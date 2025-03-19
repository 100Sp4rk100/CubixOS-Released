-- importation du module de gestion d'écran
dofile("os/User Interface/GUI/Screen/Screen.lua")
-- importation du module de gestion de fichier
dofile("os/File System Management/File Gestion/File Gestion.lua")

-- fonction pour les boutons
function closeApp()

    breakApp = false

end

function rightChunk()

    if chunkNumber + 1 <= #chunkLst and filePath ~= nil then

        chunkNumber = chunkNumber +1

        file = readFile(filePath)
        showContent()
    
        window:reload()

    end

end

function leftChunk()

    if chunkNumber - 1 >= 1 and filePath ~= nil then

        chunkNumber = chunkNumber -1

        file = readFile(filePath)
        showContent()
    
        window:reload()

    end

end

function rightLine()

    if partLine + 1 <= mostLenLinePart and filePath ~= nil then

        partLine = partLine +1

        file = readFile(filePath)
        showContent()
    
        window:reload()

    end

end

function leftLine()

    if partLine - 1 >= 1 and filePath ~= nil then

        partLine = partLine -1

        file = readFile(filePath)
        showContent()
    
        window:reload()

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

    window:addText(1, 19, filePath, "red", "white", 0)
    window:showText(0)

    window:addButton(1, 48, 19, 51, 19, "blue", "=>", 1, 0, "black", rightChunk)
    window:showButton(1)
    window:addButton(2, 44, 19, 47, 19, "blue", "<=", 1, 0, "black", leftChunk)
    window:showButton(2)

    window:addButton(3, 45, 1, 48, 1, "purple", "=>", 1, 0, "black", rightLine)
    window:showButton(3)
    window:addButton(4, 42, 1, 45, 1, "purple", "<=", 1, 0, "black", leftLine)
    window:showButton(4)

    window:addButton(5, 1, 1, 6, 1, "blue", "Open", 1, 0, "black", open)
    window:showButton(5)

    if filePath ~= nil then

        file = readFile(filePath)

        chunkNumber = 1
        partLine = 1
        mostLenLinePart = 1

        textLst = {}

        showContent()
    
    end


end

function updateTick()

    while breakApp do

        window:tick()

    end

end

function textViewer(args)

    breakApp = true
    filePath = args[1]

    init()

    window:addButton(0, 49, 0, 51, 2, "red", "X", 1, 2, "black", closeApp)
    window:showButton(0)

    updateTick()

    window:erase()
    window:freeze()

end

function showline()

    id = 2
    y = 3

    for i = 1, 16 do

        txt = i
        if txt < 10 then
            txt = "0" .. tostring(txt)
        end
        window:addText(1, y, txt, "blue", "white", id)
        window:showText(id)

        id = id + 1
        y = y + 1

    end

end

function splitLine(line)
    local lineSplit = {}
    local chunkSize = 49

    for i = 1, #line, chunkSize do

        table.insert(lineSplit, line:sub(i, i + chunkSize - 1))

    end

    if #line == 0 then

        table.insert(lineSplit, "")

    end

    return lineSplit

end

function separateChunk()

    chunkLst = {}
    chunk = {}
    z = 1
    
    if #file > 0 then

        for i, element in ipairs(file) do

            if z == 16 then

                table.insert(chunk, splitLine(element))
                table.insert(chunkLst, chunk)
                z = 0
                chunk = {}

            else

                table.insert(chunk, splitLine(element))

            end
            z = z + 1

        end

        if #chunk > 0 then

            table.insert(chunkLst, chunk)

        end
    
    else

        table.insert(chunkLst, chunk)

    end

end

function showContent()
    
    showline()
    separateChunk()

    window:addText(1, 2, chunkNumber.."/"..#chunkLst, "green", "white", 1)
    window:showText(1)

    for i, element in ipairs(textLst) do

        window:hideText(element)

    end

    for i, ligne in ipairs(chunkLst[chunkNumber]) do

        if #ligne > mostLenLinePart then

            mostLenLinePart = #ligne
        
        end

    end

    y = 3

    for i, ligne in ipairs(chunkLst[chunkNumber]) do

        txt = ligne[partLine]

        if txt == nil then

            txt = ""
        
        end

        window:addText(3, y, txt, "black", "white", id)
        window:showText(id)

        table.insert(textLst, id)

        id = id + 1
        y = y + 1

    end

end