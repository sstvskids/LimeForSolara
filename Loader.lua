local cloneref = cloneref or function(obj) return obj end
local shared = shared or getgenv()

for _, v in {'Lime', 'Lime/configs'} do
	if not isfolder(v) then
		makefolder(v)
	end
end

-- require / debug checks
if ((game.PlaceId == 11630038968 or game.PlaceId == 12011959048 or game.PlaceId == 14191889582 or game.PlaceId == 14662411059) and string.find(({identifyexecutor()})[1], 'Xeno') or not (debug.getupvalue or debug.getconstants or hookfunction)) then
	shared.badexecs = true
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/sstvskids/LimeForSolara/refs/heads/main/BridgeDuel.lua"))()
end

if require and (game.PlaceId == 11630038968 or game.PlaceId == 12011959048 or game.PlaceId == 14191889582 or game.PlaceId == 14662411059) then
	local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
	local suc, res = pcall(require, replicatedStorage.Blink.Client)
	if suc == false then
		shared.badexecs = true
		return loadstring(game:HttpGet("https://raw.githubusercontent.com/sstvskids/LimeForSolara/refs/heads/main/BridgeDuel.lua"))()
	end
elseif not require then
	shared.badexecs = true
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/sstvskids/LimeForSolara/refs/heads/main/BridgeDuel.lua"))()
end

if not shared.badexecs == true and (game.PlaceId == 11630038968 or game.PlaceId == 12011959048 or game.PlaceId == 14191889582 or game.PlaceId == 14662411059) then
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/LimeForRoblox/refs/heads/main/BridgeDuel.lua"))()
else
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/LimeForRoblox/refs/heads/main/Universal.lua"))()
end
