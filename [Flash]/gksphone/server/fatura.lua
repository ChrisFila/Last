

ESX.RegisterServerCallback('gksphone:getbilling', function(source, cb)
	local e=ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier',{["@identifier"]=e.identifier},function(result)
		local billingg = {}
		for i=1, #result, 1 do
			table.insert(billingg, {id = result[i].id, label = result[i].label, sender=result[i].sender, target=result[i].target, amount=result[i].amount}) 
		end
		cb(billingg)
	end)
end)




RegisterServerEvent("gksphone:faturapayBill")
AddEventHandler("gksphone:faturapayBill", function(id, sender, amount, target, sharedAccountName)
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
        		if xPlayer.getAccount('bank').money >= amount then	

					MySQL.Async.execute('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeAccountMoney('bank', amount)
						xTarget.addAccountMoney('bank',amount)
						TriggerClientEvent('updatebilling', xTarget.source,src)

						TriggerClientEvent('gksphone:notifi', src, {title = 'Billing', message = _U('bill_paid') ..amount, img= '/html/static/img/icons/logo.png' })
						TriggerClientEvent('gksphone:notifi', xTarget.source, {title = 'Billing', message = _U('bill_paid') ..amount, img= '/html/static/img/icons/logo.png' })

					end)
					
				else

			
					TriggerClientEvent('gksphone:notifi', src, {title = 'Billing', message = _U('bill_nocash') .. amount, img= '/html/static/img/icons/logo.png' })
	


				end

			else

				TriggerClientEvent('gksphone:notifi', src, {title = 'Billing', message = _U('bill_nocash') ..amount, img= '/html/static/img/icons/logo.png' })
			

			end				
	
    end
	
	
	
	
	else
TriggerEvent('esx_addonaccount:getSharedAccount', target, function(account)	

        if xPlayer.getAccount("bank").money >= amount then	

					MySQL.Async.execute('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeAccountMoney('bank', amount)
						account.addMoney(amount)
						TriggerClientEvent('updatebilling', xPlayer.source, id)

						TriggerClientEvent('gksphone:notifi', src, {title = 'Billing', message = _U('bill_paid') ..amount, img= '/html/static/img/icons/logo.png' })
						
						local jobName = target:gsub("society_", "")
						local test = getSource(jobName)

						for i=1, #test, 1 do
							TriggerClientEvent('gksphone:notifi', test[i].id, {title = 'Billing', message = _U('bill_paid') ..amount, img= '/html/static/img/icons/logo.png' })
						end

					end)
					
				else
					TriggerClientEvent('gksphone:notifi', src, {title = 'Billing', message = _U('bill_nocash') .. amount, img= '/html/static/img/icons/logo.png' })
					
				end

end)

end





end)
end)

