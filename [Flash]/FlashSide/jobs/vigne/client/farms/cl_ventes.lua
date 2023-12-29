--credit : ^SAM^#0001 pour la src du RageUI V2 

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(5000)
	end
end)

--- MENU ---

local open = false 
local mainMenu = RageUI.CreateMenu('', '~r~Vigne')
mainMenu.Display.Header = true 
mainMenu.Closed = function()
  open = false
end

--- FUNCTION OPENMENU ---

function VentesMeca()
	if open then 
		open = false
		RageUI.Visible(mainMenu, false)
		return
	else
		open = true 
		RageUI.Visible(mainMenu, true)
		CreateThread(function()
		while open do 
		   RageUI.IsVisible(mainMenu,function() 

			RageUI.Button("Vendre Jus de raisin", nil, {RightLabel = "~r~40$"}, true , {
				onSelected = function()
                    TriggerServerEvent('selljusraisin')
				end
			}, subMenu)

			RageUI.Button("Vendre Grand Cru", nil, {RightLabel = "~r~70$"}, true , {
				onSelected = function()
                    TriggerServerEvent('sellgrandcru')
				end
			}, subMenu)

		   end)
		Wait(0)
	   end
	end)
 end
end
		-------------------------------------------------------------------------------------------------------

VigenPosFarmVente = {
	{x = 359.38, y = -1109.02, z = 29.41} 
}

Citizen.CreateThread(function()
    while true do

      local wait = 750

        for k in pairs(VigenPosFarmVente) do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' then 
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, VigenPosFarmVente[k].x, VigenPosFarmVente[k].y, VigenPosFarmVente[k].z)

            if dist <= 4.0 then
            wait = 0
			DrawMarker(22, 359.38, -1109.02, 29.41, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 1.0, 1.0, 1.0, 136, 14, 79, 255, true, true, p19, true)   

        
            if dist <= 10.0 then
               wait = 0
                Visual.Subtitle("Appuyer sur ~r~[E]~s~ pour ~r~intéragir", 1) 
                if IsControlJustPressed(1,51) then
					VentesMeca()
            end
        end
    end
    end
    Citizen.Wait(wait)
    end
end
end)
