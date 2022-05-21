-- Variables
local coin = Crypto.Coin
local ProjectRP = exports['prp-core']:GetCoreObject()
local bannedCharacters = {'%','$',';'}

-- Function
local function RefreshCrypto()
    local result = MySQL.Sync.fetchAll('SELECT * FROM crypto WHERE crypto = ?', { coin })
    if result ~= nil and result[1] ~= nil then
        Crypto.Worth[coin] = result[1].worth
        if result[1].history ~= nil then
            Crypto.History[coin] = json.decode(result[1].history)
            TriggerClientEvent('prp-crypto:client:UpdateCryptoWorth', -1, coin, result[1].worth, json.decode(result[1].history))
        else
            TriggerClientEvent('prp-crypto:client:UpdateCryptoWorth', -1, coin, result[1].worth, nil)
        end
    end
end

local function ErrorHandle(error)
    for k, v in pairs(Ticker.Error_handle) do
        if string.match(error, k) then
            return v
        end
    end
    return false
end

local function GetTickerPrice() -- Touch = no help
    local ticker_promise = promise.new()
    PerformHttpRequest("https://min-api.cryptocompare.com/data/price?fsym=" .. Ticker.coin .. "&tsyms=" .. Ticker.currency .. '&api_key=' .. Ticker.Api_key, function(Error, Result, _)
        local result_obj = json.decode(Result)
        if not result_obj['Response'] then
            local this_resolve = {error =  Error, response_data = result_obj[string.upper(Ticker.currency)]}
            ticker_promise:resolve(this_resolve) --- Could resolve Error aswell for more accurate Error messages? Solved in else
        else
            local this_resolve = {error =  result_obj['Message']}
            ticker_promise:resolve(this_resolve)
        end
    end, 'GET')
    Citizen.Await(ticker_promise)
    if type(ticker_promise.value.error) ~= 'number' then
        local get_user_friendly_error = ErrorHandle(ticker_promise.value.error)
        if get_user_friendly_error then
            return get_user_friendly_error
        else
            return '\27[31m Unexpected error \27[0m' --- Raised an error which we did not expect, script should be capable of sticking with last recorded price and shutting down the sync logic
        end
    else
        return ticker_promise.value.response_data
    end
end

