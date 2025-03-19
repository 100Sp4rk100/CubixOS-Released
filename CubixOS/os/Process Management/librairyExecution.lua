function runLib(libName, mainFunctionName, args)

    local filePath = "os/Libraries/" .. libName .. ".lib"

    local chunk = loadfile(filePath)

    if not chunk then

        error("Error in loading of " .. filePath)

    end

    local success, execErr = pcall(chunk)

    if not success then

        error("Error in execution of " .. filePath .. ": " .. execErr)

    end

    if type(_G[mainFunctionName]) == "function" then

        args = args or {}
        return _G[mainFunctionName](args)

    end

end