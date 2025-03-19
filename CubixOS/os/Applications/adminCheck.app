-- importation du module de gestion d'écran
dofile("os/User Interface/GUI/Screen/Screen.lua")
-- importation du module de gestion de données système
dofile("os/File System Management/Data System Management/Data System Management.lua")
-- importation du module de gestion des clefs
dofile("os/Security Management/KeyGestion/KeyGestion.lua")
-- importation du module de gestion de chaine de caracteres
dofile("os/File System Management/String Gestion/String Gestion.lua")
-- importation du module de son
dofile("os/Process Management/playSound.lua")

-- fonction pour les boutons
function closeApp()

    breakApp = false

end

function check()

    if split(getSystemData("Login", getSystemKey("Password"))[2], ":::")[2] == window:getInputValue(0) then

        if action ~= nil then

            action()
            closeApp()

        else

            closeApp()

        end

    else

        window:addText(14, 14, "Admin Password Incorrect", "red", "lightGray", 0)
        window:showText(0)
        playAudioFile("os/OS Data/Sounds/error-warning-login-denied.dfpwm")

    end

end

-- fonction principale
function init()

    window = Screen:new()

    window:erase()

    window:addRectangle(14, 7, 37, 14, "lightGray", 0)
    window:showRectangle(0)

    -- ajout du code apres l'initialisation
    window:addInput(0, 17, 8, 34, 10, "yellow", "Admin password", 2, 1, "black", "*")
    window:showInput(0)
    window:addButton(1, 24, 12, 27, 13, "blue", "OK", 1, 1, "black", check)
    window:showButton(1)

    window:addButton(0, 35, 7, 37, 8, "red", "X", 1, 1, "black", closeApp)
    window:showButton(0)

    updateTick()

end

function updateTick()

    while breakApp do

        window:tick()

    end

end

function soundWelcome()

    playAudioFile("os/OS Data/Sounds/message-alert.dfpwm")

end

function adminCheck(args)

    action = args[1]

    breakApp = true

    parallel.waitForAll(init, soundWelcome)

    window:erase()
    window:freeze()

end