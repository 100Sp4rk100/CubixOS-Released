-- importation du module de gestion des donnees syteme
dofile("server/system/Data System Management.lua")
-- importation du module de gestion de chaine de caracteres
dofile("server/system/String Gestion.lua")
-- importation du module de cryptologie
dofile("server/system/Encryptor.lua")

-- creation de la classe protocol internet
NameAdresseGestion = {}
NameAdresseGestion.__index = NameAdresseGestion

-- constructeur
function NameAdresseGestion:new(protocol, crypt)

    local self = setmetatable({}, NameAdresseGestion)

    -- definition des variables
    if protocol == "default" then

        self.protocol = "internet"
    
    else

        self.protocol = protocol
        
    end

    self.enable = false

    if crypt == "default" then

        self.crypt = "qegrfuyesqdjkqdbhusbvfcujqkloqudzogcvbsqhbfiuqezsch"
    
    else

        self.crypt = crypt
        
    end

    self.domains = {}

    return self

end

-- methodes de la classe

-- methode de gestion general
function NameAdresseGestion:enableInternet()

    peripheral.find("modem", rednet.open)
    self.enable = true

end

function NameAdresseGestion:unableInternet()

    self.enable = false

end

function NameAdresseGestion:addDomainName(name, ip)

    self.domains[name] = ip

end

--methode de reçut des messages
function NameAdresseGestion:receive(maxDelay)

    if self.enable then

        id, msg = rednet.receive(self.protocol, maxDelay)

        if type(msg) == "string" then

            local inf = self:getInformationOfRequest(msg)
            if inf ~= nil then
                if inf["ip-end"] ~= nil then

                    if #split(inf["ip-end"], ".") ~= 1 and self.domains[inf["ip-end"]] ~= nil then

                        self:send({encrypt( inf["type"] .. "/" .. encrypt(inf["packet"], "eufigeqzyukfgqezhiulfqezyufgyquzef") .. "/" .. inf["packet-number"] .. "/" .. inf["total-packet-number"] .. "/" .. self.domains[inf["ip-end"]] .. "/" .. inf["ip-sender"] .. "/" .. inf["id"].."/"..inf["args"], self.crypt)})

                    end
                end
            end

        end    

    end

end

function NameAdresseGestion:getInformationOfRequest(request)

    if request ~= nil then

        requestSplit = split(uncrypt(request, self.crypt), "/")

        if requestSplit[2] ~= nil then

            return {["type"] = requestSplit[1] or "",
            ["packet"] = uncrypt(requestSplit[2], "eufigeqzyukfgqezhiulfqezyufgyquzef") or "",
            ["packet-number"] = requestSplit[3] or "",
            ["total-packet-number"] = requestSplit[4] or "",
            ["ip-end"] = requestSplit[5] or "",
            ["ip-sender"] = requestSplit[6] or "",
            ["id"] = requestSplit[7] or "",
            ["crypt"] = self.crypt,
            ["protocol"] = self.protocol,
            ["args"] = requestSplit[8] or ""
            }

        end

    end


end

--methode d'envoie des messages
function NameAdresseGestion:send(requestLst)

    for _, request in ipairs(requestLst) do

        rednet.broadcast(request, self.protocol)

    end

end

function NameAdresseGestion:makeRequest(type, packetToSend, ipEnd, ipSender, id, args)

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

        table.insert(lst, encrypt( type .. "/" .. encrypt(packet, "eufigeqzyukfgqezhiulfqezyufgyquzef") .. "/" .. i .. "/" .. #packetLst .. "/" .. ipEnd .. "/" .. ipSender .. "/" .. id.."/"..textutils.serialize(args), self.crypt))

    end

    return lst

end