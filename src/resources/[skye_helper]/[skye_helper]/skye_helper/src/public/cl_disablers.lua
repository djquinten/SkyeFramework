disableHudComponents = {1, 2, 3, 4, 7, 9, 13, 14, 19, 20, 21, 22}

CreateThread(function()
	for i = 1, 15 do
		EnableDispatchService(i, false)
	end
	SetMaxWantedLevel(0)

    SetAudioFlag("PoliceScannerDisabled", true)
	SetGarbageTrucks(false)
	SetCreateRandomCops(false)
	SetCreateRandomCopsNotOnScenarios(false)
	SetCreateRandomCopsOnScenarios(false)
	DistantCopCarSirens(false)
    DisableIdleCamera(true)
end)

CreateThread(function()
    while true do
        Wait(0)
        SetPedSuffersCriticalHits(PlayerPedId(), false)
        for i = 1, #disableHudComponents do
            HideHudComponentThisFrame(disableHudComponents[i])
        end
        DisplayAmmoThisFrame(true)
    end
end)