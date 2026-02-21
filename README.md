# Modal.ahk - Unified Modal Vim Navigation for Windows

A comprehensive AutoHotkey v1.x solution that brings vim-like modal navigation to Windows 10/11 applications. This project combines and extends multiple vim navigation utilities into a unified, configurable system.

## Features

- **Modal Navigation**: Switch between Normal, Insert, and Visual modes like in vim
- **Configurable Per-Application**: Define custom keybindings for each application via INI files
- **Vim-like Keybindings**: Standard hjkl navigation, word/line/page movements, and more
- **Repeat Counts**: Use numbers before commands (e.g., `5j` moves down 5 lines)
- **Visual Mode**: Select text using vim motions
- **Easy Extensibility**: Add new applications by editing the configuration file

## Quick Start

1. Install [AutoHotkey v1.1](https://www.autohotkey.com/) (not v2.x)
2. Double-click `Modal.ahk` to run
3. Press **CapsLock** to toggle between Normal and Insert modes
4. In Normal mode, use vim keys for navigation:
   - `h`, `j`, `k`, `l` - Left, Down, Up, Right
   - `w`, `b` - Next word, Previous word
   - `0`, `$` - Start of line, End of line
   - `gg`, `G` - Start of document, End of document
   - And many more...

## Modes

### Normal Mode
In Normal mode, keys are mapped to navigation and editing commands rather than inserting text.

**Navigation:**
| Key | Action |
|-----|--------|
| `h` | Move left |
| `j` | Move down |
| `k` | Move up |
| `l` | Move right |
| `w` | Move to next word |
| `b` | Move to previous word |
| `0` | Move to start of line |
| `$` | Move to end of line |
| `gg` | Move to start of document |
| `G` | Move to end of document |
| `Ctrl+d` | Half page down |
| `Ctrl+u` | Half page up |

**Editing:**
| Key | Action |
|-----|--------|
| `x` | Delete character |
| `dd` | Delete line |
| `yy` | Yank (copy) line |
| `p` | Paste after cursor |
| `P` | Paste before cursor |
| `u` | Undo |
| `Ctrl+r` | Redo |
| `cc` | Change line |
| `C` | Change to end of line |

**Mode Switching:**
| Key | Action |
|-----|--------|
| `i` | Insert at cursor |
| `I` | Insert at line start |
| `a` | Insert after cursor |
| `A` | Insert at line end |
| `o` | New line below |
| `O` | New line above |
| `v` | Visual mode |
| `V` | Visual line mode |

### Insert Mode
Normal text input. Press **Escape** or **CapsLock** to return to Normal mode.

### Visual Mode
Select text using navigation keys. Press `y` to yank, `d` to delete, or `Escape` to cancel.

## Configuration

### Config File Location
`config/settings.ini`

### Global Settings
```ini
[Global]
ToggleKey=CapsLock
ActivationMethod=toggle
ShowNotifications=true
NotificationTimeout=600
EnableRepeatCount=true
MaxRepeatCount=500
```

### Adding a New Application

1. Open `config/settings.ini`
2. Add a new section:

```ini
[App_MyApp]
Enabled=true
WindowClass=MyAppClass
WindowTitle=
ControlPattern=

; Navigation
nav_left={Left}
nav_down={Down}
nav_up={Up}
nav_right={Right}

; Add more bindings as needed
```

3. Use Window Spy (included with AutoHotkey) to find the correct window class

### Key Notation

| Symbol | Meaning |
|--------|---------|
| `^` | Ctrl |
| `!` | Alt |
| `+` | Shift |
| `#` | Win |
| `{Enter}` | Enter key |
| `{Left}` | Arrow left |
| `{Tab}` | Tab key |

### Pre-configured Applications

- **xplorer2**: Full file manager support with tree navigation, tabs, bookmarks
- **Windows Explorer**: Basic file navigation
- **Microsoft Excel**: Cell navigation and editing
- **Microsoft Word**: Document navigation
- **Microsoft Outlook 2023 (Classic)**: Gmail-style email navigation and actions
- **Microsoft New Outlook (2024+)**: Gmail-style email navigation and actions
- **Text Editors**: Generic config for Notepad, VS Code, etc.

### Outlook Key Bindings (Gmail-style)

Both Outlook 2023 (Classic) and New Outlook support the following Gmail-inspired key bindings in Normal mode:

| Key | Action |
|-----|--------|
| `j` | Next email (move down) |
| `k` | Previous email (move up) |
| `o` / `l` | Open email |
| `h` | Back / close reading pane (Escape) |
| `c` | Compose new email |
| `r` | Reply |
| `a` | Reply All |
| `f` | Forward |
| `e` | Archive |
| `x` | Delete |
| `u` | Mark as unread |
| `s` | Flag / Star |
| `/` | Search |
| `n` | Next message in thread |
| `p` | Previous message in thread |
| `Ctrl+d` | Half page down (general Normal mode) |
| `Ctrl+u` | Half page up (general Normal mode) |
| `gg` | Go to top of list |
| `G` | Go to bottom of list |
| `gi` | Go to Inbox |

> **Detection:** Outlook 2023 (Classic) is detected by its window class (`rctrl_renwnd32`).
> New Outlook (2024+) is detected by its process name (`olk.exe`).

## Project Structure

```
modal.ahk/
├── Modal.ahk              # Main entry point
├── config/
│   └── settings.ini       # Configuration file
├── lib/
│   ├── Modal_Core.ahk     # Core functionality
│   ├── Modal_Navigation.ahk  # Navigation functions
│   └── Modal_Actions.ahk  # Editing actions
├── icons/
│   ├── normal.ico         # Normal mode icon
│   └── insert.ico         # Insert mode icon
├── applications/          # Optional app-specific helpers
├── Kommand/              # Optional window management utility
├── EmacsEverywhere.ahk   # Optional Emacs-style keybindings
└── README.md
```

## Extending the System

### Adding New Keybindings

Edit `Modal.ahk` and add hotkeys under the appropriate `#If` block:

```autohotkey
#If Modal_IsNormalMode()
; Your custom binding
; For example, double-tap 'f' to find:
f::
    Input, char, L1 T1
    if (char = "f") {
        Modal_Search()
    }
return
#If
```

### Creating App-Specific Hotkeys

Add a new `#If` block for your application:

```autohotkey
#If Modal_IsNormalMode() && Modal_IsAppActive("MyApp")
; App-specific bindings here
h::SendInput, {Left}
j::SendInput, {Down}
#If
```

### Using the Core API

The library provides these useful functions:

```autohotkey
; Mode management
Modal_IsNormalMode()      ; Check if in normal mode
Modal_IsInsertMode()      ; Check if in insert mode
Modal_EnterNormalMode()   ; Switch to normal mode
Modal_EnterInsertMode()   ; Switch to insert mode

; Navigation
Modal_NavLeft()           ; Move left (with repeat count)
Modal_NavDown()           ; Move down (with repeat count)
Modal_SendKey("{keys}")   ; Send keys with optional repeat

; Configuration
Modal_GetBinding("action")    ; Get binding for action
Modal_IsAppActive("AppName")  ; Check if app is active
```

## Tips

1. **Use Window Spy**: Run Window Spy (included with AutoHotkey) to find window classes and control names for your applications.

2. **Test in Notepad**: Start by testing your bindings in Notepad before moving to other apps.

3. **Backup Config**: Keep a backup of your `settings.ini` before making major changes.

4. **Ctrl+CapsLock**: Use this to toggle actual CapsLock when needed.

5. **Reload Config**: Right-click the tray icon and select "Reload Config" after editing settings.ini.

## Troubleshooting

**Script not working in an app?**
- Check if the window class is correct using Window Spy
- Make sure the app section is enabled (`Enabled=true`)
- Try running AutoHotkey as administrator

**Keys not working as expected?**
- Some apps may intercept keys before AutoHotkey
- Try using `SendInput` instead of `Send` in custom bindings
- Check for conflicting hotkeys

**CapsLock stuck?**
- Press `Ctrl+CapsLock` to toggle actual CapsLock
- Reload the script

## Legacy Scripts

Legacy modal vim scripts have been consolidated into `Modal.ahk`.
Optional companion utilities such as `EmacsEverywhere.ahk` and `Kommand/` remain available.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add your changes
4. Test thoroughly
5. Submit a pull request

## License

MIT License - See LICENSE file for details.

## Credits

Based on work by:
- Rich Alesi (original Modal_Vim.ahk)
- Achal Dave (modifications)
- Andrej Mitrovic (AHK_L port)
- Jongbin Jung (vim-nav)
- Kylir Horton (Kommand)
- David Tchepak (EmacsEverywhere)
- And many other contributors
