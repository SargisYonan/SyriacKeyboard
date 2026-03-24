on run
    set payloadRoot to my payload_root_path()
    if payloadRoot is missing value then return

    set installChoice to my choose_install_option()
    if installChoice is missing value then return

    set installLabel to item 1 of installChoice
    set scriptName to item 2 of installChoice
    set scriptPath to payloadRoot & "/" & scriptName

    if my file_exists(scriptPath) is false then
        display dialog "The installer payload is missing " & scriptName & "." buttons {"Close"} default button "Close" with icon stop
        return
    end if

    set introText to "This will install the " & installLabel & " keyboard and copy the bundled fonts into your user Library."
    set confirmButton to button returned of (display dialog introText buttons {"Cancel", "Install"} default button "Install" with title "Syriac Keyboard Installer")
    if confirmButton is not "Install" then return

    display dialog "Installing " & installLabel & ". This may take a few seconds." buttons {"OK"} default button "OK" giving up after 1 with title "Syriac Keyboard Installer"

    set installCommand to "cd " & quoted form of payloadRoot & " && SYRIAC_KEYBOARD_SKIP_REBOOT_PROMPT=1 ./" & quoted form of scriptName & " 2>&1"

    try
        set installOutput to do shell script installCommand
        set resultText to "Installation finished for " & installLabel & "." & return & return & "A reboot is recommended before using the keyboard."
        set resultText to resultText & my summarized_output(installOutput)

        set chosenButton to button returned of (display dialog resultText buttons {"Close", "Reboot Now"} default button "Reboot Now" with title "Syriac Keyboard Installer")
        if chosenButton is "Reboot Now" then
            tell application "System Events" to restart
        end if
    on error errText number errNum partial result partialOutput
        set failureText to "The installer failed with error " & errNum & "." & return & return
        set failureText to failureText & my summarized_output(partialOutput & return & errText)
        display dialog failureText buttons {"Close"} default button "Close" with icon stop
    end try
end run

on choose_install_option()
    set promptText to "Choose which keyboard layout to install."
    set buttonChoice to button returned of (display dialog promptText buttons {"Cancel", "Syriac Arabic", "Syriac QWERTY"} default button "Syriac QWERTY" with title "Syriac Keyboard Installer")

    if buttonChoice is "Syriac QWERTY" then
        return {"Syriac QWERTY", "setup.command"}
    end if

    if buttonChoice is "Syriac Arabic" then
        return {"Syriac Arabic", "setup_arabic_phonetic.command"}
    end if

    return missing value
end choose_install_option

on payload_root_path()
    set appPath to POSIX path of (path to me)
    set bundledPayloadRoot to appPath & "Contents/Resources/payload"

    if my file_exists(bundledPayloadRoot) then
        return bundledPayloadRoot
    end if

    display dialog "This app bundle is missing its installer payload. Rebuild the app with build_installer_app.command." buttons {"Close"} default button "Close" with icon stop
    return missing value
end payload_root_path

on file_exists(targetPath)
    try
        do shell script "test -e " & quoted form of targetPath
        return true
    on error
        return false
    end try
end file_exists

on summarized_output(rawOutput)
    if rawOutput is missing value or rawOutput is "" then
        return ""
    end if

    set maxLength to 1200
    set cleanOutput to rawOutput as text

    if (length of cleanOutput) > maxLength then
        set cleanOutput to "Recent installer output:" & return & return & "..." & text ((length of cleanOutput) - maxLength + 1) thru -1 of cleanOutput
    else
        set cleanOutput to "Installer output:" & return & return & cleanOutput
    end if

    return return & return & cleanOutput
end summarized_output
