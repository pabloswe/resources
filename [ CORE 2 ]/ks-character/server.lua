local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

local userlogin = {}
-- AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
-- 	if first_spawn then
-- 		local data = vRP.getUData(user_id,"vRP:spawnController")
-- 		local sdata = json.decode(data) or 0
-- 		if sdata then
-- 			Citizen.Wait(1000)
-- 			processSpawnController(source,sdata,user_id)
-- 		end
-- 	end
-- end)

function getSourceRestore()
	local source = source
	return source
end

function getUserIdRestore()
	local source = source
	local user_id = vRP.getUserId(source)
	return user_id
end

function getUserWeaponsRestore(user_id)
	local weapons = vRP.getWeaponsId(user_id)
	return weapons
end

function delAmmoLogoutRestore(user_id, qtd, tipo)
	vRP.execute("vRP/del_weapon", { user_id = user_id, weapon = tipo })
	vRP.giveInventoryItem(user_id,tipo,qtd,false) -- ??
	TriggerClientEvent("vrp_inventory:Update",source,"updateMochila")
end

RegisterServerEvent("ks-CharacterSpawn")
AddEventHandler("ks-CharacterSpawn", function(source,user_id) 
	if user_id then
			local data = vRP.getUData(user_id,"spawnController")
			local sdata = json.decode(data) or 0
			if sdata then
				Citizen.Wait(1000)
				processSpawnController(source,sdata,user_id)
			end
	end

end)

function processSpawnController(source,statusSent,user_id)
	if statusSent == 2 then
		if not userlogin[user_id] then
			userlogin[user_id] = true
			doSpawnPlayer(source,user_id,true)
		else
			doSpawnPlayer(source,user_id,false)
		end
		-- RESTAURAR
		-- local ped = PlayerPedId()
		--print("teste")
		--print("user_id = "..user_id)
		--print("source = "..source)
		local dataX = getUserWeaponsRestore(user_id)
		-- print("data = "..dataX)
		for k, v in pairs(dataX) do 
			if v.weapon ~= nill then	
				--print(v.weapon.."= "..v.ammo)	
				delAmmoLogoutRestore(user_id,v.ammo, v.weapon)
			end
		end

	elseif statusSent == 1 or statusSent == 0 then
		userlogin[user_id] = true
		local data = vRP.getUserDataTable(user_id)
		if data and data.skin then
			TriggerClientEvent("ks-character:characterCreate",source, data.skin)	
		end
	end
end

RegisterServerEvent("ks-character:finishedCharacter")
AddEventHandler("ks-character:finishedCharacter",function(currentCharacterMode)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.setUData(user_id,"currentCharacterMode",json.encode(currentCharacterMode))
		vRP.setUData(user_id,"spawnController",json.encode(2))
		-- vRP.varyExp(user_id,"physical","strength",650)
		-- vRP.execute("vRP/update_user_first_spawn",{ user_id = user_id, firstname = characterSobrenome, name = characterNome, age = characterAge })
		doSpawnPlayer(source,user_id,true)
	end
end)

function doSpawnPlayer(source,user_id,firstspawn)
	TriggerClientEvent("ks-character:normalSpawn",source,firstspawn)
	TriggerEvent("vrp_barbershop:init",user_id)	
end