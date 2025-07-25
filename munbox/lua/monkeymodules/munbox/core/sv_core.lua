require("monkeyhooks")

resource.AddFile("sound/munbox/click.wav")

util.AddNetworkString( "MUnbox:Crates:Purchase" )

util.AddNetworkString( "MUnbox:Inventory:SendItem" )
util.AddNetworkString( "MUnbox:Inventory:DeleteItem" )

util.AddNetworkString( "MUnbox:Inventory:SendInventory" )

util.AddNetworkString( "MUnbox:Inventory:Unbox" )
util.AddNetworkString( "MUnbox:Inventory:Unbox:SendItem" )
util.AddNetworkString( "MUnbox:Inventory:EquipItem" )

local L = function( message )

    return MUnbox.Config.Messages[message] or message
end

MonkeyNet.ReadStructure( "MUnbox:Crates:Purchase", MUnbox.NetStructures.PurchaseCrate, function( l, ply, crateID )

    if ( not IsValid( ply ) or not isnumber( crateID ) ) then return end 

    local succ, err, crateName = MUnbox.PurchaseCrate( ply, crateID )

    if ( not err ) then return end 
    
    MonkeyLib.FancyChatMessage( L( err ), not succ, ( succ and crateName ) and { crateName } or nil, ply )
    
end )

MonkeyNet.ReadStructure( "MUnbox:Inventory:DeleteItem", MUnbox.NetStructures.DeleteInventoryItem, function( l, ply, id )

    local succ, err = MUnbox.Inventory:DeleteFromInventory( ply, id )

    if ( not err ) then return end 
    
    MonkeyLib.FancyChatMessage( L( err ), not succ, nil, ply )
    
end )

MonkeyNet.ReadStructure( "MUnbox:Inventory:Unbox", MUnbox.NetStructures.UnboxCrate, function( l, ply, id )

    local success, err = MUnbox.OpenCrateFromInventory( ply, id )
    
    if ( not err ) then return end 
    
    MonkeyLib.FancyChatMessage( L( err ), not success, nil, ply )

end )

MonkeyNet.ReadStructure( "MUnbox:Inventory:EquipItem", MUnbox.NetStructures.EquipItem, function( l, ply, id ) 

    local success, err = MUnbox.Inventory:EquipItem( ply, id )
    
    if ( not err ) then return end 

    MonkeyLib.FancyChatMessage( L( err ), not success, nil, ply )

end )



hook.Protect( "Initialize", "MonkeyUnbox:Core:InitializeDatabase", function()
 
    MonkeyLib.SQL:CreateTables( {
        "CREATE TABLE IF NOT EXISTS munbox_inventory ( id INTEGER PRIMARY KEY AUTOINCREMENT, steamID64 VARCHAR(32), itemID VARCHAR(32), itemRarity VARCHAR(32), isCrate INT, isEquiped INT );",
   //    "CREATE TABLE IF NOT EXISTS munbox_auction ( id INTEGER PRIMARY KEY AUTOINCREMENT, steamID64 VARCHAR(32), itemID VARCHAR(32), itemRarity VARCHAR(32), price INT, isCrate INT);",
    } )

    pcall( function()

        MonkeyLib.SQL:Query( "ALTER TABLE munbox_inventory ADD uses INT DEFAULT -1 NOT NULL" )

    end )

end )

do 
    
    hook.Protect( "MonkeyLib:PlayerNetReady", "MonkeyUnbox:NetReady:SendPlayerInventory", function( ply )
    
        MUnbox.Inventory:SendInventory( ply )

    end )

    hook.Protect( "PlayerLoadout", "MonkeyUnbox:Core:GiveWeapons", function( ply ) 

        MUnbox.Inventory:LoadEquipStack( ply )
        
    end )    

end


