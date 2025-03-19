dofile("os/File System Management/Data System Management/Data System Management.lua")
dofile("os/Security Management/KeyGestion/KeyGestion.lua")
dofile("os/Security Management/Encryptor/Encryptor.lua")
dofile("os/File System Management/File Gestion/File Gestion.lua")
dofile("os/File System Management/Global/Global.lua")

if not fileExists("os/OS DATA/Var/SystemVar.sys") then

    createFile("os/OS DATA/Var/SystemVar.sys")

end

addSystemKey("varkey", generateRandomKey(30))
addSystemVar("screencolor", "blue")
addSystemVar("logintry", "5")
addSystemVar("specificExplorerReturn", "")
addSystemVar("static-ip", "nil")
addSystemVar("os-time", "0")
addSystemVar("crypt-ip", "default")
addSystemVar("protocol-ip", "default")
addSystemVar("domain-ip", "")
addSystemVar("ALT-IP", "")
addSystemKey("Password", generateRandomKey(100))
addSystemKey("ApplicationList", generateRandomKey(100))
addSystemKey("OsGeneralEventKey", generateRandomKey(100))

application = {"Settings:osSettings", "Explorer:fileExplorer", "Admin Check:adminCheck", "Image Viewer:imageViewer", "Text Viewer:textViewer", "Sound Player:soundPlayer", "Popup:popup", "Web:web", "Screen Sharing:screensharing", "Loading Screen:loadingScreen"}
addSystemData("ApplicationList", application, getSystemKey("ApplicationList"))

createFile("os/OS DATA/Data/OsGeneralEvent.sys")

login = {}
print("Enter your new password : ")
local userInput = io.read()
table.insert(login, "password:::"..userInput)

print("Enter admin new password : ")
local userInput = io.read()
table.insert(login, "passwordAdmin:::"..userInput)

addSystemData("Login", login, getSystemKey("Password"))

term.clear()
term.setCursorPos(1, 1)

copyAnElement("os/startup.lua", "startup.lua")
fs.delete("os/startup.lua")

print("SETUP COMPLETE !")
print("You can execute : ")
print("rm os-compiled")
print("rm SETUP.lua")
print("rm install-os.lua")
print("Then you can reboot your computer now !")