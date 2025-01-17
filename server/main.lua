if GetResourceState('es_extended') == 'started' then
    ESX = exports['es_extended']:getSharedObject()
    Config.Framework = "esx"
elseif GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
    Config.Framework = "qb"
else
    print("^1ERROR: Neither ESX nor QBCore detected!^0")
end

RegisterNetEvent('gast_pedmenu:requestPermission', function()
    local src = source
    local steamID = GetPlayerIdentifier(src, 0)
    local licenseID = GetPlayerIdentifier(src, 1)
    local isAllowed = false

    for _, identifier in pairs(Config.AllowedPlayers) do
        if identifier == steamID or identifier == licenseID then
            isAllowed = true
            break
        end
    end

    TriggerClientEvent('gast_pedmenu:checkPermission', src, isAllowed)
end)
