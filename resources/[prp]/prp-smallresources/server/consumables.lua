----------- / alcohol

ProjectRP.Functions.CreateUseableItem("vodka", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    TriggerClientEvent("consumables:client:DrinkAlcohol", src, item.name)
end)

ProjectRP.Functions.CreateUseableItem("beer", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    TriggerClientEvent("consumables:client:DrinkAlcohol", src, item.name)
end)


ProjectRP.Functions.CreateUseableItem("mojito", function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('prp-items:client:drinkbeer', source, 'mojito', 'mojito')
    end
end)

ProjectRP.Functions.CreateUseableItem("rum", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    TriggerClientEvent("consumables:client:DrinkAlcohol", src, item.name)
end)

ProjectRP.Functions.CreateUseableItem("ecola", function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('prp-items:client:drink', source, 'ecola', 'cola')
    end
end)

ProjectRP.Functions.CreateUseableItem("glasschampagne", function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('prp-items:client:drinkbeer', source, 'glasschampagne', 'cola')
    end
end)

ProjectRP.Functions.CreateUseableItem("lockpick", function(source, item)
    local Player = ProjectRP.Functions.GetPlayer(source)
    TriggerClientEvent("lockpicks:UseLockpick", source, false)
end)

ProjectRP.Functions.CreateUseableItem("advancedlockpick", function(source, item)
    local Player = ProjectRP.Functions.GetPlayer(source)
    TriggerClientEvent("lockpicks:UseLockpick", source, true)
end)

ProjectRP.Functions.CreateUseableItem("whiskey", function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('prp-items:client:drinkbeer', source, 'whiskey', 'whiskey')
    end
end)

ProjectRP.Functions.CreateUseableItem("hennessy", function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('prp-items:client:drinkbeer', source, 'hennessy', 'hennessy')
    end
end)

ProjectRP.Functions.CreateUseableItem("tequila", function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('prp-items:client:drinkbeer', source, 'tequila', 'tequila')
    end
end)

ProjectRP.Functions.CreateUseableItem("pinacolada", function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('prp-items:client:drinkbeer', source, 'pinacolada', 'pinacolada')
    end
end)


ProjectRP.Functions.CreateUseableItem("sprunk", function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('prp-items:client:drink', source, 'sprunk', 'cola')
    end
end)

ProjectRP.Functions.CreateUseableItem("slushy", function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('prp-items:client:drink:slushy', source)
    end
end)

ProjectRP.Functions.CreateUseableItem("sandwich", function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('prp-items:client:eat', source, 'sandwich', 'sandwich')
    end
end)

ProjectRP.Functions.CreateUseableItem("carapils", function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent('prp-items:client:drinkbeer', source, 'beer', 'beer')
    end
end)

ProjectRP.Functions.CreateUseableItem("pizza", function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('prp-items:client:eat', source, 'pizza', 'pizza')
    end
end)

ProjectRP.Functions.CreateUseableItem("hotdog", function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('prp-items:client:eat', source, 'hotdog', 'footlong')
    end
end)


----------- / Eat

ProjectRP.Functions.CreateUseableItem("sandwich", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", src, item.name)
    end
end)

ProjectRP.Functions.CreateUseableItem("twerks_candy", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", src, item.name)
    end
end)

ProjectRP.Functions.CreateUseableItem("chocolate", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", src, item.name)
    end
end)

ProjectRP.Functions.CreateUseableItem("snikkel_candy", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", src, item.name)
    end
end)

ProjectRP.Functions.CreateUseableItem("toastie", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", src, item.name)
    end
end)

-- BurgerShot

ProjectRP.Functions.CreateUseableItem("burger-bleeder", function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('prp-items:client:eat', source, 'burger-bleeder', 'hamburger')
    end
end)

ProjectRP.Functions.CreateUseableItem("burger-box", function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('prp-burgershot:client:open:box', source, item.info.boxid)
    end
end)

ProjectRP.Functions.CreateUseableItem("burger-moneyshot", function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('prp-items:client:eat', source, 'burger-moneyshot', 'hamburger')
    end
end)

ProjectRP.Functions.CreateUseableItem("burger-torpedo", function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('prp-items:client:eat', source, 'burger-torpedo', 'hamburger')
    end
end)

ProjectRP.Functions.CreateUseableItem("burger-heartstopper", function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('prp-items:client:eat', source, 'burger-heartstopper', 'hamburger')
    end
end)

ProjectRP.Functions.CreateUseableItem("burger-softdrink", function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('prp-items:client:drink', source, 'burger-softdrink', 'burger-soft')
    end
end)

ProjectRP.Functions.CreateUseableItem("burger-coffee", function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('prp-items:client:drink', source, 'burger-coffee', 'coffee')
    end
end)

ProjectRP.Functions.CreateUseableItem("burger-fries", function(source, item)
	local Player = ProjectRP.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('prp-items:client:eat', source, 'burger-fries', 'burger-fries')
    end
end)

----------- / Drink

ProjectRP.Functions.CreateUseableItem("water_bottle", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drink", src, item.name)
    end
end)

ProjectRP.Functions.CreateUseableItem("coffee", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drink", src, item.name)
    end
end)

ProjectRP.Functions.CreateUseableItem("cola", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drink", src, item.name)
    end
end)

----------- / Drug

ProjectRP.Functions.CreateUseableItem("joint", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:UseJoint", src)
    end
end)

ProjectRP.Functions.CreateUseableItem("coke_baggy", function(source, item)
    local src = source
    TriggerClientEvent("consumables:client:Cokebaggy", src)
end)

