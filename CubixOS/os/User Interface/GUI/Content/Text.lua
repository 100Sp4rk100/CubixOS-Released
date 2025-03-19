-- importation du module de gestion des couleurs
dofile("os/User Interface/Colors/Get Color.lua")

-- importation du module de gestion des donnees syteme
dofile("os/File System Management/Data System Management/Data System Management.lua")

-- creation de la classe Texts
Text = {}
Text.__index = Text

-- constructeur
function Text:new(x, y, text, color, backgroundColor, id)

    local self = setmetatable({}, Text)

    -- definition des variables
    self.x = x
    self.y = y
    self.text = text
    self.color = color
    self.backgroundColor = backgroundColor
    self.id = id
    self.showed = false

    return self

end

-- methodes de la classe
function Text:show()

    self.showed = true
    paintutils.drawFilledBox(0, 0, 0, 0, getColor(self.backgroundColor))
    term.setTextColor(getColor(self.color))
    term.setCursorPos(self.x, self.y)
    term.write(self.text)

end

function Text:hide()

    self.showed = false
    paintutils.drawFilledBox(0, 0, 0, 0, getColor(getSystemVar("screencolor")))
    term.setTextColor(getColor(getSystemVar("screencolor")))
    term.setCursorPos(self.x, self.y)
    term.write(self.text)

end

function Text:getTextPosition()

    return {x = self.x, y = self.y}

end

function Text:isShowed()

    return self.showed

end

function Text:getId()

    return self.id

end

function Text:changeValue(value)

    self:hide()
    self.text = value
    self:show()

end

function Text:getValue()

    return self.text

end

function Text:getColor()

    return self.color

end

function Text:getBackgroundColor()

    return self.backgroundColor

end