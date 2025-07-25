local primaryFont = "MonkeyLib_Inter_15"
local primaryFontHeight = draw.GetFontHeight( primaryFont )

local headerFont = "MonkeyLib_Inter_20"

local GUITheme = MonkeyLib:GetTheme()

local bodyColor, headerColor, greenColor, redColor = GUITheme.bodyColor, GUITheme.headerColor, GUITheme.greenColor, GUITheme.redColor
local primaryTextColor, secondaryTextColor = GUITheme.primaryTextColor, GUITheme.secondaryTextColor 

local simplifiedBackgroundColor = Color(26, 26, 26, 250)

local itemPanelWidth = 180
local panelNameHeight = 30

local gapSize = 8

local roundedAmount = 8 
local searchBarRoundedAmount = roundedAmount - 2

local rarityOutlineSize = 4

local searchBarLineWidth = 1 
local searchIconOffset = 10

local lineHeight = 2
local lineWidthOffset = 16

local weaponPanelFOV = 30
local iconSizeOffset = 32 

local drawIcon = function( parent, iconID )

    if ( not IsValid( parent ) or not isstring( iconID ) ) then return end 

    local iconMaterial = MonkeyLib:GetIcon( iconID )
    if ( not iconMaterial ) then return end 

    local iconPanel = parent:Add( "DPanel" )
    iconPanel:Dock( FILL )
    iconPanel:SetMouseInputEnabled( false )

    iconPanel.Paint = function( s, w, h ) 

        surface.SetDrawColor( primaryTextColor )

            surface.SetMaterial( iconMaterial )
       
        surface.DrawTexturedRect(iconSizeOffset / 2, iconSizeOffset / 2, w - iconSizeOffset, h - iconSizeOffset)
        
    end 

    return iconPanel 
end

local drawModel = function( parent, model, skinIndex )

    if ( not IsValid( parent ) or not isstring( model ) or not skinIndex ) then return end 

    local modelPanel = parent:Add( "MonkeyLib:WeaponBox" )
    modelPanel:Dock( FILL )

    modelPanel:WeaponModel( model )
    modelPanel:SetFOV( weaponPanelFOV )   

    modelPanel:SetMouseInputEnabled( false )

    local ent = modelPanel.ModelPanel.Entity

    if ( IsValid( ent ) ) then ent:SetSkin( skinIndex ) end 

    return modelPanel 
end

MUnbox.RescaleItemPanel = function( panel )

    if ( not IsValid( panel ) ) then return end 

    panel:InvalidateLayout( true )
    panel:SizeToChildren( false, true )

end

MUnbox.AddItemPanelInfo = function( parent, infoText, lineColor )

    if ( not IsValid( parent ) or not isstring( infoText ) ) then return end

    local itemRow = parent:Add( "DPanel" )
    itemRow:Dock( TOP )
    itemRow:SetTall( panelNameHeight )
    itemRow:SetMouseInputEnabled( false )

    local textLabel = itemRow:Add("DLabel")
    textLabel:Dock( FILL )
    textLabel:DockMargin( 0, lineHeight , 0, 0 )

    textLabel:SetText( infoText )
    textLabel:SetFont( primaryFont )
    textLabel:SetTextColor( primaryTextColor )

    textLabel:SetContentAlignment( 5 )

    itemRow.textLabel = textLabel

    itemRow.Paint = function( s, w, h )
        
        draw.RoundedBox( 0, ( lineWidthOffset / 2 ), 0, ( w - lineWidthOffset ), lineHeight, s.bodyColor or bodyColor )

    end

    MUnbox.RescaleItemPanel( parent )

    return itemRow 
end

MUnbox.GetItemInfo = function( itemID, isCrate )

    if ( isCrate ) then 
        
        local itemInformation = MUnbox.GetCrate( itemID )
        if ( not istable( itemInformation ) ) then return end 

        local itemName, itemModel = itemInformation["Name"], itemInformation["Icon"]
        
        return itemName, itemModel
    end

    local itemInformation = MUnbox.GetWeapon( itemID )
    if ( not istable( itemInformation ) ) then return end 
    
    local itemName, itemModel, itemSkin = itemInformation["Name"], itemInformation["Model"], itemInformation["SkinIndex"]

    return itemName, itemModel, itemSkin 
end

MUnbox.CreateSimplifiedFrame = function( w, h )

    local scrw, scrh = ScrW(), ScrH()
    
    local frame = MonkeyLib:CreateDefaultFrame( w, h ) 
    if ( not IsValid( frame ) ) then return false end 

    frame.roundedAmount = roundedAmount

    local oldFramePaint = frame.Paint 

    frame.Paint = function( s, w, h )

        local x, y = s:LocalToScreen( 0, 0 )

		DisableClipping( true )
		
		    surface.SetDrawColor( simplifiedBackgroundColor )
			surface.DrawRect( x * -1, y * -1, scrw, scrh )

		DisableClipping( false )

        if ( isfunction( oldFramePaint ) ) then oldFramePaint( s, w, h ) end 
    end

    local header = frame.header 
    if ( not IsValid( header ) ) then return end 

    local headerTitleFunc = frame.GetHeaderTitle 

    header.Paint = function(s, w, h)

        draw.SimpleText( headerTitleFunc( frame ), headerFont, gapSize, h / 2, primaryTextColor, TEXT_ALIGN_LEFT, 1 )

    end 

    return frame 
