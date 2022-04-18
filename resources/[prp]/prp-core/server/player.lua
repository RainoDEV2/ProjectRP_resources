ProjectRP.Players = {}
ProjectRP.Player = {}

-- On player login get their data or set defaults
-- Don't touch any of this unless you know what you are doing
-- Will cause major issues!

function ProjectRP.Player.Login(source, citizenid, newData)
    local src = source
    if src then
        if citizenid then
            local result = exports.oxmysql:executeSync('SELECT * FROM players WHERE citizenid = ?', { citizenid })
            local PlayerData = result[1]
            if PlayerData then
                PlayerData.money = json.decode(PlayerData.money)
                PlayerData.job = json.decode(PlayerData.job)
                PlayerData.position = json.decode(PlayerData.position)
                PlayerData.metadata = json.decode(PlayerData.metadata)
                PlayerData.charinfo = json.decode(PlayerData.charinfo)
                if PlayerData.gang then
                    PlayerData.gang = json.decode(PlayerData.gang)
                else
                    PlayerData.gang = {}
                end
            end
            ProjectRP.Player.CheckPlayerData(src, PlayerData)
        else
            ProjectRP.Player.CheckPlayerData(src, newData)
        end
        return true
    else
        ProjectRP.ShowError(GetCurrentResourceName(), 'ERROR ProjectRP.PLAYER.LOGIN - NO SOURCE GIVEN!')
        return false
    end
end

