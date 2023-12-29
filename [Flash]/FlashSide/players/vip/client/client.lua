
------------- CONFIG PED & PROPS

local Couldown = false

local pedmodel = { -- CONFIG PED NAME = AFFICHAGE / MODEL = MODEL DU PED POUR LE SPAWN / PICTUREMODEL = NOM DU STREAM DE LA PHOTO
    {name = "Personnage Homme #1", model = "a_m_y_downtown_01", picturemodel = 'tonton'},
    {name = "Personnage Homme #2", model = "u_m_y_babyd", picturemodel = 'BabyD'},
    {name = "Personnage Homme #3", model = "ig_priest", picturemodel = 'priest'},
    {name = "Personnage Homme #4", model = "u_m_y_prisoner_01", picturemodel = 'Prisoner01'},
    {name = "Personnage Homme #5", model = "s_m_y_prisoner_01", picturemodel = 'Prisoner01SMY'},
    {name = "Personnage Homme #6", model = "ig_rashcosvki", picturemodel = 'rashkovsky'},
    {name = "Personnage Homme #7", model = "u_m_y_militarybum", picturemodel = 'militarybum'},
    {name = "Personnage Homme #8", model = "mp_m_waremech_01", picturemodel = 'mp_m_waremech_01'},
    {name = "Personnage Homme #9", model = "mp_m_weapexp_01", picturemodel = 'Mp_m_weapexp_01'},
    {name = "Personnage Homme #10", model = "mp_m_weapwork_01", picturemodel = 'Mp_m_weapwork_01'},
    {name = "Personnage Homme #11", model = "ig_benny", picturemodel = 'Benny'},
    {name = "Personnage Homme #12", model = "s_m_y_dealer_01", picturemodel = 'Dealer01SMY'},
    {name = "Personnage Homme #13", model = "ig_lestercrest", picturemodel = 'lestercrest'},
    {name = "Personnage Homme #14", model = "g_m_m_chicold_01", picturemodel = 'BabyD'},
    {name = "Personnage Homme #15", model = "g_m_m_chicold_01", picturemodel = 'ChiCold01GMM'},
    {name = "Personnage Homme Ballas #1", model = "g_m_y_ballaeast_01", picturemodel = 'BallaEast01GMY'},
    {name = "Personnage Homme Ballas #2", model = "g_m_y_ballaorig_01", picturemodel = 'BallaOrig01GMY'},
    {name = "Personnage Homme Ballas #3", model = "ig_ballasog", picturemodel = 'BallasOG'},
    {name = "Personnage Homme Ballas #4", model = "g_m_y_ballasout_01", picturemodel = 'BallaSout01GMY'},
    {name = "Personnage Homme Families #1", model = "g_m_y_famca_01", picturemodel = 'famca01'},
    {name = "Personnage Homme Families #2", model = "g_m_y_famdnf_01", picturemodel = 'famdnf01'},
    {name = "Personnage Homme Families #3", model = "g_m_y_famfor_01", picturemodel = 'famfor01'},
    {name = "Personnage Femme Families #1", model = "g_f_y_families_01", picturemodel = 'families01'},
    {name = "Personnage Homme Marabunta #1", model = "g_m_y_salvaboss_01", picturemodel = 'SalvaBoss01'},
    {name = "Personnage Homme Marabunta #2", model = "g_m_y_salvagoon_01", picturemodel = 'SalvaGoon01'},
    {name = "Personnage Homme Marabunta #3", model = "g_m_y_salvagoon_02", picturemodel = 'SalvaGoon02'},
    {name = "Personnage Homme Marabunta #4", model = "g_m_y_salvagoon_03", picturemodel = 'SalvaGoon03'},
    {name = "Personnage Homme Vagos #1", model = "g_m_y_mexgoon_01", picturemodel = 'mexgoon01'},
    {name = "Personnage Homme Vagos #2", model = "g_m_y_mexgoon_02", picturemodel = 'mexgoon02'},
    {name = "Personnage Homme Vagos #3", model = "g_m_y_mexgoon_03", picturemodel = 'mexgoon03'},
    {name = "Personnage Homme #16", model = "a_m_m_mexlabor_01", picturemodel = 'mexlabor01'},
    {name = "Personnage Homme #17", model = "a_m_y_mexthug_01", picturemodel = 'mexthug01'},
    {name = "Personnage Homme #18", model = "g_m_m_mexboss_01", picturemodel = 'mexboss01'},
    {name = "Personnage Homme #19", model = "g_m_m_mexboss_02", picturemodel = 'mexboss02'},
    {name = "Personnage Homme #20", model = "a_m_m_mexcntry_01", picturemodel = 'mexcntry01'},
    {name = "Personnage Homme #21", model = "g_m_y_mexgang_01", picturemodel = 'mexgang01'},
    {name = "Personnage Homme #22", model = "ig_ramp_mex", picturemodel = 'rampmex'},
    {name = "Personnage Homme #23", model = "a_m_m_eastsa_01", picturemodel = 'EastSA01AMM'},
    {name = "Personnage Homme #24", model = "a_m_y_eastsa_01", picturemodel = 'Eastsa01AMY'},
    {name = "Personnage Homme #25", model = "a_m_m_eastsa_02", picturemodel = 'EastSa02AMM'},
    {name = "Personnage Femme #1", model = "a_f_y_eastsa_03", picturemodel = 'eastsa03afy'},
    {name = "Personnage Femme #2", model = "a_f_y_eastsa_02", picturemodel = 'EastSA02AFY'},
    {name = "Personnage Homme #26", model = "a_m_m_beach_01", picturemodel = 'Beach01AMM'},
    {name = "Personnage Homme #27", model = "a_m_m_beach_02", picturemodel = 'Beach02AMM'},
    {name = "Personnage Homme #28", model = "a_m_o_beach_01", picturemodel = 'Beach01AMO'},
    {name = "Personnage Homme #29", model = "a_m_y_beach_01", picturemodel = 'Beach01AMY'},
    {name = "Personnage Homme #30", model = "a_m_y_beach_02", picturemodel = 'Beach02AMY'},
    {name = "Personnage Femme #3", model = "s_f_y_baywatch_01", picturemodel = 'BayWatch01SFY'},
    {name = "Personnage Femme #4", model = "a_f_m_beach_01", picturemodel = 'Beach01AFM'},
    {name = "Personnage Homme #31", model = "s_m_y_doorman_01", picturemodel = 'Doorman01SMY'},
    {name = "Personnage Homme #32", model = "s_m_y_clown_01", picturemodel = 'Clown01SMY'},
    {name = "Personnage Femme #5", model = "a_f_m_bevhills_01", picturemodel = 'BevHills01AFM'},
    {name = "Personnage Femme #6", model = "mp_f_boatstaff_01", picturemodel = 'BoatStaff01F'},
    {name = "Personnage Femme #7", model = "a_f_y_bevhills_01", picturemodel = 'Bevhills01AFY'},
    {name = "Personnage Femme #8", model = "a_f_m_bevhills_02", picturemodel = 'BevHills02AFM'},
    {name = "Personnage Femme #9", model = "a_f_y_bevhills_02", picturemodel = 'BevHills02AFY'},
    {name = "Personnage Femme #10", model = "a_f_y_bevhills_03", picturemodel = 'Bevhills03AFY'},
    {name = "Personnage Femme #11", model = "a_f_y_bevhills_04", picturemodel = 'BevHills04AFY'},
    {name = "Personnage Femme #12", model = "u_f_y_bikerchic", picturemodel = 'BikerChic'},
}

