local cows = {}
local harvesting = false

-- Function to spawn cows
function spawnCow(x, y, z)
    local cowModel = `a_c_cow`
    RequestModel(cowModel)
    while not HasModelLoaded(cowModel) do Wait(100) end

    local cow = CreatePed(4, cowModel, x, y, z, 0.0, true, false)
    SetEntityInvincible(cow, true)
    FreezeEntityPosition(cow, true)

    exports['qb-target']:AddTargetEntity(cow, {
        options = {
            {
                event = 'cheese:startMilkHarvest',
                icon = 'fas fa-cow',
                label = 'Harvest Milk',
                action = function(entity)
                    TriggerEvent('cheese:startMilkHarvest', cow)
                end,
            },
        },
        distance = 2.0,
    })

    table.insert(cows, cow)
end

-- Spawn cows at preset locations
Citizen.CreateThread(function()
    local spawnPoints = {
        vector3(2386.3560, 5054.5181, 45.4446),
        vector3(2382.2139, 5049.9624, 45.4350),
        vector3(2374.6006, 5048.5874, 45.4446),
        vector3(2372.4551, 5055.9966, 45.4428)
    }
    for _, point in pairs(spawnPoints) do
        spawnCow(point.x, point.y, point.z)
    end
end)

-- Function to handle harvesting loop
function StartHarvestingLoop(cow)
    Citizen.CreateThread(function()
        while harvesting do
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local cowCoords = GetEntityCoords(cow)
            local dist = #(playerCoords - cowCoords)

            print("Distance to cow:", dist)
            print("Harvesting flag:", harvesting)

            -- Stop if player moves too far
            if dist > 3.0 then
                TriggerEvent("QBCore:Notify", "You moved too far from the cow!", "error")
                harvesting = false
                return
            end

            -- Start progress bar (no return check, assume it runs)
            exports['progressbar']:Progress({
                name = "harvest_milk",
                duration = 5000,
                label = "Harvesting Milk...",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {disableMovement = true, disableCarMovement = true, disableMouse = true, disableCombat = true},
                animation = {dict = "amb@world_human_bum_wash@male@idle_a", clip = "idle_a"},
                onCancel = function()
                    harvesting = false
                    TriggerEvent("QBCore:Notify", "Milk Harvesting Canceled", "error")
                end
            })

            Citizen.Wait(5000) -- Wait for progress bar duration

            -- Check if still harvesting
            if harvesting then
                print("Milk event triggered")
                TriggerServerEvent('cheese:addMilk') -- Give milk
                Citizen.Wait(2000) -- Short delay
            end
        end
    end)
end

-- Event to start harvesting
RegisterNetEvent('cheese:startMilkHarvest')
AddEventHandler('cheese:startMilkHarvest', function(cow)
    if harvesting then
        TriggerEvent("QBCore:Notify", "You are already harvesting!", "error")
        return
    end

    local playerPed = PlayerPedId()
    local dist = #(GetEntityCoords(playerPed) - GetEntityCoords(cow))

    if dist > 3.0 then
        TriggerEvent("QBCore:Notify", "You are too far from the cow!", "error")
        return
    end

    harvesting = true
    StartHarvestingLoop(cow)
end)
