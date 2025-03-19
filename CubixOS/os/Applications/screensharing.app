-- importation du module de gestion d'écran
dofile("os/User Interface/GUI/Screen/Screen.lua")
-- importation du module de gestion des donnees systeme
dofile("os/File System Management/Data System Management/Data System Management.lua")
-- importation du module de gestion d'écran
dofile("os/User Interface/GUI/Screen/ScreenLoader.lua")

-- fonction pour les boutons
function closeApp()

    breakApp = false
    changeSystemVar("sharescreenload", "false")
    window:erase()
    window:freeze()

end

function share()

    if split(getSystemVar("sharescreenip"), ".")[2] == nil then
        
        if getSystemVar("sharescreen") == "off" then

            changeSystemVar("sharescreen", "on")

        else

            changeSystemVar("sharescreen", "off")

            local request = INTERNET:makeRequest("SCsh", "endSCreenSharingConnection", getSystemVar("sharescreenip"), "0")
            INTERNET:send(request)

        end

        window:changeTextValue(0, "Sharing screen " .. getSystemVar("sharescreen"))
        window:reload()

    end

end

function set()

    changeSystemVar("sharescreenip", window:getInputValue(0))

end

-- fonction principale
function init() 

    window = Screen:new()
    window:erase()
    window:addRectangle(0, 0, 51, 19, "white", 0)
    window:showRectangle(0)

    -- ajout du code apres l'initialisation
    window:addButton(1, 1, 1, 16, 3, "blue", "Sharing screen", 1, 1, "black", share, {{}, {}})
    window:showButton(1)
    window:addText(1, 5, "Sharing screen " .. getSystemVar("sharescreen"), "red", "white", 0)
    window:showText(0)

    window:addText(1, 19, "Your ip : " .. INTERNET:getIp(), "blue", "white", 1)
    window:showText(1)

    window:addText(18, 2, "To ip : ", "green", "white", 2)
    window:showText(2)

    if getSystemVar("sharescreenipset") == "nil" or getSystemVar("sharescreenip") == "" or getSystemVar("sharescreenip") == " " then

        window:addInput(0, 26, 2, 38, 2, "lime", "ip monitor", 0, 0, "black", "")

    else

        window:addInput(0, 26, 2, 38, 2, "lime", getSystemVar("sharescreenip"), 0, 0, "black", "")

    end
    window:showInput(0)
    window:addButton(2, 26, 3, 28, 3, "blue", "Set", 0, 0, "black", set, {{}, {}})
    window:showButton(2)

    window:addGeneralEvent("Screen Sharing", "sharing", {})

end

function updateTick()

    while breakApp do

        window:tick()

    end

end

function screensharing()

    breakApp = true

    if getSystemVar("sharescreen") == nil then

        addSystemVar("sharescreen", "off")

    end

    if getSystemVar("sharescreenipset") == nil then

        addSystemVar("sharescreenip", "nil")

    end

    changeSystemVar("sharescreenload", "false")

    init()

    window:addButton(0, 49, 0, 51, 2, "red", "X", 1, 2, "black", closeApp)
    window:showButton(0)

    updateTick()

end