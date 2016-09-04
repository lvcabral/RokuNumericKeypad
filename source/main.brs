'*
'* Roku NumericPad example (BrightScript)
'* Copyright (c) 2016 Marcelo Lv Cabral (http://github.com/lvcabral)
'*
'* Permission is hereby granted, free of charge, to any person obtaining a
'* copy of this software and associated documentation files (the "Software"),
'* to deal in the Software without restriction, including without limitation
'* the rights to use, copy, modify, merge, publish, distribute, sublicense,
'* and/or sell copies of the Software, and to permit persons to whom the Software
'* is furnished to do so, subject to the following conditions:
'*
'* The above copyright notice and this permission notice shall be included in all
'* copies or substantial portions of the Software.
'*
'* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
'* INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
'* PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
'* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
'* OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
'* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
'*

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
