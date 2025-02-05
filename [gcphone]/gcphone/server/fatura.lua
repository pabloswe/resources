

function FaturaGetBilling (accountId, cb)
  local xPlayer = vRP.getUserId(source)
  MySQL.Sync.fetchAll("SELECT vrp_users.phone FROM vrp_users WHERE vrp_users.id = @identifier",{ ['@identifier'] = identifier }, cb)
  end 

function getUserFatura(phone_number, firstname, cb)
  MySQL.Async.fetchAll("SELECT name, phone FROM vrp_users WHERE vrp_users.name = @firstname AND vrp_users.phone = @phone", {
    ['@phone'] = phone_number,
	['@firstname'] = firstname
  }, function (data)
    cb(data[1])
  end)
end

RegisterServerEvent('gcPhone:fatura_getBilling')
AddEventHandler('gcPhone:fatura_getBilling', function(phone_number, firstname)
  local sourcePlayer = tonumber(source)
  if phone_number ~= nil and phone_number ~= "" and firstname ~= nil and firstname ~= "" then
    getUserFatura(phone_number, firstname, function (user)
      local accountId = user and user.id
      FaturaGetBilling(accountId, function (billingg)
        TriggerClientEvent('gcPhone:fatura_getBilling', sourcePlayer, billingg)
      end)
    end)
  else
    FaturaGetBilling(nil, function (billingg)
      TriggerClientEvent('gcPhone:fatura_getBilling', sourcePlayer, billingg)
    end)
  end
end)


RegisterServerEvent("gcPhone:faturapayBill")
AddEventHandler("gcPhone:faturapayBill", function(id, sender, amount, target, sharedAccountName)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE id = @id', {
		['@id'] = id
	}, function(data)

	local xTarget = ESX.GetPlayerFromIdentifier(sender)
	local target = data[1].target
	local target_type = data[1].target_type
	
	if target_type=='player' then
	
	if xTarget ~= nil then	
    if amount ~= nil then
        if xPlayer.getBank() >= amount then	

					MySQL.Async.execute('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeAccountMoney('bank', amount)
						xTarget.addAccountMoney('bank',amount)

						TriggerClientEvent("esx:showNotification", src, "Fatura ödendi $" .. amount)
						TriggerClientEvent("esx:showNotification", sender, "Yeterli paran yok.")
						TriggerClientEvent("esx:showNotification", xTarget.source, "Fatura Ödendi $" .. amount)

					end)
					
				else
					TriggerClientEvent("esx:showNotification", sender, "Yeterli paran yok.")
					TriggerClientEvent("esx:showNotification", src, "Fatura ödendi $" .. amount)


				end

			else
				
				TriggerClientEvent("esx:showNotification", xTarget.source, "Fatura Ödendi of $" .. amount)

			end				
	
    end
	
	
	
	
	else
TriggerEvent('esx_addonaccount:getSharedAccount', target, function(account)	

if xTarget ~= nil then	
    if amount ~= nil then
        if xPlayer.getBank() >= amount then	

					MySQL.Async.execute('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeAccountMoney('bank', amount)
						account.addMoney(amount)

						TriggerClientEvent("esx:showNotification", src, "Fatura ödendi $" .. amount)
						TriggerClientEvent("esx:showNotification", sender, "Yeterli paran yok.")
						TriggerClientEvent("esx:showNotification", xTarget.source, "Fatura Ödendi $" .. amount)

					end)
					
				else
					TriggerClientEvent("esx:showNotification", sender, "Yeterli paran yok.")
					TriggerClientEvent("esx:showNotification", src, "Fatura ödendi $" .. amount)


				end

			else
				
				TriggerClientEvent("esx:showNotification", xTarget.source, "Fatura Ödendi of $" .. amount)

			end				
	
    end
	
end)

end





end)
end)


--====================================================================================
-- EXTRA LEAKS | https://discord.gg/extraleaks
--====================================================================================