-- importation du module de gestion d'écran
dofile("os/User Interface/GUI/Screen/Screen.lua")
-- importation du module de gestion de chaine de caracteres
dofile("os/File System Management/String Gestion/String Gestion.lua")
-- importation du module de son
dofile("os/Process Management/playSound.lua")

-- fonction pour les boutons
function closeApp()

    breakApp = false

end

-- fonction principale
function init()

    window = Screen:new()

    window:erase()

    window:addRectangle(14, 7, 37, 14, "lightGray", 0)
    window:showRectangle(0)

    -- ajout du code apres l'initialisation
    window:addButton(1, 24, 14, 27, 14, "green", "OK", 1, 0, "black", closeApp)
    window:showButton(1)

    for i=1, 7 do

        str = extractChar(msg, 22*(i-1)+1, 22*i)

        if str == nil then

            str = ""

        end

        window:addText(15, 6+i, str, "black", "lightGray", i)
        window:showText(i)

    end

    updateTick()

end

function updateTick()

    while breakApp do

        window:tick()

    end

end

function soundWelcome()

    playAudioFile(sound)

end

function popup(args)

    msg = args[1]

    if msg == nil then

        msg = ""

    end
    
    if args[2] ~= nil then

        sound = args[2]

    else

        sound = "os/OS Data/Sounds/message-alert.dfpwm"

    end

    breakApp = true

    parallel.waitForAll(init, soundWelcome)

    window:erase()
    window:freeze()

end