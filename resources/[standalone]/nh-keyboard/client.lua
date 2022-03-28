local success = {}
local await = false
RegisterNUICallback("dataPost", function(data, cb)
    SetNuiFocus(false)
    success = data.data
    await = false
    cb('ok')
end)

RegisterNUICallback("cancel", function()
    SetNuiFocus(false)
    success = nil
    await = false
end)


function KeyboardInput(data)
    if not data or await then return end
    Wait(250)
    success = {}
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "OPEN_MENU",
        data = data
    })
    await = true
    while await do Wait(0) end
    if success ~= nil and next(success) ~= nil then
        return success
    end
    return nil
end

exports("KeyboardInput", KeyboardInput)
