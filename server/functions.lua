Notify = function(playerId, type, message)
    if Config.Notify == 'ox' then
        TriggerClientEvent('ox_lib:notify', playerId, {type = type, title = 'Garbage Job', description = message})
    elseif Config.Notify == 'esx' then
        TriggerClientEvent('esx:showNotification', playerId, message, type)
    elseif Config.Notify == 'other' then
        -- Notify stuff here
    end
end