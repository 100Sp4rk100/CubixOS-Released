-- importation du module de gestion des donnees syteme
dofile("os/File System Management/Data System Management/Data System Management.lua")
-- importation du module de gestion global
dofile("os/File System Management/Global/Global.lua")
-- importation du module de gestion cles
dofile("os/Security Management/KeyGestion/KeyGestion.lua")
--importation du module de gestion des popups
dofile("os/Process Management/popup.lua")

function installPackage(packageInfoPath)
    
    packageInfo = getData(packageInfoPath.."/Package.inf")

    if getDataValue(packageInfo, "type") == "app" and getDataValue(packageInfo, ".app") ~= nil and getDataValue(packageInfo, "id") ~= nil and getDataValue(packageInfo, "name") ~= nil and packageInfo ~= nil and getDataValue(packageInfo, "type") ~= nil then

        copyAnElement(packageInfoPath.."/"..getDataValue(packageInfo, ".app"), "os/Applications/"..getDataValue(packageInfo, "id")..".app", true)
        
        if getDataValue(packageInfo, "logo") ~= nil then

            copyAnElement(packageInfoPath.."/"..getDataValue(packageInfo, "logo"), "os/OS DATA/App/"..getDataValue(packageInfo, "id").."/"..getDataValue(packageInfo, "logo"), true)
            createFile("os/OS DATA/App/"..getDataValue(packageInfo, "id").."/"..getDataValue(packageInfo, "id")..".dat")
            addTextInFile("os/OS DATA/App/"..getDataValue(packageInfo, "id").."/"..getDataValue(packageInfo, "id")..".dat", "logo=os/OS Data/App/"..getDataValue(packageInfo, "id").."/"..getDataValue(packageInfo, "logo"))

        end

        if getDataValue(packageInfo, "data") ~= nil then

            copyAnElement(packageInfoPath.."/"..getDataValue(packageInfo, "data"), "os/OS DATA/App/"..getDataValue(packageInfo, "id").."/"..getDataValue(packageInfo, "data"), true)

            if getDataValue(packageInfo, "logo") == nil then

                createFile("os/OS DATA/App/"..getDataValue(packageInfo, "id").."/"..getDataValue(packageInfo, "id")..".dat")

            end

            addTextInFile("os/OS DATA/App/"..getDataValue(packageInfo, "id").."/"..getDataValue(packageInfo, "id")..".dat", "data=os/OS DATA/App/"..getDataValue(packageInfo, "id").."/"..getDataValue(packageInfo, "data"))

        end

        addSystemData("ApplicationList", {getDataValue(packageInfo, "name")..":"..getDataValue(packageInfo, "id")}, getSystemKey("ApplicationList"))

        newPopup("installation completed", "os/OS DATA/Sounds/button-pressed.dfpwm")
    
    elseif getDataValue(packageInfo, "type") == "library" and getDataValue(packageInfo, ".library") ~= nil then

        copyAnElement(packageInfoPath.."/"..getDataValue(packageInfo, ".library"), "os/Libraries/"..getDataValue(packageInfo, ".library"), true)

        newPopup("installation completed", "os/OS DATA/Sounds/button-pressed.dfpwm")

    else

        newPopup("An error occured in the instalation !", "os/OS DATA/Sounds/error.dfpwm")

    end

end