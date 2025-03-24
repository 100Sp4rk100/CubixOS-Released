dofile("server/system/Data System Management.lua")
dofile("server/system/KeyGestion.lua")
dofile("server/system/File Gestion.lua")

if not fileExists("server/var/SystemVar.sys") then

    createFile("server/var/SystemVar.sys")

end

addSystemKey("varkey", generateRandomKey(30))
addSystemVar("static-ip", "nil")

print("SETUP COMPLETE !")
print("You can execute : ")
print("rm server-compiled")
print("rm SETUP.lua")
print("rm decompiler.lua")
print("Then you can reboot your server now !")