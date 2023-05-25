configClass = {}

function configClass:getPublic()
    local Config = nil
    callbackClass:TriggerCallback('skye_helper:Server:getConfig', function(Result)
        Config = Result
    end)
    while not Config do
        Citizen.Wait(0)
    end
    return Config
end