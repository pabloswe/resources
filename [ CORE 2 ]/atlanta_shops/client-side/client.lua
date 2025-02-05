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
Tunnel.bindInterface("atlanta_shops",cnVRP)
vSERVER = Tunnel.getInterface("atlanta_shops")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(data)
	SetNuiFocus(false,false)
	TransitionFromBlurred(1000)
	SendNUIMessage({ action = "hideNUI" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestShop",function(data,cb)
	local inventoryShop,inventoryUser,weight,maxweight,infos = vSERVER.requestShop(data.shop)
	if inventoryShop then
		cb({ inventoryShop = inventoryShop, inventoryUser = inventoryUser, weight = weight, maxweight = maxweight, infos = infos })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("functionShops",function(data,cb)
	vSERVER.functionShops(data.shop,data.item,data.amount,data.slot)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("populateSlot",function(data,cb)
	TriggerServerEvent("atlanta_shops:populateSlot",data.item,data.slot,data.target,data.amount)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSlot",function(data,cb)
	TriggerServerEvent("atlanta_shops:updateSlot",data.item,data.slot,data.target,data.amount)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- atlanta_shops:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("atlanta_shops:Update")
AddEventHandler("atlanta_shops:Update",function(action)
	SendNUIMessage({ action = action })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local shopList = {
	{ 25.68,-1346.6,29.5,"departamentStore" },
	{ 2556.47,382.05,108.63,"departamentStore" },
	{ 1163.55,-323.02,69.21,"departamentStore" },
	{ -707.31,-913.75,19.22,"departamentStore" },
	{ -47.72,-1757.23,29.43,"departamentStore" },
	{ 373.89,326.86,103.57,"departamentStore" },
	{ -3242.95,1001.28,12.84,"departamentStore" },
	{ 1729.3,6415.48,35.04,"departamentStore" },
	{ 548.0,2670.35,42.16,"departamentStore" },
	{ 1960.69,3741.34,32.35,"departamentStore" },
	{ 2677.92,3280.85,55.25,"departamentStore" },
	{ 1698.5,4924.09,42.07,"departamentStore" },
	{ -1820.82,793.21,138.12,"departamentStore" },
	{ 1393.21,3605.26,34.99,"departamentStore" },
	{ -2967.78,390.92,15.05,"departamentStore" },
	{ -3040.14,585.44,7.91,"departamentStore" },
	{ 1135.56,-982.24,46.42,"departamentStore" },
	{ 1166.0,2709.45,38.16,"departamentStore" },
	{ -1487.21,-378.99,40.17,"departamentStore" },
	{ -1222.76,-907.21,12.33,"departamentStore" },
	{ 1692.62,3759.50,34.70,"ammunationStore" },
	{ 252.89,-49.25,69.94,"ammunationStore" },
	{ 843.28,-1034.02,28.19,"ammunationStore" },
	{ -331.35,6083.45,31.45,"ammunationStore" },
	{ -663.15,-934.92,21.82,"ammunationStore" },
	{ -1305.18,-393.48,36.69,"ammunationStore" },
	{ -1118.80,2698.22,18.55,"ammunationStore" },
	{ 2568.83,293.89,108.73,"ammunationStore" },
	{ -3172.68,1087.10,20.83,"ammunationStore" },
	{ 21.32,-1106.44,29.79,"ammunationStore" },
	{ 811.19,-2157.67,29.61,"ammunationStore" },
	{ -1082.22,-247.54,37.77,"premiumStore" },
	{ -1563.58,-975.38,13.02,"fishingStore" },
	{ -1591.95,-1005.87,13.03,"fishingSell" },
	{ 306.74,-601.9,43.29,"pharmacyStore" },
	{ 237.7,-413.12,48.12,"registryStore" },
	{ 46.66,-1749.79,29.64,"megaMallStore" },
	{ -428.56,-1728.33,19.79,"recyclingSell" },
	{ 1134.33,-469.45,66.49,"digitalDen" },
	{ -435.47,273.94,83.43,"comedyBar" },
	{ 369.78,-1598.18,29.3,"policeStore" },
	{ -168.69,6317.69,30.6,"vendaCodeina" },
	{ 1135.69,-987.5,46.12,"lavandaStore" },
	{280.25,-971.93,29.42,"coffeshop"},
	{-633.53,235.28,81.89,"coffeshop2"},
	{-1839.16,-1186.89,19.19,"pearls"},
	{-1844.95,-1198.11,14.34,"pearls"},
	{359.77,280.5,94.2,"bar"},
	{127.98,-1284.91,29.28,"vanilla"},
	{-563.33,286.3,85.38,"vanilla"},
	{-560.17,286.5,82.18,"tequila"},
	{-1193.9,-892.9,14.0,"burgershot"},
	{-1195.25,-890.78,14.0,"burgershot"},
	{-1192.67,-894.77,14.0,"burgershot"},
	{736.34,2585.57,75.53,"vendaLock"},
	{1787.7,3896.81,34.39,"vendaAssassino"},
	{-2168.38,5198.5,17.03,"vendaIsolado"},
	{485.92,-1529.44,29.29,"vendaPolicialSecreto"},
	{398.31,97.03,101.49,"lojaMochilas"},
	{377.49,-828.07,29.31,"weedz"},
	{12.65,-1600.35,29.38,"tacosBebidas"},
	{15.65,-1598.32,29.38,"tacosComidas"}
}


-----------------------------------------------------------------------------------------------------------------------------------------
-- NPC no Blip Codeina
-----------------------------------------------------------------------------------------------------------------------------------------
local pedList = {
	{
		["x"] =  -168.94,
		["y"] = 6317.77,
		["z"] = 30.6,
		["h"] = 262.72,
		["hash"] = 0x841BA933,
		["hash2"] = "ig_g"
	}
}

Citizen.CreateThread( function()
	for k, v in pairs(pedList) do
		RequestModel(GetHashKey(v.hash2))

		while not HasModelLoaded(GetHashKey(v.hash2)) do
			Citizen.Wait(100)
		end

		local ped = CreatePed(4, v.hash, v.x, v.y, v.z -1, v.h, false, true)		
		FreezeEntityPosition(ped, true)
		SetEntityInvincible(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- NPC no Blip de lavanderia
-----------------------------------------------------------------------------------------------------------------------------------------
local pedList = {
	{
		["x"] =  1135.69,
		["y"] = -987.5,
		["z"] = 46.12,
		["h"] = 243.63,
		["hash"] = 0x4D5696F7,
		["hash2"] = "mp_m_bogdangoon"
	}
}

Citizen.CreateThread( function()
	for k, v in pairs(pedList) do
		RequestModel(GetHashKey(v.hash2))

		while not HasModelLoaded(GetHashKey(v.hash2)) do
			Citizen.Wait(100)
		end

		local ped = CreatePed(4, v.hash, v.x, v.y, v.z -1, v.h, false, true)		
		FreezeEntityPosition(ped, true)
		SetEntityInvincible(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)

	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			for k,v in pairs(shopList) do
				local distance = #(coords - vector3(v[1],v[2],v[3]))
				if distance <= 1.5 then
					timeDistance = 4
					DrawText3D(v[1],v[2],v[3],"~g~E~w~   ABRIR")
					if IsControlJustPressed(1,38) and vSERVER.requestPerm(v[4]) then
						SetNuiFocus(true,true)
						TransitionToBlurred(1000)
						SendNUIMessage({ action = "showNUI", name = tostring(v[4]), type = vSERVER.getShopType(v[4]) })
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,100)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 450
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,100)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPSHOPS
-----------------------------------------------------------------------------------------------------------------------------------------
local propShops = {
	-- { "prop_vend_coffe_01","coffeeMachine" },
	--{ "prop_vend_soda_02","sodaMachine" },
	--{ "prop_vend_soda_01","colaMachine" },
	--{ "v_ret_247_donuts","donutMachine" },
	-- { "prop_burgerstand_01","burgerMachine" },
	--{ "prop_hotdogstand_01","hotdogMachine" },
	{ "prop_vend_water_01","waterMachine" }
}

RegisterCommand("comprar",function(source,args)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	for k,v in pairs(propShops) do
		if DoesObjectOfTypeExistAtCoords(coords,0.7,GetHashKey(v[1]),true) then
			SetNuiFocus(true,true)
			SendNUIMessage({ action = "showNUI", name = tostring(v[2]), type = vSERVER.getShopType(v[2]) })
		end
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- NPC no Blip Crafting Ilegal
-----------------------------------------------------------------------------------------------------------------------------------------
local pedList = {
	{
		['x'] = -1195.2, ['y'] = -893.64, ['z'] = 14.0, ['h'] = 304.77,
		["hash"] = 0x5AA42C21,
		["hash2"] = "g_f_y_vagos_01"
	},
	{
		["x"] = -1196.63, ["y"] = -891.64, ["z"] = 14.0, ["h"] = 301.46,
		["hash"] = 0x69E8ABC3,
		["hash2"] = "cs_tom"
	},
	{
		["x"] = -1193.96, ["y"] = -895.48, ["z"] = 14.0, ["h"] = 304.11,
		["hash"] = 0xCE9113A9,
		["hash2"] = "s_m_m_strvend_01"
	},
	{
		["x"] = 280.27, ["y"] = -973.14, ["z"] = 29.43, ["h"] = 358.89,
		["hash"] = 0xD090C350,
		["hash2"] = "ig_fabien"
	},
	{
		["x"] = 371.54, ["y"] = -924.86, ["z"] = 30.25, ["h"] = 175.26,
		["hash"] = 0x4D6DE57E,
		["hash2"] = "cs_priest"
	},
	{
		["x"] = 113.84, ["y"] = -140.6, ["z"] = 54.87, ["h"] = 164.31,
		["hash"] = 0x6B38B8F8,
		["hash2"] = "cs_paper"
	},
	{
		["x"] = 149.45, ["y"] = -1042.15, ["z"] = 29.37, ["h"] = 340.29,
		["hash"] = 0x342333D3,
		["hash2"] = "u_m_m_fibarchitect"
	},
	{
		["x"] = -434.35, ["y"] = 273.87, ["z"] = 83.43, ["h"] = 92.18,
		["hash"] = 0xE5A11106,
		["hash2"] = "s_m_y_barman_01"
	},
	{
		["x"] = 807.88, ["y"] = -496.66, ["z"] = 30.69, ["h"] = 10.2,
		["hash"] = 0xD47303AC,
		["hash2"] = "s_m_m_doctor_01"
	},
	{
		["x"] = -177.62, ["y"] = 415.02, ["z"] = 110.78, ["h"] = 109.67,
		["hash"] = 0xD47303AC,
		["hash2"] = "s_m_m_doctor_01"
	},
	{
		["x"] = 736.34, ["y"] = 2585.57, ["z"] = 75.53, ["h"] = 259.11,
		["hash"] = 0x72551375,
		["hash2"] = "cs_lifeinvad_01"
	},
	{
		["x"] = 1787.7, ["y"] = 3896.81, ["z"] = 34.39, ["h"] = 144.07,
		["hash"] = 0xF09D5E29,
		["hash2"] = "cs_joeminuteman"
	},
	{
		["x"] = -2168.38, ["y"] = 5198.5, ["z"] = 17.03, ["h"] = 192.9,
		["hash"] = 0x07DD91AC,
		["hash2"] = "a_m_m_eastsa_02"
	},
	{
		["x"] = 485.92, ["y"] = -1529.44, ["z"] = 29.29, ["h"] = 55.27,
		["hash"] = 0xDA2C984E,
		["hash2"] = "mp_m_securoguard_01"
	}
}

Citizen.CreateThread( function()
	for k, v in pairs(pedList) do
		RequestModel(GetHashKey(v.hash2))

		while not HasModelLoaded(GetHashKey(v.hash2)) do
			Citizen.Wait(100)
		end

		local ped = CreatePed(4, v.hash, v.x, v.y, v.z -1, v.h, false, true)
		FreezeEntityPosition(ped, true)
		SetEntityInvincible(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)
	end
end)