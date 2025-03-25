-- Fonction pour chiffrer
function encrypt(texte, cle)
    if texte == nil or cle == nil then
        error("Encrypt function needs values!")
    end

    local texteChiffre = ""
    local cleIndex = 1
    local cleLongueur = #cle

    -- Parcourir chaque caractère du texte
    for i = 1, #texte do
        local char = texte:sub(i, i)
        local code = string.byte(char)
        local decalage = string.byte(cle:sub(cleIndex, cleIndex)) % 256 -- Décalage sur 256 caractères (ASCII étendu)

        -- Décalage circulaire dans le jeu de caractères
        local nouveauCode = (code + decalage) % 256
        texteChiffre = texteChiffre .. string.char(nouveauCode)

        -- Passer à la lettre suivante dans la clé
        cleIndex = cleIndex + 1
        if cleIndex > cleLongueur then
            cleIndex = 1
        end
    end

    return texteChiffre
end

-- Fonction pour dechiffrer
function uncrypt(texteChiffre, cle)
    if texteChiffre == nil or cle == nil then
        error("Uncrypt function needs values!")
    end

    local texteDechiffre = ""
    local cleIndex = 1
    local cleLongueur = #cle

    -- Parcourir chaque caractère du texte chiffré
    for i = 1, #texteChiffre do
        local char = texteChiffre:sub(i, i)
        local code = string.byte(char)
        local decalage = string.byte(cle:sub(cleIndex, cleIndex)) % 256 -- Décalage sur 256 caractères

        -- Décalage circulaire inverse dans le jeu de caractères
        local nouveauCode = (code - decalage + 256) % 256
        texteDechiffre = texteDechiffre .. string.char(nouveauCode)

        -- Passer à la lettre suivante dans la clé
        cleIndex = cleIndex + 1
        if cleIndex > cleLongueur then
            cleIndex = 1
        end
    end

    return texteDechiffre
end
