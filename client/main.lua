if GetResourceState('es_extended') == 'started' then
    ESX = exports['es_extended']:getSharedObject()
    Config.Framework = "esx"
elseif GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
    Config.Framework = "qb"
else
    print("^1ERROR: Neither ESX nor QBCore detected!^0")
end

function ShowNotification(message, type)
    local notifType = type or "info"

    if Config.NotificationType == "ox_lib" then
        if GetResourceState('ox_lib') == 'started' then
            lib.notify({title = _U("menu_title"), description = message, type = notifType})
        else
            print("^1ERROR: Notifications are not installed or started!^0")
        end
    elseif Config.NotificationType == "ps-ui" then
        if GetResourceState('ps-ui') == 'started' then
            exports['ps-ui']:Notify(message, notifType)
        else
            print("^1ERROR: Notifications are not installed or started!^0")
        end
    elseif Config.NotificationType == "esx" and Config.Framework  == 'esx' then
        if GetResourceState('esx_notify') == 'started' then
            ESX.ShowNotification(message)
        else
            print("^1ERROR: Notifications are not installed or started!^0")
        end
    elseif Config.NotificationType == "qb" and Config.Framework  == 'qb' then
        QBCore.Functions.Notify(message, notifType)
    elseif Config.NotificationType == "gast_lib" then
        if GetResourceState('gast_lib') == 'started' then
            exports['gast_lib']:Notify(message, notifType)
        else
            print("^1ERROR: Notifications are not installed or started!^0")
        end
    else
        print("[PED MENU] Notification failed!")
    end
end

function OpenPedMenu()
    if Config.MenuType == "ps-ui" then
        if GetResourceState('ps-ui') == 'started' then
            local menuOptions = {}
            for _, ped in pairs(Config.Peds) do
                table.insert(menuOptions, {
                    id = ped.model,
                    header = ped.label,
                    text = _U("menu_title"),
                    icon = "fa-solid fa-user",
                    color = "primary",
                    event = "gast_pedmenu:setPed",
                    args = {ped.model}
                })
            end
            exports['ps-ui']:CreateMenu(menuOptions)
        else
            ShowNotification(_U("installation_error"), "error")
        end
    elseif Config.MenuType == "gast_lib" then
        if GetResourceState('gast_lib') == 'started' then
            local menuOptions = {}
            for _, ped in pairs(Config.Peds) do
                table.insert(menuOptions, {
                    id = ped.model,
                    header = ped.label,
                    text = _U("menu_title"),
                    icon = "fa-solid fa-user",
                    color = "primary",
                    event = "gast_pedmenu:setPed",
                    args = {ped.model}
                })
            end
            exports['gast_lib']:CreateMenu(menuOptions)
        else
            ShowNotification(_U("installation_error"), "error")
        end
    elseif Config.MenuType == "esx-context" and Config.Framework == 'esx' then
        if GetResourceState('esx_context') == 'started' then
            local menuElements = {
                {
                    title = _U("menu_title"),
                    event = "", 
                    disabled = true, 
                    args = nil
                }
            }

            for _, ped in pairs(Config.Peds) do
                table.insert(menuElements, {
                    title = ped.label,
                    description = _U("menu_title"),
                    event = "gast_pedmenu:setPed",
                    args = ped.model
                })
            end
        
            ESX.OpenContext('right', menuElements, function(_, element)
                if element.args then
                    TriggerEvent('gast_pedmenu:setPed', element.args)
                end
            end)    
        else
            ShowNotification(_U("installation_error"), "error")
        end
    elseif Config.MenuType == "esx-default" and Config.Framework == 'esx' then
        if GetResourceState('esx_menu_default') == 'started' then
            local elements = {}
            for _, ped in pairs(Config.Peds) do
                table.insert(elements, {label = ped.label, value = ped.model})
            end
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gast_pedmenu', {
                title = _U("menu_title"),
                align = 'top-left',
                elements = elements
            }, function(data, menu)
                TriggerEvent('gast_pedmenu:setPed', data.current.value)
                menu.close()
            end, function(data, menu)
                menu.close()
            end)
        else
            ShowNotification(_U("installation_error"), "error")
        end
    elseif Config.MenuType == "ox_lib" then
        if GetResourceState('ox_lib') == 'started' then
            local options = {}
            for _, ped in pairs(Config.Peds) do
                table.insert(options, {
                    title = ped.label,
                    description = _U("menu_title"),
                    icon = "fa-solid fa-user",
                    args = { model = ped.model },
                    onSelect = function(args)
                        TriggerEvent('gast_pedmenu:setPed', args.model)
                    end
                })
            end

            lib.registerContext({
                id = 'gast_pedmenu',
                title = _U("menu_title"),
                options = options
            })

            lib.showContext('gast_pedmenu')
        else
            ShowNotification(_U("installation_error"), "error")
        end
    elseif Config.MenuType == "qb-menu" and Config.Framework == 'qb' then
        if GetResourceState('ox_lib') == 'started' then
            local menuOptions = {}
            for _, ped in pairs(Config.Peds) do
                table.insert(menuOptions, {
                    header = ped.label,
                    txt = _U("menu_title"),
                    params = {
                        event = "gast_pedmenu:setPed",
                        args = ped.model
                    }
                })
            end
            table.insert(menuOptions, {header = "Zavrieť", params = {event = ""}})
            exports['qb-menu']:openMenu(menuOptions)
        else
            ShowNotification(_U("installation_error"), "error")
        end
    else
        ShowNotification(_U("unsupported_menu"), "error")
    end
end

RegisterNetEvent('gast_pedmenu:setPed', function(model)
    if allowed then
        local pedModel = GetHashKey(model)
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do Wait(100) end
        SetPlayerModel(PlayerId(), pedModel)
        SetModelAsNoLongerNeeded(pedModel)
        ShowNotification(_U("ped_chosen"), "success")
    else
        ShowNotification(_U("no_permission"), "error")
    end
end)

RegisterNetEvent('gast_pedmenu:checkPermission', function(isAllowed)
    allowed = isAllowed
    if allowed then
        OpenPedMenu()
    else
        ShowNotification(_U("no_permission"), "error")
    end
end)

RegisterCommand(Config.Command, function()
    if Config.Framework == "qb" or "esx" then
        TriggerServerEvent('gast_pedmenu:requestPermission')
    else
        ShowNotification(_U("unsupported_framework"), "error")
    end
end)
