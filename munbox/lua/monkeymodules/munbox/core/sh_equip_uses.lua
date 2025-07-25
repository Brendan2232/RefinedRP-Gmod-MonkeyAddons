MUnbox.Inventory = MUnbox.Inventory or {}

if ( CLIENT ) then 

    MUnbox.DecreaseItemUse = function( id )

        local foundItem = ( istable( id ) and id ) or MUnbox.GetItem( id )

        if ( not istable( foundItem ) ) then 

            return 
        end 

        local uses = foundItem.Uses or -1
         
        if ( uses == -1 ) then 

            return
        end
    
        do 

            uses = uses - 1 

            uses = math.max( uses, 0 )

 
        end

        if ( uses <= 0 ) then 
            
            return 
        end 

        foundItem.Uses = uses 

    end

    MUnbox.PredictItemUse = function( )

        local items = MUnbox.GetInventory() or {}

        if ( #items <= 0 ) then 

            return 
        end

        for k = 1, #items do 

            local foundItem = items[k]
            
            if ( not istable( foundItem ) ) then 

                continue 
            end

            if ( not foundItem.isEquiped ) then 

                continue
            end

            MUnbox.DecreaseItemUse( foundItem )
        end

    end

    net.Receive( "MonkeyUnbox:PlayerLoadout:Prediction", function()
    
        MUnbox.PredictItemUse()

    end )

    return 
end

util.AddNetworkString( "MonkeyUnbox:PlayerLoadout:Prediction" )

function MUnbox.Inventory:LoadEquipStack( ply )

    assert( IsValid( ply ), "Player isn't valid!" )

    local items = ply.MUnbox_Heap or {}

    if ( next( items ) == nil ) then 

        return 
    end

    do 

        net.Start( "MonkeyUnbox:PlayerLoadout:Prediction" )
        net.Send( ply )

    end

    local steamID64 = ply:SteamID64()

    sql.Begin()

        for weaponID, v in pairs( items ) do 

            local id, uses = v.id, v.Uses 

            if ( not isnumber( id ) or not isnumber( uses )  ) then 

                continue 
            end

            if ( uses == -1 ) then 

                ply:Give( weaponID )

                continue 
            end
            
            do 

                uses = uses - 1

                uses = math.max( uses, 0 )

            end

            if ( uses <= 0 ) then 

                do 

                    ply.MUnbox_Heap = ply.MUnbox_Heap or {} 

                    ply.MUnbox_Heap[weaponID] = nil  

                end

                MUnbox.Inventory:DeleteFromInventory( ply, id )

                ply:Give( weaponID ) 

                continue 
            end

            ply:Give( weaponID )

            v.Uses = uses 
   
            do // Prep the SQL Query! 

                // Move this to a queue
                MonkeyLib.SQL:Query( "UPDATE munbox_inventory SET uses = %d WHERE id = %d AND steamID64 = %s;", {
                    uses, 
                    id, 
                    steamID64, 
                } )

            end
       
        end

    sql.Commit()

end





