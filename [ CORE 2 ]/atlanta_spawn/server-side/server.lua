-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cnVRP = {}
Tunnel.bindInterface("atlanta_spawn",cnVRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETUPCHARS
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.setupChars()
	local source = source
	local steam = vRP.getSteam(source)

	Citizen.Wait(1000)

	return getPlayerCharacters(steam)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETECHAR
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.deleteChar(id)
	local source = source
	local steam = vRP.getSteam(source)

	vRP.execute("vRP/remove_characters",{ id = parseInt(id) })
  
	Citizen.Wait(1000)

	return getPlayerCharacters(steam)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
local spawnLogin = {}
RegisterServerEvent("atlanta_spawn:charChosen")
AddEventHandler("atlanta_spawn:charChosen",function(id)
	local source = source
	TriggerClientEvent("hudActived",source,true)
	TriggerEvent("baseModule:idLoaded",source,id,nil)

	-- if spawnLogin[parseInt(id)] then
	-- 	-- TriggerClientEvent("atlanta_spawn:spawnChar",source,false)
	-- else
	-- 	spawnLogin[parseInt(id)] = true
	-- 	-- TriggerClientEvent("atlanta_spawn:spawnChar",source,true)
	-- end
	TriggerEvent("ks-CharacterSpawn", source, id)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATECHAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("atlanta_spawn:createChar")
AddEventHandler("atlanta_spawn:createChar",function(name,name2,sex)
	local source = source
	local steam = vRP.getSteam(source)
	local persons = getPlayerCharacters(steam)

	if not vRP.getPremium2(steam) and parseInt(#persons) >= 1 then
		TriggerClientEvent("Notify",source,"importante","Você atingiu o limite de personagens.",5000)
		TriggerClientEvent("atlanta_spawn:maxChars",source)
		return
	end

	vRP.execute("vRP/create_characters",{ steam = steam, name = name, name2 = name2 })

	local newId = 0
	local chars = getPlayerCharacters(steam)
	for k,v in pairs(chars) do
		if v.id > newId then
			newId = tonumber(v.id)
		end
	end

	local model = ""
	if sex == "M" then
		model = "mp_m_freemode_01"
	elseif sex == "F" then
		model = "mp_f_freemode_01"
	end

	Citizen.Wait(1000)

	spawnLogin[parseInt(newId)] = true
	TriggerClientEvent("hudActived",source,true)
	-- TriggerClientEvent("atlanta_spawn:spawnChar",source,true)
	TriggerEvent("baseModule:idLoaded",source,newId,model)
	TriggerEvent("ks-CharacterSpawn", source, newId)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPLAYERCHARACTERS
-----------------------------------------------------------------------------------------------------------------------------------------
function getPlayerCharacters(steam)
	return vRP.query("vRP/get_characters",{ steam = steam })
end