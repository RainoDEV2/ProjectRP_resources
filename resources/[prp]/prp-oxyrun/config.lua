local ProjectRP = exports['prp-core']:GetCoreObject()
Config = {}

-- Oxy runs.
Config.StartOxyPayment = 700 -- How much you pay at the start to start the run

Config.RunAmount = math.random(10,15) -- How many drop offs the player does before it automatixally stops.

Config.Payment = math.random(330,410) -- How much you get paid when RN Jesus doesnt give you oxy, divided by 2 for when it does.

Config.Item = "oxy" -- The item you receive from the oxy run. Should be oxy right??
Config.OxyChance = 400 -- Percentage chance of getting oxy on the run. Multiplied by 100. 10% = 100, 20% = 200, 50% = 500, etc. Default 55%.
Config.OxyAmount = math.random(2,5) -- How much oxy you get when RN Jesus gives you oxy. Default: 1.

Config.BigRewarditemChance = 200 -- Percentage of getting rare item on oxy run. Multiplied by 100. 0.1% = 1, 1% = 10, 20% = 200, 50% = 500, etc.
Config.BigRewarditem = "trojan_usb" -- Rare item.

Config.OxyCars = "CHECK THE CODE" -- Cars

Config.DropOffs = "CHECK THE CODE" -- Drop off spots