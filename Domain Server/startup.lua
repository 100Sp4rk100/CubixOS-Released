dofile("server/process/DomainGestionProtocol.lua")
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
    if getDataValue(conf, "crypt") ~= nil then
        crypt = getDataValue(conf, "crypt")
    else
        crypt = "default"
    end

    main = DomainGestionProtocol:new(protocol, crypt, readFile("server/config/blacklist.dat"), readFile("server/config/whitelist.dat"))

    print("Connected with ip : "..main:getIp())

    if not main:ipStaticBoolean() then
        main:setIpStatic()
    end

    main:enableInternet()

    local devices = readFile("server/config/devices.dat")

    print("Loading devices of domain")

    for _, line in ipairs(devices) do

        print("Adding domain ip : "..line.." to the list")

        main:addDevice(line)

    end

    print("Starting the server")

    while true do

        main:receive()

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
