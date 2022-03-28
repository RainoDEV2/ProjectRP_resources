ProjectRP = {}
ProjectRP.Config = PRPConfig
ProjectRP.Shared = PRPShared
ProjectRP.ServerCallbacks = {}
ProjectRP.UseableItems = {}

exports('GetCoreObject', function()
    return ProjectRP
end)

-- To use this export in a script instead of manifest method
-- Just put this line of code below at the very top of the script
-- local ProjectRP = exports['prp-core']:GetCoreObject()

-- Get permissions on server start

CreateThread(function()
    local result = exports.oxmysql:executeSync('SELECT * FROM permissions', {})
    if result[1] then
        for k, v in pairs(result) do
            ProjectRP.Config.Server.PermissionList[v.license] = {
                license = v.license,
                permission = v.permission,
                optin = true,
            }
        end
    end
end)