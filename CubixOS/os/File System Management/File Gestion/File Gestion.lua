-- lire le contenu d'un fichier et recuperer une liste
function readFile(nomFichier)
    local lignes = {}
    local fichier = fs.open(nomFichier, "r")
    if not fichier then
        error("Can't find file : " .. nomFichier)
    end

    while true do
        local ligne = fichier.readLine()

        if not ligne then

            break

        end

        table.insert(lignes, ligne)
    end

    fichier.close()

    return lignes
end

-- ecrire a la suite dans un fichier
function addTextInFile(nomFichier, texte)

    local fichier = fs.open(nomFichier, "a")
    if not fichier then
        error("Can't open the file : " .. nomFichier)
    end

    fichier.write(texte)
    fichier.write("\n")

    fichier.close()
end

function changeLineInFile(fileName, lineNumber, newText)

    if not fs.exists(fileName) then
        error("File not found: " .. fileName)
    end

    local lines = {}
    local file = fs.open(fileName, "r")

    local currentLine = 1
    while true do
        local line = file.readLine()
        if not line then break end
        table.insert(lines, line)
        currentLine = currentLine + 1
    end
    file.close()

    if lineNumber < 1 or lineNumber > #lines then
        error("Invalid line number: " .. lineNumber)
    end

    lines[lineNumber] = newText

    file = fs.open(fileName, "w")
    for _, line in ipairs(lines) do
        file.writeLine(line)
    end
    file.close()
end

function clearFile(filePath)

    local file = io.open(filePath, "w")

    if not file then
        error("Could not open file: " .. filePath)
    end

    file:write("")

    file:close()
end

function listFile(path)
    local fichiers = {}
    
    if fs.exists(path) and fs.isDir(path) then

        local elements = fs.list(path)
        
        for _, element in ipairs(elements) do
            local fullPath = fs.combine(path, element)
            if not fs.isDir(fullPath) then
                table.insert(fichiers, element)
            end
        end

    end
    
    return fichiers
end

function fileExists(path)

    local file = io.open(path, "r")

    if file then

        file:close()
        return true

    else

        return false

    end

end

function createFile(filePath)

    if fs.exists(filePath) then

        return false

    end
    
    local file = fs.open(filePath, "w")

    if file then

        file.close()

        return true

    else

        return false

    end
    
end
