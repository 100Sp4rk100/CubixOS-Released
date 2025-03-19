function deleteAnElement(path)

    if fs.exists(path) then

        fs.delete(path)

    else

        error("File or folder doesn't exist")

    end

end

function moveAnElement(originalPath, newPath)

    if fs.exists(originalPath) then

        fs.move(originalPath, newPath)

    else

        error("File or folder doesn't exist")

    end

end

function copyAnElement(originalPath, newPath, compact)

    if fs.exists(originalPath) then

        if fs.isDir(originalPath) then

            if not fs.exists(newPath) or compact then

                fs.makeDir(newPath)

                for _, item in ipairs(fs.list(originalPath)) do

                    local srcPath = fs.combine(originalPath, item)
                    local destPath = fs.combine(newPath, item)
                    
                    copyAnElement(srcPath, destPath, compact)
    
                end

            else

                copyAnElement(originalPath, newPath.."1", compact)

            end
            
        
        else

            local srcFile = fs.open(originalPath, "r")
            local destFile = fs.open(newPath, "w")

            if srcFile and destFile then

                destFile.write(srcFile.readAll())
                srcFile.close()

                destFile.close()
                
            else

                error("Can't open file !")

            end

        end

    else

        error("Orginal path doesn't exist ! : " .. originalPath)

    end

end