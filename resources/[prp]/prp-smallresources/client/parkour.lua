-- Credit goes to @Deany#5397 and @Leaf#9053

local jumping = false
local ped = GetPlayerPed(-1)

--WallGrab
Citizen.CreateThread(function()
	while true do
	Citizen.Wait(0)
	
	ped = GetPlayerPed(-1)
	
		if IsControlJustPressed(0, 22) then
			DetachEntity(GetPlayerPed(-1), true, false)
			if IsPedJumping(ped) then
				if not jumping then
					TaskClimb(ped, 0)
					Wait(0)
					jumping = true
				elseif jumping then
				end
			end
		end
		if not IsPedJumping(ped) then
			Wait(700)
			jumping = false
		end
	end
end)

local forceTypes = {
    MinForce = 0,
    MaxForceRot = 1,
    MinForce2 = 2,
    MaxForceRot2 = 3,
    ForceNoRot = 4,
    ForceRotPlusForce = 5
}

local ped = PlayerPedId()
local forceType = forceTypes.MaxForceRot2
-- sends the entity straight up into the sky:
local direction = vector3(0.0, 0.0, 15.0)
local rotation = vector3(0.0, 0.0, 0.0)
local boneIndex = 0
local isDirectionRel = false
local ignoreUpVec = false
local isForceRel = true
local p12 = false
local p13 = false

--WallClimb
Citizen.CreateThread(function()
	while true do
	Citizen.Wait(0)
	
	ped = GetPlayerPed(-1)
	
		if HasEntityCollidedWithAnything(ped) and IsControlJustPressed(1, 111) then
            loadanim("missfra0_chop_fchase")
            TaskPlayAnim(ped,"missfra0_chop_fchase","ballasog_fenceclimb_ig4",1.0,1.0,-1,8,0,0,0,0)	
			Wait(700)			
			ApplyForceToEntity(
                ped,
                forceType,
                direction,
                rotation,
                boneIndex,
                isDirectionRel,
                ignoreUpVec,
                isForceRel,
                p12,
                p13
			)
			Wait(400)
			TaskClimb(ped, 0)
			Citizen.Wait(5000)
		end
		Citizen.Wait(0)
	end
end)

local forceTypes = {
    MinForce = 0,
    MaxForceRot = 1,
    MinForce2 = 2,
    MaxForceRot2 = 3,
    ForceNoRot = 4,
    ForceRotPlusForce = 5
}

LoadAnim = function(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		
		Citizen.Wait(1)
	end
end

function loadanim(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end