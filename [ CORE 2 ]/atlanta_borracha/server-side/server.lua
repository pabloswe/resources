-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cnVRP = {}
Tunnel.bindInterface("atlanta_borracha",cnVRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local gallons = {
	{ 1503.62,-2122.93,76.58,0,0,0,0 },
	{ 1495.86,-2136.52,77.33,0,0,0,0 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(gallons) do
			if v[7] > 0 and v[7] < 100 then
				v[7] = v[7] + 10
			end
		end
		TriggerClientEvent("atlanta_borracha:labUpdate",-1,gallons)
		Citizen.Wait(1000)
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSTATUS
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.checkStatus(processId)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Dk") then
			if parseInt(gallons[processId][7]) <= 0 then
				gallons[processId][7] = 1
				TriggerClientEvent("atlanta_borracha:labUpdate",-1,gallons)
			elseif parseInt(gallons[processId][7]) >= 100 then
				local quantidade =parseInt(math.random(4,7))
				--print (quantidade)
				if vRP.computeInvWeight(user_id) + vRP.itemWeightList("rubber") * quantidade  <= vRP.getBackpack(user_id) then
					gallons[processId][7] = 0
					TriggerClientEvent("Notify",source,"aviso","Você coletou "..quantidade.."x "..vRP.itemNameList("rubber"),5000)
					TriggerClientEvent("atlanta_borracha:labUpdate",-1,gallons)
					vRP.giveInventoryItem(user_id,"rubber",quantidade,true)
				else
					TriggerClientEvent("Notify",source,"negado","Mochila cheia.",5000)
				end
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("atlanta_borracha:labUpdate",source,gallons)
end)