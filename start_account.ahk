#Requires AutoHotkey v2.0

;run loader.exe if it's not already running

configFile := "start_account_config.ini"

background_color := '0x131516'
background_grey := '0x545556'
jagex_account_select_first_name_color := '0x253F5E'
ok_button_color := '0x294A72'

start_jagex_account_x_config := 310
jagex_account_quantity := 5

base_config := 
"[start_account_configs]`njagex_account_quantity=5`nstart_jagex_account_button_x=310`n"

if !FileExist(configFile) {
    FileAppend(base_config, configFile)
}


start_jagex_account_x_config := IniRead(configFile, "start_account_configs", "start_jagex_account_button_x")
jagex_account_quantity := IniRead(configFile, "start_account_configs", "jagex_account_quantity")

if A_Args.Length < 1 {
    MsgBox('Please provide the account index to start by running with the account index as an argument. (e.g. ./start_account.ahk 3 to run the 3rd account)')
    ExitApp()
}

account_index := A_Args[1]

; MsgBox('Arg 1: ' A_Args[1])

if !WinExist("Loader")
{
    Run "loader.exe"
}

; get number of windows named "RuneScape"
runeScapeCount := WinGetCount("RuneScape")

x := 0
y := 0
w := 0
h := 0

; wait until there's a window with the title 'Loader'
WinWait('Loader',, 10)

; get the window position of the loader
WinGetPos(&x, &y, &w, &h, 'Loader')

window_center := (w / 2)

; print the loader window's position
; MsgBox('Loader window position: ' x ' ' y ' ' w ' ' h)

; make the loader window active
WinActivate('Loader')

; move the loader window to approximate center
WinMove(A_ScreenWidth / 4, A_ScreenHeight / 4,,,'Loader')

; check if account select is already open
account_select_already_open := PixelGetColor(1,1) = background_grey

if account_select_already_open {
    ; get the y position of the first account
    first_account_y := GetJagexSelectFirstAccountColor(window_center, 310, h) ; may need to adjust this 540 value
    if (first_account_y = -1) {
        MsgBox('Could not find an account in the list, color may be wrong.')
        ExitApp()
    }

    next_account_y := first_account_y
    if account_index = 1 {
        ; actually don't need to do anything here
    }
    else {
        loop_index := 2
        ; iterate through all the accounts basically
        Loop {
            next_account_y := GetNextAccount(window_center, next_account_y, h)
            if (next_account_y = -1) {
                MsgBox('Could not find next account')
                ExitApp()
            }
            ; click the account
            MouseGetPos(&current_mouse_x, &current_mouse_y)
            Click(window_center, next_account_y)

            ; MouseMove(current_mouse_x, current_mouse_y)

            ; wait until the account is selected (becomes first account color)
            ; while (PixelGetColor(window_center, next_account_y) != jagex_account_select_first_name_color) {
            ;     Sleep(50)
            ; }
            ; MsgBox('Account ' loop_index ' selected')
            if loop_index >= account_index {
                break
            }
            loop_index += 1
        }
    }

    ; click the OK button
    ok_button_y := GetOkButtonColor(window_center - 60, next_account_y, h)
    if (ok_button_y = -1) {
        MsgBox('Could not find OK button')
        ExitApp()
    }

    Click(window_center - 60, ok_button_y)
    ; MouseMove(window_center - 60, ok_button_y)
    ; wait until background is no longer grey
    while (PixelGetColor(1, 1) = background_grey) {
        Sleep(50)
    }
    MouseMove(current_mouse_x, current_mouse_y)
    ExitApp()
}

; check if start jagex account button already exists
start_jagex_account_y := GetJagexAccountColor(start_jagex_account_x_config, 0, h)
launch_accounts_already_open := start_jagex_account_y != -1
launch_window_y := 0

if launch_accounts_already_open {
    launch_window_y := start_jagex_account_y
}

list_of_colors := []
if !launch_accounts_already_open {
    ; get color in loop, stopping at end of window

    launch_window_y := GetNextBlue(start_jagex_account_x_config, launch_window_y, h)
    if (launch_window_y = -1) {
        MsgBox('Could not find launch accounts button')
        ExitApp()
    }

    ; print the y position of the launch accounts button
    ; MsgBox('Launch accounts button y position: ' launch_window_y)

    current_mouse_x := 0
    current_mouse_y := 0

    MouseGetPos(&current_mouse_x, &current_mouse_y)
    Click(start_jagex_account_x_config, launch_window_y + 2) ; this 310 value may need to be adjusted
    MouseMove(current_mouse_x, current_mouse_y)
}

skipBuffer := GetNextBlack(start_jagex_account_x_config, launch_window_y, h)
if (skipBuffer = -1) {
    MsgBox('Could not find buffer')
    ExitApp()
}

