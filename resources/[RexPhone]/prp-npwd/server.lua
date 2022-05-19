local ProjectRP = exports['prp-core']:GetCoreObject()

AddEventHandler('ProjectRP:Server:PlayerLoaded', function(prpPlayer)
  local playerIdent = prpPlayer.PlayerData.citizenid
  local phoneNumber = tostring(prpPlayer.PlayerData.charinfo.phone)
  local charInfo = prpPlayer.PlayerData.charinfo
  local playerSrc = prpPlayer.PlayerData.source

  MySQL.Sync.fetchAll('UPDATE players SET phone_number = ? WHERE citizenid = ?', { phoneNumber, playerIdent })

  exports.npwd:newPlayer({
    source = playerSrc,
    phoneNumber = charInfo.phone,
    identifier = playerIdent,
    firstname = charInfo.firstname,
    lastname = charInfo.lastname
  })
  debugPrint(('Loaded new player. S: %s, Iden: %s, Num: %s'):format(playerSrc, playerIdent, phoneNumber))
end)

AddEventHandler('ProjectRP:Client:OnPlayerUnload', function(src)
  exports.npwd:unloadPlayer(src)
end)

local currentResName = GetCurrentResourceName()

AddEventHandler('onServerResourceStart', function(resName)
  if resName ~= currentResName then return end

  debugPrint('Launched with debug mode on')
  local players = ProjectRP.Functions.GetPRPPlayers()

  for _,v in pairs(players) do
    exports.npwd:newPlayer({
      source = v.PlayerData.source,
      identifier = v.PlayerData.citizenid,
      phoneNumber = v.PlayerData.charinfo.phone,
      firstname = v.PlayerData.charinfo.firstname,
      lastname = v.PlayerData.charinfo.lastname,
    })
  end
end)

ProjectRP.Functions.CreateUseableItem(getTableKeys(Config.PhoneList), function(source, item)
  TriggerClientEvent('prp-npwd:client:setPhoneVisible', source, true)
end)