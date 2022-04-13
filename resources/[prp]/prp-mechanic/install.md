If you need support I now have a discord available, it helps me keep track of issues and give better support.

https://discord.gg/xKgQZ6wZvS

Update 2.2.1:
	- Preview.lua fixes/changes (preview.lua, functionserver.lua)
		- If you now drive the vehicle away from when you typed /preview it class it as completed and give the result
		- Removed unessessary prints from preview.lua
		- Added message for the people who keep spawning "mechboard" instead of reading the MechanicGuide.txt
	- Changes to locations.lua and functions.lua to improve the JobChecks
		- It appeared to be restricting workers more than civilians, this should be fixed now
	- Few more changes to NOS.lua..hopefuly optimizing it and may fix something else? I don't know
	- Added missing stash locations to repair.lua
	- Included spraycan.png, sorry
	
Update 2.2:
	- Added new Cosmetic Preview Menu
		- Adds new file preview.lua
		- Adds new events to functionserver.lua
		- Adds new Config.lua options, PreviewPhone and PreviewJob
		- Adds new item the "mechboard", this item shows the list of cosmetic changes from the preview menu
		- Full installion of the "mechboard" item is below
	- Added Item duplicating detection and kicking of players who do it (functionserver.lua)
		- This adds 1-2 lines to all removeable items files (armour, brakes, engines, suspension, tires, transmission, turbo, xenons)
	- Fixes and changes to repair.lua, police.lua and check_tunes.lua
		- Custom plates were causing vehicle damages not to be detected
	- Converted to use qb-mechanicjob exports instead of callbacks (repair.lua)
	- Changes to nos.lua and nosserver.lua
		- Attempt to fix nos randomly filling after use and stopping of the vehicle
	- Update GetVehicle SetVehicle functions
		- Fixes normal colors not saving.
	- Added getClass() function to show Vehicle Class (check_tunes.lua, functions.lua, repair.lua)
	- Updated install.md with preview info
	- Updated MechanicGuide.txt with preview info
	
Update 2.1.2:
	- Remove leftover qb-ui testing stuff (extras.lua)
	- Fixed pearlescent colours being removed when adding wheel colour (paints.lua)
	- Included updated GetVehicleProperties and SetVehicleProperties
		- This will hopefully fix issues people where having with saving certain parts of the vehicles

Update 2.1.1:
	- Auto fix engine and Body to 0 if value is too low (repair.lua)
	- AcualIncluded missing GetVehicleProperties and SetVehicleProperties
	- Added NOS Cooldown to reduce spamming of NOS to get insane boosts(nos.lua)

Update 2.1:
	- Fixed livery issues (police.lua & livery.lua)
		- Issues like claiming stock was installed when it wasn't
	- Added RGB Paint tool for Primary and Secondary (new file paintrgb.lua and edited paints.lua)
		- New spraying animations to go along with paints.lua and paintsrgb.lua
		- This adds a new button the "paintcan" item menu
	- Included edited GetVehicleProperties and SetVehicleProperties functions to be replaced in qb-core
		- This enables the saving of Drift Wheels, BulletProof Wheels, RGB Paint and their finishes.
	- Added Support for planes, boats and helicopters (functions.lua)
		- This requires slight edits to every client file
		- Replace "GetClosestVehicle(coords.x, coords.y, coords.z, 3.5, 0, 71)" with "getClosest(coords)"
		
Update 2.0.3:
	- Improved how the vehicles names and prices are found from the shared (functions.lua)
		- This gives better support for import custom vehicles
		- Now checks for the models HASH instead of name
		- This removes the need for the Config.carNames in the config.lua. Feel free to delete these.
		- If the car is set up in your shared correctly, it will find the info better.
	- Fixed liveries saying vehicle isn't owned even when it was. (livery.lua)
	- Set back NOS effect, forgot to change it while testing effects. (nos.lua)
		
