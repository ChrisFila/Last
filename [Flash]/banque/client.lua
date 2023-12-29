local AlexEvent = TriggerServerEvent
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)
local PlayerMoney = 0
Dors_c_mieux = AlexEvent
RegisterNetEvent("solde:argent")
AddEventHandler("solde:argent", function(money, cash)
    PlayerMoney = tonumber(money)
end)
Citizen.CreateThread(function()
    for i=1, #Config.position, 1 do
       local blip = AddBlipForCoord(Config.position[i].x, Config.position[i].y, Config.position[i].z)
       SetBlipSprite(blip, 207)
       SetBlipColour(blip, 69)
       SetBlipAsShortRange(blip, true)
       SetBlipScale(blip, 0.65)

       BeginTextCommandSetBlipName('STRING')
       AddTextComponentString("Banque")
       EndTextCommandSetBlipName(blip)
   end
end)

function MenuBanque()
	local Mbank = RageUI.CreateMenu("Banque", "                  Compte de : ~g~"..GetPlayerName(PlayerId()))
    local MbankDepo = RageUI.CreateSubMenu(Mbank, "Banque", "Déposer de l'argent")
    local MbankReti = RageUI.CreateSubMenu(Mbank, "Banque", "Retirer de l'argent")
    Mbank:SetRectangleBanner(0, 0, 0, 0)
    MbankDepo:SetRectangleBanner(0, 0, 0, 0)
    MbankReti:SetRectangleBanner(0, 0, 0, 0)
        RageUI.Visible(Mbank, not RageUI.Visible(Mbank))
            while Mbank do
            Citizen.Wait(1)
            RageUI.IsVisible(Mbank, true, true, true, function()
                RageUI.ButtonWithStyle("Déposer de l'argent", nil,  {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                end, MbankDepo)
                RageUI.ButtonWithStyle("Retirer de l'argent", nil,  {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                end, MbankReti)
                RageUI.ButtonWithStyle("Faire un virement", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                    if (Selected) then
                        local to = KeyboardInput("IBAN de la personne (ID)", "", 5)
                        local amountt = KeyboardInput("Montant à lui donner", "", 30)
                        AlexEvent('transfer', to, amountt)
                        Config.GetPlayerMoney()
                    end
                end)
                RageUI.ButtonWithStyle("Solde du compte : ", nil, {RightLabel = PlayerMoney.." $"},true, function(Hovered, Active, Selected)
                    if (Selected) then
                    end
                    end)

            end, function()
            end)
                RageUI.IsVisible(MbankDepo, true, true, true, function()
                    RageUI.ButtonWithStyle("~r~Appuyer~s~ pour mettre un montant.", nil, {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
                        if (Selected) then   
                            saisiedepot()
                            Config.GetPlayerMoney()
                        end
                        end)
                    end, function()
                 end)

                 RageUI.IsVisible(MbankReti, true, true, true, function()
                    RageUI.ButtonWithStyle("~r~Appuyer~s~ pour mettre un montant.", nil, {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
                        if (Selected) then   
                            saisieretrait()
                            Config.GetPlayerMoney()
                        end
                        end)
                end, function()
                end)
            if not RageUI.Visible(Mbank) and not RageUI.Visible(MbankDepo) and not RageUI.Visible(MbankReti) then
            Mbank = RMenu:DeleteType("Banque", true)
        end
    end
end


function MenuATM()
	local Mbank = RageUI.CreateMenu("ATM", "Interagir avec votre banque")
    local MbankDepo = RageUI.CreateSubMenu(Mbank, "ATM", "Déposer de l'argent")
    local MbankReti = RageUI.CreateSubMenu(Mbank, "ATM", "Retirer de l'argent")
    Mbank:SetRectangleBanner(0, 0, 0, 0)
    MbankDepo:SetRectangleBanner(0, 0, 0, 0)
    MbankReti:SetRectangleBanner(0, 0, 0, 0)
        RageUI.Visible(Mbank, not RageUI.Visible(Mbank))
            while Mbank do
            Citizen.Wait(1)
            RageUI.IsVisible(Mbank, true, true, true, function()
                RageUI.ButtonWithStyle("Déposer de l'argent", nil,  {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                end, MbankDepo)
                RageUI.ButtonWithStyle("Retirer de l'argent", nil,  {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                end, MbankReti)
                RageUI.ButtonWithStyle("Solde du compte : ", nil, {RightLabel = PlayerMoney.." $"},true, function(Hovered, Active, Selected)
                    if (Selected) then
                    end
                    end)
            end, function()
            end)
                RageUI.IsVisible(MbankDepo, true, true, true, function()
                    RageUI.ButtonWithStyle("~r~Appuyer~s~ pour mettre un montant.", nil, {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
                        if (Selected) then   
                            saisiedepot()
                            Config.GetPlayerMoney()
                        end
                        end)
                    end, function()
                 end)

                 RageUI.IsVisible(MbankReti, true, true, true, function()
                    RageUI.ButtonWithStyle("~r~Appuyer~s~ pour mettre un montant.", nil, {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
                        if (Selected) then   
                            saisieretrait()
                            Config.GetPlayerMoney()
                        end
                        end)
                end, function()
                end)
            if not RageUI.Visible(Mbank) and not RageUI.Visible(MbankDepo) and not RageUI.Visible(MbankReti) then
            Mbank = RMenu:DeleteType("ATM", true)
        end
    end
end


function saisieretrait()
    local amount = KeyboardInput("Retrait banque", "", 15)

    if amount ~= nil then
        amount = tonumber(amount)

        if type(amount) == 'number' then
            Dors_c_mieux('retrait', amount)
        else
            ESX.ShowAdvancedNotification("Le banquier", "", ('Tu viens pour ~r~rien~s~ retirer ~r~?!~s~'), 'CHAR_ANDREAS', 7)
        end
    end
end

function saisiedepot()
    local amount = KeyboardInput("Dépot banque", "", 15)

    if amount ~= nil then
        amount = tonumber(amount)

        if type(amount) == 'number' then
            Dors_c_mieux('depot', amount)
        else
            ESX.ShowAdvancedNotification("Le banquier", "", ('Comment ca tu viens tu veux rien déposer ~r~?!~s~ J\'vai t\'en mettre ~r~une~s~ si tu continues ~r~!'), 'CHAR_ANDREAS', 7)
        end
    end
end


function playAnim(animDict, animName, duration)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Citizen.Wait(1) end
	TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
	RemoveAnimDict(animDict)
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            for i=1, #Config.position, 1 do
            local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
            local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, Config.position[i].x, Config.position[i].y, Config.position[i].z)
            if jobdist <= 10.0 and Config.BlipsBank then
                Timer = 0
                DrawMarker(Config.Type, Config.position[i].x, Config.position[i].y, Config.position[i].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
                end
                if jobdist <= 1.0 then
                    Timer = 0
                        RageUI.Text({ message = "Appuyez sur ~g~[E]~s~ pour parler avec le banquier", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                            playAnim('mp_common', 'givetake1_a', 2500)
                            Citizen.Wait(2500)
                            Config.GetPlayerMoney()
                            ExecuteCommand("me va sur son compte en banque")
                            MenuBanque()
        
                    end  
                end 
                end 
        Citizen.Wait(Timer)   
    end
end)


Citizen.CreateThread(function()
    while true do
        local Timer = 500
        for i=1, #Config.posatm, 1 do
        local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
        local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, Config.posatm[i].x, Config.posatm[i].y, Config.posatm[i].z)
        if jobdist <= 10.0 and Config.BlipsATM then
            Timer = 0
            DrawMarker(Config.Type, Config.posatm[i].x, Config.posatm[i].y, Config.posatm[i].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
            end
            if jobdist <= 1.0 then
                Timer = 0
                    RageUI.Text({ message = "Appuyez sur ~g~[E]~s~ pour mettre votre carte bleue", time_display = 1 })
                    if IsControlJustPressed(1,51) then
                        playAnim('mp_common', 'givetake2_a', 2500)
                        Citizen.Wait(2500)
                        Config.GetPlayerMoney()
                        ExecuteCommand("me va sur son compte en banque")
                        MenuATM()
                end  
            end 
            end 
    Citizen.Wait(Timer)   
end
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)


    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(1)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(1000) 
        blockinput = false
        return result 
    else
        Citizen.Wait(1000) 
        blockinput = false 
        return nil 
    end
end