{smcl}
{* *! version 1.0.0  07nov2023}{...}
{vieweralsosee "" "--"}{...}
{viewerjumpto "Syntax" "statanotify##syntax"}{...}
{viewerjumpto "Description" "statanotify##description"}{...}
{viewerjumpto "Options" "statanotify##options"}{...}
{viewerjumpto "Examples" "statanotify##examples"}{...}
{title:Title}

{p2colset 5 22 24 2}{...}
{p2col :{hi:statanotify} {em:--} Send desktop notifications when a Stata task is complete}{...}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:statanotify}
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt :{opt m:essage(string)}}custom message for the notification{p_end}
{synopt :{opt t:itle(string)}}custom title for the notification{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:statanotify} sends a desktop notification to your machine. It is designed to be placed at the end of a long-running do-file or after a specific command to alert you when the task is finished.

{pstd}
The command automatically detects whether you are on Windows or macOS. On Windows, it uses PowerShell to trigger a tray notification. On macOS, it uses AppleScript ({cmd:osascript}) to trigger a system notification.

{pstd}
If no message is provided, {cmd:statanotify} will automatically report whether the previous command succeeded (return code 0) or failed.


{marker options}{...}
{title:Options}

{phang}
{opt message(string)} specifies the text to be displayed in the notification body. If omitted, it defaults to "Stata task completed successfully" or "Stata task failed with error code #".

{phang}
{opt title(string)} specifies the title of the notification. If omitted, it defaults to "Stata Success" or "Stata Failure".


{marker examples}{...}
{title:Examples}

{pstd}Basic usage at the end of a do-file:{p_end}
{phang2}{cmd:. long_running_command}{p_end}
{phang2}{cmd:. statanotify}{p_end}

{pstd}Using with a custom message:{p_end}
{phang2}{cmd:. statanotify, message("The big estimation is done!") title("Finished")}{p_end}

{pstd}Using with {cmd:capture} to notify even if an error occurs:{p_end}
{phang2}{cmd:. capture noisily do my_long_analysis.do}{p_end}
{phang2}{cmd:. statanotify}{p_end}


{title:Author}

{pstd}
Emanuele Clemente
{p_end}
