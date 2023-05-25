local classesLoaded = false

local function classesRequest(classes, callback)
    local doneLoading, attempts, resource, checkedClasses, attempts = false, {}, GetInvokingResource() or GetCurrentResourceName(), {}, {}
    if not classes or type(classes) ~= 'table' then return print("[^1ERROR^7] [^4" .. resource .. "^7] Classes is not a table or isn't set") end
    print("[^1INFO^7] [^4" .. resource .. "^7] Requesting " .. #classes .. " classes start loading...")
    Citizen.CreateThread(function()
        while not doneLoading do
            for k, v in pairs(classes) do
                local class = ("%sClass"):format(v)
                attempts[v] = (attempts[v] or 0) + 1
                if not _G[class] then
                    if attempts[v] > 50 then
                        print("[^1ERROR^7] [^4" .. resource .. "^7] " .. v .. "Class was not found")
                        callback(false)
                        return
                    end
                else
                    checkedClasses[#checkedClasses + 1] = v
                end
            end
            if #checkedClasses == #classes then
                doneLoading = true
                callback(true)
            end
            Wait(100)
        end
    end)
end
exports('classesRequest', classesRequest)

local function classesLoad(name)
    local class = ("%sClass"):format(name)
    if not _G[class] then
        print("[^1ERROR^7] [^4" .. name .. "^7] Class not found")
        return nil
    end
    return _G[class]
end
exports('classesLoad', classesLoad)

local function printSkyeLogo()
    print("^7")
    print("^4==================================================================================")
    print("^4      _                   _                _                                  _    ")
    print("^4     | |                 | |              | |                                | |   ")
    print("^4  ___| | ___   _  ___  __| | _____   _____| | ___  _ __  _ __ ___   ___ _ __ | |_  ")
    print("^4 / __| |/ / | | |/ _ \\/ _` |/ _ \\ \\ / / _ \\ |/ _ \\| '_ \\| '_ ` _ \\ / _ \\ '_ \\| __| ")
    print("^4 \\__ \\   <| |_| |  __/ (_| |  __/\\ V /  __/ | (_) | |_) | | | | | |  __/ | | | |_  ")
    print("^4 |___/_|\\_\\\\__, |\\___|\\__,_|\\___| \\_/ \\___|_|\\___/| .__/|_| |_| |_|\\___|_| |_|\\__| ")
    print("^4           |___/                                  |_|                              ")
    print("^4============== ^9Skye Roleplay Framework^7 by ^5@dj_quinten^7, ^5@F1nn^7 ^4==============")
    print("^7")
end

Citizen.CreateThread(function()
    printSkyeLogo()

    TriggerEvent('skye_helper:public:classesLoaded')
    classesLoaded = true

    updatePresence()
    SetDiscordButtons()
end)

AddEventHandler('onResourceStart', function(resource)
    if not classesLoaded then return end
    TriggerEvent('skye_helper:public:classesLoaded')
end)

RegisterNetEvent('skye_helper:public:log', function(method, name, message)
    print("[^1" .. method .. "^7] [^4" .. name .. "^7] " .. message)
end)