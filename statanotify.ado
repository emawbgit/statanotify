*! version 1.0.5  07nov2023
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

    if "`c(os)'" == "Windows" {
        * Clean for PowerShell: replace double quotes with single, then escape single quotes
        local message = subinstr(`"`message'"', char(34), "'", .)
        local title   = subinstr(`"`title'"',   char(34), "'", .)
        local ps_msg   = subinstr("`message'", "'", "''", .)
        local ps_title = subinstr("`title'",   "'", "''", .)
        
        local ps_cmd "(New-Object -ComObject WScript.Shell).Popup('`ps_msg'', 10, '`ps_title'', 64)"
        winexec powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "`ps_cmd'"
        display as text "(statanotify: Windows notification triggered)"
    }
    else if "`c(os)'" == "MacOSX" {
        * Clean for AppleScript and Shell: 
        * 1. Replace double quotes with single quotes to avoid AppleScript string issues
        local mac_msg   = subinstr(`"`message'"', char(34), "'", .)
        local mac_title = subinstr(`"`title'"',   char(34), "'", .)
        
        * 2. Replace single quotes with a space to avoid breaking the shell command '...'
        local mac_msg   = subinstr("`mac_msg'", char(39), " ", .)
        local mac_title = subinstr("`mac_title'", char(39), " ", .)
        
        * Build the AppleScript command
        local as_cmd "display alert \"`mac_title'\" message \"`mac_msg'\" as informational buttons {\"OK\"} default button \"OK\" giving up after 10"
        
        * Execute via shell in background
        shell osascript -e '`as_cmd'' > /dev/null 2>&1 &
        display as text "(statanotify: macOS notification triggered)"
    }
    else {
        * Fallback for Linux or other systems
        window stopbox note "`message'"
    }

end
* Author: Emanuele Clemente
