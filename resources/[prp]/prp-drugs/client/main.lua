local CurrentCops = 0

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

-- Code

RegisterNetEvent('prp-drugs:AddWeapons')
AddEventHandler('prp-drugs:AddWeapons', function()
    Config.Dealers[2]["products"][#Config.Dealers[2]["products"]+1] = {
        name = "weapon_snspistol",
        price = 5000,
        amount = 1,
        info = {
            serie = tostring(ProjectRP.Shared.RandomInt(2) .. ProjectRP.Shared.RandomStr(3) .. ProjectRP.Shared.RandomInt(1) .. ProjectRP.Shared.RandomStr(2) .. ProjectRP.Shared.RandomInt(3) .. ProjectRP.Shared.RandomStr(4))
        },
        type = "item",
        slot = 5,
        minrep = 200,
    }
    Config.Dealers[3]["products"][#Config.Dealers[3]["products"]+1] = {
        name = "weapon_snspistol",
        price = 5000,
        amount = 1,
        info = {
            serie = tostring(ProjectRP.Shared.RandomInt(2) .. ProjectRP.Shared.RandomStr(3) .. ProjectRP.Shared.RandomInt(1) .. ProjectRP.Shared.RandomStr(2) .. ProjectRP.Shared.RandomInt(3) .. ProjectRP.Shared.RandomStr(4))
        },
        type = "item",
        slot = 5,
        minrep = 200,
    }
end)
