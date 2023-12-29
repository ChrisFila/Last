function UseContextmenu(model)
    if model == 0 then
        return true
    end
    if not IsAtm(model) then
        BankOpenMenu("distrib")
        return 
    end
    ESX.ShowNotification("Vous ne pouvez pas utiliser cette objet")
end