-- importation du module de cryptologie
dofile("server/system/Encryptor.lua")
-- importation du module de gestion de fichier
dofile("server/system/File Gestion.lua")
-- importation du module de gestion cles
dofile("server/system/KeyGestion.lua")
dofile("server/system/String Gestion.lua")

-- obtenir les variables systeme
function getSystemVar(varName)

    local varLst = readFile("server/var/SystemVar.sys")

    local key = getSystemKey("varkey")

    for _, line in ipairs(varLst) do

        local var = split(uncrypt(line, key), "=")

        if var[1] == varName then

            return var[2]

        end

    end

    return nil

end

function addSystemVar(varName, value)

    local key = getSystemKey("varkey")

    if getSystemVar(varName) == nil then

        local data = encrypt(varName.."="..value, key)

        addTextInFile("server/var/SystemVar.sys", data)

    end

end

function changeSystemVar(varName, newValue)

    local varLst = readFile("server/var/SystemVar.sys")

    local key = getSystemKey("varkey")

    local data = encrypt(varName.."="..newValue, key)

    local x = 1

    for _, line in ipairs(varLst) do

        local var = split(uncrypt(line, key), "=")

        if var[1] == varName then

            changeLineInFile("server/var/SystemVar.sys", x, data)

        end

        x = x + 1

    end

end

-- obtenir les donnees systeme
function getSystemData(dataName, key)

    local dataLst = readFile("server/data/"..dataName..".sys")
    local decryptedData = {}

    for _, line in ipairs(dataLst) do

        table.insert(decryptedData, uncrypt(line, key))

    end

    return decryptedData

end

function addSystemData(dataName, values, key)

    for _, line in ipairs(values) do

        addTextInFile("server/data/"..dataName..".sys", encrypt(line, key))

    end

end

function changeSystemData(dataName, values, key)

    clearFile("server/data/"..dataName..".sys")

    for _, line in ipairs(values) do

        addTextInFile("server/data/"..dataName..".sys", encrypt(line, key))

    end

end

-- obtenir des donnees
function getDataValue(data, nameValue)

    for _, line in ipairs(data) do

        local var = split(line, "=")

        if var[1] == nameValue then

            return var[2]

        end

    end

    return nil

end

function getData(path)

    return readFile(path)

end

function addData(path, values)

    for _, line in ipairs(values) do

        addTextInFile(path, line)

    end

end

function changeData(path, values)

    clearFile(path)

    for _, line in ipairs(values) do

        addTextInFile(path, line)

    end

end