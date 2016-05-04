' ********************************************************************
' ********************************************************************
' **  Roku NumericPad example (BrightScript)
' **
' **  Created: January 2016
' **  Updated: May 2016
' **  Copyright (c) 2016 Marcelo Lv Cabral
' ********************************************************************
' ********************************************************************

Sub SettingsScreen()
    this = {
            screen: CreateObject("roListScreen")
            port: CreateObject("roMessagePort")
            navi : CreateObject("roAudioResource", "navsingle")
            dead : CreateObject("roAudioResource", "deadend")
           }
    this.screen.SetMessagePort(this.port)
    this.screen.SetHeader("Configure the Tournament Structure")
    listItems = GetSettingsMenuItems()
    this.screen.SetContent(listItems)
    this.screen.Show()
    listIndex = 0
    while true
        msg = WaitMessage(this.port)
        if msg.isScreenClosed() then return
        if type(msg) = "roListScreenEvent"
            if msg.isListItemFocused()
                listIndex = msg.GetIndex()
            else if msg.isListItemSelected()
                index = msg.GetIndex()
                if index = 0 'Edit Name
                    name = ShowKeyboardScreen("", "Name", m.settings.name, "OK", "Cancel", false)
                    if name <> ""
                        m.settings.name = left(name,50)
                        listItems[index].Title = "Name: " + m.settings.name
                        this.screen.SetItem(index, listItems[index])
                    end if
                else if index = 1 'Integer Value
                    value = NumericKeyboard("Integer Value", m.settings.value, 4)
                    if value duration > 0
                        m.settings.value = value
                        listItems[index].Title = "Value:" + Str(m.settings.value)
                        this.screen.SetItem(index, listItems[index])
                    end if
                else if index = 2 'Duration
                    msgbtns = ["15 minutes", "20 minutes", "30 minutes", "45 minutes", "60 minutes", "Custom..."]
                    opt = MessageBox(this.port,"Numeric Keypad", "Select the Duration", msgbtns)
                    if opt = msgbtns.Count()-1
                        duration = NumericKeyboard("Duration (min)", m.settigns.duration , 3)
                    else
                        duration = Int(Val(left(msgbtns[opt],2)))
                    end if
                    if duration <> invalid and duration > 0
                        m.settings.duration = duration
                        listItems[index].Title = "Duration:" + Str(m.settings.duration) + " minutes"
                        this.screen.SetItem(index, listItems[index])
                    end if
                else if index = 4 'Save
                    if SaveSettings()
                        MessageBox("Settings saved on registy!")
                    end if
                end if
            else if msg.isRemoteKeyPressed()
                bump = false
                remoteKey = msg.GetIndex()
                if listIndex = 3 'Colors
                    if remoteKey = m.codes.BUTTON_LEFT_PRESSED and m.settings.color > 0
                        m.settings.color--
                    else if remoteKey = m.codes.BUTTON_RIGHT_PRESSED and m.settings.color < m.color.Count() - 1
                        m.settings.color++
                    else
                        bump = true
                    end if
                    listItems[listIndex].Title = "Color : " + m.colors[m.settings.color]
                    this.screen.SetItem(listIndex, listItems[listIndex])
                end if
                if bump
                    this.dead.Trigger(50)
                else
                    this.navi.Trigger(50)
                end if
            end if
        end if
    end while
    return
End Sub

Function GetSettingsMenuItems()
    listItems = []
    listItems.Push({
                Title: "Name: " + m.settings.name
                HDSmallIconUrl: "pkg:/images/ElipsisIcon.png"
                SDSmallIconUrl: "pkg:/images/ElipsisIcon.png"
                HDPosterUrl: "pkg:/images/lib-settings.png"
                ShortDescriptionLine1: "Press OK to edit the text"
                ShortDescriptionLine2: "The string can have up to 50 characters"
                })
    listItems.Push({
                Title: "Value:" + Str(m.settings.value)
                HDSmallIconUrl: "pkg:/images/ElipsisIcon.png"
                SDSmallIconUrl: "pkg:/images/ElipsisIcon.png"
                HDPosterUrl: "pkg:/images/lib-settings.png"
                ShortDescriptionLine1: "Press OK to type the integer value"
                })
    listItems.Push({
                Title: "Duration:" + Str(tournament.duration) + " minutes"
                HDSmallIconUrl: "pkg:/images/ElipsisIcon.png"
                SDSmallIconUrl: "pkg:/images/ElipsisIcon.png"
                HDPosterUrl: "pkg:/images/lib-settings.png"
                ShortDescriptionLine1: "Press OK to select duration"
                })
    listItems.Push({
                Title: "Colors:" + Str(m.colors(m.settings.color))
                HDSmallIconUrl: "pkg:/images/ArrowsIcon.png"
                SDSmallIconUrl: "pkg:/images/ArrowsIcon.png"
                HDPosterUrl: "pkg:/images/lib-settings.png"
                ShortDescriptionLine1: "Use Left and Right to change color"
                })
    return listItems
End Function

Function MessageBox(port, title, text, buttons = ["OK"], default = 0, overlay = false) As Integer
    s = CreateObject("roMessageDialog")
    s.SetTitle(title)
    s.SetText(text)
    s.SetMessagePort(port)
    s.EnableOverlay(overlay)
    for b = 0 to buttons.Count()-1
        s.AddButton(b, buttons[b])
    next
    s.SetFocusedMenuItem(default)
    s.Show()
    result = default
    while true
        msg = wait(0, port)
        if msg.isButtonPressed()
            result = msg.GetIndex()
            exit while
        else if msg.isScreenClosed()
            exit while
        end if
    end while
    return result
End Function

Function ShowKeyboardScreen(title = "", prompt = "", text = "", button1 = "Okay", button2= "Cancel", secure = false)
    result = ""

    port = CreateObject("roMessagePort")
    screen = CreateObject("roKeyboardScreen")
    screen.SetMessagePort(port)

    screen.SetTitle(title)
    screen.SetDisplayText(prompt)
    screen.SetText(text)

    screen.AddButton(1, button1)
    screen.AddButton(2, button2)

    screen.SetSecureText(secure)

    screen.Show()

    while true
        msg = wait(0, port)

        if type(msg) = "roKeyboardScreenEvent" then
            if msg.isScreenClosed()
                exit while
            else if msg.isButtonPressed()
                if msg.GetIndex() = 1 and screen.GetText().Trim() <> "" 'Ok
                    result = screen.GetText()
                    exit while
                else if msg.GetIndex() = 2 'Cancel
                    result = ""
                    exit while
                end if
            end if
        end if
    end while

    screen.Close()
    return result
End function

Function GetIntSetting(key as String, default As Integer) As Integer
    sec = CreateObject("roRegistrySection", "NumericPad")
    if sec.Exists(key)
        return Int(Val(sec.Read(key)))
    endif
    return default
End Function

Function GetStringSetting(key as String, default = "") As String
    sec = CreateObject("roRegistrySection", "NumericPad")
    if sec.Exists(key)
        return sec.Read(key)
    endif
    return default
End Function

Sub SaveSettings(settings as Object)
    sec = CreateObject("roRegistrySection", "NumericPad")
    sec.Write("Name", settings.chipdenomination)
    sec.Write("Value", Str(settings.value))
    sec.Write("Duration", Str(settings.duration))
    sec.Write("Color", Str(settings.color))
    sec.Flush()
End Sub
