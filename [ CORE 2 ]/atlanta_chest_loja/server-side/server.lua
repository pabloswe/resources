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
Tunnel.bindInterface("atlanta_chest_loja",cnVRP)
vCLIENT = Tunnel.getInterface("atlanta_chest_loja")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local chestOpen = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATE CHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('createChestLoja',function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id and vRP.hasPermission(user_id,"Owner") then
		local x,y,z = vRPclient.getPositions(source)

		local nome = vRP.prompt(source,"Nome do chest?","")
		if nome == "" then
			return
		end

		local perm = vRP.prompt(source,"Permissao do chest?","")
		if perm == "" then
			return
		end

		local tamanho = vRP.prompt(source,"Tamanho do chest?","")
		if tamanho == "" then
			return
		end

		vCLIENT.insertTable(-1,nome, { x,y,z } )
		vRP.execute("vRP/addChestLoja", { permiss = perm, name = nome, x = x, y = y, z = z, weight = tamanho })
		vRP.execute("vRP/insertChest", { name = 'chestLoja:'..nome, value = '{}' })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	local rows = vRP.query("vRP/get_alltableLoja")
    if #rows > 0 then
		for k,v in pairs(rows) do
			vCLIENT.insertTable(source,rows[k].name, { rows[k].x,rows[k].y,rows[k].z } )
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINTPERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.checkIntPermissions(chestName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.wantedReturn(parseInt(user_id)) then
			return false
		end
		local consult = vRP.query("vRP/getExistChestLoja",{ name = chestName })
		if consult[1].name == chestName then
			if vRP.hasPermission(parseInt(user_id),consult[1].permiss) then
				chestOpen[user_id] = chestName
				return true
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.chestClose()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if chestOpen[user_id] then
			chestOpen[user_id] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.openChest()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		local myinventory = {}
		local mychestopen = {}
		local mychestname = chestOpen[parseInt(user_id)]
		if mychestname ~= nil then

			local inv = vRP.getInventory(parseInt(user_id))
			if inv then
				for k,v in pairs(inv) do
					if string.sub(v.item,1,9) == "toolboxes" then
						local advFile = LoadResourceFile("logsystem","toolboxes.json")
						local advDecode = json.decode(advFile)

						v.durability = advDecode[v.item]
					end

					v.amount = parseInt(v.amount)
					v.name = vRP.itemNameList(v.item)
					v.peso = vRP.itemWeightList(v.item)
					v.index = vRP.itemIndexList(v.item)
					v.key = v.item
					v.slot = k

					myinventory[k] = v
				end
			end

			local data = vRP.getSData("chestLoja:"..mychestname)
			local sdata = json.decode(data) or {}
			if data then
				for k,v in pairs(sdata) do
					table.insert(mychestopen,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, peso = vRP.itemWeightList(k) })
				end
			end
			local consult = vRP.query("vRP/getExistChestLoja",{ name = mychestname })
			if consult[1].name == mychestname then
				return myinventory,mychestopen,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),vRP.computeChestWeight(sdata),consult[1].weight,{ identity.name.." "..identity.name2,parseInt(user_id),identity.phone,identity.registration,vRP.getBank(user_id) }
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- Store
-----------------------------------------------------------------------------------------------------------------------------------------
local store = {
	["dollars"] = true,
	["dollars2"] = true,
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("atlanta_chest_loja:populateSlot")
AddEventHandler("atlanta_chest_loja:populateSlot",function(itemName,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		if vRP.tryGetInventoryItem(user_id,itemName,amount,false,slot) then
			vRP.giveInventoryItem(user_id,itemName,amount,false,target)
			TriggerClientEvent("atlanta_chest_loja:Update",source,"updateChest")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("atlanta_chest_loja:updateSlot")
AddEventHandler("atlanta_chest_loja:updateSlot",function(itemName,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		local inv = vRP.getInventory(user_id)
		if inv then
			if inv[tostring(slot)] and inv[tostring(target)] and inv[tostring(slot)].item == inv[tostring(target)].item then
				if vRP.tryGetInventoryItem(user_id,itemName,amount,false,slot) then
					vRP.giveInventoryItem(user_id,itemName,amount,false,target)
				end
			else
				vRP.swapSlot(user_id,slot,target)
			end
		end

		TriggerClientEvent("atlanta_chest_loja:Update",source,"updateChest")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("atlanta_chest_loja:sumSlot")
AddEventHandler("atlanta_chest_loja:sumSlot",function(itemName,slot,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local inv = vRP.getInventory(user_id)
		if inv then
			if inv[tostring(slot)] and inv[tostring(slot)].item == itemName then
				if vRP.tryChestItem(user_id,"chestLoja:"..tostring(chestOpen[parseInt(user_id)]),itemName,amount,slot) then
					TriggerClientEvent("atlanta_chest_loja:Update",source,"updateChest")
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.storeItem(itemName,slot,amount)
	if itemName then
		local source = source
		local user_id = vRP.getUserId(source)
		if user_id then
			if store[itemName] then
				local consult = vRP.query("vRP/getExistChestLoja",{ name = tostring(chestOpen[parseInt(user_id)]) })
				if consult[1].name == tostring(chestOpen[parseInt(user_id)]) then
					if vRP.storeChestItem(user_id,'chestLoja:'..tostring(chestOpen[parseInt(user_id)]),itemName,amount,consult[1].weight,slot) then
						TriggerClientEvent("atlanta_chest_loja:Update",source,"updateChest")
					end
				end
			else
				TriggerClientEvent("Notify",source,"importante","Você não pode armazenar este item em baús de loja.",5000)
				return
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.takeItem(itemName,slot,amount)
	if itemName then
		local source = source
		local user_id = vRP.getUserId(source)
		if user_id then
			if vRP.tryChestItem(user_id,'chestLoja:'..tostring(chestOpen[parseInt(user_id)]),itemName,amount,slot) then
				TriggerClientEvent("atlanta_chest_loja:Update",source,"updateChest")
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if chestOpen[user_id] then
		chestOpen[user_id] = nil
	end
end)