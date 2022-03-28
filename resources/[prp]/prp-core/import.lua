-- This might eventually be deprecated for the export system

if GetCurrentResourceName() == 'prp-core' then
    function GetSharedObject()
        return ProjectRP
    end

    exports('GetSharedObject', GetSharedObject)
end

ProjectRP = exports['prp-core']:GetSharedObject()