RegisterCommand('idlecamoff', function()
    ProjectRP.Functions.Notify('Idle cam is now off', 'success')
    DisableIdleCamera(true)
    SetResourceKvp("idleCam", "off")
end)

RegisterCommand('idlecamon', function()
    ProjectRP.Functions.Notify('Idle cam is now on', 'success')
    DisableIdleCamera(false)
    SetResourceKvp("idleCam", "on")
end)

Citizen.CreateThread(function()
    TriggerEvent("chat:addSuggestion", "/idlecamon", "Re-enables the idle cam")
    TriggerEvent("chat:addSuggestion", "/idlecamoff", "Disables the idle cam")
    
    local idleCamDisabled = GetResourceKvpString("idleCam") ~= "on"
    DisableIdleCamera(idleCamDisabled)
end)