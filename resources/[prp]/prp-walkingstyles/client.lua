ProjectRP = exports['prp-core']:GetCoreObject()

local PlayerData = {}
local currentwalkingstyle = 'default'

RegisterNetEvent('ProjectRP:Client:OnPlayerLoaded', function(playerData)
	PlayerData = ProjectRP.Functions.GetPlayerData()
	TriggerServerEvent('prp-walkstyles:server:walkstyles', 'get')
end)

RegisterNetEvent('prp-walkstyles:openmenu', function()
	OpenWalkMenu()
end)

-- // Walkstyle Events \\ --
RegisterNetEvent('prp-walkstyles:arrogant', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_f@arrogant@a')
end)
RegisterNetEvent('prp-walkstyles:casual', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@casual@a')
end)
RegisterNetEvent('prp-walkstyles:casual2', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@casual@b')
end)
RegisterNetEvent('prp-walkstyles:casual3', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@casual@c')
end)
RegisterNetEvent('prp-walkstyles:casual4', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@casual@d')
end)
RegisterNetEvent('prp-walkstyles:casual5', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@casual@e')
end)
RegisterNetEvent('prp-walkstyles:casual6', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@casual@f')
end)
RegisterNetEvent('prp-walkstyles:confident', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@confident')
end)
RegisterNetEvent('prp-walkstyles:business', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@business@a')
end)
RegisterNetEvent('prp-walkstyles:business2', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@business@b')
end)
RegisterNetEvent('prp-walkstyles:business3', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@business@c')
end)
RegisterNetEvent('prp-walkstyles:femme', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_f@femme@')
end)
RegisterNetEvent('prp-walkstyles:flee', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_f@flee@a')
end)
RegisterNetEvent('prp-walkstyles:gangster', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@gangster@generic')
end)
RegisterNetEvent('prp-walkstyles:gangster2', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@gangster@ng')
end)
RegisterNetEvent('prp-walkstyles:gangster3', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@gangster@var_e')
end)
RegisterNetEvent('prp-walkstyles:gangster4', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@gangster@var_f')
end)
RegisterNetEvent('prp-walkstyles:gangster5', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@gangster@var_i')
end)
RegisterNetEvent('prp-walkstyles:heels', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_f@heels@c')
end)
RegisterNetEvent('prp-walkstyles:heels2', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_f@heels@d')
end)
RegisterNetEvent('prp-walkstyles:hiking', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@hiking')
end)
RegisterNetEvent('prp-walkstyles:muscle', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@muscle@a')
end)
RegisterNetEvent('prp-walkstyles:quick', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@quick')
end)
RegisterNetEvent('prp-walkstyles:wide', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@bag')
end)
RegisterNetEvent('prp-walkstyles:scared', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_f@scared')
end)
RegisterNetEvent('prp-walkstyles:brave', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@brave')
end)
RegisterNetEvent('prp-walkstyles:tipsy', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@drunk@slightlydrunk')
end)
RegisterNetEvent('prp-walkstyles:injured', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@injured')
end)
RegisterNetEvent('prp-walkstyles:tough', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@tough_guy@')
end)
RegisterNetEvent('prp-walkstyles:sassy', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@sassy')
end)
RegisterNetEvent('prp-walkstyles:sad', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@sad@a')
end)
RegisterNetEvent('prp-walkstyles:posh', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@posh@')
end)
RegisterNetEvent('prp-walkstyles:alien', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@alien')
end)
RegisterNetEvent('prp-walkstyles:nonchalant', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@non_chalant')
end)
RegisterNetEvent('prp-walkstyles:hobo', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@hobo@a')
end)
RegisterNetEvent('prp-walkstyles:money', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@money')
end)
RegisterNetEvent('prp-walkstyles:swagger', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@swagger')
end)
RegisterNetEvent('prp-walkstyles:shady', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_m@shadyped@a')
end)
RegisterNetEvent('prp-walkstyles:maneater', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_f@maneater')
end)
RegisterNetEvent('prp-walkstyles:chichi', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'move_f@chichi')
end)
RegisterNetEvent('prp-walkstyles:default', function()
	TriggerEvent("prp-walkstyles:setwalkstyle", 'default')
end)
-- // Walkstyle Events \\ --

RegisterCommand('walking-style', function()
  OpenWalkMenu()
end)

RegisterCommand('fetch-style', function()
	TriggerServerEvent('prp-walkstyles:server:walkstyles', 'get')
end)

function OpenWalkMenu()
	local MenuOptions = {
		{
			header = "PRP Walkstyles",
			isMenuHeader = true
		},
	}
	for k, v in pairs(Config.Styles) do
		

		MenuOptions[#MenuOptions+1] = {
			header = "<h8>"..v.label.."</h>",
			txt = "Choose",
			params = {
				event = "prp-walkstyles:setwalkstyle",
				args = v.value,
			}
		}
	end

	MenuOptions[#MenuOptions+1] = {
		header = "⬅ Close Menu",
		txt = "",
		params = {
			event = "prp-menu:closeMenu",
		}
	}
	exports['prp-menu']:openMenu(MenuOptions)
end

RegisterNetEvent('prp-walkstyles:setwalkstyle', function(anim)
	currentwalkingstyle = anim
	setwalkstyle(anim)
	TriggerServerEvent('prp-walkstyles:server:walkstyles', 'update', anim)
end)

function setwalkstyle(anim)
	local playerped = PlayerPedId()

	if anim == 'default' then
		ResetPedMovementClipset(playerped)
		ResetPedWeaponMovementClipset(playerped)
		ResetPedStrafeClipset(playerped)
	else
		RequestAnimSet(anim)
		while not HasAnimSetLoaded(anim) do Citizen.Wait(0) end
		SetPedMovementClipset(playerped, anim)
		ResetPedWeaponMovementClipset(playerped)
		ResetPedStrafeClipset(playerped)
	end
end

RegisterNetEvent('prp-walkstyles:client:walkstyles', function(walkstyle)
	setwalkstyle(walkstyle)
	currentwalkingstyle = walkstyle
end)
