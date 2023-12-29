TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


local EmoteMenu = RageUI.CreateMenu("Animation",'Que veux-tu faire ?')

local emote_shared = RageUI.CreateSubMenu(EmoteMenu,"Emote paratagé", "Que veux-tu faire ?")
local emote_basic = RageUI.CreateSubMenu(EmoteMenu,"Emote", "Que veux-tu faire ?")

local emote_fav = RageUI.CreateSubMenu(EmoteMenu,"Emote favoris", "Que veux-tu faire ?")
local emote_dance = RageUI.CreateSubMenu(EmoteMenu,"Danse", "Que veux-tu faire ?")


EmoteMenu:SetSpriteBanner('emote', 'interaction_bgd2')
emote_shared:SetSpriteBanner('emote', 'interaction_bgd2')
emote_basic:SetSpriteBanner('emote', 'interaction_bgd2')
emote_fav:SetSpriteBanner('emote', 'interaction_bgd2')
emote_dance:SetSpriteBanner('emote', 'interaction_bgd2')

function input_showBox(TextEntry, ExampleText, MaxStringLenght, isValueInt)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", 50)
    local blockInput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockInput = false
        print("result: " .. result)
        return result
    else
        Wait(500)
        blockInput = false
        return nil
    end
end

---@type table
local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = 38 },
    Text = { X = 8, Y = 3, Scale = 0.33 },
}

function RageUI.Line()
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            local Option = RageUI.Options + 1
            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
                RenderRectangle(CurrentMenu.X + (CurrentMenu.WidthOffset * 2.5 ~= 0 and CurrentMenu.WidthOffset * 2.5 or 200)-150+8, CurrentMenu.Y + RageUI.ItemOffset + 15, 300, 3, 255,255,255,150)
                RageUI.ItemOffset = RageUI.ItemOffset + SettingsButton.Rectangle.Height
                if (CurrentMenu.Index == Option) then
                    if (RageUI.LastControl) then
                        CurrentMenu.Index = Option - 1
                        if (CurrentMenu.Index < 1) then
                            CurrentMenu.Index = RageUI.CurrentMenu.Options
                        end
                    else
                        CurrentMenu.Index = Option + 1
                    end
                end
            end
            RageUI.Options = RageUI.Options + 1
        end
    end
end


local menu_emote = false


local type = {"Visualisé 👀", "jouer 💃","Favorie ✨"}
local selectedtype = 1

local type3 = {"Visualisé 👀", "jouer 💃", "Supprimer 🗑", "Renomer 📝"}
local selectedtype3 = 1

local type2 = {"Visualisé 👀", "jouer 💃"}
local selectedtype2 = 1


_Utiles = {} 

