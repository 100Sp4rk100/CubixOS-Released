dofile("os/File System Management/Data System Management/Data System Management.lua")

print("Enter app name : ")
local name = io.read()

print("Enter app id : ")
local id = io.read()

addSystemData("ApplicationList", {name..":"..id}, getSystemKey("ApplicationList"))