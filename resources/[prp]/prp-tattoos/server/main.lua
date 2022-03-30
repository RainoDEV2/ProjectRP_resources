local ProjectRP = exports["prp-core"]:GetCoreObject()

RegisterNetEvent("Mx :: GetTattoos")
AddEventHandler("Mx :: GetTattoos", function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    if Player then
        local citizenid = Player.PlayerData.citizenid
        exports.oxmysql:execute("SELECT * FROM tattoos where identifier = @identifier", {['@identifier'] = citizenid},
        function(result)
            if result and #result > 0 then
                for i,k in pairs(result) do
                    k.tattoos = json.decode(k.tattoos)
                end
                TriggerClientEvent("Mx :: TattoosGeted", src, result[1].tattoos)
            else
                TriggerClientEvent("Mx :: TattoosGeted", src, {})
            end
        end)  
    end
end)

RegisterNetEvent("Mx :: RegisterTattoos")
AddEventHandler("Mx :: RegisterTattoos", function(tattoos, total_price, free)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local MoneyPlayer = Player.PlayerData.money['cash']

    if (total_price == 0 or MoneyPlayer >= total_price) or free then
        exports.oxmysql:execute('UPDATE tattoos SET tattoos = @tattoos WHERE identifier = @identifier', {
            ['@tattoos'] = json.encode(tattoos), 
            ['@identifier'] = citizenid
        }, function (rows)
            if rows.affectedRows == 0 then
                exports.oxmysql:execute('INSERT INTO tattoos (identifier, tattoos) VALUES (@identifier, @tattoos)', {
                    ['@identifier'] = citizenid,
                    ['@tattoos'] = json.encode(tattoos)
                }, function (rows)
                    if not free then Player.Functions.RemoveMoney('cash', tonumber(total_price)) end
                    TriggerClientEvent("Mx :: ClosedStore", src, tattoos, total_price)
                end)
            else
                if not free then Player.Functions.RemoveMoney('cash', tonumber(total_price)) end
                TriggerClientEvent("Mx :: ClosedStore", src, tattoos, total_price)
            end
        end)
    else
        TriggerClientEvent("Mx :: ClosedStore", src, -1, -1)
    end
end)


ProjectRP.Commands.Add("deltattoos", "Remove tattoos from your body", {}, false, function(source)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
	local citizenid = Player.PlayerData.citizenid
	local tattoos = {}
    if Player then
    exports.oxmysql:execute('UPDATE tattoos SET tattoos = @tattoos WHERE identifier = @identifier', {
            ['@tattoos'] = json.encode(tattoos), 
            ['@identifier'] = citizenid
        }, function (result)
        print(result)
		end)
		TriggerClientEvent("deltattoosCl", src)
    end
end)