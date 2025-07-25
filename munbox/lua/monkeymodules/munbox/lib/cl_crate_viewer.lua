local L = function( message )

    return MUnbox.Config.Messages[message] or message
end

local GUITheme = MonkeyLib:GetTheme()

local bodyColor, headerColor, greenColor = GUITheme.bodyColor, GUITheme.headerColor, GUITheme.greenColor
local primaryTextColor, secondaryTextColor = GUITheme.primaryTextColor, GUITheme.secondaryTextColor 

local panelHeight = 40 

local gapSize = 8
local topBarGapSize = gapSize - 2 

local roundedAmount = 8
local searchBarRoundedAmount = roundedAmount - 2

local itemPanelHeight = 180

local unboxButtonSize = 24
local scrollBarWidth = 150 

local unboxButtonText = "Unbox me!"
local unboxButtonFont = "MonkeyLib_Inter_14"

local tapeWheelDelay = 2
local crateViewer = false 

local tickSound, stopSound = "munbox/click.wav", "buttons/lever6.wav"  

util.PrecacheSound( "sound/" .. tickSound )

local createTapeWheel = function( spinner, crateItems ) 
    if ( not IsValid( spinner ) or not istable( crateItems ) ) then return end 

    local items = {}

    local j = 1
    local speed = 20
    local stopAt = nil
    local stopAtPos = nil
    local completeStopPos

    local spaceOffset = 4

    spinner:Clear()
    -- Start up the spinner
    local itemSpinner = spinner:Add("Panel")
    itemSpinner:Dock( FILL )
    itemSpinner:InvalidateParent( true )

    local spinnerOverlay = itemSpinner:Add( "DPanel" )
    spinnerOverlay:SetPos( ( itemSpinner:GetWide() - 2 ) / 2, 0)
    spinnerOverlay:SetSize( 2, itemSpinner:GetTall() )
    spinnerOverlay:SetZPos( 1 )

    local function addItem( item )
        if ( not istable( item ) ) then return end 

        local nextItemIndex = #items + 1 

        local itemID, itemRarity = item.ID, item.Rarity
        if ( not itemID or not itemRarity ) then return end 

        local itemPnl = MUnbox.CreateItemPanel( itemSpinner, item.ID, item.Rarity )
        if ( not IsValid( itemPnl ) ) then return end 

        itemPnl:Dock( LEFT )
        itemPnl:SetWide( itemSpinner:GetTall() )

        itemPnl.roundedAmount = 0 

        items[ nextItemIndex ] = itemPnl

        return itemPnl, nextItemIndex 
    end

    local space = math.ceil( itemSpinner:GetWide() / itemSpinner:GetTall() ) + 1

    for i = 1, ( space + spaceOffset ) do

        local weaponRow = crateItems[math.random(1, #crateItems)]
        addItem( weaponRow )

    end

    local targetItem = items[j]
    if ( not IsValid( targetItem ) ) then return end 

    local pad = math.floor( space / 2 )
    local posPad = ( spinnerOverlay:GetPos() + spinnerOverlay:GetWide() / 2 ) % targetItem:GetWide()

    local m = targetItem:GetWide() - posPad
    targetItem:DockMargin( -m, 0, 0, 0 )

    local soundPlayed = false

    function itemSpinner:Think()
        
        if ( not IsValid( targetItem ) ) then return end 
        
        if stopAt then

            local distance = ( stopAt - ( j + pad ) ) * targetItem:GetWide() + stopAtPos + targetItem:GetWide() - posPad - m

            if distance < 5 and not soundPlayed then
                
                soundPlayed = true

                surface.PlaySound( stopSound )

            end

            if distance <= 0 then

                self.Think = function() end -- Think will no longer be called

                return
            end

            speed = 1 + 19 * distance / ( self:GetWide() * 2 )
            speed = math.min( 20, speed )
            speed = math.max( 1, speed )

        end

        if targetItem:GetWide() * 2 - posPad <= m then

            m = m - targetItem:GetWide()

            targetItem:Remove()

            surface.PlaySound( tickSound )

            j = j + 1

            targetItem = items[j]
            if ( not IsValid( targetItem ) ) then return end 

            targetItem:DockMargin( -m, 0, 0, 0 )

            local weaponRow = crateItems[math.random(1, #crateItems)]
            addItem( weaponRow )

        end

        m = m + speed * RealFrameTime() / ( 1 / 60 )

        targetItem:DockMargin( -m, 0, 0, 0 )

        self:InvalidateChildren( false )
        
    end

    local startCurTime = CurTime() + tapeWheelDelay
    
    hook.Add( "MUnbox:Unbox:Crate", "MUnbox:TapeWheel:DisplayWinningItem", function( wonItem )

        if ( not IsValid( spinner ) ) then return end 

        wonItem = crateItems[wonItem] 
        if ( not istable( wonItem ) ) then return end 

        timer.Simple( startCurTime - CurTime(), function() 

            if ( not IsValid( spinner ) ) then return end 
            
            local newItem = crateItems[ math.random( 1, #crateItems ) ]
    
            for i = 1, space * 2 do
                
                addItem( crateItems[ math.random( 1, #crateItems ) ] )
        
            end
        
            local pnl, id = addItem( wonItem )
        
            stopAt = id

            stopAtPos = math.random( pnl:GetWide() * 0.9 ) + pnl:GetWide() * 0.05

        end )
    end )
end

local loadCrateItems = function( parent, crateItems, searchFilter )

    if ( not IsValid( parent ) or not istable( crateItems ) ) then return end 

    parent:Clear()

    for k = 1, #crateItems do 

        local itemRow = crateItems[k]
        if ( not istable( itemRow ) ) then continue end 

        local itemID, itemRarity = itemRow.ID, itemRow.Rarity 
        if ( not itemID or not itemRarity ) then continue end 

        local itemInfo = MUnbox.GetWeapon( itemID )
        if ( not istable(itemInfo)) then continue end 

        local itemName = itemInfo.Name 
        if ( not itemName ) then continue end 
 
        itemName = string.lower( itemName )

        if ( isstring( searchFilter ) and not string.match( itemName, searchFilter ) ) then 
                
            continue 
        end 
    
        MUnbox.CreateItemPanel( parent, itemID, itemRarity )
    end
end

MUnbox.CreateCrateViewer = function( crateID, inventoryID, drawTapeWheel ) // Need the inventory ID for the unboxing from inventory. It can be ignored for other systems. 

    if ( not crateID or IsValid( crateViewer ) ) then return end 

    local crateTable = MUnbox.GetCrate( crateID )

    assert( istable( crateTable ), "Crate is malformed.")

    local crateItems = crateTable.Items 

    assert( istable( crateItems ), "Crate items are malformed.")

    local scaleW, scaleH = MUnbox.ScaleFrame()

    local frame = MUnbox.CreateSimplifiedFrame( scaleW, scaleH )
    frame:DoModal()

    frame.roundedAmount = 16 

    crateViewer = frame 

    if ( drawTapeWheel ) then 

        local tapePanel = frame:Add( "DPanel" )
        tapePanel:Dock( TOP )
        tapePanel:InvalidateParent( true )
        tapePanel:DockPadding( gapSize, 0, gapSize, 0)

        tapePanel:SetTall( itemPanelHeight )

        tapePanel.Paint = function( ) end 

        local cratePanelSize = tapePanel:GetTall() - unboxButtonSize - gapSize

        local crateHolder = tapePanel:Add( "DPanel" )
        crateHolder:SetSize( cratePanelSize, tapePanel:GetTall() )
        crateHolder:Center()

        crateHolder.Paint = function() end 

        local cratePanel = MUnbox.CreateItemPanel( crateHolder, crateID, crateTable.Rarity, true, cratePanelSize )

        local unboxButton = crateHolder:Add( "DButton" )
        unboxButton:Dock( BOTTOM )
        unboxButton:SetTall( unboxButtonSize )

        unboxButton:SetTextColor( primaryTextColor )
        unboxButton:SetFont( unboxButtonFont )

        unboxButton:SetText( unboxButtonText )

        unboxButton.Paint = function( s, w, h )

            draw.RoundedBox( roundedAmount, 0, 0, w, h, headerColor )
            
        end
        
        unboxButton.DoClick = function()

            local crateExists = MUnbox.GetItem( inventoryID )

            if ( not istable( crateExists ) ) then 

                MonkeyLib.FancyChatMessage( L"crate_unbox_fail", true )

                return 
            end
                                    
            MonkeyNet.WriteStructure( "MUnbox:Inventory:Unbox", MUnbox.NetStructures.UnboxCrate, { inventoryID }  )
      
            createTapeWheel( tapePanel, crateItems )

        end
    end

    local itemLayout 

    local itemViewer = frame:Add( "DPanel" )
    itemViewer:Dock( FILL )
    itemViewer:DockPadding( gapSize, drawTapeWheel and gapSize or 0, gapSize, gapSize )

    itemViewer.Paint = function( s, w, h ) end 

    do // Search - Filter 

        local topBar = itemViewer:Add( "DPanel" )
        topBar:Dock( TOP )
        topBar:DockPadding( topBarGapSize, topBarGapSize, topBarGapSize, topBarGapSize )

        topBar:SetTall( panelHeight )

        topBar.Paint = function( s, w, h )

            draw.RoundedBox( roundedAmount, 0, 0, w, h, headerColor )
            
        end

        local _, searchBar = MUnbox.CreateSearchBar( topBar, scrollBarWidth, function( s, value )

            if ( not IsValid( itemLayout ) ) then return end 

            value = string.lower( value )

            loadCrateItems( itemLayout, crateItems, value)

        end )
    end

    do 

        local scrollPanel = itemViewer:Add( "MonkeyLib:ScrollPanel" )
        scrollPanel:Dock( FILL )
        scrollPanel:DockMargin( 0, gapSize, 0, 0 )
    
        scrollPanel:InvalidateParent( true )
    
        local oldLayout = scrollPanel.PerformLayout
    
        scrollPanel.PerformLayout = function( s, w, h ) // This is a complete hack, I have no clue on a fix for the DIconLayout issues I was having with docking. 
    
            oldLayout( s, w, h )
    
            local layout = itemLayout
            if ( not IsValid( layout ) ) then return end 
    
            layout:SetWide( w ) // Fixes some bugs I was having. 
            layout:Layout()
    
        end
        
        scrollPanel.Paint = function(s, w, h) end 

        itemLayout = scrollPanel:Add( "DIconLayout" )
        itemLayout:InvalidateParent( true )

        itemLayout:SetWide( scrollPanel:GetWide() ) // Fixes a fuck tonne of bugs I was having. 
    
        itemLayout:SetSpaceX( gapSize )
        itemLayout:SetSpaceY( gapSize )
            
        itemLayout.Paint = function( s, w, h ) end 

        frame.itemLayout = itemLayout

        loadCrateItems( itemLayout, crateItems )
    end
end

hook.Add( "MonkeyLib:ThemeReload", "MonkeyUnbox:CrateViewer:ReloadTheme", function( themeIndex )
    
    GUITheme = MonkeyLib:GetTheme()

    bodyColor, headerColor, primaryTextColor, secondaryTextColor, greenColor = GUITheme.bodyColor, GUITheme.headerColor, GUITheme.primaryTextColor, GUITheme.secondaryTextColor,  GUITheme.greenColor

end )
