-- importation du module de gestion d'écran
dofile("os/User Interface/GUI/Screen/Screen.lua")
-- importation du module de gestion de chaine de caracteres
dofile("os/File System Management/String Gestion/String Gestion.lua")

-- fonction pour les boutons
function closeApp()

    breakApp = false

end

function search()

    if window:getInputValue(0) ~= "" or window:getInputValue(0) ~= nil then

        window:hideText(1)
        
        if string.match(window:getInputValue(0), "/") then

            searchContent = split(window:getInputValue(0), "/")

            server = searchContent[1]

            title = searchContent[#searchContent]
    
            table.remove(searchContent, 1)

            page = ""

            for _, i in pairs(searchContent) do

                page = page .. i .. "/"

            end

            page = extractChar(page, 1, #page - 1)

        else

            page = "main"

            server = window:getInputValue(0)

        end

        function noRESPONSE() sleep(10) reussi = false end
        function RESPONSE() reussi, cont = runLib("Internet Gestion", "getFileINT", {true, page..".wb", "loadSite", server, "os/Temp/"..page, 10}) end

        parallel.waitForAny(noRESPONSE, RESPONSE)

        if reussi then
            closeApp()
            runLib("Compile To Website", "compileWebsiteFile", {"os/Temp/"..page.."/"..title, "os/Temp/WebSite/"..page})
            runLib("Execute Website", "executeWebsite", {page, "web"})
            sleep(1)
            closeApp()
            web()

        end

    end

end

-- fonction principale
function init()

    INTERNET:enableInternet()

    window = Screen:new()
    window:erase()
    window:addRectangle(0, 0, 51, 19, "white", 0)
    window:showRectangle(0)

    -- ajout du code apres l'initialisation
    window:addInput(0, 2, 1, 48, 2, "blue", "Search bar", 1, 1, "black", "")
    window:showInput(0)
    window:addButton(1, 2, 3, 9, 3, "green", "Search", 1, 0, "black", search, {{}, {}})
    window:showButton(1)
    window:addText(1, 19, "Your ip : " .. INTERNET:getIp(), "blue", "white", 0)
    window:showText(0)
    window:addText(1, 8, "No response", "red", "white", 1)

end

function updateTick()

    while breakApp do

        window:tick()

    end

end

function web()

    breakApp = true

    init()

    window:addButton(0, 49, 0, 51, 2, "red", "X", 1, 2, "black", closeApp)
    window:showButton(0)

    updateTick()

    window:erase()
    window:freeze()

end