Update 2.0.2:
	- Removed /test command left over from debugging police.lua
	- Added check to police.lua to stop passengers bringing up the menu
	- Added Resrapy Menu to Police repair station
		- Only Primary, Secondary and Pearlescent is available
	- Fixed mispelling breaking Custom Bumpers
	- Changes to the Rim section slightly, to help prevent errors
	- Changes to NOS syncing
		- Purge is white again
		- Hopefully synced better between players now
		- Added "OldFlame" toggle to top of nos.lua to toggle qbcore exhaust flame effect
		- Added tyreSync toggle to enable purge coming out as tiresmoke colour.
	- Fix for stash crafting.
		- Fixed removing items from slots then hitting 0
		- Fixed items being used beyond 0
		- Fixed the same item in serveral more than one slot being removed.

Update 2.0.1:
	- Fixed engine and transmission not saving on removing
	- NOS effects should now be synced between players
	- Attempt at fixing SQL issues for people
	- SQL is now required.
		- The only known way to fix NOS being picked up on script start, was to change how it found the info
	- Fixed traveldistance requiring qb-mechanicjob
	- Fixed police.lua requiring qb-customs

---------------------- INSTALLATION

- To install simply place this in your resource folder

- Add these lines to your qb-core > shared lua under the Items section

	--prp-mechanic Vehicles
	["mechanic_tools"] 				= {["name"] = "mechanic_tools", 			["label"] = "Mechanic tools", 		    ["weight"] = 0, 		["type"] = "item", 		["image"] = "mechanic_tools.png", 		["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Needed for vehicle repairs"},
	["toolbox"] 					= {["name"] = "toolbox", 			 	  	["label"] = "Toolbox", 		            ["weight"] = 0, 		["type"] = "item", 		["image"] = "toolbox.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Needed for Performance part removal"},
	["ducttape"] 					= {["name"] = "ducttape", 			 	  	["label"] = "Duct Tape", 		       	["weight"] = 0, 		["type"] = "item", 		["image"] = "bodyrepair.png", 			["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Good for quick fixes"},
	["mechboard"] 					= {["name"] = "mechboard", 			 	  	["label"] = "Mechanic Sheet", 		   	["weight"] = 0, 		["type"] = "item", 		["image"] = "mechboard.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	
	--Performance
	["turbo"] 		 	 		 	= {["name"] = "turbo", 						["label"] = "Supercharger Turbo", 		["weight"] = 0, 		["type"] = "item", 		["image"] = "turbo.png", 				["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Who doesn't need a 65mm Turbo??"},
	["car_armor"] 					= {["name"] = "car_armor", 					["label"] = "Vehicle Armor", 			["weight"] = 0, 		["type"] = "item", 		["image"] = "armour.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	
	["nos"] 					    = {["name"] = "nos", 			 	  	  	["label"] = "NOS Bottle", 		        ["weight"] = 0, 		["type"] = "item", 		["image"] = "nos.png", 				    ["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "A full bottle of NOS"},
	["noscan"] 					    = {["name"] = "noscan", 			 	  	["label"] = "Empty NOS Bottle", 		["weight"] = 0, 		["type"] = "item", 		["image"] = "noscan.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,  ["combinable"] = nil,   ["description"] = "An Empty bottle of NOS"},

	["engine1"] 				    = {["name"] = "engine1", 			 	  	["label"] = "Shonen Engine",            ["weight"] = 0, 		["type"] = "item", 		["image"] = "shonen.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["engine2"] 				    = {["name"] = "engine2", 			 	  	["label"] = "V8 Engine",        	    ["weight"] = 0, 		["type"] = "item", 		["image"] = "v8engine.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["engine3"] 				    = {["name"] = "engine3", 			 	  	["label"] = "V10 Engine",          		["weight"] = 0, 		["type"] = "item", 		["image"] = "v10engine.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["engine4"] 				    = {["name"] = "engine4", 			 	  	["label"] = "V12 Engine",               ["weight"] = 0, 		["type"] = "item", 		["image"] = "v12engine.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},

	["transmission1"] 				= {["name"] = "transmission1", 				["label"] = "Transmission Lvl 1",       ["weight"] = 0, 		["type"] = "item", 		["image"] = "transmission1.png",  		["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["transmission2"] 				= {["name"] = "transmission2", 				["label"] = "Transmission Lvl 2",       ["weight"] = 0, 		["type"] = "item", 		["image"] = "transmission2.png",  		["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["transmission3"] 				= {["name"] = "transmission3",				["label"] = "Transmission Lvl 3",       ["weight"] = 0, 		["type"] = "item", 		["image"] = "transmission3.png",   		["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},

	["brakes1"] 					= {["name"] = "brakes1", 			 		["label"] = "Performance Brakes",       ["weight"] = 0, 		["type"] = "item", 		["image"] = "brakes1.png", 		    	["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["brakes2"] 					= {["name"] = "brakes2", 			 		["label"] = "GT Big Brakes",            ["weight"] = 0, 		["type"] = "item", 		["image"] = "brakes2.png", 		    	["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["brakes3"] 					= {["name"] = "brakes3", 			 		["label"] = "Competition Brakes",       ["weight"] = 0, 		["type"] = "item", 		["image"] = "brakes3.png", 		    	["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	
	["suspension1"] 				= {["name"] = "suspension1", 				["label"] = "Lowered Suspension", 		["weight"] = 0, 		["type"] = "item", 		["image"] = "suspension1.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["suspension2"] 				= {["name"] = "suspension2",  				["label"] = "Street Suspension",		["weight"] = 0, 		["type"] = "item", 		["image"] = "suspension2.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Street Racing level Suspension"},
	["suspension3"] 				= {["name"] = "suspension3",  				["label"] = "Racing Suspension",		["weight"] = 0, 		["type"] = "item", 		["image"] = "suspension3.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Street Racing level Suspension"},
	["suspension4"] 				= {["name"] = "suspension4",  				["label"] = "Rally Suspension",			["weight"] = 0, 		["type"] = "item", 		["image"] = "suspension4.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "Street Racing level Suspension"},
	
	["bprooftires"] 				= {["name"] = "bprooftires", 			   	["label"] = "Bulletproof Tires", 		["weight"] = 0, 		["type"] = "item", 		["image"] = "bprooftires.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["drifttires"] 					= {["name"] = "drifttires", 			   	["label"] = "Drift Tires", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "drifttires.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	
	--Cosmetics
	["underglow_controller"] 		 = {["name"] = "underglow_controller", 		["label"] = "Neon Controller", 			["weight"] = 0, 		["type"] = "item", 		["image"] = "underglow_controller.png", ["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   	["description"] = "RGB LED Vehicle Remote"},
	["headlights"] 		 	 		 = {["name"] = "headlights", 				["label"] = "Xenon Headlights", 		["weight"] = 0, 		["type"] = "item", 		["image"] = "headlights.png", 			["unique"] = true, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   	["description"] = "8k HID headlights"},
	
	["tint_supplies"] 				 = {["name"] = "tint_supplies", 			["label"] = "Tint Supplies", 			["weight"] = 0, 		["type"] = "item", 		["image"] = "tint_supplies.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,    ["description"] = "Supplies for window tinting"},

	["customplate"] 				 = {["name"] = "customplate", 				["label"] = "Customized Plates", 		["weight"] = 0, 		["type"] = "item", 		["image"] = "plate.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["hood"] 						 = {["name"] = "hood", 						["label"] = "Vehicle Hood", 			["weight"] = 0, 		["type"] = "item", 		["image"] = "hood.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["roof"] 						 = {["name"] = "roof", 						["label"] = "Vehicle Roof", 			["weight"] = 0, 		["type"] = "item", 		["image"] = "roof.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["spoiler"] 					 = {["name"] = "spoiler", 					["label"] = "Vehicle Spoiler", 			["weight"] = 0, 		["type"] = "item", 		["image"] = "spoiler.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["bumper"] 						 = {["name"] = "bumper", 					["label"] = "Vehicle Bumper", 			["weight"] = 0, 		["type"] = "item", 		["image"] = "bumper.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["skirts"] 						 = {["name"] = "skirts", 					["label"] = "Vehicle Skirts", 			["weight"] = 0, 		["type"] = "item", 		["image"] = "skirts.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["exhaust"] 					 = {["name"] = "exhaust", 					["label"] = "Vehicle Exhaust", 			["weight"] = 0, 		["type"] = "item", 		["image"] = "exhaust.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["seat"] 						 = {["name"] = "seat", 						["label"] = "Seat Cosmetics", 			["weight"] = 0, 		["type"] = "item", 		["image"] = "seat.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},

	["rims"] 						 = {["name"] = "rims", 						["label"] = "Custom Wheel Rims", 		["weight"] = 0, 		["type"] = "item", 		["image"] = "rims.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	
	["livery"] 						 = {["name"] = "livery", 					["label"] = "Livery Roll", 				["weight"] = 0, 		["type"] = "item", 		["image"] = "livery.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["paintcan"] 					 = {["name"] = "paintcan", 					["label"] = "Vehicle Spray Can", 		["weight"] = 0, 		["type"] = "item", 		["image"] = "spraycan.png", 	["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["tires"] 						 = {["name"] = "tires", 					["label"] = "Drift Smoke Tires",        ["weight"] = 0, 		["type"] = "item", 		["image"] = "tires.png", 	  		    ["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},

	["horn"] 						 = {["name"] = "horn", 						["label"] = "Custom Vehicle Horn", 		["weight"] = 0, 		["type"] = "item", 		["image"] = "horn.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},

	["internals"] 					 = {["name"] = "internals", 				["label"] = "Internal Cosmetics", 		["weight"] = 0, 		["type"] = "item", 		["image"] = "internals.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	["externals"] 					 = {["name"] = "externals", 				["label"] = "Exterior Cosmetics", 		["weight"] = 0, 		["type"] = "item", 		["image"] = "mirror.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = ""},
	

- Add the image files from the zip to your qb-inventory > html > images folder

----------------------

- This script requires qb-menu and qb-input for all the menus
- This script requires qb-target for opening stores, crafting tables and cash registers (if you don't want to use these then you can disable/remove them)

- Rims menu can be a bit..weird, but thats unfortunately due to GTA's way of indexing the wheels ID's and Names
	- Custom Rims will most likely be named "NULL" and may now even show on the vehicles
	- Custom Wheel variants for the rims will posibly be named " - Var 1" and " - Var 2" this is due to different wheels just being another version of the rims.

----------------------

There are expanded features included in this scripts with SQL
The included .SQL file needs to be imported into your player_vehicles database to add the appropriate columns (traveldistance, hasnitro, noslevel)

The hasnitro and noslevel columns being added enables the of saving Nitrous levels through server restarts

The traveldistance column adds an Odometer to the toolbox/mechanic_tools menus, this this can retrieved in miles or kilometers.

Adding the sql is completely optional and the script works without them

----------------------

How do I enable extra vehicle damages?

It's easy! It's not enabled by default in ProjectRP and looks like it hasn't been updated in a while.

Within `qb-vehiclefailure` is commented out exports that enable extra vehicle damage

Search for each instance of `--exports['qb-vehicletuning']`
Remove the `--` and change the name of the export to `['qb-mechanicjob']`

You will need to do 3 times within `qb-vehiclefailure` and then you can restart your server.

When you damage and drive around in your vehicles now, you will have a chance of damaging another component. These numbers go down VERY slowly unless you edit the exports above.

----------------------

How do I create PolyZones for a new job location?

These locations determine where a person will be put on duty or taken off duty, and the places where items can be used, if you set them to be restricted to zones.

To start you need to be near the building you want to add.

Type `/pzcreate poly` to start creating a PolyZone. Pick a name, this doesn't matter as you can set this later in locations.lua
You will then get a red line right where you are standing.

Use your ARROW keys to move this around to the first corner/point you want to place.
When its in the correct place, type `/pzadd` and this will lock the current point and allow you to create another

Repeat this until your last corner/point where you will type `/pzfinish`. 

This will save all the vectors of the points you have chosen and place them in a file called: `polyzone_created_zones.txt`

In this file is the vectors that you need to copy over to my scripts.

----------------------

** This isn't fully required but helps organise multiples of the "mechboard" **

The MechBoard item is an item given to the person who uses the preview menu and makes changes

To make full use of this item you need to add the ability for the item to show item info in your inventory system

I have only done this with `qb-inventory` and `lj-inventory` as they are similar

`qb-inventory/html/js/app.js`

- Search for "harness" or Scroll down until you find:

        } else if (itemData.name == "harness") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "<p>" + itemData.info.uses + " uses left.</p>"
            );
			
- Directly underneath this add:

		} else if (itemData.name == "mechboard") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "<p>" + itemData.info.vehplate + "</p>" +
				"<p>" + itemData.info.veh + "</p>"
            );
			
When successfully added the mechboards will show the vehicle and plate number

----------------------

To add the ability to save RGB paints, their finishes and drift/bulletproof tires you need to change two functions in your qb-core/client/functions.lua

Replace GetVehicleProperties and SetVehicleProperties functions with these:

function ProjectRP.Functions.GetVehicleProperties(vehicle)
    if DoesEntityExist(vehicle) then
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		local nilfinish = nil
		local PrimaryFinish = nil
		local SecondaryFinish = nil
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
        if GetIsVehiclePrimaryColourCustom(vehicle) then
            r, g, b = GetVehicleCustomPrimaryColour(vehicle)
			PrimaryFinish, nilfinish = GetVehicleColours(vehicle)
            colorPrimary = { r, g, b, PrimaryFinish }
        end
        if GetIsVehicleSecondaryColourCustom(vehicle) then
            r, g, b = GetVehicleCustomSecondaryColour(vehicle)
			nilfinish, SecondaryFinish = GetVehicleColours(vehicle)
            colorSecondary = { r, g, b, SecondaryFinish }
        end
        local extras = {}
        for extraId = 0, 12 do
            if DoesExtraExist(vehicle, extraId) then
                local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
                extras[tostring(extraId)] = state
            end
        end
        local modLivery = GetVehicleMod(vehicle, 48)
        if GetVehicleMod(vehicle, 48) == -1 and GetVehicleLivery(vehicle) ~= 0 then modLivery = GetVehicleLivery(vehicle) end
        local neons = {}
        for i = 0, 3 do neons[i] = IsVehicleNeonLightEnabled(vehicle, i) end
        local tireHealth = {}
        for i = 0, 3 do tireHealth[i] = GetVehicleWheelHealth(vehicle, i) end
        local tireBurstState = {}
        for i = 0, 5 do tireBurstState[i] = IsVehicleTyreBurst(vehicle, i, false) end
        local tireBurstCompletely = {}
        for i = 0, 5 do tireBurstCompletely[i] = IsVehicleTyreBurst(vehicle, i, true) end
        local windowStatus = {}
        for i = 0, 7 do windowStatus[i] = IsVehicleWindowIntact(vehicle, i) == 1 end
        local doorStatus = {}
        for i = 0, 5 do doorStatus[i] = IsVehicleDoorDamaged(vehicle, i) == 1 end
        return {
            model = GetEntityModel(vehicle),
            plate = ProjectRP.Functions.GetPlate(vehicle),
            plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
            bodyHealth = ProjectRP.Shared.Round(GetVehicleBodyHealth(vehicle), 0.1),
            engineHealth = ProjectRP.Shared.Round(GetVehicleEngineHealth(vehicle), 0.1),
            tankHealth = ProjectRP.Shared.Round(GetVehiclePetrolTankHealth(vehicle), 0.1),
            fuelLevel = ProjectRP.Shared.Round(GetVehicleFuelLevel(vehicle), 0.1),
            dirtLevel = ProjectRP.Shared.Round(GetVehicleDirtLevel(vehicle), 0.1),
            oilLevel = ProjectRP.Shared.Round(GetVehicleOilLevel(vehicle), 0.1),
            color1 = colorPrimary,
            color2 = colorSecondary,
            pearlescentColor = pearlescentColor,
            dashboardColor = GetVehicleDashboardColour(vehicle),
            wheelColor = wheelColor,
            wheels = GetVehicleWheelType(vehicle),
            wheelSize = GetVehicleWheelSize(vehicle),
            wheelWidth = GetVehicleWheelWidth(vehicle),
            tireHealth = tireHealth,
            tireBurstState = tireBurstState,
            tireBurstCompletely = tireBurstCompletely,
            windowTint = GetVehicleWindowTint(vehicle),
            windowStatus = windowStatus,
            doorStatus = doorStatus,
            xenonColor = GetVehicleXenonLightsColour(vehicle),
            neonEnabled = neons,
            neonColor = table.pack(GetVehicleNeonLightsColour(vehicle)),
            headlightColor = GetVehicleHeadlightsColour(vehicle),
            interiorColor = GetVehicleInteriorColour(vehicle),
            extras = extras,
            tyreSmokeColor = table.pack(GetVehicleTyreSmokeColor(vehicle)),
            modSpoilers = GetVehicleMod(vehicle, 0),
            modFrontBumper = GetVehicleMod(vehicle, 1),
            modRearBumper = GetVehicleMod(vehicle, 2),
            modSideSkirt = GetVehicleMod(vehicle, 3),
            modExhaust = GetVehicleMod(vehicle, 4),
            modFrame = GetVehicleMod(vehicle, 5),
            modGrille = GetVehicleMod(vehicle, 6),
            modHood = GetVehicleMod(vehicle, 7),
            modFender = GetVehicleMod(vehicle, 8),
            modRightFender = GetVehicleMod(vehicle, 9),
            modRoof = GetVehicleMod(vehicle, 10),
            modEngine = GetVehicleMod(vehicle, 11),
            modBrakes = GetVehicleMod(vehicle, 12),
            modTransmission = GetVehicleMod(vehicle, 13),
            modHorns = GetVehicleMod(vehicle, 14),
            modSuspension = GetVehicleMod(vehicle, 15),
            modArmor = GetVehicleMod(vehicle, 16),
            modKit17 = GetVehicleMod(vehicle, 17),
            modTurbo = IsToggleModOn(vehicle, 18),
            modKit19 = GetVehicleMod(vehicle, 19),
            modSmokeEnabled = IsToggleModOn(vehicle, 20),
            modKit21 = GetVehicleMod(vehicle, 21),
            modXenon = IsToggleModOn(vehicle, 22),
            modFrontWheels = GetVehicleMod(vehicle, 23),
            modBackWheels = GetVehicleMod(vehicle, 24),
            modCustomTiresF = GetVehicleModVariation(vehicle, 23),
            modCustomTiresR = GetVehicleModVariation(vehicle, 24),
            modPlateHolder = GetVehicleMod(vehicle, 25),
            modVanityPlate = GetVehicleMod(vehicle, 26),
            modTrimA = GetVehicleMod(vehicle, 27),
            modOrnaments = GetVehicleMod(vehicle, 28),
            modDashboard = GetVehicleMod(vehicle, 29),
            modDial = GetVehicleMod(vehicle, 30),
            modDoorSpeaker = GetVehicleMod(vehicle, 31),
            modSeats = GetVehicleMod(vehicle, 32),
            modSteeringWheel = GetVehicleMod(vehicle, 33),
            modShifterLeavers = GetVehicleMod(vehicle, 34),
            modAPlate = GetVehicleMod(vehicle, 35),
            modSpeakers = GetVehicleMod(vehicle, 36),
            modTrunk = GetVehicleMod(vehicle, 37),
            modHydrolic = GetVehicleMod(vehicle, 38),
            modEngineBlock = GetVehicleMod(vehicle, 39),
            modAirFilter = GetVehicleMod(vehicle, 40),
            modStruts = GetVehicleMod(vehicle, 41),
            modArchCover = GetVehicleMod(vehicle, 42),
            modAerials = GetVehicleMod(vehicle, 43),
            modTrimB = GetVehicleMod(vehicle, 44),
            modTank = GetVehicleMod(vehicle, 45),
            modWindows = GetVehicleMod(vehicle, 46),
            modKit47 = GetVehicleMod(vehicle, 47),
            modLivery = modLivery,
            modKit49 = GetVehicleMod(vehicle, 49),
            liveryRoof = GetVehicleRoofLivery(vehicle),
			modDrift = GetDriftTyresEnabled(vehicle),
			modBProofTires = not GetVehicleTyresCanBurst(vehicle),
        }
    else
        return
    end
end

function ProjectRP.Functions.SetVehicleProperties(vehicle, props)
    if DoesEntityExist(vehicle) then
        if props.extras then
            for id, enabled in pairs(props.extras) do
                if enabled then
                    SetVehicleExtra(vehicle, tonumber(id), 0)
                else
                    SetVehicleExtra(vehicle, tonumber(id), 1)
                end
            end
        end
        local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
        SetVehicleModKit(vehicle, 0)
        if props.plate then SetVehicleNumberPlateText(vehicle, props.plate) end
        if props.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
        if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
        if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
        if props.tankHealth then SetVehiclePetrolTankHealth(vehicle, props.tankHealth) end
        if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end
        if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
        if props.oilLevel then SetVehicleOilLevel(vehicle, props.oilLevel) end
        if props.color1 then 
			if type(props.color1) == "number" then SetVehicleColours(vehicle, props.color1, colorSecondary) else
				SetVehicleCustomPrimaryColour(vehicle, props.color1[1], props.color1[2], props.color1[3])
				SetVehicleColours(vehicle, props.color1[4], colorSecondary)
           end
        end
        if props.color2 then
            if type(props.color2) == "number" then SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2) else
                SetVehicleCustomSecondaryColour(vehicle, props.color2[1], props.color2[2], props.color2[3])
				colorPrimary, colorSecondary = GetVehicleColours(vehicle)
				SetVehicleColours(vehicle, colorPrimary, props.color2[4])
           end
        end
        if props.pearlescentColor then SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor) end
        if props.interiorColor then SetVehicleInteriorColor(vehicle, props.interiorColor) end
        if props.dashboardColor then SetVehicleDashboardColour(vehicle, props.dashboardColor) end
        if props.wheelColor then SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor) end
        if props.wheels then SetVehicleWheelType(vehicle, props.wheels) end
        if props.tireHealth then for wheelIndex, health in pairs(props.tireHealth) do SetVehicleWheelHealth(vehicle, wheelIndex, health) end end
        if props.tireBurstState then for wheelIndex, burstState in pairs(props.tireBurstState) do 
			if burstState then SetVehicleTyreBurst(vehicle, tonumber(wheelIndex), false, 1000.0) end end end
        if props.tireBurstCompletely then
            for wheelIndex, burstState in pairs(props.tireBurstCompletely) do
                if burstState then SetVehicleTyreBurst(vehicle, tonumber(wheelIndex), true, 1000.0) end
            end
        end
        if props.windowTint then SetVehicleWindowTint(vehicle, props.windowTint) end
        if props.windowStatus then
			for windowIndex, smashWindow in pairs(props.windowStatus) do
                if not smashWindow then SmashVehicleWindow(vehicle, windowIndex) end
            end
        end
        if props.doorStatus then for doorIndex, breakDoor in pairs(props.doorStatus) do if breakDoor then SetVehicleDoorBroken(vehicle, doorIndex, true) end end end
        if props.neonEnabled then for neonIndex, enableNeons in pairs(props.neonEnabled) do SetVehicleNeonLightEnabled(vehicle, neonIndex, enableNeons) end end
        if props.neonColor then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
        if props.headlightColor then SetVehicleHeadlightsColour(vehicle, props.headlightColor) end
        if props.interiorColor then SetVehicleInteriorColour(vehicle, props.interiorColor) end
        if props.wheelSize then SetVehicleWheelSize(vehicle, props.wheelSize) end
        if props.wheelWidth then SetVehicleWheelWidth(vehicle, props.wheelWidth) end
        if props.tyreSmokeColor then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end
        if props.modSpoilers then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end
        if props.modFrontBumper then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end
        if props.modRearBumper then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end
        if props.modSideSkirt then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end
        if props.modExhaust then SetVehicleMod(vehicle, 4, props.modExhaust, false) end
        if props.modFrame then SetVehicleMod(vehicle, 5, props.modFrame, false) end
        if props.modGrille then SetVehicleMod(vehicle, 6, props.modGrille, false) end
        if props.modHood then SetVehicleMod(vehicle, 7, props.modHood, false) end
        if props.modFender then SetVehicleMod(vehicle, 8, props.modFender, false) end
        if props.modRightFender then SetVehicleMod(vehicle, 9, props.modRightFender, false) end
        if props.modRoof then SetVehicleMod(vehicle, 10, props.modRoof, false) end
        if props.modEngine then SetVehicleMod(vehicle, 11, props.modEngine, false) end
        if props.modBrakes then SetVehicleMod(vehicle, 12, props.modBrakes, false) end        
		if props.modTransmission then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
        if props.modHorns then SetVehicleMod(vehicle, 14, props.modHorns, false) end
        if props.modSuspension then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
        if props.modArmor then SetVehicleMod(vehicle, 16, props.modArmor, false) end
        if props.modKit17 then SetVehicleMod(vehicle, 17, props.modKit17, false) end
        if props.modTurbo then ToggleVehicleMod(vehicle, 18, props.modTurbo) end
        if props.modKit19 then SetVehicleMod(vehicle, 19, props.modKit19, false) end
        if props.modSmokeEnabled then ToggleVehicleMod(vehicle, 20, props.modSmokeEnabled) end
        if props.modKit21 then SetVehicleMod(vehicle, 21, props.modKit21, false) end
        if props.modXenon then ToggleVehicleMod(vehicle, 22, props.modXenon) end
        if props.xenonColor then SetVehicleXenonLightsColor(vehicle, props.xenonColor) end
        if props.modFrontWheels then SetVehicleMod(vehicle, 23, props.modFrontWheels, false) end
        if props.modBackWheels then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end
        if props.modCustomTiresF then SetVehicleMod(vehicle, 23, props.modFrontWheels, props.modCustomTiresF) end
        if props.modCustomTiresR then SetVehicleMod(vehicle, 24, props.modBackWheels, props.modCustomTiresR) end
		if props.modPlateHolder then SetVehicleMod(vehicle, 25, props.modPlateHolder, false) end
        if props.modVanityPlate then SetVehicleMod(vehicle, 26, props.modVanityPlate, false) end
        if props.modTrimA then SetVehicleMod(vehicle, 27, props.modTrimA, false) end
        if props.modOrnaments then SetVehicleMod(vehicle, 28, props.modOrnaments, false) end
        if props.modDashboard then SetVehicleMod(vehicle, 29, props.modDashboard, false) end
        if props.modDial then SetVehicleMod(vehicle, 30, props.modDial, false) end
        if props.modDoorSpeaker then SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false) end
        if props.modSeats then SetVehicleMod(vehicle, 32, props.modSeats, false) end
        if props.modSteeringWheel then SetVehicleMod(vehicle, 33, props.modSteeringWheel, false) end
        if props.modShifterLeavers then SetVehicleMod(vehicle, 34, props.modShifterLeavers, false) end
        if props.modAPlate then SetVehicleMod(vehicle, 35, props.modAPlate, false) end
        if props.modSpeakers then SetVehicleMod(vehicle, 36, props.modSpeakers, false) end
        if props.modTrunk then SetVehicleMod(vehicle, 37, props.modTrunk, false) end
        if props.modHydrolic then SetVehicleMod(vehicle, 38, props.modHydrolic, false) end
        if props.modEngineBlock then SetVehicleMod(vehicle, 39, props.modEngineBlock, false) end
        if props.modAirFilter then SetVehicleMod(vehicle, 40, props.modAirFilter, false) end
        if props.modStruts then SetVehicleMod(vehicle, 41, props.modStruts, false) end
        if props.modArchCover then SetVehicleMod(vehicle, 42, props.modArchCover, false) end
        if props.modAerials then SetVehicleMod(vehicle, 43, props.modAerials, false) end
        if props.modTrimB then SetVehicleMod(vehicle, 44, props.modTrimB, false) end
        if props.modTank then SetVehicleMod(vehicle, 45, props.modTank, false) end
        if props.modWindows then SetVehicleMod(vehicle, 46, props.modWindows, false) end
        if props.modKit47 then SetVehicleMod(vehicle, 47, props.modKit47, false) end
        if props.modLivery then SetVehicleMod(vehicle, 48, props.modLivery, false) SetVehicleLivery(vehicle, props.modLivery) end
        if props.modKit49 then SetVehicleMod(vehicle, 49, props.modKit49, false) end
        if props.liveryRoof then SetVehicleRoofLivery(vehicle, props.liveryRoof) end
		if props.modDrift then SetDriftTyresEnabled(vehicle, true) end	
		SetVehicleTyresCanBurst(vehicle, not props.modBProofTires)
    end
end