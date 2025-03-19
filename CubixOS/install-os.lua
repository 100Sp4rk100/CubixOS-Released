function uncrypt(texteChiffre, cle)

    if texteChiffre == nil or cle == nil then

        return ""

    end

    local texteDechiffre = ""
    local cleIndex = 1
    local cleLongueur = #cle

    for i = 1, #texteChiffre do

        local char = texteChiffre:sub(i, i)
        local code = string.byte(char)
        local decalage = string.byte(cle:sub(cleIndex, cleIndex)) % 256

        local nouveauCode = (code - decalage + 256) % 256
        texteDechiffre = texteDechiffre .. string.char(nouveauCode)

        cleIndex = cleIndex + 1

        if cleIndex > cleLongueur then

            cleIndex = 1

        end

    end

    return texteDechiffre

end

function addTextInFile(nomFichier, texte)

    local fichier = fs.open(nomFichier, "a")

    if fichier then

        fichier.write(texte)
        fichier.write("\n")
        fichier.close()

    else

        error("Unable to write to file: " .. nomFichier)

    end

    os.sleep(0)

end

function readFile(nomFichier)

    local lignes = {}
    local fichier = fs.open(nomFichier, "r")

    if not fichier then

        error("Can't find file: " .. nomFichier)

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

function uncompile()

    local data = readFile(FOLDERCOMPILE)
    local x = 1
    local y = 0 -- Compteur de fichiers restaurés

    while x <= #data do

        local ligne = uncrypt(data[x], "auzgyqrzehvfubgfdyu")

        if ligne == "$$$" then

            x = x + 1

            if x > #data then 

                break 

            end

            ligne = uncrypt(data[x], "auzgyqrzehvfubgfdyu")

            local path = ligne
            print(string.format("Restoring file %d: %s", y + 1, path))
            y = y + 1

            if fs.exists(path) then

                fs.delete(path)

            end

            x = x + 1

            while x <= #data do

                ligne = uncrypt(data[x], "auzgyqrzehvfubgfdyu")

                if ligne == "$$$" then

                    break

                end

                addTextInFile(path, ligne)
                x = x + 1

            end

        else

            x = x + 1

        end

        if x % 10 == 0 then

            os.sleep(0)

        end

    end

    print(string.format("Decompilation completed. Restored %d files.", y))

end

if fs.exists("os") then

    fs.delete("os")

end

FOLDERCOMPILE = "os-compiled"
print("Decompilation in progress...")
uncompile()
print("Decompilation successful!")
print("You can now execute : SETUP")