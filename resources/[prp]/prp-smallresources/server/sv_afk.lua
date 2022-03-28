local ProjectRP = exports['prp-core']:GetCoreObject()

RegisterServerEvent('KickForAFK', function()
    local src = source
	DropPlayer(src, 'You Have Been Kicked For Being AFK')
end)

ProjectRP.Functions.CreateCallback('prp-afkkick:server:GetPermissions', function(source, cb)
    local src = source
    local group = ProjectRP.Functions.GetPermission(src)
    cb(group)
end)