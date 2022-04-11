RegisterServerEvent('prp-traphouse:server:TakeoverHouse')
AddEventHandler('prp-traphouse:server:TakeoverHouse', function(Traphouse)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid

    if not HasCitizenIdHasKey(CitizenId, Traphouse) then
        if Player.Functions.RemoveMoney('cash', Config.TakeoverPrice) then
            TriggerClientEvent('prp-traphouse:client:TakeoverHouse', src, Traphouse)
        else
            TriggerClientEvent('ProjectRP:Notify', src, 'You dont have enough cash..', 'error')
        end
    end
end)

RegisterServerEvent('prp-traphouse:server:AddHouseKeyHolder')
AddEventHandler('prp-traphouse:server:AddHouseKeyHolder', function(CitizenId, TraphouseId, IsOwner)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)

	local gangss = Player.PlayerData.gang.name

    if Config.TrapHouses[TraphouseId] ~= nil then
        if IsOwner then
            print("isdahdnbsajdsssssssssss")
            Config.TrapHouses[TraphouseId].keyholders = {}
            Config.TrapHouses[TraphouseId].pincode = math.random(1111, 4444)
            Config.TrapHouses[TraphouseId].gang = gangss
        end

        if Config.TrapHouses[TraphouseId].keyholders == nil then
            print("shbjadsbjbjsafsadddddddddddddddd")
            Config.TrapHouses[TraphouseId].keyholders[#Config.TrapHouses[TraphouseId].keyholders+1] = {
                citizenid = CitizenId,
                owner = IsOwner,
            }
            print("syncdatasdadsad")
            TriggerClientEvent('prp-traphouse:client:SyncData', -1, TraphouseId, Config.TrapHouses[TraphouseId])
        else
            if #Config.TrapHouses[TraphouseId].keyholders + 1 <= 6 then
                if not HasCitizenIdHasKey(CitizenId, TraphouseId) then
                    print("sdsad")
                    Config.TrapHouses[TraphouseId].keyholders[#Config.TrapHouses[TraphouseId].keyholders+1] = {
                        citizenid = CitizenId,
                        owner = IsOwner,
                    }
                    print("syndadsadsd")
                    TriggerClientEvent('prp-traphouse:client:SyncData', -1, TraphouseId, Config.TrapHouses[TraphouseId])
                end
            else
                TriggerClientEvent('ProjectRP:Notify', src, 'There Are No Slots Left')
            end
        end
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'Error Has Occurred')
    end
end)

function HasCitizenIdHasKey(CitizenId, Traphouse)
    local retval = false
    if Config.TrapHouses[Traphouse].keyholders ~= nil and next(Config.TrapHouses[Traphouse].keyholders) ~= nil then
        for _, data in pairs(Config.TrapHouses[Traphouse].keyholders) do
            if data.citizenid == CitizenId then
                retval = true
                break
            end
        end
    end
    return retval
end

function AddKeyHolder(CitizenId, Traphouse, IsOwner)
    if IsOwner then
        Config.TrapHouses[Traphouse].keyholders = {}
    end
    if #Config.TrapHouses[Traphouse].keyholders <= 6 then
        if not HasCitizenIdHasKey(CitizenId, Traphouse) then
            Config.TrapHouses[Traphouse].keyholders[#Config.TrapHouses[Traphouse].keyholders+1] = {
                citizenid = CitizenId,
                owner = IsOwner,
            }
        end
    end
end

function HasTraphouseAndOwner(CitizenId)
    local retval = nil
    for Traphouse,_ in pairs(Config.TrapHouses) do
        for k, v in pairs(Config.TrapHouses[Traphouse].keyholders) do
            if v.citizenid == CitizenId then
                if v.owner then
                    retval = Traphouse
                end
            end
        end
    end
    return retval
end

ProjectRP.Commands.Add("entertraphouse", "Enter traphouse", {}, false, function(source, args)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)

    TriggerClientEvent('prp-traphouse:client:EnterTraphouse', src)
end)

