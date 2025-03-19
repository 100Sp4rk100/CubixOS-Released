function detectMouse()

    local event, side, x, y = os.pullEvent()

    if event == "mouse_drag" then

        return true, x, y

    else

        return false

    end

end