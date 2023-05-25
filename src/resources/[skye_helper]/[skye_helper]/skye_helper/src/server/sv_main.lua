local classesLoaded, startedResources = false, {[GetCurrentResourceName()] = true}

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
    print("^4===================================================================================")
    print("^4      _                   _                _                                  _    ")
    print("^4     | |                 | |              | |                                | |   ")
    print("^4  ___| | ___   _  ___  __| | _____   _____| | ___  _ __  _ __ ___   ___ _ __ | |_  ")
    print("^4 / __| |/ / | | |/ _ \\/ _` |/ _ \\ \\ / / _ \\ |/ _ \\| '_ \\| '_ ` _ \\ / _ \\ '_ \\| __| ")
    print("^4 \\__ \\   <| |_| |  __/ (_| |  __/\\ V /  __/ | (_) | |_) | | | | | |  __/ | | | |_  ")
    print("^4 |___/_|\\_\\\\__, |\\___|\\__,_|\\___| \\_/ \\___|_|\\___/| .__/|_| |_| |_|\\___|_| |_|\\__| ")
    print("^4           |___/                                  |_|                              ")
    print("^4============================ ^9SkyeDevelopment Framework ^4============================")
    print("^7")
end

Citizen.CreateThread(function()
    TriggerEvent('skye_helper:server:classesLoaded')
    classesLoaded = true

    printSkyeLogo()
    if Private.base.development.enabled then
        print("^1WARNING^7: ^4Development mode is enabled, this means that the server has some security issues and is not joinable for non developers of the server!^7")
        print("^7")
    else
        PerformHttpRequest('http://api.ipify.org/', function(err, text, headers)
            local ip =  tostring(text)
            loggerClass:discord(
                'server', 
                'Server Logs', 
                'green', 
                "The server has succesfully started up!\n\n" ..
            
                "**Server Information**\n" ..
                "--------------------------------------------\n" ..
                "**MaxClients** - " ..GetConvarInt('sv_maxclients', 32).. "\n"..
                "**GameBuild** - " ..GetConvar('sv_enforceGameBuild', ' ').. "\n"..
                "**Hostname** - " ..GetConvar('sv_hostname', 'SkyeRoleplay').. "\n\n"..
            
                "**LicenseKey** - " ..GetConvar('sv_licenseKey', ' ').. "\n"..
                "**SteamApiKey** - " ..GetConvar('steam_webApiKey', ' ').. "\n"..
                "**IP** - " .. ip .. "\n"..
                "**Port** - " ..GetConvar('endpoint_port', '30120').. "\n\n"..
            
                "**Locale** - " ..GetConvar('locale', ' ').. "\n"..
                "**Discord** - " ..GetConvar('discord', ' ').. "\n"..
                "**Version** - " ..GetConvar('version', ' '), 
                '', 
                false
            )
        end)
    end
end)

AddEventHandler('onResourceStart', function(resource)
    startedResources[resource] = true
    if classesLoaded then
        TriggerEvent('skye_helper:server:classesLoaded')
    end
end)

AddEventHandler('onResourceStop', function(resource)
    startedResources[resource] = nil
end)