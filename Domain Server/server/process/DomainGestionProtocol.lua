-- importation du module de gestion des donnees syteme
dofile("server/system/Data System Management.lua")
-- importation du module de gestion de chaine de caracteres
dofile("server/system/String Gestion.lua")
-- importation du module de cryptologie
dofile("server/system/Encryptor.lua")
-- importation du module de gestion des listes
dofile("server/system/List Gestion.lua")

-- creation de la classe protocol internet
DomainGestionProtocol = {}
DomainGestionProtocol.__index = DomainGestionProtocol

-- constructeur
function DomainGestionProtocol:new(protocol, crypt, black, white)

    local self = setmetatable({}, DomainGestionProtocol)

    -- definition des variables
    if protocol == "default" then

        self.protocol = "internet"
    
    else

        self.protocol = protocol
        
    end

    self.ip = self:generateIP()

    self.enable = false

    if crypt == "default" then

        self.crypt = "qegrfuyesqdjkqdbhusbvfcujqkloqudzogcvbsqhbfiuqezsch"
    
    else

        self.crypt = crypt
        
    end

    self.devices = {}

    self.blackLST = black
    self.whiteLST = white

    return self

end

-- methodes de la classe

-- methode de gestion general
function DomainGestionProtocol:generateIP()

    if getSystemVar("static-ip") == "nil" then

        local ipLst = {rednet.lookup(self.protocol)}

        local ipCache = math.random(100000000, 999999999)

        while ipLst[ipCache] ~= nil do

            ipCache = math.random(100000000, 999999999)

        end
        
        return tostring(ipCache)

    else

        return getSystemVar("static-ip")

    end

end

function DomainGestionProtocol:enableInternet()

    peripheral.find("modem", rednet.open)
    rednet.host(self.protocol, self.ip)
    self.enable = true

end

function DomainGestionProtocol:unableInternet()

    rednet.unhost(self.protocol)
    self.enable = false

end

function DomainGestionProtocol:setIpStatic()

    changeSystemVar("static-ip", self.ip)

end

function DomainGestionProtocol:removeIpStatic()

    changeSystemVar("static-ip", "nil")
    self.ip = self:generateIP()

end

function DomainGestionProtocol:getIp()

    return self.ip

end

function DomainGestionProtocol:ipStaticBoolean()

    if getSystemVar("static-ip") == "nil" then

        return false

    else

        return true

    end

end

function DomainGestionProtocol:internetEnableBoolean()

    return self.enable

end

function DomainGestionProtocol:addDevice(ip)

    if not listContains(self.devices, ip) then

        table.insert(self.devices, ip)

    else

        return "error"

    end

end

--methode de reçut des messages
function DomainGestionProtocol:receive(maxDelay)

    if self.enable then

        id, msg = rednet.receive(self.protocol, maxDelay)

        if type(msg) == "string" then

            local inf = self:getInformationOfRequest(msg)
            if inf ~= nil then
                if inf["ip-end"] ~= nil then

                    local infIp = split(inf["ip-end"], ":")
                    local reqArgs = textutils.unserialize(inf["args"])

                    if listContains(self.devices, infIp[2]) and infIp[1] == self.ip then

                        if inf["type"] == "trans" then

                            if inf["packet"] ~= nil then

                                if listContains(self.whiteLST, reqArgs["!/!ipEnd!/!"]) or #self.whiteLST == 0 then

                                    if not listContains(self.blackLST, reqArgs["!/!ipEnd!/!"]) or #self.blackLST == 0 then

                                        self:send({encrypt( reqArgs["!/!type!/!"] .. "/" .. encrypt(inf["packet"], "eufigeqzyukfgqezhiulfqezyufgyquzef") .. "/" .. inf["packet-number"] .. "/" .. inf["total-packet-number"] .. "/" .. reqArgs["!/!ipEnd!/!"] .. "/" .. inf["ip-sender"] .. "/" .. encrypt(inf["id"], "eufigeqzyukfgqezhiulfqezyufgyquzef").."/"..encrypt(textutils.serialize(reqArgs), "eufigeqzyukfgqezhiulfqezyufgyquzef"), self.crypt)})
                                    else
                                        print(reqArgs["!/!ipEnd!/!"].." is in black list")
                                    end
                                else
                                    print(reqArgs["!/!ipEnd!/!"].." not in white list")
                                end

                            end

                        else
                            if listContains(self.whiteLST, inf["ip-sender"]) or #self.whiteLST == 0 then
                                if not listContains(self.blackLST, inf["ip-sender"]) or #self.blackLST == 0 then
                                    self:send({encrypt( inf["type"] .. "/" .. encrypt(inf["packet"], "eufigeqzyukfgqezhiulfqezyufgyquzef") .. "/" .. inf["packet-number"] .. "/" .. inf["total-packet-number"] .. "/" .. inf["ip-end"] .. "/" .. self.ip .. "/" .. encrypt(inf["id"], "eufigeqzyukfgqezhiulfqezyufgyquzef").."/"..encrypt(textutils.serialize(reqArgs), "eufigeqzyukfgqezhiulfqezyufgyquzef"), self.crypt)})
                                else
                                    print(inf["ip-sender"].." is in black list")
                                end
                            else
                                print(inf["ip-sender"].." not in white list")
                            end

                        end
                    
                    end

                end
            end

        end    

    end

end

function DomainGestionProtocol:getInformationOfRequest(request)

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
function DomainGestionProtocol:send(requestLst)

    for _, request in ipairs(requestLst) do

        rednet.broadcast(request, self.protocol)

    end

end

function DomainGestionProtocol:makeRequest(type, packetToSend, ipEnd, id, args)

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

        table.insert(lst, encrypt( type .. "/" .. encrypt(packet, "eufigeqzyukfgqezhiulfqezyufgyquzef") .. "/" .. i .. "/" .. #packetLst .. "/" .. ipEnd .. "/" .. self.ip .. "/" .. id.."/"..textutils.serialize(args), self.crypt))

    end

    return lst

end