local itemIndex = 1
local legalprops = { ---- Props catégorie légal / nameprops = 'Nom visible par le joueur' / modelprops = 'Model_du_props'
    {nameprops = 'Chaise', modelprops = 'apa_mp_h_din_chair_12'},
    {nameprops = 'Carton', modelprops = 'prop_cardbordbox_04a'},
    {nameprops = 'Sac', modelprops = 'prop_cs_heist_bag_02'},
    {nameprops = 'Table 1', modelprops = 'prop_rub_table_02'},
    {nameprops = 'Table 2', modelprops = 'prop_table_04'},
    {nameprops = 'Table 3', modelprops = 'bkr_prop_weed_table_01b'},
    {nameprops = 'Chaise 1', modelprops = 'bkr_prop_clubhouse_chair_01'},
    {nameprops = 'Chaise 2', modelprops = 'bkr_prop_weed_chair_01a'},
    {nameprops = 'Chaise de Pêche', modelprops = 'hei_prop_hei_skid_chair'},
    {nameprops = 'Chaise de Bureau', modelprops = 'bkr_prop_clubhouse_offchair_01a'},
    {nameprops = 'Canapé', modelprops = 'v_tre_sofa_mess_c_s'},
    {nameprops = 'Canapé 2', modelprops = 'v_res_tre_sofa_mess_a'},
    {nameprops = 'Ordinateur', modelprops = 'bkr_prop_clubhouse_laptop_01a'},
    {nameprops = 'Lit', modelprops = 'gr_prop_bunker_bed_01'},
    {nameprops = 'Outils', modelprops = 'prop_cs_trolley_01'},
    {nameprops = 'Outils de mécanique', modelprops = 'prop_carcreeper'},
    {nameprops = 'Sac de sport', modelprops = 'prop_cs_heist_bag_02'},
    {nameprops = 'Trousse médical 2', modelprops = 'xm_prop_x17_bag_med_01a'},
}


