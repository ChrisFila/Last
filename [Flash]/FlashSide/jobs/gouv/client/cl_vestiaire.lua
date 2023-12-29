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

function applySkinSpecificGouv(infos)
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

function VestiaireGouv()
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

                RageUI.Button("Reprendre sa tenue : ~r~Civil", nil,{RightLabel = "→"}, true,{
                    onSelected = function()
                      ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin) TriggerEvent('skinchanger:loadSkin', skin) end)
                      SetPedArmour(PlayerPedId(), 0)
                    end
                })
  

                
              RageUI.Separator("↓ ~r~Équipement ~s~↓")

              RageUI.Button("Déposer son : ~r~Équipement", nil,{RightLabel = "→"}, true,{
                onSelected = function()
                    TriggerServerEvent("vestaiaire:déposer")
              end
              })

              RageUI.Button("S'équiper d'un : ~r~Équipement", nil,{RightLabel = "→"}, true,{
                onSelected = function()
                    TriggerServerEvent("vestaiaire:equipement")
              end
              })


                RageUI.Separator("↓ ~r~Tenues de service ~s~↓")
                for _,infos in pairs(cfg_gouv.Gouvernement.clothes.grades) do
                  RageUI.Button(infos.label, nil, {RightLabel = ">"}, ESX.PlayerData.job.grade >= infos.minimum_grade, {
                    onSelected = function()
                        applySkinSpecificGouv(infos)
                      end
                    })

            


                end
            end)
          Wait(0)
         end
      end)
   end
end

