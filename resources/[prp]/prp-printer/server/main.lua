local ProjectRP = exports['prp-core']:GetCoreObject()

local ValidExtensions = {
    [".png"] = true,
    [".gif"] = true,
    [".jpg"] = true,
    [".jpeg"] = true
}

local ValidExtensionsText = '.png, .gif, .jpg, .jpeg'

ProjectRP.Functions.CreateUseableItem("printerdocument", function(source, item)
    TriggerClientEvent('prp-printer:client:UseDocument', source, item)
end)

ProjectRP.Commands.Add("spawnprinter", "Spawn a printer", {}, true, function(source, args)
	TriggerClientEvent('prp-printer:client:SpawnPrinter', source)
end, "admin")

RegisterNetEvent('prp-printer:server:SaveDocument', function(url)
    local src = source
    local Player = ProjectRP.Functions.GetPlayer(src)
    local info = {}
    local extension = string.sub(url, -4)
    local validexts = ValidExtensions
    if url ~= nil then
        if validexts[extension] then
            info.url = url
            Player.Functions.AddItem('printerdocument', 1, nil, info)
            TriggerClientEvent('inventory:client:ItemBox', src, ProjectRP.Shared.Items['printerdocument'], "add")
        else
            TriggerClientEvent('ProjectRP:Notify', src, 'Thats not a valid extension, only '..ValidExtensionsText..' extension links are allowed.', "error")
        end
    end
end)