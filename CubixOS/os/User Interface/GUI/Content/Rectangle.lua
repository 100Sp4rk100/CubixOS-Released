-- importation du module de gestion des couleurs
dofile("os/User Interface/Colors/Get Color.lua")

-- importation du module de gestion des donnees syteme
dofile("os/File System Management/Data System Management/Data System Management.lua")

-- creation de la classe Rectangles
Rectangle = {}
Rectangle.__index = Rectangle

-- constructeur
function Rectangle:new(x1, y1, x2, y2, color, id)

    local self = setmetatable({}, Rectangle)

    -- definition des variables
    self.x1 = x1
    self.x2 = x2
    self.y1 = y1
    self.y2 = y2
    self.color = color
    self.id = id
    self.showed = false

    return self

end

-- methodes de la classe
function Rectangle:show()

    self.showed = true
    paintutils.drawFilledBox(self.x1, self.y1, self.x2, self.y2, getColor(self.color))

end

function Rectangle:hide()

    self.showed = false
    paintutils.drawFilledBox(self.x1, self.y1, self.x2, self.y2, getColor(getSystemVar("screencolor")))

end

function Rectangle:getRectanglePosition()

    return {x1 = self.x1, y1 = self.y1, x2 = self.x2, y2 = self.y2}

end

function Rectangle:isShowed()

    return self.showed

end

function Rectangle:getId()

    return self.id

end

function Rectangle:getColor()

    return self.color

end