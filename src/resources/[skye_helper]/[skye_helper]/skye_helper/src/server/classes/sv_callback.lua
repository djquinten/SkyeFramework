local RegisteredCallbacks, RegisteredPublicCallbacks = {}, {} -- Server
callbackClass = {}

function callbackClass:TriggerCallback(Name, Cb, ...)
    local CbId = #RegisteredPublicCallbacks + 1
    CbId = Name ..":" ..CbId
    RegisteredPublicCallbacks[CbId] = Cb
    local src = source
    TriggerClientEvent("skye_helper:Public:Callbacks:TriggerPublicCallback", src, CbId, Name, ...)
end

function callbackClass:CreateCallback(Name, Cb)
    RegisteredCallbacks[Name] = Cb
end

-- Client Callbacks
RegisterNetEvent("skye_helper:Server:Callbacks:PublicCallbackResponse")
AddEventHandler("skye_helper:Server:Callbacks:PublicCallbackResponse", function(Id, Data)
    local src = source
    TriggerClientEvent('skye_helper:Public:Callbacks:PublicCallbackResponse', src, Id, Data)
end)

-- Server callbacks
RegisterNetEvent("skye_helper:Server:Callbacks:TriggerCallback", function(Id, Name, ...)
    if not RegisteredCallbacks[Name] then return end
    local src = source
    RegisteredCallbacks[Name](src, function(Data)
        TriggerClientEvent("skye_helper:Public:Callbacks:CallbackResponse", src, Id, Data)
    end, ...)
end)