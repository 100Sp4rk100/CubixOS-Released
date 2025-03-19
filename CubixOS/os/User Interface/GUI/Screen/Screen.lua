-- importation du module de boutons
dofile("os/User Interface/GUI/Button/Button.lua")

-- importation du module d'entree
dofile("os/User Interface/GUI/Input/Input.lua")

-- importation du module de gestion des donnees syteme
dofile("os/File System Management/Data System Management/Data System Management.lua")

-- importation du module de gestion des couleurs
dofile("os/User Interface/Colors/Get Color.lua")

-- importation du module de gestion des Events
dofile("os/Device Management/Screen/Screen Event.lua")

-- importation du module de gestion des images
dofile("os/User Interface/Image/Image.lua")

-- importation du module de rectangle
dofile("os/User Interface/GUI/Content/Rectangle.lua")

-- importation du module de texte
dofile("os/User Interface/GUI/Content/Text.lua")

-- importation du module de gestion de librairies
dofile("os/Process Management/librairyExecution.lua")

-- importation du module de gestion cles
dofile("os/Security Management/KeyGestion/KeyGestion.lua")

-- creation de la classe Screens
Screen = {}
Screen.__index = Screen

-- constructeur
function Screen:new()

    local self = setmetatable({}, Screen)

    -- definition des variables
    self.isFreeze = false

    -- definition des tables
    self.buttonsTable = {}
    self.buttonTablePosition = {}

    self.inputTable = {}
    self.inputTablePosition = {}

    self.rectangleTable = {}
    self.rectangleTablePosition = {}

    self.textTable = {}
    self.textTablePosition = {}

    self.imageTable = {}

    self.reloadTable = {}

    self.keyEvent = {}
    self.Event = {}
    self:reloadGeneralEvent()
    return self

end

-- methodes de la classe

-- fonctions sur l'écran
function Screen:tick()
    if not self.isFreeze then

        for id, obj in pairs(self.buttonsTable) do
            if obj:isShowed() then

                self.buttonTablePosition[id] = obj:getButtonPosition()

            else

                self.buttonTablePosition[id] = nil

            end

        end

        for id, obj in pairs(self.inputTable) do
            if obj:isShowed() then

                self.inputTablePosition[id] = obj:getInputPosition()

            else

                self.inputTablePosition[id] = nil

            end

        end

        self:getEvent()

    end

    for _, i in ipairs(self.Event) do

        i[1](i[2])

    end

    for name, i in pairs(self.generalEvent) do

        runLib(name, i.mainFunctionName, i.args)

    end

end

function Screen:freeze()

    self.isFreeze = true

end

function Screen:unfreeze()

    self.isFreeze = false

end

function Screen:erase()

    term.setBackgroundColor(getColor(getSystemVar("screencolor")))
    term.clear()
    term.setCursorPos(1, 1)
    
end

function Screen:getEvent()

    self.event, self.param1, self.param2, self.param3 = detectScreenClics()

    if self.event == "clic" then

        for id, position in pairs(self.buttonTablePosition) do

            if isClickInArea(position.x1, position.y1, position.x2, position.y2, self.param1, self.param2) then

                self.currentButton = self.buttonsTable[id]
                self.currentButton:action(self.param3)

            end

        end

        for id, position in pairs(self.inputTablePosition) do

            if isClickInArea(position.x1, position.y1, position.x2, position.y2, self.param1, self.param2) then

                self.currentInput = self.inputTable[id]
                self.currentInput:action()


            end

        end
    
    elseif self.event == "key" then

        if self.keyEvent[self.param1] ~= nil then

            local toRun = self.keyEvent[self.param1]
            toRun[1](toRun[2])

        end

    end

end

function Screen:reload()

    self:erase()

    for id, obj in pairs(self.reloadTable) do

        if obj[1] == "button" then

            self.element = self.buttonsTable[obj[2]]

            if self.element:isShowed() then

                self.element:show()
    
            end
        
        elseif obj[1] == "rectangle" then

            self.element = self.rectangleTable[obj[2]]

            if self.element:isShowed() then

                self.element:show()
    
            end

        elseif obj[1] == "text" then

            self.element = self.textTable[obj[2]]

            if self.element:isShowed() then

                self.element:show()
    
            end

        elseif obj[1] == "image" then

            self.element = self.imageTable[obj[2]]

            if self.element:isShowed() then

                self.element:show()
    
            end

        elseif obj[1] == "input" then

            self.element = self.inputTable[obj[2]]

            if self.element:isShowed() then

                self.element:show()
    
            end

        end

    end

end

local function removeCircularReferences(t, visited)

    if type(t) ~= "table" then 
        return t 
    end

    if visited[t] then 
        return nil 
    end

    visited[t] = true
    local copy = {}

    for k, v in pairs(t) do
        copy[k] = removeCircularReferences(v, visited)
    end

    return copy

end

