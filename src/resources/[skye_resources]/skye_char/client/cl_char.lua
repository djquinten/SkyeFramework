local SpawnedPeds, callbackClass = {}, nil

AddEventHandler('skye_helper:public:classesLoaded', function()
    exports['skye_helper']:classesRequest({
        'callback',
    }, function(success)
        if not success then return end

        callbackClass = exports['skye_helper']:classesLoad('callback')
    end)
end)

CreateThread(function()
	while true do
		Wait(0)
		if NetworkIsSessionStarted() then
			TriggerEvent('skye_char:public:start:multicharacter', 'true')
			return
		end
	end
end)

RegisterNetEvent('skye_char:public:start:multicharacter', function(Toggle)
    Wait(500)
    if Toggle == 'true' then
        Citizen.Wait(2500)
        CreatedCharacter = false

        ToggleCharCam(true)

        SendNUIMessage({
            action = 'StartMultichar',
        })

        SetEntityCoords(PlayerPedId(), Config.Multichar['PlayerPedLoc']['X'], Config.Multichar['PlayerPedLoc']['Y'], Config.Multichar['PlayerPedLoc']['Z'], true, false, false, true)
        SetEntityInvincible(PlayerPedId(), true)
        SetEntityAlpha(PlayerPedId(), 0)
        FreezeEntityPosition(PlayerPedId(), true)

        DoScreenFadeIn(10)

        ShutdownLoadingScreenNui()
        ShutdownLoadingScreen()
        Citizen.Wait(1)
        ShutdownLoadingScreenNui()
        ShutdownLoadingScreen()
    elseif Toggle == 'false' then
        ToggleCharCam(false)
        SetEntityInvincible(PlayerPedId(), false)
        SetEntityAlpha(PlayerPedId(), 255)
        FreezeEntityPosition(PlayerPedId(), false)
        SetNuiFocus(false, false)
    end
end)

RegisterNetEvent('Skye/MultiChar/Client/GetPlayerSkinData', function(Callback, Cid)
    local SkinPromise = promise:new()

    callbackClass:TriggerCallback('Skye/Characters/Callback/GetUserSkins', function(InsertSkins)
        SkinPromise:resolve(InsertSkins)
    end, Cid)

    local InsertSkins = Citizen.Await(SkinPromise)

    Wait(300)

    Callback(InsertSkins)
end)

RegisterNetEvent('Base/Multicharacter/Client/Create/Char', function()
    SetNuiFocus(false, false)

    SetEntityInvincible(PlayerPedId(), false)
    SetEntityAlpha(PlayerPedId(), 255)
    FreezeEntityPosition(PlayerPedId(), false)
    SetEntityCoords(PlayerPedId(), Config.Multichar['CreationLoc']['X'], Config.Multichar['CreationLoc']['Y'], Config.Multichar['CreationLoc']['Z'], true, false, false, true)
    SetEntityHeading(PlayerPedId(), Config.Multichar['CreationLoc']['H'])

    DoScreenFadeIn(100)
    TriggerEvent('skye_clothing:client:CreateFirstCharacter')
end)

ToggleCharCam = function(Toggle)
    if Toggle then
        MulticharCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(MulticharCam, Config.Multichar['CamLoc']['X'], Config.Multichar['CamLoc']['Y'], Config.Multichar['CamLoc']['Z'] - 1.0)
        SetCamRot(MulticharCam, -10.0, 0.0, 176.0)
        SetCamFov(MulticharCam, 35.0)
        RenderScriptCams(true, false, 1, true, true)
    else
        SetTimecycleModifier('default')
        SetCamActive(MulticharCam, false)
        DestroyCam(MulticharCam, true)
        RenderScriptCams(false, false, 1, false, false)

        MulticharCam = nil
    end
end

