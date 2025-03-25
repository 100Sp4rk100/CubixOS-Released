function splitByTwo(str)

    if #str % 2 ~= 0 then
        error("The string length is not even. Cannot split into pairs. : ")
    end

    local result = {}

    for i = 1, #str, 2 do
        local pair = str:sub(i, i + 1)
        table.insert(result, pair)
    end

    return result
end

function extractChar(str, x, y)

    if x > y or x < 0 then
        return ""
    end

    local resultat = ""
    for i = x, y do
        resultat = resultat .. str:sub(i, i)
    end

    return resultat

end

function split(texte, delimiteur)
    if texte == nil then
        error("Split function needs a value!")
    end

    local resultats = {}
    local modele = "(.-)" .. delimiteur:gsub("%p", "%%%0")  -- Échappe les caractères spéciaux
    local debut = 1

    for trouv, fin in texte:gmatch(modele .. "()") do
        table.insert(resultats, trouv)
        debut = fin
    end

    if debut <= #texte then
        table.insert(resultats, texte:sub(debut))
    end

    return resultats
end