local illegalprops = { ---- Props catégorie illégal / nameprops = 'Nom visible par le joueur' / modelprops = 'Model_du_props'
    {nameprops = 'Bloque de cocaïne', modelprops = 'bkr_prop_coke_block_01a'},
    {nameprops = 'Bouteille de cocaïne', modelprops = 'bkr_prop_coke_bottle_01a'},
    {nameprops = 'Balance', modelprops = 'bkr_prop_coke_scale_01'},
    {nameprops = 'Table cocaine', modelprops = 'bkr_prop_coke_table01a'},
    {nameprops = 'Caisse', modelprops = 'bkr_prop_crate_set_01a'},
    {nameprops = 'Pot Weed 2', modelprops = 'bkr_prop_weed_bucket_01d'},
    {nameprops = 'Cocaine', modelprops = 'bkr_prop_coke_block_01a'},
    {nameprops = 'Acétone', modelprops = 'bkr_prop_meth_acetone'},
    {nameprops = 'Bidon', modelprops = 'bkr_prop_meth_ammonia'},
    {nameprops = 'Lithium', modelprops = 'bkr_prop_meth_lithium'},
    {nameprops = 'Packet de weed', modelprops = 'bkr_prop_weed_bigbag_03a'},
    {nameprops = 'Packet de weed Ouvert', modelprops = 'bkr_prop_weed_bigbag_open_01a'},
    {nameprops = 'Chanvre', modelprops = 'bkr_prop_weed_lrg_01b'},
    {nameprops =  'Weed séchée', modelprops = 'bkr_prop_weed_drying_01a'},
    {nameprops = 'Sac de weed', modelprops = 'bkr_prop_weed_bigbag_03a'},
    {nameprops = 'Block de coke', modelprops = 'bkr_prop_coke_cut_01'},
    {nameprops = 'Weed', modelprops = 'bkr_prop_weed_01_small_01b'},
    {nameprops = 'Malette d\'armes', modelprops = 'bkr_prop_biker_gcase_s'},
    {nameprops = 'Caisse d\'armes lourdes', modelprops = 'ex_office_swag_guns04'},
    {nameprops = 'Caisse Fermée', modelprops = 'ex_prop_adv_case_sm_03'},
    {nameprops = 'Caisse de chargeurs', modelprops = 'gr_prop_gr_crate_mag_01a'},
}




