local RegisteredCallbacks, RegisteredPublicCallbacks = {}, {}
callbackClass = {}

function callbackClass:TriggerCallback(Name, Cb, ...)
    local CbId = #RegisteredCallbacks + 1
    CbId = Name ..":" ..CbId
    RegisteredCallbacks[CbId] = Cb
    TriggerServerEvent("skye_helper:Server:Callbacks:TriggerCallback", CbId, Name, ...)
end

function callbackClass:CreateCallback(Name, Cb)
    RegisteredPublicCallbacks[Name] = Cb
end

-- // Events \\ --

-- Server Callbacks
RegisterNetEvent("skye_helper:Public:Callbacks:CallbackResponse")
AddEventHandler("skye_helper:Public:Callbacks:CallbackResponse", function(Id, Data)
    local CallbackEvent = RegisteredCallbacks[Id]
    if CallbackEvent then
        CallbackEvent(Data)
    end
end)

-- Public Callbacks
RegisterNetEvent("skye_helper:Public:Callbacks:PublicCallbackResponse")
AddEventHandler("skye_helper:Public:Callbacks:PublicCallbackResponse", function(Id, Data)
    local CallbackEvent = RegisteredPublicCallbacks[Id]
    if CallbackEvent then
        CallbackEvent(Data)
    end
end)

RegisterNetEvent("skye_helper:Public:Callbacks:TriggerPublicCallback")
AddEventHandler("skye_helper:Public:Callbacks:TriggerPublicCallback", function(Id, Name, ...)
    if not RegisteredPublicCallbacks[Name] then return end
    RegisteredPublicCallbacks[Name](function(Data)
        TriggerServerEvent("skye_helper:Server:Callbacks:PublicCallbackResponse", Id, Data)
    end, ...)
end)