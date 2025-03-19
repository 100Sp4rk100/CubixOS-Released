-- importation du module de gestion d'applications
dofile("os/Process Management/launchApplication.lua")

-- importation du module de gestion d'ecran
dofile("os/User Interface/GUI/Screen/Screen.lua")

-- importation du module de gestion des donnees systeme
dofile("os/File System Management/Data System Management/Data System Management.lua")

-- importation du module de gestion des clefs
dofile("os/Security Management/KeyGestion/KeyGestion.lua")

-- importation du module de gestion de chaine de caracteres
dofile("os/File System Management/String Gestion/String Gestion.lua")

-- importation du module de gestion de listes
dofile("os/File System Management/List/List Gestion.lua")

-- importation du module de son
dofile("os/Process Management/playSound.lua")

-- importation du module de gestion internet
dofile("os/Network Management/InternetProtocol.lua")

function init()

    print("Starting Cubix-OS")

    local domain = ""
    if getSystemVar("domain-ip") ~= nil then
        if getSystemVar("domain-ip") ~= "" then
            domain = getSystemVar("domain-ip")
        end
    end
    local alt = ""
    if getSystemVar("ALT-IP") ~= notLogin then
        if getSystemVar("ALT-IP") ~= "" then
            alt = getSystemVar("ALT-IP")
        end
    end

    INTERNET = InternetProtocol:new(getSystemVar("protocol-ip"), domain, getSystemVar("crypt-ip"), alt)

    print("INTERNET PARAMS : ", getSystemVar("protocol-ip"), domain, getSystemVar("crypt-ip"), alt)

    sleep(2)

    notLogin = true
    try = 1

    passwd = Screen:new()
    passwd:erase()

    passwd:addInput(0, 17, 9, 37, 12, "yellow", "Password", 7, 1, "black", "*")
    passwd:addButton(0, 20, 15, 34, 17, "yellow", "Connection", 2, 1, "black", login)
    passwd:addImage(1, 1, "os/OS Data/Image/Cubix.img", 0)
    passwd:showInput(0)
    passwd:showButton(0)
    passwd:showImage(0)

    updateLoginTick()

end

function updateLoginTick()
    while notLogin do

        passwd:tick()

    end

end

function login()

    key = getSystemKey("Password")
    password = split(getSystemData("Login", key)[1], ":::")[2]
    if password == passwd:getInputValue(0) then

        notLogin = false
        passwd:erase()
        passwd:hideInput(0)
        passwd:hideButton(0)
        passwd:freeze()
        deskop()

    else

        if try ~= tonumber(getSystemVar("logintry")) then

            passwd:addText(19, 13, "Password invalid !", "red", getSystemVar("screencolor"), 0)
            passwd:showText(0)
            try = try + 1

            if try ~= tonumber(getSystemVar("logintry")) then

                playAudioFile("os/OS Data/Sounds/error-warning-login-denied.dfpwm")

            end
        
        else

            passwd:addText(19, 14, "Wait few secounds", "red", getSystemVar("screencolor"), 1)
            passwd:showText(1)
            playAudioFile("os/OS Data/Sounds/error.dfpwm")
            sleep(math.random(1, 10))
            try = 1
            passwd:hideText(0)
            passwd:hideText(1)

        end

    end

end

