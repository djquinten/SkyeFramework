local function playerConnecting(name, setKickReason, deferrals)
    deferrals.defer()
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    local presentCard = json.decode(LoadResourceFile(GetCurrentResourceName(), "shared/presentcard.json"))[1]
    local name = GetPlayerName(src)

    function updateMessage(msg, _deferrals)
        local deferrals = _deferrals or deferrals
        connecting = false
        local currentMessage = GetMessage(tostring(msg) or "")
        deferrals.presentCard(currentMessage, function(data, rawData) end)
    end

    function GetMessage(message)
        local card = presentCard
        card.body[3].text = message
        return card
    end

    Wait(0)
    CreateThread(function()
        if not name then
            deferrals.done('Please restart FiveM and try again.')
        end

        local steamid = identifiers[1]
        if ((steamid:sub(1,6) == "steam:") == false) then
            deferrals.done('You need to have steam open to join this server.')
	    end

        if(string.match(name, "[*%%'=`\"]")) then
            deferrals.done('You have a token ('..string.match(name, "[*%%'=`\"]")..') in your name which is not allowed.\nPlease change your steam name.')
	    end
	    if (string.match(name, "drop") or string.match(name, "table") or string.match(name, "database")) then
            deferrals.done('You have a word (drop/table/database) in your name which is not allowed.\nPlease change your steam name.')
	    end

        local steamId = string.gsub(playerClass:getIdentifierByType(src, 'steam'), "steam:", "") 
        local discordId = string.gsub(playerClass:getIdentifierByType(src, 'discord'), "discord:", "")
        local licenseId = string.gsub(playerClass:getIdentifierByType(src, 'license'), "license:", "")
        local ip = string.gsub(playerClass:getIdentifierByType(src, 'ip'), "ip:", "")
        loggerClass:discord(
            'joinleave', 
            'Player connecting', 
            'orange',
            "Steam: **".. GetPlayerName(src) .. "** | **"..steamId .. "** \n\nlicense: **"..licenseId.. "** \ndiscord: <@" .. discordId .. "> | **" ..discordId.. "\n\n**ip:** "..ip .. "**"
        )
        print(
            "Steam: **".. GetPlayerName(src) .. "** | **"..steamId .. "** \n\nlicense: **"..licenseId.. "** \ndiscord: <@" .. discordId .. "> | **" ..discordId.. "\n\n**ip:** "..ip .. "**"
        )

        Wait(5)
        updateMessage("Welcome to the SkyeFramework, " .. name .. "!\n\nPlease wait while we are checking your information...", deferrals)
        Wait(6000)

        deferrals.done()
    end)
end
AddEventHandler('playerConnecting', playerConnecting)

function playerDropped(reason, setKickReason, deferrals)
    local src = source
    local reason = reason or "No reason"
    local steamId = string.gsub(GetPlayerIdentifierByType(src, 'steam'), "steam:", "") 
    local discordId = string.gsub(GetPlayerIdentifierByType(src, 'discord'), "discord:", "")
    local licenseId = string.gsub(GetPlayerIdentifierByType(src, 'license'), "license:", "")
    local ip = string.gsub(GetPlayerIdentifierByType(src, 'ip'), "ip:", "")

    loggerClass:discord(
        'joinleave',
        'Player left',
        'red',
        "Reason: **" .. reason .. "**\nSteam: **".. GetPlayerName(src) .. "** | **"..steamId .. "** \n\nlicense: **"..licenseId.. "** \ndiscord: <@" .. discordId .. "> | **" ..discordId.. "**\n\nip:** "..ip .. "**"
    )
end
AddEventHandler('playerDropped', playerDropped)