RegisterNUICallback('LoadChars', function()
    Wait(500)

    local CharPromise = promise:new()

    callbackClass:TriggerCallback('Skye/Characters/Callback/GetUserCharacters', function(InsertCharacters)
        CharPromise:resolve(InsertCharacters)
    end)

    local InsertCharacters = Citizen.Await(CharPromise)
    local Info = {}
    local CharInfo = {}
    local CitizenId = nil

    if #InsertCharacters > 0 then
        
        for Index = 1, (#InsertCharacters), 1 do
            CharInfo = json.decode(InsertCharacters[Index].charinfo)
            CitizenId = InsertCharacters[Index].citizenid

            local Skins = {}

            local SkinPromise = promise:new()

            TriggerEvent('Skye/MultiChar/Client/GetPlayerSkinData', function(InsertSkins) 
                SkinPromise:resolve(InsertSkins)
            end, CitizenId)

            local InsertSkins = Citizen.Await(SkinPromise)

            local SkinModel = nil

            if #InsertSkins > 0 then
                SkinModel = tonumber(InsertSkins[1]['model'])
            else
                SkinModel = GetHashKey("mp_m_freemode_01")
            end

            RequestModel(SkinModel)

            while not HasModelLoaded(SkinModel) do
                Wait(0)
                RequestModel(GetHashKey("mp_m_freemode_01"))
            end

            CharacterPed = CreatePed(2, SkinModel, Config.Multichar['PedLocs'][Index]['X'], Config.Multichar['PedLocs'][Index]['Y'], Config.Multichar['PedLocs'][Index]['Z'] - 1.0, Config.Multichar['PedLocs'][Index]['H'], false, true)
            SetPedComponentVariation(CharacterPed, 0, 0, 0, 2)
            FreezeEntityPosition(CharacterPed, false)
            SetEntityInvincible(CharacterPed, true)
            PlaceObjectOnGroundProperly(CharacterPed)
            SetBlockingOfNonTemporaryEvents(CharacterPed, true)

            if #InsertSkins > 0 then
                local SkinData = json.decode(InsertSkins[1]['skin'])

                TriggerEvent('skye_clothing:client:loadPlayerClothing', SkinData, CharacterPed)    
            end

            local InsertTable = {CharacterPed}

            SpawnedPeds[#SpawnedPeds + 1] = CharacterPed

            local Bool, Left, Top = GetScreenCoordFromWorldCoord(Config.Multichar['PedLocs'][Index]['X'], Config.Multichar['PedLocs'][Index]['Y'], Config.Multichar['PedLocs'][Index]['Z'] - 1.0)
            
            local FirstName, Lastname = nil

            for CharInfoKey, CharInfoValue in pairs({CharInfo}) do 
                if CharInfoValue['firstname'] then
                    FirstName = CharInfoValue['firstname']
                    LastName = CharInfoValue['lastname']
                end
            end
            local InsertTable = {['ScreenCoords'] = {['Left'] = (Left * 100), ['Top'] = (Top * 100)}, ['Character'] = {['FirstName'] = FirstName, ['LastName'] = LastName, ['CitizenId'] = CitizenId}}

            Info[#Info + 1] = InsertTable

            SetNuiFocus(true, true)

            SendNUIMessage({
                action = 'SetupMultichar',
                Info = Info,
            })
        end
    else
        SetNuiFocus(true, true)

        SendNUIMessage({
            action = 'NoChars',
        })
    end
end)

RegisterNUICallback('LoginSelectedChar', function(data)
    local CitizenId = data.CitizenId

    TriggerEvent('skye_char:public:start:multicharacter', 'false')

    TriggerServerEvent('Skye/Characters/Server/LoginSelectedChar', CitizenId)

    for Key, Value in pairs(SpawnedPeds) do
        SetEntityAsMissionEntity(Value[1], true, true)
        DeleteEntity(Value[1])
    end

    SpawnedPeds = {}
end)

RegisterNUICallback('CreateChar', function(data)
    if data.Gender == "man" then
        data.Gender = 0
    elseif data.Gender == "vrouw" then
        data.Gender = 1
    end
    DoScreenFadeOut(100)

    TriggerEvent('skye_char:public:start:multicharacter', 'false')
    TriggerServerEvent('Base/Multicharacter/Server/Create/Char', data, false)

    for Key, Value in pairs(SpawnedPeds) do
        SetEntityAsMissionEntity(Value[1], true, true)
        DeleteEntity(Value[1])
    end

    SpawnedPeds = {}

    CreatedCharacter = true

    SetTimeout(500, function() 
        TriggerServerEvent('Base/Multicharacter/Server/Create/Char', nil, true)
    end)
end)

RegisterNUICallback('DeleteChar', function(data) 
    TriggerEvent('Base/MultiChar/Client/Start/Multicharacter', 'false')

    Wait(500)
    TriggerServerEvent('Base/Multicharacter/Server/Delete/Character', data.CitizenId)

    for Key, Value in pairs(SpawnedPeds) do
        SetEntityAsMissionEntity(Value[1], true, true)
        DeleteEntity(Value[1])
    end

    SpawnedPeds = {}
end)