ProjectRP.Functions.CreateUseableItem("crack_baggy", function(source, item)
    local src = source
    TriggerClientEvent("consumables:client:Crackbaggy", src)
end)

ProjectRP.Functions.CreateUseableItem("xtcbaggy", function(source, item)
    local src = source
    TriggerClientEvent("consumables:client:EcstasyBaggy", src)
end)

ProjectRP.Functions.CreateUseableItem("oxy", function(source, item)
    local src = source
    TriggerClientEvent("consumables:client:oxy", src)
end)

ProjectRP.Functions.CreateUseableItem("meth_baggy", function(source, item)
    local src = source
    TriggerClientEvent("consumables:client:meth_baggy", src)
end)

----------- / Tools

ProjectRP.Functions.CreateUseableItem("armor", function(source, item)
    local src = source
    TriggerClientEvent("consumables:client:UseArmor", src)
end)

ProjectRP.Functions.CreateUseableItem("heavyarmor", function(source, item)
    local src = source
    TriggerClientEvent("consumables:client:UseArmor", src)
end)

ProjectRP.Commands.Add("resetarmor", "Resets Vest (Police Only)", {}, false, function(source, args)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("consumables:client:ResetArmor", src)
    else
        TriggerClientEvent('ProjectRP:Notify', src,  "For Police Officer Only", "error")
    end
end)

ProjectRP.Functions.CreateUseableItem("binoculars", function(source, item)
    local src = source
    TriggerClientEvent("binoculars:Toggle", src)
end)

ProjectRP.Functions.CreateUseableItem("parachute", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:UseParachute", src)
    end
end)

ProjectRP.Commands.Add("resetparachute", "Resets Parachute", {}, false, function(source, args)
    local src = source
	TriggerClientEvent("consumables:client:ResetParachute", src)
end)

RegisterNetEvent('prp-smallpenis:server:AddParachute', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    Player.Functions.AddItem("parachute", 1)
end)

----------- / Firework

ProjectRP.Functions.CreateUseableItem("firework1", function(source, item)
    local src = source
    TriggerClientEvent("fireworks:client:UseFirework", src, item.name, "proj_indep_firework")
end)

ProjectRP.Functions.CreateUseableItem("firework2", function(source, item)
    local src = source
    TriggerClientEvent("fireworks:client:UseFirework", src, item.name, "proj_indep_firework_v2")
end)

ProjectRP.Functions.CreateUseableItem("firework3", function(source, item)
    local src = source
    TriggerClientEvent("fireworks:client:UseFirework", src, item.name, "proj_xmas_firework")
end)

ProjectRP.Functions.CreateUseableItem("firework4", function(source, item)
    local src = source
    TriggerClientEvent("fireworks:client:UseFirework", src, item.name, "scr_indep_fireworks")
end)

----------- / Unused

-- ProjectRP.Functions.CreateUseableItem("smoketrailred", function(source, item)
--     local Player = ProjectRP.Functions.GetPlayer(source)
-- 	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
--         TriggerClientEvent("consumables:client:UseRedSmoke", source)
--     end
-- end)

-- Tequilala Drinks
ProjectRP.Functions.CreateUseableItem("dusche-beer", function(source, item)
    local Player = ProjectRP.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:DrinkCock", source, item.name)
    end
end)

ProjectRP.Functions.CreateUseableItem("stronzo-beer", function(source, item)
    local Player = ProjectRP.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:DrinkCock", source, item.name)
    end
end)

ProjectRP.Functions.CreateUseableItem("am-beer", function(source, item)
    local Player = ProjectRP.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:DrinkBeer", source, item.name)
    end
end)

ProjectRP.Functions.CreateUseableItem("logger-beer", function(source, item)
    local Player = ProjectRP.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:DrinkBeer", source, item.name)
    end
end)

ProjectRP.Functions.CreateUseableItem("sunny-cocktail", function(source, item)
    local Player = ProjectRP.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:DrinkBeer", source, item.name)
    end
end)

-- Tequilala Food
ProjectRP.Functions.CreateUseableItem("crisps", function(source, item)
    local Player = ProjectRP.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", source, item.name)
    end
end)

-- Galaxy Food
ProjectRP.Functions.CreateUseableItem("baconfries", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent('prp-items:client:eat', src, item.name, 'sandwich')
    end
end)

ProjectRP.Functions.CreateUseableItem("chickenstars", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent('prp-items:client:eat', src, item.name, 'sandwich')
    end
end)

ProjectRP.Functions.CreateUseableItem("moonrock", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent('prp-items:client:eat', src, item.name, 'donut')
    end
end)

ProjectRP.Functions.CreateUseableItem("gdonut", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent('prp-items:client:eat', src, item.name, 'donut')
    end
end)

ProjectRP.Functions.CreateUseableItem("ethertacos", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent('prp-items:client:eat', src, item.name, 'taco')
    end
end)

ProjectRP.Functions.CreateUseableItem("galaxyslush", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:DrinkAlcohol", src, item.name, 'tequila')
    end
end)

ProjectRP.Functions.CreateUseableItem("junojs", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:DrinkAlcohol", src, item.name, 'tequila')
    end
end)

ProjectRP.Functions.CreateUseableItem("blackhole", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:DrinkAlcohol", src, item.name, 'tequila')
    end
end)

ProjectRP.Functions.CreateUseableItem("stardust", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:DrinkAlcohol", src, item.name, 'tequila')
    end
end)

ProjectRP.Functions.CreateUseableItem("venus", function(source, item)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:DrinkAlcohol", src, item.name, 'tequila')
    end
end)