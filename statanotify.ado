*! version 1.0.3  07nov2023
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
    local message = subinstr(`"`message'"', char(34), "'", .)
    local title   = subinstr(`"`title'"',   char(34), "'", .)

    if "`c(os)'" == "Windows" {
        * Windows notification using a robust PowerShell script
        * We use the WScript.Shell Popup method as it is more reliable across Windows versions
        * and doesn't depend on the system tray icon settings as much as BalloonTips do.
        
        local ps_msg   = subinstr("`message'", "'", "''", .)
        local ps_title = subinstr("`title'",   "'", "''", .)
        
        * Popup parameters: message, seconds_to_wait (0=infinite), title, type (64=Info icon)
        local ps_cmd "(New-Object -ComObject WScript.Shell).Popup('`ps_msg'', 10, '`ps_title'', 64)"
        
        * Use winexec to run hidden and non-blocking
        winexec powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "`ps_cmd'"
        display as text "(statanotify: Windows notification triggered)"
    }
    else if "`c(os)'" == "MacOSX" {
        * macOS notification using osascript
        local mac_msg   = `"`message'"'
        local mac_title = `"`title'"'
        shell osascript -e "display notification \"`mac_msg'\" with title \"`mac_title'\""
        display as text "(statanotify: macOS notification triggered)"
    }
    else {
        * Fallback for other systems
        window stopbox note "`message'"
    }

end
* Author: Emanuele Clemente
