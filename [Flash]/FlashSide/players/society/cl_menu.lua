mSociety.OpenFlashSideUIMenu = function(_society, _options)
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == _society.name and ESX.PlayerData.job.grade_name == "boss" then
        if mSociety.Menu then
            mSociety.Menu = false
        else
            mSociety.InitFlashSideUIMenu(mSocietyCFG.Title, mSocietyCFG.SubTitle, mSocietyCFG.Banner.Texture, mSocietyCFG.Banner.Name, mSocietyCFG.ColorMenu, mSocietyCFG.Banner.Display)
            mSociety.Menu = true
            local options = {money = true, wash = false,employees = true,grades = true}
            for k,v in pairs(options) do if _options[k] == nil then _options[k] = v end  end
            mSociety.RefreshMoney(_society.name)
            FlashSideUI.Visible(RMenu:Get('bossmenu', 'main'), true)

            Citizen.CreateThread(function()
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                while mSociety.Menu do
                    FlashSideUI.IsVisible(RMenu:Get('bossmenu', 'main'), mSocietyCFG.Banner.Display, true, true, function()
                        FlashSideUI.Separator(mSociety.Trad["society"].." :~r~ " .._society.label)

                        if closestPlayer ~= -1  and closestDistance <= 5.0 then
                            FlashSideUI.ButtonWithStyle(mSociety.Trad["recruit"], mSociety.Trad["recruit_desc"], {}, true, function(Hovered, Active, Selected)
                                if Active then
                                    local pCoords = GetEntityCoords(GetPlayerPed(closestPlayer))
                                    DrawMarker(2, pCoords.x, pCoords.y, pCoords.z+1.1, 0, 0, 0, 180.0, nil, nil, 0.2, 0.2, 0.2, 255, 255, 255, 170, 0, 1, 0, 0, nil, nil, 0)
                                    if Selected then
                                        TriggerServerEvent("mSociety:RequestSetRecruit", GetPlayerServerId(closestPlayer), _society.name)
                                    end
                                end
                            end)
                        end

                        if _options.money then
                            if mSociety.societyMoney ~= nil then
                                FlashSideUI.Separator(mSociety.Trad["society_money"].." :~r~" ..mSociety.societyMoney.." "..mSociety.Trad["money_symbol"])
                            end
                            FlashSideUI.ButtonWithStyle(mSociety.Trad["withdraw_money"], false, {}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    result = mSociety.KeyboardInput("pick", mSociety.Trad["how_much"], "", 8)
                                    if result ~= nil and result ~= "" then
                                        result = ESX.Math.Round(tonumber(result))
                                        if result > 0 then
                                            TriggerServerEvent('mSociety:withdrawMoney', _society.name, result)
                                            SetTimeout(100, function()
                                                mSociety.RefreshMoney(_society.name)
                                            end)
                                        else
                                            FlashSideUI.Popup({message = mSociety.Trad["impossible_action"]})
                                        end
                                    end
                                end
                            end)
    
                            FlashSideUI.ButtonWithStyle(mSociety.Trad["deposit_money"], false, {}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    result = mSociety.KeyboardInput("deposit", mSociety.Trad["how_much"], "", 8)
                                    if result ~= nil and result ~= "" then
                                        result = ESX.Math.Round(tonumber(result))
                                        if result > 0 then
                                            TriggerServerEvent('mSociety:depositMoney', _society.name, result)
                                            SetTimeout(100, function()
                                                mSociety.RefreshMoney(_society.name)
                                            end)
                                        else
                                            FlashSideUI.Popup({message = mSociety.Trad["impossible_action"]})
                                        end
                                    end
                                end
                            end)
                        end

                        if _options.wash and _society.percent then
                            FlashSideUI.ButtonWithStyle(mSociety.Trad["wash_money"], mSociety.Trad["wash_money_desc"].." (".._society.percent.."%).", {}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local tax = tonumber("0.".._society.percent)
                                    result = mSociety.KeyboardInput("wash", mSociety.Trad["how_much"], "", 8)
                                    result = tonumber(result)
                                    if result ~= nil and result ~= "" then
                                        if result >= 2 then
                                            TriggerServerEvent('mSociety:washMoney', _society.name, result, tax)
                                            SetTimeout(100, function()
                                                mSociety.RefreshMoney(_society.name)
                                            end)
                                        else
                                            FlashSideUI.Popup({message = "~r~Action impossible"})
                                        end
                                    end
                                end
                            end)
                        end

                        if _options.employees then
                            FlashSideUI.ButtonWithStyle(mSociety.Trad["manage_employees"], false, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    mSociety.RefeshEmployeesList(_society.name)
                                    filterstring = ""
                                end
                            end, RMenu:Get('bossmenu', 'manage_employees'))
                        end
    
                        if _options.grades then
                            FlashSideUI.ButtonWithStyle(mSociety.Trad["manage_salary"], mSociety.Trad["manage_salary_desc"], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    mSociety.RefeshjobInfos(_society.name)
                                end
                            end, RMenu:Get('bossmenu', 'manage_salary'))
                        end
                    end)

                    FlashSideUI.IsVisible(RMenu:Get('bossmenu', 'manage_employees'), mSocietyCFG.Banner.Display, true, true, function()
                        FlashSideUI.ButtonWithStyle(mSociety.Trad["search"], false, {RightLabel = filterstring}, true, function(Hovered, Active, Selected)
                            if Selected then
                                filterstring = mSociety.KeyboardInput("entysearch", "~r~"..mSociety.Trad["search"], "", 50)
                            end
                        end)
                        FlashSideUI.Separator("↓↓ ~r~"..mSociety.Trad["list"].."~s~ ↓↓")
    
                        for i=1, #mSociety.EmployeesList do
                            local ply = mSociety.EmployeesList[i]
    
                            if filterstring == nil or string.find(ply.name, filterstring) or string.find(ply.job.grade_label, filterstring) then
                                FlashSideUI.ButtonWithStyle(ply.name, false, {RightLabel = "~r~"..ply.job.grade_label.."~s~ →"}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        mSociety.RefeshjobInfos(_society.name)
                                        SelectedEmployee = ply
                                    end
                                end, RMenu:Get('bossmenu', 'update_employee'))
                            end
                        end
                    end)

                    FlashSideUI.IsVisible(RMenu:Get('bossmenu', 'update_employee'), mSocietyCFG.Banner.Display, true, true, function()

                        FlashSideUI.Separator("↓↓ ~r~"..SelectedEmployee.name.."~s~ ↓↓")
    
                        for i=1, #mSociety.JobList, 1 do
                            local jb = mSociety.JobList[i]
    
                            if SelectedEmployee.job.grade ~= jb.grade then
                                FlashSideUI.ButtonWithStyle(jb.label, false, {RightLabel = mSociety.Trad["choose"]}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        ESX.TriggerServerCallback('mSociety:setJob', function(data)
                                            if data ~= false then
                                                SelectedEmployee.job.grade = jb.grade
                                            end
                                        end, SelectedEmployee.identifier, _society.name, jb.grade)
                                    end
                                end)
                            else
                                FlashSideUI.ButtonWithStyle(jb.label, false, {RightLabel = mSociety.Trad["current"]}, true, function(Hovered, Active, Selected)
                                end)
                            end
                        end
    
                        FlashSideUI.ButtonWithStyle(mSociety.Trad["kick_society"], false, {RightBadge = FlashSideUI.BadgeStyle.Alert}, true, function(Hovered, Active, Selected)
                            if Selected then
                                result = mSociety.KeyboardInput("valid", mSociety.Trad["sure"].." ("..mSociety.Trad["yes"]..")", "", 8)
                                if result == mSociety.Trad["yes"] then
                                    ESX.TriggerServerCallback('mSociety:setJob', function()
                                        FlashSideUI.GoBack()
                                    end, SelectedEmployee.identifier, 'unemployed', 0)
                                end
                            end
                        end)
                    end)

                    FlashSideUI.IsVisible(RMenu:Get('bossmenu', 'manage_salary'), mSocietyCFG.Banner.Display, true, true, function()
                        FlashSideUI.Separator("↓↓ ~r~".._society.label.."~s~ ↓↓")
    
                        for i=1, #mSociety.JobList, 1 do
                            local jb = mSociety.JobList[i]
    
                            FlashSideUI.ButtonWithStyle(jb.grade..". "..jb.label, false, {RightLabel = "~r~"..jb.salary.." "..mSociety.Trad["money_symbol"]}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    result = mSociety.KeyboardInput("pick", mSociety.Trad["how_much"], "", 5)
                                    result = ESX.Math.Round(tonumber(result))
                                    if result >= 0 and result <= _society.salary_max then
                                        ESX.TriggerServerCallback('mSociety:setJobSalary', function()
                                            SetTimeout(100, function()
                                                mSociety.RefeshjobInfos(_society.name)
                                            end)
                                        end, _society.name, jb.grade, result)
                                        print(_society.name, jb.grade, result)
                                    else
                                        FlashSideUI.Popup({message = mSociety.Trad["impossible_action"]})
                                    end
                                end
                            end)
                        end
                    end)

                    Citizen.Wait(0)
                end
            end)
        end
    end
end