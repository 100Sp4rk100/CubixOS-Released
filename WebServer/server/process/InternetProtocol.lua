-- importation du module de gestion des donnees syteme
dofile("server/system/Data System Management.lua")
-- importation du module de gestion de chaine de caracteres
dofile("server/system/String Gestion.lua")
-- importation du module de cryptologie
dofile("server/system/Encryptor.lua")

-- creation de la classe protocol internet
InternetProtocol = {}
InternetProtocol.__index = InternetProtocol

-- constructeur
function InternetProtocol:new(protocol, domainIp, crypt, altIP)

    local self = setmetatable({}, InternetProtocol)

    -- definition des variables
    if protocol == "default" then

        self.protocol = "internet"
    
    else

        self.protocol = protocol
        
    end

    self.domainIp = domainIp

    self.ip = self:generateIP()

    self.enable = false

    if crypt == "default" then

        self.crypt = "qegrfuyesqdjkqdbhusbvfcujqkloqudzogcvbsqhbfiuqezsch"
    
    else

        self.crypt = crypt
        
    end

    if altIP == "" or nil then

        self.altIP = ""
    
    else

        self.altIP = altIP
        
    end

    self.cachePacket = {}
    self.cache = {}

    self.packet = {}

    return self

end

-- methodes de la classe

-- methode de gestion general
function InternetProtocol:generateIP()

    if getSystemVar("static-ip") == "nil" then

        if self.domainIp == "" then

            local ipLst = {rednet.lookup(self.protocol)}
    
            local ipCache = math.random(100000000, 999999999)
    
            while ipLst[ipCache] ~= nil do
    
                ipCache = math.random(100000000, 999999999)
    
            end
            
            return tostring(ipCache)
    
        else
    
            local ipLst = {rednet.lookup(self.protocol)}
    
            local ipCache = math.random(100, 999)
    
            while ipLst[self.domainIp..":"..ipCache] ~= nil do
    
                ipCache = math.random(100, 999)
    
            end

            self.ipForDomain = ipCache

            return tostring(self.domainIp..":"..ipCache)
    
        end

    else

        self.ipForDomain = split(getSystemVar("static-ip"), ":")[2]

        return getSystemVar("static-ip")

    end

end

function InternetProtocol:enableInternet()

    peripheral.find("modem", rednet.open)
    rednet.host(self.protocol, self.ip)
    self.enable = true

end

function InternetProtocol:unableInternet()

    rednet.unhost(self.protocol)
    self.enable = false

end

function InternetProtocol:setIpStatic()

    changeSystemVar("static-ip", self.ip)

end

function InternetProtocol:removeIpStatic()

    changeSystemVar("static-ip", "nil")
    self.ip = self:generateIP()

end

function InternetProtocol:ipStaticBoolean()

    if getSystemVar("static-ip") == "nil" then

        return false

    else

        return true

    end

end

function InternetProtocol:internetEnableBoolean()

    return self.enable

end

function InternetProtocol:getIp()

    return self.ip

end

--methode de reçut des messages
function InternetProtocol:receive(maxDelay)

    if self.enable then

        id, msg = rednet.receive(self.protocol, maxDelay)

        if type(msg) == "string" then

            local inf = self:getInformationOfRequest(msg)
            if inf ~= nil then
                if inf["ip-end"] ~= nil then
                    local infIp = split(inf["ip-end"], ":")[2]

                    if self.domainIp == "" and inf["ip-end"] == self.ip then

                        self:receivePacket(inf)
                    
                    elseif inf["ip-sender"] == self.domainIp and self.ipForDomain == infIp then

                        self:receivePacket(inf)

                    end
                end
            end

        end    

    end

end

function InternetProtocol:receivePacket(inf)

    if self.cachePacket[inf["id"]..inf["ip-sender"]] == nil then

        self.cachePacket[inf["id"]..inf["ip-sender"]] = {}
        self.cache[inf["id"]..inf["ip-sender"]] = {}

    end
    

    if self.cache[inf["id"]..inf["ip-sender"]][inf["packet-number"]] == nil then

        table.insert(self.cachePacket[inf["id"]..inf["ip-sender"]], inf)
        table.insert(self.cache[inf["id"]..inf["ip-sender"]], inf["packet-number"])
        self:updatePacket()

    end

