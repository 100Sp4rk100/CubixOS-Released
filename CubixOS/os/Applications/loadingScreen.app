-- importation du module de gestion d'écran
dofile("os/User Interface/GUI/Screen/Screen.lua")
-- importation du module de gestion des donnees systeme
dofile("os/File System Management/Data System Management/Data System Management.lua")
-- importation du module de gestion d'écran
dofile("os/User Interface/GUI/Screen/ScreenLoader.lua")

-- fonction pour les boutons
function closeApp()

    breakApp = false
    changeSystemVar("sharescreenOpen", "false")
    changeSystemVar("sharescreenload", "false")
    window:erase()
    window:freeze()

end

function loadScreen()

    local function findMonitorSide() 

        local sides = {"left", "right", "top", "bottom", "front", "back"} 

        for _, side in ipairs(sides) do 

            if peripheral.isPresent(side) and peripheral.getType(side) == "monitor" then 

                return side 
            
            end 
        
        end 
        
        return nil

    end

    INTERNET:enableInternet()
    windowsLoad = ScreenLoader:new()
    packet = ""
    
    local monitorSide = findMonitorSide()

    if monitorSide ~= nil then

        local monitor = peripheral.wrap(monitorSide)
        if monitor ~= nil then

            term.redirect(monitor)

        end

    end

    while packet ~= "endSCreenSharingConnection" or stop do

        INTERNET:receive()
        
        packets = INTERNET:getPacket()
        packet = packets[1]

        if packet ~= nil then
            if packet["packet"] ~= "endSCreenSharingConnection" then
                addTextInFile("cache", packet["packet"])
                windowsLoad:displayFromString(packet["packet"])
                INTERNET:deletePacket(1)
            end

            if packet["packet"] == "endSCreenSharingConnection" then
            
                stop = false
    
            end

        end

    end

end

function BTNload()

    if getSystemVar("sharescreenload") == "true" then

        changeSystemVar("sharescreenload", "false")
        window:changeTextValue(3, "Loading Screen : " .. getSystemVar("sharescreenload"))
        window:reload()

    else

        changeSystemVar("sharescreenload", "true")
        window:changeTextValue(3, "Loading Screen : " .. getSystemVar("sharescreenload"))
        window:reload()
        loadScreen()
        term.redirect(term.native())
        changeSystemVar("sharescreenload", "false")
        window:changeTextValue(3, "Loading Screen : " .. getSystemVar("sharescreenload"))
        window:reload()

    end

end

-- fonction principale
function init() 

    window = Screen:new()
    window:erase()
    window:addRectangle(0, 0, 51, 19, "white", 0)
    window:showRectangle(0)

    -- ajout du code apres l'initialisation
    window:addText(1, 19, "Your ip : " .. INTERNET:getIp(), "blue", "white", 1)
    window:showText(1)

    window:addButton(3, 1, 8, 14, 10, "blue", "Load screen", 1, 1, "black", BTNload, {{}, {}})
    window:showButton(3)

    window:addText(1, 12, "Loading Screen : " .. getSystemVar("sharescreenload"), "red", "white", 3)
    window:showText(3)

    window:addButton(2, 1, 1, 14, 3, "blue", "On screen", 2, 1, "black", share, {{}, {}})
    window:showButton(2)

    window:addGeneralEvent("Screen Sharing", "sharing", {})
    window:registerKeyEvent("l", BTNload, {})

end

function updateTick()

    while breakApp do

        window:tick()

    end

end

function loadingScreen()

    breakApp = true
    stop = true

    if getSystemVar("sharescreen") == nil then

        addSystemVar("sharescreen", "off")

    end

    if getSystemVar("sharescreenload") == nil then

        addSystemVar("sharescreenload", "false")

    end

    if getSystemVar("sharescreenOpen") == nil then

        addSystemVar("sharescreenOpen", "")

    end

    if getSystemVar("sharescreenipset") == nil then

        addSystemVar("sharescreenip", "nil")

    end

    changeSystemVar("sharescreenload", "false")
    changeSystemVar("sharescreenOpen", "true")

    init()

    window:addButton(0, 49, 0, 51, 2, "purple", "X", 1, 2, "black", closeApp)
    window:showButton(0)

    updateTick()

end