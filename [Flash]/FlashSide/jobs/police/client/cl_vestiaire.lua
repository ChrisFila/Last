Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

-- Function --

function applySkinSpecificPolice(infos)
	TriggerEvent('skinchanger:getSkin', function(skin)
		local uniformObject
		if skin.sex == 0 then
			uniformObject = infos.variations.male
		else
			uniformObject = infos.variations.female
		end
		if uniformObject then
			TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
		end

		infos.onEquip()
	end)
end

-- MENU FUNCTION --

local open = false 
local mainMenu6 = RageUI.CreateMenu('', '~r~Ouverture du cassier..')
mainMenu6.Display.Header = true 
mainMenu6.Closed = function()
  open = false
end

function VestiairePolice()
     if open then 
         open = false
         RageUI.Visible(mainMenu6, false)
         return
     else
         open = true 
         RageUI.Visible(mainMenu6, true)
         CreateThread(function()
         while open do 
            RageUI.IsVisible(mainMenu6,function() 

              RageUI.Separator("↓ ~r~Tenues Civil ~s~↓")
			
              for _,infos in pairs(cfg_police.PoliceCloak.clothes.specials) do
                RageUI.Button(infos.label, nil, {RightLabel = ">"}, true, {
                onSelected = function()
                    servicepolice = false
                    local info = 'fin'
                    TriggerServerEvent('police:PriseEtFinservice', info)
                    applySkinSpecificPolice(infos)
                  end
                })	
              end

                RageUI.Separator("↓ ~r~Tenues de service ~s~↓")

                for _,infos in pairs(cfg_police.PoliceCloak.clothes.grades) do
                  RageUI.Button(infos.label, nil, {RightLabel = ">"}, ESX.PlayerData.job.grade >= infos.minimum_grade, {
                    onSelected = function()
                        servicepolice = true
                        local info = 'prise'
                        TriggerServerEvent('police:PriseEtFinservice', info)
                        applySkinSpecificPolice(infos)
                      end
                    })
                end

            end)
          Wait(0)
         end
      end)
   end
end

Citizen.CreateThread(function()
  while true do
  local wait = 750
      if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
    for k in pairs(cfg_police.Position.Vestaire) do
              local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
              local pos = cfg_police.Position.Vestaire
              local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

              if dist <= cfg_police.MarkerDistance then
                  wait = 0
                  DrawMarker(cfg_police.MarkerType, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, cfg_police.MarkerSizeLargeur, cfg_police.MarkerSizeEpaisseur, cfg_police.MarkerSizeHauteur, cfg_police.MarkerColorR, cfg_police.MarkerColorG, cfg_police.MarkerColorB, cfg_police.MarkerOpacite, cfg_police.MarkerSaute, true, p19, cfg_police.MarkerTourne)  
              end

              if dist <= 1.0 then
                  wait = 0
                  Visual.Subtitle(cfg_police.TextVestaire, 1)
                  if IsControlJustPressed(1,51) then
                    VestiairePolice()
                  end
              end
          end
  end
  Citizen.Wait(wait)
  end
end)