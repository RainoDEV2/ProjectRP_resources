RegisterServerEvent('prp-hunting:skinReward')
AddEventHandler('prp-hunting:skinReward', function()
  local src = source
  local Player = ProjectRP.Functions.GetPlayer(src)
  local randomAmount = math.random(1,30)
  if randomAmount > 1 and randomAmount < 15 then
    Player.Functions.AddItem("huntingcarcass1", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["huntingcarcass1"], "add")
  elseif randomAmount > 15 and randomAmount < 23 then
    Player.Functions.AddItem("huntingcarcass2", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["huntingcarcass2"], "add")
  elseif randomAmount > 23 and randomAmount < 29 then
    Player.Functions.AddItem("huntingcarcass3", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["huntingcarcass3"], "add")
  else 
    Player.Functions.AddItem("huntingcarcass4", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["huntingcarcass4"], "add")
  end

  --TriggerClientEvent('player:receiveItem', _source, 'meat',math.random(1,4))
end)

RegisterServerEvent('prp-hunting:removeBait')
AddEventHandler('prp-hunting:removeBait', function()
  local src = source
  local Player = ProjectRP.Functions.GetPlayer(src)
  Player.Functions.RemoveItem("huntingbait", 1)
end)

RegisterServerEvent('remove:money')
AddEventHandler('remove:money', function(totalCash)
  local src = source
  local Player = ProjectRP.Functions.GetPlayer(src)
  if Player.PlayerData.money['cash'] >= (50) then
    Player.Functions.RemoveMoney('cash', 50)
    TriggerClientEvent("prp-hunting:setammo", src)
    TriggerClientEvent("ProjectRP:Notify", src, 'Reloaded.')
  else
    TriggerClientEvent("ProjectRP:Notify", src, 'Not enough cash on you.', 'error')
  end
end)

ProjectRP.Functions.CreateUseableItem("huntingbait", function(source, item)
  local Player = ProjectRP.Functions.GetPlayer(source)

  TriggerClientEvent('prp-hunting:usedBait', source)
end)


local carcasses = {
  huntingcarcass1 = 30,
  huntingcarcass2 = 35,
  huntingcarcass3 = 40,
  huntingcarcass4 = 45
}

RegisterServerEvent('prp-hunting:server:sell')
AddEventHandler('prp-hunting:server:sell', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    for k,v in pairs(carcasses) do
        local item = Player.Functions.GetItemByName(k)
        if item ~= nil then
            if Player.Functions.RemoveItem(k, item.amount) then
                Player.Functions.AddMoney('cash', v * item.amount)
            end
        end
    end
end)