AddCSLuaFile()

-- Uhh - Don't use this, I removed the await function a while back, doesn't work correctly anymore  

function await(coroutine)
    
end

function async( callback, ... )

    local packedArguments = { ... }

    return callback( unpack( packedArguments ) )
end 
