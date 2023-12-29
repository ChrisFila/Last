ESX = nil
ESXLoaded = false
TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
    ESXLoaded = true
end)

Citizen.CreateThread(function()
	while true do
		TriggerClientEvent('xr_core:updatePlayerCount', -1, GetNumPlayerIndices())
		Citizen.Wait(2500)
	end
end)