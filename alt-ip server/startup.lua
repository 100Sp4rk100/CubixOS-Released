dofile("server/process/NameAdresseGestion.lua")
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

    main = NameAdresseGestion:new(protocol, crypt)

    main:enableInternet()

    local domain = readFile("server/config/domain.dat")

    print("Loading domain name of server")

    for _, line in ipairs(domain) do

        datDN = split(line, "=")

        if datDN[1] ~= nil and datDN[2] ~= nil then

            print("Adding domain name : "..datDN[2].." to the list")

            main:addDomainName(datDN[2], datDN[1])

        end

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
