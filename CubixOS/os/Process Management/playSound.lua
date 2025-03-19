-- importation du module de gestion des donnees systeme
dofile("os/File System Management/Data System Management/Data System Management.lua")

function playAudioFile(filePath, sysVar)

    if getSystemVar(sysVar) == nil then

        stopPlayback = false

    elseif getSystemVar(sysVar) == "true" then
        
        stopPlayback = false
    
    elseif getSystemVar(sysVar) == "false" then
        
        stopPlayback = true

    else

        stopPlayback = false

    end

    if fs.exists(filePath) and not fs.isDir(filePath) then

        local speaker = peripheral.find("speaker")

        if speaker then
            
            local dfpwm = dofile("os/Default Programs/dfpwm.lua")
            local decoder = dfpwm.make_decoder()

            local function playBuffer(buffer)

                while not speaker.playAudio(buffer) do

                    if getSystemVar(sysVar) == nil then

                        stopPlayback = false
                
                    elseif getSystemVar(sysVar) == "true" then
                
                        stopPlayback = false
                    
                    elseif getSystemVar(sysVar) == "false" then
                
                        stopPlayback = true
                
                    else
                
                        stopPlayback = false
                
                    end

                    if stopPlayback then

                        return
                    
                    end

                    os.pullEvent("speaker_audio_empty")

                end

            end

            for chunk in io.lines(filePath, 16 * 1024) do
                
                if getSystemVar(sysVar) == nil then

                    stopPlayback = false
            
                elseif getSystemVar(sysVar) == "true" then
            
                    stopPlayback = false
                
                elseif getSystemVar(sysVar) == "false" then
            
                    stopPlayback = true
            
                else
            
                    stopPlayback = false
            
                end

                if stopPlayback then

                    break 

                end

                local buffer = decoder(chunk)
                playBuffer(buffer)
                sleep(0.05)

            end

        end

    end

end