end

function InternetProtocol:updatePacket()

    for id, packets in pairs(self.cachePacket) do

        if #packets == tonumber(packets[1]["total-packet-number"]) then

            local lstCache = {}

            table.sort(packets, function(a, b)

                return tonumber(a["packet-number"]) < tonumber(b["packet-number"])

            end)

            for _, packetData in ipairs(packets) do

                table.insert(lstCache, packetData["packet"])

            end

            local pack = table.concat(lstCache)
            packets[1]["args"] = textutils.unserialize(packets[1]["args"]) or {}
            table.insert(self.packet, {["packet"] = pack, ["info"] = packets[1]})

            self.cachePacket[id] = nil
            self.cache[id] = nil

        end

    end

end


function InternetProtocol:getPacket()

    return self.packet

end

function InternetProtocol:deletePacket(i)

    table.remove(self.packet, i)

end

function InternetProtocol:getInformationOfRequest(request)

    if request ~= nil then

        requestSplit = split(uncrypt(request, self.crypt), "/")

        if requestSplit[2] ~= nil then

            return {["type"] = requestSplit[1] or "",
            ["packet"] = uncrypt(requestSplit[2], "eufigeqzyukfgqezhiulfqezyufgyquzef") or "",
            ["packet-number"] = requestSplit[3] or "",
            ["total-packet-number"] = requestSplit[4] or "",
            ["ip-end"] = requestSplit[5] or "",
            ["ip-sender"] = requestSplit[6] or "",
            ["id"] = uncrypt(requestSplit[7], "eufigeqzyukfgqezhiulfqezyufgyquzef") or "",
            ["crypt"] = self.crypt,
            ["protocol"] = self.protocol,
            ["args"] = uncrypt(requestSplit[8], "eufigeqzyukfgqezhiulfqezyufgyquzef") or ""
            }

        end

    end


end

--methode d'envoie des messages
function InternetProtocol:send(requestLst)

    for _, request in ipairs(requestLst) do

        rednet.broadcast(request, self.protocol)

    end

end

function InternetProtocol:makeRequest(type, packetToSend, ipEnd, id, args)

    lst = {}
    packetLst = {}

    if args == nil then
        args = {""}
    end

    x = 1
    y = 20

    if y > #packetToSend then

        table.insert(packetLst, packetToSend)
    
    else

        while y <= #packetToSend do

            table.insert(packetLst, extractChar(packetToSend, x, y))
            x = x + 20
            y = y + 20
        
        end

        table.insert(packetLst, extractChar(packetToSend, x, y))

    end

    for i, packet in ipairs(packetLst) do

        if self.domainIp ~= "" then

            argsLSt = args
            argsLSt["!/!type!/!"] = type
            argsLSt["!/!ipEnd!/!"] = ipEnd
            argsLSt["$alt-ip$"] = self.altIP
            table.insert(lst, encrypt( "trans" .. "/" .. encrypt(packet, "eufigeqzyukfgqezhiulfqezyufgyquzef") .. "/" .. i .. "/" .. #packetLst .. "/" .. self.ip .. "/" .. self.ip .. "/" .. encrypt(id, "eufigeqzyukfgqezhiulfqezyufgyquzef").."/"..encrypt(textutils.serialize(argsLSt), "eufigeqzyukfgqezhiulfqezyufgyquzef"), self.crypt))
        
        else
            argsLSt = args
            argsLSt["$ip-sender$"] = self.ip
            argsLSt["$alt-ip$"] = self.altIP
            table.insert(lst, encrypt( type .. "/" .. encrypt(packet, "eufigeqzyukfgqezhiulfqezyufgyquzef") .. "/" .. i .. "/" .. #packetLst .. "/" .. ipEnd .. "/" .. self.ip .. "/" .. encrypt(id, "eufigeqzyukfgqezhiulfqezyufgyquzef").."/"..encrypt(textutils.serialize(argsLSt), "eufigeqzyukfgqezhiulfqezyufgyquzef"), self.crypt))

        end

    end

    return lst

end