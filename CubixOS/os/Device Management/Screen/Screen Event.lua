-- importation du module de gestion du clavier
dofile("os/Device Management/Keyboard/keyboard.lua")

function detectScreenClics()

    local event, param1, param2, param3 = os.pullEvent()

    if event == "mouse_click" then

        return "clic", param2, param3, param1
    
    elseif event == "char" then

        return "key", param1

    else

        return false

    end

end

function isClickInArea(x1, y1, x2, y2, clickX, clickY)

    return clickX >= x1 and clickX <= x2 and clickY >= y1 and clickY <= y2

end