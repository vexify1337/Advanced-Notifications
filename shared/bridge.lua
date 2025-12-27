FrameworkBridge = {}

function FrameworkBridge:GetFramework()
    return Config.framework or "none"
end

function FrameworkBridge:GetPlayer(player_id)
    local framework = self:GetFramework()
    
    if framework == "qb" or framework == "qbcore" then
        local QBCore = exports['qb-core']:GetCoreObject()
        return QBCore.Functions.GetPlayer(player_id)
    elseif framework == "esx" then
        local ESX = exports['es_extended']:getSharedObject()
        return ESX.GetPlayerFromId(player_id)
    elseif framework == "custom" then
        if Config.custom_get_player then
            return Config.custom_get_player(player_id)
        end
    end
    return nil
end

function FrameworkBridge:PlayerExists(player_id)
    local player = self:GetPlayer(player_id)
    return player ~= nil
end

function FrameworkBridge:Initialize()
    local framework = self:GetFramework()
    
    if framework == "qb" or framework == "qbcore" then
        return true
    elseif framework == "esx" then
        return true
    elseif framework == "custom" then
        if Config.custom_initialize then
            return Config.custom_initialize()
        end
        return true
    elseif framework == "none" then
        return true
    end
    return false
end

