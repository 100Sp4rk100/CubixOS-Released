-- importation du module de cryptologie
dofile("server/system/Encryptor.lua")
-- importation du module de gestion de fichier
dofile("server/system/File Gestion.lua")
-- importation du module de gestion de fichier
dofile("server/system/String Gestion.lua")

-- recuperer une clef systeme
function getSystemKey(keyName)

    local keyLst = readFile("server/data/Data.sys")
    local key = "dnh3sWdo7dX8KEMSxy7W2yUI029dMeShwpGGC0XuyamQFNk9b2NjnNTvhEPao9UitnUMozjiA0xuxJsrRZ0aWNryiOqqPKV8f3of"

    for _, line in ipairs(keyLst) do

        local var = split(uncrypt(line, key), "=")

        if var[1] == keyName then

            return var[2]

        end

    end

    return nil

end

-- ajouter une clef systeme
function addSystemKey(keyName, value)
    local key = "dnh3sWdo7dX8KEMSxy7W2yUI029dMeShwpGGC0XuyamQFNk9b2NjnNTvhEPao9UitnUMozjiA0xuxJsrRZ0aWNryiOqqPKV8f3of"

    local data = encrypt(keyName.."="..value, key)

    addTextInFile("server/data/Data.sys", data)

end

--creer une clef systeme
function generateRandomKey(length)
    local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local key = ""
    math.randomseed(os.time())

    for i = 1, length do
        local randIndex = math.random(1, #charset)
        key = key .. charset:sub(randIndex, randIndex)
    end

    return key
end

-- changer une clef syteme
function changeSystemKey(keyName, newKey)

    local keyLst = readFile("server/data/Data.sys")
    local key = "dnh3sWdo7dX8KEMSxy7W2yUI029dMeShwpGGC0XuyamQFNk9b2NjnNTvhEPao9UitnUMozjiA0xuxJsrRZ0aWNryiOqqPKV8f3of"

    local data = encrypt(keyName.."="..newKey, key)

    local x = 1

    for _, line in ipairs(keyLst) do

        local var = split(uncrypt(line, key), "=")

        if var[1] == keyName then

            changeLineInFile("server/data/Data.sys", x, data)

        end

        x = x + 1

    end

end