function Screen:getScreen()
    local screenContent = {}

    for id, obj in pairs(self.reloadTable) do

        if obj[1] == "button" then

            self.element = self.buttonsTable[obj[2]]

            if self.element:isShowed() then

                table.insert(screenContent, {
                    type = "button",
                    id = self.element:getId(),
                    position = self.element:getButtonPosition(),
                    color = self.element:getColor(),
                    txtColor = self.element:getTextColor(),
                    txt = self.element:getText(),
                    txtposition = self.element:getTextPosition(),
                })

            end
        
        elseif obj[1] == "rectangle" then

            self.element = self.rectangleTable[obj[2]]

            if self.element:isShowed() then

                table.insert(screenContent, {
                    type = "rectangle",
                    id = self.element:getId(),
                    position = self.element:getRectanglePosition(),
                    color = self.element:getColor()
                })

            end

        elseif obj[1] == "text" then

            self.element = self.textTable[obj[2]]

            if self.element:isShowed() then

                table.insert(screenContent, {
                    type = "text",
                    id = self.element:getId(),
                    position = self.element:getTextPosition(),
                    value = self.element:getValue(),
                    color = self.element:getColor(),
                    backgroundColor = self.element:getBackgroundColor()
                })

            end

        elseif obj[1] == "image" then

            self.element = self.imageTable[obj[2]]

            if self.element:isShowed() then

                table.insert(screenContent, {
                    type = "image",
                    id = self.element:getId(),
                    position = self.element:getImagePosition(),
                    img = self.element:getImage()
                })

            end

        elseif obj[1] == "input" then

            self.element = self.inputTable[obj[2]]

            if self.element:isShowed() then

                table.insert(screenContent, {
                    type = "input",
                    id = self.element:getId(),
                    position = self.element:getInputPosition(),
                    color = self.element:getColor(),
                    txtColor = self.element:getTextColor(),
                    txt = self.element:getText(),
                    txtposition = self.element:getTextPosition(),
                    mask = self.element:getMask()
                })

            end

        end

    end

    local serialized = textutils.serialize(removeCircularReferences(screenContent, {}))

    return serialized:gsub("\n", ""):gsub("%s+", " ")

end

-- fonctions en rapport avec les boutons
function Screen:addButton(id, x1, y1, x2, y2, color, texte, texteX, texteY, texteColor, fonction1, args, fonction2)

    if type(id) == "number" then

        self.buttonsTable[id] = Button:new(x1, y1, x2, y2, color, texte, texteX, texteY, texteColor, id, {fonction1, fonction2}, args)
        table.insert(self.reloadTable, {"button", id})

    else

        error("You must enter a int for the id")

    end
    
end

function Screen:showButton(id)

    if type(id) == "number" then

        if self.buttonsTable[id] ~= nil then

            self.buttonsTable[id]:show()

        end

    else

        error("You must enter a int for the id")

    end

end

function Screen:hideButton(id)

    if type(id) == "number" then

        if self.buttonsTable[id] ~= nil then
        
            self.buttonsTable[id]:hide()
        
        end

    else

        error("You must enter a int for the id")

    end

end

-- fonction d'ajout de contenu

-- fonction en rapport avec les rectangles
function Screen:addRectangle(x1, y1, x2, y2, color, id)

    if type(id) == "number" then

        self.rectangleTable[id] = Rectangle:new(x1, y1, x2, y2, color, id)
        table.insert(self.reloadTable,  {"rectangle", id})

    else

        error("You must enter a int for the id")

    end

end

function Screen:showRectangle(id)

    if type(id) == "number" then

        if self.rectangleTable[id] ~= nil then

            self.rectangleTable[id]:show()

        end

    else

        error("You must enter a int for the id")

    end

end

function Screen:hideRectangle(id)

    if type(id) == "number" then

        if self.rectangleTable[id] ~= nil then

            self.rectangleTable[id]:hide()

        end

    else

        error("You must enter a int for the id")

    end

end

-- fonction en rapport avec le texte
function Screen:addText(x1, y1, text, color, backgroundColor, id)

    if type(id) == "number" then

        self.textTable[id] = Text:new(x1, y1, text, color, backgroundColor, id)
        table.insert(self.reloadTable, {"text", id})

    else

        error("You must enter a int for the id")
    
    end

end

function Screen:showText(id)

    if type(id) == "number" then

        if self.textTable[id] ~= nil then

            self.textTable[id]:show()

        end

    else

        error("You must enter a int for the id")

    end

end

function Screen:hideText(id)

    if type(id) == "number" then

        if self.textTable[id] ~= nil then

            self.textTable[id]:hide()

        end

    else

        error("You must enter a int for the id")

    end

end

function Screen:changeTextValue(id, value)

    if type(id) == "number" then

        self.textTable[id]:changeValue(value)

    else

        error("You must enter a int for the id")

    end

end

function Screen:getTextValue(id)

    if type(id) == "number" then

        return self.textTable[id]:getValue()

    else

        error("You must enter a int for the id")

    end

end

