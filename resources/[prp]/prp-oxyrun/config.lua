local ProjectRP = exports['prp-core']:GetCoreObject()
Config = {}

-- Oxy runs.
Config.StartOxyPayment = 750 -- How much you pay at the start to start the run

Config.RunAmountMin = 10 -- Min drop offs the player does before it automatixally stops.
Config.RunAmountMax = 15 -- Max drop offs the player does before it automatixally stops.

Config.PaymentMin = 280 -- Min money you get paid when RN Jesus doesnt give you oxy, divided by 3 for when it does.
Config.PaymentMax = 580 -- Max money you get paid when RN Jesus doesnt give you oxy, divided by 3 for when it does.

Config.Item = "oxy" -- The item you receive from the oxy run. Should be oxy right??
Config.OxyChance = 500 -- Percentage chance of getting oxy on the run. Multiplied by 100. 10% = 100, 20% = 200, 50% = 500, etc. Default 55%.
Config.OxyAmountMin = 2 -- Min oxy you get when RN Jesus gives you oxy. Default: 1.
Config.OxyAmountMax = 5 -- Max oxy you get when RN Jesus gives you oxy. Default: 1.

Config.BigRewarditemChance = 200 -- Percentage of getting rare item on oxy run. Multiplied by 100. 0.1% = 1, 1% = 10, 20% = 200, 50% = 500, etc.
Config.BigRewarditem = "trojan_usb" -- Rare item.

Config.OxyCars = "CHECK THE CODE" -- Cars

Config.DropOffs = "CHECK THE CODE" -- Drop off spots