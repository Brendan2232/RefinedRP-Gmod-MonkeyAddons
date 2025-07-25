MUnbox = MUnbox or {}

MUnbox.Rarities = MUnbox.Rarities or {}

MUnbox.Crates = MUnbox.Crates or {}

MUnbox.Categories = {
    {
        
        id = "perm_knifes", 

        Name = "Perm Knifes",
    
    },
    {
        
        id = "temp_weapons", 

        Name = "Temp Weapons",
    
    }
}


local createCrate, createRarity, registerItem

do // Functions to register everything, put a 'do' statement to make reading this file easier. 

    MUnbox.GetRarity = function( rarityID )

        return MUnbox.Rarities[rarityID]
    end
    
    createRarity = function( rarityID, rarityName, rarityColor, uses )
    
        if ( not isstring( rarityID ) or not isstring( rarityName ) or not IsColor( rarityColor ) ) then 
            
            ErrorNoHaltWithStack( "Failed to create rarity, malformed arguments." )
    
            return 
        end 
        
        if ( MUnbox.GetRarity( rarityID ) ) then 
    
            ErrorNoHaltWithStack( "Failed to create rarity, rarity ID '", rarityID, "' is already in use.")
    
            return 
        end
    
        MUnbox.Rarities[rarityID] = {

            ["Name"] = rarityName, 
            
            ["Color"] = rarityColor, 

            ["Uses"] = uses, 

        }
    end
    
    registerItem = function( ID, Rarity, Weight, isLimited )
    
        if ( not MUnbox.GetRarity( Rarity ) ) then 
    
            ErrorNoHaltWithStack( "Failed to register item, '", ID, "', rarity ID '", Rarity,"' is invalid. Make sure you're using the rarity ID." )
    
            return
        end
    
        return { ["ID"] = ID, ["Rarity"] = Rarity, ["Weight"] = Weight, ["UseLimited"] = ( isLimited or false ) }
    end
    
end

createRarity( "common", "Common", Color(50,212,50), { 2, 5 }  )

createRarity( "rare", "Rare", Color(0,89,255), { 5, 12 }  )

createRarity( "epic", "Epic", Color(190, 40, 196), { 12, 25 }  )

createRarity( "legendary", "Legendary", Color(197, 22, 31), { 25, 60 }  )

createRarity( "mythical", "Mythical", Color(175, 218, 23), { 100, 500 } )

createRarity( "spooky", "Spooky", Color(255, 115, 0), { 1, 25 } )

