--====================================================================================
--  Function APP BANK
--====================================================================================


ESX = nil
local bank = 0

function setBankBalance (value)
      bank = value
      SendNUIMessage({event = 'updateBankbalance', banking = bank})
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
      local accounts = playerData.accounts or {}
      for index, account in ipairs(accounts) do 
            if account.name == 'bank' then
                  setBankBalance(account.money)
            end
      end
      if ESX.PlayerData.job ~= nil then
            if ESX.PlayerData.job.grade_name == "boss" then
                  ESX.TriggerServerCallback('gksphone:isparasicek', function(data)
                  setBankaparas(data)
                  end)
            end
      end
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
      if account.name == 'bank' then
            setBankBalance(account.money)
      end
end)

RegisterNetEvent("es:addedBank")
AddEventHandler("es:addedBank", function(m)
      setBankBalance(bank + m)
end)

RegisterNetEvent("es:removedBank")
AddEventHandler("es:removedBank", function(m)
      setBankBalance(bank - m)
end)

RegisterNetEvent('es:displayBank')
AddEventHandler('es:displayBank', function(bank)
      setBankBalance(bank)
end)



--===============================================
--==         Transfer Event                    ==
--===============================================

RegisterNUICallback('transferPhoneNumber', function(data)
      TriggerServerEvent('gksphone:transferPhoneNumber', data.to, data.totaltt, data.tfee)
end)

--===============================================
--==             Ad ve Soyad                   ==
--===============================================

RegisterNetEvent("gksphone:firstname")
AddEventHandler("gksphone:firstname", function(identifier, _firstname, jobname, joblabel, accmoney)
  firstname = _firstname

  SendNUIMessage({event = 'identifierrr', identifier = identifier})
  SendNUIMessage({event = 'updateMyFirstname', firstname = firstname})
  SendNUIMessage({event = 'jobkontrol', joblabel = joblabel})
  SendNUIMessage({event = 'jobname', jobname = jobname})

  setBankBalance(accmoney)
      if joblabel == "boss" then
            ESX.TriggerServerCallback('gksphone:isparasicek', function(data)
               
            setBankaparas(data)
            end)
      end

end)

RegisterNetEvent("gksphone:jobupdate")
AddEventHandler("gksphone:jobupdate", function(identifier, jobname, joblabel)


  SendNUIMessage({event = 'identifierrr', identifier = identifier})
  SendNUIMessage({event = 'jobkontrol', joblabel = joblabel})
  SendNUIMessage({event = 'jobname', jobname = jobname})



end)

RegisterNetEvent("gksphone:lastname")
AddEventHandler("gksphone:lastname", function(_lastname)
  lastname = _lastname
  SendNUIMessage({event = 'updateMyListname', lastname = lastname})
end)


RegisterNetEvent("gksphone:bank_getBilling")
AddEventHandler("gksphone:bank_getBilling", function(bankkkkk)
  SendNUIMessage({event = 'bank_billingg', bankkkkk = bankkkkk})
end)

RegisterNUICallback('bank_getBilling', function(data, cb)
  TriggerServerEvent('gksphone:bank_getBilling')
end)



function setBankaparas(isciparasi)
      SendNUIMessage({event = 'societypara', isciparasi = isciparasi})
end

