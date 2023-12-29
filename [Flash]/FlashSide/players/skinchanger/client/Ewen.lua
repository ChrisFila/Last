local open = false

local indexface2 = {}
local comp = {}
local isCameraActive = false
local FirstSpawn, zoomOffset, camOffset, heading = true, 0.0, 0.0, 90.0

function RefreshData()
    TriggerEvent("skinchanger:getData", function(comp_, max)
        open = true
        comp = comp_
        for k,v in pairs(comp) do
            if v.value ~= 0 then
                indexface2[v.name] = v.value
            else
                indexface2[v.name] = 1
            end
            for i,value in pairs(max) do
                if i == v.name then
                    comp[k].max = value
                    comp[k].table = {}
                    for i = 0, value do
                        table.insert(comp[k].table, i)
                    end
                    break
                end
            end
        end
    end)
end

function SkinChanger()
    local face = RageUI.CreateMenu("", "Faite votre personnage")
    RageUI.Visible(face, not RageUI.Visible(face))
    zoomOffset = comp[1].zoomOffset
    camOffset = comp[1].camOffset
	FreezeEntityPosition(GetPlayerPed(-1), true)
    while face do
        Citizen.Wait(0)
        RageUI.IsVisible(face, function()
            for k,v in pairs(comp) do
                if v.table[1] ~= nil then
                    RageUI.List(v.label, v.table, indexface2[v.name], nil, {}, true, {
                        onListChange = function(indexface, Items)
                            indexface2[v.name] = indexface;
                            TriggerEvent("skinchanger:change", v.name, indexface - 1)
                            if v.componentId ~= nil then
                                SetPedComponentVariation(GetPlayerPed(-1), v.componentId, indexface - 1, 0, 2)
                            end
                        end,
                        onSelected = function(indexface, Items)
							openValidate()
                        end,
                        onActive = function()
                            zoomOffset = comp[k].zoomOffset
                            camOffset = comp[k].camOffset
                        end,
                    })
                end
            end
        end, function()
    end)
        if not RageUI.Visible(face) then
			FreezeEntityPosition(GetPlayerPed(-1), false)
            face = RMenu:DeleteType('face', true)
        end
    end
end

function openValidate()
    local face = RageUI.CreateMenu("", "Faite votre personnage")
    RageUI.Visible(face, not RageUI.Visible(face))
    while face do
        Citizen.Wait(0)
        RageUI.IsVisible(face, function()
			RageUI.Button('Continuer de modifier mon personnage', nil, {}, true, {
				onSelected = function() 
					RefreshData()
					SkinChanger()
				end
			});
			RageUI.Button('~r~Validé le personnage', nil, {}, true, {
				onSelected = function() 
					TriggerEvent('skinchanger:getSkin', function(skin)
						TriggerServerEvent('esx_skin:save', skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)
					RageUI.CloseAll()
					ESX.ShowNotification('FlashSide ~w~~n~Bienvenue sur le Serveur ~n~Bon jeu à vous !')
				end
			});
        end, function()
    end)
        if not RageUI.Visible(face) then
			FreezeEntityPosition(GetPlayerPed(-1), false)
            face = RMenu:DeleteType('face', true)
        end
    end
end

RegisterNetEvent('ewen:openSkinMenu')
AddEventHandler('ewen:openSkinMenu', function()
    RefreshData()
    SkinChanger()
end)