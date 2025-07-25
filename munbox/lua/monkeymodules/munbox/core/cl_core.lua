require( "memoize" )
require("async")

MUnbox.CachedKnifes = MUnbox.CachedKnifes or {}

MUnbox.GetWeapon = function( weaponID ) 
    
    return MUnbox.CachedKnifes[weaponID] or false
end

local sortCagetoryItems = function( categoryID )

    if ( not isstring( categoryID ) ) then 

        return
    end

    local packedCrates = {}
    
    local storeItems = MUnbox.Crates

    for i = 1, #storeItems do 

        local storeRow = storeItems[i]

        if ( not istable( storeRow ) ) then 

            continue 
        end

        local crateCategoryID = storeRow.Category

        if ( crateCategoryID ~= categoryID ) then 
            
            continue 
        end

        do 

            local index = #packedCrates + 1 

            packedCrates[index] = storeRow 

            packedCrates[index].originalIndex = i 

        end

    end

    return packedCrates
end

MUnbox.GetCategoryCrates = memoize( function( categoryID ) 

    local categories = ( MUnbox.Categories or {} )[categoryID]

    categoryID = ( istable( categories ) and categories.id ) or categoryID
    
    return sortCagetoryItems( categoryID )
end, {} )

local loadIcons = function()

    for k = 1, #MUnbox.Icons do 

        local iconRow = MUnbox.Icons[k]

        if ( not iconRow ) then 
            
            continue 
        end 

        local iconID, iconLink, iconParamaters = iconRow.iconID, iconRow.iconLink, iconRow.iconParamaters

        MonkeyLib:LoadIcon( iconID, {

            ["iconLink"] = iconLink, 
            ["iconParamaters"] = iconParamaters, 
            
        } )
    end
end

net.Receive( "MUnbox:Inventory:SendInventory", function()

    table.Empty( MUnbox.Inventory )

    local startRead = true 

    while ( startRead ) do

        local id, itemID, itemRarity, isCrate, isEquiped, uses = net.ReadUInt( 32 ), net.ReadString(), net.ReadString(), net.ReadBool(), net.ReadBool(), net.ReadInt( 16 )
 
        MUnbox.AddToInventory( id, itemID, itemRarity, isCrate, isEquiped, uses )

        startRead = net.ReadBool()
    end

end )

MonkeyNet.ReadStructure( "MUnbox:Inventory:SendItem", MUnbox.NetStructures.SendInventoryItem, function( id, itemID, itemRarity, isCrate, uses )

    MUnbox.AddToInventory( id, itemID, itemRarity, isCrate, false, uses )

end )

MonkeyNet.ReadStructure( "MUnbox:Inventory:DeleteItem", MUnbox.NetStructures.DeleteInventoryItem, function( id )

    MUnbox.RemoveFromInventory( id )

end )

MonkeyNet.ReadStructure( "MUnbox:Inventory:Unbox:SendItem", MUnbox.NetStructures.SendUnboxedItem, function( id )

    hook.Run( "MUnbox:Unbox:Crate", id )

end )

MonkeyNet.ReadStructure( "MUnbox:Inventory:EquipItem", MUnbox.NetStructures.SendEquipItem, function( id, itemID, equipState ) 

    local Inventory = MUnbox.GetInventory()

    for k = 1, #Inventory do 

        local inventoryRow = Inventory[k]

        if ( not istable( inventoryRow ) ) then 
            
            continue 
        end 

        local inventoryItemID = inventoryRow.itemID 

        if ( not isstring( inventoryItemID ) ) then 
            
            continue 
        end 

        if ( inventoryItemID ~= itemID ) then 
            
            continue 
        end  
        
        if ( inventoryRow.id ~= id ) then
    
            inventoryRow.isEquiped = false 

            continue 
        end
            
        inventoryRow.isEquiped = equipState 

        if ( equipState ) then 

            MUnbox.DecreaseItemUse( inventoryRow )
            
        end    
    
    end
end )

hook.Protect( "Initialize", "MonkeyUnbox:Init:LoadIcons", function()

    async( loadIcons )

end )

