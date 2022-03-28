local ProjectRP = exports['prp-core']:GetCoreObject()

CreateThread(function()
	for i, v in pairs(ProjectRP.Shared.Vehicles) do
		local text
		if v["brand"] then
			text = v["brand"] .. " " .. v["name"]
		else
			text = v["name"]
		end
		AddTextEntryByHash(v["hash"],text)
	end
end)