MUnbox.Crates = {
    {
        ["ID"] = "m_crate_common", // For the inventory Database. 

        ["Name"] = "Common Knife Crate", 
        ["Icon"] = "m_unbox_crate_2", 
        
        ["Category"] = "perm_knifes", 

        ["Rarity"] = "common",
        ["Price"] = 1000000, 

        ["Items"] = {

            registerItem( "csgo_bayonet", "common", 150 ),
 
            registerItem( "csgo_bowie_rustcoat", "common", 150 ),

            registerItem( "csgo_daggers_rustcoat", "common", 150 ),

            registerItem( "csgo_huntsman_rustcoat", "common", 150 ),

            registerItem( "csgo_m9_rustcoat", "common", 150 ),

            registerItem( "csgo_bowie", "common", 150 ),

            registerItem( "csgo_falchion", "common", 150 ),

            registerItem( "csgo_flip", "common", 150 ),

            registerItem( "csgo_gut", "common", 150 ),

            registerItem( "csgo_huntsman", "common", 150 ),

            registerItem( "csgo_m9", "common", 150 ),

            registerItem( "csgo_daggers", "common", 150 ),

            registerItem( "csgo_bayonet_boreal", "rare", 50 ),

            registerItem( "csgo_bayonet_bluesteel", "rare", 50 ),

            registerItem( "csgo_bayonet_bright_water", "rare", 50 ),

            registerItem( "csgo_bowie_damascus", "rare", 50 ),

            registerItem( "csgo_bowie_bright_water", "rare", 50 ),

            registerItem( "csgo_falchion_boreal", "rare", 50 ),

            registerItem( "csgo_falchion_night", "rare", 50 ),

            registerItem( "csgo_falchion_ddpat", "rare", 50 ),

            registerItem( "csgo_flip_black_laminate", "rare", 50 ),

            registerItem( "csgo_flip_bluesteel", "rare", 50 ),

            registerItem( "csgo_falchion_bright_water", "rare", 50 ),

            registerItem( "csgo_flip_bright_water", "rare", 50 ),

            registerItem( "csgo_bayonet_ddpat", "rare", 50 ),

            registerItem( "csgo_flip_boreal", "rare", 50 ),

            registerItem( "csgo_gut_bluesteel", "rare", 50 ),

            registerItem( "csgo_gut_boreal", "rare", 50 ),

            registerItem( "csgo_gut_damascus", "rare", 50 ),

            registerItem( "csgo_gut_night", "rare", 50 ),

            registerItem( "csgo_huntsman_bluesteel", "rare", 50 ),

            registerItem( "csgo_huntsman_boreal", "rare", 50 ),

            registerItem( "csgo_m9_bluesteel", "rare", 50 ),

            registerItem( "csgo_m9_boreal", "rare", 50 ),

            registerItem( "csgo_m9_bright_water", "rare", 50 ),

            registerItem( "csgo_daggers_bluesteel", "rare", 50 ),

            registerItem( "csgo_daggers_bright_water", "rare", 50 ),  

            registerItem( "csgo_daggers_boreal", "rare", 50 ),  

            registerItem( "csgo_daggers_ddpat", "rare", 50 ),  

            registerItem( "csgo_bayonet_black_laminate", "epic", 10 ),

            registerItem( "csgo_bayonet_case", "epic", 10 ),

            registerItem( "csgo_bowie_gamma_doppler", "epic", 10 ),

            registerItem( "csgo_bayonet_crimsonwebs", "epic", 10 ),

            registerItem( "csgo_bayonet_gamma_doppler", "epic", 10 ),

            registerItem( "csgo_bowie_case", "epic", 10 ),

            registerItem( "csgo_bowie_crimsonwebs", "epic", 10 ),

            registerItem( "csgo_bowie_night", "epic", 10 ),

            registerItem( "csgo_bowie_slaughter", "epic", 10 ),

            registerItem( "csgo_butterfly", "epic", 10 ),

            registerItem( "csgo_butterfly_boreal", "epic", 10 ),

            registerItem( "csgo_butterfly_bluesteel", "epic", 10 ),

            registerItem( "csgo_butterfly_ddpat", "epic", 10 ),

            registerItem( "csgo_falchion_case", "epic", 10 ),

            registerItem( "csgo_falchion_slaughter", "epic", 10 ),

            registerItem( "csgo_falchion_ultraviolet", "epic", 10 ),

            registerItem( "csgo_falchion_tiger", "epic", 10 ),

            registerItem( "csgo_flip_crimsonwebs", "epic", 10 ),

            registerItem( "csgo_flip_gamma_doppler", "epic", 10 ),

            registerItem( "csgo_flip_tiger", "epic", 10 ),

            registerItem( "csgo_flip_ultraviolet", "epic", 10 ),

            registerItem( "csgo_gut_case", "epic", 10 ),

            registerItem( "csgo_gut_freehand", "epic", 10 ),

            registerItem( "csgo_gut_gamma_doppler", "epic", 10 ),

            registerItem( "csgo_gut_ultraviolet", "epic", 10 ),

            registerItem( "csgo_huntsman_case", "epic", 10 ),

            registerItem( "csgo_huntsman_crimsonwebs", "epic", 10 ),

            registerItem( "csgo_huntsman_freehand", "epic", 10 ),

            registerItem( "csgo_huntsman_gamma_doppler", "epic", 10 ),

            registerItem( "csgo_huntsman_slaughter", "epic", 10 ),

            registerItem( "csgo_huntsman_ultraviolet", "epic", 10 ),

            registerItem( "csgo_karambit", "epic", 10 ),

            registerItem( "csgo_karambit_boreal", "epic", 10 ),

            registerItem( "csgo_karambit_bright_water", "epic", 10 ),

            registerItem( "csgo_karambit_night", "epic", 10 ),

            registerItem( "csgo_karambit_ddpat", "epic", 10 ),

            registerItem( "csgo_m9_black_laminate", "epic", 10 ),

            registerItem( "csgo_flip_gamma_doppler", "epic", 10 ),

            registerItem( "csgo_daggers_gamma_doppler", "epic", 10 ),

            registerItem( "csgo_m9_case", "epic", 10 ),

            registerItem( "csgo_m9_crimsonwebs", "epic", 10 ),

            registerItem( "csgo_m9_freehand", "epic", 10 ),

            registerItem( "csgo_m9_gamma_doppler", "epic", 10 ),

            registerItem( "csgo_m9_slaughter", "epic", 10 ),

            registerItem( "csgo_m9_tiger", "epic", 10 ),

            registerItem( "csgo_m9_ultraviolet", "epic", 10 ),

            registerItem( "csgo_daggers_case", "epic", 10 ),

            registerItem( "csgo_daggers_slaughter", "epic", 10 ),

            registerItem( "csgo_daggers_ultraviolet", "epic", 10 ),

            registerItem( "csgo_daggers_tiger", "epic", 10 ),

            registerItem( "csgo_bayonet_autotronic", "legendary", 2 ),

            registerItem( "csgo_bayonet_fade", "legendary", 2 ),

            registerItem( "csgo_bayonet_marblefade", "legendary", 3 ),

            registerItem( "csgo_bowie_fade", "legendary", 3 ),

            registerItem( "csgo_bowie_marblefade", "legendary", 2 ),

            registerItem( "csgo_butterfly_crimsonwebs", "legendary", 2 ),

            registerItem( "csgo_butterfly_slaughter", "legendary", 2 ),

            registerItem( "csgo_butterfly_ultraviolet", "legendary", 2 ),

            registerItem( "csgo_butterfly_freehand", "legendary", 2 ),

            registerItem( "csgo_butterfly_gamma_doppler", "legendary", 2 ),

            registerItem( "csgo_falchion_fade", "legendary", 2 ),

            registerItem( "csgo_falchion_marblefade", "legendary", 2 ),

            registerItem( "csgo_flip_autotronic", "legendary", 2 ),

            registerItem( "csgo_flip_fade", "legendary", 2 ),

            registerItem( "csgo_flip_marblefade", "legendary", 2 ),

            registerItem( "csgo_gut_autotronic", "legendary", 2 ),

            registerItem( "csgo_gut_marblefade", "legendary", 2 ),

            registerItem( "csgo_huntsman_fade", "legendary", 2 ),

            registerItem( "csgo_huntsman_marblefade", "legendary", 2 ),

            registerItem( "csgo_karambit_black_laminate", "legendary", 2 ),

            registerItem( "csgo_karambit_crimsonwebs", "legendary", 2 ),

            registerItem( "csgo_karambit_freehand", "legendary", 2 ),

            registerItem( "csgo_karambit_gamma_doppler", "legendary", 2 ),

            registerItem( "csgo_karambit_ultraviolet", "legendary", 2 ),

            registerItem( "csgo_m9_autotronic", "legendary", 2 ),

            registerItem( "csgo_m9_marblefade", "legendary", 2 ),

            registerItem( "csgo_daggers_fade", "legendary", 2 ),

            registerItem( "csgo_gut_fade", "legendary", 2 ),

            registerItem( "csgo_butterfly_damascus", "legendary", 2 ),

            registerItem( "csgo_karambit_damascus", "legendary", 2 ),

            
        }, 
    },
    {
        ["ID"] = "m_crate_rare", // For the inventory Database. 

        ["Name"] = "Rare Knife Crate", 
        ["Icon"] = "m_unbox_crate_2", 

        ["Rarity"] = "rare",
        ["Price"] = 1500000, 

        ["Category"] = "perm_knifes",

        ["Items"] = {

            registerItem( "csgo_bayonet", "common", 105 ),

            registerItem( "csgo_bowie_rustcoat", "common", 105 ),
            
            registerItem( "csgo_daggers_rustcoat", "common", 105 ),
            
            registerItem( "csgo_huntsman_rustcoat", "common", 105 ),
            
            registerItem( "csgo_m9_rustcoat", "common", 105 ),
            
            registerItem( "csgo_bowie", "common", 105 ),
            
            registerItem( "csgo_falchion", "common", 105 ),
            
            registerItem( "csgo_flip", "common", 105 ),
            
            registerItem( "csgo_gut", "common", 105 ),
            
            registerItem( "csgo_huntsman", "common", 105 ),
            
            registerItem( "csgo_m9", "common", 105 ),
            
            registerItem( "csgo_daggers", "common", 105 ),
            
            registerItem( "csgo_bayonet_boreal", "rare", 60 ),

            registerItem( "csgo_bayonet_ddpat", "rare", 60 ),
            
            registerItem( "csgo_bayonet_bluesteel", "rare", 60 ),
            
            registerItem( "csgo_bayonet_bright_water", "rare", 60 ),
            
            registerItem( "csgo_bowie_damascus", "rare", 60 ),
            
            registerItem( "csgo_bowie_bright_water", "rare", 60 ),
            
            registerItem( "csgo_falchion_boreal", "rare", 60 ),
            
            registerItem( "csgo_falchion_night", "rare", 60 ),
            
            registerItem( "csgo_falchion_ddpat", "rare", 60 ),
            
            registerItem( "csgo_flip_black_laminate", "rare", 60 ),
            
            registerItem( "csgo_flip_bluesteel", "rare", 60 ),
            
            registerItem( "csgo_flip_bright_water", "rare", 60 ),
            
            registerItem( "csgo_flip_boreal", "rare", 60 ),
            
            registerItem( "csgo_gut_bluesteel", "rare", 60 ),
            
            registerItem( "csgo_gut_boreal", "rare", 60 ),
            
            registerItem( "csgo_gut_damascus", "rare", 60 ),
            
            registerItem( "csgo_gut_night", "rare", 60 ),
            
            registerItem( "csgo_huntsman_bluesteel", "rare", 60 ),
            
            registerItem( "csgo_huntsman_boreal", "rare", 60 ),
            
            registerItem( "csgo_m9_bluesteel", "rare", 60 ),
            
            registerItem( "csgo_m9_boreal", "rare", 60 ),

            registerItem( "csgo_falchion_bright_water", "rare", 60 ),
            
            registerItem( "csgo_m9_bright_water", "rare", 60 ),
            
            registerItem( "csgo_daggers_bluesteel", "rare", 60 ),
            
            registerItem( "csgo_daggers_bright_water", "rare", 60 ),  
            
            registerItem( "csgo_daggers_boreal", "rare", 60 ),  
            
            registerItem( "csgo_daggers_ddpat", "rare", 60 ),  
            
            registerItem( "csgo_bayonet_black_laminate", "epic", 14 ),
            
            registerItem( "csgo_bayonet_case", "epic", 14 ),
            
            registerItem( "csgo_bayonet_crimsonwebs", "epic", 14 ),
            
            registerItem( "csgo_bayonet_gamma_doppler", "epic", 14 ),
            
            registerItem( "csgo_bowie_case", "epic", 14 ),
            
            registerItem( "csgo_bowie_crimsonwebs", "epic", 14 ),
            
            registerItem( "csgo_bowie_night", "epic", 14 ),
            
            registerItem( "csgo_bowie_slaughter", "epic", 14 ),
            
            registerItem( "csgo_butterfly", "epic", 14 ),
            
            registerItem( "csgo_butterfly_boreal", "epic", 14 ),
            
            registerItem( "csgo_butterfly_bluesteel", "epic", 14 ),

            registerItem( "csgo_daggers_gamma_doppler", "epic", 14 ),
            
            registerItem( "csgo_butterfly_ddpat", "epic", 14 ),
            
            registerItem( "csgo_falchion_case", "epic", 14 ),
            
            registerItem( "csgo_falchion_slaughter", "epic", 14 ),
            
            registerItem( "csgo_falchion_ultraviolet", "epic", 14 ),
            
            registerItem( "csgo_falchion_tiger", "epic", 14 ),
            
            registerItem( "csgo_flip_crimsonwebs", "epic", 14 ),
            
            registerItem( "csgo_flip_gamma_doppler", "epic", 14 ),
            
            registerItem( "csgo_flip_tiger", "epic", 14 ),

            registerItem( "csgo_bowie_gamma_doppler", "epic", 14 ),
            
            registerItem( "csgo_flip_ultraviolet", "epic", 14 ),
            
            registerItem( "csgo_gut_case", "epic", 14 ),
            
            registerItem( "csgo_gut_freehand", "epic", 14 ),
            
            registerItem( "csgo_gut_gamma_doppler", "epic", 14 ),
            
            registerItem( "csgo_gut_ultraviolet", "epic", 14 ),
            
            registerItem( "csgo_huntsman_case", "epic", 14 ),
            
            registerItem( "csgo_huntsman_crimsonwebs", "epic", 14 ),
            
            registerItem( "csgo_huntsman_freehand", "epic", 14 ),
            
            registerItem( "csgo_huntsman_gamma_doppler", "epic", 14 ),
            
            registerItem( "csgo_huntsman_slaughter", "epic", 14 ),
            
            registerItem( "csgo_huntsman_ultraviolet", "epic", 14 ),
            
            registerItem( "csgo_karambit", "epic", 14 ),
            
            registerItem( "csgo_karambit_boreal", "epic", 14 ),
            
            registerItem( "csgo_karambit_bright_water", "epic", 14 ),
            
            registerItem( "csgo_karambit_night", "epic", 14 ),
            
            registerItem( "csgo_karambit_ddpat", "epic", 14 ),
            
            registerItem( "csgo_m9_black_laminate", "epic", 14 ),
            
            registerItem( "csgo_m9_case", "epic", 14 ),
            
            registerItem( "csgo_m9_crimsonwebs", "epic", 14 ),
            
            registerItem( "csgo_m9_freehand", "epic", 14 ),

            registerItem( "csgo_flip_gamma_doppler", "epic", 14 ),
            
            registerItem( "csgo_m9_gamma_doppler", "epic", 14 ),
            
            registerItem( "csgo_m9_slaughter", "epic", 14 ),
            
            registerItem( "csgo_m9_tiger", "epic", 14 ),
            
            registerItem( "csgo_m9_ultraviolet", "epic", 14 ),
    
            registerItem( "csgo_daggers_case", "epic", 14 ),
            
            registerItem( "csgo_daggers_slaughter", "epic", 14 ),
            
            registerItem( "csgo_daggers_ultraviolet", "epic", 14 ),
            
            registerItem( "csgo_daggers_tiger", "epic", 14 ),
            
            registerItem( "csgo_bayonet_autotronic", "legendary", 4 ),
            
            registerItem( "csgo_bayonet_fade", "legendary", 4 ),
            
            registerItem( "csgo_bayonet_marblefade", "legendary", 4 ),
            
            registerItem( "csgo_bowie_fade", "legendary", 4 ),
            
            registerItem( "csgo_bowie_marblefade", "legendary", 4 ),
            
            registerItem( "csgo_butterfly_crimsonwebs", "legendary", 4 ),
            
            registerItem( "csgo_butterfly_slaughter", "legendary", 4 ),
            
            registerItem( "csgo_butterfly_ultraviolet", "legendary", 4 ),
            
            registerItem( "csgo_butterfly_freehand", "legendary", 4 ),
            
            registerItem( "csgo_butterfly_gamma_doppler", "legendary", 4 ),
            
            registerItem( "csgo_falchion_fade", "legendary", 4 ),
            
            registerItem( "csgo_falchion_marblefade", "legendary", 4 ),
            
            registerItem( "csgo_flip_autotronic", "legendary", 4 ),
            
            registerItem( "csgo_flip_fade", "legendary", 4 ),
            
            registerItem( "csgo_flip_marblefade", "legendary", 4 ),
            
            registerItem( "csgo_gut_autotronic", "legendary", 4 ),
            
            registerItem( "csgo_gut_fade", "legendary", 4 ),
            
            registerItem( "csgo_gut_marblefade", "legendary", 4 ),
            
            registerItem( "csgo_huntsman_fade", "legendary", 4 ),
            
            registerItem( "csgo_huntsman_marblefade", "legendary", 4 ),
            
            registerItem( "csgo_karambit_black_laminate", "legendary", 4 ),
            
            registerItem( "csgo_karambit_crimsonwebs", "legendary", 4 ),
            
            registerItem( "csgo_karambit_freehand", "legendary", 4 ),
            
            registerItem( "csgo_karambit_gamma_doppler", "legendary", 4 ),
            
            registerItem( "csgo_karambit_ultraviolet", "legendary", 4 ),
            
            registerItem( "csgo_m9_autotronic", "legendary", 4 ),
            
            registerItem( "csgo_m9_marblefade", "legendary", 4 ),
            
            registerItem( "csgo_daggers_fade", "legendary", 4 ),

            registerItem( "csgo_butterfly_damascus", "legendary", 4 ),

            registerItem( "csgo_karambit_damascus", "legendary", 4 ),
            
            registerItem( "csgo_bayonet_lore", "mythical", 2 ),
            
            registerItem( "csgo_butterfly_fade", "mythical", 2 ),
            
            registerItem( "csgo_butterfly_marblefade", "mythical", 2 ),
            
            registerItem( "csgo_flip_lore", "mythical", 2 ),
            
            registerItem( "csgo_gut_lore", "mythical", 2 ),
            
            registerItem( "csgo_karambit_autotronic", "mythical", 2 ),
            
            registerItem( "csgo_karambit_lore", "mythical", 2 ),
            
            registerItem( "csgo_karambit_marblefade", "mythical", 2 ),
            
            registerItem( "csgo_m9_lore", "mythical", 2 ),

            registerItem( "csgo_karambit_fade", "mythical", 2 ),

            registerItem( "csgo_karambit_case", "mythical", 2 ),

            registerItem( "csgo_butterfly_case", "mythical", 2 ),

            registerItem( "csgo_karambit_tiger", "mythical", 2 ),

            registerItem( "csgo_butterfly_tiger", "mythical", 2 ),
        }, 
    },

    {
        ["ID"] = "m_crate_epic", // For the inventory Database. 

        ["Name"] = "Epic Knife Crate", 
        ["Icon"] = "m_unbox_crate_2", 

        ["Rarity"] = "epic",
        ["Price"] = 2000000, 

        ["Category"] = "perm_knifes",

        ["Items"] = {

            registerItem( "csgo_bayonet", "common", 95 ),
            
            registerItem( "csgo_huntsman_rustcoat", "common", 95 ),
            
            registerItem( "csgo_bowie_rustcoat", "common", 95 ),
            
            registerItem( "csgo_daggers_rustcoat", "common", 95 ),
            
            registerItem( "csgo_m9_rustcoat", "common", 95 ),
            
            registerItem( "csgo_bowie", "common", 95 ),
            
            registerItem( "csgo_falchion", "common", 95 ),
            
            registerItem( "csgo_flip", "common", 95 ),
            
            registerItem( "csgo_gut", "common", 95 ),
            
            registerItem( "csgo_huntsman", "common", 95 ),
            
            registerItem( "csgo_m9", "common", 95 ),
            
            registerItem( "csgo_daggers", "common", 95 ),
            
            registerItem( "csgo_bayonet_boreal", "rare", 55 ),
            
            registerItem( "csgo_bayonet_bluesteel", "rare", 55 ),
            
            registerItem( "csgo_bowie_damascus", "rare", 55 ),
            
            registerItem( "csgo_bowie_bright_water", "rare", 55 ),
            
            registerItem( "csgo_falchion_boreal", "rare", 55 ),

            registerItem( "csgo_falchion_bright_water", "rare", 55 ),
            
            registerItem( "csgo_falchion_night", "rare", 55 ),
            
            registerItem( "csgo_falchion_ddpat", "rare", 55 ),
            
            registerItem( "csgo_flip_black_laminate", "rare", 55 ),
            
            registerItem( "csgo_flip_bluesteel", "rare", 55 ),
            
            registerItem( "csgo_flip_bright_water", "rare", 55 ),
            
            registerItem( "csgo_flip_boreal", "rare", 55 ),
            
            registerItem( "csgo_gut_bluesteel", "rare", 55 ),
            
            registerItem( "csgo_gut_boreal", "rare", 55 ),

            registerItem( "csgo_bayonet_ddpat", "rare", 55 ),
            
            registerItem( "csgo_gut_damascus", "rare", 55 ),
            
            registerItem( "csgo_gut_night", "rare", 55 ),
            
            registerItem( "csgo_huntsman_bluesteel", "rare", 55 ),
            
            registerItem( "csgo_huntsman_boreal", "rare", 55 ),
            
            registerItem( "csgo_m9_bluesteel", "rare", 55 ),
            
            registerItem( "csgo_m9_boreal", "rare", 55 ),
            
            registerItem( "csgo_m9_bright_water", "rare", 55 ),
            
            registerItem( "csgo_daggers_bluesteel", "rare", 55 ),
            
            registerItem( "csgo_daggers_bright_water", "rare", 55 ),  
            
            registerItem( "csgo_daggers_boreal", "rare", 55 ),  
            
            registerItem( "csgo_daggers_ddpat", "rare", 55 ),  
            
            registerItem( "csgo_bayonet_black_laminate", "epic", 20 ),
            
            registerItem( "csgo_bayonet_case", "epic", 20 ),
            
            registerItem( "csgo_bayonet_crimsonwebs", "epic", 20 ),
            
            registerItem( "csgo_bayonet_gamma_doppler", "epic", 20 ),
            
            registerItem( "csgo_bowie_case", "epic", 20 ),
            
            registerItem( "csgo_bowie_crimsonwebs", "epic", 20 ),
            
            registerItem( "csgo_bowie_night", "epic", 20 ),
            
            registerItem( "csgo_bowie_slaughter", "epic", 20 ),

            registerItem( "csgo_bowie_gamma_doppler", "epic", 20 ),
            
            registerItem( "csgo_butterfly", "epic", 20 ),
            
            registerItem( "csgo_butterfly_boreal", "epic", 20 ),
            
            registerItem( "csgo_butterfly_bluesteel", "epic", 20 ),
            
            registerItem( "csgo_butterfly_ddpat", "epic", 20 ),
            
            registerItem( "csgo_falchion_case", "epic", 20 ),

            registerItem( "csgo_daggers_gamma_doppler", "epic", 20 ),
            
            registerItem( "csgo_falchion_slaughter", "epic", 20 ),
            
            registerItem( "csgo_falchion_ultraviolet", "epic", 20 ),
            
            registerItem( "csgo_falchion_tiger", "epic", 20 ),
            
            registerItem( "csgo_flip_crimsonwebs", "epic", 20 ),
            
            registerItem( "csgo_flip_gamma_doppler", "epic", 20 ),
            
            registerItem( "csgo_flip_tiger", "epic", 20 ),
            
            registerItem( "csgo_flip_ultraviolet", "epic", 20 ),
            
            registerItem( "csgo_gut_case", "epic", 20 ),
            
            registerItem( "csgo_gut_freehand", "epic", 20 ),
            
            registerItem( "csgo_gut_gamma_doppler", "epic", 20 ),
                  
            registerItem( "csgo_gut_ultraviolet", "epic", 20 ),
            
            registerItem( "csgo_huntsman_case", "epic", 20 ),
            
            registerItem( "csgo_huntsman_crimsonwebs", "epic", 20 ),
            
            registerItem( "csgo_huntsman_freehand", "epic", 20 ),
            
            registerItem( "csgo_huntsman_gamma_doppler", "epic", 20 ),
            
            registerItem( "csgo_huntsman_slaughter", "epic", 20 ),
            
            registerItem( "csgo_huntsman_ultraviolet", "epic", 20 ),
            
            registerItem( "csgo_karambit", "epic", 20 ),
            
            registerItem( "csgo_karambit_boreal", "epic", 20 ),
            
            registerItem( "csgo_karambit_bright_water", "epic", 20 ),
            
            registerItem( "csgo_karambit_night", "epic", 20 ),
            
            registerItem( "csgo_karambit_ddpat", "epic", 20 ),
            
            registerItem( "csgo_m9_black_laminate", "epic", 20 ),
            
            registerItem( "csgo_m9_case", "epic", 20 ),
            
            registerItem( "csgo_m9_crimsonwebs", "epic", 20 ),
            
            registerItem( "csgo_m9_freehand", "epic", 20 ),
            
            registerItem( "csgo_m9_gamma_doppler", "epic", 20 ),
            
            registerItem( "csgo_m9_slaughter", "epic", 20 ),
            
            registerItem( "csgo_m9_tiger", "epic", 20 ),

            registerItem( "csgo_flip_gamma_doppler", "epic", 20 ),
            
            registerItem( "csgo_m9_ultraviolet", "epic", 20 ),
            
            registerItem( "csgo_daggers_case", "epic", 20 ),
            
            registerItem( "csgo_daggers_slaughter", "epic", 20 ),
            
            registerItem( "csgo_daggers_ultraviolet", "epic", 20 ),
            
            registerItem( "csgo_daggers_tiger", "epic", 20 ),
            
            registerItem( "csgo_bayonet_autotronic", "legendary", 7 ),
            
            registerItem( "csgo_bayonet_fade", "legendary", 7 ),
            
            registerItem( "csgo_bayonet_marblefade", "legendary", 7 ),
            
            registerItem( "csgo_bowie_fade", "legendary", 7 ),
            
            registerItem( "csgo_bowie_marblefade", "legendary", 7 ),
            
            registerItem( "csgo_butterfly_crimsonwebs", "legendary", 8 ),
            
            registerItem( "csgo_butterfly_slaughter", "legendary", 7 ),
            
            registerItem( "csgo_butterfly_ultraviolet", "legendary", 6 ),
            
            registerItem( "csgo_butterfly_freehand", "legendary", 6 ),
            
            registerItem( "csgo_butterfly_gamma_doppler", "legendary", 6 ),

            registerItem( "csgo_butterfly_damascus", "legendary", 7 ),

            registerItem( "csgo_karambit_damascus", "legendary", 7 ),

            registerItem( "csgo_butterfly_gamma_doppler", "legendary", 6),
            
            registerItem( "csgo_falchion_fade", "legendary", 7 ),
            
            registerItem( "csgo_falchion_marblefade", "legendary", 6 ),
            
            registerItem( "csgo_flip_autotronic", "legendary", 6 ),
            
            registerItem( "csgo_flip_fade", "legendary", 6 ),
            
            registerItem( "csgo_flip_marblefade", "legendary", 6 ),
            
            registerItem( "csgo_gut_autotronic", "legendary", 6 ),
            
            registerItem( "csgo_gut_fade", "legendary", 6 ),
            
            registerItem( "csgo_gut_marblefade", "legendary", 6 ),
            
            registerItem( "csgo_huntsman_fade", "legendary", 6 ),
            
            registerItem( "csgo_huntsman_marblefade", "legendary", 6 ),
            
            registerItem( "csgo_karambit_black_laminate", "legendary", 6 ),
            
            registerItem( "csgo_karambit_crimsonwebs", "legendary", 7 ),
            
            registerItem( "csgo_karambit_freehand", "legendary", 7 ),
            
            registerItem( "csgo_karambit_gamma_doppler", "legendary", 7 ),

            registerItem( "csgo_butterfly_gamma_doppler", "legendary", 7 ),
            
            registerItem( "csgo_karambit_ultraviolet", "legendary", 7 ),
            
            registerItem( "csgo_m9_autotronic", "legendary", 7 ),
            
            registerItem( "csgo_m9_marblefade", "legendary", 7 ),
            
            registerItem( "csgo_daggers_fade", "legendary", 7 ),

            registerItem( "csgo_butterfly_damascus", "legendary", 7 ),

            registerItem( "csgo_karambit_damascus", "legendary", 7 ),
        
            registerItem( "csgo_bayonet_lore", "mythical", 3 ),
            
            registerItem( "csgo_butterfly_fade", "mythical", 3 ),
            
            registerItem( "csgo_butterfly_marblefade", "mythical", 3 ),
            
            registerItem( "csgo_flip_lore", "mythical", 3 ),
            
            registerItem( "csgo_gut_lore", "mythical", 3 ),
            
            registerItem( "csgo_karambit_autotronic", "mythical", 3 ),
            
            registerItem( "csgo_karambit_lore", "mythical", 3 ),
            
            registerItem( "csgo_karambit_marblefade", "mythical", 3 ),
            
            registerItem( "csgo_m9_lore", "mythical", 3 ),

            registerItem( "csgo_karambit_fade", "mythical", 3 ),

            registerItem( "csgo_karambit_case", "mythical", 3 ),

            registerItem( "csgo_butterfly_case", "mythical", 3 ),

            registerItem( "csgo_karambit_tiger", "mythical", 3 ),

            registerItem( "csgo_butterfly_tiger", "mythical", 3 ),

        }, 
    },

    {
        ["ID"] = "m_crate_legendary", // For the inventory Database. 

        ["Name"] = "Legendary Knife Crate", 
        ["Icon"] = "m_unbox_crate_2", 

        ["Rarity"] = "legendary",
        ["Price"] = 3000000, 

        ["Category"] = "perm_knifes",

        ["Items"] = {

            registerItem( "csgo_bayonet_boreal", "rare", 62 ),

            registerItem( "csgo_bayonet_bluesteel", "rare", 62 ),
            
            registerItem( "csgo_bayonet_bright_water", "rare", 62 ),
            
            registerItem( "csgo_bowie_damascus", "rare", 62 ),
            
            registerItem( "csgo_bowie_bright_water", "rare", 62 ),
            
            registerItem( "csgo_falchion_boreal", "rare", 62 ),
            
            registerItem( "csgo_falchion_night", "rare", 62 ),
            
            registerItem( "csgo_falchion_ddpat", "rare", 62 ),

            registerItem( "csgo_falchion_bright_water", "rare", 62 ),
            
            registerItem( "csgo_flip_black_laminate", "rare", 62 ),

            registerItem( "csgo_bayonet_ddpat", "rare", 62 ),
            
            registerItem( "csgo_flip_bluesteel", "rare", 62 ),
            
            registerItem( "csgo_flip_bright_water", "rare", 62 ),
            
            registerItem( "csgo_flip_boreal", "rare", 62 ),
            
            registerItem( "csgo_gut_bluesteel", "rare", 62 ),
            
            registerItem( "csgo_gut_boreal", "rare", 62 ),
            
            registerItem( "csgo_gut_damascus", "rare", 62 ),
            
            registerItem( "csgo_gut_night", "rare", 62 ),
            
            registerItem( "csgo_huntsman_bluesteel", "rare", 62 ),
            
            registerItem( "csgo_huntsman_boreal", "rare", 62 ),
            
            registerItem( "csgo_m9_bluesteel", "rare", 62 ),
            
            registerItem( "csgo_m9_boreal", "rare", 62 ),
            
            registerItem( "csgo_m9_bright_water", "rare", 62 ),
            
            registerItem( "csgo_daggers_bluesteel", "rare", 62 ),
            
            registerItem( "csgo_daggers_bright_water", "rare", 62 ),  
            
            registerItem( "csgo_daggers_boreal", "rare", 62 ),  
            
            registerItem( "csgo_daggers_ddpat", "rare", 62 ),  
            
            registerItem( "csgo_bayonet_black_laminate", "epic", 24 ),
            
            registerItem( "csgo_bayonet_case", "epic", 24 ),
            
            registerItem( "csgo_bayonet_crimsonwebs", "epic", 24 ),
            
            registerItem( "csgo_bayonet_gamma_doppler", "epic", 24 ),
            
            registerItem( "csgo_bowie_case", "epic", 24 ),
            
            registerItem( "csgo_bowie_crimsonwebs", "epic", 24 ),
            
            registerItem( "csgo_bowie_night", "epic", 24 ),
            
            registerItem( "csgo_bowie_slaughter", "epic", 24 ),

            registerItem( "csgo_daggers_gamma_doppler", "epic", 24 ),
            
            registerItem( "csgo_butterfly", "epic", 24 ),
            
            registerItem( "csgo_butterfly_boreal", "epic", 24 ),
            
            registerItem( "csgo_butterfly_bluesteel", "epic", 24 ),

            registerItem( "csgo_bowie_gamma_doppler", "epic", 24 ),

            registerItem( "csgo_flip_gamma_doppler", "epic", 24 ),
            
            registerItem( "csgo_butterfly_ddpat", "epic", 24 ),
            
            registerItem( "csgo_falchion_case", "epic", 24 ),
            
            registerItem( "csgo_falchion_slaughter", "epic", 24 ),
            
            registerItem( "csgo_falchion_ultraviolet", "epic", 24 ),
            
            registerItem( "csgo_falchion_tiger", "epic", 24 ),
            
            registerItem( "csgo_flip_crimsonwebs", "epic", 24 ),
            
            registerItem( "csgo_flip_gamma_doppler", "epic", 24 ),
            
            registerItem( "csgo_flip_tiger", "epic", 24 ),
            
            registerItem( "csgo_flip_ultraviolet", "epic", 24 ),
            
            registerItem( "csgo_gut_case", "epic", 24 ),
            
            registerItem( "csgo_gut_freehand", "epic", 24 ),
            
            registerItem( "csgo_gut_gamma_doppler", "epic", 24 ),
    
            registerItem( "csgo_gut_ultraviolet", "epic", 24 ),
            
            registerItem( "csgo_huntsman_case", "epic", 24 ),
            
            registerItem( "csgo_huntsman_crimsonwebs", "epic", 24 ),
            
            registerItem( "csgo_huntsman_freehand", "epic", 24 ),
            
            registerItem( "csgo_huntsman_gamma_doppler", "epic", 24 ),
            
            registerItem( "csgo_huntsman_slaughter", "epic", 24 ),
            
            registerItem( "csgo_huntsman_ultraviolet", "epic", 24 ),
            
            registerItem( "csgo_karambit", "epic", 24 ),
            
            registerItem( "csgo_karambit_boreal", "epic", 24 ),
            
            registerItem( "csgo_karambit_bright_water", "epic", 24 ),
            
            registerItem( "csgo_karambit_night", "epic", 24 ),
            
            registerItem( "csgo_karambit_ddpat", "epic", 24 ),
            
            registerItem( "csgo_m9_black_laminate", "epic", 24 ),
            
            registerItem( "csgo_m9_case", "epic", 24 ),
            
            registerItem( "csgo_m9_crimsonwebs", "epic", 24 ),
            
            registerItem( "csgo_m9_freehand", "epic", 24 ),
            
            registerItem( "csgo_m9_gamma_doppler", "epic", 24 ),
            
            registerItem( "csgo_m9_slaughter", "epic", 24 ),
            
            registerItem( "csgo_m9_tiger", "epic", 24 ),
            
            registerItem( "csgo_m9_ultraviolet", "epic", 24 ),
            
            registerItem( "csgo_daggers_case", "epic", 24 ),
            
            registerItem( "csgo_daggers_slaughter", "epic", 24 ),
            
            registerItem( "csgo_daggers_ultraviolet", "epic", 24 ),
            
            registerItem( "csgo_daggers_tiger", "epic", 24 ),
            
            registerItem( "csgo_bayonet_autotronic", "legendary", 9 ),
            
            registerItem( "csgo_bayonet_fade", "legendary", 9 ),
            
            registerItem( "csgo_bayonet_marblefade", "legendary", 9 ),
            
            registerItem( "csgo_bowie_fade", "legendary", 10 ),
            
            registerItem( "csgo_bowie_marblefade", "legendary", 9 ),
            
            registerItem( "csgo_butterfly_crimsonwebs", "legendary", 9 ),
            
            registerItem( "csgo_butterfly_slaughter", "legendary", 9 ),
            
            registerItem( "csgo_butterfly_ultraviolet", "legendary", 10 ),
            
            registerItem( "csgo_butterfly_freehand", "legendary", 9 ),
            
            registerItem( "csgo_butterfly_gamma_doppler", "legendary", 9 ),
            
            registerItem( "csgo_falchion_fade", "legendary", 9 ),
            
            registerItem( "csgo_falchion_marblefade", "legendary", 9 ),
            
            registerItem( "csgo_flip_autotronic", "legendary", 10 ),
            
            registerItem( "csgo_flip_fade", "legendary", 10 ),
            
            registerItem( "csgo_flip_marblefade", "legendary", 10 ),
            
            registerItem( "csgo_gut_autotronic", "legendary", 10 ),
    
            registerItem( "csgo_gut_marblefade", "legendary", 10 ),
            
            registerItem( "csgo_huntsman_fade", "legendary", 10 ),

            registerItem( "csgo_butterfly_gamma_doppler", "legendary", 9 ),
            
            registerItem( "csgo_huntsman_marblefade", "legendary", 9 ),
            
            registerItem( "csgo_karambit_black_laminate", "legendary", 9 ),
            
            registerItem( "csgo_karambit_crimsonwebs", "legendary", 9 ),
            
            registerItem( "csgo_karambit_freehand", "legendary", 9 ),
            
            registerItem( "csgo_karambit_gamma_doppler", "legendary", 9 ),

            registerItem( "csgo_butterfly_gamma_doppler", "legendary", 10 ),
            
            registerItem( "csgo_karambit_ultraviolet", "legendary", 10 ),
            
            registerItem( "csgo_m9_autotronic", "legendary", 9 ),
            
            registerItem( "csgo_m9_marblefade", "legendary", 10 ),
            
            registerItem( "csgo_daggers_fade", "legendary", 9 ),

            registerItem( "csgo_gut_fade", "legendary", 10 ),

            registerItem( "csgo_butterfly_damascus", "legendary", 9),

            registerItem( "csgo_karambit_damascus", "legendary", 10 ),
            
            registerItem( "csgo_bayonet_lore", "mythical", 5),
            
            registerItem( "csgo_butterfly_fade", "mythical", 4 ),
            
            registerItem( "csgo_butterfly_marblefade", "mythical", 5 ),
            
            registerItem( "csgo_flip_lore", "mythical", 4 ),
            
            registerItem( "csgo_gut_lore", "mythical", 5 ),
            
            registerItem( "csgo_karambit_autotronic", "mythical", 4 ),
            
            registerItem( "csgo_karambit_lore", "mythical", 4 ),
            
            registerItem( "csgo_karambit_marblefade", "mythical", 4 ),
            
            registerItem( "csgo_m9_lore", "mythical", 5 ),

            registerItem( "csgo_karambit_fade", "mythical", 4 ),

            registerItem( "csgo_karambit_case", "mythical", 5 ),

            registerItem( "csgo_butterfly_case", "mythical", 4 ),

            registerItem( "csgo_karambit_tiger", "mythical", 4 ),

            registerItem( "csgo_butterfly_tiger", "mythical", 5 ),

        }, 
    },

    {
        ["ID"] = "m_crate_lightsaber", // For the inventory Database. 

        ["Name"] = "Lightsaber!", 
        ["Icon"] = "m_unbox_crate_2", 
        
        ["Category"] = "perm_knifes", 

        ["Rarity"] = "mythical",
        ["Price"] = 100000000, 

        ["Items"] = {

            registerItem( "weapon_lightsaber", "mythical", 50 ),

        },
    },

    {
        ["ID"] = "m_crate_temp_rare", // For the inventory Database. 

        ["Name"] = "High Tier crate", 
        ["Icon"] = "m_unbox_crate_2", 

        ["Rarity"] = "legendary",
        ["Price"] = 1000000, 

        ["Category"] = "temp_weapons",

        ["Items"] = {

            registerItem( "m9k_winchester73", "rare", 75, true ),

            registerItem( "m9k_winchester73", "epic", 35, true ),

            registerItem( "m9k_winchester73", "legendary", 16, true ),

            registerItem( "m9k_winchester73", "mythical", 6, true ),

            registerItem( "m9k_acr", "rare", 75, true ),

            registerItem( "m9k_acr", "epic", 35, true ),

            registerItem( "m9k_acr", "legendary", 16, true ),

            registerItem( "m9k_acr", "mythical", 4, true ),

            registerItem( "m9k_ak47", "rare", 75, true ),

            registerItem( "m9k_ak47", "epic", 35, true ),

            registerItem( "m9k_ak47", "legendary", 16, true ),

            registerItem( "m9k_ak47", "mythical", 4, true ),

            registerItem( "m9k_ak74", "rare", 75, true ),

            registerItem( "m9k_ak74", "epic", 35, true ),

            registerItem( "m9k_ak74", "legendary", 16, true ),

            registerItem( "m9k_ak74", "mythical", 4, true ),

            registerItem( "m9k_amd65", "rare", 75, true ),

            registerItem( "m9k_amd65", "epic", 35, true ),

            registerItem( "m9k_amd65", "legendary", 16, true ),

            registerItem( "m9k_amd65", "mythical", 4, true ),

            registerItem( "m9k_val", "rare", 75, true ),

            registerItem( "m9k_val", "epic", 35, true ),

            registerItem( "m9k_val", "legendary", 16, true ),

            registerItem( "m9k_val", "mythical", 4, true ),

            registerItem( "m9k_f2000", "rare", 75, true ),

            registerItem( "m9k_f2000", "epic", 35, true ),

            registerItem( "m9k_f2000", "legendary", 16, true ),

            registerItem( "m9k_f2000", "mythical", 4, true ),

            registerItem( "m9k_fal", "rare", 75, true ),

            registerItem( "m9k_fal", "epic", 35, true ),

            registerItem( "m9k_fal", "legendary", 16, true ),

            registerItem( "m9k_fal", "mythical", 4, true ),

            registerItem( "m9k_g36", "rare", 75, true ),

            registerItem( "m9k_g36", "epic", 35, true ),

            registerItem( "m9k_g36", "legendary", 16, true ),

            registerItem( "m9k_g36", "mythical", 4, true ),

            registerItem( "m9k_m416", "rare", 75, true ),

            registerItem( "m9k_m416", "epic", 35, true ),

            registerItem( "m9k_m416", "legendary", 16, true ),

            registerItem( "m9k_m416", "mythical", 4, true ),

            registerItem( "m9k_g3a3", "rare", 75, true ),

            registerItem( "m9k_g3a3", "epic", 35, true ),

            registerItem( "m9k_g3a3", "legendary", 16, true ),

            registerItem( "m9k_g3a3", "mythical", 4, true ),

            registerItem( "m9k_l85", "rare", 75, true ),

            registerItem( "m9k_l85", "epic", 35, true ),

            registerItem( "m9k_l85", "legendary", 16, true ),

            registerItem( "m9k_l85", "mythical", 4, true ),

            registerItem( "m9k_m14sp", "rare", 75, true ),

            registerItem( "m9k_m14sp", "epic", 35, true ),

            registerItem( "m9k_m14sp", "legendary", 16, true ),

            registerItem( "m9k_m14sp", "mythical", 4, true ),

            registerItem( "m9k_m16a4_acog", "rare", 75, true ),

            registerItem( "m9k_m16a4_acog", "epic", 35, true ),

            registerItem( "m9k_m16a4_acog", "legendary", 16, true ),

            registerItem( "m9k_m16a4_acog", "mythical", 4, true ),

            registerItem( "m9k_scar", "rare", 75, true ),

            registerItem( "m9k_scar", "epic", 35, true ),

            registerItem( "m9k_scar", "legendary", 16, true ),

            registerItem( "m9k_scar", "mythical", 4, true ),

            registerItem( "m9k_vikhr", "rare", 75, true ),

            registerItem( "m9k_vikhr", "epic", 35, true ),

            registerItem( "m9k_vikhr", "legendary", 16, true ),

            registerItem( "m9k_vikhr", "mythical", 4, true ),

            registerItem( "m9k_auga3", "rare", 75, true ),

            registerItem( "m9k_auga3", "epic", 35, true ),

            registerItem( "m9k_auga3", "legendary", 16, true ),

            registerItem( "m9k_auga3", "mythical", 4, true ),

            registerItem( "m9k_tar21", "rare", 75, true ),

            registerItem( "m9k_tar21", "epic", 35, true ),

            registerItem( "m9k_tar21", "legendary", 16, true ),

            registerItem( "m9k_tar21", "mythical", 4, true ),

            ---------------------------------------

            registerItem( "m9k_fg42", "rare", 75, true ),

            registerItem( "m9k_fg42", "epic", 35, true ),

            registerItem( "m9k_fg42", "legendary", 16, true ),

            registerItem( "m9k_fg42", "mythical", 4, true ),

            registerItem( "m9k_ares_shrike", "rare", 75, true ),

            registerItem( "m9k_ares_shrike", "epic", 35, true ),

            registerItem( "m9k_ares_shrike", "legendary", 16, true ),

            registerItem( "m9k_ares_shrike", "mythical", 4, true ),

            registerItem( "m9k_m1918bar", "rare", 75, true ),

            registerItem( "m9k_m1918bar", "epic", 35, true ),

            registerItem( "m9k_m1918bar", "legendary", 16, true ),

            registerItem( "m9k_m1918bar", "mythical", 4, true ),

            registerItem( "m9k_m249lmg", "rare", 75, true ),

            registerItem( "m9k_m249lmg", "epic", 35, true ),

            registerItem( "m9k_m249lmg", "legendary", 16, true ),

            registerItem( "m9k_m249lmg", "mythical", 4, true ),

            registerItem( "m9k_m60", "rare", 75, true ),

            registerItem( "m9k_m60", "epic", 35, true ),

            registerItem( "m9k_m60", "legendary", 16, true ),

            registerItem( "m9k_m60", "mythical", 4, true ),

            registerItem( "m9k_pkm", "rare", 75, true ),

            registerItem( "m9k_pkm", "epic", 35, true ),

            registerItem( "m9k_pkm", "legendary", 16, true ),

            registerItem( "m9k_pkm", "mythical", 4, true ),

            -------------------------------------------------

            registerItem( "m9k_colt1911", "rare", 75, true ),

            registerItem( "m9k_colt1911", "epic", 35, true ),

            registerItem( "m9k_colt1911", "legendary", 16, true ),
            
            registerItem( "m9k_colt1911", "mythical", 4, true ),

            registerItem( "m9k_coltpython", "rare", 75, true ),

            registerItem( "m9k_coltpython", "epic", 35, true ),

            registerItem( "m9k_coltpython", "legendary", 16, true ),

            registerItem( "m9k_coltpython", "mythical", 4, true ),

            registerItem( "m9k_deagle", "rare", 75, true ),

            registerItem( "m9k_deagle", "epic", 35, true ),

            registerItem( "m9k_deagle", "legendary", 16, true ),

            registerItem( "m9k_deagle", "mythical", 4, true ),

            registerItem( "m9k_glock", "rare", 75, true ),

            registerItem( "m9k_glock", "epic", 35, true ),

            registerItem( "m9k_glock", "legendary", 16, true ),

            registerItem( "m9k_glock", "mythical", 4, true ),

            registerItem( "m9k_usp", "rare", 75, true ),

            registerItem( "m9k_usp", "epic", 35, true ),

            registerItem( "m9k_usp", "legendary", 16, true ),

            registerItem( "m9k_usp", "mythical", 4, true ),

            registerItem( "m9k_hk45", "rare", 75, true ),

            registerItem( "m9k_hk45", "epic", 35, true ),

            registerItem( "m9k_hk45", "legendary", 16, true ),

            registerItem( "m9k_hk45", "mythical", 4, true ),

            registerItem( "m9k_m92beretta", "rare", 75, true ),

            registerItem( "m9k_m92beretta", "epic", 35, true ),

            registerItem( "m9k_m92beretta", "legendary", 16, true ),

            registerItem( "m9k_m92beretta", "mythical", 4, true ),

            registerItem( "m9k_luger", "rare", 75, true ),

            registerItem( "m9k_luger", "epic", 35, true ),

            registerItem( "m9k_luger", "legendary", 16, true ),

            registerItem( "m9k_luger", "mythical", 4, true ),

            registerItem( "m9k_ragingbull", "rare", 75, true ),

            registerItem( "m9k_ragingbull", "epic", 35, true ),

            registerItem( "m9k_ragingbull", "legendary", 16, true ),

            registerItem( "m9k_ragingbull", "mythical", 4, true ),

            registerItem( "m9k_scoped_taurus", "rare", 75, true ),

            registerItem( "m9k_scoped_taurus", "epic", 35, true ),

            registerItem( "m9k_scoped_taurus", "legendary", 16, true ),

            registerItem( "m9k_scoped_taurus", "mythical", 4, true ),

            registerItem( "m9k_remington1858", "rare", 75, true ),

            registerItem( "m9k_remington1858", "epic", 35, true ),

            registerItem( "m9k_remington1858", "legendary", 16, true ),

            registerItem( "m9k_remington1858", "mythical", 4, true ),

            registerItem( "m9k_model3russian", "rare", 75, true ),

            registerItem( "m9k_model3russian", "epic", 35, true ),

            registerItem( "m9k_model3russian", "legendary", 16, true ),

            registerItem( "m9k_model3russian", "mythical", 4, true ),

            registerItem( "m9k_model500", "rare", 75, true ),

            registerItem( "m9k_model500", "epic", 35, true ),

            registerItem( "m9k_model500", "legendary", 16, true ),

            registerItem( "m9k_model500", "mythical", 4, true ),

            registerItem( "m9k_model627", "rare", 75, true ),

            registerItem( "m9k_model627", "epic", 35, true ),

            registerItem( "m9k_model627", "legendary", 16, true ),

            registerItem( "m9k_model627", "mythical", 4, true ),

            registerItem( "m9k_sig_p229r", "rare", 75, true ),

            registerItem( "m9k_sig_p229r", "epic", 35, true ),

            registerItem( "m9k_sig_p229r", "legendary", 16, true ),

            registerItem( "m9k_sig_p229r", "mythical", 4, true ),

            ----------------------------------------

            registerItem( "m9k_m3", "rare", 75, true ),

            registerItem( "m9k_m3", "epic", 35, true ),

            registerItem( "m9k_m3", "legendary", 16, true ),

            registerItem( "m9k_m3", "mythical", 4, true ),

            registerItem( "m9k_browningauto5", "rare", 75, true ),

            registerItem( "m9k_browningauto5", "epic", 35, true ),

            registerItem( "m9k_browningauto5", "legendary", 16, true ),

            registerItem( "m9k_browningauto5", "mythical", 4, true ),

            registerItem( "m9k_browningauto5", "rare", 75, true ),

            registerItem( "m9k_browningauto5", "epic", 35, true ),

            registerItem( "m9k_browningauto5", "legendary", 16, true ),

            registerItem( "m9k_browningauto5", "mythical", 4, true ),

            registerItem( "m9k_dbarrel", "rare", 75, true ),

            registerItem( "m9k_dbarrel", "epic", 35, true ),

            registerItem( "m9k_dbarrel", "legendary", 16, true ),

            registerItem( "m9k_dbarrel", "mythical", 4, true ),

            registerItem( "m9k_ithacam37", "rare", 75, true ),

            registerItem( "m9k_ithacam37", "epic", 35, true ),

            registerItem( "m9k_ithacam37", "legendary", 16, true ),

            registerItem( "m9k_ithacam37", "mythical", 4, true ),

            registerItem( "m9k_mossberg590", "rare", 75, true ),

            registerItem( "m9k_mossberg590", "epic", 35, true ),

            registerItem( "m9k_mossberg590", "legendary", 16, true ),

            registerItem( "m9k_mossberg590", "mythical", 4, true ),

            registerItem( "m9k_jackhammer", "rare", 75, true ),

            registerItem( "m9k_jackhammer", "epic", 35, true ),

            registerItem( "m9k_jackhammer", "legendary", 16, true ),

            registerItem( "m9k_jackhammer", "mythical", 4, true ),

            registerItem( "m9k_remington870", "rare", 75, true ),

            registerItem( "m9k_remington870", "epic", 35, true ),

            registerItem( "m9k_remington870", "legendary", 16, true ),

            registerItem( "m9k_remington870", "mythical", 4, true ),

            registerItem( "m9k_remington870", "rare", 75, true ),

            registerItem( "m9k_remington870", "epic", 35, true ),

            registerItem( "m9k_remington870", "legendary", 16, true ),
            
            registerItem( "m9k_remington870", "mythical", 4, true ),

            registerItem( "m9k_striker12", "rare", 75, true ),

            registerItem( "m9k_striker12", "epic", 35, true ),

            registerItem( "m9k_striker12", "legendary", 16, true ),

            registerItem( "m9k_striker12", "mythical", 4, true ),

            registerItem( "m9k_usas", "rare", 75, true ),

            registerItem( "m9k_usas", "epic", 35, true ),

            registerItem( "m9k_usas", "legendary", 16, true ),

            registerItem( "m9k_usas", "mythical", 4, true ),

            registerItem( "m9k_1897winchester", "rare", 75, true ),

            registerItem( "m9k_1897winchester", "epic", 35, true ),

            registerItem( "m9k_1897winchester", "legendary", 16, true ),

            registerItem( "m9k_1897winchester", "mythical", 4, true ),

            registerItem( "m9k_1887winchester", "rare", 75, true ),

            registerItem( "m9k_1887winchester", "epic", 35, true ),

            registerItem( "m9k_1887winchester", "legendary", 16, true ),

            registerItem( "m9k_1887winchester", "mythical", 4, true ),

            ----------------------------------------------

            registerItem( "m9k_aw50", "rare", 75, true ),

            registerItem( "m9k_aw50", "epic", 35, true ),

            registerItem( "m9k_aw50", "legendary", 16, true ),

            registerItem( "m9k_aw50", "mythical", 4, true ),

            registerItem( "m9k_barret_m82", "rare", 75, true ),

            registerItem( "m9k_barret_m82", "epic", 35, true ),

            registerItem( "m9k_barret_m82", "legendary", 16, true ),

            registerItem( "m9k_barret_m82", "mythical", 4, true ),

            registerItem( "m9k_m98b", "rare", 75, true ),

            registerItem( "m9k_m98b", "epic", 35, true ),

            registerItem( "m9k_m98b", "legendary", 16, true ),

            registerItem( "m9k_m98b", "mythical", 4, true ),

            registerItem( "m9k_svu", "rare", 75, true ),

            registerItem( "m9k_svu", "epic", 35, true ),

            registerItem( "m9k_svu", "legendary", 16, true ),

            registerItem( "m9k_svu", "mythical", 4, true ),

            registerItem( "m9k_sl8", "rare", 75, true ),

            registerItem( "m9k_sl8", "epic", 35, true ),

            registerItem( "m9k_sl8", "legendary", 16, true ),

            registerItem( "m9k_sl8", "mythical", 4, true ),

            registerItem( "m9k_intervention", "rare", 75, true ),

            registerItem( "m9k_intervention", "epic", 35, true ),

            registerItem( "m9k_intervention", "legendary", 16, true ),

            registerItem( "m9k_intervention", "mythical", 4, true ),

            registerItem( "m9k_m24", "rare", 75, true ),

            registerItem( "m9k_m24", "epic", 35, true ),

            registerItem( "m9k_m24", "legendary", 16, true ),

            registerItem( "m9k_m24", "legendary", 4, true ),

            registerItem( "m9k_psg1", "rare", 75, true ),

            registerItem( "m9k_psg1", "epic", 35, true ),

            registerItem( "m9k_psg1", "legendary", 16, true ),

            registerItem( "m9k_psg1", "mythical", 4, true ),

            -----------------------------------------------------

            registerItem( "m9k_honeybadger", "rare", 75, true ),

            registerItem( "m9k_honeybadger", "epic", 35, true ),

            registerItem( "m9k_honeybadger", "legendary", 16, true ),

            registerItem( "m9k_honeybadger", "mythical", 4, true ),

            registerItem( "m9k_bizonp19", "rare", 75, true ),

            registerItem( "m9k_bizonp19", "epic", 35, true ),

            registerItem( "m9k_bizonp19", "legendary", 16, true ),

            registerItem( "m9k_bizonp19", "mythical", 4, true ),

            registerItem( "m9k_smgp90", "rare", 75, true ),

            registerItem( "m9k_smgp90", "epic", 35, true ),

            registerItem( "m9k_smgp90", "legendary", 16, true ),

            registerItem( "m9k_smgp90", "mythical", 4, true ),

            registerItem( "m9k_mp5", "rare", 75, true ),

            registerItem( "m9k_mp5", "epic", 35, true ),

            registerItem( "m9k_mp5", "legendary", 16, true ),

            registerItem( "m9k_mp5", "mythical", 4, true ),

            registerItem( "m9k_mp7", "rare", 75, true ),

            registerItem( "m9k_mp7", "epic", 35, true ),

            registerItem( "m9k_mp7", "legendary", 16, true ),

            registerItem( "m9k_mp7", "mythical", 4, true ),

            registerItem( "m9k_ump45", "rare", 75, true ),

            registerItem( "m9k_ump45", "epic", 35, true ),

            registerItem( "m9k_ump45", "legendary", 16, true ),

            registerItem( "m9k_ump45", "mythical", 4, true ),

            registerItem( "m9k_usc", "rare", 75, true ),

            registerItem( "m9k_usc", "epic", 35, true ),

            registerItem( "m9k_usc", "legendary", 16, true ),

            registerItem( "m9k_usc", "mythical", 4, true ),

            registerItem( "m9k_kac_pdw", "rare", 75, true ),

            registerItem( "m9k_kac_pdw", "epic", 35, true ),

            registerItem( "m9k_kac_pdw", "legendary", 16, true ),

            registerItem( "m9k_kac_pdw", "mythical", 4, true ),

            registerItem( "m9k_vector", "rare", 75, true ),

            registerItem( "m9k_vector", "epic", 35, true ),

            registerItem( "m9k_vector", "legendary", 16, true ),

            registerItem( "m9k_vector", "mythical", 4, true ),

            registerItem( "m9k_magpulpdr", "rare", 75, true ),

            registerItem( "m9k_magpulpdr", "epic", 35, true ),

            registerItem( "m9k_magpulpdr", "legendary", 16, true ),

            registerItem( "m9k_magpulpdr", "mythical", 4, true ),

            registerItem( "m9k_mp40", "rare", 75, true ),

            registerItem( "m9k_mp40", "epic", 35, true ),

            registerItem( "m9k_mp40", "legendary", 16, true ),

            registerItem( "m9k_mp40", "mythical", 4, true ),

            registerItem( "m9k_mp5sd", "rare", 75, true ),

            registerItem( "m9k_mp5sd", "epic", 35, true ),

            registerItem( "m9k_mp5sd", "legendary", 16, true ),

            registerItem( "m9k_mp5sd", "mythical", 4, true ),

            registerItem( "m9k_mp9", "rare", 75, true ),

            registerItem( "m9k_mp9", "epic", 35, true ),

            registerItem( "m9k_mp9", "legendary", 16, true ),

            registerItem( "m9k_mp9", "mythical", 4, true ),

            registerItem( "m9k_sten", "rare", 75, true ),

            registerItem( "m9k_sten", "epic", 35, true ),

            registerItem( "m9k_sten", "legendary", 16, true ),

            registerItem( "m9k_sten", "mythical", 4, true ),

            registerItem( "m9k_tec9", "rare", 75, true ),

            registerItem( "m9k_tec9", "epic", 35, true ),

            registerItem( "m9k_tec9", "legendary", 16, true ),

            registerItem( "m9k_tec9", "mythical", 4, true ),

            registerItem( "m9k_thompson", "rare", 75, true ),

            registerItem( "m9k_thompson", "epic", 35, true ),

            registerItem( "m9k_thompson", "legendary", 16, true ),

            registerItem( "m9k_thompson", "mythical", 4, true ),

            registerItem( "m9k_uzi", "rare", 75, true ),

            registerItem( "m9k_uzi", "epic", 35, true ),

            registerItem( "m9k_uzi", "legendary", 16, true ),
            
            registerItem( "m9k_uzi", "mythical", 4, true ),

            registerItem( "m9k_minigun", "legendary", 10, true ),

            registerItem( "m9k_minigun", "mythical", 2, true ),
        }
    }, 
    {
    
        ["ID"] = "m_crate_temp_low", // For the inventory Database. 

        ["Name"] = "Low Tier crate", 
        ["Icon"] = "m_unbox_crate_2", 

        ["Rarity"] = "rare",
        ["Price"] = 300000, 

        ["Category"] = "temp_weapons",

        ["Items"] = {

            registerItem( "m9k_winchester73", "common", 55, true ),

            registerItem( "m9k_winchester73", "rare", 55, true ),

            registerItem( "m9k_winchester73", "epic", 22, true ),

            registerItem( "m9k_winchester73", "legendary", 5, true ),

            registerItem( "m9k_acr", "common", 55, true ),

            registerItem( "m9k_acr", "rare", 55, true ),

            registerItem( "m9k_acr", "epic", 22, true ),

            registerItem( "m9k_acr", "legendary", 5, true ),

            registerItem( "m9k_ak47", "common", 55, true ),

            registerItem( "m9k_ak47", "rare", 55, true ),

            registerItem( "m9k_ak47", "epic", 22, true ),

            registerItem( "m9k_ak47", "legendary", 5, true ),

            registerItem( "m9k_ak74", "common", 55, true ),

            registerItem( "m9k_ak74", "rare", 55, true ),

            registerItem( "m9k_ak74", "epic", 22, true ),

            registerItem( "m9k_ak74", "legendary", 5, true ),

            registerItem( "m9k_amd65", "common", 55, true ),

            registerItem( "m9k_amd65", "rare", 55, true ),

            registerItem( "m9k_amd65", "epic", 22, true ),

            registerItem( "m9k_amd65", "legendary", 5, true ),

            registerItem( "m9k_val", "common", 55, true ),

            registerItem( "m9k_val", "rare", 55, true ),

            registerItem( "m9k_val", "epic", 22, true ),

            registerItem( "m9k_val", "legendary", 5, true ),

            registerItem( "m9k_f2000", "common", 55, true ),

            registerItem( "m9k_f2000", "rare", 55, true ),

            registerItem( "m9k_f2000", "epic", 22, true ),

            registerItem( "m9k_f2000", "legendary", 5, true ),

            registerItem( "m9k_fal", "common", 55, true ),

            registerItem( "m9k_fal", "rare", 55, true ),

            registerItem( "m9k_fal", "epic", 22, true ),

            registerItem( "m9k_fal", "legendary", 5, true ),

            registerItem( "m9k_g36", "common", 55, true ),

            registerItem( "m9k_g36", "rare", 55, true ),

            registerItem( "m9k_g36", "epic", 22, true ),

            registerItem( "m9k_g36", "legendary", 5, true ),

            registerItem( "m9k_m416", "common", 55, true ),

            registerItem( "m9k_m416", "rare", 55, true ),

            registerItem( "m9k_m416", "epic", 22, true ),

            registerItem( "m9k_m416", "legendary", 5, true ),

            registerItem( "m9k_g3a3", "common", 55, true ),

            registerItem( "m9k_g3a3", "rare", 55, true ),

            registerItem( "m9k_g3a3", "epic", 22, true ),

            registerItem( "m9k_g3a3", "legendary", 5, true ),

            registerItem( "m9k_l85", "common", 55, true ),

            registerItem( "m9k_l85", "rare", 55, true ),

            registerItem( "m9k_l85", "epic", 22, true ),

            registerItem( "m9k_l85", "legendary", 5, true ),

            registerItem( "m9k_m14sp", "common", 55, true ),

            registerItem( "m9k_m14sp", "rare", 55, true ),

            registerItem( "m9k_m14sp", "epic", 22, true ),

            registerItem( "m9k_m14sp", "legendary", 5, true ),

            registerItem( "m9k_m16a4_acog", "common", 55, true ),

            registerItem( "m9k_m16a4_acog", "rare", 55, true ),

            registerItem( "m9k_m16a4_acog", "epic", 22, true ),

            registerItem( "m9k_m16a4_acog", "legendary", 5, true ),

            registerItem( "m9k_scar", "common", 55, true ),

            registerItem( "m9k_scar", "rare", 55, true ),

            registerItem( "m9k_scar", "epic", 22, true ),

            registerItem( "m9k_scar", "legendary", 5, true ),

            registerItem( "m9k_vikhr", "common", 55, true ),

            registerItem( "m9k_vikhr", "rare", 55, true ),

            registerItem( "m9k_vikhr", "epic", 22, true ),

            registerItem( "m9k_vikhr", "legendary", 5, true ),

            registerItem( "m9k_auga3", "common", 55, true ),

            registerItem( "m9k_auga3", "rare", 55, true ),

            registerItem( "m9k_auga3", "epic", 22, true ),

            registerItem( "m9k_auga3", "legendary", 5, true ),

            registerItem( "m9k_tar21", "common", 55, true ),

            registerItem( "m9k_tar21", "rare", 55, true ),

            registerItem( "m9k_tar21", "epic", 22, true ),

            registerItem( "m9k_tar21", "legendary", 5, true ),

            ---------------------------------------

            registerItem( "m9k_fg42", "common", 55, true ),

            registerItem( "m9k_fg42", "rare", 55, true ),

            registerItem( "m9k_fg42", "epic", 22, true ),

            registerItem( "m9k_fg42", "legendary", 5, true ),

            registerItem( "m9k_ares_shrike", "common", 55, true ),

            registerItem( "m9k_ares_shrike", "rare", 55, true ),

            registerItem( "m9k_ares_shrike", "epic", 22, true ),

            registerItem( "m9k_ares_shrike", "legendary", 5, true ),

            registerItem( "m9k_m1918bar", "common", 55, true ),

            registerItem( "m9k_m1918bar", "rare", 55, true ),

            registerItem( "m9k_m1918bar", "epic", 22, true ),

            registerItem( "m9k_m1918bar", "legendary", 5, true ),

            registerItem( "m9k_m249lmg", "common", 55, true ),

            registerItem( "m9k_m249lmg", "rare", 55, true ),

            registerItem( "m9k_m249lmg", "epic", 22, true ),

            registerItem( "m9k_m249lmg", "legendary", 5, true ),

            registerItem( "m9k_m60", "common", 55, true ),

            registerItem( "m9k_m60", "rare", 55, true ),

            registerItem( "m9k_m60", "epic", 22, true ),

            registerItem( "m9k_m60", "legendary", 5, true ),

            registerItem( "m9k_pkm", "common", 55, true ),

            registerItem( "m9k_pkm", "rare", 55, true ),

            registerItem( "m9k_pkm", "epic", 22, true ),

            registerItem( "m9k_pkm", "legendary", 5, true ),

            -------------------------------------------------

            registerItem( "m9k_colt1911", "common", 55, true ),

            registerItem( "m9k_colt1911", "rare", 55, true ),

            registerItem( "m9k_colt1911", "epic", 22, true ),

            registerItem( "m9k_colt1911", "legendary", 5, true ),

            registerItem( "m9k_coltpython", "common", 55, true ),

            registerItem( "m9k_coltpython", "rare", 55, true ),

            registerItem( "m9k_coltpython", "epic", 22, true ),

            registerItem( "m9k_coltpython", "legendary", 5, true ),

            registerItem( "m9k_deagle", "common", 55, true ),

            registerItem( "m9k_deagle", "rare", 55, true ),

            registerItem( "m9k_deagle", "epic", 22, true ),

            registerItem( "m9k_deagle", "legendary", 5, true ),

            registerItem( "m9k_glock", "common", 55, true ),

            registerItem( "m9k_glock", "rare", 55, true ),

            registerItem( "m9k_glock", "epic", 22, true ),

            registerItem( "m9k_glock", "legendary", 5, true ),

            registerItem( "m9k_usp", "common", 55, true ),

            registerItem( "m9k_usp", "rare", 55, true ),

            registerItem( "m9k_usp", "epic", 22, true ),

            registerItem( "m9k_usp", "legendary", 5, true ),

            registerItem( "m9k_hk45", "common", 55, true ),

            registerItem( "m9k_hk45", "rare", 55, true ),

            registerItem( "m9k_hk45", "epic", 22, true ),

            registerItem( "m9k_hk45", "legendary", 5, true ),

            registerItem( "m9k_m92beretta", "common", 55, true ),

            registerItem( "m9k_m92beretta", "rare", 55, true ),

            registerItem( "m9k_m92beretta", "epic", 22, true ),

            registerItem( "m9k_m92beretta", "legendary", 5, true ),

            registerItem( "m9k_luger", "common", 55, true ),

            registerItem( "m9k_luger", "rare", 55, true ),

            registerItem( "m9k_luger", "epic", 22, true ),

            registerItem( "m9k_luger", "legendary", 5, true ),

            registerItem( "m9k_ragingbull", "common", 55, true ),

            registerItem( "m9k_ragingbull", "rare", 55, true ),

            registerItem( "m9k_ragingbull", "epic", 22, true ),

            registerItem( "m9k_ragingbull", "legendary", 5, true ),

            registerItem( "m9k_scoped_taurus", "common", 55, true ),

            registerItem( "m9k_scoped_taurus", "rare", 55, true ),

            registerItem( "m9k_scoped_taurus", "epic", 22, true ),

            registerItem( "m9k_scoped_taurus", "legendary", 5, true ),

            registerItem( "m9k_remington1858", "common", 55, true ),

            registerItem( "m9k_remington1858", "rare", 55, true ),

            registerItem( "m9k_remington1858", "epic", 22, true ),

            registerItem( "m9k_remington1858", "legendary", 5, true ),

            registerItem( "m9k_model3russian", "common", 55, true ),

            registerItem( "m9k_model3russian", "rare", 55, true ),

            registerItem( "m9k_model3russian", "epic", 22, true ),

            registerItem( "m9k_model3russian", "legendary", 5, true ),

            registerItem( "m9k_model500", "common", 55, true ),

            registerItem( "m9k_model500", "rare", 55, true ),

            registerItem( "m9k_model500", "epic", 22, true ),

            registerItem( "m9k_model500", "legendary", 5, true ),

            registerItem( "m9k_model627", "common", 55, true ),

            registerItem( "m9k_model627", "rare", 55, true ),

            registerItem( "m9k_model627", "epic", 22, true ),

            registerItem( "m9k_model627", "legendary", 5, true ),

            registerItem( "m9k_sig_p229r", "common", 55, true ),

            registerItem( "m9k_sig_p229r", "rare", 55, true ),

            registerItem( "m9k_sig_p229r", "epic", 22, true ),

            registerItem( "m9k_sig_p229r", "legendary", 5, true ),

            ----------------------------------------

            registerItem( "m9k_m3", "common", 55, true ),

            registerItem( "m9k_m3", "rare", 55, true ),

            registerItem( "m9k_m3", "epic", 22, true ),

            registerItem( "m9k_m3", "legendary", 5, true ),

            registerItem( "m9k_browningauto5", "common", 55, true ),

            registerItem( "m9k_browningauto5", "rare", 55, true ),

            registerItem( "m9k_browningauto5", "epic", 22, true ),

            registerItem( "m9k_browningauto5", "legendary", 5, true ),

            registerItem( "m9k_browningauto5", "common", 55, true ),

            registerItem( "m9k_browningauto5", "rare", 55, true ),

            registerItem( "m9k_browningauto5", "epic", 22, true ),

            registerItem( "m9k_browningauto5", "legendary", 5, true ),

            registerItem( "m9k_dbarrel", "common", 55, true ),

            registerItem( "m9k_dbarrel", "rare", 55, true ),

            registerItem( "m9k_dbarrel", "epic", 22, true ),

            registerItem( "m9k_dbarrel", "legendary", 5, true ),

            registerItem( "m9k_ithacam37", "common", 55, true ),

            registerItem( "m9k_ithacam37", "rare", 55, true ),

            registerItem( "m9k_ithacam37", "epic", 22, true ),

            registerItem( "m9k_ithacam37", "legendary", 5, true ),

            registerItem( "m9k_mossberg590", "common", 55, true ),

            registerItem( "m9k_mossberg590", "rare", 55, true ),

            registerItem( "m9k_mossberg590", "epic", 22, true ),

            registerItem( "m9k_mossberg590", "legendary", 5, true ),

            registerItem( "m9k_jackhammer", "common", 55, true ),

            registerItem( "m9k_jackhammer", "rare", 55, true ),

            registerItem( "m9k_jackhammer", "epic", 22, true ),

            registerItem( "m9k_jackhammer", "legendary", 5, true ),

            registerItem( "m9k_remington870", "common", 55, true ),

            registerItem( "m9k_remington870", "rare", 55, true ),

            registerItem( "m9k_remington870", "epic", 22, true ),

            registerItem( "m9k_remington870", "legendary", 5, true ),

            registerItem( "m9k_remington870", "common", 55, true ),

            registerItem( "m9k_remington870", "rare", 55, true ),

            registerItem( "m9k_remington870", "epic", 22, true ),

            registerItem( "m9k_remington870", "legendary", 5, true ),

            registerItem( "m9k_striker12", "common", 55, true ),

            registerItem( "m9k_striker12", "rare", 55, true ),

            registerItem( "m9k_striker12", "epic", 22, true ),

            registerItem( "m9k_striker12", "legendary", 5, true ),

            registerItem( "m9k_usas", "common", 55, true ),

            registerItem( "m9k_usas", "rare", 55, true ),

            registerItem( "m9k_usas", "epic", 22, true ),

            registerItem( "m9k_usas", "legendary", 5, true ),

            registerItem( "m9k_1897winchester", "common", 55, true ),

            registerItem( "m9k_1897winchester", "rare", 55, true ),

            registerItem( "m9k_1897winchester", "epic", 22, true ),

            registerItem( "m9k_1897winchester", "legendary", 5, true ),

            registerItem( "m9k_1887winchester", "common", 55, true ),

            registerItem( "m9k_1887winchester", "rare", 55, true ),

            registerItem( "m9k_1887winchester", "epic", 22, true ),

            registerItem( "m9k_1887winchester", "legendary", 5, true ),

            ----------------------------------------------

            registerItem( "m9k_aw50", "common", 55, true ),

            registerItem( "m9k_aw50", "rare", 55, true ),

            registerItem( "m9k_aw50", "epic", 22, true ),

            registerItem( "m9k_aw50", "legendary", 5, true ),

            registerItem( "m9k_barret_m82", "common", 55, true ),

            registerItem( "m9k_barret_m82", "rare", 55, true ),

            registerItem( "m9k_barret_m82", "epic", 22, true ),

            registerItem( "m9k_barret_m82", "legendary", 5, true ),

            registerItem( "m9k_m98b", "common", 55, true ),

            registerItem( "m9k_m98b", "rare", 55, true ),

            registerItem( "m9k_m98b", "epic", 22, true ),

            registerItem( "m9k_m98b", "legendary", 5, true ),

            registerItem( "m9k_svu", "common", 55, true ),

            registerItem( "m9k_svu", "rare", 55, true ),

            registerItem( "m9k_svu", "epic", 22, true ),

            registerItem( "m9k_svu", "legendary", 5, true ),

            registerItem( "m9k_sl8", "common", 55, true ),

            registerItem( "m9k_sl8", "rare", 55, true ),

            registerItem( "m9k_sl8", "epic", 22, true ),

            registerItem( "m9k_sl8", "legendary", 5, true ),

            registerItem( "m9k_intervention", "common", 55, true ),

            registerItem( "m9k_intervention", "rare", 55, true ),

            registerItem( "m9k_intervention", "epic", 22, true ),

            registerItem( "m9k_intervention", "legendary", 5, true ),

            registerItem( "m9k_m24", "common", 55, true ),

            registerItem( "m9k_m24", "rare", 55, true ),

            registerItem( "m9k_m24", "epic", 22, true ),

            registerItem( "m9k_m24", "legendary", 5, true ),

            registerItem( "m9k_psg1", "common", 55, true ),

            registerItem( "m9k_psg1", "rare", 55, true ),

            registerItem( "m9k_psg1", "epic", 22, true ),

            registerItem( "m9k_psg1", "legendary", 5, true ),

            -----------------------------------------------------

            registerItem( "m9k_honeybadger", "common", 55, true ),

            registerItem( "m9k_honeybadger", "rare", 55, true ),

            registerItem( "m9k_honeybadger", "epic", 22, true ),

            registerItem( "m9k_honeybadger", "legendary", 5, true ),

            registerItem( "m9k_bizonp19", "common", 55, true ),

            registerItem( "m9k_bizonp19", "rare", 55, true ),

            registerItem( "m9k_bizonp19", "epic", 22, true ),

            registerItem( "m9k_bizonp19", "legendary", 5, true ),

            registerItem( "m9k_smgp90", "common", 55, true ),

            registerItem( "m9k_smgp90", "rare", 55, true ),

            registerItem( "m9k_smgp90", "epic", 22, true ),

            registerItem( "m9k_smgp90", "legendary", 5, true ),

            registerItem( "m9k_mp5", "common", 55, true ),

            registerItem( "m9k_mp5", "rare", 55, true ),

            registerItem( "m9k_mp5", "epic", 22, true ),

            registerItem( "m9k_mp5", "legendary", 5, true ),

            registerItem( "m9k_mp7", "common", 55, true ),

            registerItem( "m9k_mp7", "rare", 55, true ),

            registerItem( "m9k_mp7", "epic", 22, true ),

            registerItem( "m9k_mp7", "legendary", 5, true ),

            registerItem( "m9k_ump45", "common", 55, true ),

            registerItem( "m9k_ump45", "rare", 55, true ),

            registerItem( "m9k_ump45", "epic", 22, true ),

            registerItem( "m9k_ump45", "legendary", 5, true ),

            registerItem( "m9k_usc", "common", 55, true ),

            registerItem( "m9k_usc", "rare", 55, true ),

            registerItem( "m9k_usc", "epic", 22, true ),

            registerItem( "m9k_usc", "legendary", 5, true ),

            registerItem( "m9k_kac_pdw", "common", 55, true ),

            registerItem( "m9k_kac_pdw", "rare", 55, true ),

            registerItem( "m9k_kac_pdw", "epic", 22, true ),

            registerItem( "m9k_kac_pdw", "legendary", 5, true ),

            registerItem( "m9k_vector", "common", 55, true ),

            registerItem( "m9k_vector", "rare", 55, true ),

            registerItem( "m9k_vector", "epic", 22, true ),

            registerItem( "m9k_vector", "legendary", 5, true ),

            registerItem( "m9k_magpulpdr", "common", 55, true ),

            registerItem( "m9k_magpulpdr", "rare", 55, true ),

            registerItem( "m9k_magpulpdr", "epic", 22, true ),

            registerItem( "m9k_magpulpdr", "legendary", 5, true ),

            registerItem( "m9k_mp40", "common", 55, true ),

            registerItem( "m9k_mp40", "rare", 55, true ),

            registerItem( "m9k_mp40", "epic", 22, true ),

            registerItem( "m9k_mp40", "legendary", 5, true ),

            registerItem( "m9k_mp5sd", "common", 55, true ),

            registerItem( "m9k_mp5sd", "rare", 55, true ),

            registerItem( "m9k_mp5sd", "epic", 22, true ),

            registerItem( "m9k_mp5sd", "legendary", 5, true ),

            registerItem( "m9k_mp9", "common", 55, true ),

            registerItem( "m9k_mp9", "rare", 55, true ),

            registerItem( "m9k_mp9", "epic", 22, true ),

            registerItem( "m9k_mp9", "legendary", 5, true ),

            registerItem( "m9k_sten", "common", 55, true ),

            registerItem( "m9k_sten", "rare", 55, true ),

            registerItem( "m9k_sten", "epic", 22, true ),

            registerItem( "m9k_sten", "legendary", 5, true ),

            registerItem( "m9k_tec9", "common", 55, true ),

            registerItem( "m9k_tec9", "rare", 55, true ),

            registerItem( "m9k_tec9", "epic", 22, true ),

            registerItem( "m9k_tec9", "legendary", 5, true ),

            registerItem( "m9k_thompson", "common", 55, true ),

            registerItem( "m9k_thompson", "rare", 55, true ),

            registerItem( "m9k_thompson", "epic", 22, true ),

            registerItem( "m9k_thompson", "legendary", 5, true ),

            registerItem( "m9k_uzi", "common", 55, true ),

            registerItem( "m9k_uzi", "rare", 55, true ),

            registerItem( "m9k_uzi", "epic", 22, true ),

            registerItem( "m9k_uzi", "legendary", 5, true ),

            registerItem( "m9k_minigun", "legendary", 5, true ),

        }
    },    
    
    {
        ["ID"] = "m_crate_temp_halloween", // For the inventory Database. 

        ["Name"] = "Halloween Tier crate", 
        ["Icon"] = "m_unbox_crate_2", 

        ["Rarity"] = "spooky",
        ["Price"] = 2500000, 

        ["Category"] = "temp_weapons",

        ["Items"] = {

            registerItem( "m9k_harpoon", "spooky", 10, true ),

            registerItem( "m9k_machete", "spooky", 100, true ),

            registerItem( "m9k_damascus", "spooky", 100, true ),

            registerItem( "m9k_knife", "spooky", 100, true ),

            registerItem( "m9k_fists", "spooky", 100, true ),

            registerItem( "weapon_vape_mega", "spooky", 1, true ),

            registerItem( "weapon_vape_dragon", "spooky", 1, true ),

        }
    },

}


