playerClass = {}
playerClass.playerData = nil

RegisterNetEvent('skye_helper:public:updatePlayerData', function(val)
    playerClass.playerData = val
end)

function playerClass:getPlayerData(callback)
    if not callback then return playerClass.playerData end
    callback(playerData)
end