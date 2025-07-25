require("async")

local primaryFont = "MonkeyLib_Inter_15"

local secondaryFont = "MonkeyLib_Inter_14"

local GUITheme = MonkeyLib:GetTheme()

local bodyColor, headerColor, greenColor = GUITheme.bodyColor, GUITheme.headerColor, GUITheme.greenColor
local primaryTextColor, secondaryTextColor = GUITheme.primaryTextColor, GUITheme.secondaryTextColor 

local gapSize = 8
local topBarGapSize = gapSize - 2 

local roundedAmount = 8
local searchBarRoundedAmount = roundedAmount - 2

local rarityOutlineSize = 4


local panelHeight = 40 

local emptySpaceSize = 180 // Might add scaling in the future, honestly not bothered about scaling small elements.
local equipHueSpeed = 80

local searchBarWidth = 150 

local drawEmptySpace = function( parent )

    if ( not IsValid( parent ) ) then return end 

    local emptySpace = parent:Add( "DPanel" )
    emptySpace:SetSize( emptySpaceSize, emptySpaceSize )

    emptySpace.Paint = function( s, w, h )

        draw.RoundedBox( roundedAmount, 0, 0, w, h, headerColor ) 

    end

end

local DMenuOptions = {
    {
        ["Name"] = "Unbox Crate", 

        ["CanSee"] = function( _, item )

            if ( not istable( item ) ) then return end 

            return item.isCrate or false 
        end, 

        ["Callback"] = function( item )

            if ( not istable( item ) ) then return end 

            local itemID = item.itemID 
            if ( not itemID ) then return end 

            MUnbox.CreateCrateViewer( itemID, item.id, true )
        end
    }, 
    {
        ["Name"] = "Equip Item",

        ["CanSee"] = function( _, item )
            
            return ( not item.isCrate ) and ( not item.isEquiped )
        end,

        ["Callback"] = function( item )

            if ( not istable( item ) ) then return end 

            local itemID = item.id 
            if ( not isnumber( itemID ) ) then return end 

            MonkeyNet.WriteStructure( "MUnbox:Inventory:EquipItem", MUnbox.NetStructures.EquipItem, { itemID } )
            
        end
    }, 
    {
        ["Name"] = "Un-Equip Item",

        ["CanSee"] = function( _, item )
            
            return ( not item.isCrate ) and ( item.isEquiped )
        end,

        ["Callback"] = function( item )

            if ( not istable( item ) ) then return end 

            local itemID = item.id 
            if ( not isnumber( itemID ) ) then return end 

            MonkeyNet.WriteStructure( "MUnbox:Inventory:EquipItem", MUnbox.NetStructures.EquipItem, { itemID } )
            
        end
    }, 
    {
        ["Name"] = "Delete Item", 
        ["Callback"] = function( item )

            if ( not istable( item ) ) then return end 

            MUnbox.CreateQuery( "query_confirm_delete", "query_cant_revert", function()
            
                local itemID = item.id 
                if ( not isnumber( itemID ) ) then return end 
    
                MonkeyNet.WriteStructure( "MUnbox:Inventory:DeleteItem", MUnbox.NetStructures.DeleteInventoryItem, { itemID } )

            end )
        end
    }, 

}

local PANEL = {}

function PANEL:AddInventoryItem( index, searchFilter )

    local itemLayout = self.itemLayout 
    if ( not IsValid( itemLayout ) ) then return end 
  
    local inventoryItems = MUnbox.GetInventory()

    local itemRow = inventoryItems[index]

    if ( not istable( itemRow ) ) then 
        
        if ( searchFilter and searchFilter ~= "" ) then return end 
        
        drawEmptySpace( itemLayout )

        return 
    end  

    local itemID, itemRarity, isCrate = itemRow.itemID, itemRow.itemRarity, itemRow.isCrate
    if ( not isstring( itemID ) or not isstring( itemRarity ) ) then return end 

    local itemName = MUnbox.GetItemInfo( itemID, isCrate )
    if ( not isstring( itemName ) ) then return end 
    
    local lowerName = string.lower( itemName )

    if ( isstring( searchFilter ) and not string.match( lowerName, searchFilter ) ) then 
        
        return 
    end 

    local itemPanel = MUnbox.CreateItemPanel( itemLayout, itemID, itemRarity, isCrate )
    if ( not IsValid( itemPanel ) ) then return end 

    local uses = itemRow.Uses or -1

    if ( uses ~= -1 ) then 
    
        local textLabel = itemPanel:Add( "DPanel" )
        textLabel:SetPos( rarityOutlineSize, rarityOutlineSize )
        textLabel:SetSize( itemPanel:GetWide(), panelHeight )

        textLabel:SetMouseInputEnabled( false )

        textLabel.Paint = function( s, w, h ) // Would use DLabel, however it means I need to do an O(n ^ 2) to modify the equip incrementer 

            draw.SimpleText( ( itemRow.Uses or 0 ), secondaryFont, 0, 0, primaryTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )

        end

    end
    

    local namePanel = itemPanel.namePanel
    if ( not IsValid( namePanel ) ) then return end 

    if ( not isCrate ) then 

        local oldPaint = namePanel.Paint 

        namePanel.Paint = function( s, w, h )

            if ( itemRow and not itemRow.isEquiped ) then 

                s.bodyColor = nil 

                oldPaint( s, w, h )

                return 
            end 

            local hueValues = HSVToColor( ( CurTime() * equipHueSpeed ) % 360, 1, 1 )
    
            s.bodyColor = hueValues 

            oldPaint( s, w, h )
        end

    end

    itemPanel.DoClick = function()

        local options = MonkeyLib.DermaMenu( DMenuOptions, itemRow )

        options:Open()

    end
