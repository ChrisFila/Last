function Billing(billingg)
  SendNUIMessage({event = 'fatura_billingg', billingg = billingg})
end

RegisterNUICallback('fatura_getBilling', function(data, cb)
  ESX.TriggerServerCallback('gksphone:getbilling', function(data)
    Billing(data)
  end)
end)

RegisterNUICallback('faturapayBill', function(data)
  TriggerServerEvent('gksphone:faturapayBill', data.id, data.sender, data.amount, data.target)
end)

RegisterNetEvent('updatebilling')
AddEventHandler('updatebilling', function(billingg)
    ESX.TriggerServerCallback('gksphone:getbilling', function(data)
      Billing(data)
    end, billingg)
end)
