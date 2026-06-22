# statanotify

A Stata command to send desktop notifications on Windows and macOS.

## Installation

You can install `statanotify` directly from GitHub:

```stata
net install statanotify, from("https://raw.githubusercontent.com/username/statanotify/master")
```

*(Note: Replace `username` with your GitHub username after pushing the code.)*

## Usage

Simply add `statanotify` at the end of your script or after a specific command.

```stata
* Basic usage
regress y x
statanotify

* Custom message
statanotify, message("Estimation complete") title("Stata")
```

## Features

- **Automatic OS Detection:** Works on Windows (via PowerShell) and macOS (via AppleScript).
- **Error Detection:** If a previous command failed, the notification will automatically indicate failure and the return code (unless a custom message is provided).
- **Standalone:** No external Stata dependencies required.

## Options

- `message(string)`: Custom text for the notification.
- `title(string)`: Custom title for the notification.

## Author

Created by Jules.
