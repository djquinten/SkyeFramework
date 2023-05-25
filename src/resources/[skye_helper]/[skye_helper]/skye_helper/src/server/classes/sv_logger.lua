loggerClass = {}

colors = {
    ["default"] = 5793266,
    ["blue"] = 25087,
    ["green"] = 762640,
    ["white"] = 16777215,
    ["black"] = 0,
    ["orange"] = 16743168,
    ["lightgreen"] = 65309,
    ["yellow"] = 15335168,
    ["turqois"] = 62207,
    ["pink"] = 16711900,
    ["red"] = 16711680,
}

function loggerClass:discord(name, title, color, message, image, tagEveryone)
    local tag = tagEveryone or false
    local webHook = Private.base.webHooks[name] or Private.base.webHooks["default"]
    local embedData = {
        {
            ["title"] = "SkyeDevelopment logs - " .. title,
            ["color"] = colors[color] or colors["default"],
            ["footer"] = {
                ["text"] = os.date("%c"),
            },
            ["description"] = message,
            ["image"] = {
                ["url"] = image,
            },
        }
    }
    Citizen.Wait(100)
    if tag then
        PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "SkyeRoleplay | Logs", content = "@everyone", embeds = embedData}), { ['Content-Type'] = 'application/json' })
    else
        PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "SkyeRoleplay | Logs", embeds = embedData}), { ['Content-Type'] = 'application/json' })
    end
end

function loggerClass:console(method, name, message)
    print("[^1" .. method .. "^7] [^4" .. name .. "^7] " .. message)
end

function loggerClass:public(method, name, message)
    local src = source
    TriggerClientEvent('skye_helper:public:log', src, method, name, message)
end