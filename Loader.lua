local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local MainFolder, ConfigFolder, LogsFolder = "Eternal", "Eternal/configs", "Eternal/logs"

local Library = "https://raw.githubusercontent.com/AfgMS/EternalForRoblox/main/Library.lua"
local BridgeDuels = "https://raw.githubusercontent.com/AfgMS/EternalForRoblox/main/BridgeDuels.lua"
local Universal = "https://raw.githubusercontent.com/AfgMS/EternalForRoblox/main/Universal.lua"

if not isfolder(MainFolder) then makefolder(MainFolder) end
if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
if not isfolder(LogsFolder) then makefolder(LogsFolder) end

if isfolder(MainFolder) and isfolder(ConfigFolder) and isfolder(LogsFolder) then
	if game.PlaceId == 6872274481 or game.PlaceId == 8560631822 or game.PlaceId == 8444591321 then
		writefile(LogsFolder .. "/support_issue_" .. game.PlaceId .. ".txt", "This game is not supported by Eternal")
	elseif game.PlaceId == 11630038968 then
		loadstring(game:HttpGet(BridgeDuels))()
	else
		loadstring(game:HttpGet(Universal))()
    writefile(LogsFolder .. "/comingsoon_" .. game.PlaceId .. ".txt", "Coming soon...")
	end
end
