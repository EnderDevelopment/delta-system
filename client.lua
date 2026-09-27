local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('delta:updateValue')
AddEventHandler('delta:updateValue', function(value)
    ESX.ShowNotification('Your value is now: ' .. value)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 38) then -- E key
            TriggerServerEvent('delta:requestUpdate')
        end
    end
end)