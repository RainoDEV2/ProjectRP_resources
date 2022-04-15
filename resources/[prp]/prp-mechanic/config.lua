Loc = {}
Config = {}

Config.Lan = "en" -- Pick your language here

Config.Debug = false -- Set to true to show green debug boxes to help track

Config.img = "prp-inventory/html/images/" -- Set this to the directory for your inventory image files

Config.distkph = false -- Set to false to read distance travelled in Miles.

-- Main variables

Config.UseMechJob = true -- Enable this if you want to use prp-mechanicjob to get extra vehicle damages/repairs

Config.isVehicleOwned = false -- Keep this true if you only want changes to be made to owned vehicles

Config.RequiresJob = true  -- Do the specfic items require the mechanic job?

Config.LocationBlips = false -- Enable to grab the blip locations from locations.lua

Config.LocationRequired = false -- Are the mecahnics locked to specific locations? -- IF FALSE, DISABLES JobRequiredForLocation --

Config.JobRequiredForLocation = true -- Enable this if the job locations require a SPECIFIED ROLE (specified in locations.lua)

Config.CosmeticsJob = false -- Do vehicle cosmetics require a mechanic job role?

Config.FreeRepair = false  -- Are repairs free? True means yes

Config.StashRepair = true -- Enable for repair materials to be removed from a job stash

Config.Stores = false -- Set true to turn on shop storage features

Config.Crafting = true -- Set true to turn on crafting features

Config.StashCraft = true  -- Set true to grab materials from mechaincs stash for crafting

Config.PreviewPhone = false -- Enable this is preview menu generates an email, False if you want to give an item

Config.PreviewJob = false -- Enable this if you want the preview menu to require a Job Role or Location Checks


--THESE ARE MAX AMOUNTS
Config.RepairEngine = "iron"  ---Engine repair item and its cost
Config.RepairEngineCost = 5

Config.RepairBody = "plastic"  ---Body Repair item and its cost
Config.RepairBodyCost = 5

Config.RepairRadiator = "plastic"  ---Radiator Repair item and its cost
Config.RepairRadiatorCost = 5

Config.RepairAxle = "steel"  ---DriveShaft Repair item and its cost
Config.RepairAxleCost = 5

Config.RepairBrakes = "iron"  ---Brakes Repair item and its cost
Config.RepairBrakesCost = 5

Config.RepairClutch = "aluminum"  ---Clutch Repair item and its cost
Config.RepairClutchCost = 5

Config.RepairFuel = "plastic"  ---Fuel Repair item and its cost
Config.RepairFuelCost = 5

--DuctTape Controllers
Config.DuctSimpleMode = true -- This will repair the engine to the max (set below)

Config.MaxDuctEngine = 450.0 -- 450.0 is 45% health, this will be the max amount that it can be repaired to
Config.DuctAmountEngine = 100.0 -- Repairs the engine by 10% each use

Config.DuctTapeBody = true  --Enable if you want duct tape to repair body at the same time as engine
Config.MaxDuctBody = 450.0
Config.DuctAmountBody = 100.0 -- Repairs the engine by 10% each use

Config.RemoveDuctTape = true --If Enabled it will remove 1 duct after use. If false it will be constantly reusable

Config.JobRoles = { "mechanic" } -- Add your extra job roles here or just leave as "mechanic"

--Example--
--Config.JobRoles = { "mechanic", "tuner" }