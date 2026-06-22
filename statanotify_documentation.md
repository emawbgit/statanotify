# statanotify: Desktop Notifications for Stata

**Author:** Emanuele Clemente  
**Platform Support:** Windows & macOS  
**Version:** 1.0.3  

---

## Overview

`statanotify` is a lightweight Stata command designed to bridge the gap between long-running data analysis tasks and user productivity. It provides instant desktop notifications (popups) on Windows and macOS, allowing researchers and data scientists to move away from their screens during heavy computations without losing track of when their tasks are completed.

## Key Features

- **Cross-Platform Compatibility:** Automatically detects your operating system and uses native notification systems (PowerShell Popup for Windows, AppleScript for macOS).
- **Status Awareness:** Captures the return code of the preceding Stata command. If a task fails, the notification automatically alerts you with the specific error code.
- **Customizable:** Easily set custom titles and messages to differentiate between multiple running scripts.
- **Non-Intrusive:** Designed to run in the background without interrupting the Stata flow or locking the interface.

---

## Installation

To install `statanotify` directly from GitHub, run the following command in Stata:

```stata
net install statanotify, from("https://raw.githubusercontent.com/emawbgit/statanotify/main") replace
```

---

## Usage

### 1. Basic Notification
Place the command at the end of a script or after a long estimation:
```stata
regress price mpg weight
statanotify
```
*Result: A notification showing "Stata task completed successfully" or an error message if the regression failed.*

### 2. Custom Message
Customize the alert for specific milestones:
```stata
statanotify, message("Big data merge complete!") title("Project X")
```

### 3. Handling Errors
Use `capture` to ensure you get notified even if the script crashes:
```stata
capture noisily do my_complex_analysis.do
statanotify
```

---

## Syntax

`statanotify [, message(string) title(string)]`

- `message(string)`: The text to be displayed in the popup body.
- `title(string)`: The text to be displayed in the popup header.

---

## Implementation Details

- **Windows:** Utilizes `WScript.Shell` via PowerShell to trigger a persistent popup.
- **macOS:** Utilizes the macOS Notification Center via `osascript`.
- **Legacy/Other:** Falls back to a standard Stata `stopbox` if the OS is not recognized.

---

## License & Author

Created by **Emanuele Clemente**.  
This package is free for academic and professional use.
