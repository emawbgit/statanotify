*! version 1.0.0  07nov2023
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
        * Escape single quotes for PowerShell strings
        local ps_msg   = subinstr("`message'", "'", "''", .)
        local ps_title = subinstr("`title'",   "'", "''", .)
        
        local ps_cmd "[Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null; "
        local ps_cmd "`ps_cmd' [Reflection.Assembly]::LoadWithPartialName('System.Drawing') | Out-Null; "
        local ps_cmd "`ps_cmd' \$objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon; "
        local ps_cmd "`ps_cmd' \$objNotifyIcon.Icon = [System.Drawing.SystemIcons]::Information; "
        local ps_cmd "`ps_cmd' \$objNotifyIcon.BalloonTipIcon = 'Info'; "
        local ps_cmd "`ps_cmd' \$objNotifyIcon.BalloonTipText = '`ps_msg''; "
        local ps_cmd "`ps_cmd' \$objNotifyIcon.BalloonTipTitle = '`ps_title''; "
        local ps_cmd "`ps_cmd' \$objNotifyIcon.Visible = \$True; "
        local ps_cmd "`ps_cmd' \$objNotifyIcon.ShowBalloonTip(10000); "
        local ps_cmd "`ps_cmd' Start-Sleep -s 1; "
        local ps_cmd "`ps_cmd' \$objNotifyIcon.Dispose()"
        
        winexec powershell -noprofile -windowstyle hidden -command "`ps_cmd'"
    }
    else if "`c(os)'" == "MacOSX" {
        * macOS notification using osascript
        * Use compound double quotes for AppleScript string literals
        local mac_msg   = `"`message'"'
        local mac_title = `"`title'"'
        shell osascript -e "display notification \"`mac_msg'\" with title \"`mac_title'\""
    }
    else {
        display as text "statanotify: Notification not supported on `c(os)'."
        display as text "Message: `message'"
    }

end
