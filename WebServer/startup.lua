dofile("server/process/InternetProtocol.lua")
dofile("server/system/Data System Management.lua")
dofile("server/libs/Global.lib")
dofile("server/system/File Gestion.lua")

function start()
    if not peripheral.find("modem") then

        error("Server need a modem.")

    end

    term.clear()
    term.setCursorPos(1, 1)

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
    if getDataValue(conf, "altIP") ~= nil then
        altIP = getDataValue(conf, "altIP")
    else
        altIP = ""
    end

    main = InternetProtocol:new(protocol, domainIp, crypt, altIP)

    print("Connected with ip : "..main:getIp(), altIP)

    if not main:ipStaticBoolean() then
        main:setIpStatic()
    end

    main:enableInternet()

    print("Starting the server")

    while true do

        main:receive()

        local packets = main:getPacket()

        for i, packet in ipairs(packets) do

            if not global(packet, main) then

                addTextInFile("server/logs/"..packet["info"]["ip-sender"]..".log", textutils.serialize(packet["info"]))
                print("ERROR : gestion of packet => IP : "..packet["info"]["ip-sender"])

            else

                main:deletePacket(i)

            end

        end

    end

end

while true do
    local success, err = pcall(start)

    if not success then
        print(err)
        sleep(1)
        os.reboot()
    end
end
