function listFolder(path)
    local dossiers = {}
    
    -- Vérifie que le path existe
    if fs.exists(path) and fs.isDir(path) then
        -- Liste tous les éléments dans le répertoire
        local elements = fs.list(path)
        
        -- Vérifie si chaque élément est un dossier
        for _, element in ipairs(elements) do
            local fullPath = fs.combine(path, element)
            if fs.isDir(fullPath) then
                table.insert(dossiers, element)
            end
        end
    else
        print("Le path spécifié n'existe pas ou n'est pas un dossier.")
    end
    
    return dossiers
end

function createFolder(folderPath)

    if fs.exists(folderPath) then

        return false

    end

    fs.makeDir(folderPath)

    if fs.isDir(folderPath) then

        return true

    else

        return false

    end
    
end
