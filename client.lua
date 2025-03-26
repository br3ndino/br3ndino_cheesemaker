local cows = {}

-- Function to spawn cows at specific locations
function spawnCowAtCoords(coords)
    local cowModel = `a_c_cow` -- Use cow model

    RequestModel(cowModel)
    while not HasModelLoaded(cowModel) do
        Wait(100)
    end

    local cowPed = CreatePed(4, cowModel, coords.x, coords.y, coords.z, 0.0, true, true)
    SetEntityInvincible(cowPed, true)  -- Make the cow invincible
    SetEntityVisible(cowPed, true, false) -- Make the cow visible
    SetBlockingOfNonTemporaryEvents(cowPed, true) -- Prevent the cow from running

    -- Save the cow data
    table.insert(cows, { id = #cows + 1, ped = cowPed, location = coords })
end

-- Example of where cows should spawn (could be randomized later)
local cowLocations = {
    vector3(2386.3560, 5054.5181, 46.4446), -- Add more locations as needed
    vector3(2382.2139, 5049.9624, 46.4350),
    vector3(2374.6006, 5048.5874, 46.4446),
    vector3(2372.4551, 5055.9966, 46.4428)
}

-- Spawn cows at defined locations
Citizen.CreateThread(function()
    for _, coords in ipairs(cowLocations) do
        spawnCowAtCoords(coords)
    end
end)

-- Interaction with cows (harvest milk)
RegisterNetEvent('cheese:harvestMilk')
AddEventHandler('cheese:harvestMilk', function(cowID)
    local cow = cows[cowID]

    if cow then
        -- Check if player is close enough to the cow
        local playerPed = PlayerPedId()
        local cowCoords = GetEntityCoords(cow.ped)
        if #(GetEntityCoords(playerPed) - cowCoords) < 3.0 then
            TriggerServerEvent('cheese:addMilk')
            -- Optionally, play a milk harvesting animation here
            print("Milk harvested from cow ID: " .. cowID)
        else
            TriggerEvent("QBCore:Notify", "You are too far from the cow!", "error")
        end
    end
end)

-- Add interaction logic with qb-target (assuming qb-target is already setup)
Citizen.CreateThread(function()
    for i, cow in ipairs(cows) do
        exports['qb-target']:AddTargetEntity(cow.ped, {
            options = {
                {
                    type = "client",
                    event = "cheese:harvestMilk",
                    icon = "fas fa-mug-hot",
                    label = "Harvest Milk",
                    action = function()
                        TriggerEvent('cheese:harvestMilk', i)
                    end
                }
            },
            distance = 3.0
        })
    end
end)
