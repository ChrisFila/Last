Citizen.CreateThread(function()
    Wait(2500)
    TriggerServerEvent('ewen:RetreiveIsDead')
end)

RegisterNetEvent('ewen:PlayerIsDead')
AddEventHandler('ewen:PlayerIsDead', function()
    SetEntityHealth(PlayerPedId(), 0)
end)

local ReportListTable = {}

RegisterNetEvent('ewen:UpdateTableSignalEms')
AddEventHandler('ewen:UpdateTableSignalEms', function(table)
    ReportListTable = table
end)

local AppelsSelected = 0
local SrcSelected = 0
local AppelEnCours = false
local blip = nil
function OpenReportListEms()
    local menu = RageUI.CreateMenu('', "Voici les appeles disponibles")
    local OpenSelectedAppel = RageUI.CreateSubMenu(menu, "", 'Actions disponible')
    RageUI.Visible(menu, not RageUI.Visible(menu))
    while menu do
        Citizen.Wait(0)
        RageUI.IsVisible(menu, function()
            for k,v in pairs(ReportListTable) do
                RageUI.Separator('~r~Appel en Attente')
                if v.status == 0 then
                    RageUI.Button('Appel N*'..v.numbers, 'Description : '..v.raison, {RightLabel = 'Fait à '..v.heures..'h'..v.minutes.. 'm'..v.secondes..'s'}, true, {
                        onSelected = function() 
                            SrcSelected = v.src
                            AppelsSelected = v.numbers
                        end
                    }, OpenSelectedAppel)
                end
            end
            for k,v in pairs(ReportListTable) do
                RageUI.Separator('~r~Appel en Cours')
                if v.status == 1 then
                    RageUI.Button('Appel N*'..v.numbers, 'Description : '..v.raison..'\nAppel pris par ~r~'..v.EMSName, {RightLabel = 'Fait à '..v.heures..'h'..v.minutes.. 'm'..v.secondes..'s'}, true, {
                        onSelected = function() 
                            SrcSelected = v.src
                            AppelsSelected = v.numbers
                        end
                    }, OpenSelectedAppel)
                end
            end
        end, function()
        end)
        RageUI.IsVisible(OpenSelectedAppel, function()
            RageUI.Separator('')
            RageUI.Separator('Appel N*~r~'..AppelsSelected)
            print(ReportListTable[SrcSelected].status)
            if ReportListTable[SrcSelected].status == 1 then
                StatusText = 'Pris par ~r~'..ReportListTable[SrcSelected].EMSName
            else 
                StatusText = '~r~En Attente'
            end
            RageUI.Separator('Status : '..StatusText)
            RageUI.Separator('')
            if ReportListTable[SrcSelected].status == 0 then
                RageUI.Button('Prendre l\'appel','Permet de prendre l\'appel, Vos collegues seront informer', {RightLabel = '>'}, true, {
                    onSelected = function()
                        if not AppelEnCours then
                            AppelEnCours = true
                            blip = AddBlipForCoord(ReportListTable[SrcSelected].position)
                            SetBlipColour(blip, 60)
                            SetBlipRoute(blip, true)
                            ESX.ShowNotification('FlashSide~w~~n~Tu as pris l\'appel N*'..AppelsSelected)
                            TriggerServerEvent('EMS:UpdateReport', SrcSelected, true) --> TRUE = PRENDRE
                        else
                            ESX.ShowNotification('FlashSide~w~~n~Vous avez déjà un appel en cours\nCloture le pour en reprendre un.')
                        end
                    end
                })
            else
                if GetPlayerServerId(PlayerId()) == ReportListTable[SrcSelected].EMS_SRC then
                    RageUI.Button('Informer le patient de votre arriver',nil, {RightLabel = '>'}, true, {
                        onSelected = function()
                            TriggerServerEvent('EMS:InformPatient', SrcSelected)
                        end
                    })
                    RageUI.Button('Terminer l\'appel',nil, {RightLabel = '>'}, true, {
                        onSelected = function()
                            AppelEnCours = false
                            RemoveBlip(blip)
                            ESX.ShowNotification('FlashSide~w~~n~Vous avez terminer l\'intervention N*'..AppelsSelected)
                            TriggerServerEvent('EMS:UpdateReport', SrcSelected, false)
                        end
                    })
                end
            end
        end)

        if not RageUI.Visible(menu) and not RageUI.Visible(OpenSelectedAppel) then
            menu = RMenu:DeleteType('menu', true)
        end
    end
end

RegisterNetEvent('EMS:ForceStopAppel')
AddEventHandler('EMS:ForceStopAppel', function()
    AppelEnCours = false
    RemoveBlip(blip)
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name = 'Ambulance',
		number = 'ambulance',
		base64Icon = 'data:image/png;base64,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'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)