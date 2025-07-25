MUnbox.Inventory = MUnbox.Inventory or {}

if ( CLIENT ) then 
    
    MUnbox.GetInventory = function()

        return MUnbox.Inventory
    end

    MUnbox.GetItem = function( id )

        if ( not isnumber( id ) ) then return end 

        local foundInventory = MUnbox.GetInventory()

        for k = 1, #foundInventory do 
            local inventoryRow = foundInventory[k]
            if ( not istable( inventoryRow ) ) then continue end 

            local foundID = inventoryRow.id 
            if ( not foundID ) then continue end 

            if ( id == foundID ) then 

                return inventoryRow
            end
        end
    end

    MUnbox.AddToInventory = function( id, itemID, itemRarity, isCrate, isEquiped, uses )

        if ( not isnumber( id ) or not isstring( itemID ) or not isstring( itemRarity ) ) then return end 

        if ( not MUnbox.GetRarity( itemRarity ) ) then return end 
        
        uses = ( isnumber( uses ) and uses ) or -1

        local index = #MUnbox.Inventory + 1 

        local inventoryStruct = {

            ["id"] = id, 
            ["itemID"] = itemID, 

            ["itemRarity"] = itemRarity, 
            
            ["isCrate"] = isCrate or false, 
            ["isEquiped"] = isEquiped or false, 
            
            ["Uses"] = uses, 
        }

        MUnbox.Inventory[index] = inventoryStruct

        hook.Run( "MonkeyUnbox:Inventory:Added", index, inventoryStruct )

        return inventoryStruct
    end

    MUnbox.RemoveFromInventory = function( id )

        if ( not isnumber( id ) ) then return end 

        local foundInventory = MUnbox.GetInventory()

        for k = 1, #foundInventory do 

            local inventoryRow = foundInventory[k]
            if ( not istable( inventoryRow ) ) then continue end 

            local sqlID = inventoryRow.id 
            if ( not isnumber( sqlID ) ) then continue end 

            if ( sqlID == id ) then 

                table.remove( foundInventory, k )

                hook.Run( "MonkeyUnbox:Inventory:Removed", k, inventoryRow )

                break 
            end
        end
    end
    
    return 
end  

local addToEquipStack = function( ply, id, itemID, uses )

    if ( not IsValid( ply ) or not itemID ) then 
        
        return false, "item_equip_fail" 
    end 

    ply.MUnbox_Heap = ply.MUnbox_Heap or {} 

    local foundItem = ply.MUnbox_Heap[itemID] 

    if ( istable( foundItem ) ) then 
        
        return false, "item_equip_dupe" 
    end 

    ply.MUnbox_Heap[itemID] = {
        ["Uses"] = uses, 
        ["id"] = id, 
    }

    return true, "item_equip_success"
end

local removeFromEquipStack = function( ply, itemID )

    if ( not IsValid( ply ) or not itemID ) then 
        
        return false, "item_unequip_fail" 
    end 

    ply.MUnbox_Heap = ply.MUnbox_Heap or {} 

    ply.MUnbox_Heap[itemID] = nil  

    ply:StripWeapon( itemID )

    return true, "item_unequip_success"
end

function MUnbox.Inventory:GetItem( steamID64, id )

    if ( not MonkeyLib.isSteamID64( steamID64 ) or not isnumber( id ) ) then 
        
        return false 
    end 

    local foundItem = MonkeyLib.SQL:QueryRow( "SELECT itemID, itemRarity, isCrate, isEquiped, uses FROM munbox_inventory WHERE steamID64 = %s AND id = %s;", {
        steamID64, 
        id
    } ) or {}
    
    if ( not foundItem.itemID or not foundItem.itemRarity or not foundItem.isCrate or not foundItem.isEquiped or not foundItem.uses ) then 
        
        return false 
    end 
    
    do 

        foundItem.id = id 

        foundItem.isCrate = tobool( foundItem.isCrate )

        foundItem.isEquiped = tobool( foundItem.isEquiped ) 
    
        foundItem.Uses = tonumber( foundItem.uses )


    end 

    return foundItem 
