' ********************************************************************
' ********************************************************************
' **  Roku NumericPad example (BrightScript)
' **
' **  Created: January 2016
' **  Updated: May 2016
' **  Copyright (c) 2016 Marcelo Lv Cabral
' ********************************************************************
' ********************************************************************

Library "v30/bslCore.brs"

Sub Main()
    'Constants
    m.codes = bslUniversalControlEventCodes()
    m.colors = ["Blue", "Green", "Red", "Black", "White"]
    'Setup App Manager Theme
    app = CreateObject("roAppManager")
    app.SetTheme(GetTheme())
    'Load Settings
    m.settings = {}
    m.settings.name = GetStringSetting("Name", "Default Name")
    m.settings.integerValue = GetIntSetting("IntegerValue", 5)
    m.settings.floatValue = GetFloatSetting("FloatValue", 30.70)
    m.settings.duration = GetIntSetting("Duration", 15)
    m.settings.color = GetIntSetting("Color", 0)
    'Open Settings Screen
    SettingsScreen()
End Sub

Function GetTheme()
    theme = CreateObject("roAssociativeArray")
    theme.OverhangOffsetSD_X = "15"
    theme.OverhangOffsetSD_Y= "10"
    theme.OverhangSliceSD= "pkg:/images/lib-overhang-sd.png"
    theme.OverhangLogoSD = "pkg:/images/lib-logo-sd.png"

    theme.OverhangOffsetHD_X= "50"
    theme.OverhangOffsetHD_Y= "20"
    theme.OverhangSliceHD= "pkg:/images/lib-overhang-hd.png"
    theme.OverhangLogoHD = "pkg:/images/lib-logo-hd.png"

    theme.ButtonMenuHighlightText= "#FFFFFF"
    theme.ButtonHighlightColor=    "#FFFFFF"
    theme.BackgroundColor=         "#000000"
    theme.PosterScreenLine1Text=   "#FFFFFF"
    theme.BreadcrumbTextRight=     "#FFFFFF"

    theme.ParagraphHeaderText=     "#FFFFFF"

    theme.SpringboardTitleText=    "#FFFFFF"
    theme.SpringboardArtistColor=  "#FFFFFF"
    theme.SpringboardAlbumColor=   "#FFFFFF"
    theme.SpringboardRuntimeColor= "#FFFFFF"

    theme.ListScreenHeaderText=    "#FFFFFF"
    theme.ListItemHighlightText=   "#FFFFFF"

    return theme
End Function
