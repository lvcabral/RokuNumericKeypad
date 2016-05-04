' ********************************************************************
' ********************************************************************
' **  Roku NumericPad example (BrightScript)
' **
' **  Created: January 2016
' **  Updated: May 2016
' **  Copyright (c) 2016 Marcelo Lv Cabral
' ********************************************************************
' ********************************************************************

Function NumericKeyboard(label as string, number as integer, maxDigits = 11, allowNegative = false, allowDecimal = false)
    'local variables
    keypadPos = { x: 500, y: 300 }
    cursorPos = { x: keypadPos.x + 258, y: keypadPos.y - 94 }
    selectedCol = 0
    selectedRow = 0
    blinkCursor = true
    if number > 0
        retNumber = itostr(number)
    else
        retNumber = ""
    end if
    'Keypad object
    this = {
            canvas: CreateObject("roImageCanvas")
            port  : CreateObject("roMessagePort")
            fonts : CreateObject("roFontRegistry")
            navi : CreateObject("roAudioResource", "navsingle")
            dead : CreateObject("roAudioResource", "deadend")
            select : CreateObject("roAudioResource", "select")
            overhang = GetOverhang()
            buttons = GetKeyPadButtons(keypadPos)
           }
    'Setup Keypad
    this.canvas.SetMessagePort(this.port)
    canvasRect = this.canvas.GetCanvasRect()
    this.canvas.SetLayer(0, GetOverhang())
    this.canvas.SetLayer(1, { url: "pkg:/images/lib-keypad-back.png", TargetRect: keypadPos })
    this.canvas.SetLayer(2, this.buttons[this.selectedCol][this.selectedRow])
    this.canvas.SetLayer(3, GetField(keypadPos, label, retNumber))
    this.canvas.SetLayer(4, { url: "pkg:/images/lib-keypad-cursor.png", TargetRect: cursorPos })
    this.canvas.Show()
    while true
        event = wait(500, this.port)
        if event<> invalid
            if event.isRemoteKeyPressed()
                index = event.GetIndex()
                if index = m.codes.BUTTON_LEFT_PRESSED
                    selectedCol--
                    if selectedCol < 0
                        selectedCol = this.buttons.Count() - 1
                    end if
                    this.navi.Trigger(50)
                else if index = m.codes.BUTTON_RIGHT_PRESSED
                    selectedCol++
                    if selectedCol >= this.buttons.Count() then selectedCol = 0
                    this.navi.Trigger(50)
                else if index = m.codes.BUTTON_UP_PRESSED
                    selectedRow--
                    if selectedRow < 0 then selectedRow = this.buttons[selectedCol].Count() - 1
                    this.navi.Trigger(50)
                else if index = m.codes.BUTTON_DOWN_PRESSED
                    selectedRow++
                    if selectedRow >= this.buttons[selectedCol].Count() then selectedRow = 0
                    this.navi.Trigger(50)
                else if index = m.codes.BUTTON_SELECT_PRESSED and selectedCol < 3
                    negative = (Left(retNumber,1) = "-")
                    bump = false
                    sel = this.buttons[selectedCol][selectedRow]
                    if sel.button = "-" and allowNegative
                        if negative
                            retNumber = Mid(retNumber,2)
                        else
                            retNumber = "-" + retNumber
                        end if
                    else
                        if sel.button = "." and (InStr(0, retNumber, ".") > 0 or not allowDecimal)
                            bump = true
                        else if (negative and len(retNumber) = maxDigits + 1) or (not negative and len(retNumber) = maxDigits)
                            bump = true
                        else if sel.button = "-"
                            bump = true
                        else
                            retNumber += sel.button
                        end if
                    end if
                    if bump
                        this.dead.Trigger(50)
                    else
                        this.select.Trigger(50)
                    end if
                else if index = m.codes.BUTTON_SELECT_PRESSED and selectedCol = 3
                    sel = this.buttons[selectedCol][selectedRow]
                    if sel.button = "ok"
                        this.select.Trigger(50)
                        exit while
                    else if sel.button = "cancel"
                        this.select.Trigger(50)
                        return invalid
                    else if sel.button = "clear"
                        this.select.Trigger(50)
                        retNumber = ""
                    else
                        if Len(retNumber) > 0
                            retNumber = Left(retNumber, Len(retNumber)-1)
                            this.select.Trigger(50)
                        else
                            this.dead.Trigger(50)
                        end if
                    end if
                else if index = m.codes.BUTTON_REWIND_PRESSED
                    if Len(retNumber) > 0
                        retNumber = Left(retNumber, Len(retNumber)-1)
                        this.select.Trigger(50)
                    else
                        this.dead.Trigger(50)
                    end if
                else if index = m.codes.BUTTON_BACK_PRESSED
                    return invalid
                endif
                this.canvas.SetLayer(0, this.overhang)
                this.canvas.SetLayer(1, { url: "pkg:/images/lib-keypad-back.png", TargetRect: keypadPos })
                this.canvas.SetLayer(2, this.buttons[selectedCol][selectedRow])
                this.canvas.SetLayer(3, GetField(keypadPos, label, retNumber))
            end if
        end if
        if blinkCursor
            this.canvas.ClearLayer(4)
        else
            this.canvas.SetLayer(4, { url: "pkg:/images/lib-keypad-cursor.png", TargetRect: cursorPos })
        end if
        blinkCursor = not blinkCursor

    end while
    return Int(Val(retNumber.Trim()))

