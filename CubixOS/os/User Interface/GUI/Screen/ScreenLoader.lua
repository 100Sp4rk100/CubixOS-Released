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

-- creation de la classe ScreenLoaders
ScreenLoader = {}
ScreenLoader.__index = ScreenLoader

-- constructeur
function ScreenLoader:new()

    local self = setmetatable({}, ScreenLoader)

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

    return self

end

-- methodes de la classe

-- fonctions sur l'écran
function ScreenLoader:freeze()

    self.isFreeze = true

end

function ScreenLoader:unfreeze()

    self.isFreeze = false

end

function ScreenLoader:erase()

    term.setBackgroundColor(getColor(getSystemVar("screencolor")))
    term.clear()
    term.setCursorPos(1, 1)
    
end

function ScreenLoader:reload()

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

function ScreenLoader:displayFromString(ScreenLoaderString)

    local ScreenLoaderContent = textutils.unserialize(ScreenLoaderString)

    if type(ScreenLoaderContent) ~= "table" then

        error("Invalid ScreenLoader content format")

    end

    self:erase()

    for _, element in ipairs(ScreenLoaderContent) do

        if element.type == "button" then
            
            self:addButton(element.id, element.position.x1, element.position.y1, element.position.x2, element.position.y2, element.color, element.txt, element.txtposition.x, element.txtposition.y, element.txtColor)
            self:showButton(element.id)

        elseif element.type == "rectangle" then

            self:addRectangle(element.position.x1, element.position.y1, element.position.x2, element.position.y2, element.color, element.id)
            self:showRectangle(element.id)

        elseif element.type == "text" then

            self:addText(element.position.x, element.position.y, element.value, element.color, element.backgroundColor, element.id)
            self:showText(element.id)

        elseif element.type == "image" then
  
            self:addImage(element.position.x, element.position.y, element.img, element.id)
            
            if element.img ~= nil then

                self:showImage(element.id)
            
            end

        elseif element.type == "input" then

            self:addInput(element.id, element.position.x1, element.position.y1, element.position.x2, element.position.y2, element.color, element.txt, element.txtposition.x, element.txtposition.y, element.txtColor, element.mask)
            self:showInput(element.id)

        end
        
    end

end

-- fonctions en rapport avec les boutons
function ScreenLoader:addButton(id, x1, y1, x2, y2, color, texte, texteX, texteY, texteColor, fonction1, args, fonction2)
    
    if type(id) == "number" then

        self.buttonsTable[id] = Button:new(x1, y1, x2, y2, color, texte, texteX, texteY, texteColor, id, {fonction1, fonction2}, args)
        table.insert(self.reloadTable, {"button", id})

    else

        error("You must enter a int for the id")

    end
    
end

function ScreenLoader:showButton(id)

    if type(id) == "number" then

        if self.buttonsTable[id] ~= nil then

            self.buttonsTable[id]:show()

        end

    else

        error("You must enter a int for the id")

    end

end

function ScreenLoader:hideButton(id)

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
function ScreenLoader:addRectangle(x1, y1, x2, y2, color, id)
    
    if type(id) == "number" then

        self.rectangleTable[id] = Rectangle:new(x1, y1, x2, y2, color, id)
        table.insert(self.reloadTable,  {"rectangle", id})

    else

        error("You must enter a int for the id")

    end

end

function ScreenLoader:showRectangle(id)

    if type(id) == "number" then

        if self.rectangleTable[id] ~= nil then

            self.rectangleTable[id]:show()

        end

    else

        error("You must enter a int for the id")

    end

end

function ScreenLoader:hideRectangle(id)

    if type(id) == "number" then

        if self.rectangleTable[id] ~= nil then

            self.rectangleTable[id]:hide()

        end

    else

        error("You must enter a int for the id")

    end

end

-- fonction en rapport avec le texte
function ScreenLoader:addText(x1, y1, text, color, backgroundColor, id)
    
    if type(id) == "number" then

        self.textTable[id] = Text:new(x1, y1, text, color, backgroundColor, id)
        table.insert(self.reloadTable, {"text", id})

    else

        error("You must enter a int for the id")
    
    end

