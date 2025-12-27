local active_notifications = {}
local notification_counter = 0
local spam_protection = {}
local spam_cooldown = 1000
local cleanup_timer = 0

local function send_nui_message(action, data)
    SendNUIMessage({
        type = action,
        data = data
    })
end

local function cleanup_spam_protection()
    local current_time = GetGameTimer()
    local to_remove = {}
    
    for k, v in pairs(spam_protection) do
        if current_time - v > spam_cooldown * 10 then
            table.insert(to_remove, k)
        end
    end
    
    for _, k in ipairs(to_remove) do
        spam_protection[k] = nil
    end
end

local function is_spam(title, content)
    local key = title .. "|" .. content
    local current_time = GetGameTimer()
    
    if spam_protection[key] then
        if current_time - spam_protection[key] < spam_cooldown then
            return true
        end
    end
    
    spam_protection[key] = current_time
    
    if current_time - cleanup_timer > 5000 then
        cleanup_spam_protection()
        cleanup_timer = current_time
    end
    
    return false
end

local function get_default_position()
    if Config.position == "top" then return 4
    elseif Config.position == "top-right" then return 3
    elseif Config.position == "top-left" then return 2
    elseif Config.position == "bottom" then return 1
    elseif Config.position == "bottom-right" then return 1
    elseif Config.position == "bottom-left" then return 1
    elseif Config.position == "center" then return 0
    else return 4
    end
end

local function show_notification(title, content, timeout, type, position, tag, sound)
    if is_spam(title, content) then
        return nil
    end
    
    notification_counter = notification_counter + 1
    local notification_id = GetGameTimer() + notification_counter
    
    local notification_data = {
        id = notification_id,
        type = type or 3,
        title = title or "Notification",
        content = content or "",
        timeout = timeout or 5000,
        position = position or get_default_position(),
        tag = tag or "knox",
        sound = sound or "sound2.mp3"
    }
    
    table.insert(active_notifications, notification_data)
    
    send_nui_message("show", notification_data)
    
    if notification_data.timeout and notification_data.timeout > 0 then
        SetTimeout(notification_data.timeout, function()
            for i = #active_notifications, 1, -1 do
                if active_notifications[i].id == notification_id then
                    table.remove(active_notifications, i)
                    send_nui_message("hide", { id = notification_id })
                    break
                end
            end
        end)
    end
    
    return notification_id
end

RegisterNetEvent("s6la:notify", function(title, content, timeout, type, position, tag, sound)
    show_notification(title, content, timeout, type, position, tag, sound)
end)

RegisterNetEvent("s6la:notify:client", function(data)
    show_notification(data.title, data.content, data.timeout, data.type, data.position, data.tag, data.sound)
end)

RegisterNetEvent("s6la:notify:hide", function(notification_id)
    if notification_id then
        for i = #active_notifications, 1, -1 do
            if active_notifications[i].id == notification_id then
                table.remove(active_notifications, i)
                send_nui_message("hide", { id = notification_id })
                break
            end
        end
    else
        active_notifications = {}
        send_nui_message("hideAll", {})
    end
end)

exports("Notify", function(title, content, timeout, type, position, tag, sound)
    return show_notification(title, content, timeout, type, position, tag, sound)
end)

exports("HideNotification", function(notification_id)
    TriggerEvent("s6la:notify:hide", notification_id)
end)

exports("HideAllNotifications", function()
    TriggerEvent("s6la:notify:hide")
end)

RegisterCommand("notifyerror", function()
    TriggerEvent("s6la:notify", "Error", "This is an error notification", 5000, 0, nil, "test", "sound2.mp3")
end, false)

RegisterCommand("notifysuccess", function()
    TriggerEvent("s6la:notify", "Success", "This is a success notification", 5000, 1, nil, "test", "sound2.mp3")
end, false)

RegisterCommand("notifywarning", function()
    TriggerEvent("s6la:notify", "Warning", "This is a warning notification", 5000, 2, nil, "test", "sound2.mp3")
end, false)

RegisterCommand("notifyinfo", function()
    TriggerEvent("s6la:notify", "Information", "This is an information notification", 5000, 3, nil, "test", "sound2.mp3")
end, false)

RegisterCommand("notifytop", function()
    TriggerEvent("s6la:notify", "Top", "Notification at top position", 5000, 3, 4, "test", "sound2.mp3")
end, false)

RegisterCommand("notifybottom", function()
    TriggerEvent("s6la:notify", "Bottom", "Notification at bottom position", 5000, 3, 1, "test", "sound2.mp3")
end, false)

RegisterCommand("notifyleft", function()
    TriggerEvent("s6la:notify", "Left", "Notification at left position", 5000, 3, 2, "test", "sound2.mp3")
end, false)

RegisterCommand("notifyright", function()
    TriggerEvent("s6la:notify", "Right", "Notification at right position", 5000, 3, 3, "test", "sound2.mp3")
end, false)

RegisterCommand("notifymiddle", function()
    TriggerEvent("s6la:notify", "Middle", "Notification at middle position", 5000, 3, 0, "test", "sound2.mp3")
end, false)

RegisterCommand("testall", function()
    TriggerEvent("s6la:notify", "Error", "Error notification test", 5000, 0, 4, "test", "sound2.mp3")
    Wait(200)
    TriggerEvent("s6la:notify", "Success", "Success notification test", 5000, 1, 4, "test", "sound2.mp3")
    Wait(200)
    TriggerEvent("s6la:notify", "Warning", "Warning notification test", 5000, 2, 4, "test", "sound2.mp3")
    Wait(200)
    TriggerEvent("s6la:notify", "Information", "Information notification test", 5000, 3, 4, "test", "sound2.mp3")
    Wait(200)
    TriggerEvent("s6la:notify", "Top", "Top position test", 5000, 3, 4, "test", "sound2.mp3")
    Wait(200)
    TriggerEvent("s6la:notify", "Bottom", "Bottom position test", 5000, 3, 1, "test", "sound2.mp3")
    Wait(200)
    TriggerEvent("s6la:notify", "Left", "Left position test", 5000, 3, 2, "test", "sound2.mp3")
    Wait(200)
    TriggerEvent("s6la:notify", "Right", "Right position test", 5000, 3, 3, "test", "sound2.mp3")
    Wait(200)
    TriggerEvent("s6la:notify", "Middle", "Middle position test", 5000, 3, 0, "test", "sound2.mp3")
end, false)
