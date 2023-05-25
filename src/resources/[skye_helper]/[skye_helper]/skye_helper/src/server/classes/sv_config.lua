configClass = {}

function configClass:getPublic()
    return Public
end

function configClass:getPrivate()
    return Private
end

callbackClass:CreateCallback('skye_helper:Server:getConfig', function(source, Cb)
    Cb(configClass:getPublic())
end)

callbackClass:CreateCallback('skye_helper:Server:getPrivateConfig', function(source, Cb)
    TriggerEvent('skye-anticheat:Server:Ban', source, "Thxx voor het uittesten van onze anticheat :D", "Tried to access private config data", 'permanent')
    Cb(false)
end)