ProjectRP.Commands.Add("multikeys", "Give Keys To Traphouse", {{name = "id", help = "Player id"}}, true, function(source, args)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local TargetId = tonumber(args[1])
    local TargetData = ProjectRP.Functions.GetPlayer(TargetId)
    local IsOwner = false
    local Traphouse = HasTraphouseAndOwner(Player.PlayerData.citizenid)

    if TargetData ~= nil then
        if Traphouse ~= nil then
            if not HasCitizenIdHasKey(TargetData.PlayerData.citizenid, Traphouse) then
                if Config.TrapHouses[Traphouse] ~= nil then
                    if IsOwner then
                        Config.TrapHouses[Traphouse].keyholders = {}
                        Config.TrapHouses[Traphouse].pincode = math.random(1111, 4444)
                    end

                    if Config.TrapHouses[Traphouse].keyholders == nil then
                        Config.TrapHouses[Traphouse].keyholders[#Config.TrapHouses[Traphouse].keyholders+1] = {
                            citizenid = TargetData.PlayerData.citizenid,
                            owner = IsOwner,
                        }
                        TriggerClientEvent('prp-traphouse:client:SyncData', -1, Traphouse, Config.TrapHouses[Traphouse])
                    else
                        if #Config.TrapHouses[Traphouse].keyholders + 1 <= 6 then
                            if not HasCitizenIdHasKey(TargetData.PlayerData.citizenid, Traphouse) then
                                Config.TrapHouses[Traphouse].keyholders[#Config.TrapHouses[Traphouse].keyholders+1] = {
                                    citizenid = TargetData.PlayerData.citizenid,
                                    owner = IsOwner,
                                }
                                TriggerClientEvent('prp-traphouse:client:SyncData', -1, Traphouse, Config.TrapHouses[Traphouse])
                            end
                        else
                            TriggerClientEvent('ProjectRP:Notify', src, 'There Are No Slots Left')
                        end
                    end
                else
                    TriggerClientEvent('ProjectRP:Notify', src, 'Error Has Occurred')
                end
            else
                TriggerClientEvent('ProjectRP:Notify', src, 'This Person Already Has Keys', 'error')
            end
        else
            TriggerClientEvent('ProjectRP:Notify', src, 'You Do Not Own A Traphouse Or Are Not The Owner', 'error')
        end
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'This Person Is Not In The City', 'error')
    end
end)

RegisterServerEvent('prp-traphouse:server:TakeMoney')
AddEventHandler('prp-traphouse:server:TakeMoney', function(TraphouseId)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    if Config.TrapHouses[TraphouseId].money ~= 0 then
        Player.Functions.AddMoney('cash', Config.TrapHouses[TraphouseId].money)
        Config.TrapHouses[TraphouseId].money = 0
        TriggerClientEvent('prp-traphouse:client:SyncData', -1, TraphouseId, Config.TrapHouses[TraphouseId])
    else
        TriggerClientEvent('ProjectRP:Notify', src, 'There issent any money in the cupboard', 'error')
    end
end)

function SellTimeout(traphouseId, slot, itemName, amount, info)
    Citizen.CreateThread(function()
        if itemName == "markedbills" then
            SetTimeout(math.random(1000, 5000), function()
                if Config.TrapHouses[traphouseId].inventory[slot] ~= nil then
                    RemoveHouseItem(traphouseId, slot, itemName, 1)
                    Config.TrapHouses[traphouseId].money = Config.TrapHouses[traphouseId].money + math.ceil(info.worth / 100 * 80)
                    TriggerClientEvent('prp-traphouse:client:SyncData', -1, traphouseId, Config.TrapHouses[traphouseId])
                end
            end)
        else
            for i = 1, amount, 1 do
                local SellData = Config.AllowedItems[itemName]
                SetTimeout(SellData.wait, function()
                    if Config.TrapHouses[traphouseId].inventory[slot] ~= nil then
                        RemoveHouseItem(traphouseId, slot, itemName, 1)
                        Config.TrapHouses[traphouseId].money = Config.TrapHouses[traphouseId].money + SellData.reward
                        TriggerClientEvent('prp-traphouse:client:SyncData', -1, traphouseId, Config.TrapHouses[traphouseId])
                    end
                end)
                if amount > 1 then
                    Citizen.Wait(SellData.wait)
                end
            end
        end
    end)
end

function AddHouseItem(traphouseId, slot, itemName, amount, info, source)
    local amount = tonumber(amount)
    traphouseId = tonumber(traphouseId)
    if Config.TrapHouses[traphouseId].inventory[slot] ~= nil and Config.TrapHouses[traphouseId].inventory[slot].name == itemName then
        Config.TrapHouses[traphouseId].inventory[slot].amount = Config.TrapHouses[traphouseId].inventory[slot].amount + amount
    else
        local itemInfo = ProjectRP.Shared.Items[itemName:lower()]
        Config.TrapHouses[traphouseId].inventory[slot] = {
            name = itemInfo["name"],
            amount = amount,
            info = info ~= nil and info or "",
            label = itemInfo["label"],
            description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
            weight = itemInfo["weight"],
            type = itemInfo["type"],
            unique = itemInfo["unique"],
            useable = itemInfo["useable"],
            image = itemInfo["image"],
            slot = slot,
        }
    end
    SellTimeout(traphouseId, slot, itemName, amount, info)
    TriggerClientEvent('prp-traphouse:client:SyncData', -1, traphouseId, Config.TrapHouses[traphouseId])
