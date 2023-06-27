local databaseClass, playerClass, callbackClass = nil, nil, nil

AddEventHandler('skye_helper:server:classesLoaded', function()
    exports['skye_helper']:classesRequest({
        'database',
        'player',
        'callback',
    }, function(success)
        if not success then return end

        databaseClass = exports['skye_helper']:classesLoad('database')
        playerClass = exports['skye_helper']:classesLoad('player')
        callbackClass = exports['skye_helper']:classesLoad('callback')

        callbackClass:CreateCallback('skye_clothing:server:getOutfits', function(source, cb)
            local src = source
            local Player = playerClass:getPlayerBySource(src)
            local anusVal = {}
        
            databaseClass:Execute("SELECT * FROM `characters_outfits` WHERE `citizenid` = '"..Player.citizenid.."'", false, function(result)
                if result[1] then
                    for k, v in pairs(result) do
                        result[k].skin = json.decode(result[k].skin)
                        anusVal[k] = v
                    end
                    cb(anusVal)
                end
                cb(anusVal)
            end)
        end)
    end)
end)

-- Code

-- SkyeFramework.Commands.Add("skin", "Ooohja toch", {}, false, function(source, args)
-- 	TriggerClientEvent("skye_clothing:client:openMenu", source)
-- end, "admin")

RegisterServerEvent("skye_clothing:saveSkin")
AddEventHandler('skye_clothing:saveSkin', function(model, skin)
    local Player = playerClass:getPlayerBySource(source)
    if model and skin then 
        databaseClass:Execute("DELETE FROM `characters_skins` WHERE `citizenid` = '"..Player.citizenid.."'", false, function()
            databaseClass:Insert("INSERT INTO `characters_skins` (`citizenid`, `model`, `skin`) VALUES ('"..Player.citizenid.."', '"..model.."', '"..skin.."')", false)
        end)
    end
end)

RegisterServerEvent("skye_clothing:loadPlayerSkin")
AddEventHandler('skye_clothing:loadPlayerSkin', function()
    local src = source
    local Player = playerClass:getPlayerBySource(src)
    databaseClass:Execute("SELECT * FROM `characters_skins` WHERE `citizenid` = '"..Player.citizenid.."'", false, function(result)
        if result[1] then
            TriggerClientEvent("skye_clothing:loadSkin", src, false, result[1].model, result[1].skin)
        else
            TriggerClientEvent("skye_clothing:loadSkin", src, true)
        end
    end)
end)

RegisterServerEvent("skye_clothing:saveOutfit")
AddEventHandler("skye_clothing:saveOutfit", function(outfitName, model, skinData)
    local src = source
    local Player = playerClass:getPlayerBySource(src)
    if model and skinData then
        local outfitId = "outfit-"..math.random(1, 10).."-"..math.random(1111, 9999)
        databaseClass:Insert("INSERT INTO `characters_outfits` (`citizenid`, `outfitname`, `model`, `skin`, `outfitId`) VALUES ('"..Player.citizenid.."', '"..outfitName.."', '"..model.."', '"..json.encode(skinData).."', '"..outfitId.."')", false, function()
            databaseClass:Execute("SELECT * FROM `characters_outfits` WHERE `citizenid` = '"..Player.citizenid.."'", false, function(result)
                if result[1] then
                    TriggerClientEvent('skye_clothing:client:reloadOutfits', src, result)
                else
                    TriggerClientEvent('skye_clothing:client:reloadOutfits', src, nil)
                end
            end)
        end)
    end
end)

RegisterServerEvent("skye_clothing:server:removeOutfit")
AddEventHandler("skye_clothing:server:removeOutfit", function(outfitName, outfitId)
    local src = source
    local Player = playerClass:getPlayerBySource(src)

    databaseClass:Execute("DELETE FROM `characters_outfits` WHERE `citizenid` = '"..Player.citizenid.."' AND `outfitname` = '"..outfitName.."' AND `outfitId` = '"..outfitId.."'", false, function()
        databaseClass:Execute("SELECT * FROM `characters_outfits` WHERE `citizenid` = '"..Player.citizenid.."'", false, function(result)
            if result[1] then
                TriggerClientEvent('skye_clothing:client:reloadOutfits', src, result)
            else
                TriggerClientEvent('skye_clothing:client:reloadOutfits', src, nil)
            end
        end)
    end)
end)