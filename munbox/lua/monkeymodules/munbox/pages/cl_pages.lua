require( "async" )

local primaryFont = "MonkeyLib_Inter_15"
local primaryFontHeight = draw.GetFontHeight( primaryFont )

local GUITheme = MonkeyLib:GetTheme()

local bodyColor, headerColor, greenColor = GUITheme.bodyColor, GUITheme.headerColor, GUITheme.greenColor
local primaryTextColor, secondaryTextColor = GUITheme.primaryTextColor, GUITheme.secondaryTextColor 

local gapSize = 8 
local iconOffset = 16 

local headerHeight = 40 
local resizeBarHeight = headerHeight - 10 

local resizeButtonSpeed = 10 
local resizeButtonOffset = 8 

local sideBarWidth = 175

local frameScaleWidth, frameScaleHeight = .8, .7 
local sideBarMoveSpeed = .3 

local contractOffset = gapSize
local sizeBarContractedSize = headerHeight + contractOffset

local loadTabs = function( tabSideBar, parent )

    if ( not IsValid( tabSideBar ) or not IsValid( parent ) ) then return end 
    
    local tabs = MUnbox.Tabs

    local iconDockOffset = ( contractOffset / 2 ) 

    local colorLerpFunc = MonkeyLib.ColorLerp

    for k = 1, #tabs do 

        local tabInfo = tabs[k]
        if ( not istable( tabInfo ) ) then continue end 

        local TabName, Icon, VGUIPanel, StartsActive = tabInfo.Name, tabInfo.Icon, tabInfo.VGUIPanel, tabInfo.StartsActive 
        if ( not TabName or not Icon or not VGUIPanel ) then continue end 

        local foundIcon = MonkeyLib:GetIcon( Icon )

        local panel, button = tabSideBar:RegisterButton( StartsActive, parent, function( pnl, button )
    
            if ( not IsValid( button ) or not IsValid( pnl ) ) then return end 

            lerpPos = button:GetY() or 0 

            if ( isfunction( pnl.ReCall ) ) then pnl:ReCall() end 
            
        end, VGUIPanel )

        if ( not IsValid( button ) ) then return end 

        button:Dock( TOP )
        button:SetTall( headerHeight )
        button:SetText( " " )

        button.ColorLerp = StartsActive and bodyColor or headerColor
     
        button.Paint = function( s, w, h ) 

            s.ColorLerp = colorLerpFunc( s.ColorLerp, ( tabSideBar.ActivePanel == s.TabIndex ) and bodyColor or headerColor )

            draw.RoundedBox( 0, 0, 0, w, h, s.ColorLerp )

            draw.SimpleText( TabName, primaryFont, h + contractOffset, h / 2, primaryTextColor, TEXT_ALIGN_LEFT, 1 )
       
        end 
        
        local buttonIcon = button:Add( "DPanel" )
        buttonIcon:Dock( LEFT )
        buttonIcon:DockMargin( iconDockOffset, 0, 0, 0 )

        buttonIcon:SetWide( button:GetTall() )
        buttonIcon:SetMouseInputEnabled( false )

        buttonIcon.Paint = function( s, w, h )
            
            surface.SetMaterial( foundIcon )
                surface.SetDrawColor( secondaryTextColor )
            surface.DrawTexturedRect( iconOffset / 2, iconOffset / 2, w - iconOffset, h - iconOffset )

        end
    end
end

MUnbox.ScaleFrame = function()

    local scrw, scrh =  ScrW() * frameScaleWidth, ScrH() * frameScaleHeight

    return math.floor( scrw ), math.floor( scrh )
end

local formattedPoints = "NULL"

