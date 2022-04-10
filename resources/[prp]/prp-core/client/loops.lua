CreateThread(function()
    while true do
        Wait(0)
        if LocalPlayer.state['isLoggedIn'] then
            Wait((1000 * 60) * ProjectRP.Config.UpdateInterval)
            TriggerServerEvent('ProjectRP:UpdatePlayer')
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if LocalPlayer.state['isLoggedIn'] and ProjectRP.Functions.GetPlayerData().job.onduty then
            Wait((1000 * 60) * ProjectRP.Config.UpdateSalary)
            TriggerServerEvent('ProjectRP:UpdatePlayerSalary')
        end
    end
end)

CreateThread(function()
    while true do
        Wait(ProjectRP.Config.StatusInterval)
        if LocalPlayer.state['isLoggedIn'] then
            if ProjectRP.Functions.GetPlayerData().metadata['hunger'] <= 0 or
                    ProjectRP.Functions.GetPlayerData().metadata['thirst'] <= 0 then
                local ped = PlayerPedId()
                local currentHealth = GetEntityHealth(ped)
                SetEntityHealth(ped, currentHealth - math.random(5, 10))
            end
        end
    end
end)




Citizen.CreateThread(
	function()
		while true do
			Citizen.Wait(4)
			if IsPedArmed(PlayerPedId(), 6) then
				DisableControlAction(1, 140, true)
				DisableControlAction(1, 141, true)
				DisableControlAction(1, 142, true)
			else
				Citizen.Wait(1500)
			end
		end
	end
)
