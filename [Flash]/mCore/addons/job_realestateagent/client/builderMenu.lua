--[[
  This file is part of FlashSide RolePlay.

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local previousPos, currentlyVisiting, cat, desc, visitingBucket = nil, false, "realestateagent", "~r~Menu des interactions", 35
local sub = function(str)
    return cat .. "_" .. str
end
local announce = false
local closestPlayer, closestDistance
local builder = { name = nil, price = nil, entry = nil, selectedInterior = 1}
Jobs.list["realestateagent"].openMenu = function()
    if menuIsOpened then
        return
    end

    local interiors = {}
    for k, v in pairs(FlashSideInteriors) do
        interiors[k] = "~o~" .. v.label .. "~s~"
    end

    menuIsOpened = true
    RMenu.Add(cat, sub("main"), RageUI.CreateMenu(nil, desc, nil, nil, "root_cause", "shopui_title_dynasty8"))
    RMenu:Get(cat, sub("main")).Closed = function()end
    RMenu.Add(cat, sub("builder"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), nil, desc, nil, nil, "root_cause", "shopui_title_dynasty8"))
    RMenu:Get(cat, sub("builder")).Closed = function()end
    RageUI.Visible(RMenu:Get(cat, sub("main")), true)
    FlashSide.newThread(function()
        while menuIsOpened and Job.name:lower() == cat do
            local shouldStayOpened = false
            local function tick()
                shouldStayOpened = true
            end
            if builder.entry ~= nil then
                local p = builder.entry
                DrawMarker(22, p.x, p.y, p.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 0, 255, 0, 255, 55555, false, true, 2, false, false, false, false)
            end
            RageUI.IsVisible(RMenu:Get(cat, sub("main")), true, true, true, function()
                tick()

                RageUI.Separator("↓ ~r~Annonces ~s~↓")

                RageUI.ButtonWithStyle("Entreprise ~r~ouverte", nil, { RightLabel = "→→" }, true, function(_, _, s)
                    if s then
                        -- TODO -> Entreprise ouverte
                        FlashSideClientUtils.toServer("FlashSide:Ouvert")
                    end
                end)
                RageUI.ButtonWithStyle("Entreprise ~r~fermée", nil, { RightLabel = "→→" }, true, function(_, _, s)
                    if s then
                        -- TODO -> Entreprise fermée
                        FlashSideClientUtils.toServer("FlashSide:Fermée")
                    end
                end)

                RageUI.Separator("↓ ~r~Gestion des propriétées ~s~↓")

                RageUI.ButtonWithStyle("Créer une propriétée", nil, { RightLabel = "→→" }, true, function(_, _, s)
                end, RMenu:Get(cat, sub("builder")))

            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("builder")), true, true, true, function()
                tick()

                RageUI.Separator("↓ ~r~Valeurs de base ~s~↓")

                RageUI.ButtonWithStyle("Nom de la propriétée" .. FlashSideMenuUtils.valueNotDefault(builder.name), nil, { RightLabel = "~r~Définir ~s~→→" }, true, function(_, _, s)
                    if s then
                        local result = FlashSideMenuUtils.inputBox("Agence immo", "", 20, false)
                        if result ~= nil then
                            builder.name = result
                        end
                    end
                end)
                RageUI.ButtonWithStyle("Prix d'achat" .. FlashSideMenuUtils.valueNotDefault(builder.price, "$"), nil, { RightLabel = "~r~Définir ~s~→→" }, true, function(_, _, s)
                    if s then
                        local result = FlashSideMenuUtils.inputBox("Agence immo", "", 20, true)
                        if result ~= nil then
                            builder.price = result
                        end
                    end
                end)
                RageUI.Separator("↓ ~r~Positions ~s~↓")
                RageUI.ButtonWithStyle("Définir l'entrée" .. FlashSideMenuUtils.okIfDef(builder.entry, false), nil, { RightLabel = "~r~Définir ~s~→→" }, true, function(_, _, s)
                    if s then
                        local pos = GetEntityCoords(PlayerPedId())
                        builder.entry = pos
                    end
                end)
                RageUI.Separator("↓ ~o~Intérieur ~s~↓")
                if not currentlyVisiting then
                    RageUI.List("Intérieur:", interiors, builder.selectedInterior, "~r~Description: ~s~Appuyez sur ~r~[ENTER] ~s~pour visiter la maison", {}, not currentlyVisiting, function(_, a, s, i)
                        builder.selectedInterior = i
                        if a then
                            RenderSprite("RageUI", FlashSideInteriors[builder.selectedInterior].Img, 0, 600, 430, 250, 80)
                        end
                        if s then
                            FlashSideClientUtils.toServer("setBucket", visitingBucket)
                            currentlyVisiting = true
                            previousPos = GetEntityCoords(PlayerPedId())
                            SetEntityCoords(PlayerPedId(), FlashSideInteriors[builder.selectedInterior].interiorEntry.position, false, false, false, false)
                            SetEntityHeading(PlayerPedId(), FlashSideInteriors[builder.selectedInterior].interiorEntry.heading)
                        end
                    end)
                else
                    RageUI.ButtonWithStyle("~r~Arrêter la visite", nil, {}, true, function(_,_,s)
                        if s then
                            FlashSideClientUtils.toServer("setOnPublicBucket")
                            SetEntityCoords(PlayerPedId(), previousPos, false, false, false, false)
                            currentlyVisiting = false
                        end
                    end)
                end
                RageUI.Separator("↓ ~r~Interactions ~s~↓")

                RageUI.Checkbox("~r~Annoncer la mise en vente", nil, announce, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    announce = Checked
                end, function()
                end, function()
                end)
                
                RageUI.ButtonWithStyle("~r~Valider et sauvegarder", nil, {RightLabel = "→→"}, builder.name ~= nil and builder.name ~= "" and builder.entry ~= nil and builder.price ~= nil and tonumber(builder.price) >= 1 and not currentlyVisiting, function(_,_,s)
                    if s then
                        local plyPos = GetEntityCoords(PlayerPedId())
                        local streetHash = Citizen.InvokeNative(0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
                        local street = GetStreetNameFromHashKey(streetHash)
                        FlashSideClientUtils.toServer("saveProperty", builder, street, announce)
                        ESX.ShowNotification("~o~Création de la propriétée en cours...")
                        shouldStayOpened = false
                    end
                end)

            end, function()
            end)
            if not shouldStayOpened and menuIsOpened then
                menuIsOpened = false
            end
            Wait(0)
        end
        RMenu:Delete(cat, sub("main"))
        RMenu:Delete(cat, sub("builder"))
    end)
end