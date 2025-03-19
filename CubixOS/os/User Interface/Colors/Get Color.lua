-- importation du module de gestion des donnees syteme
dofile("os/File System Management/Data System Management/Data System Management.lua")

function getColor(name)

    if name == "black" then
        return colors.black
    elseif name == "white" then
        return colors.white
    elseif name == "lightBlue" then
        return colors.lightBlue
    elseif name == "lime" then
        return colors.lime
    elseif name == "pink" then
        return colors.pink
    elseif name == "yellow" then
        return colors.yellow
    elseif name == "orange" then
        return colors.orange
    elseif name == "magenta" then
        return colors.magenta
    elseif name == "gray" then
        return colors.gray
    elseif name == "lightGray" then
        return colors.lightGray
    elseif name == "cyan" then
        return colors.cyan
    elseif name == "purple" then
        return colors.purple
    elseif name == "blue" then
        return colors.blue
    elseif name == "brown" then
        return colors.brown
    elseif name == "green" then
        return colors.green
    elseif name == "red" then
        return colors.red

    else

        error("Color name : " ..name.." is invalid.")

    end

end

function getImageColor(name)

    if name == "bk" then
        return colors.black
    elseif name == "wh" then
        return colors.white
    elseif name == "lb" then
        return colors.lightBlue
    elseif name == "li" then
        return colors.lime
    elseif name == "pk" then
        return colors.pink
    elseif name == "ye" then
        return colors.yellow
    elseif name == "or" then
        return colors.orange
    elseif name == "ma" then
        return colors.magenta
    elseif name == "gr" then
        return colors.gray
    elseif name == "lg" then
        return colors.lightGray
    elseif name == "cy" then
        return colors.cyan
    elseif name == "pu" then
        return colors.purple
    elseif name == "bl" then
        return colors.blue
    elseif name == "br" then
        return colors.brown
    elseif name == "gn" then
        return colors.green
    elseif name == "rd" then
        return colors.red
    elseif name == "00" then
        return ""
    else
        error("Color name : " ..name.." is invalid.")
    end

end

function getCorrespondance(name)

    if name == "bk" then
        return "black"
    elseif name == "wh" then
        return "white"
    elseif name == "lb" then
        return "lightBlue"
    elseif name == "li" then
        return "lime"
    elseif name == "pk" then
        return "pink"
    elseif name == "ye" then
        return "yellow"
    elseif name == "or" then
        return "orange"
    elseif name == "ma" then
        return "magenta"
    elseif name == "gr" then
        return "gray"
    elseif name == "lg" then
        return "lightGray"
    elseif name == "cy" then
        return "cyan"
    elseif name == "pu" then
        return "purple"
    elseif name == "bl" then
        return "blue"
    elseif name == "br" then
        return "brown"
    elseif name == "gn" then
        return "green"
    elseif name == "rd" then
        return "red"
    else
        error("Color name : " ..name.." is invalid.")
    end

end