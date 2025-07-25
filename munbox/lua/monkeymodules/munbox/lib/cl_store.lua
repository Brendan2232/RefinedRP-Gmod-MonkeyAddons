local L = function( message )

    return MUnbox.Config.Messages[message] or message
end

local GUITheme = MonkeyLib:GetTheme()

local bodyColor, headerColor, greenColor = GUITheme.bodyColor, GUITheme.headerColor, GUITheme.greenColor
local primaryTextColor, secondaryTextColor = GUITheme.primaryTextColor, GUITheme.secondaryTextColor 

local primaryFont = "MonkeyLib_Inter_15"

local gapSize = 8
local topBarGapSize = gapSize - 2 

local roundedAmount = 8
local searchBarRoundedAmount = roundedAmount - 2

local panelHeight = 40 
local storeCategoryHeight = 30 

local searchBarLineWidth = 1 
local searchIconOffset = 10

local searchBarWidth = 150 

local DMenuOptions = {
    {
        ["Name"] = "Purchase Crate", 

        ["Callback"] = function( item )

            if ( not isnumber( item ) ) then return end 

            local ply = LocalPlayer()

            local foundCrate = MUnbox.GetCrate( item )

            if ( not istable( foundCrate ) ) then

                MonkeyLib.FancyChatMessage( L"crate_purchase_fail", true )
                
                return 
            end 

            local cratePrice = foundCrate.Price

            if ( not isnumber( cratePrice ) ) then 
    
                MonkeyLib.FancyChatMessage( L"crate_purchase_fail", true )

                return 
            end

            if ( not MonkeyLib.CanAfford( ply, cratePrice ) ) then

                MonkeyLib.FancyChatMessage( L"cant_afford", true )

                return 
            end

            MonkeyNet.WriteStructure( "MUnbox:Crates:Purchase", MUnbox.NetStructures.PurchaseCrate, { item } )

        end
    }, 
    {
        ["Name"] = "View Contents", 

        ["Callback"] = function( item )

            if ( not isnumber( item ) ) then return end 

            MUnbox.CreateCrateViewer( item )

        end
    }, 
}

local PANEL = {}

