vehicleClass = {}

-- ###########################################
-- ### Vehicle Spawning, Deleting & Fixing ###
-- ###########################################
function vehicleClass:spawnAndTeleport(vehicleModel)
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)

	RequestModel(vehicleModel)
	while not HasModelLoaded(vehicleModel) do
		Citizen.Wait(0)
	end

	local vehicle = CreateVehicle(vehicleModel, playerCoords.x, playerCoords.y, playerCoords.z, GetEntityHeading(playerPed), true, false)

	SetPedIntoVehicle(playerPed, vehicle, -1)
	print("Vehicle spawned")
end

function vehicleClass:deleteVehicle()
	local playerPed = PlayerPedId()
	local playerPos = GetEntityCoords(playerPed)

	local vehicle = GetClosestVehicle(playerPos.x, playerPos.y, playerPos.z, 3.0, 0, 71)
	local playerVehicle = GetVehiclePedIsIn(playerPed, false)

	if DoesEntityExist(vehicle) then
		DeleteVehicle(vehicle)
		print("Vehicle deleted")
	elseif DoesEntityExist(playerVehicle) then
		DeleteVehicle(playerVehicle)
		print("Vehicle deleted")
	else
		print("No vehicle nearby")
	end
end

function vehicleClass:fixVehicle()
	local playerPed = PlayerPedId()
	local playerPos = GetEntityCoords(playerPed)

	local vehicle = GetClosestVehicle(playerPos.x, playerPos.y, playerPos.z, 3.0, 0, 71)
	local playerVehicle = GetVehiclePedIsIn(playerPed, false)

	if DoesEntityExist(vehicle) then
		SetVehicleFixed(vehicle)
		SetVehicleDirtLevel(vehicle, 0.0)
		print("Vehicle fixed")
	elseif DoesEntityExist(playerVehicle) then
		SetVehicleFixed(playerVehicle)
		SetVehicleDirtLevel(playerVehicle, 0.0)
		print("Vehicle fixed")
	else
		print("No vehicle nearby")
	end
end