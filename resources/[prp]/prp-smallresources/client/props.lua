local AllProps = {}
local HasProp = false

function AddProp(Name)
    if Config.PropList[Name] ~= nil then
      if not HasProp then
        HasProp = true
        RequestModelHash(Config.PropList[Name]['prop'])
        local CurrentProp = CreateObject(Config.PropList[Name]['hash'], 0, 0, 0, true, true, true)
        AttachEntityToEntity(CurrentProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), Config.PropList[Name]['bone-index']['bone']), Config.PropList[Name]['bone-index']['X'], Config.PropList[Name]['bone-index']['Y'], Config.PropList[Name]['bone-index']['Z'], Config.PropList[Name]['bone-index']['XR'], Config.PropList[Name]['bone-index']['YR'], Config.PropList[Name]['bone-index']['ZR'], true, true, false, true, 1, true)
        table.insert(AllProps, CurrentProp)
      end
    end 
end

function RemoveProp()
  for k, v in pairs(AllProps) do
    NetworkRequestControlOfEntity(v)
    SetEntityAsMissionEntity(v, true, true)
    DetachEntity(v, 1, 1)
    DeleteEntity(v)
    DeleteObject(v)
  end
    AllProps = {}
    HasProp = false
end

function GetPropStatus()
  return HasProp
end

function RequestModelHash(Model)
  RequestModel(Model)
	while not HasModelLoaded(Model) do
      Wait(1)
    end
end

AddEventHandler('onResourceStop', function(resource)
	RemoveProp()
end)

-- RegisterCommand('gloves', function()
--     putGloves()
-- end)

-- RegisterCommand('nogloves', function()
--     removeGloves()
-- end)

-- local Gloves = {}
-- function putGloves()
--     local ped = GetPlayerPed(-1)
--     local hash = GetHashKey('prop_boxing_glove_01')
--     while not HasModelLoaded(hash) do RequestModel(hash); Citizen.Wait(0); end
--     local pos = GetEntityCoords(ped)
--     local gloveA = CreateObject(hash, pos.x,pos.y,pos.z + 0.50, true,false,false)
--     local gloveB = CreateObject(hash, pos.x,pos.y,pos.z + 0.50, true,false,false)
--     table.insert(Gloves,gloveA)
--     table.insert(Gloves,gloveB)
--     SetModelAsNoLongerNeeded(hash)
--     FreezeEntityPosition(gloveA,false)
--     SetEntityCollision(gloveA,false,true)
--     ActivatePhysics(gloveA)
--     FreezeEntityPosition(gloveB,false)
--     SetEntityCollision(gloveB,false,true)
--     ActivatePhysics(gloveB)
--     if not ped then ped = GetPlayerPed(-1); end -- gloveA = L, gloveB = R
--     AttachEntityToEntity(gloveA, ped, GetPedBoneIndex(ped, 0xEE4F), 0.05, 0.00,  0.04,     00.0, 90.0, -90.0, true, true, false, true, 1, true) -- object is attached to right hand 
--     AttachEntityToEntity(gloveB, ped, GetPedBoneIndex(ped, 0xAB22), 0.05, 0.00, -0.04,     00.0, 90.0,  90.0, true, true, false, true, 1, true) -- object is attached to right hand 
-- end

-- function removeGloves()
--     for k,v in pairs(Gloves) do DeleteObject(v); end
-- end
