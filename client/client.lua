local QBCore = exports['qb-core']:GetCoreObject()

local hasbike = false

CreateThread(function ()
	exports['qb-target']:AddTargetModel(Config.Bikes, {
		options = {
		{
			type = "client",
			event = "kevin-pickbikes:client:takeup",
			icon = "fas fa-bicycle",
			label = "Pick Up",
		}
	},
		distance = 1.5,
	})
end)

RegisterNetEvent("kevin-pickbikes:client:takeup", function ()
    local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	bike = QBCore.Functions.GetClosestVehicle()
	if GetHashKey(bike) then
		print(bike)
		RequestAnimDict("anim@heists@box_carry@")
		while (not HasAnimDictLoaded("anim@heists@box_carry@")) do
			Wait(1)
		end
		TaskPlayAnim(ped, "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
		AttachEntityToEntity(bike, ped, GetPedBoneIndex(player, 60309), 0.0, 0.35, 0.160, 180.0, 170.0, 90.0, true, false, true, true, 0, true)
		hasbike = true
		exports['qb-core']:DrawText("[G] Drop Bike", Config.DrawTextPosition)
	end
end)

RegisterCommand('dropbike', function()
	if IsEntityAttachedToEntity(bike, PlayerPedId()) then
		DetachEntity(bike, false, false)
		SetVehicleOnGroundProperly(bike)
		ClearPedTasks(PlayerPedId())
		hasbike = false
		exports['qb-core']:HideText()
	end
end)

RegisterKeyMapping('dropbike', 'Drop Bike', 'keyboard', Config.DropBikeKey)
