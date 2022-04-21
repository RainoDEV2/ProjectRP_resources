local ProjectRP = exports['prp-core']:GetCoreObject()

--CHAIR CONTROLLER
attachedProp = 0
function attachAChair(chairModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeattachedChair()
	chairModel = GetHashKey(chairModelSent)
	--loadModel(chairModelSent)
	boneNumber = boneNumberSent 
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	RequestModel(chairModel)
	while not HasModelLoaded(chairModel) do
		Citizen.Wait(100)
	end
	attachedChair = CreateObject(chairModel, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(attachedChair, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
	SetModelAsNoLongerNeeded(chairModel)
end
function removeattachedChair()
	DeleteEntity(attachedChair)
	attachedChair = 0
end
function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end


RegisterNetEvent("prp-chairs:Use")
AddEventHandler("prp-chairs:Use", function(item)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped) then return end
	if not haschairalready then haschairalready = true
	local coords = GetEntityCoords(GetPlayerPed(-1))
	local animDict = "timetable@ron@ig_3_couch"
	local animation = "base"
	FreezeEntityPosition(ped, true)

	if item == "chair1" then attachAChair("prop_skid_chair_01", 0, 0, -0.05, -0.18, 8.4, 0.4, 185.0)
	elseif item == "chair2" then attachAChair("prop_skid_chair_02", 0, 0, -0.05, -0.18, 8.4, 0.4, 185.0)
	elseif item == "chair3" then attachAChair("prop_skid_chair_03", 0, 0, -0.05, -0.18, 8.4, 0.4, 185.0) end
	loadAnimDict(animDict)
	local animLength = GetAnimDuration(animDict, animation)
	TaskPlayAnim(ped, animDict, animation, 1.5, 2.0, animLength, 1, 0, 0, 0, 0)
	else
		haschairalready = false
		FreezeEntityPosition(ped,false)
		removeattachedChair()
		StopEntityAnim(ped, "base", "timetable@ron@ig_3_couch", 3)
	end
end)

Citizen.CreateThread(function()
	while true do
		if haschairalready and not IsEntityPlayingAnim(PlayerPedId(), "timetable@ron@ig_3_couch", "base", 3) then
			FreezeEntityPosition(PlayerPedId(),false)
			removeattachedChair()
			--ClearPedTasks(PlayerPedId())
			haschairalready = false
		end
		Wait(500)
	end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
		FreezeEntityPosition(PlayerPedId(),false)
		removeattachedChair()
		ClearPedTasks(PlayerPedId())
		haschairalready = false
    end
end)
