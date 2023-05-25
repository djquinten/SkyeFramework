function updatePresence()
    local Config = configClass:getPublic()
    SetDiscordAppId(Config.base.richPresence['AppId'])
    SetDiscordRichPresenceAsset('logo')
    SetDiscordRichPresenceAssetText(Config.base.richPresence['Text'])
    SetDiscordRichPresenceAssetSmall('skyedevelopment')
    SetDiscordRichPresenceAssetSmallText('SkyeDevelopment')
end

function SetDiscordButtons()
    SetDiscordRichPresenceAction(0, 'Connect', 'https://dsc.gg/skyedevelopment')
    SetDiscordRichPresenceAction(1, 'Discord', 'https://dsc.gg/skyedevelopment')
end