function deskop()

    --fonction pour les boutons
    function fileExplorerLaunch()

        deskop:hideInput(0)
        deskop:hideButton(1)
        deskop:hideText(0)
        deskop:hideImage(0)
        deskop:freeze()

        runApplication("fileExplorer", "fileExplorer")

        deskop:unfreeze()
        deskop:showImage(0)
        deskop:reload()
        logoShow= false

    end

    function textViewerLaunch()

        deskop:hideInput(0)
        deskop:hideButton(1)
        deskop:hideText(0)
        deskop:hideImage(0)
        deskop:freeze()

        runApplication("textViewer", "textViewer")

        deskop:unfreeze()
        deskop:showImage(0)
        deskop:reload()
        logoShow= false

    end

    function imageViewerLaunch()

        deskop:hideInput(0)
        deskop:hideButton(1)
        deskop:hideText(0)
        deskop:hideImage(0)
        deskop:freeze()

        runApplication("imageViewer", "imageViewer")

        deskop:unfreeze()
        deskop:showImage(0)
        deskop:reload()
        logoShow= false

    end

    function soundPlayerLaunch()

        deskop:hideInput(0)
        deskop:hideButton(1)
        deskop:hideText(0)
        deskop:hideImage(0)
        deskop:freeze()

        runApplication("soundPlayer", "soundPlayer")

        deskop:unfreeze()
        deskop:showImage(0)
        deskop:reload()
        logoShow= false

    end

    -- fonctions principales
    function initDeskop()

        playAudioFile("os/OS Data/Sounds/login.dfpwm")

        ApplicationList = getSystemData("ApplicationList", getSystemKey("ApplicationList"))
        ApplicationNameList = {}

        for _, v in ipairs(ApplicationList) do

            table.insert(ApplicationNameList, split(v, ":")[1])

        end
        

        deskop = Screen:new()
        deskop:addButton(0, 1, 1, 8, 8, getSystemVar("screencolor"), "", 0, 0, getSystemVar("screencolor"), logo)
        deskop:addImage(1, 1, "os/OS Data/Image/Cubix.img", 0)

        deskop:addInput(0, 17, 9, 37, 12, "yellow", "Application", 5, 1, "black", "")
        deskop:addButton(1, 20, 15, 34, 17, "yellow", "Search", 5, 1, "black", researchApp)

        deskop:showButton(0)
        deskop:showImage(0)

        deskop:addButton(2, 1, 10, 5, 13, getSystemVar("screencolor"), "", 0, 0, getSystemVar("screencolor"), fileExplorerLaunch)
        deskop:addImage(1, 10, getImgPath("fileExplorer"), 1)
        deskop:showButton(2)
        deskop:showImage(1)

        deskop:addButton(3, 1, 14, 5, 17, getSystemVar("screencolor"), "", 0, 0, getSystemVar("screencolor"), textViewerLaunch)
        deskop:addImage(1, 14, getImgPath("textViewer"), 2)
        deskop:showButton(3)
        deskop:showImage(2)

        deskop:addButton(4, 7, 10, 12, 13, getSystemVar("screencolor"), "", 0, 0, getSystemVar("screencolor"), imageViewerLaunch)
        deskop:addImage(7, 10, getImgPath("imageViewer"), 3)
        deskop:showButton(4)
        deskop:showImage(3)

        deskop:addButton(5, 7, 14, 12, 17, getSystemVar("screencolor"), "", 0, 0, getSystemVar("screencolor"), soundPlayerLaunch)
        deskop:addImage(7, 14, getImgPath("soundPlayer"), 4)
        deskop:showButton(5)
        deskop:showImage(4)

        logoShow = false

        updateDeskopTick()

    end

    function getImgPath(nameApp)

        if fileExists("os/OS Data/App/"..nameApp.."/"..nameApp..".dat") then

            content = getData("os/OS Data/App/"..nameApp.."/"..nameApp..".dat")

            imagePath = getDataValue(content, "logo")
        
        else

            imagePath = imagePath .. "FileApp.img"

        end

        return imagePath

    end

    function updateDeskopTick()

        while true do

            deskop:tick()

        end

    end

    function logo()

        if logoShow then

            deskop:hideInput(0)
            deskop:hideButton(1)
            deskop:hideText(0)
            logoShow = false

        else

            deskop:showInput(0)
            deskop:showButton(1)
            logoShow = true

        end

    end

    function researchApp()

        deskop:addText(15, 13, "", "red", getSystemVar("screencolor"), 0)

        if listContains(ApplicationNameList, deskop:getInputValue(0)) then

            for _, v in ipairs(ApplicationList) do

                if split(v, ":")[1] ==  deskop:getInputValue(0)then
                    
                    app = split(v, ":")[2]

                end

            end
            
            deskop:hideInput(0)
            deskop:hideButton(1)
            deskop:hideText(0)
            deskop:hideImage(0)
            deskop:freeze()

            runApplication(app, app)

            deskop:unfreeze()
            deskop:showImage(0)
            deskop:reload()
            logoShow= false

        else

            deskop:changeTextValue(0, "Application doesn't exist !")
            deskop:showText(0)
            playAudioFile("os/OS Data/Sounds/error-warning-login-denied.dfpwm")

        end

    end

    initDeskop()

end