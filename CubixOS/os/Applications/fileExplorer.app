-- importation du module de gestion d'écran
dofile("os/User Interface/GUI/Screen/Screen.lua")
-- importation du module de gestion de fichier
dofile("os/File System Management/File Gestion/File Gestion.lua")
-- importation du module de gestion de dossier
dofile("os/File System Management/Folder Gestion/Folder Gestion.lua")
-- importation du module de gestion des chaines de charactere
dofile("os/File System Management/String Gestion/String Gestion.lua")
-- importation du module de gestion d'applications
dofile("os/Process Management/launchApplication.lua")
-- importation du module de gestion global
dofile("os/File System Management/Global/Global.lua")
-- importation du module d'installation d'applications
dofile("os/Process Management/packageInstaller.lua")

-- fonction pour les boutons
function closeApp()

    breakApp = false

end

function leftPath()

    chunkNumber = 1

    pathElements = split(path, "/")
    if pathElements[#pathElements] ~= "os" then

        path = "os"

        table.remove(pathElements, #pathElements)

        for i, element in ipairs(pathElements) do
            
            if i ~= 1 then
                path = path .. "/" .. element
            end

        end

        listeOfFile = listFile(path)
        listOfFolder = listFolder(path)
        showFileFolder()
    
        window:changeTextValue(0, path)
        window:changeTextValue(1, "type : nil // name : nil", "red", "white")
    
        window:reload()

    end


end

function rightChunk()

    if chunkNumber + 1 <= #newFolderLst or chunkNumber + 1 <= #newFileLst then

        chunkNumber = chunkNumber +1

        listeOfFile = listFile(path)
        listOfFolder = listFolder(path)
        showFileFolder()

        window:changeTextValue(1, "type : nil // name : nil", "red", "white")

        window:reload()

    end

end

function leftChunk()

    if chunkNumber - 1 >= 1 then

        chunkNumber = chunkNumber -1

        listeOfFile = listFile(path)
        listOfFolder = listFolder(path)
        showFileFolder()
    
        window:changeTextValue(1, "type : nil // name : nil", "red", "white")

        window:reload()

    end


end

function delete()
    
    if window:getTextValue(1) ~= "type : nil // name : nil" then

        if split(split(window:getTextValue(1), " // name : ")[2], ".")[#split(split(window:getTextValue(1), " // name : ")[2], ".")] == "sys" then

            breakApp = false

            window:freeze()

            pathToDelete = path.. "/" .. split(window:getTextValue(1), " // name : ")[2]

            function nextDelete()

                deleteAnElement(pathToDelete)

            end

            runApplication("adminCheck", "adminCheck", {nextDelete})

            runApplication("fileExplorer", "fileExplorer", {path})
        
        else

            deleteAnElement(path.. "/" .. split(window:getTextValue(1), " // name : ")[2])
            listeOfFile = listFile(path)
            listOfFolder = listFolder(path)
            showFileFolder()

            window:changeTextValue(0, path)
            window:changeTextValue(1, "type : nil // name : nil", "red", "white")

            window:reload()
        
        end

    end

end

function rename()
    
    if window:getTextValue(1) ~= "type : nil // name : nil" then

        if split(split(window:getTextValue(1), " // name : ")[2], ".")[#split(split(window:getTextValue(1), " // name : ")[2], ".")] == "sys" then

            breakApp = false

            window:freeze()

            pathToMove = path.. "/" .. split(window:getTextValue(1), " // name : ")[2]
            newName = window:getInputValue(0)

            function nextMove()

                moveAnElement(pathToMove, path.. "/" .. newName)

            end

            runApplication("adminCheck", "adminCheck", {nextMove})

            runApplication("fileExplorer", "fileExplorer", {path})
        
        else

            moveAnElement(path.. "/" .. split(window:getTextValue(1), " // name : ")[2], path.. "/" .. window:getInputValue(0))
            listeOfFile = listFile(path)
            listOfFolder = listFolder(path)
            showFileFolder()

            window:changeTextValue(0, path)
            window:changeTextValue(1, "type : nil // name : nil", "red", "white")

            window:reload()
        
        end

    end

end

function move()

    if window:getTextValue(1) ~= "type : nil // name : nil" and window:getInputValue(1) ~= "" then

        if split(split(window:getTextValue(1), " // name : ")[2], ".")[#split(split(window:getTextValue(1), " // name : ")[2], ".")] == "sys" then

            breakApp = false

            window:freeze()

            pathToMove = path.. "/" .. split(window:getTextValue(1), " // name : ")[2]
            newName = window:getInputValue(1)

            function nextMove()

                moveAnElement(pathToMove, path.. "/" .. newName)

            end

            runApplication("adminCheck", "adminCheck", {nextMove})

            runApplication("fileExplorer", "fileExplorer", {path})
        
        else

            name = split(window:getTextValue(1), " // name : ")[2]
            begin = split(window:getInputValue(1), "..")

            if begin[2] ~= nil then

                pathElements2 = split(path, "/")
                if pathElements2[#pathElements2] ~= "os" then

                    path2 = "os"

                    table.remove(pathElements2, #pathElements2)

                    for i, element in ipairs(pathElements2) do
                        
                        if i ~= 1 then
                            path2 = path2 .. "/" .. element
                        end

                    end

                end

                if fs.isDir(path2.. "/" .. begin[2]) then

                    moveAnElement(path.. "/" .. name, path2.. "/" .. begin[2].. "/" .. name)
                
                end

            else
                
                if fs.isDir(path.. "/" .. window:getInputValue(1)) then

                    moveAnElement(path.. "/" .. name, path.. "/" .. window:getInputValue(1).. "/" .. name)
                
                end

            end
            
            listeOfFile = listFile(path)
            listOfFolder = listFolder(path)
            showFileFolder()

            window:changeTextValue(0, path)
            window:changeTextValue(1, "type : nil // name : nil", "red", "white")

            window:reload()
        
        end

    end

end

function copy()

    if window:getTextValue(1) ~= "type : nil // name : nil" and window:getInputValue(2) ~= "" then

        if split(split(window:getTextValue(1), " // name : ")[2], ".")[#split(split(window:getTextValue(1), " // name : ")[2], ".")] == "sys" then

            breakApp = false

            window:freeze()

            pathToMove = path.. "/" .. split(window:getTextValue(1), " // name : ")[2]
            newName = window:getInputValue(2)

            function nextMove()

                copyAnElement(pathToMove, path.. "/" .. newName)

            end

            runApplication("adminCheck", "adminCheck", {nextMove})

            runApplication("fileExplorer", "fileExplorer", {path})
        
        else

            name = split(window:getTextValue(1), " // name : ")[2]
            begin = split(window:getInputValue(2), "..")

            if begin[2] ~= nil then

                pathElements2 = split(path, "/")
                if pathElements2[#pathElements2] ~= "os" then

                    path2 = "os"

                    table.remove(pathElements2, #pathElements2)

                    for i, element in ipairs(pathElements2) do
                        
                        if i ~= 1 then
                            path2 = path2 .. "/" .. element
                        end

                    end

                end

                if fs.isDir(path2.. "/" .. begin[2]) then

                    copyAnElement(path.. "/" .. name, path2.. "/" .. begin[2].. "/" .. name)
                
                end

            else
                
                if fs.isDir(path.. "/" .. window:getInputValue(2)) then

                    copyAnElement(path.. "/" .. name, path.. "/" .. window:getInputValue(2).. "/" .. name)
                
                end

            end
            
            listeOfFile = listFile(path)
            listOfFolder = listFolder(path)
            showFileFolder()

            window:changeTextValue(0, path)
            window:changeTextValue(1, "type : nil // name : nil", "red", "white")

            window:reload()
        
        end

    end

end

function new()

    if window:getInputValue(3) ~= "" then

        if #split(window:getInputValue(3), ".") ~= 1 then

            createFile(path.."/"..window:getInputValue(3))

            if split(window:getInputValue(3), ".")[#split(window:getInputValue(3), ".")] == "img" then

                addTextInFile(path.."/"..window:getInputValue(3), "width=0")
                addTextInFile(path.."/"..window:getInputValue(3), "height=0")

            end

        else

            createFolder(path.."/"..window:getInputValue(3))

        end

        listeOfFile = listFile(path)
        listOfFolder = listFolder(path)
        showFileFolder()

        window:changeTextValue(0, path)
        window:changeTextValue(1, "type : nil // name : nil", "red", "white")

        window:reload()

    end

end

-- fonction principale

function init()

    window = Screen:new()
    window:erase()
    window:addRectangle(0, 0, 51, 19, "white", 0)
    window:showRectangle(0)

    window:addButton(2, 48, 18, 51, 19, "blue", "=>", 1, 1, "black", rightChunk)
    window:showButton(2)
    window:addButton(3, 44, 18, 47, 19, "blue", "<=", 1, 1, "black", leftChunk)
    window:showButton(3)

    if argsPath[1] ~= nil then

        path = argsPath[1]

    else

        path = "os/Home"

    end

    buttonImageLst = {}
    chunkNumber = 1
    listeOfFile = listFile(path)
    listOfFolder = listFolder(path)
    showFileFolder()

    window:addButton(1, 0, 0, 3, 3, "blue", "<=", 1, 2, "black", leftPath)
    window:showButton(1)

    window:addText(4, 1, path, "green", "white", 0)
    window:showText(0)
    window:addText(1, 18, "type : nil // name : nil", "red", "white", 1)
    window:showText(1)

    window:addButton(4, 4, 2, 9, 2, "red", "Delete", 0, 0, "black", delete)
    window:showButton(4)

    window:addInput(0, 10, 2, 15, 2, "green", "Rename", 0, 0, "black", "")
    window:showInput(0)
    window:addButton(5, 10, 3, 15, 3, "orange", "Ok", 2, 0, "black", rename)
    window:showButton(5)

    window:addInput(1, 16, 2, 22, 2, "blue", "Move to", 0, 0, "black", "")
    window:showInput(1)
    window:addButton(6, 16, 3, 22, 3, "orange", "Ok", 3, 0, "black", move)
    window:showButton(6)

    window:addInput(2, 23, 2, 29, 2, "green", "Copy to", 0, 0, "black", "")
    window:showInput(2)
    window:addButton(7, 23, 3, 29, 3, "orange", "Ok", 3, 0, "black", copy)
    window:showButton(7)

    window:addInput(3, 30, 2, 37, 2, "blue", "Name", 2, 0, "black", "")
    window:showInput(3)
    window:addButton(8, 30, 3, 37, 3, "orange", "Create", 1, 0, "black", new)
    window:showButton(8)

end

function updateTick()

    while breakApp do

        window:tick()

    end

end

function fileExplorer(args)

    breakApp = true

    argsPath = args

    init()

    window:addButton(0, 49, 0, 51, 2, "red", "X", 1, 2, "black", closeApp)
    window:showButton(0)

    updateTick()

    window:erase()
    window:freeze()

end

function leftClicElement(args)

    typeElement = args[1]
    name = args[2]

    if typeElement == "file" then

        extension = split(name, ".")
        extension = extension[#extension]

        if extension == "sys" then

            -- mdp + txt

            breakApp = false

            window:freeze()

            function openTextViewer()

                runApplication("textViewer", "textViewer", {path.."/"..name})

                runApplication("fileExplorer", "fileExplorer", {path})

            end

            runApplication("adminCheck", "adminCheck", {openTextViewer})

            runApplication("fileExplorer", "fileExplorer", {path})

        elseif extension == "img" then

            breakApp = false
            window:erase()
            window:freeze()

            runApplication("imageViewer", "imageViewer", {path.."/"..name})

            runApplication("fileExplorer", "fileExplorer", {path})

        elseif extension == "app" then

            breakApp = false
            window:erase()
            window:freeze()

            appName = split(name, ".")[1]
            runApplication(appName, appName)

            runApplication("fileExplorer", "fileExplorer", {path})

        elseif extension == "dfpwm" then

            breakApp = false

            window:freeze()

            runApplication("soundPlayer", "soundPlayer", {path.."/"..name})

            runApplication("fileExplorer", "fileExplorer", {path})

        elseif extension == "inf" then

            installPackage(path)

        else

            breakApp = false

            window:freeze()

            runApplication("textViewer", "textViewer", {path.."/"..name})

            runApplication("fileExplorer", "fileExplorer", {path})

        end

    elseif typeElement == "folder" then

        extension = split(name, ".")
        extension = extension[#extension]

        if extension == "inf" then

            installPackage(path.."/"..name)

        else

            chunkNumber = 1

            path = path .. "/" .. name

            listeOfFile = listFile(path)
            listOfFolder = listFolder(path)
            showFileFolder()
        
            window:changeTextValue(0, path)
            window:changeTextValue(1, "type : nil // name : nil", "red", "white")

            window:reload()

        end

    else

        error("type invalid : "..typeElement)

    end

end

function rightClicElement(args)

    typeElement = args[1]
    name = args[2]

    window:hideText(1)
    window:changeTextValue(1, "type : " .. typeElement .. " // name : " .. name, "red", "white")
    window:showText(1)

end

function showFileFolder()

    for i, element in ipairs(buttonImageLst) do

        window:hideButton(element)
        window:hideImage(element)

    end

    buttonImageLst = {}

    newFolderLst = {}
    chunk = {}
    z = 1
    
    if #listOfFolder > 0 then

        for i, element in ipairs(listOfFolder) do

            if z == 25 then

                table.insert(newFolderLst, chunk)
                z = 0
                chunk = {}

            else

                table.insert(chunk, element)

            end
            z = z + 1

        end

        if #chunk > 0 then

            table.insert(newFolderLst, chunk)

        end
    
    else

        table.insert(newFolderLst, chunk)

    end

    newFileLst = {}
    chunk = {}
    z = 1

    if #listeOfFile > 0 then

        for i, element in ipairs(listeOfFile) do

            if z == 25 then

                table.insert(newFileLst, chunk)
                z = 0
                chunk = {}

            else

                table.insert(chunk, element)

            end
            z = z + 1

        end

        if #chunk > 0 then

            table.insert(newFileLst, chunk)

        end
    
    else

        table.insert(newFileLst, chunk)

    end

    x = 1
    y = 5
    id = 9

    if newFolderLst[chunkNumber] ~= nil then

        for _, folder in ipairs(newFolderLst[chunkNumber]) do
            window:addButton(id, x, y, x + 4, y + 2, "", "", 1, 1, "", leftClicElement, {{"folder", folder}, {"folder", folder}}, rightClicElement)

            local extension = split(folder, ".")[#split(folder, ".")]

            if extension == "inf" then

                window:addImage(x, y, "os/OS Data/Image/FileInstall.img", id)

            else

                window:addImage(x, y, "os/OS Data/Image/Folder.img", id)

            end
            
            x = x + 6
            if x >= 49 then
                x = 1
                y = y + 4

                if y >= 17 then 

                    break 
                
                end
                
            end

            window:showButton(id)
            window:showImage(id)
            table.insert(buttonImageLst, id)
            id = id + 1
        end

    end

    if newFileLst[chunkNumber] ~= nil then

        if y ~= 17 then

            for _, file in ipairs(newFileLst[chunkNumber]) do

                local imagePath = "os/OS Data/Image/"
                local extension = split(file, ".")[#split(file, ".")]

                local nameLst = split(file, ".")
                local name = ""
                table.remove(nameLst, #nameLst)

                for i, element in ipairs(nameLst) do

                    name = name .. element

                end
    
                if extension == "sys" then

                    imagePath = imagePath .. "FileSys.img"

                elseif extension == "img" then

                    imagePath = imagePath .. "FileImage.img"

                elseif extension == "lua" then

                    imagePath = imagePath .. "FileLua.img"

                elseif extension == "app" then
                    
                    if fileExists("os/OS Data/App/"..name.."/"..name..".dat") then

                        content = getData("os/OS Data/App/"..name.."/"..name..".dat")

                        imagePath = getDataValue(content, "logo")
                    
                    else

                        imagePath = imagePath .. "FileApp.img"

                    end

                elseif extension == "dat" then

                    imagePath = imagePath .. "FileDat.img"

                elseif extension == "dfpwm" then

                    imagePath = imagePath .. "FileDFPWM.img"

                elseif extension == "inf" then

                    imagePath = imagePath .. "FileInf.img"

                elseif extension == "lib" then

                    imagePath = imagePath .. "FileLib.img"

                else

                    imagePath = imagePath .. "File.img"

                end
    
                window:addButton(id, x, y, x + 4, y + 2, "", "", 1, 1, "", leftClicElement, {{"file", file}, {"file", file}}, rightClicElement)
                window:addImage(x, y, imagePath, id)
                
                x = x + 6

                if x >= 49 then

                    x = 1
                    y = y + 4

                    if y >= 17 then 
                        
                        break 
                    
                    end

                end
    
                window:showButton(id)
                window:showImage(id)
                table.insert(buttonImageLst, id)
                id = id + 1

            end
        
        end

    end

end