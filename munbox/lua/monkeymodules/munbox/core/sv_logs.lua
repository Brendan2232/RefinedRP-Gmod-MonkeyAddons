require( "mlogs" )

assert( istable( MonkeyLogs ), "Failed to load Unbox Logs, module doesn't exist." ); 

local log = MonkeyLogs.NewLog()
log:SetTitle( "MUnbox" )

local unboxLog = function( logLookup, ... )

    assert( IsValid( log ), "Log isn't valid." )

    local logReference = MUnbox.Config.Logs[logLookup]
    
    assert( logReference, "Failed to find log reference." )

    do 
        
        MonkeyLib.Debug( false, logReference, ... )

        log:Log( logReference, ... )

    end 

end

local commitLog = function()

    assert( IsValid( log ), "Log isn't valid." )

    log:Commit()

end

do 

    hook.Protect( "MonkeyUnbox:Inventory:UnboxFromInventory", "MonkeyUnbox:Logs:ItemUnbox", function( ply, crateStructure )

        assert( IsValid( ply ), "Player isn't valid." ) // hook.Protect to save the day!
        
        assert( istable( crateStructure ), "Crate Structure is malformed!" )

        local crateID = crateStructure.itemID or "NULL"

        local name, steamID64 = ply:Name(), ply:SteamID64()
    
        unboxLog( "unbox_crate", steamID64, name, crateID )
    
        commitLog()

    end )
    
    hook.Protect( "MonkeyUnbox:Inventory:PurchaseCrate", "MonkeyUnbox:Logs:PurchaseCrate", function( ply, crateID, crateStructure )

        assert( IsValid( ply ), "Player isn't valid." ) // hook.Protect to save the day!

        assert( crateID, "Crate ID is malformed!" )
        
        assert( istable( crateStructure ), "Crate Structure is malformed!" )

        local cratePrice = crateStructure.Price or 0

        local name, steamID64 = ply:Name(), ply:SteamID64()
    
        unboxLog( "purchase_crate", steamID64, name, crateID, MonkeyLib.FormatMoney( cratePrice ) )
    
        commitLog()

    end )
    
end

do 

    hook.Protect( "MonkeyUnbox:Inventory:Added", "MonkeyUnbox:Logs:AddedItem", function( ply, itemID  )

        assert( IsValid( ply ), "Player isn't valid." ) // hook.Protect to save the day!
    
        assert( isstring( itemID ), "Item ID is malformed!" ) 
    
        local name, steamID64 = ply:Name(), ply:SteamID64()
    
        unboxLog( "item_added", steamID64, name, itemID )
    
        commitLog()

    end )
    
    hook.Protect( "MonkeyUnbox:Inventory:Removed", "MonkeyUnbox:Logs:RemoveItem", function( ply, itemStructure  )

        assert( IsValid( ply ), "Player isn't valid." ) // hook.Protect to save the day!
    
        assert( istable( itemStructure ), "Item Structure is malformed!" ) 
    
        local itemID = itemStructure.itemID or "NULL"

        local name, steamID64 = ply:Name(), ply:SteamID64()
    
        unboxLog( "item_deleted", steamID64, name, itemID )
    
        commitLog()
        
    end )
 
end