-- fonction en rapport avec les images
function Screen:addImage(x, y, path, id)

    if type(id) == "number" then

        self.imageTable[id] = Image:new(x, y, path, id)

        if path ~= "!NUL!" then

            self.imageTable[id]:load()

        end

        table.insert(self.reloadTable, {"image", id})

    else

        error("You must enter a int for the id")

    end
end

function Screen:showImage(id)

    if type(id) == "number" then

        if self.imageTable[id] ~= nil then

            self.imageTable[id]:show()

        end

    else

        error("You must enter a int for the id")

    end

end

function Screen:hideImage(id)

    if type(id) == "number" then

        if self.imageTable[id] ~= nil then

            self.imageTable[id]:hide()

        end

    else

        error("You must enter a int for the id")

    end

end

function Screen:getImageSize(id)

    if type(id) == "number" then

        if self.imageTable[id] ~= nil then

            return self.imageTable[id]:size()

        end

    else

        error("You must enter a int for the id")

    end

end

function Screen:setPixel(id, x, y, color)

    if type(id) == "number" then

        if self.imageTable[id] ~= nil then

            return self.imageTable[id]:setPixel(x, y, color)

        end

    else

        error("You must enter a int for the id")

    end

end

function Screen:changeImagePosition(id, x, y)

    if type(id) == "number" then

        if self.imageTable[id] ~= nil then

            return self.imageTable[id]:changeImagePosition(x, y)

        end

    else

        error("You must enter a int for the id")

    end

end

function Screen:getImagePosition(id)

    if type(id) == "number" then

        if self.imageTable[id] ~= nil then

            return self.imageTable[id]:getImagePosition()

        end

    else

        error("You must enter a int for the id")

    end

end

function Screen:loadImage(id)

    if type(id) == "number" then

        if self.imageTable[id] ~= nil then

            self.imageTable[id]:load()

        end

    else

        error("You must enter a int for the id")

    end

end

function Screen:setImage(id, img)

    if type(id) == "number" then

        if self.imageTable[id] ~= nil then

            self.imageTable[id]:setImage(img)

        end

    else

        error("You must enter a int for the id")

    end

end

-- fonctions en rapport avec les entree
function Screen:addInput(id, x1, y1, x2, y2, color, texte, texteX, texteY, texteColor, mask)

    if type(id) == "number" then

        self.inputTable[id] = Input:new(x1, y1, x2, y2, color, texte, texteX, texteY, texteColor, id, mask)
        table.insert(self.reloadTable, {"input", id})

    else

        error("You must enter a int for the id")

    end

end

function Screen:showInput(id)

    if type(id) == "number" then

        if self.inputTable[id] ~= nil then

            self.inputTable[id]:show()

        end

    else

        error("You must enter a int for the id")

    end

end

function Screen:hideInput(id)

    if type(id) == "number" then

        if self.inputTable[id] ~= nil then

            self.inputTable[id]:hide()

        end

    else

        error("You must enter a int for the id")

    end

end

function Screen:getInputValue(id)

    if type(id) == "number" then
        
        return self.inputTable[id]:getValue()

    else

        error("You must enter a int for the id")

    end

end

-- fonctions sur les events
function Screen:registerKeyEvent(key, func, args)

    self.keyEvent[key] = {func, args}

end

function Screen:registerEvent(func, args)

    table.insert(self.Event, {func, args})

end

function Screen:addGeneralEvent(name, mainFunctionName, args)

    function serializeTable(tbl)
        local result = {}
        for key, value in pairs(tbl) do
            table.insert(result, key .. "=" .. tostring(value))
        end
        return table.concat(result, ",")
    end

    self.generalEvent[name] = {name = name, mainFunctionName = mainFunctionName, args = args}

    local serializedData = {}

    for eventName, eventData in pairs(self.generalEvent) do

        table.insert(serializedData, eventName .. ":" .. serializeTable(eventData))

    end

    changeSystemData("OsGeneralEvent", serializedData, getSystemKey("OsGeneralEventKey"))

end


function Screen:reloadGeneralEvent()

    function deserializeTable(str)
        local tbl = {}
        for pair in string.gmatch(str, "[^,]+") do
            local key, value = string.match(pair, "([^=]+)=([^=]+)")
            tbl[key] = value
        end
        return tbl
    end

    local data = getSystemData("OsGeneralEvent", getSystemKey("OsGeneralEventKey"))
    self.generalEvent = {}

    for _, line in ipairs(data) do

        local name, eventData = string.match(line, "([^:]+):(.+)")
        self.generalEvent[name] = deserializeTable(eventData)

    end
end


function Screen:removeGeneralEvent(name)

    self.generalEvent[name] = nil
    
    local serializedData = {}

    for eventName, eventData in pairs(self.generalEvent) do

        table.insert(serializedData, eventName .. ":" .. serializeTable(eventData))

    end

    changeSystemData("OsGeneralEvent", serializedData, getSystemKey("OsGeneralEventKey"))

end
