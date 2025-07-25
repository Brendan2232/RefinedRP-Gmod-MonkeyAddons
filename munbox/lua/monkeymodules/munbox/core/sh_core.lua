require( "memoize" )
MUnbox.CachedKnifes = MUnbox.CachedKnifes or {}

MUnbox.GetWeapon = function( weaponID ) 
    
    return MUnbox.CachedKnifes[weaponID] or false
end

do 

    local cacheKnifes = function()
    
        table.Empty( MUnbox.CachedKnifes )
    
        local allWeapons = weapons.GetList() or {}
        
        for k = 1, #allWeapons do
             
            local row = allWeapons[k]

            if ( not istable( row ) ) then 
                
                continue 
            end 
        
            local weaponName, weaponID, weaponModel, skinIndex = row["PrintName"], row["ClassName"], row["WorldModel"], row["SkinIndex"] or 0 

            if ( not isstring( weaponName ) or not isstring( weaponID ) or not isstring( weaponModel ) ) then 
                
                continue 
            end
    
            MUnbox.CachedKnifes[weaponID] = {
                
                ["Name"] = weaponName, 
                ["WeaponID"] = weaponID, 
    
                ["Model"] = weaponModel, 
                ["SkinIndex"] = skinIndex,

            }
    
        end
    end
    
    hook.Protect( "Initialize", "MonkeyUnbox:Init:CacheKnifes", cacheKnifes )

end

MUnbox.GetCrate = memoize( function( id )

    local foundCrate = MUnbox.Crates[id] 

    if ( istable( foundCrate ) and ( next( foundCrate ) ~= nil ) ) then 

        return foundCrate
    end

    for k = 1, #MUnbox.Crates do 

        local crateRow = MUnbox.Crates[k]
        if ( not istable( crateRow ) ) then continue end 

        local crateID = crateRow["ID"]
        if ( not isstring( crateID ) ) then continue end 

        if ( crateID == id ) then 

            return crateRow, k 
        end
    end
end, {} )