end

function ScreenLoader:showText(id)

    if type(id) == "number" then

        if self.textTable[id] ~= nil then

            self.textTable[id]:show()

        end

    else

        error("You must enter a int for the id")

    end

end

function ScreenLoader:hideText(id)

    if type(id) == "number" then

        if self.textTable[id] ~= nil then

            self.textTable[id]:hide()

        end

    else

        error("You must enter a int for the id")

    end

end

function ScreenLoader:changeTextValue(id, value)

    if type(id) == "number" then

        self.textTable[id]:changeValue(value)

    else

        error("You must enter a int for the id")

    end

end

function ScreenLoader:getTextValue(id)

    if type(id) == "number" then

        return self.textTable[id]:getValue()

    else

        error("You must enter a int for the id")

    end

end

-- fonction en rapport avec les images
function ScreenLoader:addImage(x, y, img, id)
    
    if type(id) == "number" then

        self.imageTable[id] = Image:new(x, y, "", id)
        self.imageTable[id]:setImage(img)
        table.insert(self.reloadTable, {"image", id})

    else

        error("You must enter a int for the id")

    end
end

function ScreenLoader:showImage(id)

    if type(id) == "number" then

        if self.imageTable[id] ~= nil then

            self.imageTable[id]:show()

        end

    else

        error("You must enter a int for the id")

    end

end

function ScreenLoader:hideImage(id)

    if type(id) == "number" then

        if self.imageTable[id] ~= nil then

            self.imageTable[id]:hide()

        end

    else

        error("You must enter a int for the id")

    end

end

function ScreenLoader:getImageSize(id)

    if type(id) == "number" then

        if self.imageTable[id] ~= nil then

            return self.imageTable[id]:size()

        end

    else

        error("You must enter a int for the id")

    end

end

function ScreenLoader:setPixel(id, x, y, color)

    if type(id) == "number" then

        if self.imageTable[id] ~= nil then

            return self.imageTable[id]:setPixel(x, y, color)

        end

    else

        error("You must enter a int for the id")

    end

end

function ScreenLoader:changeImagePosition(id, x, y)

    if type(id) == "number" then

        if self.imageTable[id] ~= nil then

            return self.imageTable[id]:changeImagePosition(x, y)

        end

    else

        error("You must enter a int for the id")

    end

end

function ScreenLoader:getImagePosition(id)

    if type(id) == "number" then

        if self.imageTable[id] ~= nil then

            return self.imageTable[id]:getImagePosition()

        end

    else

        error("You must enter a int for the id")

    end

end

function ScreenLoader:loadImage(id)

    if type(id) == "number" then

        if self.imageTable[id] ~= nil then

            self.imageTable[id]:load()

        end

    else

        error("You must enter a int for the id")

    end

end

-- fonctions en rapport avec les entree
function ScreenLoader:addInput(id, x1, y1, x2, y2, color, texte, texteX, texteY, texteColor, mask)
    
    if type(id) == "number" then

        self.inputTable[id] = Input:new(x1, y1, x2, y2, color, texte, texteX, texteY, texteColor, id, mask)
        table.insert(self.reloadTable, {"input", id})

    else

        error("You must enter a int for the id")

    end

end

function ScreenLoader:showInput(id)

    if type(id) == "number" then

        if self.inputTable[id] ~= nil then

            self.inputTable[id]:show()

        end

    else

        error("You must enter a int for the id")

    end

end

function ScreenLoader:hideInput(id)

    if type(id) == "number" then

        if self.inputTable[id] ~= nil then

            self.inputTable[id]:hide()

        end

    else

        error("You must enter a int for the id")

    end

end

function ScreenLoader:getInputValue(id)

    if type(id) == "number" then
        
        return self.inputTable[id]:getValue()

    else

        error("You must enter a int for the id")

    end

end