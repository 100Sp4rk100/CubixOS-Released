-- importation du module de gestion d'écran
dofile("os/User Interface/GUI/Screen/Screen.lua")
-- importation du module de son
dofile("os/Process Management/playSound.lua")
-- importation du module de gestion d'applications
dofile("os/Process Management/launchApplication.lua")
-- importation du module de gestion des donnees systeme
dofile("os/File System Management/Data System Management/Data System Management.lua")
-- importation du module de gestion de chaine de caracteres
dofile("os/File System Management/String Gestion/String Gestion.lua")

-- fonction pour les boutons
function closeApp()

    breakApp = false
    changeSystemVar("soundPlayer", "false")
    isPlay = false
    changeSystemVar("soundPlayer2", "false")
    window:erase()
    window:freeze()

end

function play()

    while getSystemVar("soundPlayer2") == "true" do
        
        if getSystemVar("soundPlayer") == "true" then
            
            playAudioFile(soundPath, "soundPlayer")
            changeSystemVar("soundPlayer", "false")
            isPlay = false
        
        end

        sleep(0.1)

    end

end

function playSoundFunc()
    
    if soundPath ~= nil then

            if isPlay then
                
                changeSystemVar("soundPlayer", "false")
                isPlay = false
            
            else

                changeSystemVar("soundPlayer", "true")
                isPlay = true

            end

    end

end

function open()

    closeApp()

    runApplication("fileExplorer", "fileExplorer", {defaltPath})

end

-- fonction principale
function init()

    window = Screen:new()
    window:erase()
    window:addRectangle(0, 0, 51, 19, "white", 0)
    window:showRectangle(0)

    -- ajout du code apres l'initialisation
    window:addButton(1, 1, 1, 12, 3, "lightBlue", "Play/ Stop", 1, 1, "black", playSoundFunc)
    window:showButton(1)
    window:addButton(2, 17, 1, 23, 3, "blue", "Open", 1, 1, "black", open)
    window:showButton(2)

    window:addText(1, 19, soundPath, "red", "white", 0)
    window:showText(0)

    window:addText(8, 10, "It can take a bit time to stop sound.", "red", "white", 1)
    window:showText(1)

    window:addButton(0, 49, 0, 51, 2, "red", "X", 1, 2, "black", closeApp)
    window:showButton(0)

    updateTick()

end

function updateTick()

    while breakApp do

        window:tick()

    end

end

function soundPlayer(args)

    breakApp = true
    isPlay = false

    if getSystemVar("soundPlayer") == nil then

        addSystemVar("soundPlayer", "")

    end

    changeSystemVar("soundPlayer", "false")

    if getSystemVar("soundPlayer2") == nil then

        addSystemVar("soundPlayer2", "")

    end

    changeSystemVar("soundPlayer2", "true")

    if args[1] ~= nil then

        soundPath = args[1]
        lst = split(soundPath, "/")
        table.remove(lst, #lst)
        defaltPath = ""
        for _, element in ipairs(lst) do
            
            defaltPath = defaltPath .. element .. "/"

        end
        
    else

        soundPath = nil
        defaltPath = "os/Home"
    
    end

    parallel.waitForAll(init, play)

end