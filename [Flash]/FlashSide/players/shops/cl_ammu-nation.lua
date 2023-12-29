local AmmuItem = {
    {name = 'weapon_bat', label = 'Batte de Baseball', price = 15000},
    {name = 'weapon_knuckle', label = 'Poing Américain', price = 15000},
    {name = 'weapon_knife', label = 'Couteau', price = 15000},
    {name = 'weapon_battleaxe', label = 'Hache de Combat', price = 15000},
    {name = 'weapon_poolcue', label = 'Queue de billard', price = 15000}
}

local AmmuItemVip = {
    {name = 'weapon_snspistol', label = 'Pistolet SNS - ~r~Vip', price = 50000},
    {name = 'weapon_pistol', label = 'Berreta - ~r~Vip', price = 75000},
    {name = 'weapon_pistol50', label = 'Pistolet 50mm - ~r~Vip', price = 50000},
    {name = 'weapon_revolver', label = 'Rvolver - ~r~Vip', price = 75000},
}

local MunitionsItem = {
    {name = 'clip', label = 'Chargeur', price = 180},
}

function AmmuNation()
    if exports.FlashSide:GetLevel() >= 5 then
        local menu = RageUI.CreateMenu("", "Articles disponibles :")

        RageUI.Visible(menu, not RageUI.Visible(menu))

        while menu do
            Wait(0)
            RageUI.IsVisible(menu, function()

            RageUI.Button('Arme Blanche', nil, {RightLabel = ">"}, true, {
                onSelected = function()
                    OpenArmeBlanche()
                end
            })
            if GetVIP() then 
                RageUI.Button('Arme ~r~Vip', nil, {RightLabel = ">"}, true, {
                    onSelected = function()
                        OpenArmeVip()
                    end
                })
            end
            RageUI.Button('Munitions', nil, {RightLabel = ">"}, true, {
                onSelected = function()
                    OpenMunitions()
                end
            })
            end, function()
            end)

            if not RageUI.Visible(menu) then
                menu = RMenu:DeleteType('menu', true)
            end
        end
    else
        ESX.ShowNotification('FlashSide~w~RP~w~ ~n~Vous devez être niveau 3 afin d\'acceder à l\'armurerie')
    end
end

function OpenArmeVip()
    local menu = RageUI.CreateMenu("", "Articles disponibles :")

    RageUI.Visible(menu, not RageUI.Visible(menu))

    while menu do
        Wait(0)
        RageUI.IsVisible(menu, function()
            for k,v in pairs(AmmuItemVip) do
                RageUI.Button(v.label, nil, {RightLabel = "~r~".. v.price.."$"}, true, {
                    onSelected = function()
                        OpenMenuPaiement(v.name, v.price)
                    end
                })
             end
        end, function()
        end)

        if not RageUI.Visible(menu) then
            menu = RMenu:DeleteType('menu', true)
        end
    end
end

function OpenArmeBlanche()
    local menu = RageUI.CreateMenu("", "Articles disponibles :")

    RageUI.Visible(menu, not RageUI.Visible(menu))

    while menu do
        Wait(0)
        RageUI.IsVisible(menu, function()
        for k,v in pairs(AmmuItem) do
            RageUI.Button(v.label, nil, {RightLabel = "~r~".. v.price.."$"}, true, {
                onSelected = function()
                    OpenMenuPaiement(v.name, v.price)
                end
            })
        end
        end, function()
        end)

        if not RageUI.Visible(menu) then
            menu = RMenu:DeleteType('menu', true)
        end
    end
end

function OpenMunitions()
    local menu = RageUI.CreateMenu("", "Articles disponibles :")

    RageUI.Visible(menu, not RageUI.Visible(menu))

    while menu do
        Wait(0)
        RageUI.IsVisible(menu, function()
        for k,v in pairs(MunitionsItem) do
            RageUI.Button(v.label, nil, {RightLabel = "~r~".. v.price.."$"}, true, {
                onSelected = function()
                    OpenMenuPaiement(v.name, v.price)
                end
            })
        end
        end, function()
        end)

        if not RageUI.Visible(menu) then
            menu = RMenu:DeleteType('menu', true)
        end
    end
end

RegisterNetEvent('esx_clip:clipcli')
AddEventHandler('esx_clip:clipcli', function()
  ped = GetPlayerPed(-1)
  if IsPedArmed(ped, 4) then
    hash=GetSelectedPedWeapon(ped)
    if hash~=nil then
      TriggerServerEvent('esx_clip:remove')
      AddAmmoToPed(GetPlayerPed(-1), hash,25)
      ESX.ShowNotification("tu as utilisé un chargeur")
    else
      ESX.ShowNotification("tu n'as pas d'arme en main")
    end
  else
    ESX.ShowNotification("ce type de munition ne convient pas")
  end
end)