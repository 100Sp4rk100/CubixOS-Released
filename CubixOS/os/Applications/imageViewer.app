-- importation du module de gestion d'écran
dofile("os/User Interface/GUI/Screen/Screen.lua")
-- importation du module de gestion des donnees syteme
dofile("os/File System Management/Data System Management/Data System Management.lua")

-- fonction pour les boutons
function closeApp()

    breakApp = false

end

function open()

    closeApp()

    runApplication("fileExplorer", "fileExplorer", {defaltPath})

end

function clic(args)

    window:setPixel(1, args[1], args[2], getSystemVar("imageViewerCurrentColor"))

    if getSystemVar("imageViewerCurrentColor") == "00" then

        window:reload()

    end

end

function clicColor(args)

    changeSystemVar("imageViewerCurrentColor", args[1])

end

-- fonction sur les events
function r()

    window:loadImage(1)
    window:reload()

end

-- fonction principale
function init()

    if getSystemVar("imageViewerCurrentColor") == nil then

        addSystemVar("imageViewerCurrentColor", "bk")

    else

        changeSystemVar("imageViewerCurrentColor", "bk")

    end

    window = Screen:new()
    window:erase()

    -- ajout du code apres l'initialisation
    window:addImage(5, 1, "os/OS Data/App/imageViewer/fount.img", 0)
    window:showImage(0)

    window:registerKeyEvent("r", r, {})

    if imageName ~= nil then

        window:addImage(5, 1, imageName, 1)

        window:addRectangle(1, 1, 4, 19, "blue", 0)
        window:showRectangle(0)
        window:addRectangle(49, 1, 51, 19, "blue", 1)
        window:showRectangle(1)

        setupButton()

        window:showImage(1)
    
    end

end

function updateTick()

    while breakApp do

        window:tick()

    end

end

function imageViewer(args)

    breakApp = true

    if args[1] ~= nil then

        imageName = args[1]
        
    else

        imageName = nil
    
    end

    init()

    window:addButton(0, 49, 0, 51, 2, "red", "X", 1, 2, "black", closeApp)
    window:showButton(0)
    window:addButton(1, 1, 1, 4, 1, "green", "Open", 0, 0, "black", open)
    window:showButton(1)

    updateTick()

    window:erase()
    window:freeze()

end

function setupButton()

    imageSize = window:getImageSize(0)
    id = 2
    y = 1

    for i = 1, tonumber(imageSize["height"]) do

        x = 5

        for ii = 1, tonumber(imageSize["width"]) do

            window:addButton(id, x, y, x, y, "", "", 0, 0, "", clic, {{x-4, y}, {}})
            window:showButton(id)
            id = id + 1
            x = x + 1

        end

        y = y + 1

    end

    clLST = {"bk", "wh", "lb", "li", "pk", "ye", "or", "ma", "gr", "lg", "cy", "pu", "bl", "br", "gn", "rd", "00"}
    y = 5
    z = 1

    for i = 1, 8 do

        x = 2

        for ii = 1, 2 do

            window:addButton(id, x, y, x, y, getCorrespondance(clLST[z]), "", 0, 0, getCorrespondance(clLST[z]), clicColor, {{clLST[z]}, {}})
            window:showButton(id)

            x = x +1
            id = id +1
            z = z +1

        end

        y = y + 1

    end

    y = y + 1
    window:addButton(id, x-3, y, x, y, "red", "Gum", 0, 0, "black", clicColor, {{clLST[z]}, {}})
    window:showButton(id)

end