local Players = game:GetService("Players")
local MainFolder, ConfigFolder = "Lime", "Lime/configs"

if not isfolder(MainFolder) then makefolder(MainFolder) end
if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

if isfolder(MainFolder) and isfolder(ConfigFolder) then
	if game.PlaceId == 11630038968 or game.PlaceId == 10810646982 then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/LimeForRoblox/refs/heads/main/BridgeDuel.lua"))()
	else
		loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/LimeForRoblox/refs/heads/main/Universal.lua"))()
	end
end
