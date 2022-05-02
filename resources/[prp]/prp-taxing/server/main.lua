local ProjectRP = exports['prp-core']:GetCoreObject()

local flyin = Config.flyin -- minimum bank value to be taxed in this bracket
local poor = Config.poor -- minimum bank value to be taxed in this bracket
local notbad = Config.notbad -- mininum bank value to be taxed in this bracket
local medium = Config.medium -- mininum bank value to be taxed in this bracket
local rich = Config.rich -- mininum bank value to be taxed in this bracket
local toorich = Config.toorich -- mininum bank value to be taxed in this bracket
local percentage = {}


--     flyinperc = 0,
--     poorperc = 1,
--     notbadperc = 2,
--     mediumperc = 4,
--     richperc = 6,
--     toorichperc = 8,


RegisterServerEvent("prp-taxing:server:Display")
AddEventHandler("prp-taxing:server:Display", function()
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local bankamount = Player.PlayerData.money['bank']
    local bracket = {}
    if bankamount > flyin and bankamount <= poor then
        bracket = flyin
        percentage = Config.TaxBracket1
    elseif bankamount > poor and bankamount <= notbad then
        bracket = poor
        percentage = Config.TaxBracket2
    elseif bankamount > notbad and bankamount <= medium then
        bracket = notbad
        percentage = Config.TaxBracket3
    elseif bankamount > medium and bankamount <= rich then
        bracket = medium
        percentage = Config.TaxBracket4
    elseif bankamount > rich and bankamount <= toorich then
        bracket = rich
        percentage = Config.TaxBracket5
    elseif bankamount > toorich then
        bracket = toorich
        percentage = Config.TaxBracket6
    end
    TriggerClientEvent("ProjectRP:Notify", src, "Your Current Tax Bracket is $" ..bracket.. " Tax Percentage is " ..percentage.. "!")
end)

function toint(n)
    local s = tostring(n)
    local i, j = s:find('%.')
    if i then
        return tonumber(s:sub(1, i-1))
    else
        return n
    end
end

RegisterServerEvent('prp-taxing:server:paytaxes')
AddEventHandler('prp-taxing:server:paytaxes', function(amount)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local bankamount = Player.PlayerData.money.bank
    local tax = (bankamount / 100 * Config.TaxBracket1) 
    local tax1 = (bankamount / 100 * Config.TaxBracket2) 
    local tax2 = (bankamount / 100 * Config.TaxBracket3) 
    local tax3 = (bankamount / 100 * Config.TaxBracket4) 
    local tax4 = (bankamount / 100 * Config.TaxBracket5) 

    if bankamount <= poor then
        TriggerClientEvent('ProjectRP:Notify', source, "You do not have enough money to be taxed" , "error")
        TriggerEvent("prp-log:server:CreateLog", Config.Logs, "Taxes", "red", "**"..GetPlayerName(src) .. "** has paid $"..tax.."in taxes.")
    elseif bankamount > poor and bankamount <= notbad then
        Player.Functions.RemoveMoney('bank', toint(tax), "Taxes paid")
        exports["prp-management"]:AddMoney(Config.Job, tax)
        TriggerEvent("prp-log:server:CreateLog", Config.Logs, "Taxes", "red", "**"..GetPlayerName(src) .. "** has paid $"..tax1.."in taxes.")
    elseif bankamount > notbad and bankamount <= medium then
        Player.Functions.RemoveMoney('bank', toint(tax1), "Taxes paid")
        exports["prp-management"]:AddMoney(Config.Job, tax1)
        TriggerEvent("prp-log:server:CreateLog", Config.Logs, "Taxes", "red", "**"..GetPlayerName(src) .. "** has paid $"..tax1.."in taxes.")
    elseif bankamount > medium and bankamount <= rich then
        Player.Functions.RemoveMoney('bank', toint(tax2), "Taxes paid")
        exports["prp-management"]:AddMoney(Config.Job, tax2)
        TriggerEvent("prp-log:server:CreateLog", Config.Logs, "Taxes", "red", "**"..GetPlayerName(src) .. "** has paid $"..tax2.."in taxes.")
    elseif bankamount > rich and bankamount <= toorich then
        Player.Functions.RemoveMoney('bank', toint(tax3), "Taxes paid")
        exports["prp-management"]:AddMoney(Config.Job, tax3)
        TriggerEvent("prp-log:server:CreateLog", Config.Logs, "Taxes", "red", "**"..GetPlayerName(src) .. "** has paid $"..tax3.."in taxes.")
    elseif bankamount > toorich then
        Player.Functions.RemoveMoney('bank', toint(tax4), "Taxes paid")
        exports["prp-management"]:AddMoney(Config.Job, tax4)
        TriggerEvent("prp-log:server:CreateLog", Config.Logs, "Taxes", "red", "**"..GetPlayerName(src) .. "** has paid $"..tax4.."in taxes.")
    end
end)