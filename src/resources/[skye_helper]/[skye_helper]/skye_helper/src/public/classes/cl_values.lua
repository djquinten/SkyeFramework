valuesClass = {}

Citizen.CreateThread(function()
    while true do
        if valuesClass['PlayerId'] ~= PlayerId() then valuesClass['PlayerId'] = PlayerId() end
        if valuesClass['PlayerPedId'] ~= PlayerPedId() then valuesClass['PlayerPedId'] = PlayerPedId() end
        Citizen.Wait(1000 * 30) -- 30 seconds
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) -- 1 second
        -- Vehicle
        if GetVehiclePedIsIn(valuesClass['PlayerPedId']) ~= valuesClass['vehiclePlayerIsIn'] then
            valuesClass['vehiclePlayerIsIn'] = GetVehiclePedIsIn(valuesClass['PlayerPedId'])
            if valuesClass['vehiclePlayerIsIn'] ~= 0 then
                TriggerEvent('skye_helper:public:valuesClass:enterVehicle')

                DisplayRadar(true)
                exports['skye_userinterface']:SendUIMessage('vehiclehud', 'toggleHud', {
                    State = true,
                })
            else
                TriggerEvent('skye_helper:public:valuesClass:leaveVehicle')

                DisplayRadar(false)
                exports['skye_userinterface']:SendUIMessage('vehiclehud', 'toggleHud', {
                    State = false,
                })
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(250) -- 0.25 second
        -- Health
        if GetEntityHealth(valuesClass['PlayerPedId']) ~= valuesClass['GetEntityHealth'] then
            valuesClass['GetEntityHealth'] = GetEntityHealth(valuesClass['PlayerPedId'])
            TriggerEvent('skye_helper:public:baseEvents:changeHealth', valuesClass['GetEntityHealth'])

            exports['skye_userinterface']:SendUIMessage('playerhud', 'changeHealth', {
                Health = valuesClass['GetEntityHealth'] / 2,
            })
        end
    end
end)

RegisterNetEvent('skye_helper:public:valuesClass:enterVehicle', function()
    while valuesClass['vehiclePlayerIsIn'] ~= 0 do
        Citizen.Wait(5)
        if math.floor(GetEntitySpeed(valuesClass['vehiclePlayerIsIn']) * 3.6) ~= valuesClass['GetEntitySpeedVehicle'] then 
            valuesClass['GetEntitySpeedVehicle'] = math.floor(GetEntitySpeed(valuesClass['vehiclePlayerIsIn']) * 3.6) 
            TriggerEvent('skye_helper:public:baseEvents:changeSpeed', valuesClass['GetEntitySpeedVehicle'])

            exports['skye_userinterface']:SendUIMessage('vehiclehud', 'changeSpeed', {
                Speed = valuesClass['GetEntitySpeedVehicle'],
            })
        end
    end
end)

-- Request a update of a specific value
RegisterNetEvent('skye_helper:public:requestUpdate', function(value)
    valuesClass[value] = _G[value]()
end)