function ProjectRP.Player.CheckPlayerData(source, PlayerData)
    local src = source
    PlayerData = PlayerData or {}
    PlayerData.source = src
    PlayerData.citizenid = PlayerData.citizenid or ProjectRP.Player.CreateCitizenId()
    PlayerData.license = PlayerData.license or ProjectRP.Functions.GetIdentifier(src, 'license')
    PlayerData.name = GetPlayerName(src)
    PlayerData.cid = PlayerData.cid or 1
    PlayerData.money = PlayerData.money or {}
    for moneytype, startamount in pairs(ProjectRP.Config.Money.MoneyTypes) do
        PlayerData.money[moneytype] = PlayerData.money[moneytype] or startamount
    end
    -- Charinfo
    PlayerData.charinfo = PlayerData.charinfo or {}
    PlayerData.charinfo.firstname = PlayerData.charinfo.firstname or 'Firstname'
    PlayerData.charinfo.lastname = PlayerData.charinfo.lastname or 'Lastname'
    PlayerData.charinfo.birthdate = PlayerData.charinfo.birthdate or '00-00-0000'
    PlayerData.charinfo.gender = PlayerData.charinfo.gender or 0
    PlayerData.charinfo.backstory = PlayerData.charinfo.backstory or 'placeholder backstory'
    PlayerData.charinfo.nationality = PlayerData.charinfo.nationality or 'USA'
    PlayerData.charinfo.phone = PlayerData.charinfo.phone ~= nil and PlayerData.charinfo.phone or '1' .. math.random(111111111, 999999999)
    PlayerData.charinfo.account = PlayerData.charinfo.account ~= nil and PlayerData.charinfo.account or 'US0' .. math.random(1, 9) .. 'ProjectRP' .. math.random(1111, 9999) .. math.random(1111, 9999) .. math.random(11, 99)
    -- Metadata
    PlayerData.metadata = PlayerData.metadata or {}
    PlayerData.metadata['hunger'] = PlayerData.metadata['hunger'] or 100
    PlayerData.metadata['thirst'] = PlayerData.metadata['thirst'] or 100
    PlayerData.metadata['stress'] = PlayerData.metadata['stress'] or 0
    PlayerData.metadata['isdead'] = PlayerData.metadata['isdead'] or false
    PlayerData.metadata['inlaststand'] = PlayerData.metadata['inlaststand'] or false
    PlayerData.metadata['armor'] = PlayerData.metadata['armor'] or 0
    PlayerData.metadata['ishandcuffed'] = PlayerData.metadata['ishandcuffed'] or false
    PlayerData.metadata['tracker'] = PlayerData.metadata['tracker'] or false
    PlayerData.metadata['injail'] = PlayerData.metadata['injail'] or 0
    PlayerData.metadata['jailitems'] = PlayerData.metadata['jailitems'] or {}
    PlayerData.metadata['status'] = PlayerData.metadata['status'] or {}
    PlayerData.metadata['phone'] = PlayerData.metadata['phone'] or {}
    PlayerData.metadata['fitbit'] = PlayerData.metadata['fitbit'] or {}
    PlayerData.metadata['commandbinds'] = PlayerData.metadata['commandbinds'] or {}
    PlayerData.metadata['bloodtype'] = PlayerData.metadata['bloodtype'] or ProjectRP.Config.Player.Bloodtypes[math.random(1, #ProjectRP.Config.Player.Bloodtypes)]
    PlayerData.metadata['dealerrep'] = PlayerData.metadata['dealerrep'] or 0
    PlayerData.metadata['craftingrep'] = PlayerData.metadata['craftingrep'] or 0
    PlayerData.metadata['attachmentcraftingrep'] = PlayerData.metadata['attachmentcraftingrep'] or 0
    PlayerData.metadata['currentapartment'] = PlayerData.metadata['currentapartment'] or nil
    PlayerData.metadata['jobrep'] = PlayerData.metadata['jobrep'] or {
        ['tow'] = 0,
        ['trucker'] = 0,
        ['taxi'] = 0,
        ['hotdog'] = 0,
    }
    PlayerData.metadata['callsign'] = PlayerData.metadata['callsign'] or 'NO CALLSIGN'
    PlayerData.metadata['fingerprint'] = PlayerData.metadata['fingerprint'] or ProjectRP.Player.CreateFingerId()
    PlayerData.metadata['walletid'] = PlayerData.metadata['walletid'] or ProjectRP.Player.CreateWalletId()
    PlayerData.metadata['criminalrecord'] = PlayerData.metadata['criminalrecord'] or {
        ['hasRecord'] = false,
        ['date'] = nil
    }
    PlayerData.metadata['licences'] = PlayerData.metadata['licences'] or {
        ['driver'] = true,
        ['business'] = false,
        ['weapon'] = false,
        ['permit'] = false
    }
    PlayerData.metadata['inside'] = PlayerData.metadata['inside'] or {
        house = nil,
        apartment = {
            apartmentType = nil,
            apartmentId = nil,
        }
    }
    PlayerData.metadata['phonedata'] = PlayerData.metadata['phonedata'] or {
        SerialNumber = ProjectRP.Player.CreateSerialNumber(),
        InstalledApps = {},
    }
    -- Job
    PlayerData.job = PlayerData.job or {}
    PlayerData.job.name = PlayerData.job.name or 'unemployed'
    PlayerData.job.label = PlayerData.job.label or 'Civilian'
    PlayerData.job.payment = PlayerData.job.payment or 10
    if ProjectRP.Shared.ForceJobDefaultDutyAtLogin or PlayerData.job.onduty == nil then
        PlayerData.job.onduty = ProjectRP.Shared.Jobs[PlayerData.job.name].defaultDuty
    end
    PlayerData.job.isboss = PlayerData.job.isboss or false
    PlayerData.job.grade = PlayerData.job.grade or {}
    PlayerData.job.grade.name = PlayerData.job.grade.name or 'Freelancer'
    PlayerData.job.grade.level = PlayerData.job.grade.level or 0
    -- Gang
    PlayerData.gang = PlayerData.gang or {}
    PlayerData.gang.name = PlayerData.gang.name or 'none'
    PlayerData.gang.label = PlayerData.gang.label or 'No Gang Affiliaton'
    PlayerData.gang.isboss = PlayerData.gang.isboss or false
    PlayerData.gang.grade = PlayerData.gang.grade or {}
    PlayerData.gang.grade.name = PlayerData.gang.grade.name or 'none'
    PlayerData.gang.grade.level = PlayerData.gang.grade.level or 0
    -- Other
    PlayerData.position = PlayerData.position or PRPConfig.DefaultSpawn
    PlayerData.LoggedIn = true
    PlayerData = ProjectRP.Player.LoadInventory(PlayerData)
    ProjectRP.Player.CreatePlayer(PlayerData)
end

-- On player logout

function ProjectRP.Player.Logout(source)
    local src = source
    TriggerClientEvent('ProjectRP:Client:OnPlayerUnload', src)
    TriggerClientEvent('ProjectRP:Player:UpdatePlayerData', src)
    Citizen.Wait(200)
    ProjectRP.Players[src] = nil
end

-- Create a new character
-- Don't touch any of this unless you know what you are doing
-- Will cause major issues!

function ProjectRP.Player.CreatePlayer(PlayerData)
    local self = {}
    self.Functions = {}
    self.PlayerData = PlayerData

    self.Functions.UpdatePlayerData = function(dontUpdateChat)
        TriggerClientEvent('ProjectRP:Player:SetPlayerData', self.PlayerData.source, self.PlayerData)
        if dontUpdateChat == nil then
            ProjectRP.Commands.Refresh(self.PlayerData.source)
        end
    end

    self.Functions.SetJob = function(job, grade)
        local job = job:lower()
        local grade = tostring(grade) or '0'

        if ProjectRP.Shared.Jobs[job] then
            self.PlayerData.job.name = job
            self.PlayerData.job.label = ProjectRP.Shared.Jobs[job].label
            self.PlayerData.job.onduty = ProjectRP.Shared.Jobs[job].defaultDuty

            if ProjectRP.Shared.Jobs[job].grades[grade] then
                local jobgrade = ProjectRP.Shared.Jobs[job].grades[grade]
                self.PlayerData.job.grade = {}
                self.PlayerData.job.grade.name = jobgrade.name
                self.PlayerData.job.grade.level = tonumber(grade)
                self.PlayerData.job.payment = jobgrade.payment or 30
                self.PlayerData.job.isboss = jobgrade.isboss or false
            else
                self.PlayerData.job.grade = {}
                self.PlayerData.job.grade.name = 'No Grades'
                self.PlayerData.job.grade.level = 0
                self.PlayerData.job.payment = 30
                self.PlayerData.job.isboss = false
            end

            self.Functions.UpdatePlayerData()
            TriggerClientEvent('ProjectRP:Client:OnJobUpdate', self.PlayerData.source, self.PlayerData.job)
            return true
        end

        return false
    end

    self.Functions.SetGang = function(gang, grade)
        local gang = gang:lower()
        local grade = tostring(grade) or '0'

        if ProjectRP.Shared.Gangs[gang] then
            self.PlayerData.gang.name = gang
            self.PlayerData.gang.label = ProjectRP.Shared.Gangs[gang].label
            if ProjectRP.Shared.Gangs[gang].grades[grade] then
                local ganggrade = ProjectRP.Shared.Gangs[gang].grades[grade]
                self.PlayerData.gang.grade = {}
                self.PlayerData.gang.grade.name = ganggrade.name
                self.PlayerData.gang.grade.level = tonumber(grade)
                self.PlayerData.gang.isboss = ganggrade.isboss or false
            else
                self.PlayerData.gang.grade = {}
                self.PlayerData.gang.grade.name = 'No Grades'
                self.PlayerData.gang.grade.level = 0
                self.PlayerData.gang.isboss = false
            end

            self.Functions.UpdatePlayerData()
            TriggerClientEvent('ProjectRP:Client:OnGangUpdate', self.PlayerData.source, self.PlayerData.gang)
            return true
        end
        return false
    end

    self.Functions.SetJobDuty = function(onDuty)
        self.PlayerData.job.onduty = onDuty
        self.Functions.UpdatePlayerData()
    end

    self.Functions.SetMetaData = function(meta, val)
        local meta = meta:lower()
        if val ~= nil then
            self.PlayerData.metadata[meta] = val
            self.Functions.UpdatePlayerData()
        end
    end

    self.Functions.AddJobReputation = function(amount)
        local amount = tonumber(amount)
        self.PlayerData.metadata['jobrep'][self.PlayerData.job.name] = self.PlayerData.metadata['jobrep'][self.PlayerData.job.name] + amount
        self.Functions.UpdatePlayerData()
    end

    self.Functions.AddMoney = function(moneytype, amount, reason)
        reason = reason or 'unknown'
        local moneytype = moneytype:lower()
        local amount = tonumber(amount)
        if amount < 0 then
            return
        end
        if self.PlayerData.money[moneytype] then
            old = self.PlayerData.money[moneytype]
            self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] + amount
            self.Functions.UpdatePlayerData()
            if amount > 100000 then
                TriggerEvent('prp-log:server:CreateLog', 'playermoney', 'Money Added ('..moneytype..')', 'lightgreen', '**Name**\n```Steam Name: ' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ' | Character Name: ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.firstname .. ' ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.lastname .. ')```\n **Details**\n```'..moneytype..' Balance Before: '..old..' | New Balance: '..self.PlayerData.money[moneytype]..' | Amount Added: '..amount..'```**Reason:**\n```'..reason..'```', true)
                -- TriggerEvent('prp-log:server:CreateLog', 'playermoney', 'AddMoney', 'lightgreen', '**Name**\n```' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')```\n $' .. amount .. ' (' .. moneytype .. ') added, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype], true)
            else
                TriggerEvent('prp-log:server:CreateLog', 'playermoney', 'Money Added ('..moneytype..')', 'lightgreen', '**Name**\n```Steam Name: ' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ' | Character Name: ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.firstname .. ' ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.lastname .. ')```\n **Details**\n```'..moneytype..' Balance Before: '..old..' | New Balance: '..self.PlayerData.money[moneytype]..' | Amount Added: '..amount..'```**Reason:**\n```'..reason..'```')
                -- TriggerEvent('prp-log:server:CreateLog', 'playermoney', 'AddMoney', 'lightgreen', '**Name**\n```' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')```\n $' .. amount .. ' (' .. moneytype .. ') added, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype])
            end
            TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, false)
            return true
        end
        return false
    end

    self.Functions.RemoveMoney = function(moneytype, amount, reason)
        reason = reason or 'unknown'
        local moneytype = moneytype:lower()
        local amount = tonumber(amount)
        if amount < 0 then
            return
        end
        if self.PlayerData.money[moneytype] then
            for _, mtype in pairs(ProjectRP.Config.Money.DontAllowMinus) do
                if mtype == moneytype then
                    if self.PlayerData.money[moneytype] - amount < 0 then
                        return false
                    end
                end
            end
            old = self.PlayerData.money[moneytype]
            self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] - amount
            self.Functions.UpdatePlayerData()
            if amount > 100000 then
                TriggerEvent('prp-log:server:CreateLog', 'playermoney', 'Money Removed ('..moneytype..')', 'red', '**Name**\n```Steam Name: ' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ' | Character Name: ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.firstname .. ' ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.lastname .. ')```\n **Details**\n```'..moneytype..' Balance Before: $'..old..' | New Balance: $'..self.PlayerData.money[moneytype]..' | Amount Added: $'..amount..'```**Reason:**\n```'..reason..'```', true)
            else
                TriggerEvent('prp-log:server:CreateLog', 'playermoney', 'Money Removed ('..moneytype..')', 'red', '**Name**\n```Steam Name: ' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ' | Character Name: ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.firstname .. ' ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.lastname .. ')```\n **Details**\n```'..moneytype..' Balance Before: $'..old..' | New Balance: $'..self.PlayerData.money[moneytype]..' | Amount Added: $'..amount..'```**Reason:**\n```'..reason..'```')
            end
            TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, true)
            if moneytype == 'bank' then
                TriggerClientEvent('prp-phone:client:RemoveBankMoney', self.PlayerData.source, amount)
            end
            return true
        end
        return false
    end

    self.Functions.SetMoney = function(moneytype, amount, reason)
        reason = reason or 'unknown'
        local moneytype = moneytype:lower()
        local amount = tonumber(amount)
        if amount < 0 then
            return
        end
        if self.PlayerData.money[moneytype] then
            old = self.PlayerData.money[moneytype]
            self.PlayerData.money[moneytype] = amount
            self.Functions.UpdatePlayerData()
            TriggerEvent('prp-log:server:CreateLog', 'playermoney', 'Money Set', 'green', '**Name**\n```Steam Name: ' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ' | Character Name: ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.firstname .. ' ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.lastname .. ')```\n **Details**\n```'..moneytype..' Old Balance: $'..old..' | New Balance: $'..self.PlayerData.money[moneytype]..'```**Reason:**\n```'..reason..'```')
            -- TriggerEvent('prp-log:server:CreateLog', 'playermoney', 'Money Set', 'green', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') set, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype])
            return true
        end
        return false
    end

    self.Functions.GetMoney = function(moneytype)
        if moneytype then
            local moneytype = moneytype:lower()
            return self.PlayerData.money[moneytype]
        end
        return false
    end

    self.Functions.AddItem = function(item, amount, slot, info)
        local totalWeight = ProjectRP.Player.GetTotalWeight(self.PlayerData.items)
        local itemInfo = ProjectRP.Shared.Items[item:lower()]
        if itemInfo == nil then
            TriggerClientEvent('ProjectRP:Notify', self.PlayerData.source, 'Item Does Not Exist', 'error')
            return
        end
        local amount = tonumber(amount)
        local slot = tonumber(slot) or ProjectRP.Player.GetFirstSlotByItem(self.PlayerData.items, item)
        if itemInfo['type'] == 'weapon' and info == nil then
            info = {
                serie = tostring("SCRAPED")
                -- serie = tostring(ProjectRP.Shared.RandomInt(2) .. ProjectRP.Shared.RandomStr(3) .. ProjectRP.Shared.RandomInt(1) .. ProjectRP.Shared.RandomStr(2) .. ProjectRP.Shared.RandomInt(3) .. ProjectRP.Shared.RandomStr(4)),
            }
        end
        if (totalWeight + (itemInfo['weight'] * amount)) <= ProjectRP.Config.Player.MaxWeight then
            if (slot and self.PlayerData.items[slot]) and (self.PlayerData.items[slot].name:lower() == item:lower()) and (itemInfo['type'] == 'item' and not itemInfo['unique']) then
                self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount + amount
                self.Functions.UpdatePlayerData()
                TriggerEvent('prp-log:server:CreateLog', 'playerinventory', 'Item Added', 'green', '**Name**\n```Steam Name: ' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ' | Character Name: ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.firstname .. ' ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.lastname .. ')```\n **Details**\n```Recieved  Item: [Name:'..self.PlayerData.items[slot].name..'] [slot:' .. slot .. '] [Amount: '..amount..'] [New Amount: '..self.PlayerData.items[slot].amount..']```')
                return true
            elseif (not itemInfo['unique'] and slot or slot and self.PlayerData.items[slot] == nil) then
                self.PlayerData.items[slot] = { name = itemInfo['name'], amount = amount, info = info or '', label = itemInfo['label'], description = itemInfo['description'] or '', weight = itemInfo['weight'], type = itemInfo['type'], unique = itemInfo['unique'], useable = itemInfo['useable'], image = itemInfo['image'], shouldClose = itemInfo['shouldClose'], slot = slot, combinable = itemInfo['combinable'] }
                self.Functions.UpdatePlayerData()
                TriggerEvent('prp-log:server:CreateLog', 'playerinventory', 'Item Added', 'green', '**Name**\n```Steam Name: ' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ' | Character Name: ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.firstname .. ' ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.lastname .. ')```\n **Details**\n```Recieved  Item: [Name:'..self.PlayerData.items[slot].name..'] [slot:' .. slot .. '] [Amount: '..amount..'] [New Amount: '..self.PlayerData.items[slot].amount..']```')
            
                return true
            elseif (itemInfo['unique']) or (not slot or slot == nil) or (itemInfo['type'] == 'weapon') then
                for i = 1, PRPConfig.Player.MaxInvSlots, 1 do
                    if self.PlayerData.items[i] == nil then
                        self.PlayerData.items[i] = { name = itemInfo['name'], amount = amount, info = info or '', label = itemInfo['label'], description = itemInfo['description'] or '', weight = itemInfo['weight'], type = itemInfo['type'], unique = itemInfo['unique'], useable = itemInfo['useable'], image = itemInfo['image'], shouldClose = itemInfo['shouldClose'], slot = i, combinable = itemInfo['combinable'] }
                        self.Functions.UpdatePlayerData()
                        TriggerEvent('prp-log:server:CreateLog', 'playerinventory', 'Item Added', 'green', '**Name**\n```Steam Name: ' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ' | Character Name: ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.firstname .. ' ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.lastname .. ')```')
                        return true
                    end
                end
            end
        else
            TriggerClientEvent('ProjectRP:Notify', self.PlayerData.source, 'Your inventory is too heavy!', 'error')
        end
        return false
    end

    self.Functions.RemoveItem = function(item, amount, slot)
        local amount = tonumber(amount)
        local slot = tonumber(slot)
        if slot then
            if self.PlayerData.items[slot].amount > amount then
                self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount - amount
                self.Functions.UpdatePlayerData()
                TriggerEvent('prp-log:server:CreateLog', 'playerinventory', 'Item Removed', 'red', '**Name**\n```Steam Name: ' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ' | Character Name: ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.firstname .. ' ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.lastname .. ')```\n **Details**\n```Removed  Item: [Name:'..item..'] [slot:' .. slot .. '] [Amount: '..amount..'] [New Amount: '..self.PlayerData.items[slot].amount..']```')
                return true
            else
                self.PlayerData.items[slot] = nil
                self.Functions.UpdatePlayerData()
                TriggerEvent('prp-log:server:CreateLog', 'playerinventory', 'Item Removed', 'red', '**Name**\n```Steam Name: ' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ' | Character Name: ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.firstname .. ' ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.lastname .. ')```\n **Details**\n```Removed  Item: [Name:'..item..'] [slot:' .. slot .. '] [Amount: '..amount..']```')
            
                return true
            end
        else
            local slots = ProjectRP.Player.GetSlotsByItem(self.PlayerData.items, item)
            local amountToRemove = amount
            if slots then
                for _, slot in pairs(slots) do
                    if self.PlayerData.items[slot].amount > amountToRemove then
                        self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount - amountToRemove
                        self.Functions.UpdatePlayerData()
                        TriggerEvent('prp-log:server:CreateLog', 'playerinventory', 'Item Removed', 'red', '**Name**\n```Steam Name: ' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ' | Character Name: ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.firstname .. ' ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.lastname .. ')```\n **Details**\n```Removed  Item: [Name:'..item..'] [slot:' .. slot .. '] [Amount: '..amount..'] [New Amount: '..self.PlayerData.items[slot].amount..']```')
                        return true
                    elseif self.PlayerData.items[slot].amount == amountToRemove then
                        self.PlayerData.items[slot] = nil
                        self.Functions.UpdatePlayerData()
                        TriggerEvent('prp-log:server:CreateLog', 'playerinventory', 'Item Removed', 'red', '**Name**\n```Steam Name: ' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ' | Character Name: ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.firstname .. ' ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.lastname .. ')```\n **Details**\n```Removed  Item: [Name:'..item..'] [slot:' .. slot .. '] [Amount: '..amount..']```')
                       
                        return true
                    end
                end
            end
        end
        return false
    end

    self.Functions.SetInventory = function(items, dontUpdateChat)
        self.PlayerData.items = items
        self.Functions.UpdatePlayerData(dontUpdateChat)
        TriggerEvent('prp-log:server:CreateLog', 'playerinventory', 'Inventory Set', 'blue', '**Name**\n```Steam Name: ' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ' | Character Name: ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.firstname .. ' ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.lastname .. ')```\n **Details**\n```Items Set: '..json.encode(items)..'```')
    end

    self.Functions.ClearInventory = function()
        self.PlayerData.items = {}
        self.Functions.UpdatePlayerData()
        TriggerEvent('prp-log:server:CreateLog', 'playerinventory', 'Inventory Cleared', 'red', '**Name**\n```Steam Name: ' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ' | Character Name: ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.firstname .. ' ' .. ProjectRP.Functions.GetPlayer(self.PlayerData.source).PlayerData.charinfo.lastname .. ')```\n **Details**\n```Inventory Cleared```')
    end

    self.Functions.GetItemByName = function(item)
        local item = tostring(item):lower()
        local slot = ProjectRP.Player.GetFirstSlotByItem(self.PlayerData.items, item)
        if slot then
            return self.PlayerData.items[slot]
        end
        return nil
    end

    self.Functions.GetItemsByName = function(item)
        local item = tostring(item):lower()
        local items = {}
        local slots = ProjectRP.Player.GetSlotsByItem(self.PlayerData.items, item)
        for _, slot in pairs(slots) do
            if slot then
                items[#items+1] = self.PlayerData.items[slot]
            end
        end
        return items
    end

    self.Functions.SetCreditCard = function(cardNumber)
        self.PlayerData.charinfo.card = cardNumber
        self.Functions.UpdatePlayerData()
    end

    self.Functions.GetCardSlot = function(cardNumber, cardType)
        local item = tostring(cardType):lower()
        local slots = ProjectRP.Player.GetSlotsByItem(self.PlayerData.items, item)
        for _, slot in pairs(slots) do
            if slot then
                if self.PlayerData.items[slot].info.cardNumber == cardNumber then
                    return slot
                end
            end
        end
        return nil
    end

    self.Functions.GetItemBySlot = function(slot)
        local slot = tonumber(slot)
        if self.PlayerData.items[slot] then
            return self.PlayerData.items[slot]
        end
        return nil
    end

    self.Functions.Save = function()
        ProjectRP.Player.Save(self.PlayerData.source)
    end

    ProjectRP.Players[self.PlayerData.source] = self
    ProjectRP.Player.Save(self.PlayerData.source)

    -- At this point we are safe to emit new instance to third party resource for load handling
    TriggerEvent('ProjectRP:Server:PlayerLoaded', self)
    self.Functions.UpdatePlayerData()
end

-- Save player info to database (make sure citizenid is the primary key in your database)

function ProjectRP.Player.Save(source)
    local src = source
    local ped = GetPlayerPed(src)
    local pcoords = GetEntityCoords(ped)
    local PlayerData = ProjectRP.Players[src].PlayerData
    if PlayerData then
        exports.oxmysql:insert('INSERT INTO players (citizenid, cid, license, name, money, charinfo, job, gang, position, metadata) VALUES (:citizenid, :cid, :license, :name, :money, :charinfo, :job, :gang, :position, :metadata) ON DUPLICATE KEY UPDATE cid = :cid, name = :name, money = :money, charinfo = :charinfo, job = :job, gang = :gang, position = :position, metadata = :metadata', {
            citizenid = PlayerData.citizenid,
            cid = tonumber(PlayerData.cid),
            license = PlayerData.license,
            name = PlayerData.name,
            money = json.encode(PlayerData.money),
            charinfo = json.encode(PlayerData.charinfo),
            job = json.encode(PlayerData.job),
            gang = json.encode(PlayerData.gang),
            position = json.encode(pcoords),
            metadata = json.encode(PlayerData.metadata)
        })
        ProjectRP.Player.SaveInventory(src)
        ProjectRP.ShowSuccess(GetCurrentResourceName(), PlayerData.name .. ' PLAYER SAVED!')
    else
        ProjectRP.ShowError(GetCurrentResourceName(), 'ERROR ProjectRP.PLAYER.SAVE - PLAYERDATA IS EMPTY!')
    end
end

-- Delete character

local playertables = { -- Add tables as needed
    { table = 'players' },
    { table = 'apartments' },
    { table = 'bank_accounts' },
    { table = 'crypto_transactions' },
    { table = 'phone_invoices' },
    { table = 'phone_messages' },
    { table = 'playerskins' },
    { table = 'player_boats' },
    { table = 'player_contacts' },
    { table = 'player_houses' },
    { table = 'player_mails' },
    { table = 'player_outfits' },
    { table = 'player_vehicles' }
}

function ProjectRP.Player.DeleteCharacter(source, citizenid)
    local src = source
    local license = ProjectRP.Functions.GetIdentifier(src, 'license')
    local result = exports.oxmysql:scalarSync('SELECT license FROM players where citizenid = ?', { citizenid })
    if license == result then
        for k, v in pairs(playertables) do
            exports.oxmysql:execute('DELETE FROM ' .. v.table .. ' WHERE citizenid = ?', { citizenid })
        end
        TriggerEvent('prp-log:server:CreateLog', 'joinleave', 'Character Deleted', 'red', '**' .. GetPlayerName(src) .. '** ' .. license .. ' deleted **' .. citizenid .. '**..')
    else
        DropPlayer(src, 'You Have Been Kicked For Exploitation')
        TriggerEvent('prp-log:server:CreateLog', 'anticheat', 'Anti-Cheat', 'white', GetPlayerName(src) .. ' Has Been Dropped For Character Deletion Exploit', false)
    end
end

-- Inventory

ProjectRP.Player.LoadInventory = function(PlayerData)
    PlayerData.items = {}
    local result = exports.oxmysql:singleSync('SELECT * FROM players WHERE citizenid = ?', { PlayerData.citizenid })
    if result then
        if result.inventory then
            local plyInventory = json.decode(result.inventory)
            if next(plyInventory) then
                for _, item in pairs(plyInventory) do
                    if item then
                        local itemInfo = ProjectRP.Shared.Items[item.name:lower()]
                        if itemInfo then
                            PlayerData.items[item.slot] = {
                                name = itemInfo['name'],
                                amount = item.amount,
                                info = item.info or '',
                                label = itemInfo['label'],
                                description = itemInfo['description'] or '',
                                weight = itemInfo['weight'],
                                type = itemInfo['type'],
                                unique = itemInfo['unique'],
                                useable = itemInfo['useable'],
                                image = itemInfo['image'],
                                shouldClose = itemInfo['shouldClose'],
                                slot = item.slot,
                                combinable = itemInfo['combinable']
                            }
                        end
                    end
                end
            end
        end
    end
    return PlayerData
end

ProjectRP.Player.SaveInventory = function(source)
    local src = source
    if ProjectRP.Players[src] then
        local PlayerData = ProjectRP.Players[src].PlayerData
        local items = PlayerData.items
        local ItemsJson = {}
        if items and next(items) then
            for slot, item in pairs(items) do
                if items[slot] then
                    ItemsJson[#ItemsJson+1] = {
                        name = item.name,
                        amount = item.amount,
                        info = item.info,
                        type = item.type,
                        slot = slot,
                    }
                end
            end
            exports.oxmysql:execute('UPDATE players SET inventory = ? WHERE citizenid = ?', { json.encode(ItemsJson), PlayerData.citizenid })
        else
            exports.oxmysql:execute('UPDATE players SET inventory = ? WHERE citizenid = ?', { '[]', PlayerData.citizenid })
        end
    end
end

-- Util Functions

function ProjectRP.Player.GetTotalWeight(items)
    local weight = 0
    if items then
        for slot, item in pairs(items) do
            weight = weight + (item.weight * item.amount)
        end
    end
    return tonumber(weight)
end

function ProjectRP.Player.GetSlotsByItem(items, itemName)
    local slotsFound = {}
    if items then
        for slot, item in pairs(items) do
            if item.name:lower() == itemName:lower() then
                slotsFound[#slotsFound+1] = slot
            end
        end
    end
    return slotsFound
end

function ProjectRP.Player.GetFirstSlotByItem(items, itemName)
    if items then
        for slot, item in pairs(items) do
            if item.name:lower() == itemName:lower() then
                return tonumber(slot)
            end
        end
    end
    return nil
end

function ProjectRP.Player.CreateCitizenId()
    local UniqueFound = false
    local CitizenId = nil
    while not UniqueFound do
        CitizenId = tostring(ProjectRP.Shared.RandomStr(3) .. ProjectRP.Shared.RandomInt(5)):upper()
        local result = exports.oxmysql:executeSync('SELECT COUNT(*) as count FROM players WHERE citizenid = ?', { CitizenId })
        if result[1].count == 0 then
            UniqueFound = true
        end
    end
    return CitizenId
end

function ProjectRP.Player.CreateFingerId()
    local UniqueFound = false
    local FingerId = nil
    while not UniqueFound do
        FingerId = tostring(ProjectRP.Shared.RandomStr(2) .. ProjectRP.Shared.RandomInt(3) .. ProjectRP.Shared.RandomStr(1) .. ProjectRP.Shared.RandomInt(2) .. ProjectRP.Shared.RandomStr(3) .. ProjectRP.Shared.RandomInt(4))
        local query = '%' .. FingerId .. '%'
        local result = exports.oxmysql:executeSync('SELECT COUNT(*) as count FROM `players` WHERE `metadata` LIKE ?', { query })
        if result[1].count == 0 then
            UniqueFound = true
        end
    end
    return FingerId
end

function ProjectRP.Player.CreateWalletId()
    local UniqueFound = false
    local WalletId = nil
    while not UniqueFound do
        WalletId = 'prp-' .. math.random(11111111, 99999999)
        local query = '%' .. WalletId .. '%'
        local result = exports.oxmysql:executeSync('SELECT COUNT(*) as count FROM players WHERE metadata LIKE ?', { query })
        if result[1].count == 0 then
            UniqueFound = true
        end
    end
    return WalletId
end

function ProjectRP.Player.CreateSerialNumber()
    local UniqueFound = false
    local SerialNumber = nil
    while not UniqueFound do
        SerialNumber = math.random(11111111, 99999999)
        local query = '%' .. SerialNumber .. '%'
        local result = exports.oxmysql:executeSync('SELECT COUNT(*) as count FROM players WHERE metadata LIKE ?', { query })
        if result[1].count == 0 then
            UniqueFound = true
        end
    end
    return SerialNumber
end

PaycheckLoop() -- This just starts the paycheck system
