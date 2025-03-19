-- importation du module de gestion des couleurs
dofile("os/User Interface/Colors/Get Color.lua")

-- importation du module de gestion des donnees syteme
dofile("os/File System Management/Data System Management/Data System Management.lua")

-- importation du module de gestion de fichier
dofile("os/File System Management/File Gestion/File Gestion.lua")

-- importation du module de gestion de chaine de caracteres
dofile("os/File System Management/String Gestion/String Gestion.lua")

-- creation de la classe Image
Image = {}
Image.__index = Image

-- constructeur
function Image:new(x, y, path, id)

    local self = setmetatable({}, Image)

    -- definition des variables
    self.x = x
    self.y = y
    self.path = path
    self.image = nil
    self.showed = false
    self.id = id

    return self

end

-- methodes de la classe
function Image:show()

    term.setBackgroundColor(colors.blue)

    self.showed = true

    self.y1 = self.y

    for i = 1, tonumber(split(self.image[2], "=")[2]) do
        self.x1 = self.x
        self.line = self.image[i+2]
        self.bytwo = splitByTwo(self.line)

        for i = 1, tonumber(split(self.image[1], "=")[2]) do

            if getImageColor(self.bytwo[i]) ~= "" then
                term.setBackgroundColor(getImageColor(self.bytwo[i]))
                term.setCursorPos(self.x1, self.y1)
                write(" ")
            end

            self.x1 = self.x1 + 1

        end

        self.y1 = self.y1 + 1

    end

end

function Image:hide()

    self.showed = false

    paintutils.drawFilledBox(self.x, self.y, self.x + tonumber(split(self.image[2], "=")[2])+1, self.y + tonumber(split(self.image[1], "=")[2]), getColor(getSystemVar("screencolor")))

end

function Image:load()

    if path ~= "!NUL!" then

        self.image = readFile(self.path)

    end

end

function Image:setImage(img)
    
    self.image = img

end

function Image:getImage()

    return self.image

end

function Image:getImagePosition()

    return {["x"] = self.x, ["y"] = self.y}

end

function Image:isShowed()

    return self.showed

end

function Image:getId()

    return self.id

end

function Image:size()

    return {["width"] = getDataValue(self.image, "width"), ["height"] = getDataValue(self.image, "height")}

end

function Image:setPixel(x, y, color)

    if x > tonumber(getDataValue(self.image, "width")) then

        local add = string.rep("00", x - tonumber(getDataValue(self.image, "width")))

        for i = 3, #self.image do

            local line = self.image[i]
            local currentWidth = #splitByTwo(line)

            if currentWidth < x then

                self.image[i] = line .. string.rep("00", x - currentWidth)

            end

        end

        self.image[1] = "width=" .. x

    end

    if y > tonumber(getDataValue(self.image, "height")) then

        local add = string.rep("00", tonumber(getDataValue(self.image, "width")))

        for i = tonumber(getDataValue(self.image, "height")) + 1, y do

            self.image[i + 2] = add

        end

        self.image[2] = "height=" .. y

    end

    local add = ""
    local content = splitByTwo(self.image[y + 2])

    for i = 1, tonumber(getDataValue(self.image, "width")) do

        if i == x then

            add = add .. color

        else

            add = add .. (content[i] or "00")

        end

    end

    self.image[y + 2] = add

    changeData(self.path, self.image)
    self:load()
    self:show()
end

function Image:changeImagePosition(x, y)

    self.x = x
    self.y = y

end