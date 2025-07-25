local headerFont = "MonkeyLib_Inter_20"

local primaryFont = "MonkeyLib_Inter_17"
local primaryFontHeight = draw.GetFontHeight( primaryFont )

local secondaryFont = "MonkeyLib_Inter_14"
local secondaryFontHeight = draw.GetFontHeight( secondaryFont )

local GUITheme = MonkeyLib:GetTheme()

local bodyColor, headerColor, greenColor, redColor = GUITheme.bodyColor, GUITheme.headerColor, GUITheme.greenColor, GUITheme.redColor
local primaryTextColor, secondaryTextColor = GUITheme.primaryTextColor, GUITheme.secondaryTextColor 

local gapSize = 8 
local roundedAmount = 8

local animationSpeed = .3 
local outlineSize = 4

local queryWidth, queryHeight = 400, 175

local safeFormat = function( message, format )

    if ( not isstring( message ) ) then return end 

    message = MUnbox.Config.Messages[message] or message 

    local succ, err = pcall( string.format, message, unpack( format or {} ) )

    if ( not succ and err ) then 

        return message 
    end

    return err 
end

local closeQuery = function( s )

    if ( not IsValid( s ) ) then return end 

    s:Stop()

    s:AlphaTo( 0, animationSpeed, 0, function()

        if ( IsValid( s ) ) then s:Remove() end 

    end )

end

MUnbox.CreateQuery = function( primaryText, secondaryText, confirmFunc, primaryTextFormat, secondaryTextFormat )

    if ( not isstring( primaryText ) or not isstring( secondaryText ) or not isfunction( confirmFunc ) ) then return end 

    primaryText = safeFormat( primaryText, primaryTextFormat )
    secondaryText = safeFormat( secondaryText, secondaryTextFormat )
    
    local scrw, scrh = ScrW(), ScrH()
    
    local frame = MUnbox.CreateSimplifiedFrame( queryWidth, queryHeight ) // Possibly add some re-scale feature. If the text is too long or whatever. 
    if ( not IsValid( frame ) ) then return end 
    
    local header = frame.header 
    
    frame:DoModal( true )

    local headerHeight = header:GetTall()

    do // I honestly find this easier than DLabel 
        

        local textPanel = frame:Add( "DPanel" )
        textPanel:Dock( FILL )

        textPanel.Paint = function( s, w, h )

            draw.SimpleText( primaryText, primaryFont, w / 2, h / 2 - primaryFontHeight / 2, primaryTextColor, 1, 1 )

            draw.SimpleText( secondaryText, secondaryFont, w / 2, h / 2 + secondaryFontHeight / 2, secondaryTextColor, 1, 1 )

        end
    end

    local queryButtonRow = frame:Add("DPanel")
    queryButtonRow:Dock( BOTTOM )
    queryButtonRow:DockMargin( gapSize, gapSize, gapSize ,gapSize)

    queryButtonRow:SetTall( headerHeight )
    queryButtonRow:InvalidateParent( true )

    queryButtonRow.Paint = function() end 

    do 
        local gapMath = queryButtonRow:GetWide() / 2 - ( gapSize / 2 )

        local queryYes = queryButtonRow:Add( "DButton" )
        queryYes:Dock( LEFT )
        queryYes:SetWide( gapMath )
        queryYes:SetText( "Yes" )
        queryYes:SetFont( primaryFont )
        queryYes:SetTextColor( primaryTextColor )

        queryYes.Paint = function( s, w, h )

            draw.RoundedBox( roundedAmount / 2, 0, 0, w, h, greenColor )

            draw.RoundedBox( roundedAmount / 2, outlineSize / 2, outlineSize / 2, w - outlineSize, h - outlineSize, headerColor )

        end

        queryYes.DoClick = function()

            closeQuery( frame )

            confirmFunc()

        end
   
        local queryNo = queryButtonRow:Add( "DButton" )
        queryNo:Dock( RIGHT )
        queryNo:SetWide( gapMath )
        queryNo:SetText( "No" )
        queryNo:SetFont( primaryFont )
        queryNo:SetTextColor( primaryTextColor )

        queryNo.Paint = function( s, w, h )
            
            draw.RoundedBox( roundedAmount / 2, 0, 0, w, h, redColor )

            draw.RoundedBox( roundedAmount / 2, outlineSize / 2, outlineSize / 2, w - outlineSize, h - outlineSize, headerColor )

        end

        queryNo.DoClick = function()

            closeQuery( frame )
            
        end
    end
end

hook.Add( "MonkeyLib:ThemeReload", "MonkeyUnbox:QueryBox:ReloadTheme", function( themeIndex )
    
    GUITheme = MonkeyLib:GetTheme()

    bodyColor, headerColor, primaryTextColor, secondaryTextColor, greenColor = GUITheme.bodyColor, GUITheme.headerColor, GUITheme.primaryTextColor, GUITheme.secondaryTextColor,  GUITheme.greenColor

end )
