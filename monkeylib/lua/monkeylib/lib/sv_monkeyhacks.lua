// Absolute hack!!

require( "memoize" )
require( "monkeyhooks" )

local PLAYER = FindMetaTable( "Player" )

do // Spawnpoint handler! 
        
    local spawnPoints = {

        {
            spawnPoint = Vector(3066.4072265625,683.37841796875,-195.96875),
            spawnAngle = Angle(-0.35750070214272,-179.56015014648,0), 
        },

        {
            spawnPoint = Vector(3221.2827148438,684.56756591797,-195.96875), 
            spawnAngle = Angle(-0.35750070214272,-179.56015014648,0),
        },

        {
            spawnPoint = Vector(3286.5825195313,685.06884765625,-195.96875),
            spawnAngle = Angle(-0.35750070214272,-179.56015014648,0),
        },

        {
            spawnPoint = Vector(3368.2687988281,885.68096923828,-195.96875),
            spawnAngle = Angle(-0.35750070214272,-179.56015014648,0),
        },

        {
            spawnPoint = Vector(3391.3020019531,1109.3092041016,-195.96875),
            spawnAngle = Angle(-0.35750070214272,-179.56015014648,0),
        },

        {
            spawnPoint = Vector(3212.716796875,1253.298828125,-195.96875),
            spawnAngle = Angle(-0.35750070214272,-179.56015014648,0),
        },
        
        {
            spawnPoint = Vector(3053.7126464844,1122.8061523438,-195.96875),
            spawnAngle = Angle(-0.35750070214272,-179.56015014648,0),
        },

        {
            spawnPoint = Vector(3017.1281738281,843.98876953125,-195.96875),
            spawnAngle = Angle(-0.35750070214272,-179.56015014648,0),
        },

        {
            spawnPoint = Vector(3121.9892578125,929.33770751953,-195.96875),
            spawnAngle = Angle(-0.35750070214272,-179.56015014648,0),
        },
        
        {
            spawnPoint = Vector(3117.7993164063,741.53332519531,-195.96875),
            spawnAngle = Angle(-0.35750070214272,-179.56015014648,0),
        },
        
    }

    local removeCurrentSpawns = function()

        local curSpawns = ents.FindByClass( "info_player_start" )
    
        if ( #curSpawns <= 0 ) then return end 
    
        for k = 1, #curSpawns do 
    
            local ent = curSpawns[k]
            if ( not IsValid( ent ) ) then continue end 
    
            ent.BeingRemoved = true 
            ent:Remove()
    
        end
    end
    
    local createNewSpawn = function( obj )
    
        if ( not istable( obj ) ) then
    
            MonkeyLib.Debug( false, "Failed to create spawnpoint, object isn't a table." )
    
            return 
        end
    
        local vec, ang = obj.spawnPoint, ( obj.spawnAngle or Angle() )
    
        if ( not isvector( vec ) ) then
    
            MonkeyLib.Debug( false, "Failed to create spawnpoint, vector isn't valid." )
    
            return 
        end
    
        local spawnEnt = ents.Create( "info_player_start" )
        spawnEnt:SetPos( vec )
        spawnEnt:SetAngles( ang )
    
        return spawnEnt 
    end
    
    local loadSpawnPoints = function()
        
        MonkeyLib.Debug( false, "Over-writing spawn points!" )
    
        local spawns = spawnPoints 
    
        if ( #spawns <= 0 ) then
    
            MonkeyLib.Debug( false, "Failed to load new spawn points, there's no spawn vectors!" )
    
            return 
        end
    
        removeCurrentSpawns()
    
        for k = 1, #spawns do 
            
            local spawnObj = spawnPoints[k]
    
            createNewSpawn( spawnObj )
    
        end
    end
    
    hook.Protect( "InitPostEntity", "MonkeyLib:MonkeyHacks:CreateSpawns", function()
    
        loadSpawnPoints()
    
    end )

end

do // Stop the demote! 

    hook.Add( "canDemote", "MonkeyLib:MonkeyHacks:StopDemote", function()
    
        return false 
    end )

end

do // Arrest batton cooldown 
    
    local arrestCooldown = 8 

    local arrestCooldowns = {}

    local arrestFailedStamp = "You can't arrest for another %d's"

    hook.Add( "canArrest", "MonkeyLib:MonkeyHacks:ArrestCooldown", function( ply )
    
        if ( not IsValid( ply ) ) then 

            return 
        end 

        local cooldown = arrestCooldowns[ply] or 0 

        do 

            cooldown = ( cooldown - CurTime() ) 
            cooldown = math.floor( cooldown )

        end

        if ( cooldown < 0 ) then
           
            return 
        end

        local errorMessage = arrestFailedStamp:format( cooldown )

        return false, errorMessage
    end )

    hook.Protect( "playerArrested", "MonkeyLib:MonkeyHacks:InitArrestCooldown", function(_, __, ply) 

        if ( not IsValid( ply ) ) then
            
            return 
        end

        arrestCooldowns[ply] = ( CurTime() + arrestCooldown )

    end )   

end

do // Stop ramming chairs! 

    local canRam = {

        ["prop_vehicle_prisoner_pod"] = false, 
    
    }
    
    hook.Add( "canDoorRam", "MonkeyLib:MonkeyHacks:StopTheRam", function( ply, _, chair )
    
        if ( not IsValid( ply ) or not IsValid( chair ) ) then 
            
            return  
        end 
    
        local class = chair:GetClass()

        return canRam[ class ]
    end )
end 

do // Hard block on the Give function 

    local oldGive 

    local giveFunc = function( ply, weaponID, noAmmo )

        assert( isfunction( oldGive ), "Old give function hasn't been instated!" )

        local succ = hook.Run( "MonkeyLib:CanGiveWeapon", ply, weaponID, noAmmo )

        if ( succ == false ) then 

            return 
        end

        return oldGive( ply, weaponID, noAmmo )
    end 

    hook.Protect( "Initialize", "MonkeyLib:MonkeyHacks:StopTheGive", function()
    
        oldGive = PLAYER.Give 

        PLAYER.Give = giveFunc 

    end )
    
end

do // Entity Blacklist 

    local blacklistedEntities = {
        ["gmod_contr_spawner"] = true,  
    }

    local entIsBlacklisted = function( ent )

        return ( IsValid( ent ) and ( blacklistedEntities[ ent:GetClass() ] == true ) )
    end

    hook.Protect( "OnEntityCreated", "MonkeyLib:MonkeyHacks:StopSpawningWeirdEnts", function( ent )
    
        if ( not IsValid( ent ) ) then 

            return 
        end

        local isBlacklisted = entIsBlacklisted( ent )

        if ( not isBlacklisted ) then 

            return 
        end

        timer.Simple( 0, function()

            if ( not IsValid( ent ) ) then 

                return 
            end

            SafeRemoveEntity( ent )

        end )

    end )
    
end

do // Weapon drop limiter 

    local canDrop = {}

    local setDrop = function( weapon )

        if ( not IsValid( weapon ) ) then 
            
            return 
        end 

        weapon.MonkeyLib_CanDrop = true 

    end 

    hook.Add( "canDropWeapon", "MonkeyLib:MonkeyHacks:CanDropWeapon", function( ply, weapon )

        if ( not IsValid( ply ) or not IsValid( weapon ) ) then 
            
            return 
        end 

        local foundClass = weapon:GetClass()

        local canDropWeapon = weapon.MonkeyLib_CanDrop

        do 

            canDropWeapon = ( ( canDrop[foundClass] == true ) and true ) or canDropWeapon 
  
        end

        if ( not canDropWeapon ) then 
            
            return false 
        end 
          
    end )

    hook.Add( "playerPickedUpWeapon", "MonkeyLib:MonkeyHacks:StoreDarkRPWeapon", function( ply, _, weapon ) 

        setDrop( weapon )

    end )

    hook.Add( "ItemStoreItemUsed", "MonkeyLib:MonkeyHacks:StoreInventorWeapon", function( ply, _, data )

        local itemData = data.Data 

        if ( not istable( itemData ) ) then 
            
            return 
        end 
        
        local weaponClass = itemData.Class 

        if ( not isstring( weaponClass ) ) then 
            
            return 
        end 

        local foundWeapon = ply:GetWeapon( weaponClass ) 
        
        if ( not IsValid( foundWeapon ) ) then 
            
            return 
        end 

        setDrop( foundWeapon )
       
    end )    

end

do // Stop frozen handcuffing / arresting / tazing 

    local canDo = function( ply )

        if ( not IsValid( ply ) ) then 
        
            return 
        end

        local isFrozen = ply:IsFrozen()

        if ( isFrozen ) then 
    
            return false 
        end
        
    end

    do // Interface 

        hook.Add( "PlayerCanTaze", "MonkeyLib:MonkeyHacks:CanTazeFrozen", function( _, frozenTarget )
    
            return canDo( frozenTarget )
        end )        
    
        hook.Add( "CuffsCanHandcuff", "MonkeyLib:MonkeyHacks:CanHandcuffFrozen", function( _, frozenTarget )

            return canDo( frozenTarget )
        end ) 
    
        hook.Add( "CanPlayerSuicide", "MonkeyLib:MonkeyHacks:CanFrozenSuicide", function( frozenTarget )
        
            return canDo( frozenTarget )
        end ) 

        hook.Add( "MPickPocket:CanPickPocket", "MonkeyLib:MonkeyHacks:CanFrozenSuicide", function( _, _, frozenTarget )
               
            return canDo( frozenTarget )
        end )

        hook.Add( "canArrest", "MonkeyLib:MonkeyHacks:CanArrestFrozen", function( _, frozenTarget )	
            
            if ( not IsValid( frozenTarget ) ) then return end 
    
            if ( frozenTarget:IsFrozen() and not frozenTarget:GetNWBool( "tazefrozen" ) ) then 
                
                return false 
            end 
    
        end )
    
    end

end

do // Prop Motion Disabler ( I hate this )

    local modelWhitelist = {}

    local shouldDisableMotion = function( ent )

        local entClass = ent:GetClass()
        
        if ( entClass ~= "prop_physics" ) then
            
            return false  
        end

        local owner = gProtect.GetOwner( ent )

        if ( not IsValid( owner ) ) then 

            return false 
        end

        local model = ent:GetModel() 

        local modelIsWhitelisted = modelWhitelist[model] or false 

        if ( modelIsWhitelisted ) then 

            return false 
        end

        return true 
    end

    local disableMotion = function( ent )
    
        if ( not IsValid( ent ) ) then 

            return 
        end

        local shouldDisable = shouldDisableMotion( ent )

        if ( not shouldDisable ) then 

            return 
        end 

        local phys = ent:GetPhysicsObject()
        
        if ( not IsValid( phys ) ) then 

            return 
        end

        phys:EnableMotion( false )

    end

    hook.Protect( "OnEntityCreated", "MonkeyLib:MonkeyHacks:DisableEntMotion", function( ent )
    
        local entClass = ent:GetClass()

        if ( entClass ~= "prop_physics" ) then 

            return 
        end

        timer.Simple( 0, function()

            disableMotion( ent )
            
        end )
        
    end )

    hook.Add( "PhysgunDrop", "MonkeyLib:MonkeyHacks:StopTheReEnableMotion", function( ply, ent  )

        if ( not IsValid( ply ) or not IsValid( ent ) ) then 

            return 
        end

        disableMotion( ent )

    end )

end

do // Unbreakable perma props!

    local filterDamage 

    local MakeFilterDamage = function() // Stolen from the Unbreakable tool, no clue if there's a better method. 
   
        local FilterDamage = ents.Create( "filter_activator_name" )
       
        FilterDamage:SetKeyValue( "TargetName", "FilterDamage" )
        FilterDamage:SetKeyValue( "negated", "1" )
        FilterDamage:Spawn()
       
        return FilterDamage
    end

    hook.Protect( "PermaProps.OnEntityCreated", "MonkeyLib:MonkeyHacks:UnbreakableEnts", function(ent)
    
        if ( not IsValid( ent ) ) then 
            
            return 
        end 

        if ( not IsValid( filterDamage ) ) then 
            
            filterDamage = MakeFilterDamage() 
        
        end 

        ent:Fire( "SetDamageFilter", "FilterDamage", 0 )

    end )
    
end

do // Stop prop damage 

    hook.Add( "EntityTakeDamage", "MonkeyLib:MonkeyHacks:StopEntKilling", function(ply, dmgInfo )

        if ( not IsValid( ply ) or not ply:IsPlayer() ) then return end 

        local inflictor = dmgInfo:GetInflictor()

        if ( not IsValid( inflictor ) ) then return end 

        if ( inflictor:IsPlayer() ) then return end 

        local isType = dmgInfo:IsDamageType( DMG_CRUSH + DMG_PREVENT_PHYSICS_FORCE )

        if ( isType ) then  

            return true 
        end
        
    end )
    
end

do // Share health between jobs 

    local oldTeamFunc = function()
        
        error( "Old Team function hasn't been Initialize." )
            
    end 

    // I prefer function overloading to modifying DarkRP. Especially for simple systems like this here. 
    local changeTeam = function( ply, ... ) 

        if ( not ply:Alive() ) then 
            
            oldTeamFunc( ply, ... )

            return 
        end 

        // Store our current Health / Armor 
        local currentHealth, currentArmor = ply:Health(), ply:Armor()

        oldTeamFunc( ply, ... )

        do // Sort our health / armor, make sure jobs that had 100 + hp are correctly formatted to the new jobs max hp. 

            local maxHealth, maxArmor = ply:GetMaxHealth(), ply:GetMaxArmor()

            currentHealth = math.Clamp( currentHealth, 0, maxHealth )      
    
            currentArmor = math.Clamp( currentArmor, 0, maxArmor )

        end
 
        // Set our Health / Armor.

        ply:SetHealth( currentHealth )

        ply:SetArmor( currentArmor )

    end 

    hook.Add( "DarkRPFinishedLoading", "MonkeyLib:MonkeyHacks:TeamHealthShare", function()

        oldTeamFunc = PLAYER.changeTeam

        PLAYER.changeTeam = changeTeam

    end )

end

do 
    
    // Not keen on the entire idea of looping around all of these models. 
    // Possibly re-map the table, [Model] = true 

    local models = {"models/props_phx/construct/metal_angle180.mdl","models/props_phx/construct/metal_angle360.mdl","models/props_phx/construct/metal_angle90.mdl","models/props_phx/construct/metal_dome180.mdl","models/props_phx/construct/metal_dome360.mdl","models/props_phx/construct/metal_dome90.mdl","models/props_phx/construct/metal_plate_curve.mdl","models/props_phx/construct/metal_plate_curve180.mdl","models/props_phx/construct/metal_plate_curve180x2.mdl","models/props_phx/construct/metal_plate_curve2.mdl","models/props_phx/construct/metal_plate_curve2x2.mdl","models/props_phx/construct/metal_plate_curve360.mdl","models/props_phx/construct/metal_plate_curve360x2.mdl","models/props_phx/construct/metal_plate_pipe.mdl","models/props_phx/construct/metal_wire_angle180x1.mdl","models/props_phx/construct/metal_wire_angle180x2.mdl","models/props_phx/construct/metal_wire_angle360x1.mdl","models/props_phx/construct/metal_wire_angle360x2.mdl","models/props_phx/construct/metal_wire_angle90x1.mdl","models/props_phx/construct/metal_wire_angle90x2.mdl","models/props_phx/construct/glass/glass_angle180.mdl","models/props_phx/construct/glass/glass_angle360.mdl","models/props_phx/construct/glass/glass_angle90.mdl","models/props_phx/construct/glass/glass_curve180x1.mdl","models/props_phx/construct/glass/glass_curve180x2.mdl","models/props_phx/construct/glass/glass_curve360x1.mdl","models/props_phx/construct/glass/glass_curve360x2.mdl","models/props_phx/construct/glass/glass_curve90x1.mdl","models/props_phx/construct/glass/glass_curve90x2.mdl","models/props_phx/construct/glass/glass_dome180.mdl","models/props_phx/construct/glass/glass_dome360.mdl","models/props_phx/construct/glass/glass_dome90.mdl","models/props_phx/construct/windows/window_angle180.mdl","models/props_phx/construct/windows/window_angle360.mdl","models/props_phx/construct/windows/window_angle90.mdl","models/props_phx/construct/windows/window_curve180x1.mdl","models/props_phx/construct/windows/window_curve180x2.mdl","models/props_phx/construct/windows/window_curve360x1.mdl","models/props_phx/construct/windows/window_curve360x2.mdl","models/props_phx/construct/windows/window_curve90x1.mdl","models/props_phx/construct/windows/window_curve90x2.mdl","models/props_phx/construct/windows/window_dome180.mdl","models/props_phx/construct/windows/window_dome360.mdl","models/props_phx/construct/windows/window_dome90.mdl","models/props_phx/construct/wood/wood_angle180.mdl","models/props_phx/construct/wood/wood_angle360.mdl","models/props_phx/construct/wood/wood_angle90.mdl","models/props_phx/construct/wood/wood_curve180x1.mdl","models/props_phx/construct/wood/wood_curve180x2.mdl","models/props_phx/construct/wood/wood_curve360x1.mdl","models/props_phx/construct/wood/wood_curve360x2.mdl","models/props_phx/construct/wood/wood_curve90x1.mdl","models/props_phx/construct/wood/wood_curve90x2.mdl","models/props_phx/construct/wood/wood_dome180.mdl","models/props_phx/construct/wood/wood_dome360.mdl","models/props_phx/construct/wood/wood_dome90.mdl","models/props_phx/construct/wood/wood_wire_angle180x1.mdl","models/props_phx/construct/wood/wood_wire_angle180x2.mdl","models/props_phx/construct/wood/wood_wire_angle360x1.mdl","models/props_phx/construct/wood/wood_wire_angle360x2.mdl","models/props_phx/construct/wood/wood_wire_angle90x1.mdl","models/props_phx/construct/wood/wood_wire_angle90x2.mdl","models/hunter/misc/platehole1x1a.mdl","models/hunter/misc/platehole1x1b.mdl","models/hunter/misc/platehole1x1c.mdl","models/hunter/misc/platehole1x1d.mdl","models/hunter/tubes/tube1x1x1.mdl","models/hunter/tubes/tube1x1x1b.mdl","models/hunter/tubes/tube1x1x1c.mdl","models/hunter/tubes/tube1x1x1d.mdl","models/hunter/tubes/tube1x1x2.mdl","models/hunter/tubes/tube1x1x2b.mdl","models/hunter/tubes/tube1x1x2c.mdl","models/hunter/tubes/tube1x1x2d.mdl","models/hunter/tubes/tube1x1x3.mdl","models/hunter/tubes/tube1x1x3b.mdl","models/hunter/tubes/tube1x1x3c.mdl","models/hunter/tubes/tube1x1x3d.mdl","models/hunter/tubes/tube1x1x4.mdl","models/hunter/tubes/tube1x1x4b.mdl","models/hunter/tubes/tube1x1x4c.mdl","models/hunter/tubes/tube1x1x4d.mdl","models/hunter/tubes/tube1x1x5.mdl","models/hunter/tubes/tube1x1x5b.mdl","models/hunter/tubes/tube1x1x5c.mdl","models/hunter/tubes/tube1x1x5d.mdl","models/hunter/tubes/tube1x1x6.mdl","models/hunter/tubes/tube1x1x6b.mdl","models/hunter/tubes/tube1x1x6c.mdl","models/hunter/tubes/tube1x1x6d.mdl","models/hunter/tubes/tube1x1x8.mdl","models/hunter/tubes/tube1x1x8b.mdl","models/hunter/tubes/tube1x1x8c.mdl","models/hunter/tubes/tube1x1x8d.mdl","models/hunter/tubes/tubebend1x1x90.mdl","models/hunter/tubes/circle2x2.mdl","models/hunter/tubes/circle2x2b.mdl","models/hunter/tubes/circle2x2c.mdl","models/hunter/tubes/circle2x2d.mdl","models/hunter/plates/platehole1x1.mdl","models/hunter/plates/platehole1x2.mdl","models/hunter/plates/platehole2x2.mdl","models/hunter/plates/platehole3.mdl","models/hunter/misc/shell2x2a.mdl","models/hunter/misc/shell2x2b.mdl","models/hunter/misc/shell2x2c.mdl","models/hunter/misc/shell2x2d.mdl","models/hunter/misc/shell2x2e.mdl","models/hunter/misc/shell2x2x45.mdl","models/hunter/tubes/tube2x2x025.mdl","models/hunter/tubes/tube2x2x025b.mdl","models/hunter/tubes/tube2x2x025c.mdl","models/hunter/tubes/tube2x2x025d.mdl","models/hunter/tubes/tube2x2x05.mdl","models/hunter/tubes/tube2x2x05b.mdl","models/hunter/tubes/tube2x2x05c.mdl","models/hunter/tubes/tube2x2x05d.mdl","models/hunter/tubes/tube2x2x1.mdl","models/hunter/tubes/tube2x2x1b.mdl","models/hunter/tubes/tube2x2x1c.mdl","models/hunter/tubes/tube2x2x1d.mdl","models/hunter/tubes/tube2x2x2.mdl","models/hunter/tubes/tube2x2x2b.mdl","models/hunter/tubes/tube2x2x2c.mdl","models/hunter/tubes/tube2x2x2d.mdl","models/hunter/tubes/tube2x2x4.mdl","models/hunter/tubes/tube2x2x4b.mdl","models/hunter/tubes/tube2x2x4c.mdl","models/hunter/tubes/tube2x2x4d.mdl","models/hunter/tubes/tube2x2x8.mdl","models/hunter/tubes/tube2x2x8b.mdl","models/hunter/tubes/tube2x2x8c.mdl","models/hunter/tubes/tube2x2x8d.mdl","models/hunter/tubes/tube2x2x16d.mdl","models/hunter/tubes/tube2x2x+.mdl","models/hunter/tubes/tube2x2xt.mdl","models/hunter/tubes/tube2x2xta.mdl","models/hunter/tubes/tube2x2xtb.mdl","models/hunter/tubes/tubebend2x2x90.mdl","models/hunter/tubes/tubebend1x2x90.mdl","models/hunter/tubes/tubebend1x2x90b.mdl","models/hunter/tubes/tubebend1x2x90a.mdl","models/hunter/tubes/tubebend2x2x90outer.mdl","models/hunter/tubes/tubebend2x2x90square.mdl","models/hunter/tubes/tubebendinsidesquare.mdl","models/hunter/tubes/tubebendinsidesquare2.mdl","models/hunter/tubes/tubebendoutsidesquare.mdl","models/hunter/tubes/tubebendoutsidesquare2.mdl","models/hunter/tubes/circle4x4.mdl","models/hunter/tubes/circle4x4b.mdl","models/hunter/tubes/circle4x4c.mdl","models/hunter/tubes/circle4x4d.mdl","models/hunter/misc/platehole4x4.mdl","models/hunter/misc/platehole4x4b.mdl","models/hunter/misc/platehole4x4c.mdl","models/hunter/misc/platehole4x4d.mdl","models/hunter/tubes/tube4x4x1to2x2.mdl","models/hunter/tubes/tube4x4x025.mdl","models/hunter/tubes/tube4x4x025b.mdl","models/hunter/tubes/tube4x4x025c.mdl","models/hunter/tubes/tube4x4x025d.mdl","models/hunter/tubes/tube4x4x05.mdl","models/hunter/tubes/tube4x4x05b.mdl","models/hunter/tubes/tube4x4x05c.mdl","models/hunter/tubes/tube4x4x05d.mdl","models/hunter/tubes/tube4x4x1.mdl","models/hunter/tubes/tube4x4x1b.mdl","models/hunter/tubes/tube4x4x1c.mdl","models/hunter/tubes/tube4x4x1d.mdl","models/hunter/tubes/tube4x4x2.mdl","models/hunter/tubes/tube4x4x2b.mdl","models/hunter/tubes/tube4x4x2c.mdl","models/hunter/tubes/tube4x4x2d.mdl","models/hunter/tubes/tube4x4x3.mdl","models/hunter/tubes/tube4x4x3b.mdl","models/hunter/tubes/tube4x4x3c.mdl","models/hunter/tubes/tube4x4x3d.mdl","models/hunter/tubes/tube4x4x4.mdl","models/hunter/tubes/tube4x4x4b.mdl","models/hunter/tubes/tube4x4x4c.mdl","models/hunter/tubes/tube4x4x4d.mdl","models/hunter/tubes/tube4x4x5.mdl","models/hunter/tubes/tube4x4x5b.mdl","models/hunter/tubes/tube4x4x5c.mdl","models/hunter/tubes/tube4x4x5d.mdl","models/hunter/tubes/tube4x4x6.mdl","models/hunter/tubes/tube4x4x6b.mdl","models/hunter/tubes/tube4x4x6c.mdl","models/hunter/tubes/tube4x4x6d.mdl","models/hunter/tubes/tube4x4x8.mdl","models/hunter/tubes/tube4x4x8b.mdl","models/hunter/tubes/tube4x4x8c.mdl","models/hunter/tubes/tube4x4x8d.mdl","models/hunter/tubes/tube4x4x16.mdl","models/hunter/tubes/tube4x4x16b.mdl","models/hunter/tubes/tube4x4x16c.mdl","models/hunter/tubes/tube4x4x16d.mdl","models/hunter/tubes/tubebend4x4x90.mdl","models/hunter/triangles/025x025.mdl","models/hunter/triangles/05x05.mdl","models/hunter/triangles/075x075.mdl","models/hunter/triangles/1x1.mdl","models/hunter/triangles/2x2.mdl","models/hunter/triangles/3x3.mdl","models/hunter/triangles/4x4.mdl","models/hunter/triangles/5x5.mdl","models/hunter/triangles/6x6.mdl","models/hunter/triangles/7x7.mdl","models/hunter/triangles/8x8.mdl","models/hunter/plates/tri2x1.mdl","models/hunter/plates/tri3x1.mdl","models/hunter/triangles/025x025mirrored.mdl","models/hunter/triangles/05x05mirrored.mdl","models/hunter/triangles/075x075mirrored.mdl","models/hunter/triangles/1x1mirrored.mdl","models/hunter/triangles/2x2mirrored.mdl","models/hunter/triangles/3x3mirrored.mdl","models/hunter/triangles/4x4mirrored.mdl","models/hunter/triangles/05x05x05.mdl","models/hunter/triangles/1x05x05.mdl","models/hunter/triangles/1x05x1.mdl","models/hunter/triangles/1x1x1.mdl","models/hunter/triangles/1x1x2.mdl","models/hunter/triangles/1x1x3.mdl","models/hunter/triangles/1x1x4.mdl","models/hunter/triangles/1x1x5.mdl","models/hunter/triangles/2x1x1.mdl","models/hunter/triangles/2x2x1.mdl","models/hunter/triangles/2x2x2.mdl","models/hunter/triangles/3x2x2.mdl","models/hunter/triangles/3x3x2.mdl","models/hunter/triangles/1x1x1carved.mdl","models/hunter/triangles/2x1x1carved.mdl","models/hunter/triangles/2x2x1carved.mdl","models/hunter/triangles/1x1x2carved.mdl","models/hunter/triangles/2x1x2carved.mdl","models/hunter/triangles/2x2x2carved.mdl","models/hunter/triangles/1x1x4carved.mdl","models/hunter/triangles/2x2x4carved.mdl","models/hunter/triangles/1x1x1carved025.mdl","models/hunter/triangles/1x1x2carved025.mdl","models/hunter/triangles/1x1x4carved025.mdl","models/XQM/panel45.mdl","models/XQM/panel90.mdl","models/XQM/panel180.mdl","models/XQM/panel360.mdl","models/XQM/quad1.mdl","models/XQM/quad2.mdl","models/XQM/quad3.mdl","models/XQM/rhombus1.mdl","models/XQM/rhombus2.mdl","models/XQM/rhombus3.mdl","models/XQM/triangle1x1.mdl","models/XQM/triangle1x2.mdl","models/XQM/triangle2x2.mdl","models/XQM/triangle2x4.mdl","models/XQM/triangle4x4.mdl","models/XQM/triangle4x6.mdl","models/XQM/trianglelong1.mdl","models/XQM/trianglelong2.mdl","models/XQM/trianglelong3.mdl","models/XQM/trianglelong4.mdl","models/PHXtended/bar1x.mdl","models/PHXtended/bar1x45a.mdl","models/PHXtended/bar1x45b.mdl","models/PHXtended/bar2x.mdl","models/PHXtended/bar2x45a.mdl","models/PHXtended/bar2x45b.mdl","models/PHXtended/cab1x1x1.mdl","models/PHXtended/cab2x1x1.mdl","models/PHXtended/cab2x2x1.mdl","models/PHXtended/cab2x2x2.mdl","models/PHXtended/tri1x1.mdl","models/PHXtended/tri1x1solid.mdl","models/PHXtended/tri1x1x1.mdl","models/PHXtended/tri1x1x1solid.mdl","models/PHXtended/tri1x1x2.mdl","models/PHXtended/tri1x1x2solid.mdl","models/PHXtended/tri2x1.mdl","models/PHXtended/tri2x1solid.mdl","models/PHXtended/tri2x1x1.mdl","models/PHXtended/tri2x1x1solid.mdl","models/PHXtended/tri2x1x2.mdl","models/PHXtended/tri2x1x2solid.mdl","models/PHXtended/tri2x2.mdl","models/PHXtended/tri2x2solid.mdl","models/PHXtended/tri2x2x1.mdl","models/PHXtended/tri2x2x1solid.mdl","models/PHXtended/tri2x2x2.mdl","models/PHXtended/tri2x2x2solid.mdl","models/PHXtended/trieq1x1x1.mdl","models/PHXtended/trieq1x1x1solid.mdl","models/PHXtended/trieq1x1x2.mdl","models/PHXtended/trieq1x1x2solid.mdl","models/PHXtended/trieq2x2x1.mdl","models/PHXtended/trieq2x2x1solid.mdl","models/PHXtended/trieq2x2x2.mdl","models/PHXtended/trieq2x2x2solid.mdl","models/XQM/cylinderx1.mdl","models/XQM/cylinderx1big.mdl","models/XQM/cylinderx1huge.mdl","models/XQM/cylinderx1large.mdl","models/XQM/cylinderx1medium.mdl","models/XQM/cylinderx2.mdl","models/XQM/cylinderx2big.mdl","models/XQM/cylinderx2huge.mdl","models/XQM/cylinderx2large.mdl","models/XQM/cylinderx2medium.mdl","models/XQM/deg180.mdl","models/XQM/deg180single.mdl","models/XQM/deg360.mdl","models/XQM/deg360single.mdl","models/XQM/deg45.mdl","models/XQM/deg45single.mdl","models/XQM/deg90.mdl","models/XQM/deg90single.mdl","models/XQM/Rails/gumball_1.mdl","models/XQM/Rails/trackball_1.mdl","models/XQM/CoasterTrack/train_2.mdl","models/XQM/coastertrain1.mdl","models/XQM/coastertrain2seat.mdl","models/XQM/coastertrain1seat.mdl","models/XQM/CoasterTrack/train_1.mdl","models/XQM/CoasterTrack/train_car_1.mdl","models/XQM/Rails/funnel.mdl","models/XQM/Rails/straight_1.mdl","models/XQM/Rails/straight_2.mdl","models/XQM/Rails/straight_4.mdl","models/XQM/Rails/straight_8.mdl","models/XQM/Rails/straight_16.mdl","models/XQM/Rails/tunnel_1.mdl","models/XQM/Rails/tunnel_2.mdl","models/XQM/Rails/tunnel_4.mdl","models/XQM/Rails/tunnel_8.mdl","models/XQM/Rails/tunnel_16.mdl","models/XQM/Rails/slope_down_15.mdl","models/XQM/Rails/slope_down_30.mdl","models/XQM/Rails/slope_down_45.mdl","models/XQM/Rails/slope_down_90.mdl","models/XQM/Rails/slope_up_15.mdl","models/XQM/Rails/slope_up_30.mdl","models/XQM/Rails/slope_up_45.mdl","models/XQM/Rails/slope_up_90.mdl","models/XQM/Rails/turn_15.mdl","models/XQM/Rails/turn_30.mdl","models/XQM/Rails/turn_45.mdl","models/XQM/Rails/turn_90.mdl","models/XQM/Rails/turn_180.mdl","models/XQM/Rails/twist_45_left.mdl","models/XQM/Rails/twist_90_left.mdl","models/XQM/Rails/twist_45_right.mdl","models/XQM/Rails/twist_90_right.mdl","models/XQM/Rails/loop_left.mdl","models/XQM/Rails/loop_right.mdl","models/XQM/CoasterTrack/bank_start_left_1.mdl","models/XQM/CoasterTrack/bank_start_left_2.mdl","models/XQM/CoasterTrack/bank_start_left_3.mdl","models/XQM/CoasterTrack/bank_start_left_4.mdl","models/XQM/CoasterTrack/bank_start_right_1.mdl","models/XQM/CoasterTrack/bank_start_right_2.mdl","models/XQM/CoasterTrack/bank_start_right_3.mdl","models/XQM/CoasterTrack/bank_start_right_4.mdl","models/XQM/CoasterTrack/bank_turn_180_1.mdl","models/XQM/CoasterTrack/bank_turn_180_2.mdl","models/XQM/CoasterTrack/bank_turn_180_3.mdl","models/XQM/CoasterTrack/bank_turn_180_4.mdl","models/XQM/CoasterTrack/bank_turn_45_1.mdl","models/XQM/CoasterTrack/bank_turn_45_2.mdl","models/XQM/CoasterTrack/bank_turn_45_3.mdl","models/XQM/CoasterTrack/bank_turn_45_4.mdl","models/XQM/CoasterTrack/bank_turn_90_1.mdl","models/XQM/CoasterTrack/bank_turn_90_2.mdl","models/XQM/CoasterTrack/bank_turn_90_3.mdl","models/XQM/CoasterTrack/bank_turn_90_4.mdl","models/XQM/CoasterTrack/slope_225_1.mdl","models/XQM/CoasterTrack/slope_225_2.mdl","models/XQM/CoasterTrack/slope_225_3.mdl","models/XQM/CoasterTrack/slope_225_4.mdl","models/XQM/CoasterTrack/slope_225_down_1.mdl","models/XQM/CoasterTrack/slope_225_down_2.mdl","models/XQM/CoasterTrack/slope_225_down_3.mdl","models/XQM/CoasterTrack/slope_225_down_4.mdl","models/XQM/CoasterTrack/slope_45_1.mdl","models/XQM/CoasterTrack/slope_45_2.mdl","models/XQM/CoasterTrack/slope_45_3.mdl","models/XQM/CoasterTrack/slope_45_4.mdl","models/XQM/CoasterTrack/slope_45_down_1.mdl","models/XQM/CoasterTrack/slope_45_down_2.mdl","models/XQM/CoasterTrack/slope_45_down_3.mdl","models/XQM/CoasterTrack/slope_45_down_4.mdl","models/XQM/CoasterTrack/slope_90_1.mdl","models/XQM/CoasterTrack/slope_90_2.mdl","models/XQM/CoasterTrack/slope_90_3.mdl","models/XQM/CoasterTrack/slope_90_4.mdl","models/XQM/CoasterTrack/slope_90_down_1.mdl","models/XQM/CoasterTrack/slope_90_down_2.mdl","models/XQM/CoasterTrack/slope_90_down_3.mdl","models/XQM/CoasterTrack/slope_90_down_4.mdl","models/XQM/CoasterTrack/special_full_corkscrew_left_1.mdl","models/XQM/CoasterTrack/special_full_corkscrew_left_2.mdl","models/XQM/CoasterTrack/special_full_corkscrew_left_3.mdl","models/XQM/CoasterTrack/special_full_corkscrew_left_4.mdl","models/XQM/CoasterTrack/special_full_corkscrew_right_1.mdl","models/XQM/CoasterTrack/special_full_corkscrew_right_2.mdl","models/XQM/CoasterTrack/special_full_corkscrew_right_3.mdl","models/XQM/CoasterTrack/special_full_corkscrew_right_4.mdl","models/XQM/CoasterTrack/special_full_loop_3.mdl","models/XQM/CoasterTrack/special_full_loop_4.mdl","models/XQM/CoasterTrack/special_half_corkscrew_left_1.mdl","models/XQM/CoasterTrack/special_half_corkscrew_left_2.mdl","models/XQM/CoasterTrack/special_half_corkscrew_left_3.mdl","models/XQM/CoasterTrack/special_half_corkscrew_left_4.mdl","models/XQM/CoasterTrack/special_half_corkscrew_right_1.mdl","models/XQM/CoasterTrack/special_half_corkscrew_right_2.mdl","models/XQM/CoasterTrack/special_half_corkscrew_right_3.mdl","models/XQM/CoasterTrack/special_half_corkscrew_right_4.mdl","models/XQM/CoasterTrack/special_helix_middle_2.mdl","models/XQM/CoasterTrack/special_helix_middle_3.mdl","models/XQM/CoasterTrack/special_helix_middle_4.mdl","models/XQM/CoasterTrack/special_helix_middle_full_2.mdl","models/XQM/CoasterTrack/special_helix_middle_full_3.mdl","models/XQM/CoasterTrack/special_helix_middle_full_4.mdl","models/XQM/CoasterTrack/special_station.mdl","models/XQM/CoasterTrack/special_sturn_left_2.mdl","models/XQM/CoasterTrack/special_sturn_left_3.mdl","models/XQM/CoasterTrack/special_sturn_left_4.mdl","models/XQM/CoasterTrack/special_sturn_right_2.mdl","models/XQM/CoasterTrack/special_sturn_right_3.mdl","models/XQM/CoasterTrack/special_sturn_right_4.mdl","models/XQM/CoasterTrack/straight_1.mdl","models/XQM/CoasterTrack/straight_2.mdl","models/XQM/CoasterTrack/straight_3.mdl","models/XQM/CoasterTrack/straight_4.mdl","models/XQM/CoasterTrack/turn_180_1.mdl","models/XQM/CoasterTrack/turn_180_2.mdl","models/XQM/CoasterTrack/turn_180_3.mdl","models/XQM/CoasterTrack/turn_180_4.mdl","models/XQM/CoasterTrack/turn_180_tight_2.mdl","models/XQM/CoasterTrack/turn_180_tight_3.mdl","models/XQM/CoasterTrack/turn_180_tight_4.mdl","models/XQM/CoasterTrack/turn_45_1.mdl","models/XQM/CoasterTrack/turn_45_2.mdl","models/XQM/CoasterTrack/turn_45_3.mdl","models/XQM/CoasterTrack/turn_45_4.mdl","models/XQM/CoasterTrack/turn_90_1.mdl","models/XQM/CoasterTrack/turn_90_2.mdl","models/XQM/CoasterTrack/turn_90_3.mdl","models/XQM/CoasterTrack/turn_90_4.mdl","models/XQM/CoasterTrack/turn_90_tight_1.mdl","models/XQM/CoasterTrack/turn_90_tight_2.mdl","models/XQM/CoasterTrack/turn_90_tight_3.mdl","models/XQM/CoasterTrack/turn_90_tight_4.mdl","models/XQM/CoasterTrack/turn_slope_180_1.mdl","models/XQM/CoasterTrack/turn_slope_180_2.mdl","models/XQM/CoasterTrack/turn_slope_180_3.mdl","models/XQM/CoasterTrack/turn_slope_180_4.mdl","models/XQM/CoasterTrack/turn_slope_45_1.mdl","models/XQM/CoasterTrack/turn_slope_45_2.mdl","models/XQM/CoasterTrack/turn_slope_45_3.mdl","models/XQM/CoasterTrack/turn_slope_45_4.mdl","models/XQM/CoasterTrack/turn_slope_90_1.mdl","models/XQM/CoasterTrack/turn_slope_90_2.mdl","models/XQM/CoasterTrack/turn_slope_90_3.mdl","models/XQM/CoasterTrack/turn_slope_90_4.mdl","models/XQM/CoasterTrack/turn_slope_down_180_1.mdl","models/XQM/CoasterTrack/turn_slope_down_180_2.mdl","models/XQM/CoasterTrack/turn_slope_down_180_3.mdl","models/XQM/CoasterTrack/turn_slope_down_180_4.mdl","models/XQM/CoasterTrack/turn_slope_down_45_1.mdl","models/XQM/CoasterTrack/turn_slope_down_45_2.mdl","models/XQM/CoasterTrack/turn_slope_down_45_3.mdl","models/XQM/CoasterTrack/turn_slope_down_45_4.mdl","models/XQM/CoasterTrack/turn_slope_down_90_1.mdl","models/XQM/CoasterTrack/turn_slope_down_90_2.mdl","models/XQM/CoasterTrack/turn_slope_down_90_3.mdl","models/XQM/CoasterTrack/turn_slope_down_90_4.mdl","models/XQM/CoasterTrack/track_guide.mdl","models/props_phx/trains/tracks/track_1x.mdl","models/props_phx/trains/tracks/track_225_down.mdl","models/props_phx/trains/tracks/track_225_up.mdl","models/props_phx/trains/tracks/track_2x.mdl","models/props_phx/trains/tracks/track_45_down.mdl","models/props_phx/trains/tracks/track_45_up.mdl","models/props_phx/trains/tracks/track_4x.mdl","models/props_phx/trains/monorail4.mdl","models/props_phx/trains/tracks/track_8x.mdl","models/props_phx/trains/tracks/track_pass.mdl","models/props_phx/trains/tracks/track_16x.mdl","models/props_phx/trains/tracks/track_turn45.mdl","models/props_phx/trains/tracks/track_x.mdl","models/props_phx/trains/tracks/track_switcher.mdl","models/props_phx/trains/track_64.mdl","models/props_phx/trains/tracks/track_switcher2.mdl","models/props_phx/trains/trackslides_inner.mdl","models/props_phx/trains/trackslides_outer.mdl","models/props_phx/trains/track_32.mdl","models/props_phx/trains/track_128.mdl","models/props_phx/trains/track_512.mdl","models/props_phx/trains/tracks/track_crossing.mdl","models/props_phx/trains/tracks/track_switch2.mdl","models/props_phx/trains/tracks/track_turn90.mdl","models/props_phx/trains/trackslides_both.mdl","models/props_phx/trains/track_256.mdl","models/props_phx/trains/tracks/track_single.mdl","models/Mechanics/robotics/a1.mdl","models/Mechanics/robotics/a2.mdl","models/Mechanics/robotics/a3.mdl","models/Mechanics/robotics/a4.mdl","models/Mechanics/robotics/b1.mdl","models/Mechanics/robotics/b2.mdl","models/Mechanics/robotics/b3.mdl","models/Mechanics/robotics/b4.mdl","models/Mechanics/robotics/c1.mdl","models/Mechanics/robotics/c2.mdl","models/Mechanics/robotics/c3.mdl","models/Mechanics/robotics/c4.mdl","models/Mechanics/robotics/d1.mdl","models/Mechanics/robotics/d2.mdl","models/Mechanics/robotics/d3.mdl","models/Mechanics/robotics/d4.mdl","models/Mechanics/robotics/e1.mdl","models/Mechanics/robotics/e2.mdl","models/Mechanics/robotics/e3.mdl","models/Mechanics/robotics/e4.mdl","models/Mechanics/robotics/f1.mdl","models/Mechanics/robotics/f2.mdl","models/Mechanics/robotics/f3.mdl","models/Mechanics/robotics/foot.mdl","models/Mechanics/robotics/g1.mdl","models/Mechanics/robotics/g2.mdl","models/Mechanics/robotics/g3.mdl","models/Mechanics/robotics/g4.mdl","models/Mechanics/robotics/h1.mdl","models/Mechanics/robotics/h2.mdl","models/Mechanics/robotics/h3.mdl","models/Mechanics/robotics/h4.mdl","models/Mechanics/robotics/i1.mdl","models/Mechanics/robotics/i2.mdl","models/Mechanics/robotics/i3.mdl","models/Mechanics/robotics/i4.mdl","models/Mechanics/robotics/j1.mdl","models/Mechanics/robotics/j2.mdl","models/Mechanics/robotics/j3.mdl","models/Mechanics/robotics/j4.mdl","models/Mechanics/robotics/k1.mdl","models/Mechanics/robotics/k2.mdl","models/Mechanics/robotics/k3.mdl","models/Mechanics/robotics/k4.mdl","models/Mechanics/robotics/l1.mdl","models/Mechanics/robotics/l2.mdl","models/Mechanics/robotics/l3.mdl","models/Mechanics/robotics/l4.mdl","models/Mechanics/robotics/m3.mdl","models/Mechanics/robotics/m4.mdl","models/Mechanics/robotics/stand.mdl","models/Mechanics/robotics/xfoot.mdl","models/Mechanics/roboticslarge/a1.mdl","models/Mechanics/roboticslarge/a2.mdl","models/Mechanics/roboticslarge/a3.mdl","models/Mechanics/roboticslarge/a4.mdl","models/Mechanics/roboticslarge/b1.mdl","models/Mechanics/roboticslarge/b2.mdl","models/Mechanics/roboticslarge/b3.mdl","models/Mechanics/roboticslarge/b4.mdl","models/Mechanics/roboticslarge/c1.mdl","models/Mechanics/roboticslarge/c2.mdl","models/Mechanics/roboticslarge/c3.mdl","models/Mechanics/roboticslarge/c4.mdl","models/Mechanics/roboticslarge/d1.mdl","models/Mechanics/roboticslarge/d2.mdl","models/Mechanics/roboticslarge/d3.mdl","models/Mechanics/roboticslarge/d4.mdl","models/Mechanics/roboticslarge/e1.mdl","models/Mechanics/roboticslarge/e2.mdl","models/Mechanics/roboticslarge/e3.mdl","models/Mechanics/roboticslarge/e4.mdl","models/Mechanics/roboticslarge/f1.mdl","models/Mechanics/roboticslarge/f2.mdl","models/Mechanics/roboticslarge/f3.mdl","models/Mechanics/roboticslarge/g1.mdl","models/Mechanics/roboticslarge/g2.mdl","models/Mechanics/roboticslarge/g3.mdl","models/Mechanics/roboticslarge/g4.mdl","models/Mechanics/roboticslarge/h1.mdl","models/Mechanics/roboticslarge/h2.mdl","models/Mechanics/roboticslarge/h3.mdl","models/Mechanics/roboticslarge/h4.mdl","models/Mechanics/roboticslarge/i1.mdl","models/Mechanics/roboticslarge/i2.mdl","models/Mechanics/roboticslarge/i3.mdl","models/Mechanics/roboticslarge/i4.mdl","models/Mechanics/roboticslarge/j1.mdl","models/Mechanics/roboticslarge/j2.mdl","models/Mechanics/roboticslarge/j3.mdl","models/Mechanics/roboticslarge/j4.mdl","models/Mechanics/roboticslarge/k1.mdl","models/Mechanics/roboticslarge/k2.mdl","models/Mechanics/roboticslarge/k3.mdl","models/Mechanics/roboticslarge/k4.mdl","models/Mechanics/roboticslarge/l1.mdl","models/Mechanics/roboticslarge/l2.mdl","models/Mechanics/roboticslarge/l3.mdl","models/Mechanics/roboticslarge/l4.mdl","models/Mechanics/roboticslarge/m3.mdl","models/Mechanics/roboticslarge/m4.mdl","models/Mechanics/roboticslarge/xfoot.mdl","models/mechanics/roboticslarge/claw2l.mdl","models/mechanics/roboticslarge/clawl.mdl","models/mechanics/roboticslarge/claw_guide2l.mdl","models/mechanics/roboticslarge/claw_guide2la.mdl","models/mechanics/robotics/claw.mdl","models/mechanics/robotics/claw2.mdl","models/mechanics/robotics/claw_guide.mdl","models/mechanics/robotics/claw_guide2.mdl","models/mechanics/robotics/claw_guide2a.mdl","models/mechanics/roboticslarge/claw_hub_8.mdl","models/mechanics/roboticslarge/claw_hub_8l.mdl","models/Combine_Helicopter.mdl","models/Combine_dropship.mdl","models/combine_apc.mdl","models/buggy.mdl","models/airboat.mdl","models/props_canal/boat001a.mdl","models/props_canal/boat001b.mdl","models/props_canal/boat002b.mdl","models/props_combine/combine_train02a.mdl","models/props_combine/combine_train02b.mdl","models/props_combine/CombineTrain01a.mdl","models/props_trainstation/train005.mdl","models/props_trainstation/train003.mdl","models/props_trainstation/train002.mdl","models/props_trainstation/train001.mdl","models/props_vehicles/car002a_physics.mdl","models/props_vehicles/car001b_phy.mdl","models/props_vehicles/car001b_hatchback.mdl","models/props_vehicles/car001a_phy.mdl","models/props_vehicles/car001a_hatchback.mdl","models/props_vehicles/apc001.mdl","models/props_vehicles/car002b_physics.mdl","models/props_vehicles/car003a_physics.mdl","models/props_vehicles/car003b_physics.mdl","models/props_vehicles/car004a_physics.mdl","models/props_vehicles/car004b_physics.mdl","models/props_vehicles/car005a_physics.mdl","models/props_vehicles/car005b_physics.mdl","models/props_vehicles/tanker001a.mdl","models/props_vehicles/generatortrailer01.mdl","models/props_vehicles/trailer001a.mdl","models/props_vehicles/trailer002a.mdl","models/props_vehicles/truck001a.mdl","models/props_vehicles/truck002a_cab.mdl","models/props_vehicles/truck003a.mdl","models/props_vehicles/van001a_physics.mdl","models/props_vehicles/wagon001a_phy.mdl"}

    local function blockPropsEffects( ply, mdl )

        for k = 1, #models do 

            local row = models[k] or ""

            if string.find( mdl, row ) then return false end
        end
       
    end

    hook.Add( "PlayerSpawnProp", "Brendan:blockProps", blockPropsEffects )
    hook.Add( "PlayerSpawnEffect", "Brendan:blockEffects", blockPropsEffects )

    local SpawnedProp = function( ply, model, ent )

        if ( not IsValid( ply ) or not isstring( model ) or not IsValid( ent ) ) then return end 

        local physObj = ent:GetPhysicsObject() 

        if ( ( tostring( physObj ) or "" ) == "[NULL PhysObject]" ) then 
            
            ent:Remove() 
            
        end 

        local entMaterial = ent:GetMaterial()
        
        if ( string.lower( entMaterial ) == "pp/copy" ) then 
        
            ent:Remove()

        end
    end
    
    hook.Protect( "PlayerSpawnedProp", "Brendan:SpawnedProps:WeirdFixes", SpawnedProp )
    

end

do // God zone restrictions 
    
    local depotArea = function( ply )

        local foundArea = ply:GetArea() or "none"

        if ( foundArea == "none" ) then 

            return 
        end

        return AreaManager.areas[foundArea] or nil 
    end

    local zoneIsGod = function( zone )

        if ( not istable( zone ) ) then 

            return false 
        end 

        return zone.godmode or false 
    end 

    local isInSafeZone = function( ply )

        if ( not istable( AreaManager ) ) then 

            ErrorNoHaltWithStack( "Can't find area manager global table!" )

            return false 
        end

        local foundZone = depotArea( ply )

        return zoneIsGod( foundZone )
    end

    do // Interface 

        local canDo = function( ply, target )

            if ( ( not IsValid( ply ) or not IsValid( target ) ) or ( not ply:IsPlayer() or not target:IsPlayer() ) ) then 

                return 
            end
            
            local playersInZone = isInSafeZone( ply ) or isInSafeZone( target )

            if ( playersInZone ) then 

                return false
            end 

        end
 
        hook.Add( "canArrest", "MonkeyLib:SafeZone:CanArrest", canDo ) 

        hook.Add( "CuffsCanHandcuff", "MonkeyLib:SafeZone:CanCuff", canDo ) 

        hook.Add( "PlayerCanTaze", "MonkeyLib:SafeZone:CanTaze", canDo )

        hook.Add( "CanPlayerSuicide", "MonkeyLib:SafeZone:CanSuicide", function(ply )
        
            local safeZone = isInSafeZone( ply )

            if ( safeZone ) then 
                
                return false 
            end

        end )

        hook.Add( "ABT:CanShootBullet", "MonkeyLib:SafeZone:CanUseAdvancedBullets", function( ply, tr )
        
            if ( not IsValid( ply ) or not tr ) then 

                return 
            end

            local target = tr.Entity 

            if ( not IsValid( target ) or not target:IsPlayer() ) then 

                return 
            end 

            local applyBullet = canDo( ply, target )
            
            if ( applyBullet == false ) then 

                return false 
            end
            
        end )

    end
    
    do // MonkeyLib Wrapper 

        MonkeyLib.IsGodZone = zoneIsGod

        MonkeyLib.GetZone = depotArea 
    
        MonkeyLib.IsInSafeZone = isInSafeZone

    end
    
    do 

        local restrictedRankBypass = {

            ["Senior-Admin"] = true, 

            ["superadmin"] = true, 
            
            ["Head-Admin"] = true, 
            
        } 

        local restrictedZoneTag = "leaveusalonenoobs"

        local isRestrictedZone = function( zone )

            if ( not istable( zone ) ) then 

                return 
            end 

            local zoneTag = ( zone.uniquename or "" )

            return ( zoneTag:match( restrictedZoneTag ) == restrictedZoneTag )
        end

        hook.Protect( "PlayerChangedArea", "MonkeyLib:MonkeyHacks:LeaveUsAlone", function( ply, zone )
        
            if ( not IsValid( ply ) or not istable( zone ) ) then 

                return 
            end

            local isRestricted = isRestrictedZone( zone )
            
            if ( not isRestricted ) then 

                return 
            end

            local canEnter = restrictedRankBypass[ ply:GetUserGroup() ] or false
        
            if ( canEnter ) then 
               
                return 
            end

            ply:Spawn()

        end )

    end

end

