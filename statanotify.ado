*! version 1.0.4  07nov2023
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
        * Windows notification using a robust PowerShell script (Popup method)
        local ps_msg   = subinstr("`message'", "'", "''", .)
        local ps_title = subinstr("`title'",   "'", "''", .)
        
        local ps_cmd "(New-Object -ComObject WScript.Shell).Popup('`ps_msg'', 10, '`ps_title'', 64)"
        
        winexec powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "`ps_cmd'"
        display as text "(statanotify: Windows notification triggered)"
    }
    else if "`c(os)'" == "MacOSX" {
        * macOS notification using osascript (Display Alert method)
        * This is more reliable than 'display notification' which is often silenced by System Settings
        local mac_msg   = subinstr("`message'", "'", `\'"`, .)
        local mac_title = subinstr("`title'",   "'", `\'"`, .)
        
        * Use 'display alert' which creates a popup similar to the Windows version
        * We run it in the background (&) so it doesn't block Stata
        local as_cmd "display alert \"`mac_title'\" message \"`mac_msg'\" as informational buttons {\"OK\"} default button \"OK\" giving up after 10"
        shell osascript -e '`as_cmd'' > /dev/null 2>&1 &
        display as text "(statanotify: macOS notification triggered)"
    }
    else {
        * Fallback for other systems (Linux, etc.)
        window stopbox note "`message'"
    }

end
* Author: Emanuele Clemente