End Function

Function GetOverhang()
    theme = GetTheme()
    overhang = []
    overhang.Push({ Color: "#00000000", CompositionMode: "Source", url: theme.OverhangSliceHD})
    overhang.Push({ url: theme.OverhangLogoHD, TargetRect: {x: int(val(theme.OverhangOffsetHD_X)), y: int(val(theme.OverhangOffsetHD_Y))} })
    return overhang
End Function

Function GetKeyPadButtons(position as object) as object
    col1 = []
    col1.Push({
        url: "pkg:/images/lib-keypad-1.png"
        TargetRect: position
        button: "1"
    })
    col1.Push({
        url: "pkg:/images/lib-keypad-4.png"
        TargetRect: position
        button: "4"
    })
    col1.Push({
        url: "pkg:/images/lib-keypad-7.png"
        TargetRect: position
        button: "7"
    })
    col1.Push({
        url: "pkg:/images/lib-keypad-minus.png"
        TargetRect: position
        button: "-"
    })

    col2 = []
    col2.Push({
        url: "pkg:/images/lib-keypad-2.png"
        TargetRect: position
        button: "2"
    })
    col2.Push({
        url: "pkg:/images/lib-keypad-5.png"
        TargetRect: position
        button: "5"
    })
    col2.Push({
        url: "pkg:/images/lib-keypad-8.png"
        TargetRect: position
        button: "8"
    })
    col2.Push({
        url: "pkg:/images/lib-keypad-dot.png"
        TargetRect: position
        button: "."
    })

    col3 = []
    col3.Push({
        url: "pkg:/images/lib-keypad-3.png"
        TargetRect: position
        button: "3"
    })
    col3.Push({
        url: "pkg:/images/lib-keypad-6.png"
        TargetRect: position
        button: "6"
    })
    col3.Push({
        url: "pkg:/images/lib-keypad-9.png"
        TargetRect: position
        button: "9"
    })
    col3.Push({
        url: "pkg:/images/lib-keypad-0.png"
        TargetRect: position
        button: "0"
    })

    col4 = []
    col4.Push({
        url: "pkg:/images/lib-keypad-ok.png"
        TargetRect: position
        button: "ok"
    })
    col4.Push({
        url: "pkg:/images/lib-keypad-cancel.png"
        TargetRect: position
        button: "cancel"
    })
    col4.Push({
        url: "pkg:/images/lib-keypad-clear.png"
        TargetRect: position
        button: "clear"
    })
    col4.Push({
        url: "pkg:/images/lib-keypad-del.png"
        TargetRect: position
        button: "del"
    })
    buttons = []
    buttons.Push(col1)
    buttons.Push(col2)
    buttons.Push(col3)
    buttons.Push(col4)
    return buttons
End Function

Function GetField(position as object, label as string, value as string)
    txtArray = []
    txtArray.Push({
                url: "pkg:/images/lib-keypad-field.png"
                TargetRect: {x: position.x, y: position.y - 110} })
    txtArray.Push({
                Text: value
                TextAttrs: {color: "#ACACAC", font: "Large", HAlign: "Right"}
                TargetRect: {x: position.x + 20, y: position.y - 92, w: 240, h: 40}})
    txtArray.Push({
                Text: label
                TextAttrs: {color: "#787878", font: "Medium", HAlign: "Right"}
                TargetRect: {x: position.x + 22, y: position.y - 34, w: 240, h: 36}})
    return txtArray
End Function
