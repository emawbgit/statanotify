*! version 1.0.1  07nov2023
program statanotify
    * Capture the return code of the previous command immediately
    local last_rc = _rc
    
    version 14.0
    
    syntax [, Message(string) Title(string)]

    * Set default message if not provided
    if `"`message'"' == "" {
        if `last_rc' == 0 {
            local message "Stata task completed successfully."
        }
        else {
            local message "Stata task failed with error code `last_rc'."
        }
    }
    
    * Set default title if not provided
    if `"`title'"' == "" {
        if `last_rc' == 0 {
            local title "Stata Success"
        }
        else {
            local title "Stata Failure"
        }
    }

    * Prepare for shell execution (escaping and cleaning)
    * Replace double quotes with single quotes to avoid breaking shell commands
    local message = subinstr(`"`message'"', char(34), "'", .)
    local title   = subinstr(`"`title'"',   char(34), "'", .)

    if "`c(os)'" == "Windows" {
        * Windows notification using PowerShell
        local ps_msg   = subinstr("`message'", "'", "''", .)
        local ps_title = subinstr("`title'",   "'", "''", .)
        
        * We use a more robust one-liner that ensures the icon is visible and disposed correctly
        local ps_cmd "Add-Type -AssemblyName System.Windows.Forms; "
        local ps_cmd "`ps_cmd' \$n = New-Object System.Windows.Forms.NotifyIcon; "
        local ps_cmd "`ps_cmd' \$n.Icon = [System.Drawing.SystemIcons]::Information; "
        local ps_cmd "`ps_cmd' \$n.Visible = \$true; "
        local ps_cmd "`ps_cmd' \$n.ShowBalloonTip(5000, '`ps_title'', '`ps_msg'', 1); "
        local ps_cmd "`ps_cmd' Start-Sleep 5; "
        local ps_cmd "`ps_cmd' \$n.Dispose()"
        
        * Run via winexec to keep it hidden and non-blocking
        winexec powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "& { `ps_cmd' }"
        display as text "(statanotify: Windows notification sent)"
    }
    else if "`c(os)'" == "MacOSX" {
        * macOS notification using osascript
        local mac_msg   = `"`message'"'
        local mac_title = `"`title'"'
        shell osascript -e "display notification \"`mac_msg'\" with title \"`mac_title'\""
        display as text "(statanotify: macOS notification sent)"
    }
    else {
        * Fallback for other systems
        window stopbox note "`message'"
    }

end
* Author: Emanuele Clemente
