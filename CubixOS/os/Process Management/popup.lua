--importation du module d'execution d'application
dofile("os/Process Management/launchApplication.lua")

function newPopup(msg, sound)

    runApplication("popup", "popup", {msg, sound})

end