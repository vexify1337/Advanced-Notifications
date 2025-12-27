# Advanced-Notifications
Advanced Notifications for esx/qbcore fivem, all open source and easily  configurable


# S6LA Notification System

Modern notification system for FiveM with support for multiple frameworks.

## Features

- Modern, sleek dark design with smooth animations
- Support for QBCore, ESX, and custom frameworks
- Configurable notification duration, colors, icons, and positions
- Sound support (sound.mp3 or sound2.mp3)
- Anti-spam protection
- Optimized for performance (resmon 0.00)

## Installation

1. Place the resource in your `resources` folder
2. Subscribe https://www.youtube.com/@VSScript
3. Add `ensure s6la_notifications` to your `server.cfg`
4. Configure the framework in `shared/config.lua`

## Configuration

Edit `shared/config.lua`:

```lua
Config.framework = "qb"  -- Options: "qb", "qbcore", "esx", "custom", "none"
```

### Framework Options

- **"qb" or "qbcore"**: QBCore framework
- **"esx"**: ESX framework
- **"custom"**: Custom framework (requires custom functions in config)
- **"none"**: No framework validation (works with any setup)

### Custom Framework Setup

If using `Config.framework = "custom"`, add these functions to `shared/config.lua`:

```lua
Config.custom_get_player = function(player_id)
    -- Return your player object or nil
    return YourFramework:GetPlayer(player_id)
end

Config.custom_initialize = function()
    -- Optional initialization function
    return true
end
```

## Usage

### Client-Side

```lua
exports['s6la_notifications']:Notify(title, content, timeout, type, position, tag, sound)
```

### Server-Side

```lua
-- Notify specific player
exports['s6la_notifications']:NotifyPlayer(player_id, title, content, timeout, type, position, tag, sound)

-- Notify all players
exports['s6la_notifications']:NotifyAll(title, content, timeout, type, position, tag, sound)

-- Hide notification
exports['s6la_notifications']:HideNotification(player_id, notification_id)

-- Hide all notifications
exports['s6la_notifications']:HideAllNotifications(player_id)
```

### Event-Based

```lua
-- Client
TriggerEvent("s6la:notify", title, content, timeout, type, position, tag, sound)

-- Server to Client
TriggerClientEvent("s6la:notify", player_id, title, content, timeout, type, position, tag, sound)
```

## Parameters

- **title** (string): Notification title
- **content** (string): Notification content/description
- **timeout** (number): Duration in milliseconds (0 = no auto-hide)
- **type** (number): 0 = Error, 1 = Success, 2 = Warning, 3 = Information
- **position** (number): 0 = Middle, 1 = Bottom, 2 = Left, 3 = Right, 4 = Top
- **tag** (string): Optional tag (not displayed visually)
- **sound** (string): "sound.mp3" or "sound2.mp3" (default: "sound2.mp3")

## Examples

```lua
-- Success notification
exports['s6la_notifications']:Notify("Success!", "Operation completed", 5000, 1, 3, "server", "sound2.mp3")

-- Error notification
exports['s6la_notifications']:Notify("Error!", "Something went wrong", 5000, 0, 3)

-- Server-side notification
exports['s6la_notifications']:NotifyPlayer(source, "Welcome!", "Enjoy your stay", 5000, 3, 3)
```

## Framework Override Installation

# Installation Guide - Framework Override

This guide will help you replace the default notification systems in QBCore and ESX with S6LA Notifications.

## QBCore Installation

1. Navigate to `qb-core/client/functions.lua`
2. Find the `QBCore.Functions.Notify` function
3. Replace it with the code from `qb-core_override.lua`

**OR** add this to your `qb-core/client/functions.lua`:

```lua
function QBCore.Functions.Notify(text, texttype, length, icon)
    local s6la_type = 3
    
    if texttype == 'error' then
        s6la_type = 0
    elseif texttype == 'success' then
        s6la_type = 1
    elseif texttype == 'warning' or texttype == 'warn' then
        s6la_type = 2
    elseif texttype == 'info' or texttype == 'information' or texttype == 'primary' then
        s6la_type = 3
    end
    
    local timeout = length or 5000
    local content = text
    
    if type(text) == 'table' then
        content = text.text or text.caption or 'Notification'
    end
    
    TriggerEvent("s6la:notify", "", content, timeout, s6la_type, 3, 'qb-core')
end
```

## ESX Installation

1. Navigate to `es_extended/client/functions.lua` or wherever `ESX.ShowNotification` is defined
2. Find the `ESX.ShowNotification` and `ESX.ShowAdvancedNotification` functions
3. Replace them with the code from `esx_override.lua`

**OR** add this to your ESX client file:

```lua
ESX.ShowNotification = function(msg, type, length)
    local s6la_type = 3
    
    if type == 'error' then
        s6la_type = 0
    elseif type == 'success' then
        s6la_type = 1
    elseif type == 'warning' or type == 'warn' then
        s6la_type = 2
    elseif type == 'info' or type == 'information' or type == 'primary' then
        s6la_type = 3
    end
    
    local timeout = length or 5000
    local content = msg
    
    if type(msg) == 'table' then
        content = msg.text or msg.caption or 'Notification'
    end
    
    TriggerEvent("s6la:notify", "", content, timeout, s6la_type, 3, 'esx')
end

ESX.ShowAdvancedNotification = function(title, subject, msg, icon, iconType, length)
    local s6la_type = 3
    
    if iconType == 1 then
        s6la_type = 0
    elseif iconType == 2 then
        s6la_type = 1
    elseif iconType == 3 then
        s6la_type = 2
    else
        s6la_type = 3
    end
    
    local timeout = length or 5000
    local content = msg or subject or 'Notification'
    
    TriggerEvent("s6la:notify", title or "", content, timeout, s6la_type, 3, 'esx')
end
```

## Type Mapping

### QBCore
- `'error'` → Type 0 (Error)
- `'success'` → Type 1 (Success)
- `'warning'` or `'warn'` → Type 2 (Warning)
- `'info'`, `'information'`, or `'primary'` → Type 3 (Information)

### ESX
- `'error'` → Type 0 (Error)
- `'success'` → Type 1 (Success)
- `'warning'` or `'warn'` → Type 2 (Warning)
- `'info'`, `'information'`, or `'primary'` → Type 3 (Information)
- `iconType` 1 → Type 0 (Error)
- `iconType` 2 → Type 1 (Success)
- `iconType` 3 → Type 2 (Warning)
- Default → Type 3 (Information)

## Notes

- Position is set to `3` (Right) by default
- Tag is set to framework name (`'qb-core'` or `'esx'`)
- Default timeout is 5000ms if not provided
- All existing framework notification calls will now use S6LA Notifications
