ESX.RegisterUsableItem('ciseaux', function(source)
	TriggerClientEvent('altix:useciseaux', source)
end)

RegisterNetEvent('altix:haircut', function(target)
	TriggerClientEvent('altix:haircut', target, source)
end)