end

function MUnbox.Inventory:GetInventory( steamID64 )

    if ( not MonkeyLib.isSteamID64( steamID64 ) ) then return end 
    
    local query = MonkeyLib.SQL:Query( "SELECT id, itemID, itemRarity, isCrate, isEquiped, uses FROM munbox_inventory WHERE steamID64 = %s;", { steamID64 } )

    return query 
end

function MUnbox.Inventory:GetInventorySize( steamID64 )
    
    if ( not MonkeyLib.isSteamID64( steamID64 ) ) then return 0 end 
    
    local query = MonkeyLib.SQL:Query( "SELECT id FROM munbox_inventory WHERE steamID64 = %s;", { steamID64 } )
    if ( not istable( query ) ) then return 0 end 

    return #query 
end

function MUnbox.Inventory:InsertIntoInventory( steamID64, itemID, itemRarity, isCrate, uses )

    assert( MonkeyLib.isSteamID64( steamID64 ), "Failed to insert data, SteamID64 is malformed!" )
    
    assert( isstring( itemID ), "Failed to insert data, ItemID is malformed!" )
    
    assert( isstring( itemRarity ) and istable( MUnbox.GetRarity( itemRarity ) ), "Failed to insert data, Item rarity is malformed!" )

    uses = ( isnumber( uses ) and uses ) or -1 

    MonkeyLib.SQL:Query( "INSERT INTO munbox_inventory ( steamID64, itemID, itemRarity, isCrate, isEquiped, uses ) VALUES( %s, %s, %s, %s, %d, %d );", {

        steamID64, itemID, itemRarity, isCrate or false, 0, uses

    } )

    local sqlID = MonkeyLib.SQL:QueryValue( "SELECT last_insert_rowid()" ) 
    sqlID = tonumber( sqlID )

    return sqlID 
end

function MUnbox.Inventory:RemoveFromInventory( steamID64, id ) 

    assert( MonkeyLib.isSteamID64( steamID64 ), "Failed to remove item, SteamID64 is malformed!" )

    assert( isnumber( id ), "Failed to remove item, ID is malformed!" )

    MonkeyLib.SQL:Query( "DELETE FROM munbox_inventory WHERE steamID64 = %s AND id = %s;", {

        steamID64, id, 

    } )

end

function MUnbox.Inventory:AddToInventory( ply, itemID, itemRarity, isCrate, uses ) 

    if ( not IsValid( ply ) or not itemID or not itemRarity ) then 
        
        return  
    end 
            
    local steamID64 = ply:SteamID64()

    uses = ( isnumber( uses ) and uses ) or -1

    local id = MUnbox.Inventory:InsertIntoInventory( steamID64, itemID, itemRarity, isCrate, uses )

    MonkeyNet.WriteStructure( "MUnbox:Inventory:SendItem", MUnbox.NetStructures.SendInventoryItem, { 

        id, itemID, itemRarity, isCrate, uses

    }, ply )

    hook.Run( "MonkeyUnbox:Inventory:Added", ply, itemID, id ) 

end

