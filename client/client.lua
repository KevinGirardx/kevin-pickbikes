local QBCore = exports['qb-core']:GetCoreObject()
local bike = nil
local hasbike = false
local closebike = false

local function PickUpBike(hash)
	local ped = PlayerPedId()
	local name = string.lower(GetDisplayNameFromVehicleModel(hash))
	RequestAnimDict("anim@heists@box_carry@")
	while (not HasAnimDictLoaded("anim@heists@box_carry@")) do
		Wait(1)
	end
	TaskPlayAnim(ped, "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
	AttachEntityToEntity(bike, ped, GetPedBoneIndex(player, 60309), Config.Bikes[name].x, Config.Bikes[name].y, Config.Bikes[name].z, Config.Bikes[name].RotX, Config.Bikes[name].RotY, Config.Bikes[name].RotZ, true, false, false, true, 0, true)
	hasbike = true
	exports['qb-core']:DrawText("["..Config.InteractKey.."] Drop ", Config.DrawTextPosition)
end

local function PressedKey(hash)
	CreateThread(function ()
		while not hasbike do
			local ped = PlayerPedId()
			if IsControlJustReleased(0, 38) then
				PickUpBike(hash)
			end
			Wait(1)
		end
	end)
end

CreateThread( function ()
	if Config.Interaction == "qb" then
		while true do
			local ped = PlayerPedId()
			local pos = GetEntityCoords(ped)
			bike = QBCore.Functions.GetClosestVehicle()
			for k, v in pairs(Config.Bikes) do
				local hash = GetHashKey(k)
				if GetEntityModel(bike) == hash then
					local bikepos = GetEntityCoords(bike)
                    local dist = #(pos - bikepos)
                    if dist <= 1.5 then
						if IsPedOnFoot(ped) and not closebike then
							closebike = true
							exports['qb-core']:DrawText("["..Config.InteractKey.."] Pick Up", Config.DrawTextPosition)
							PressedKey(hash)
						end
					else
						closebike = false
						exports['qb-core']:HideText()
					end
				end
			end
			Wait(1000)
		end
	else
		for k,v in pairs(Config.Bikes) do
			local hash = GetHashKey(k)
			exports['qb-target']:AddTargetModel(hash, {
				options = {
				{
					type = "client",
					event = "kevin-pickbikes:client:takeup", -- I'm not familiar but there is a way to put the function right in here and pass the variable i believe but this event will do for now.
					icon = "fas fa-bicycle",
					label = "Pick Up",
					hash = hash
				}
			},
				distance = 2.0,
			})
		end
	end
end)

RegisterNetEvent("kevin-pickbikes:client:takeup", function(data)
	local hash = data.hash
	bike = QBCore.Functions.GetClosestVehicle()
	PickUpBike(hash)
end)

RegisterCommand('dropbike', function()
	if IsEntityAttachedToEntity(bike, PlayerPedId()) then
		DetachEntity(bike, false, false)
		SetVehicleOnGroundProperly(bike)
		ClearPedTasks(PlayerPedId())
		hasbike = false
		closebike = false
		exports['qb-core']:HideText()
	end
end)

RegisterKeyMapping('dropbike', 'Drop Bike', 'keyboard', Config.InteractKey)
