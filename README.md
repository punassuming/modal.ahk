# Modal.ahk - Unified Modal Vim Navigation for Windows

A comprehensive AutoHotkey v1.x solution that brings vim-like modal navigation to Windows 10/11 applications. This project combines and extends multiple vim navigation utilities into a unified, configurable system.

## Features

- **Modal Navigation**: Switch between Normal, Insert, and Visual modes like in vim
- **Configurable Per-Application**: Define custom keybindings for each application via INI files
- **Vim-like Keybindings**: Standard hjkl navigation, word/line/page movements, and more
- **Repeat Counts**: Use numbers before commands (e.g., `5j` moves down 5 lines)
- **Visual Mode**: Select text using vim motions
- **Per-Window Mode Memory**: Each window restores its last mode when refocused
- **Master Enable Toggle**: Temporarily suspend all modal interception without exiting
- **Easy Extensibility**: Add new applications by editing the configuration file

## Quick Start

1. Install [AutoHotkey v1.1](https://www.autohotkey.com/) (not v2.x)
2. Double-click `Modal.ahk` to run
3. Press **CapsLock** to toggle between Normal and Insert modes
   - Optional: Press **Ctrl+Shift+CapsLock** to globally enable/disable modal interception
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
- **Windows Explorer**: Enhanced file navigation with file operations, g-prefix shortcuts, and Windows 11 tab support
- **Microsoft Excel**: Cell navigation and editing
- **Microsoft Word**: Document navigation
- **Microsoft Outlook 2023 (Classic)**: Gmail-style email navigation and actions
- **Microsoft New Outlook (2024+)**: Gmail-style email navigation and actions
- **Google Chrome**: Vimium-style browser navigation and tab management
- **Microsoft Edge**: Vimium-style browser navigation and tab management
- **Mozilla Firefox**: Vimium-style browser navigation and tab management
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

### Windows Explorer Key Bindings

| Key | Action |
|-----|--------|
| `h` | Go to parent folder (Backspace) |
| `j` | Move down |
| `k` | Move up |
| `l` | Open file/folder (Enter) |
| `H` (Shift+h) | Back in history |
| `L` (Shift+l) | Forward in history |
| `J` (Shift+j) | Page down |
| `K` (Shift+k) | Page up |
| `r` | Rename (F2) |
| `d` | Delete to Recycle Bin |
| `D` (Shift+d) | Permanently delete |
| `y` | Copy file (Ctrl+C) |
| `p` | Paste file (Ctrl+V) |
| `m` | Cut/Move file (Ctrl+X) |
| `e` | File properties (Alt+Enter) |
| `o` | Focus address bar |
| `/` | Search |
| `n` | New folder (Ctrl+Shift+N) |
| `Ctrl+r` | Refresh |
| `gg` | Go to top of list |
| `G` | Go to bottom of list |
| `gh` | Go to user home folder |
| `gu` | Go up one level (Alt+Up) |
| `gd` | Go to Desktop |
| `gt` | Next tab (Windows 11) |
| `gT` | Previous tab (Windows 11) |

### Browser Key Bindings (Chrome, Edge, Firefox)

Vimium-inspired bindings for keyboard-driven browsing in Normal mode.
> **Note:** Link-hint mode (`f` key in Vimium) requires a browser extension and cannot be replicated by AutoHotkey alone. Install [Vimium](https://vimium.github.io/) alongside this script for full link-hint support.

> **Detection:** Chrome is detected by process name (`chrome.exe`), Edge by `msedge.exe`, and Firefox by window class (`MozillaWindowClass`).

**Scrolling:**
| Key | Action |
|-----|--------|
| `j` | Scroll down |
| `k` | Scroll up |
| `h` | Scroll left |
| `l` | Scroll right |
| `d` | Page down (Space) |
| `u` | Page up (Shift+Space) |
| `Ctrl+d` | Half-page down |
| `Ctrl+u` | Half-page up |
| `gg` | Scroll to top of page |
| `G` | Scroll to bottom of page |

**Navigation:**
| Key | Action |
|-----|--------|
| `H` (Shift+h) | Go back in history |
| `L` (Shift+l) | Go forward in history |
| `r` | Reload page |
| `R` (Shift+r) | Hard reload (bypass cache) |
| `/` | Find in page |
| `n` | Find next |
| `N` (Shift+n) | Find previous |
| `gi` | Focus first input field (Tab) |

**Tabs:**
| Key | Action |
|-----|--------|
| `t` | Open new tab |
| `x` | Close current tab |
| `X` (Shift+x) | Restore last closed tab |
| `J` (Shift+j) | Next tab |
| `K` (Shift+k) | Previous tab |
| `gt` | Next tab |
| `gT` | Previous tab |
| `g0` | First tab |

**URL / Clipboard:**
| Key | Action |
|-----|--------|
| `o` | Focus address bar (open URL in current tab) |
| `O` (Shift+o) | Open new tab |
| `yy` | Copy current page URL to clipboard |

**Zoom / View:**
| Key | Action |
|-----|--------|
| `I` (Shift+i) | Zoom in |
| `M` (Shift+m) | Zoom out |
| `Shift+0` | Reset zoom (Ctrl+0) |
| `U` (Shift+u) | View page source |

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
