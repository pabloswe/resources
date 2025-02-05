-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local playerReady = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERREADY
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.playerReady()
	playerReady = true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADREADY
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	NetworkSetFriendlyFireOption(true)
	SetCanAttackFriendly(PlayerPedId(),true,true)

	while true do
		if playerReady then
			local coords = GetEntityCoords(PlayerPedId())
			vRPserver._updatePositions(coords.x,coords.y,coords.z)
		end

		Citizen.Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADREADY
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if playerReady then
			vRPserver._updateHealth(GetEntityHealth(PlayerPedId()))
			vRPserver._updateArmour(GetPedArmour(PlayerPedId()))
		end

		Citizen.Wait(30000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.getHealth()
	return GetEntityHealth(PlayerPedId())
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.setHealth(health)
	SetEntityHealth(PlayerPedId(),parseInt(health))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.updateHealth(number)
	local ped = PlayerPedId()
	local health = GetEntityHealth(ped)
	if health > 101 then
		SetEntityHealth(ped,parseInt(health+number))
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.downHealth(number)
	local ped = PlayerPedId()
	local health = GetEntityHealth(ped)

	SetEntityHealth(ped,parseInt(health-number))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETARMOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.getArmour()
	return GetPedArmour(PlayerPedId())
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETARMOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.setArmour(amount)
	local ped = PlayerPedId()
	local armour = GetPedArmour(ped)
	SetPedArmour(ped,parseInt(armour+amount))
	TriggerEvent("nahu:clock",amount)
end