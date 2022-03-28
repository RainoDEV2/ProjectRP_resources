ProjectRP = exports["prp-core"]:GetCoreObject()
local seatsTaken = {}



RegisterNetEvent('prp-sit:takePlace')
AddEventHandler('prp-sit:takePlace', function(objectCoords)
	seatsTaken[objectCoords] = true
end)

RegisterNetEvent('prp-sit:leavePlace')
AddEventHandler('prp-sit:leavePlace', function(objectCoords)
	if seatsTaken[objectCoords] then
		seatsTaken[objectCoords] = nil
	end
end)

ProjectRP.Functions.CreateCallback('prp-sit:getPlace', function(source, cb, objectCoords)
	cb(seatsTaken[objectCoords])
end)