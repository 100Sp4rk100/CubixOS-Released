-- importation du module de gestion d'écran
dofile("os/User Interface/GUI/Screen/Screen.lua")
-- importation du module de gestion cles
dofile("os/Security Management/KeyGestion/KeyGestion.lua")
-- importation du module de cryptologie
dofile("os/Security Management/Encryptor/Encryptor.lua")
-- importation du module de gestion de fichier
dofile("os/File System Management/File Gestion/File Gestion.lua")

-- fonction pour les boutons
function closeApp()

    breakApp = false

end

function regenerateKeys()

    local varLst = readFile("os/OS Data/Var/SystemVar.sys")

    local key = getSystemKey("varkey")

    local newKey = generateRandomKey(30)

    local var = {}

    for _, line in ipairs(varLst) do

        table.insert(var, encrypt(uncrypt(line, key), newKey))

    end

    changeData("os/OS Data/Var/SystemVar.sys", var)
    changeSystemKey("varkey", newKey)

    varLst = getSystemData("ApplicationList", getSystemKey("ApplicationList"))

    local newKey = generateRandomKey(100)

    local var = {}

    for _, line in ipairs(varLst) do

        table.insert(var, encrypt(line, newKey))

    end

    changeData("os/OS Data/Data/ApplicationList.sys", var)
    changeSystemKey("ApplicationList", newKey)

    varLst = getSystemData("Login", getSystemKey("Password"))

    local newKey = generateRandomKey(100)

    local var = {}

    for _, line in ipairs(varLst) do

        table.insert(var, encrypt(line, newKey))

    end

    changeData("os/OS Data/Data/Login.sys", var)
    changeSystemKey("Password", newKey)

end

function rebootC()

    os.reboot()

end

function staticIp()

    if INTERNET:ipStaticBoolean() then

        INTERNET:removeIpStatic()
        window:addText(1, 19, "Your ip : " .. INTERNET:getIp(), "blue", "white", 0)
        window:showText(0)

    else

        INTERNET:setIpStatic()

    end

    if INTERNET:ipStaticBoolean() then

        window:addButton(3, 1, 3, 9, 3, "green", "Ip Static", 0, 0, "black", staticIp)

    else

        window:addButton(3, 1, 3, 9, 3, "red", "Ip Static", 0, 0, "black", staticIp)

    end
    window:showButton(3)

end

function domainIPset()
    INTERNET:removeIpStatic()

    local protocol = "default"
    if window:getInputValue(1) ~= "" then
        protocol = window:getInputValue(1)
    end
    
    local crypt = "default"
    if window:getInputValue(2) ~= "" then
        crypt = window:getInputValue(2)
    end

    local altIP = window:getInputValue(3)
    local domainIp = window:getInputValue(0)

    changeSystemVar("crypt-ip", crypt)
    changeSystemVar("protocol-ip", protocol)
    changeSystemVar("ALT-IP", altIP)
    changeSystemVar("domain-ip", domainIp)

    INTERNET = InternetProtocol:new(protocol, domainIp, crypt, altIP)
    window:addText(1, 19, "Your ip : " .. INTERNET:getIp(), "blue", "white", 0)
    window:showText(0)

end

-- fonction principale
function init()

    window = Screen:new()
    window:erase()
    window:addRectangle(0, 0, 51, 19, "white", 0)
    window:showRectangle(0)

    -- ajout du code apres l'initialisation
    window:addButton(1, 1, 1, 24, 1, "red", "Regenerate Security Keys", 0, 0, "black", regenerateKeys)
    window:showButton(1)
    -- reboot
    window:addButton(2, 1, 2, 6, 2, "blue", "Reboot", 0, 0, "black", rebootC)
    window:showButton(2)
    -- static ip
    if INTERNET:ipStaticBoolean() then

        window:addButton(3, 1, 3, 9, 3, "green", "Ip Static", 0, 0, "black", staticIp)

    else

        window:addButton(3, 1, 3, 9, 3, "red", "Ip Static", 0, 0, "black", staticIp)

    end
    window:showButton(3)

    --domain ip
    window:addInput(0, 1, 4, 9, 4, "lime", "Domain IP", 0, 0, "black", "")
    window:showInput(0)
    window:addInput(1, 1, 5, 9, 5, "lime", "Protocol", 0, 0, "black", "")
    window:showInput(1)
    window:addInput(2, 1, 6, 9, 6, "lime", "Crypt", 2, 0, "black", "")
    window:showInput(2)
    window:addInput(3, 1, 7, 9, 7, "lime", "Alt IP", 1, 0, "black", "")
    window:showInput(3)

    window:addButton(4, 10, 4, 13, 7, "blue", "Ok", 1, 2, "black", domainIPset)
    window:showButton(4)

    -- show ip
    window:addText(1, 19, "Your ip : " .. INTERNET:getIp(), "blue", "white", 0)
    window:showText(0)

end

function updateTick()

    while breakApp do

        window:tick()

    end

end

function osSettings()

    breakApp = true

    init()

    window:addButton(0, 49, 0, 51, 2, "red", "X", 1, 2, "black", closeApp)
    window:showButton(0)

    updateTick()

    window:erase()
    window:freeze()

end