------------- SCRIPT




ESX, vipLevel, isMenuActive = nil, 0, false

function getBaseSkin()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        local isMale = skin.sex == 0
        TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
                TriggerEvent('esx:restoreLoadout')
            end)
        end)

    end)
end

Citizen.CreateThread(function()
    TriggerEvent("esx:getSharedObject", function(obj)
        ESX = obj
    end)
    Citizen.Wait(10)
end)


object = {}
function OpenPedsMenu()
local OpenedPedsMenu = false
local PedsMenu = RageUI.CreateMenu("", "Merci de soutenir FlashSide")
local PedsSubMenu = RageUI.CreateSubMenu(PedsMenu, "", "Peds disponibles")
local PropsSubMenu = RageUI.CreateSubMenu(PedsMenu, "", "Props disponibles")
local DeletePropsSubMenu = RageUI.CreateSubMenu(PedsMenu, "", "Suppression props")
local PedsSubCusMenu = RageUI.CreateSubMenu(PedsMenu, "", "Personnalisation")

local Options = {
    List1 = 1
}

local Customs = {
    List1 = 1,
    List2 = 1,
    List4 = 1,
    List5 = 1,
    List6 = 1,
    List7 = 1, 
    List8 = 1
}




PedsMenu.Closable = true
PedsMenu:DisplayHeader(true)
PedsSubMenu:DisplayHeader(true)
PropsSubMenu:DisplayHeader(true)

    if OpenedPedsMenu then
        OpenedPedsMenu = false
        RageUI.Visible(PedsMenu, false)
        return;
    else
        OpenedPedsMenu = true
        RageUI.Visible(PedsMenu, true)
        CreateThread(function()
            while OpenedPedsMenu do
                Wait(1.0)
                RageUI.IsVisible(PedsMenu, function()
                    local ped = GetPlayerPed(-1)
                    local playername = GetPlayerName(PlayerId())

                    RageUI.Separator('~r~↓ Vos Informations ↓')

                        local viptext = GetVIP() == 1 or GetVIP() == true and '~o~Premium' or 'Aucun'
                        RageUI.Separator('VIP : '..viptext)

                        RageUI.Separator('~r~↓ Nos catégories ↓')

                        RageUI.Button("Liste des peds", nil, {RightLabel = "→→"}, true, {
                        }, PedsSubMenu);
                        RageUI.Button("Personnalisation", nil, {RightLabel = "→→"}, true, {
                        }, PedsSubCusMenu);

                        --RageUI.Button("Liste des props", nil, {RightLabel = "→→"}, true, {
                        --}, PropsSubMenu);

                        RageUI.Button("Supprimer les props", nil, {RightLabel = "→→"}, true, {
                        }, DeletePropsSubMenu);
                            
                        --RageUI.Button("Full custom vehicule", nil, {RightLabel = "→→"}, not Couldown, {
                            --onSelected = function()
                                --if IsPedSittingInAnyVehicle(PlayerPedId()) then
                                   -- local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                    --VehicleCustom(NetworkGetNetworkIdFromEntity(vehicle))
                                --else
                                    --ESX.ShowNotification('~r~Tu dois attendre 6 heurs BG')
                                --end
                            --end 
                        --});

                        RageUI.List("Options", {"Reset personnage", "Choisir manuellement", "Informations"}, Options.List1, nil, {}, true, {
                            onListChange = function(i, Item)
                                Options.List1 = i;
                            end,
                            onSelected = function(i, Item)
                                if Options.List1 == 2 then
                                    Citizen.Wait(200)
                                    InputPed()
                                end
                                if Options.List1 == 1 then
                                    ResetPed()
                                    Citizen.Wait(200)
                                end
                                if Options.List1 == 3 then
                                    ESX.ShowAdvancedNotification("FlashSide", "~r~Menu VIP","Plus d'informations sur Discord !\n~r~discord.gg/FlashSide", "CHAR_SEALIFE", 2) 
                                    RageUI.CloseAll()
                                end
                            end,
                        })
                end)

                RageUI.IsVisible(PedsSubCusMenu, function ()
                    local ped = GetPlayerPed(-1)

                    RageUI.List("Visage", {"1", "2", "3"}, Customs.List1, nil, {}, true, {
                        onListChange = function(i, Item)
                            Customs.List1 = i;
                        end,
                        onActive = function()
                            if Customs.List1 == 1 then
                                SetCus(ped, 0, 0, 0, 0)
                            end
                            if Customs.List1 == 2 then
                                SetCus(ped, 0, 0, 1, 0)
                            end
                            if Customs.List1 == 3 then
                                SetCus(ped, 0, 1, 1, 0)
                            end
                        end, 
					})

                    RageUI.List("Cheveux", {"1", "2", "3", "4"}, Customs.List2, nil, {}, true, {
                        onListChange = function(i, Item)
                            Customs.List2 = i;
                        end,
                        onActive = function()
                            if Customs.List2 == 1 then
                                SetCus(ped, 2, 0, 0, 0)
                            end
                            if Customs.List2 == 2 then
                                SetCus(ped, 2, 1, 1, 0)
                            end
                            if Customs.List2 == 3 then
                                SetCus(ped, 2, 2, 1, 0)
                            end
                            if Customs.List2 == 4 then
                                SetCus(ped, 2, 3, 1, 0)
                            end
                        end, 
					})

                    RageUI.List("Haut", {"1", "2", "3", "4", "5", "6"}, Customs.List4, nil, {}, true, {
                        onListChange = function(i, Item)
                            Customs.List4 = i;
                        end,
                        onActive = function()
                            if Customs.List4 == 1 then
                                SetCus(ped, 3, 0, 0, 0)
                            end
                            if Customs.List4 == 2 then
                                SetCus(ped, 3, 0, 1, 0)
                            end
                            if Customs.List4 == 3 then
                                SetCus(ped, 3, 0, 2, 0)
                            end
                            if Customs.List4 == 4 then
                                SetCus(ped, 3, 1, 0, 0)
                            end
                            if Customs.List4 == 5 then
                                SetCus(ped, 3, 1, 1, 0)
                            end
                            if Customs.List4 == 6 then
                                SetCus(ped, 3, 1, 2, 0)
                            end
                        end, 
					})

                    RageUI.List("Bas", {"1", "2", "3", "4"}, Customs.List5, nil, {}, true, {
                        onListChange = function(i, Item)
                            Customs.List5 = i;
                        end,
                        onActive = function()
                            if Customs.List5 == 1 then
                                SetCus(ped, 4, 0, 0, 0)
                            end
                            if Customs.List5 == 2 then
                                SetCus(ped, 4, 0, 1, 0)
                            end
                            if Customs.List5 == 3 then
                                SetCus(ped, 4, 1, 0, 0)
                            end
                            if Customs.List5 == 4 then
                                SetCus(ped, 4, 1, 1, 0)
                            end
                        end, 
					})

                

                    RageUI.List("Chapeau", {"1", "2", "3", "4", "5", "6"}, Customs.List8, nil, {}, true, {
                        onListChange = function(i, Item)
                            Customs.List8 = i;
                        end,
                        onActive = function()
                            if Customs.List8 == 1 then
                                Clear(ped, 0)
                            end
                            if Customs.List8 == 2 then
                                SetProp(ped, 0, 0, 0, 0)
                            end
                            if Customs.List8 == 3 then
                                SetProp(ped, 0, 0, 1, 0)
                            end
                            if Customs.List8 == 4 then
                                SetProp(ped, 0, 0, 2, 0)
                            end
                            if Customs.List8 == 5 then
                                SetProp(ped, 0, 1, 0, 0)
                            end
                            if Customs.List8 == 6 then
                                SetProp(ped, 0, 1, 1, 0)
                            end
                        end, 
					})

                    RageUI.List("Lunettes", {"1", "2", "3", "4"}, Customs.List7, nil, {}, true, {
                        onListChange = function(i, Item)
                            Customs.List7 = i;
                        end,
                        onActive = function()
                            if Customs.List7 == 1 then
                                Clear(ped, 1)
                            end
                            if Customs.List7 == 2 then
                                SetProp(ped, 1, 0, 0, 0)
                            end
                            if Customs.List7 == 3 then
                                SetProp(ped, 1, 0, 1, 0)
                            end
                            if Customs.List7 == 4 then
                                SetProp(ped, 1, 1, 0, 0)
                            end
                        end, 
					})

                end)

                RageUI.IsVisible(PedsSubMenu, function()

    
					RageUI.Separator("~r~↓~s~ Liste des peds ~r~↓~s~")


                    for _, v in pairs (pedmodel) do

                        RageUI.Button(v.name, nil, {RightBadge = RageUI.BadgeStyle.None}, not Couldown, {
                            onActive = function()--              --   --
                                RenderSprite("vip", v.picturemodel, 445, 344, 260, 417, 500)
                            end,   
                            onSelected = function()
                                ESX.ShowNotification("~r~Chargement en cours ...")
                                Citizen.Wait(200)
                                SpawnPed(v.model)
                                local model = v.model
                                local _src = source
                                TriggerEvent('couldown')
                            end 
                        });
                   end

            end)

                ------- MENU PROPS 

        RageUI.IsVisible(PropsSubMenu, function()
                        

                RageUI.Separator("~r~↓~s~ Liste des props ~r~↓~s~")

                      

                RageUI.List("Trier", {"~h~Props | ~r~Civil", "~h~Props | ~r~Illégal"}, itemIndex, nil, {}, true, {
                        onListChange = function(Index, Items)
                            itemIndex = Index
                        end,
                            onSelected = function()
                        end,
                })
                    if itemIndex == 1 then
                            for _, v in pairs (legalprops) do
                            
                                RageUI.Button(v.nameprops, nil, {RightBadge = RageUI.BadgeStyle.None}, true, {
                                    onSelected = function()
                                        local _src = source
                                        SpawnObj(v.modelprops)
                                        local nameprops = v.nameprops
                                    end 
                                });
                            end
                        else
                            for _, v in pairs (illegalprops) do
                        
                                RageUI.Button(v.nameprops, nil, {RightBadge = RageUI.BadgeStyle.None}, true, {
                                    onSelected = function()
                                        local _src = source
                                        SpawnObj(v.modelprops)
                                        local nameprops = v.nameprops
                                    end 
                                });
                            end
                        end
                
        end)
                    
                RageUI.IsVisible(DeletePropsSubMenu, function()
                        
                        
                        for k,v in pairs(object) do
                            if GoodName(GetEntityModel(NetworkGetEntityFromNetworkId(v))) == 0 then table.remove(object, k) end

                            RageUI.Button("Props : "..GoodName(GetEntityModel(NetworkGetEntityFromNetworkId(v))).." ["..v.."]", nil, {}, true, {
                                onActive = function()
                                    local entity = NetworkGetEntityFromNetworkId(v)
                                    local ObjCoords = GetEntityCoords(entity)
                                    DrawMarker(20, ObjCoords.x, ObjCoords.y, ObjCoords.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 33, 172, 235, 255, 1, 0, 2, 1, nil, nil, 0)
                                end,
                                onSelected = function()
                                    RemoveObj(v, k)
                                end 
                        });
                    end
                end)
            end
        end)
    end
end

RegisterNetEvent('couldown')
AddEventHandler('couldown', function()
    Couldown = true 
    Wait(3600000)
    Couldown = false
end)

RegisterCommand("vip", function() 
    if GetVIP() then
        OpenPedsMenu()
    else
        ESX.ShowNotification("Vous n'êtes pas VIP") 
    end
end)

TriggerEvent('chat:addSuggestion', '/vip', 'Ouvrir le menu VIP', {})