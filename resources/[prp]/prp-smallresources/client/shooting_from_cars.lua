local recentViewMode = 0
local changedViewMode = false
local sleep = 100

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		sleep = 100

		if IsPedInAnyVehicle(ped) then
			sleep = 10
			if IsPedDoingDriveby(ped) then
				if GetFollowVehicleCamViewMode() ~= 4 then
					recentViewMode = GetFollowVehicleCamViewMode()
					local context = GetCamActiveViewModeContext()
					SetCamViewModeForContext(context, 4)
					changedViewMode = true
				end
			end
			if changedViewMode and not IsPedDoingDriveby(ped) then
				local context = GetCamActiveViewModeContext()
				SetCamViewModeForContext(context, recentViewMode)
				changedViewMode = false
			end
		end
		Citizen.Wait(sleep)
	end
end)