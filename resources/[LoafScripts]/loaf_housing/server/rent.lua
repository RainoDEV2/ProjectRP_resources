CreateThread(function()
    lib.RegisterCallback("loaf_housing:fetch_rent_balance", function(source, cb, wallet)
        MySQL.Async.fetchAll("SELECT `balance`, `rent_due` FROM `loaf_rent` WHERE `rent_wallet`=@wallet", {
            ["@wallet"] = wallet
        }, function(res)
            if not res or not res[1] then cb(false) end
            cb(res[1].balance, os.date("%Y-%m-%d @ %H:%M", res[1].rent_due))
        end)
    end)

    lib.RegisterCallback("loaf_housing:deposit_rent", function(source, cb, wallet, amount)
        if amount < 0 then return cb(false) end
        if not PayMoney(source, amount) then cb(false) end

        MySQL.Async.execute("UPDATE `loaf_rent` SET `balance`=`balance`+@amount WHERE `rent_wallet`=@wallet", {
            ["@amount"] = amount,
            ["@wallet"] = wallet
        }, function()
            Notify(source, Strings["deposited_rent"]:format(amount))
            cb(true)
        end)
    end)

    local CHECK_INTERVAL = 30 -- how many minutes between each rent check
    local function CheckRent()
        print("Checking rent")
        MySQL.Async.fetchAll("SELECT `rent_wallet`, `propertyid`, `owner`, `balance`, `rent_due` FROM `loaf_rent` WHERE `rent_due`<@time", {
            ["@time"] = os.time()
        }, function(result)
            -- print(Config.RentInterval/60/60/24)
            if not result then return end
            
            for _, v in pairs(result) do
                local houseData = Houses[v.propertyid]
                local rent = houseData.rent or 0
                if v.balance >= houseData.rent then 
                    MySQL.Async.execute("UPDATE `loaf_rent` SET `balance`=`balance`-@rent, `rent_due`=@due WHERE `rent_wallet`=@wallet", {
                        ["@rent"] = rent,
                        ["@due"] = os.time() + Config.RentInterval,
                        ["@wallet"] = v.rent_wallet
                    }, function()
                        print("wallet", v.rent_wallet, "paid their rent")
                    end)
                else
                    print("wallet",v.rent_wallet,"did not have enough money. removed house")
                    RemoveProperty(v.owner, v.propertyid)
                end
            end
        end)
        SetTimeout(CHECK_INTERVAL * 60 * 1000, CheckRent)
    end

    Wait(10000)
    CheckRent()
end)