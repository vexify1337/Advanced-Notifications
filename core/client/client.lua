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
        position = position or 3,
        tag = tag or "knox",
        sound = sound or "sound2.mp3"
    }
    
    table.insert(active_notifications, notification_data)
    
    send_nui_message("show", notification_data)
    
    if notification_data.timeout and notification_data.timeout > 0 then
        SetTimeout(function()
            for i = #active_notifications, 1, -1 do
                if active_notifications[i].id == notification_id then
                    table.remove(active_notifications, i)
                    send_nui_message("hide", { id = notification_id })
                    break
                end
            end
        end, notification_data.timeout)
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