end

MUnbox.CreateItemPanel = function( parent, itemID, itemRarity, isCrate, sizeOverride )

    if ( not IsValid( parent ) or not itemID or not isstring( itemRarity ) ) then return end 

    local foundRarity = MUnbox.GetRarity( itemRarity )
    if ( not istable( foundRarity ) ) then return end 

    local rarityColor = foundRarity.Color 
    if ( not IsColor( rarityColor ) ) then return end 

    local itemName, itemModel, itemSkin = MUnbox.GetItemInfo( itemID, isCrate )
    if ( not isstring( itemName ) or not isstring( itemModel ) ) then return end 

    local itemPanel = parent:Add( "DButton" )
    itemPanel:SetWide( sizeOverride or itemPanelWidth ) 
    itemPanel:SetText( " " )
    itemPanel:DockPadding( rarityOutlineSize, rarityOutlineSize, rarityOutlineSize, rarityOutlineSize ) // No clue why I need to do +1 for the top panel, Gmod is WEIRD, or I'm dumb.
    
    itemPanel.Paint = function( s, w, h )

        draw.RoundedBox( s.roundedAmount or roundedAmount, 0, 0, w, h, rarityColor )

        draw.RoundedBox( s.roundedAmount or roundedAmount, rarityOutlineSize / 2, rarityOutlineSize / 2, w - rarityOutlineSize, h - rarityOutlineSize, headerColor )

    end

    local iconPanel = itemPanel:Add( "DPanel" )
    iconPanel:Dock( TOP )
    iconPanel:SetTall( itemPanel:GetWide() - panelNameHeight - ( rarityOutlineSize * 2 ) )
    iconPanel:SetMouseInputEnabled(false)

    itemPanel.iconPanel = iconPanel 

    iconPanel.Paint = function( s, w, h ) end 

    do  
     
        if ( isCrate ) then

            drawIcon( iconPanel, itemModel )

        else

            drawModel( iconPanel, itemModel, itemSkin )

        end

    end 

    local namePanel = MUnbox.AddItemPanelInfo( itemPanel, itemName )

    itemPanel.namePanel = namePanel 

    return itemPanel 
end

MUnbox.CreateSearchBar = function( parent, width, callback ) // Very simple search bar wrapper, same searchbar needs to be re-used like 5 - ish times. 
       
    if ( not IsValid( parent ) or not isnumber( width ) ) then return end 

    local searchIcon = MonkeyLib:GetIcon( "m_unbox_search" ) 

    local searchBarHolder = parent:Add( "DPanel" )
    searchBarHolder:Dock( LEFT )
    searchBarHolder:SetWide( width )

    searchBarHolder:InvalidateParent( true )
    
    searchBarHolder.Paint = function( s, w, h )
        draw.RoundedBox( searchBarRoundedAmount, 0, 0, w, h, bodyColor)
    end

    local searchBarIcon = searchBarHolder:Add( "DPanel")
    searchBarIcon:Dock( LEFT )
    searchBarIcon:SetWide( searchBarHolder:GetTall() + ( searchBarLineWidth * 2 ) )
    
    searchBarIcon.Paint = function( s, w, h )

        draw.RoundedBox( 0, w - searchBarLineWidth, gapSize / 2, searchBarLineWidth, h - gapSize, headerColor )

        surface.SetDrawColor( primaryTextColor )

            surface.SetMaterial( searchIcon )

        surface.DrawTexturedRect( searchIconOffset / 2, searchIconOffset / 2, h - searchIconOffset, h - searchIconOffset )

    end

    local searchBar = searchBarHolder:Add( "DTextEntry" )
    searchBar:Dock( FILL )
    searchBar:DockMargin( 0, 0, 0, 0 )

    searchBar:SetTextColor( primaryTextColor )
    searchBar:SetFont( primaryFont )

    searchBar.Paint = function( s, w, h )

        s:DrawTextEntryText( primaryTextColor, primaryTextColor, primaryTextColor )
    
        draw.SimpleText( s:GetValue() == "" and "Search" or "", primaryFont, 2, h / 2, primaryTextColor, TEXT_ALIGN_LEFT, 1 )

    end

    if ( isfunction( callback ) ) then 
        
        searchBar.OnEnter = function( s )

            local value = s:GetValue()
    
            if ( s:GetNumeric() ) then value = tonumber( value ) end 
    
            callback( s, value )
        end
    
    end
   
    searchBarHolder.searchBar = searchBar 

    return searchBarHolder, searchBar
end

hook.Add( "MonkeyLib:ThemeReload", "MonkeyUnbox:VGUI:ReloadTheme", function( )
    
    GUITheme = MonkeyLib:GetTheme()

    bodyColor, headerColor, primaryTextColor, secondaryTextColor, greenColor = GUITheme.bodyColor, GUITheme.headerColor, GUITheme.primaryTextColor, GUITheme.secondaryTextColor,  GUITheme.greenColor

end )

