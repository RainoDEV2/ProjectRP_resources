local mCallback = {}

function openGui(clr,msg,time)
    guiEnabled = true
    SendNUIMessage({runProgress = true, colorsent = clr, textsent = msg, fadesent = time})
end

function addNotification(title,message,time,sos)
    SendNUIMessage({Toast = true, title = title, text = message, time = time, sos = sos})
end

function addNotifyHelp(message,time)
    SendNUIMessage({Notify = true, text = message, time = time})
end

function AddDialog(thetitle,message,callback)
    mCallback = callback
    SendNUIMessage({Modal = true, text = message, title=thetitle})
    SetNuiFocus(true, true)
end

function closeGui()
    guiEnabled = false
    SendNUIMessage({closeProgress = true})
end

RegisterNUICallback("callback", function(data,cb)
    mCallback(data.Val)
    print(data.Val)
    print("test")
    SetNuiFocus(false, false)
    cb('ok')
end)



RegisterNUICallback("closeJob", function(data,cb)
    guiEnabled = false
    SetNuiFocus(false, false)
    cb('ok')
end)



RegisterNUICallback("closeReport", function(data,cb)
    guiEnabled = false

    SetNuiFocus(false, false)
    if data.msg then
        TriggerServerEvent("prp:ReportBugReport", data.msgData, data.msgError, data.resource)
    end
    cb('ok')

end)

RegisterNetEvent('prp:HUD:DisplayItem')
AddEventHandler('prp:HUD:DisplayItem', function(id, title)
	SendNUIMessage({UseBar = true, itemid = id, itemtitle = title})
end)

-- RegisterCommand("item", function()
--     TriggerEvent("hud-display-item", "bread", "Bread")
-- end)

RegisterNetEvent("tasknotify:guiupdate")
AddEventHandler("tasknotify:guiupdate", function(color,message,time)
    openGui(color,message,time)
end)

RegisterNetEvent("tasknotify:notify")
AddEventHandler("tasknotify:notify", function(message,color,time)
    addNotification(message,color,time)
end)

function Toast(title,msg,time,sos)
    if not sos then sos = false end

    addNotification(title,msg,time,sos)
end

function NotifyHelp(msg,time)
    addNotifyHelp(msg,time)
end

RegisterNetEvent("tasknotify:guiclose")
AddEventHandler("tasknotify:guiclose", function()
    closeGui()
end)


function BugReport(resource, scriptError)

    SendNUIMessage({bugReport = true, resource = resource, error=scriptError})

    SetNuiFocus(true, true)

end



RegisterNetEvent("prp:SendErrorToScreen")

AddEventHandler("prp:SendErrorToScreen", function(resource, error)

    BugReport(resource, error)

end)


function openGuiJob(title, message)

    guiEnabled = true

    SetNuiFocus(true, true)

    SendNUIMessage({JobInfo = true, title = title, text = message})

end


RegisterNetEvent("tasknotify:jobui")

AddEventHandler("tasknotify:jobui", function(title,message)

    openGuiJob(title,message)

end)


function openGuiJob(title, message)

    guiEnabled = true

    SetNuiFocus(true, true)

    SendNUIMessage({JobInfo = true, title = title, text = message})

end


function addStateHelp(message,time)
    SendNUIMessage({State = true, text = message, time = time})
end

function StateHelp(msg,time)
    addStateHelp(msg,time)
end

RegisterCommand("StateHelp", function()
StateHelp("test", 15000)
end)

RegisterCommand("bugreport212", function()
    local resource = "yourmom"
    local error = "small dick"
    BugReport(resource, error)
end)


RegisterNetEvent('prp:BagOverlay')

AddEventHandler('prp:BagOverlay', function(show)
	SendNUIMessage({Bag = true, Display = show})
end)