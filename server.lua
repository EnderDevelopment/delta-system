local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
    print('DeltaSystem database is ready')
end)

ESX.RegisterServerCallback('delta:getValue', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        MySQL.Async.fetchScalar('SELECT value FROM delta_system WHERE player_id = @player_id', {
            ['@player_id'] = xPlayer.identifier
        }, function(result)
            if result then
                cb(result)
            else
                MySQL.Async.execute('INSERT INTO delta_system (player_id, value) VALUES (@player_id, @value)', {
                    ['@player_id'] = xPlayer.identifier,
                    ['@value'] = Config.Settings.DefaultValue
                }, function()
                    cb(Config.Settings.DefaultValue)
                end)
            end
        end)
    else
        cb(nil)
    end
end)

RegisterNetEvent('delta:requestUpdate')
AddEventHandler('delta:requestUpdate', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        MySQL.Async.fetchScalar('SELECT value FROM delta_system WHERE player_id = @player_id', {
            ['@player_id'] = xPlayer.identifier
        }, function(result)
            if result then
                local newValue = result + 10
                MySQL.Async.execute('UPDATE delta_system SET value = @value WHERE player_id = @player_id', {
                    ['@player_id'] = xPlayer.identifier,
                    ['@value'] = newValue
                }, function()
                    TriggerClientEvent('delta:updateValue', source, newValue)
                end)
            end
        end)
    end
end)