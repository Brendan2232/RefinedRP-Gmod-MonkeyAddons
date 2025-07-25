MUnbox.NetStructures = MUnbox.NetStructures or {}

MUnbox.NetStructures.PurchaseCrate = MonkeyNet.CreateStructure(

    function( crateID )

        net.WriteUInt( crateID, 7 )
    
    end,

    function()
        
        return net.ReadUInt( 7 )
    end
)

MUnbox.NetStructures.UnboxCrate = MonkeyNet.CreateStructure(

    function( id )

        net.WriteUInt( id, 32 )
    
    end,

    function()
        
        return net.ReadUInt( 32 )
    end
)

MUnbox.NetStructures.EquipItem = MonkeyNet.CreateStructure(

    function( id )

        net.WriteUInt( id, 32 )
    
    end,

    function()
        
        return net.ReadUInt( 32 )
    end
)

MUnbox.NetStructures.SendEquipItem = MonkeyNet.CreateStructure(

    function( id, itemID, equipState )

        net.WriteUInt( id, 32 )
        
        net.WriteString( itemID )
        
        net.WriteBool( equipState )
        
    end,

    function()
        
        return net.ReadUInt( 32 ), net.ReadString( ), net.ReadBool()
    end
)

MUnbox.NetStructures.SendInventoryItem = MonkeyNet.CreateStructure(

    function( id, itemID, itemRarity, isCrate, uses )

        if ( not isnumber( id ) or not isstring( itemID ) or not isstring( itemRarity ) or not isnumber( uses ) ) then 
            
            return 
        end 

        net.WriteUInt( id, 32 )

        net.WriteString( itemID )
        net.WriteString( itemRarity )

        net.WriteBool( isCrate or false )
        
        net.WriteInt( uses, 16 )

    end,

    function()
        
        return net.ReadUInt( 32 ), net.ReadString(), net.ReadString(), net.ReadBool(), net.ReadInt( 16 )
    end
)

MUnbox.NetStructures.DeleteInventoryItem = MonkeyNet.CreateStructure(

    function( id )

        net.WriteUInt( id, 32 )
    
    end,

    function()
        
        return net.ReadUInt( 32 ) 
    end
)

MUnbox.NetStructures.SendUnboxedItem = MonkeyNet.CreateStructure(

    function( id )

        net.WriteUInt( id, 32 )
    
    end,

    function()
        
        return net.ReadUInt( 32 ) 
    end
)
