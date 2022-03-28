ProjectRP = {}
ProjectRP.PlayerData = {}
ProjectRP.Config = PRPConfig
ProjectRP.Shared = PRPShared
ProjectRP.ServerCallbacks = {}

exports('GetCoreObject', function()
    return ProjectRP
end)

-- To use this export in a script instead of manifest method
-- Just put this line of code below at the very top of the script
-- local ProjectRP = exports['prp-core']:GetCoreObject()