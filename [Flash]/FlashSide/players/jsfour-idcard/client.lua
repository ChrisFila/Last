local open = false

-- Open ID card
RegisterNetEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function( data, type )
	open = true
	SendNUIMessage({
		action = "open",
		array  = data,
		type   = type
	})
end)

-- Key events
RegisterCommand("jsfour-idcard_close", function()
	SendNUIMessage({
		action = 'close'
	})
	open = false
end, false)
RegisterKeyMapping("jsfour-idcard_close", "Fermer les card", "keyboard", 'BACK')