_Utiles.animation_load = function(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
       Wait(1)
    end
end

_Utiles.process_load = function(name)
   RequestAnimSet(name)
   while not HasAnimSetLoaded(name) do
       Wait(1)
   end
end

_Utiles.TaskAnim = function(ped, animDict, animName)
   _Utiles.animation_load(animDict)
   TaskPlayAnim(ped, animDict, animName, 1.0, -1.0, -1, 1, 1, false, false, false)
end

_Utiles.keyRegister = function(name, defaultKey, desc, callback)
    local cmd = ("gw_%s"):format(name)
    RegisterCommand(cmd, function()
        callback()
    end)
    RegisterKeyMapping(cmd, desc, "keyboard", defaultKey)
end

_Utiles.keyRegister('animation', 'f3', 'Menu Animation', function()
    Open_Menu_Animation()
end)


_Utiles.keyRegister('animation-cancel', 'x', 'Stop Animation', function()
   ClearPedTasks(GetPlayerPed(-1))
   ClearPedSecondaryTask(GetPlayerPed(-1))
end)

EmoteMenu.Closed = function()
    menu_emote = false
    DeleteEntity(peds)
    RageUI.SetAcces(true)
end


PlayAnim = function(peds, Dict, Anim, Flag)
    RequestAnimDict(Dict)
    while not HasAnimDictLoaded(Dict) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(peds, Dict, Anim, 8.0, -8.0, -1, Flag or 0, 0, false, false, false)
end

local type_GetClosestPed = function(coords, cb)
    local ped = GetPlayerPed(GetClosestPlayer(coords.x, coords.y, coords.z, 5.0, 0, playerPed))
    if DoesEntityExist(ped) then
        cb(ped)
    end
end


Fav_Emote = {}


Open_Menu_Animation = function()
    if not RageUI.Acces() then 
        return
    end
    RageUI.SetAcces(false)
    if menu_emote then 
        menu_emote = false 
        return 
    else 
        menu_emote = true
        RageUI.Visible(EmoteMenu, true)
        CreateThread(function()
            while menu_emote do
                RageUI.IsVisible(EmoteMenu,function()
                    RageUI.Button("Emote partagé", false, {RightLabel = "→→"}, true, {
                        onSelected = function()
                        end
                    }, emote_shared)
                    RageUI.Button("Emote basic", false, {RightLabel = "→→"}, true, {
                        onSelected = function()
                        end
                    
                    }, emote_basic)

                    RageUI.Button("Emote dance", false, {RightLabel = "→→"}, true, {
                        onSelected = function()
                        end
                    }, emote_dance)


                    RageUI.Line()

                    RageUI.Button("Favorie ✨", false, {RightLabel = "→→"}, true, {
                        onSelected = function()
                            Fav_Emote = {}
                            Citizen.CreateThread(function()
                                ESX.TriggerServerCallback("animations:getAnimations", function(data)
                                    Fav_Emote = {}
                                    Fav_Emote = data
                                    Fav_Emote_loaded = true
                                end)
                            end)
                            Fav_Emote_loaded = false
                        end
                    }, emote_fav)


                end)

                RageUI.IsVisible(emote_fav,function()
                    if not Fav_Emote_loaded then 

                        RageUI.Separator("Chargement des emote favoris")
                    end
                    RageUI.Separator("Vos emote favoris ✨")
                    if Fav_Emote_loaded then 

                        if #Fav_Emote == 0 then 
                            RageUI.Separator()
                            RageUI.Separator("~r~Aucun favori ✨")
                            RageUI.Separator()
                        else  
                            for k,v in pairs(Fav_Emote) do
                                    RageUI.List(v.name,type3,selectedtype3,nil,{},true,{
                                        onListChange = function(Index)
                                            selectedtype3 = Index
                                            DeleteEntity(peds)
                                        end,
                                        onSelected = function(index)
                                            if index == 1 then 
                                                SetPexIndexClosset(v.dict, v.anim)
                                            elseif index == 2 then
                                                ClearPedTasks(GetPlayerPed(-1))
                                                Citizen.CreateThread(function()
                                                    _Utiles.animation_load(v.dict, v.anim)
                                                    ChosenDict = v.dict 
                                                    ChosenAnimation = v.anim
                                                    AnimationOptions = {}
                                                    table.insert(AnimationOptions, v.param)
                                                    MovementType = 1
                                                    AnimationDuration = -1
                                                    print(ChosenDict, ChosenAnimation, 2.0, 2.0, AnimationDuration, MovementType)
                                                    TaskPlayAnim(PlayerPedId(), ChosenDict, ChosenAnimation, 2.0, 2.0, AnimationDuration, MovementType, 0, false, false, false)
                                                end)
                                            elseif index == 3 then
                                                TriggerServerEvent("animations:removeAnimation", v.id)
                                                RageUI.GoBack()
                                            elseif index == 4 then
                                                local res = input_showBox("Nom de l'emote", "", 100, true)
                                                TriggerServerEvent("animations:renameAnimation", v.id, res)
                                                Fav_Emote[k].name = res
                                            end
                                                
                                        end 
                                    })
                                end
                            end
                       
                    end
                end) 
                RageUI.IsVisible(emote_dance,function()
                   
                    for k,v in pairs(danceList) do
                        RageUI.List(v[3],type,selectedtype,nil,{},true,{
                            onListChange = function(Index)
                                selectedtype = Index
                                DeleteEntity(peds)
                            end,
                            onSelected = function(index)
                                if index == 3 then
                                    TriggerServerEvent("animation:saveemote", v[1], v[2], v[3], v.AnimationOptions)
                                end
                                if index == 1 then 
                                    SetPexIndexClosset(v[1], v[2])
                                elseif index == 2 then
                                    ClearPedTasks(GetPlayerPed(-1))
                                    Citizen.CreateThread(function()
                                        _Utiles.animation_load(v[1], v[2])

                                        ChosenDict = v[1] 
                                        ChosenAnimation = v[2]

                                        if v.AnimationOptions then
                                            if v.AnimationOptions.EmoteLoop then
                                                MovementType = 1
                                                if v.AnimationOptions.EmoteMoving then
                                                    MovementType = 51
                                                end
                                
                                            elseif v.AnimationOptions.EmoteMoving then
                                                MovementType = 51
                                            elseif v.AnimationOptions.EmoteMoving == false then
                                                MovementType = 0
                                            elseif v.AnimationOptions.EmoteStuck then
                                                MovementType = 50
                                            end
                                
                                        else
                                            MovementType = 0
                                        end
                                        if v.AnimationOptions then
                                            if v.AnimationOptions.EmoteDuration == nil then
                                                v.AnimationOptions.EmoteDuration = -1
                                                AttachWait = 0
                                            else
                                                AnimationDuration = v.AnimationOptions.EmoteDuration
                                                AttachWait = v.AnimationOptions.EmoteDuration
                                            end
                                        else
                                            PtfxPrompt = false
                                        end
                                        TaskPlayAnim(PlayerPedId(), ChosenDict, ChosenAnimation, 2.0, 2.0, AnimationDuration, MovementType, 0, false, false, false)
                                    end)
                                end
                            end 
                        })
                    end
                end)

                RageUI.IsVisible(emote_basic,function()
                   
                    for k,v in pairs(AnimationList) do
                        RageUI.List(v[3],type,selectedtype,nil,{},true,{
                            onListChange = function(Index)
                                selectedtype = Index
                                DeleteEntity(peds)
                            end,
                            onSelected = function(index)
                                if index == 3 then
                                    TriggerServerEvent("animation:saveemote", v[1], v[2], v[3], v.AnimationOptions)
                                end
                                if index == 1 then 
                                    SetPexIndexClosset(v[1], v[2])
                                elseif index == 2 then
                                    ClearPedTasks(GetPlayerPed(-1))
                                    Citizen.CreateThread(function()
                                        _Utiles.animation_load(v[1], v[2])

                                        ChosenDict = v[1] 
                                        ChosenAnimation = v[2]

                                        if v.AnimationOptions then
                                            if v.AnimationOptions.EmoteLoop then
                                                MovementType = 1
                                                if v.AnimationOptions.EmoteMoving then
                                                    MovementType = 51
                                                end
                                
                                            elseif v.AnimationOptions.EmoteMoving then
                                                MovementType = 51
                                            elseif v.AnimationOptions.EmoteMoving == false then
                                                MovementType = 0
                                            elseif v.AnimationOptions.EmoteStuck then
                                                MovementType = 50
                                            end
                                
                                        else
                                            MovementType = 0
                                        end
                                        if v.AnimationOptions then
                                            if v.AnimationOptions.EmoteDuration == nil then
                                                v.AnimationOptions.EmoteDuration = -1
                                                AttachWait = 0
                                            else
                                                AnimationDuration = v.AnimationOptions.EmoteDuration
                                                AttachWait = v.AnimationOptions.EmoteDuration
                                            end
                                        else
                                            PtfxPrompt = false
                                        end
                                        TaskPlayAnim(PlayerPedId(), ChosenDict, ChosenAnimation, 2.0, 2.0, AnimationDuration, MovementType, 0, false, false, false)
                                    end)
                                end
                            end 
                        })
                    end
                end)
                RageUI.IsVisible(emote_shared,function()
                    for k,v in pairs(Animation_Config_Synced) do 
                        RageUI.List(v['Label'],type2,selectedtype2,nil,{},true,{
                            onListChange = function(Index)
                                selectedtype2 = Index
                            end,
                            onSelected = function(index)
                                DeleteEntity(pedsclone2)
                                DeleteEntity(target)
                            if index == 2 then 
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                if closestPlayer ~= -1 and closestDistance < 2.0 then
                                    TriggerServerEvent('animations:requestSynced', GetPlayerServerId(closestPlayer), v)
                                end
                            end
                            if index == 1 then 
                                pedsclone2 = ClonePed(PlayerPedId(), false, false)
                                target = ClonePed(PlayerPedId(), false, false)
                                SetBlockingOfNonTemporaryEvents(pedsclone2, true)
                                SetBlockingOfNonTemporaryEvents(target, true)
                                SetEntityAlpha(pedsclone2, 190, 0)
                                SetEntityAlpha(target, 190, 0)
                                CreateThread(function()
                                    local anim = v['Accepter']
                                    if v['Car'] then
                                        TaskWarpPedIntoVehicle(target, GetVehiclePedIsUsing(PlayerPedId()), 0)
                                    end
        
                                    if anim['Attach'] then
                                        local attach = anim['Attach']
                                        AttachEntityToEntity(target, pedsclone2, attach['Bone'], attach['xP'], attach['yP'], attach['zP'], attach['xR'], attach['yR'], attach['zR'], 0, 0, 0, 0, 2, 1)
                                    end
        
                                    Wait(750)
        
                                    if anim['Type'] == 'animation' then
                                        RequestAnimDict(anim['Dict'])
                                        while not HasAnimDictLoaded(anim['Dict']) do
                                            Wait(0)
                                        end
                                        TaskPlayAnim(target, anim['Dict'], anim['Anim'], 8.0, -8.0, -1, anim['Flags'] or 0, 0, false, false, false)
                                    end
        
                                    anim = v['Requester']
                                   
                                    while not IsEntityPlayingAnim(pedsclone2, anim['Dict'], anim['Anim'], 3) do
                                        Wait(0)
                                        SetEntityNoCollisionEntity(PlayerPedId(), pedsclone2, true)
                                        SetEntityNoCollisionEntity(PlayerPedId(), target, true)
                                        SetEntityNoCollisionEntity(target, pedsclone2, true)
                                    end
                                    DetachEntity(target)
                                    while IsEntityPlayingAnim(pedsclone2, anim['Dict'], anim['Anim'], 3) do
                                        Wait(0)
                                        SetEntityNoCollisionEntity(PlayerPedId(), pedsclone2, true)
                                        SetEntityNoCollisionEntity(PlayerPedId(), target, true)
                                        SetEntityNoCollisionEntity(target, pedsclone2, true)
                                    end
        
                                    ClearPedTasks(target)
                                    DeleteEntity(target)
        
                                end)
                                CreateThread(function()
                                    local anim = v['Requester']
                                    if anim['Attach'] then
                                        local attach = anim['Attach']
                                        AttachEntityToEntity(pedsclone2, target, attach['Bone'], attach['xP'], attach['yP'], attach['zP'], attach['xR'], attach['yR'], attach['zR'], 0, 0, 0, 0, 2, 1)
                                    end
        
                                    Wait(750)
        
                                    if anim['Type'] == 'animation' then
                                        PlayAnim(pedsclone2, anim['Dict'], anim['Anim'], anim['Flags'])
                                    end
        
                                    anim = v['Accepter']
        
                                    while not IsEntityPlayingAnim(target, anim['Dict'], anim['Anim'], 3) do
                                        Wait(0)
                                        SetEntityNoCollisionEntity(pedsclone2, target, true)
                                    end
                                    DetachEntity(pedsclone2)
                                    while IsEntityPlayingAnim(target, anim['Dict'], anim['Anim'], 3) do
                                        Wait(0)
                                        SetEntityNoCollisionEntity(pedsclone2, target, true)
                                    end
        
                                    ClearPedTasks(pedsclone2)
                                    DeleteEntity(pedsclone2)
                                end)
                            end
                            end
                        })
                    end
                end)
                Wait(0)
            end
        end)
    end
end



function SetPexIndexClosset(animation,animation_name)
    Citizen.CreateThread(function()
        DeleteEntity(peds)
        peds = ClonePed(PlayerPedId(), false, false)
        Coords = GetEntityCoords(PlayerPedId())
        SetEntityAlpha(peds, 200)
        SetEntityCollision(peds, false, false)
        SetEntityCoords(peds, Coords.x , Coords.y, Coords.z)
        AttachEntityToEntity(peds, PlayerPedId(), 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        FreezeEntityPosition(peds, true)
        SetBlockingOfNonTemporaryEvents(peds, true)
        SetEntityInvincible(peds, true)
        _Utiles.TaskAnim(peds, animation, animation_name, -1)
        Wait(1000)
        while IsEntityPlayingAnim(peds, animation, animation_name, 3) do
            Wait(0)
        end
        DeleteEntity(peds)
    end)
end


RegisterNetEvent('animations:syncRequest')
AddEventHandler('animations:syncRequest', function(requester, v, name)
    local accepted = false
    local timer = GetGameTimer() + 5000
    while timer >= GetGameTimer() do 
        Wait(0)
        ESX.ShowNotification('Le joueur ' .. name .. ' veux faire une animation avec vous ( ' .. v['RequesterLabel'] .. ' ) appuyez sur ~g~E~w~ pour accepter')
        if IsControlJustReleased(0, 194) then
            break
        elseif IsControlJustReleased(0, 201) then
            accepted = true
            break
        end
    end
    if accepted then
        TriggerServerEvent('animations:syncAccepted', requester, v)
    end
end)

RegisterNetEvent('animations:playSynced')
AddEventHandler('animations:playSynced', function(serverid, v, type)
    local anim = v[type]

    local target = GetPlayerPed(GetPlayerFromServerId(serverid))
    if anim['Attach'] then
        local attach = anim['Attach']
        AttachEntityToEntity(PlayerPedId(), target, attach['Bone'], attach['xP'], attach['yP'], attach['zP'], attach['xR'], attach['yR'], attach['zR'], 0, 0, 0, 0, 2, 1)
    end
    Wait(750)
    if anim['Type'] == 'animation' then
        PlayAnim(PlayerPedId(), anim['Dict'], anim['Anim'], anim['Flags'])
    end
    if type == 'Requester' then
        anim = v['Accepter']
    else
        anim = v['Requester']
    end
    print("start sync emote " .. anim['Dict'] .. " " .. anim['Anim'])
    while not IsEntityPlayingAnim(target, anim['Dict'], anim['Anim'], 3) do
        Wait(0)
        SetEntityNoCollisionEntity(PlayerPedId(), target, true)
    end
    DetachEntity(PlayerPedId())
    while IsEntityPlayingAnim(target, anim['Dict'], anim['Anim'], 3) do
        Wait(0)
        SetEntityNoCollisionEntity(PlayerPedId(), target, true)
    end
    ClearPedTasks(PlayerPedId())
end)