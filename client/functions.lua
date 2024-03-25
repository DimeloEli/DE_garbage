Notify = function(type, message)
    if Config.Notify == 'ox' then
        lib.notify({type = type, title = 'Garbage Job', description = message})
    elseif Config.Notify == 'esx' then
        ESX.ShowNotification(message, type)
    elseif Config.Notify == 'other' then
        -- Notify stuff here
    end
end

ProgressBar = function(length, text, animTable, disableTable)
    if Config.Progress == 'circle' then
        lib.progressCircle({duration = length, label = text, position = 'bottom', useWhileDead = false, canCancel = false, disable = disableTable, anim = animTable})
    elseif Config.Progress == 'bar' then
        lib.progressBar({duration = length, label = text, position = 'bottom', useWhileDead = false, canCancel = false, disable = disableTable, anim = animTable})
    end
end

loadAnimDict = function(dict)
    if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict) 
		while not HasAnimDictLoaded(dict) do 
			Citizen.Wait(0)
		end
	end
end

receiveCarKeys = function(vehicle, plate)

end