start_jagex_account_y := GetJagexAccountColor(start_jagex_account_x_config, launch_window_y, h)
if (start_jagex_account_y = -1) {
    MsgBox('Could not find start jagex account button')
    ExitApp()
}

MouseGetPos(&current_mouse_x, &current_mouse_y)
Click(310, start_jagex_account_y + 1)

; ImGui button presses seem to be delayed, so we need to wait for the button to be pressed
while (PixelGetColor(1, 1) != background_grey) {
    Sleep(50)
}

MouseMove(current_mouse_x, current_mouse_y)

; get the y position of the first account
first_account_y := GetJagexSelectFirstAccountColor(window_center, 310, h) ; may need to adjust this 540 value
if (first_account_y = -1) {
    MsgBox('Could not find an account in the list, color may be wrong.')
    ExitApp()
}

next_account_y := first_account_y
if account_index = 1 {
    ; actually don't need to do anything here
}
else {
    loop_index := 2
    ; iterate through all the accounts basically
    Loop {
        next_account_y := GetNextAccount(window_center, next_account_y, h)
        if (next_account_y = -1) {
            MsgBox('Could not find next account')
            ExitApp()
        }
        ; click the account
        MouseGetPos(&current_mouse_x, &current_mouse_y)
        Click(window_center, next_account_y)

        ; MouseMove(current_mouse_x, current_mouse_y)

        ; wait until the account is selected (becomes first account color)
        ; while (PixelGetColor(window_center, next_account_y) != jagex_account_select_first_name_color) {
        ;     Sleep(50)
        ; }
        ; MsgBox('Account ' loop_index ' selected')
        if loop_index >= account_index {
            break
        }
        loop_index += 1
    }
}

; click the OK button
ok_button_y := GetOkButtonColor(window_center - 60, next_account_y, h)
if (ok_button_y = -1) {
    MsgBox('Could not find OK button')
    ExitApp()
}

Click(window_center - 60, ok_button_y)
; MouseMove(window_center - 60, ok_button_y)
; wait until background is no longer grey
while (PixelGetColor(1, 1) = background_grey) {
    Sleep(50)
}
MouseMove(current_mouse_x, current_mouse_y)
ExitApp()


GetNextAccount(window_center, first_account_y, h)

GetNextBlue(X, currentY, maxHeight) {
    Loop {
        if (currentY > maxHeight) {
            return -1
        }
        color := PixelGetColor(X, currentY)
        if (color = '0x223D5D') {
            return currentY
        }
        currentY += 1
    }
}

GetNextBlack(X, currentY, maxHeight) {
    Loop {
        if (currentY >= maxHeight) {
            return -1
        }
        color := PixelGetColor(X, currentY)
        if (color = '0x131516') {
            return currentY
        }
        currentY += 1
        
    }
}

GetJagexAccountColor(X, currentY, maxHeight) {
    Loop {
        if (currentY >= maxHeight) {
            return -1
        }
        color := PixelGetColor(X, currentY)
        if (color = '0x264971') {
            return currentY
        }
        currentY += 2
    }
}

RecordColorsAtX(X, H) {
    list_of_colors := []
    Loop {
        if (currentY >= H) {
            return list_of_colors
        }
        color := PixelGetColor(X, currentY)
        list_of_colors.Push(color)
        currentY += 1
    }
    return list_of_colors
}

GetJagexSelectFirstAccountColor(X, currentY, maxHeight) {
    Loop {
        if (currentY >= maxHeight) {
            return -1
        }
        color := PixelGetColor(X, currentY)
        if (color = jagex_account_select_first_name_color || color = '0x254060') {
            return currentY
        }
        currentY += 1
    }
}

GetOkButtonColor(X, currentY, maxHeight) {
    Loop {
        if (currentY >= maxHeight) {
            return -1
        }
        color := PixelGetColor(X, currentY)
        if (color = ok_button_color) {
            return currentY
        }
        currentY += 1
    }
}

GetNextAccount(X, currentY, maxHeight) {
    currentColor := PixelGetColor(X, currentY)
    if currentColor = '0x181818' || currentColor = jagex_account_select_first_name_color || currentColor = '0x254060' {
        ; our current account color, we then need to iterate until we find a new color and add 2 to the y value
        Loop {
            if (currentY >= maxHeight) {
                return -1
            }
            color := PixelGetColor(X, currentY)
            if (color != currentColor) {
                return GetNextAccount(X, currentY, maxHeight)
            }
            currentY += 1
        }
    }
    else {
        ; continue until we find 0x181818 or jagex_account_select_first_name_color
        Loop {
            if (currentY >= maxHeight) {
                return -1
            }
            color := PixelGetColor(X, currentY)
            if (color = '0x181818' || color = jagex_account_select_first_name_color || color = '0x254060') {
                return currentY
            }
            currentY += 1
        }
    } 
}