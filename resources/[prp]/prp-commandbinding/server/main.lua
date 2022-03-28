ProjectRP.Commands.Add("binds", "Open commandbinding menu", {}, false, function(source, args)
    local Player = ProjectRP.Functions.GetPlayer(source)
	TriggerClientEvent("prp-commandbinding:client:openUI", source)
end)

RegisterServerEvent('prp-commandbinding:server:setKeyMeta')
AddEventHandler('prp-commandbinding:server:setKeyMeta', function(keyMeta)
    local src = source
    local ply = ProjectRP.Functions.GetPlayer(src)

    ply.Functions.SetMetaData("commandbinds", keyMeta)
end)