local function HandlePriceChance()
    local currentValue = Crypto.Worth[coin]
    local prevValue = Crypto.Worth[coin]
    local trend = math.random(0,100)
    local event = math.random(0,100)
    local chance = event - Crypto.ChanceOfCrashOrLuck

    if event > chance then
        if trend <= Crypto.ChanceOfDown then
            currentValue = currentValue - math.random(Crypto.CasualDown[1], Crypto.CasualDown[2])
        elseif trend >= Crypto.ChanceOfUp then
            currentValue = currentValue + math.random(Crypto.CasualUp[1], Crypto.CasualUp[2])
        end
    else
        if math.random(0, 1) == 1 then
            currentValue = currentValue + math.random(Crypto.Luck[1], Crypto.Luck[2])
        else
            currentValue = currentValue - math.random(Crypto.Crash[1], Crypto.Crash[2])
        end
    end

    if currentValue <= Crypto.Lower then
        currentValue = Crypto.Lower
    elseif currentValue >= Crypto.Upper then
        currentValue = Crypto.Upper
    end

    if Crypto.History[coin][4] then
        Crypto.History[coin][1] = {PreviousWorth = prevValue, NewWorth = currentValue}
    else
        Crypto.History[coin][#Crypto.History[coin] + 1] = {PreviousWorth = prevValue, NewWorth = currentValue}
    end

    Crypto.Worth[coin] = currentValue

    MySQL.Async.insert('INSERT INTO crypto (worth, history) VALUES (:worth, :history) ON DUPLICATE KEY UPDATE worth = :worth, history = :history', {
        ['worth'] = currentValue,
        ['history'] = json.encode(Crypto.History[coin]),
    })
    RefreshCrypto()
end

-- Commands

ProjectRP.Commands.Add("setcryptoworth", "Set crypto value", {{name="crypto", help="Name of the crypto currency"}, {name="Value", help="New value of the crypto currency"}}, false, function(source, args)
    local src = source
    local crypto = tostring(args[1])

    if crypto ~= nil then
        if Crypto.Worth[crypto] ~= nil then
            local NewWorth = math.ceil(tonumber(args[2]))

            if NewWorth ~= nil then
                local PercentageChange = math.ceil(((NewWorth - Crypto.Worth[crypto]) / Crypto.Worth[crypto]) * 100)
                local ChangeLabel = "+"

                if PercentageChange < 0 then
                    ChangeLabel = "-"
                    PercentageChange = (PercentageChange * -1)
                end

                if Crypto.Worth[crypto] == 0 then
                    PercentageChange = 0
                    ChangeLabel = ""
                end

                Crypto.History[crypto][#Crypto.History[crypto]+1] = {
                    PreviousWorth = Crypto.Worth[crypto],
                    NewWorth = NewWorth
                }

                TriggerClientEvent('ProjectRP:Notify', src, "You have the value of "..Crypto.Labels[crypto].."adapted from: ($"..Crypto.Worth[crypto].." to: $"..NewWorth..") ("..ChangeLabel.." "..PercentageChange.."%)")
                Crypto.Worth[crypto] = NewWorth
                TriggerClientEvent('prp-crypto:client:UpdateCryptoWorth', -1, crypto, NewWorth)
                MySQL.Async.insert('INSERT INTO crypto (worth, history) VALUES (:worth, :history) ON DUPLICATE KEY UPDATE worth = :worth, history = :history', {
                    ['worth'] = NewWorth,
                    ['history'] = json.encode(Crypto.History[crypto]),
                })
            else
                TriggerClientEvent('ProjectRP:Notify', src, "You have not given a new value .. Current values: "..Crypto.Worth[crypto])
            end
        else
            TriggerClientEvent('ProjectRP:Notify', src, "This Crypto does not exist :(, available: Qbit")
        end
    else
        TriggerClientEvent('ProjectRP:Notify', src, "You have not provided Crypto, available: Qbit")
    end
end, "admin")

ProjectRP.Commands.Add("checkcryptoworth", "", {}, false, function(source)
    local src = source
    TriggerClientEvent('ProjectRP:Notify', src, "The Qbit has a value of: $"..Crypto.Worth["qbit"])
end)

ProjectRP.Commands.Add("crypto", "", {}, false, function(source)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local MyPocket = math.ceil(Player.PlayerData.money.crypto * Crypto.Worth["qbit"])

    TriggerClientEvent('ProjectRP:Notify', src, "You have: "..Player.PlayerData.money.crypto.." QBit, with a value of: $"..MyPocket..",-")
end)

-- Events

RegisterServerEvent('prp-crypto:server:FetchWorth', function()
    for name,_ in pairs(Crypto.Worth) do
        local result = MySQL.Sync.fetchAll('SELECT * FROM crypto WHERE crypto = ?', { name })
        if result[1] ~= nil then
            Crypto.Worth[name] = result[1].worth
            if result[1].history ~= nil then
                Crypto.History[name] = json.decode(result[1].history)
                TriggerClientEvent('prp-crypto:client:UpdateCryptoWorth', -1, name, result[1].worth, json.decode(result[1].history))
            else
                TriggerClientEvent('prp-crypto:client:UpdateCryptoWorth', -1, name, result[1].worth, nil)
            end
        end
    end
end)

RegisterServerEvent('prp-crypto:server:ExchangeFail', function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local ItemData = Player.Functions.GetItemByName("cryptostick")

    if ItemData ~= nil then
        Player.Functions.RemoveItem("cryptostick", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["cryptostick"], "remove")
        TriggerClientEvent('ProjectRP:Notify', src, "Cryptostick malfunctioned", 'error')
    end
end)

RegisterServerEvent('prp-crypto:server:Rebooting', function(state, percentage)
    Crypto.Exchange.RebootInfo.state = state
    Crypto.Exchange.RebootInfo.percentage = percentage
end)

RegisterServerEvent('prp-crypto:server:GetRebootState', function()
    local src = source
    TriggerClientEvent('prp-crypto:client:GetRebootState', src, Crypto.Exchange.RebootInfo)
end)

RegisterServerEvent('prp-crypto:server:SyncReboot', function()
    TriggerClientEvent('prp-crypto:client:SyncReboot', -1)
end)

RegisterServerEvent('prp-crypto:server:ExchangeSuccess', function(LuckChance)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local ItemData = Player.Functions.GetItemByName("cryptostick")

    if ItemData ~= nil then
        local LuckyNumber = math.random(1, 20)
        local DeelNumber = 100
        local Amount = (math.random(10, 30) / DeelNumber)
        if LuckChance == LuckyNumber then
            Amount = (math.random(30, 50) / DeelNumber)
        end

        Player.Functions.RemoveItem("cryptostick", 1)
        Player.Functions.AddMoney('crypto', Amount, 'cryptostick')
        TriggerClientEvent('ProjectRP:Notify', src, "You have exchanged your Cryptostick for: "..Amount.." QBit(\'s)", "success", 3500)
        TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items["cryptostick"], "remove")
        TriggerClientEvent('prp-phone:client:AddTransaction', src, Player, {}, "There are "..Amount.." Qbit('s) credited!", "Credit")
    end
end)

-- Callbacks

