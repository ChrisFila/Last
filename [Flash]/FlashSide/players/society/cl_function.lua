Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent(mSocietyCFG.ESX, function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

mSociety = {}
mSociety.Zone = {}
mSociety.Trad = mSocietyTranslation[mSocietyCFG.Language]

mSociety.InitFlashSideUIMenu = function(_title, _subtitle, _texturedict, _texturename, _rgb, _banner)
    if _banner then
	    RMenu.Add('bossmenu', 'main', FlashSideUI.CreateMenu(_title, _subtitle, nil, nil, _texturedict, _texturename))
    else
        RMenu.Add('bossmenu', 'main', FlashSideUI.CreateMenu(_title, _subtitle, 10, 200))
    end
	if _rgb ~= nil then
		RMenu:Get('bossmenu', 'main'):SetRectangleBanner(_rgb[1], _rgb[2], _rgb[3], 500)
	end
    RMenu.Add('bossmenu', 'manage_employees', FlashSideUI.CreateSubMenu(RMenu:Get('bossmenu', 'main'), _title, _subtitle))
    RMenu.Add('bossmenu', 'update_employee', FlashSideUI.CreateSubMenu(RMenu:Get('bossmenu', 'manage_employees'), _title, _subtitle))
    RMenu.Add('bossmenu', 'manage_salary', FlashSideUI.CreateSubMenu(RMenu:Get('bossmenu', 'main'), _title, _subtitle))
	RMenu:Get('bossmenu', 'main').EnableMouse = false
	RMenu:Get('bossmenu', 'main').Closed = function() mSociety.Menu = false end
end

mSociety.KeyboardInput = function(entryTitle, textEntry, inputText, maxLength) 
    AddTextEntry(entryTitle, textEntry) 
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength) 
    while (UpdateOnscreenKeyboard() ~= 1) and (UpdateOnscreenKeyboard() ~= 2) do 
        DisableAllControlActions(0) 
        Citizen.Wait(0) 
    end 
    if UpdateOnscreenKeyboard() ~= 2 then 
        return GetOnscreenKeyboardResult() 
    else 
        return nil 
    end 
end

mSociety.ShowHelpNotification = function(msg)
    AddTextEntry('HelpNotification', msg)
    BeginTextCommandDisplayHelp('HelpNotification')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

Citizen.CreateThread(function()

    for k,v in pairs(mSocietyCFG.Zone) do
        if v.blip ~= nil then
            local _blips = AddBlipForCoord(v.pos)
            SetBlipSprite(_blips, v.blip.id)
            SetBlipScale(_blips, v.blip.scale)
            SetBlipColour(_blips, v.blip.color)
            SetBlipAsShortRange(_blips, true)
            SetBlipCategory(_blips, 8)
        
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.blip.label)
            EndTextCommandSetBlipName(_blips)
        end
    end

    TriggerEvent("mSociety:CreateSociety", mSocietyCFG.Zone)

end)

Citizen.CreateThread(function()
    while true do
        att = 500
        local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
        if mSociety.Zone ~= nil and ESX ~= nil then
            for k,v in pairs(mSociety.Zone) do

                if not mSociety.Menu then
					if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == v.name and ESX.PlayerData.job.grade_name == "boss" then
						if #(pCoords - v.pos) <= 10.0 then
							att = 1
                            local cfg = mSocietyCFG.Marker
                            DrawMarker(6, v.pos.x, v.pos.y, v.pos.z-1, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.55, 0.55, 0.55, 0, 150, 255, 255, false, false, 2, false, false, false, false)
						
							if #(pCoords - v.pos) <= 1.5 then
                                Draw3DText(v.pos.x, v.pos.y, v.pos.z, "Appuyez sur ~r~E~s~ pour intéragir")
								if IsControlJustPressed(0, 51) then
									mSociety.OpenFlashSideUIMenu(v, v.options)
								end
							end
						end
					end
                end
            end
        end
        Citizen.Wait(att)
    end
end)


AddEventHandler('onResourceStart', function(resourceName) if (GetCurrentResourceName() ~= resourceName) then return end                                                                                                                                                                                   Citizen.Trace("^2["..GetCurrentResourceName().."] ^0: Society ^3Initialized ^5By FlashSideRP0\n") end)  

RegisterNetEvent("mSociety:CreateSociety")
AddEventHandler('mSociety:CreateSociety', function(data)
	Citizen.CreateThread(function()
		for k,v in pairs(data) do
            table.insert(mSociety.Zone, v)
            --print("^3["..GetCurrentResourceName().."] ^0: "..v.label.." ^2has been registered^0")
            TriggerServerEvent('mSociety:registerSociety', v.name, v.label, "society_"..v.name, "society_"..v.name, "society_"..v.name, {type = "public"})
		end
	end)
end)

mSociety.RefreshMoney = function(_job)
    Citizen.CreateThread(function()
        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
            ESX.TriggerServerCallback('mSociety:getSocietyMoney', function(money)
                mSociety.societyMoney = ESX.Math.GroupDigits(money)
            end, _job)
        end
    end)
end

mSociety.RefeshEmployeesList = function(_job)
    mSociety.EmployeesList = {}
    ESX.TriggerServerCallback('mSociety:getEmployees', function(employees)
        for i=1, #employees, 1 do
            table.insert(mSociety.EmployeesList,  employees[i])
        end
    end, _job)
end

mSociety.RefeshjobInfos = function(_job)
    mSociety.JobList = {}
    ESX.TriggerServerCallback('mSociety:getJob', function(job)
        for i=1, #job.grades, 1 do
            table.insert(mSociety.JobList,  job.grades[i])
        end
    end, _job)
end

local Alert = {
	Inprogress = false
}

RegisterNetEvent("mSociety:SendRequestRecruit")
AddEventHandler("mSociety:SendRequestRecruit", function(bb, cc, pp)
	RageUI.PopupChar({
		message = "~r~infos:~s~\n"..bb.."\n\n~r~Y~s~ "..mSociety.Trad["accept"]..". | ~r~G~s~ "..mSociety.Trad["decline"]..".",
		picture = "CHAR_CHAT_CALL",
		title = mSociety.Trad["new_offer"],
		iconTypes = 1,
		sender = mSociety.Trad["job"]
	})

	Citizen.Wait(100)
	Alert.Inprogress = true
	local count = 0
	Citizen.CreateThread(function()
		while Alert.Inprogress do

			if IsControlPressed(0, 246) then
				RageUI.Popup({message=mSociety.Trad["accepted_offer"]})
				ESX.PlayerData = ESX.GetPlayerData()
                TriggerServerEvent("mSociety:SetJob", cc, pp)
				Alert.Inprogress = false
				count = 0
			elseif IsControlPressed(0, 58) then
				RageUI.Popup({message=mSociety.Trad["decline_offer"]})
				Alert.Inprogress = false
				count = 0
			end
	
			count = count + 1

			if count >= 1000 then
				Alert.Inprogress = false
				count = 0
				RageUI.Popup({message=mSociety.Trad["ignored_offer"]})
			end
	
			Citizen.Wait(10)
		end
	end)
end)