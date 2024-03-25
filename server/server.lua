RegisterNetEvent('DE_garbage:pay')
AddEventHandler('DE_garbage:pay', function(bagCount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local payAmount = Config.PayPerBag * bagCount

    if payAmount > 0 then
        xPlayer.addInventoryItem('money', payAmount)
        Notify(source, 'inform', 'You have been paid $' .. payAmount)
    else
        Notify(source, 'inform', 'You didnt collect any bags so you didnt get paid.')
    end
end)