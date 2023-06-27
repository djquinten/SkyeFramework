local databaseClass, playerClass, callbackClass, databaseClass = nil, nil, nil, nil

AddEventHandler('skye_helper:server:classesLoaded', function()
    exports['skye_helper']:classesRequest({
        'database',
        'player',
        'callback',
        'database',
        'logger',
    }, function(success)
        if not success then return end

        databaseClass = exports['skye_helper']:classesLoad('database')
        playerClass = exports['skye_helper']:classesLoad('player')
        callbackClass = exports['skye_helper']:classesLoad('callback')
        databaseClass = exports['skye_helper']:classesLoad('database')
        loggerClass = exports['skye_helper']:classesLoad('logger')

        callbackClass:CreateCallback('Skye/Characters/Callback/GetUserCharacters', function(source, cb)
            local src = source
            local license = playerClass:getIdentifierByType(src, 'license')
        
            databaseClass:Execute('SELECT * FROM server_players WHERE license = @license', true, {['@license'] = license}, function(result)
                cb(result)
            end)
        end)
        
        callbackClass:CreateCallback('Skye/Characters/Callback/GetUserSkins', function(source, cb, CitizenId)
            print(CitizenId)
            local result = databaseClass:Execute('SELECT * FROM characters_skins WHERE citizenid = "' .. CitizenId .. '"', false)
            Wait(400)
            print(json.encode(result))
            cb(result)
        end)
    end)
end)

-- Base.Commands.Add("logout", "Logout of Character (Admin Only)", {}, false, function(source)
--     Base.Player.Logout(source)
--     TriggerClientEvent('skye_char:public:start:multicharacter', source, 'true')
-- end, "admin")

-- Base.Commands.Add("load", "Lekker inloggen.", {}, false, function(source, args)
--     TriggerClientEvent('SkyeFramework:Client:OnPlayerLoaded', source)
-- end, "admin")

RegisterNetEvent('Skye/Characters/Server/LoginSelectedChar', function(CitizenId)
    local src = source
    if playerClass:login(src, CitizenId) then
        -- Base.Commands.Refresh(src)

        local Player = playerClass:getPlayerBySource(src)

        while not Player do
            Player = playerClass:getPlayerBySource(src)
            Citizen.Wait(100)
        end

        print(
            "**".. GetPlayerName(src) .. "** ("..CitizenId.." | "..src..") loaded.."
        )
        TriggerClientEvent('hx-spawn_new:Client:OpenSpawnSelector', src, Player.userdata)
        loggerClass:discord("joinleave", "Loaded", "**".. GetPlayerName(src) .. "** ("..CitizenId.." | "..src..") loaded..")
	end
end)

RegisterServerEvent('Base/Multicharacter/Server/Create/Char')
AddEventHandler('Base/Multicharacter/Server/Create/Char', function(data, OnReset) 
    local src = source
    if not OnReset then
        if src ~= prevsrc then
            prevsrc = src
            local newData = {firstname = data.FirstName, lastname = data.LastName, birthdate = data.BirthDate, gender = data.Gender, nationality = 'United states of america'}

            if playerClass:login(src, false, newData) then
                -- Base.Commands.Refresh(src)
                GiveStarterItems(src)

                TriggerClientEvent('Base/Multicharacter/Client/Create/Char', src)
            end
        end
    else
        prevsrc = nil
    end
end)

RegisterServerEvent('Base/Multicharacter/Server/Delete/Character')
AddEventHandler('Base/Multicharacter/Server/Delete/Character', function(citizenid)
    local src = source
    TriggerClientEvent('skye_char:public:start:multicharacter', src, 'true')

    local Player = playerClass:getPlayerBySource(src)
    playerClass:DeleteCharacter(src, citizenid)
end)

function GiveStarterItems(source)
    -- for k, v in pairs(Base.Shared.StarterItems) do
    --     local info = {}

    --     if v.item == "id_card" then
    --         local Player = playerClass:getPlayerBySource(source)
    --         info.citizenid = Player.PlayerData.citizenid
    --         info.firstname = Player.PlayerData.charinfo.firstname
    --         info.lastname = Player.PlayerData.charinfo.lastname
    --         info.birthdate = Player.PlayerData.charinfo.birthdate
    --         info.gender = Player.PlayerData.charinfo.gender
    --         info.nationality = Player.PlayerData.charinfo.nationality
    --     elseif v.item == "driver_license" then
    --         local Player = playerClass:getPlayerBySource(source)
    --         info.firstname = Player.PlayerData.charinfo.firstname
    --         info.lastname = Player.PlayerData.charinfo.lastname
    --         info.birthdate = Player.PlayerData.charinfo.birthdate
    --         info.type = "A1-A2-A | AM-B | C1-C-CE"
    --     end

    --     local Player = playerClass:getPlayerBySource(source)
    --     Player.Functions.AddItem(v.item, v.amount, false, info)
    -- end
end