ProjectRP.Functions.CreateCallback('prp-crypto:server:HasSticky', function(source, cb)
    local Player = ProjectRP.Functions.GetPlayer(source)
    local Item = Player.Functions.GetItemByName("cryptostick")

    if Item ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

ProjectRP.Functions.CreateCallback('prp-crypto:server:GetCryptoData', function(source, cb, name)
    local Player = ProjectRP.Functions.GetPlayer(source)
    local CryptoData = {
        History = Crypto.History[name],
        Worth = Crypto.Worth[name],
        Portfolio = Player.PlayerData.money.crypto,
        WalletId = Player.PlayerData.metadata["walletid"],
    }

    cb(CryptoData)
end)

ProjectRP.Functions.CreateCallback('prp-crypto:server:BuyCrypto', function(source, cb, data)
    local Player = ProjectRP.Functions.GetPlayer(source)
    local total_price = tonumber(data.Coins) * tonumber(Crypto.Worth["qbit"])
    if Player.PlayerData.money.bank >= total_price then
        local CryptoData = {
            History = Crypto.History["qbit"],
            Worth = Crypto.Worth["qbit"],
            Portfolio = Player.PlayerData.money.crypto + tonumber(data.Coins),
            WalletId = Player.PlayerData.metadata["walletid"],
        }
        Player.Functions.RemoveMoney('bank', total_price, 'buy-crypto')
        TriggerClientEvent('prp-phone:client:AddTransaction', source, Player, data, "You have "..tonumber(data.Coins).." Qbit('s) purchased!", "Credit")
        Player.Functions.AddMoney('crypto', tonumber(data.Coins))
        cb(CryptoData)
    else
        cb(false)
    end
end)

ProjectRP.Functions.CreateCallback('prp-crypto:server:SellCrypto', function(source, cb, data)
    local Player = ProjectRP.Functions.GetPlayer(source)
    
    if Player.PlayerData.money.crypto >= tonumber(data.Coins) then
        local CryptoData = {
            History = Crypto.History["qbit"],
            Worth = Crypto.Worth["qbit"],
            Portfolio = Player.PlayerData.money.crypto - tonumber(data.Coins),
            WalletId = Player.PlayerData.metadata["walletid"],
        }
        Player.Functions.RemoveMoney('crypto', tonumber(data.Coins), 'sold-crypto')
        TriggerClientEvent('prp-phone:client:AddTransaction', source, Player, data, "You have "..tonumber(data.Coins).." Qbit('s) sold!", "Depreciation")
        Player.Functions.AddMoney('bank', tonumber(data.Coins) * tonumber(Crypto.Worth["qbit"]))
        cb(CryptoData)
    else
        cb(false)
    end
end)

ProjectRP.Functions.CreateCallback('prp-crypto:server:TransferCrypto', function(source, cb, data)
    local newCoin = tostring(data.Coins)
    local newWalletId = tostring(data.WalletId)
    for _, v in pairs(bannedCharacters) do
        newCoin = string.gsub(newCoin, '%' .. v, '')
        newWalletId = string.gsub(newWalletId, '%' .. v, '')
    end
    data.WalletId = newWalletId
    data.Coins = tonumber(newCoin)
    local Player = ProjectRP.Functions.GetPlayer(source)
    if Player.PlayerData.money.crypto >= tonumber(data.Coins) then
        local query = '%"walletid":"' .. data.WalletId .. '"%'
        local result = MySQL.Sync.fetchAll('SELECT * FROM `players` WHERE `metadata` LIKE ?', { query })
        if result[1] ~= nil then
            local CryptoData = {
                History = Crypto.History["qbit"],
                Worth = Crypto.Worth["qbit"],
                Portfolio = Player.PlayerData.money.crypto - tonumber(data.Coins),
                WalletId = Player.PlayerData.metadata["walletid"],
            }
            Player.Functions.RemoveMoney('crypto', tonumber(data.Coins))
            TriggerClientEvent('prp-phone:client:AddTransaction', source, Player, data, "You have "..tonumber(data.Coins).." Qbit('s) transferred!", "Depreciation")
            local Target = ProjectRP.Functions.GetPlayerByCitizenId(result[1].citizenid)

            if Target ~= nil then
                Target.Functions.AddMoney('crypto', tonumber(data.Coins))
                TriggerClientEvent('prp-phone:client:AddTransaction', Target.PlayerData.source, Player, data, "There are "..tonumber(data.Coins).." Qbit('s) credited!", "Credit")
            else
                local MoneyData = json.decode(result[1].money)
                MoneyData.crypto = MoneyData.crypto + tonumber(data.Coins)
                MySQL.Async.execute('UPDATE players SET money = ? WHERE citizenid = ?', { json.encode(MoneyData), result[1].citizenid })
            end
            cb(CryptoData)
        else
            cb("notvalid")
        end
    else
        cb("notenough")
    end
end)

-- Threads

CreateThread(function()
    while true do
        Wait(Crypto.RefreshTimer*60000)
        HandlePriceChance()
    end
end)

-- You touch = you break
if Ticker.Enabled then
    Citizen.CreateThread(function()
        local Interval = Ticker.tick_time * 60000
        if Ticker.tick_time < 2 then
            Interval = 120000
        end
        while(true) do
            local get_coin_price = GetTickerPrice()
            if type(get_coin_price) == 'number' then
                Crypto.Worth["qbit"] = get_coin_price
            else
                print('\27[31m' .. get_coin_price .. '\27[0m')
                Ticker.Enabled = false
                break
            end
            Citizen.Wait(Interval)
        end
    end)
end