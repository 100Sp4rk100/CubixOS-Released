local conf = getData("server/config/config.dat")
if getDataValue(conf, "protocol") ~= nil then
    protocol = getDataValue(conf, "protocol")
else
    protocol = "default"
end
if getDataValue(conf, "domainIp") ~= nil then
    domainIp = getDataValue(conf, "domainIp")
else
    domainIp = ""
end
if getDataValue(conf, "crypt") ~= nil then
    crypt = getDataValue(conf, "crypt")
else
    crypt = "default"
end

main = InternetProtocol:new(protocol, domainIp, crypt)

main:removeIpStatic()
main:setIpStatic()

print("New ip : "..main:getIp())