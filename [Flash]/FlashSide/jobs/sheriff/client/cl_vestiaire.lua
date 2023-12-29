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

function applySkinSpecificsheriff(infos)
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

function Vestiairesheriff()
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

              
              RageUI.Separator("↓ ~r~Equipement ~s~↓")

              RageUI.Separator("↓ ~r~Tenues Civil ~s~↓")
			
              for _,infos in pairs(cfg_sheriff.sheriffCloak.clothes.specials) do
                RageUI.Button(infos.label, nil, {RightLabel = ">"}, ESX.PlayerData.job.grade >= infos.minimum_grade, {
                onSelected = function()
                     applySkinSpecificsheriff(infos)
                  end
                })	

                RageUI.Separator("↓ ~r~Tenues de service ~s~↓")
                for _,infos in pairs(cfg_sheriff.sheriffCloak.clothes.grades) do
                  RageUI.Button(infos.label, nil, {RightLabel = ">"}, ESX.PlayerData.job.grade >= infos.minimum_grade, {
                    onSelected = function()
                        applySkinSpecificsheriff(infos)
                      end
                    })

            


                  end
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
      if ESX.PlayerData.job and ESX.PlayerData.job.name == 'sheriff' then
    for k in pairs(cfg_sheriff.Position.Vestaire) do
              local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
              local pos = cfg_sheriff.Position.Vestaire
              local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

              if dist <= cfg_sheriff.MarkerDistance then
                  wait = 0
                  DrawMarker(cfg_sheriff.MarkerType, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, cfg_sheriff.MarkerSizeLargeur, cfg_sheriff.MarkerSizeEpaisseur, cfg_sheriff.MarkerSizeHauteur, cfg_sheriff.MarkerColorR, cfg_sheriff.MarkerColorG, cfg_sheriff.MarkerColorB, cfg_sheriff.MarkerOpacite, cfg_sheriff.MarkerSaute, true, p19, cfg_sheriff.MarkerTourne)  
              end

              if dist <= 1.0 then
                  wait = 0
                  Visual.Subtitle(cfg_sheriff.TextVestaire, 1)
                  if IsControlJustPressed(1,51) then
                    Vestiairesheriff()
                  end
              end
          end
  end
  Citizen.Wait(wait)
  end
end)