end

function RemoveHouseItem(traphouseId, slot, itemName, amount)
	local amount = tonumber(amount)
    traphouseId = tonumber(traphouseId)
	if Config.TrapHouses[traphouseId].inventory[slot] ~= nil and Config.TrapHouses[traphouseId].inventory[slot].name == itemName then
		if Config.TrapHouses[traphouseId].inventory[slot].amount > amount then
			Config.TrapHouses[traphouseId].inventory[slot].amount = Config.TrapHouses[traphouseId].inventory[slot].amount - amount
		else
			Config.TrapHouses[traphouseId].inventory[slot] = nil
			if next(Config.TrapHouses[traphouseId].inventory) == nil then
				Config.TrapHouses[traphouseId].inventory = {}
			end
		end
	else
		Config.TrapHouses[traphouseId].inventory[slot] = nil
		if Config.TrapHouses[traphouseId].inventory == nil then
			Config.TrapHouses[traphouseId].inventory[slot] = nil
		end
	end
    TriggerClientEvent('prp-traphouse:client:SyncData', -1, traphouseId, Config.TrapHouses[traphouseId])
end

function GetInventoryData(traphouse, slot)
    traphouse = tonumber(traphouse)
    if Config.TrapHouses[traphouse].inventory[slot] ~= nil then
        return Config.TrapHouses[traphouse].inventory[slot]
    else
        return nil
    end
end

function CanItemBeSaled(item)
    local retval = false
    if Config.AllowedItems[item] ~= nil then
        retval = true
    elseif item == "markedbills" then
        retval = true
    end
    return retval
end




RegisterServerEvent("Traphouse:Give")
AddEventHandler("Traphouse:Give", function(data,Traphouse)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)

    TriggerEvent("prp-log:server:CreateLog", "traphouse", "Player Entered", "green", "**Steam Name** \n".. GetPlayerName(src) .. "\n **ID:**\n" ..src.. "\n (citizenid: *"..Player.PlayerData.citizenid.."* \nPlayer has entered the Traphouse with Pincode: ``"..data.pincode.. "``| Entrance: ``"..Config.TrapHouses[Traphouse].coords["enter"].. "`` | Traphouse")
end)

RegisterServerEvent("Axel:Is:Cute")
AddEventHandler("Axel:Is:Cute", function(Traphouse)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local Chance = math.random(1, 10)
    local odd = math.random(1, 10)

        if Chance == odd then
            local info = {
                label = "Traphouse Pincode: "..Config.TrapHouses[Traphouse].pincode
            }
            Player.Functions.AddItem("stickynote", 1, false, info)
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["stickynote"], "add")

            TriggerEvent("prp-log:server:CreateLog", "traphouse", "Pin Recieved", "green", "**Steam Name** \n".. GetPlayerName(src) .. "\n **ID:**\n" ..src.. "\n (citizenid: *"..Player.PlayerData.citizenid.."* \nPlayer has Robbed an NPC and found the Traphouse Pincode: ``"..Config.TrapHouses[Traphouse].pincode.. "``| Entrance: ``"..Config.TrapHouses[Traphouse].coords["enter"].. "`` | Traphouse")
        
        end

end)
RegisterServerEvent('RobNpc')
AddEventHandler('RobNpc', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local Chance = math.random(1, 10)
    local odd = math.random(1, 10)

    -- if Chance == odd then
    --     local info = {
    --         label = "Traphouse Pincode: "..Config.TrapHouses[Traphouse].pincode
    --     }
    --     Player.Functions.AddItem("stickynote", 1, false, info)
    --     TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["stickynote"], "add")

    --     TriggerEvent("prp-log:server:CreateLog", "traphouse", "Pin Recieved", "green", "**Steam Name** \n".. GetPlayerName(src) .. "\n **ID:**\n" ..src.. "\n (citizenid: *"..Player.PlayerData.citizenid.."* \nPlayer has Robbed an NPC and found the Traphouse Pincode: ``"..Config.TrapHouses[Traphouse].pincode.. "``| Entrance: ``"..Config.TrapHouses[Traphouse].coords["enter"].. "`` | Traphouse")
    
    -- else
        local amount = math.random(1, 80)
        Player.Functions.AddMoney('cash', amount)
    -- end
end)

ProjectRP.Functions.CreateCallback('prp-traphouse:server:GetTraphousesData', function(source, cb)
    cb(Config.TrapHouses)
end)


RegisterServerEvent("traphouse:takeover:notify")
AddEventHandler("traphouse:takeover:notify", function(trapid)


    TriggerClientEvent("Axel:Is:sEXYa:ASADA",-1, Config.TrapHouses[trapid].gang)
end)