-- importation du module de gestion des couleurs
dofile("os/User Interface/Colors/Get Color.lua")

-- importation du module de gestion des donnees syteme
dofile("os/File System Management/Data System Management/Data System Management.lua")

-- creation de la classe Buttons
Button = {}
Button.__index = Button

-- constructeur
function Button:new(x1, y1, x2, y2, color, texte, texteX, texteY, texteColor, id, fonction, args)

    local self = setmetatable({}, Button)

    -- definition des variables
    self.x1 = x1
    self.x2 = x2
    self.y1 = y1
    self.y2 = y2
    self.color = color
    self.texte = texte
    self.texteX = texteX
    self.texteY = texteY
    self.texteColor = texteColor
    self.id = id
    self.fonction = fonction
    self.showed = false

    if args == nil then

        self.args = {{}, {}}

    else

        self.args = args

    end

    return self

end

-- methodes de la classe
function Button:show()

    self.showed = true
    
    if self.color ~= "" then
        paintutils.drawFilledBox(self.x1, self.y1, self.x2, self.y2, getColor(self.color))
    end

    if self.texteColor ~= "" then
        term.setTextColor(getColor(self.texteColor))
        term.setCursorPos(self.x1 + self.texteX, self.y1 + self.texteY)
        term.write(self.texte)
    end

end

function Button:hide()

    self.showed = false
    paintutils.drawFilledBox(self.x1, self.y1, self.x2, self.y2, getColor(getSystemVar("screencolor")))

end

function Button:getButtonPosition()

    return {x1 = self.x1, y1 = self.y1, x2 = self.x2, y2 = self.y2}

end

function Button:isShowed()

    return self.showed

end

function Button:getId()

    return self.id

end

function Button:action(num)

    if self.fonction[num] ~= nil then

        self.fonction[num](self.args[num])
        
    end

end

function Button:getColor()

    return self.color

end

function Button:getTextColor()

    return self.texteColor

end

function Button:getText()

    return self.texte

end

function Button:getTextPosition()

    return {x = self.texteX, y = self.texteY}

end