eUtils = {}

eUtils.GetDistance = function(source, position, distance, eventName, security, onAccepted, onRefused)
    if #(GetEntityCoords(GetPlayerPed(source)) - position) < distance then
        onAccepted();
    else
        onRefused();
        if security then
            local xPlayer = ESX.GetPlayerFromId(source)
            FlashSideLogs('', "AntiCheat","**"..GetPlayerName(source).."** vient d'etre Kick \n**License** : "..xPlayer.identifier..'\nEvent : '..eventName, 56108)
            DropPlayer(source, 'Désynchronisation avec le serveur ou detection de Cheat [' ..eventName..']')
        end
    end
end