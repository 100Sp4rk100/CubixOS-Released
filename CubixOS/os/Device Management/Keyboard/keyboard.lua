local keyMapping = {

    [keys.enter] = "\n", [keys.tab] = "\t",
    [keys.backspace] = "%%",  -- Efface le texte
}



function getKeyboardCaractere()


    local event, param1 = os.pullEvent()

    local key = param1

    if event == "key" and keyMapping[key] then

        return keyMapping[key]

    elseif event == "char" then

        return key

    else

        return "§§§"

    end

end

function getCorrespondanceKey(param1)

    local key = param1

    if keyMapping[key] then

        return keyMapping[key]

    else

        return "§§§"

    end
end