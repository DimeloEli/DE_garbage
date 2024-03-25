local bags = 0
local bagsTaken = {}
local bagProp = nil
local jobVehicle = nil
local isHoldingBag = false
local isOnDuty = false

if Config.RequireJob then
    jobName = Config.Job
else
    jobName = nil
end

CreateThread(function()
    if Config.Blip.Show then
        if Config.RequireJob then
            if ESX.PlayerData.job.name == Config.Job then
                local blip = AddBlipForCoord(Config.JobClock)

                SetBlipSprite(blip, Config.Blip.Sprite)
                SetBlipScale(blip, Config.Blip.Scale)
                SetBlipColour(blip, Config.Blip.Color)
                SetBlipAsShortRange(blip, true)

                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName('Garbage Job')
                EndTextCommandSetBlipName(blip)
            end
        else
            local blip = AddBlipForCoord(Config.JobClock)

            SetBlipSprite(blip, Config.Blip.Sprite)
            SetBlipScale(blip, Config.Blip.Scale)
            SetBlipColour(blip, Config.Blip.Color)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName('Garbage Job')
            EndTextCommandSetBlipName(blip)
        end
    end
end)

exports.ox_target:addModel(Config.Models, {
    {
        label = 'Grab Bag',
        icon = 'fas fa-trash',
        distance = 2.0,
        onSelect = function(data)
            local playerPed = PlayerPedId()

            if bagsTaken[data.entity] == nil then
                bagsTaken[data.entity] = 0
            end

            loadAnimDict("anim@heists@narcotics@trash")
            ProgressBar(5000, 'Grabbing Garbage Bag', {scenario = 'PROP_HUMAN_BUM_BIN'}, {move = true, mouse = false, combat = true, sprint = true, car = true})

            isHoldingBag = true
            bagProp = CreateObject(GetHashKey("prop_cs_street_binbag_01"), 0, 0, 0, true, true, true)
            AttachEntityToEntity(bagProp, playerPed, GetPedBoneIndex(playerPed, 57005), 0.4, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)

            bagsTaken[data.entity] += 1

            TaskPlayAnim(playerPed, 'anim@heists@narcotics@trash', 'walk', 1.0, -1.0,-1,49,0,0, 0,0)
        end,
        canInteract = function(entity)
            return not isHoldingBag and isOnDuty and bagsTaken[entity] ~= 3 and bags < Config.MaxBags
        end
    }
})

exports.ox_target:addGlobalVehicle({
    {
        label = 'Place Garbage Bag',
        icon = 'fas fa-trash',
        bones = 'boot',
        distance = 2.0,
        onSelect = function(data)
            ProgressBar(800, 'Throwing bag in truck', {dict = 'anim@heists@narcotics@trash', clip = 'throw_b'}, {move = true, mouse = false, combat = true, sprint = true, car = true})
            DeleteEntity(bagProp)
            bagProp = nil
            isHoldingBag = false
            bags += 1

            if bags == Config.MaxBags then
                Notify('inform', 'You have reached the max amount of bags, go clock out and you will get paid.')
            end
        end,
        canInteract = function(entity)
            return isHoldingBag and GetEntityModel(entity) == GetHashKey(Config.VehicleModel)
        end
    }
})

exports.ox_target:addSphereZone({
    coords = Config.JobClock,
    radius = 0.5,
    debug = false,
    options = {
        {
            label = 'Clock-in',
            icon = 'fas fa-clipboard',
            groups = jobName,
            distance = 2.0,
            onSelect = function(data)
                ProgressBar(2000, 'Clocking in', nil, {move = true, mouse = false, combat = true, sprint = true, car = true})

                ESX.Game.SpawnVehicle(Config.VehicleModel, Config.VehicleSpawn.xyz, Config.VehicleSpawn.w, function(vehicle)
                    Notify('inform', 'You have clocked in and your vehicle has been released.')
                    receiveCarKeys(vehicle, GetVehicleNumberPlateText(vehicle))
                    
                    jobVehicle = vehicle
                end)
                isOnDuty = true
            end,
            canInteract = function()
                return not isOnDuty
            end
        },
        {
            label = 'Clock-out',
            icon = 'fas fa-clipboard',
            groups = jobName,
            distance = 2.0,
            onSelect = function(data)
                ProgressBar(2000, 'Clocking out', nil, {move = true, mouse = false, combat = true, sprint = true, car = true})
                Notify('inform', 'You have clocked out and your vehicle has been put away.')

                TriggerServerEvent('DE_garbage:pay', bags)
                DeleteEntity(jobVehicle)
                jobVehicle = nil
                bagsTaken = {}
                bags = 0
                isOnDuty = false
            end,
            canInteract = function()
                return isOnDuty
            end
        }
    }
})