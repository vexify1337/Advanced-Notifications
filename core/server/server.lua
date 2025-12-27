FrameworkBridge:Initialize()

RegisterNetEvent("s6la:notify", function(title, content, timeout, type, position, tag, sound)
    local source = source
    TriggerClientEvent("s6la:notify", source, title, content, timeout, type, position, tag, sound)
end)

exports("NotifyPlayer", function(player_id, title, content, timeout, type, position, tag, sound)
    if FrameworkBridge:GetFramework() ~= "none" then
        if not FrameworkBridge:PlayerExists(player_id) then
            return false
        end
    end
    
    TriggerClientEvent("s6la:notify", player_id, title, content, timeout, type, position, tag, sound)
    return true
end)

exports("NotifyAll", function(title, content, timeout, type, position, tag, sound)
    TriggerClientEvent("s6la:notify", -1, title, content, timeout, type, position, tag, sound)
    return true
end)

exports("HideNotification", function(player_id, notification_id)
    if FrameworkBridge:GetFramework() ~= "none" then
        if not FrameworkBridge:PlayerExists(player_id) then
            return false
        end
    end
    
    TriggerClientEvent("s6la:notify:hide", player_id, notification_id)
    return true
end)

exports("HideAllNotifications", function(player_id)
    if FrameworkBridge:GetFramework() ~= "none" then
        if not FrameworkBridge:PlayerExists(player_id) then
            return false
        end
    end
    
    TriggerClientEvent("s6la:notify:hide", player_id)
    return true
end)