function PANEL:LoadStoreItems( searchFilter )

    local itemLayout = self.itemLayout 
    if ( not IsValid( itemLayout ) ) then return end 

    itemLayout:Clear()

    local vbarOffset = ( gapSize / 2 ) 

    local categories = MUnbox.Categories

    for k = 1, #categories do 

        local categoryRow = categories[k]

        if ( not istable( categoryRow ) ) then 

            continue 
        end

        local categoryName = categoryRow.Name or ""

        local storeItems = MUnbox.GetCategoryCrates( k ) or {}

        if ( #storeItems <= 0 ) then 

            continue 
        end

        do 

            local scrollBar, canvas

            do 

                scrollBar = self.scrollPanel 

                assert( IsValid( scrollBar ), "Scroll bar isn't valid!" )

            end

            do 

                canvas = scrollBar:GetCanvas()

                assert( IsValid( canvas ), "Canvas isn't valid!" )

            end

            local categoryRow = itemLayout:Add( "DPanel" )
            categoryRow:SetSize( ( scrollBar.VBar.Enabled and ( canvas:GetWide() - vbarOffset ) ) or canvas:GetWide(), storeCategoryHeight )

            categoryRow.Think = function( s ) // Haven't done GUI in a while, forgot how to do everything :( 

                if ( not IsValid( s ) ) then 
                
                    return 
                end 

                local curSize = s:GetWide()

                local canvasSize = ( scrollBar.VBar.Enabled and ( canvas:GetWide() - vbarOffset ) ) or canvas:GetWide()
            
                if ( curSize ~= canvasSize ) then 

                    s:SetWide( canvasSize )
                    
                end

            end

            categoryRow.Paint = function( s, w, h )

                draw.RoundedBox( roundedAmount, 0, 0, w, h, headerColor )

                draw.SimpleText( categoryName, primaryFont, gapSize, h / 2, primaryTextColor, TEXT_ALIGN_LEFT, 1 )

            end

            categoryRow.OwnLine = true 
            
        end 

        for i = 1, #storeItems do 
            
            local itemRow = storeItems[i]
            if ( not istable( itemRow ) ) then continue end 

            local itemName, itemPrice, itemRarity = itemRow["Name"], itemRow["Price"], itemRow["Rarity"] 
            if ( not isstring( itemName ) or not isnumber( itemPrice ) or not isstring( itemRarity ) ) then continue end 

            local lowerName = string.lower( itemName )

            if ( isstring( searchFilter ) and ( not string.match( lowerName, searchFilter ) ) ) then 
                
                continue 
            end 

            local originalIndex = itemRow["originalIndex"] or i
        
            local formattedPrice = MonkeyLib.FormatMoney( itemPrice ) 

            local itemPanel = MUnbox.CreateItemPanel( itemLayout, originalIndex, itemRarity, true )
            if ( not IsValid( itemPanel ) ) then return end 

            itemPanel.DoClick = function()

                local options = MonkeyLib.DermaMenu( DMenuOptions, originalIndex )

                options:Open()

            end
            
            local pricePanel = MUnbox.AddItemPanelInfo( itemPanel, formattedPrice )

            local priceLabel = pricePanel.textLabel

            if ( IsValid( priceLabel ) ) then 

                priceLabel:SetTextColor( greenColor )

            end 
        end
    end 
end 

function PANEL:Init()
    
    local searchIcon = MonkeyLib:GetIcon( "m_unbox_search" )

    self:Dock( FILL )
    self:DockPadding( gapSize, gapSize, gapSize, gapSize )

    self:InvalidateParent( true )
    
    local topBar = self:Add( "DPanel" )
    topBar:Dock( TOP )
    topBar:DockPadding( topBarGapSize, topBarGapSize, topBarGapSize, topBarGapSize )
    topBar:SetTall( panelHeight )

    topBar.Paint = function( s, w, h )

        draw.RoundedBox( roundedAmount, 0, 0, w, h, headerColor )

    end

    do 
    
        MUnbox.CreateSearchBar( topBar, searchBarWidth, function( s, value )

            value = string.lower( value )

            self:LoadStoreItems( value )
                 
        end )  

    end

    local scrollPanel = self:Add( "MonkeyLib:ScrollPanel" )
    scrollPanel:Dock( FILL )
    scrollPanel:DockMargin( 0, gapSize, 0, 0 )

    scrollPanel:InvalidateParent( true )

    scrollPanel.Paint = function( s, w, h ) end 

    local oldLayout = scrollPanel.PerformLayout

    scrollPanel.PerformLayout = function( s, w, h ) // This is a complete hack, I have no clue on a fix for the DIconLayout issues I was having. 

        oldLayout( s, w, h )

        local layout = self.itemLayout
        if ( not IsValid( layout ) ) then 
                
            return 
        end 

        layout:SetWide( w ) // Fixes some bugs I was having. 
        layout:Layout()
        
    end

    self.scrollPanel = scrollPanel 

    do 
        
            
        local itemLayout = scrollPanel:Add( "MUnbox:IconLayout" )
        itemLayout:SetWide( scrollPanel:GetWide() )

        itemLayout:SetSpaceX( gapSize )
        itemLayout:SetSpaceY( gapSize )
        
        itemLayout.Paint = function( s, w, h ) end 
        
        self.itemLayout = itemLayout 

    end

    async( function ()

        if ( not IsValid( self ) ) then return end 

        self:LoadStoreItems()      

    end )
end

function PANEL:Paint() end 

vgui.Register( "MonkeyUnbox:StorePanel", PANEL, "DPanel" )

hook.Add( "MonkeyLib:ThemeReload", "MonkeyUnbox:Store:ReloadTheme", function( themeIndex )
    
    GUITheme = MonkeyLib:GetTheme()

    bodyColor, headerColor, primaryTextColor, secondaryTextColor, greenColor = GUITheme.bodyColor, GUITheme.headerColor, GUITheme.primaryTextColor, GUITheme.secondaryTextColor,  GUITheme.greenColor

end )
