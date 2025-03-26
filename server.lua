QBCore = exports['qb-core']:GetCoreObject()

-- Handle adding milk to player's inventory
RegisterNetEvent('cheese:addMilk')
AddEventHandler('cheese:addMilk', function()
    local player = QBCore.Functions.GetPlayer(source)
    local milkItem = "milk"  -- Define milk as an item in your inventory system

    if player then
        -- Check if player has a valid inventory space
        if player.Functions.AddItem(milkItem, 1) then
            TriggerClientEvent('QBCore:Notify', source, 'You have harvested milk!', 'success')
        else
            TriggerClientEvent('QBCore:Notify', source, 'You do not have enough inventory space!', 'error')
        end
    end
end)

-- Crafting logic (using milk and other ingredients)
RegisterNetEvent('cheese:craftCheese')
AddEventHandler('cheese:craftCheese', function()
    local player = QBCore.Functions.GetPlayer(source)
    local milkItem = "milk"
    local rennetItem = "rennet"
    local butterItem = "butter"
    local saltItem = "salt"
    local culturesItem = "cultures"
    local lemonJuiceItem = "lemon_juice"

    -- Check if player has required ingredients
    if player.Functions.GetItemByName(milkItem) and player.Functions.GetItemByName(rennetItem) and
        player.Functions.GetItemByName(butterItem) and player.Functions.GetItemByName(saltItem) and
        player.Functions.GetItemByName(culturesItem) and player.Functions.GetItemByName(lemonJuiceItem) then
        
        -- Deduct ingredients
        player.Functions.RemoveItem(milkItem, 1)
        player.Functions.RemoveItem(rennetItem, 1)
        player.Functions.RemoveItem(butterItem, 1)
        player.Functions.RemoveItem(saltItem, 1)
        player.Functions.RemoveItem(culturesItem, 1)
        player.Functions.RemoveItem(lemonJuiceItem, 1)

        -- Add the crafted cheese to the player's inventory
        player.Functions.AddItem("cheese", 1)  -- "cheese" is the crafted item

        -- Notify player
        TriggerClientEvent('QBCore:Notify', source, 'You have crafted cheese!', 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'You are missing ingredients!', 'error')
    end
end)
