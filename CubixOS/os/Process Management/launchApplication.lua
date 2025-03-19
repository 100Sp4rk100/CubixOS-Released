-- importation du module de gestion des donnees syteme
dofile("os/File System Management/Data System Management/Data System Management.lua")
-- importation du module de gestion de fichier
dofile("os/File System Management/File Gestion/File Gestion.lua")
-- importation du module de gestion de clefs
dofile("os/Security Management/KeyGestion/KeyGestion.lua")
-- importation du module de gestion de listes
dofile("os/File System Management/List/List Gestion.lua")

function runApplication(appName, mainFunctionName, args)
    if checkApplicationExist(appName) then
        local filePath = "os/Applications/" .. appName .. ".app"

        local chunk, err = loadfile(filePath)
        if not chunk then
            error("Error in loading of " .. filePath .. ": " .. err)
        end

        -- Exécuter le chunk
        local success, execErr = pcall(chunk)
        if not success then
            error("Error in execution of " .. filePath .. ": " .. execErr)
        end

        if type(_G[mainFunctionName]) == "function" then
            args = args or {}
            _G[mainFunctionName](args)

        end

    else

        error("Application : "..appName.." didn't exist")

    end
end

function checkApplicationExist(appName)

    appLst = getSystemData("ApplicationList", getSystemKey("ApplicationList"))
    appNameLst = {}

    for _, v in ipairs(appLst) do

        table.insert(appNameLst, split(v, ":")[2])

    end

    return listContains(appNameLst, appName)

end