MUnbox.CreateFrame = function()
    
    local ply = LocalPlayer()

    local playerPoints = MonkeyLib.GetMoney( ply ) or 0 

    formattedPoints = MonkeyLib.FormatMoney( playerPoints )

    local scaleW, scaleH = MUnbox.ScaleFrame()

    local frame = MonkeyLib:CreateDefaultFrame( scaleW, scaleH )

    assert( IsValid( frame ), "MonkeyLib Frame isn't valid." )

    local sideToolBar = frame:Add( "DPanel" )
    sideToolBar:Dock( LEFT )
    sideToolBar:SetWide( sideBarWidth )

    sideToolBar.isContracted = false 

    sideToolBar.Paint = function( s, w, h )

        draw.RoundedBoxEx( frame.roundedAmount or 16, 0, 0, w, h, headerColor, false, false, true, false )

    end

    local sideBarSize = sideToolBar:GetWide()  

    local resizeBar = sideToolBar:Add( "DPanel" ) // Scale this please.
    resizeBar:Dock( TOP )
    resizeBar:SetTall( resizeBarHeight )

    resizeBar.Paint = function( s, w, h ) end 

    do 

        local resizeArrow = MonkeyLib:GetIcon( "m_scoreboard_arrow" ) // Change to an internal icon. 

        local resizeButton = resizeBar:Add( "DButton" )
        resizeButton:Dock( RIGHT )
        resizeButton:SetWide( resizeBar:GetTall() )
        resizeButton:SetText( " " )

        resizeButton.Lerp = 0 
        
        resizeButton.DoClick = function( s )

            if ( not IsValid( sideToolBar ) ) then return end 

            sideToolBar:Stop()
            
            sideToolBar:SizeTo( sideToolBar.isContracted and sideBarSize or sizeBarContractedSize, -1, sideBarMoveSpeed, 0, -1 )

            sideToolBar.isContracted = not sideToolBar.isContracted

        end

        resizeButton.Paint = function(s, w, h)

            s.Lerp = Lerp( FrameTime() * resizeButtonSpeed, s.Lerp, sideToolBar.isContracted and 90 or -90 )
            
            surface.SetDrawColor( primaryTextColor )
                surface.SetMaterial( resizeArrow )
            surface.DrawTexturedRectRotated( w / 2, h / 2, w - resizeButtonOffset, h - resizeButtonOffset, s.Lerp )

        end
    end

    local playerName = ply:Name()

    local playerInfo = sideToolBar:Add( "DPanel" )
    playerInfo:Dock( TOP )
    playerInfo:SetTall( headerHeight )

    playerInfo.Paint = function( s, w, h )
        
        local newMoney = MonkeyLib.GetMoney( ply )

        if ( newMoney ~= playerPoints ) then 

            formattedPoints = MonkeyLib.FormatMoney( newMoney )

            playerPoints = newMoney 

        end

        draw.SimpleText( playerName, primaryFont, h + contractOffset, h / 2 - primaryFontHeight / 2, primaryTextColor, TEXT_ALIGN_LEFT, 1 )
        
        draw.SimpleText( formattedPoints, primaryFont, h + contractOffset, h / 2 + primaryFontHeight / 2, greenColor, TEXT_ALIGN_LEFT, 1 ) 

    end

    do 

        local avatarOffset = ( contractOffset / 2 ) + ( gapSize / 2 )
    
        local playerAvatar = playerInfo:Add( "MonkeyLib:CircleAvatar" )
        playerAvatar:Dock( LEFT )
        playerAvatar:DockMargin( avatarOffset, gapSize / 2, 0, gapSize / 2 )

        playerAvatar:SetWide( playerInfo:GetTall() - gapSize )

        playerAvatar:SetPlayer( ply )

    end

    local sideBar = sideToolBar:Add( "MonkeyLib:Tabs" )
    sideBar:Dock( FILL )
    
    sideBar.Paint = function() end 

    async( loadTabs, sideBar, frame )

end

hook.Add( "MonkeyLib:ThemeReload", "MonkeyUnbox:Pages:ReloadTheme", function( themeIndex )
    
    GUITheme = MonkeyLib:GetTheme()

    bodyColor, headerColor, primaryTextColor, secondaryTextColor, greenColor = GUITheme.bodyColor, GUITheme.headerColor, GUITheme.primaryTextColor, GUITheme.secondaryTextColor,  GUITheme.greenColor

end )

MonkeyLib.RegisterChatCommand( { "unbox", "crates", "store" }, function( )

    MUnbox.CreateFrame()

end )