end

function PANEL:LoadInventoryItems( searchFilter )

    local itemLayout = self.itemLayout 
    if ( not IsValid( itemLayout ) ) then return end 

    async( function()

        if ( not IsValid( itemLayout ) or not IsValid( self ) ) then return end 

        itemLayout:Clear()

        local inventoryRows = MUnbox.Config.InventorySpace or 0 

        local inventoryItems = MUnbox.GetInventory()
        
        for k = 1, inventoryRows  do 
            
            self:AddInventoryItem( k, searchFilter )

        end
    
    end )
end 

function PANEL:Init()

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

    local _, searchBar = MUnbox.CreateSearchBar( topBar, searchBarWidth, function( s, value )

        value = string.lower( value )

        self:LoadInventoryItems( value )   

    end )

    local scrollPanel = self:Add( "MonkeyLib:ScrollPanel" )
    scrollPanel:Dock( FILL )
    scrollPanel:DockMargin( 0, gapSize, 0, 0 )

    scrollPanel:InvalidateParent( true )

    local oldLayout = scrollPanel.PerformLayout

    scrollPanel.PerformLayout = function( s, w, h ) // This is a complete hack, I have no clue on a fix for the DIconLayout issues I was having with docking. 

        oldLayout( s, w, h )

        local layout = self.itemLayout 
        if ( not IsValid( layout ) ) then return end 

        layout:SetWide( w ) // Fixes some bugs I was having. 
        layout:Layout()

    end
    
    scrollPanel.Paint = function(s, w, h) end 

    self.scrollPanel = scrollPanel 

    do 
            
        local itemLayout = scrollPanel:Add( "DIconLayout" )
        itemLayout:InvalidateParent( true )
        itemLayout:SetWide( scrollPanel:GetWide() ) // Fixes a fuck tonne of bugs I was having. 

        itemLayout:SetSpaceX( gapSize )
        itemLayout:SetSpaceY( gapSize )
        
        itemLayout.Paint = function( s, w, h ) end 
        
        self.itemLayout = itemLayout 

    end

    async( function ()

        if ( not IsValid( self ) ) then return end 

        self:LoadInventoryItems()      

    end )

    hook.Add( "MonkeyUnbox:Inventory:Added", "MonkeyUnbox:Inventory:AddItem", function( )

        if ( not IsValid( self ) ) then hook.Remove( "MonkeyUnbox:Inventory:Added", "MonkeyUnbox:Inventory:AddItem" ) return end 
        
        local searchFilter = searchBar:GetValue()
        searchFilter = string.lower( searchFilter )
        
        self:LoadInventoryItems( searchFilter ) // This is a quick solution for now, I want a better solution.

    end )

    hook.Add( "MonkeyUnbox:Inventory:Removed", "MonkeyUnbox:Inventory:RemoveItem", function( )

        if ( not IsValid( self ) ) then hook.Remove( "MonkeyUnbox:Inventory:Removed", "MonkeyUnbox:Inventory:RemoveItem" ) return end 
        
        local searchFilter = searchBar:GetValue()
        searchFilter = string.lower( searchFilter )

        self:LoadInventoryItems( searchFilter ) // This is a quick solution for now, I want a better solution.

    end ) 
end

function PANEL:Paint() end 

vgui.Register( "MonkeyUnbox:InventoryPanel", PANEL, "DPanel" )

hook.Add( "MonkeyLib:ThemeReload", "MonkeyUnbox:Inventory:ReloadTheme", function( themeIndex )
    
    GUITheme = MonkeyLib:GetTheme()

    bodyColor, headerColor, primaryTextColor, secondaryTextColor, greenColor = GUITheme.bodyColor, GUITheme.headerColor, GUITheme.primaryTextColor, GUITheme.secondaryTextColor,  GUITheme.greenColor

end )
