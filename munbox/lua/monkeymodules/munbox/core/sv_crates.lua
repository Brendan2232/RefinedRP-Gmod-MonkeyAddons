local maxInventorySpace = MUnbox.Config.InventorySpace

local L = function( message )

    return MUnbox.Config.Messages[message] or message
end

local SelectRandomItem = function( items ) 

    if ( not istable( items ) ) then return end

	local totalWeight = 0
	
	for k = 1, #items do 

        local itemRow = items[k]
        if ( not istable( itemRow ) ) then continue end 

        local weight = itemRow.Weight 
        if ( not isnumber( weight ) ) then continue end
        
		totalWeight = totalWeight + weight
	end

	for k = 1, #items do 

        local itemRow = items[k]
        if ( not istable( itemRow ) ) then continue end 

        local weight = itemRow.Weight 
        if ( not isnumber( weight ) ) then continue end
        
		local chance = weight / totalWeight
		totalWeight = totalWeight - weight

		if ( math.random() <= chance ) then

			return k
		end
	end
end

local openCrate = function( crateID )

    if ( not crateID ) then return end 

    local foundCrate = MUnbox.GetCrate( crateID )
    if ( not istable( foundCrate ) ) then return end 

    local crateWeapons = foundCrate.Items 
    if ( not istable( crateWeapons ) ) then return end 

    local unboxedWeapon = SelectRandomItem( crateWeapons )
    
    local convertedWeapon = crateWeapons[unboxedWeapon] 

    return unboxedWeapon, convertedWeapon
end

local generateItemUses = function( itemRarity )

    local foundRarity = MUnbox.GetRarity( itemRarity )

    assert( istable( foundRarity ), "Failed to find rarity, malformed data!" )

    local minUses, maxUses = unpack( foundRarity.Uses or {} )

    do // Make sure our data is valid! 

        assert( isnumber( minUses ), "Minimum amount of uses isn't defined!" )
    
        assert( isnumber( maxUses ), "Maximum amount of uses isn't defined!" )

    end

    return math.random( minUses, maxUses )
end

MUnbox.OpenCrateFromInventory = function( ply, id )

    local steamID64 = ply:SteamID64()

    local ownedItem = MUnbox.Inventory:GetItem( steamID64, id )

    if ( not istable( ownedItem ) or not ownedItem.isCrate ) then 

        return false, "crate_unbox_failed"
    end 

    local crateID = ownedItem.itemID 

    local inventorySize = MUnbox.Inventory:GetInventorySize( steamID64 ) - 1 // Minus the crate as it'll be deleted!

    if ( not isnumber( inventorySize ) or inventorySize >= maxInventorySpace ) then 

        return false, "inventory_no_space"
    end 

    local unboxedID, unboxedItem = openCrate( crateID )
    
    if ( not isnumber( unboxedID ) or not istable( unboxedItem ) ) then 
        
        return false, "crate_unbox_fail"
    end 

    local itemRarity = unboxedItem.Rarity 

    if ( not isstring( itemRarity ) ) then 

        return false, "crate_unbox_fail"
    end 

    local itemUses // Leave this empty! The inventory system defaults to -1 if the parsed uses are nil. 

    if ( unboxedItem.UseLimited ) then 

        itemUses = generateItemUses( itemRarity )

    end

    MUnbox.Inventory:DeleteFromInventory( ply, id )
    
    MUnbox.Inventory:AddToInventory( ply, unboxedItem.ID, unboxedItem.Rarity, false, itemUses )

    MonkeyNet.WriteStructure( "MUnbox:Inventory:Unbox:SendItem", MUnbox.NetStructures.SendUnboxedItem, { unboxedID }, ply )

    hook.Run( "MonkeyUnbox:Inventory:UnboxFromInventory", ply, ownedItem, unboxedItem )

end

MUnbox.PurchaseCrate = function( ply, crateID, bypassPrice )

    if ( not IsValid( ply ) or not crateID ) then 
        
        return false, "crate_purchase_fail"
    end
    
    local steamID64 = ply:SteamID64()

    local foundCrate = MUnbox.GetCrate( crateID )

    if ( not istable( foundCrate ) ) then 
        
        return false, "crate_purchase_fail"
    end  

    local crateName, crateID, crateRarity, cratePrice, isCrate = foundCrate.Name or "NULL", foundCrate.ID, foundCrate.Rarity, foundCrate.Price, true 

    if ( not crateID or not isstring( crateRarity ) or not isnumber( cratePrice ) ) then 

        return false, "crate_purchase_fail"
    end 

    if ( not MonkeyLib.CanAfford( ply, cratePrice ) and ( not bypassPrice ) ) then 

        return false, "cant_afford"
    end

    local inventorySize = MUnbox.Inventory:GetInventorySize( steamID64 )

    if ( not isnumber( inventorySize ) or inventorySize >= maxInventorySpace ) then 

        return false, "inventory_no_space"
    end 

    if ( not bypassPrice ) then 

        MonkeyLib.AddMoney( ply, -cratePrice )

    end 

    MUnbox.Inventory:AddToInventory( ply, crateID, crateRarity, isCrate )

    hook.Run( "MonkeyUnbox:Inventory:PurchaseCrate", ply, crateID, foundCrate )

    return true, "crate_purchase_success", crateName 
end