function MUnbox.Inventory:EquipItem( ply, id ) // needs improvements, didn't fully think this function through. 

    if ( not IsValid( ply ) or not isnumber( id ) ) then 
        
        return false, "item_equip_fail"
    end 

    if ( not ply:Alive() ) then 

        return false, "item_equip_fail"
    end

    local steamID64 = ply:SteamID64()

    local itemInfo = MUnbox.Inventory:GetItem( steamID64, id )

    if ( not istable( itemInfo ) or itemInfo.isCrate ) then 
        
        return false, "item_equip_fail"
    end 

    local itemID, isEquip, uses = itemInfo.itemID, itemInfo.isEquiped, itemInfo.Uses    

    local infiniteUses = ( uses == -1 )

    if ( ( not isEquip ) and ( not infiniteUses ) ) then 
       
        uses = uses - 1

        uses = math.max( uses, 0 )
        
    end

    local success, errorMessage = false, "item_equip_fail" 

    if ( isEquip ) then 

        success, errorMessage = removeFromEquipStack( ply, itemID )

    else 

        success, errorMessage = addToEquipStack( ply, id, itemID, uses )

    end

    if ( success and ( isEquip == false ) and ( uses <= 0 and ( not infiniteUses ) ) ) then 

        do 

            removeFromEquipStack( ply, itemID ) 

            ply:Give( itemID ) 
    
        end

        MUnbox.Inventory:DeleteFromInventory( ply, id )

        return true, "item_equip_success" // Change this message! 
    end

    if ( success ) then 
        
        MonkeyLib.SQL:Query( "UPDATE munbox_inventory SET isEquiped = %s, uses = %s WHERE id = %s AND steamID64 = %s;", { not isEquip, uses, id, steamID64 } )

        MonkeyNet.WriteStructure( "MUnbox:Inventory:EquipItem", MUnbox.NetStructures.SendEquipItem, { id, itemID, not isEquip }, ply )

        do // Function wrapper 

            local equipFunc = ( ( isEquip and ply.StripWeapon ) or ply.Give ) or function() end  

            equipFunc( ply, itemID )

        end

        hook.Run( "MonkeyUnbox:Inventory:Equiped", ply, itemInfo, not isEquip ) 

    end

    return success, errorMessage
end

function MUnbox.Inventory:DeleteFromInventory( ply, id )

    if ( not IsValid( ply ) or not isnumber( id ) ) then 

        return false, "item_delete_fail" 
    end 
    
    local steamID64 = ply:SteamID64()

    local itemInfo = MUnbox.Inventory:GetItem( steamID64, id )
    
    if ( not istable( itemInfo ) ) then   

        return false, "item_delete_fail" 
    end

    if ( itemInfo.isEquiped ) then 

        removeFromEquipStack( ply, itemInfo.itemID )

    end

    MUnbox.Inventory:RemoveFromInventory( steamID64, id )

    MonkeyNet.WriteStructure( "MUnbox:Inventory:DeleteItem", MUnbox.NetStructures.DeleteInventoryItem, { 

        id,

    }, ply )

    hook.Run( "MonkeyUnbox:Inventory:Removed", ply, itemInfo )

    return true, "item_delete_success"
end

function MUnbox.Inventory:SendInventory( ply )
    
    if ( not IsValid( ply ) ) then return end
     
    async( function ()
            
        local playerName, steamID64 = ply:Name(), ply:SteamID64()

        MonkeyLib.Debug( false, "%s | %s Sending Unbox inventory.", steamID64, playerName )

        local items = MUnbox.Inventory:GetInventory( steamID64 )
        
        if ( istable( items ) and #items >= 1 ) then

            net.Start( "MUnbox:Inventory:SendInventory" )

                for k = 1, #items do 

                    local itemRow = items[k]

                    if ( not istable( itemRow ) ) then 
                            
                        continue 
                    end 

                    local id, itemID, itemRarity, isCrate, isEquiped, uses = itemRow.id, itemRow.itemID, itemRow.itemRarity, itemRow.isCrate, itemRow.isEquiped, itemRow.uses 
                    
                    if ( not id or not itemID or not itemRarity or not isCrate or not isEquiped or not uses ) then 
                        
                        continue 
                    end 

                    do 
    
                        id = tonumber( id )

                        uses = tonumber( uses )
                    
                    end

                    do 

                        isCrate = tobool( isCrate )

                        isEquiped = tobool( isEquiped )

                    end
                    
                    if ( isEquiped ) then 

                        local succ = addToEquipStack( ply, id, itemID, uses )
                        
                        if ( succ ) then 
                            
                            ply:Give( itemID ) 
                        
                        end 
                        
                    end

                    net.WriteUInt( id, 32 )

                    net.WriteString( itemID )
                    net.WriteString( itemRarity )

                    net.WriteBool( isCrate )
                    net.WriteBool( isEquiped )

                    net.WriteInt( uses, 16 )

                    net.WriteBool( true )

                end

                net.WriteBool( false )

            net.Send( ply )
        end

    end )
end



