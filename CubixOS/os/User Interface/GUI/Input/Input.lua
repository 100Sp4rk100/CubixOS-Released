-- importation du module de gestion des couleurs
dofile("os/User Interface/Colors/Get Color.lua")

-- importation du module de gestion des donnees syteme
dofile("os/File System Management/Data System Management/Data System Management.lua")

-- importation du module de gestion de chaine de caracteres
dofile("os/File System Management/String Gestion/String Gestion.lua")

-- importation du module de gestion du clavier
dofile("os/Device Management/Keyboard/keyboard.lua")

-- creation de la classe Inputs
Input = {}
Input.__index = Input

-- constructeur
function Input:new(x1, y1, x2, y2, color, texte, texteX, texteY, texteColor, id, mask)

    local self = setmetatable({}, Input)

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
    self.mask = mask
    self.value = ""
    self.valueShow = ""
    self.showed = false

    return self

end

-- methodes de la classe
function Input:show()

    self.showed = true
    paintutils.drawFilledBox(self.x1, self.y1, self.x2, self.y2, getColor(self.color))
    self:showValueInput()

end

function Input:hide()

    self.showed = false
    paintutils.drawFilledBox(self.x1, self.y1, self.x2, self.y2, getColor(getSystemVar("screencolor")))

end

function Input:getInputPosition()

    return {x1 = self.x1, y1 = self.y1, x2 = self.x2, y2 = self.y2}

end

function Input:isShowed()

    return self.showed

end

function Input:getId()

    return self.id

end

function Input:action()

    paintutils.drawFilledBox(self.x1, self.y1, self.x2, self.y2, getColor(self.color))
    term.setTextColor(getColor(self.texteColor))
    term.setCursorPos(self.x1 + self.texteX, self.y1 + self.texteY)

    self.char = ""
    self.value = ""
    self.valueShow = ""

    while self.char ~= "\n" do

        self.char = getKeyboardCaractere()

        if self.char ~= nil then

            if self.char == "%%" then
                
                if self.mask == "" then

                    self.value = extractChar(self.value, 1, #self.value - 1)
                    self.valueShow = extractChar(self.value, 1, #self.value)
                    self:showValueInput()

                else

                    self.value = extractChar(self.value, 1, #self.value - 1)
                    self.valueShow = extractChar(self.valueShow, 1, #self.valueShow - #self.mask)
                    self:showValueInput()

                end

            elseif self.char ~= "\t" and self.char ~= "§§§" and self.char ~= "\n" then

                if self.mask == "" then

                    self.value = self.value .. self.char
                    self.valueShow = self.valueShow .. self.char
                    self:showValueInput()

                else

                    self.value = self.value .. self.char
                    self.valueShow = self.valueShow .. self.mask
                    self:showValueInput()

                end

            end

        end

    end

end

function Input:getValue()

    return self.value

end

function Input:showValueInput()

    paintutils.drawFilledBox(self.x1, self.y1, self.x2, self.y2, getColor(self.color))
    term.setTextColor(getColor(self.texteColor))
    term.setCursorPos(self.x1 + self.texteX, self.y1 + self.texteY)

    if self.value == "" then
        term.write(self.texte)

    else

        if #self.valueShow <= self.x2-self.x1 - 2*self.texteX then

            term.write(self.valueShow)

        else

            term.write(extractChar(self.valueShow, #self.valueShow - (self.x2-self.x1 - 2*self.texteX), #self.valueShow))

        end

    end

end

function Input:getColor()

    return self.color

end

function Input:getTextColor()

    return self.texteColor

end

function Input:getText()

    return self.texte

end

function Input:getTextPosition()

    return {x = self.texteX, y = self.texteY}

end

function Input:getMask()

    return self.mask

end