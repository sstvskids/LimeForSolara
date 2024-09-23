local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/EternalForRoblox/main/Library.lua"))()
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
--local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
local CurrentCamera = game.Workspace.CurrentCamera
--[[
local Rayparams = RaycastParams.new()
Rayparams.FilterType = Enum.RaycastFilterType.Blacklist;
--]]

local Main = Library:CreateMain()
local Tabs = {
	Combat = Main:CreateTab("Combat", false),
	Movement = Main:CreateTab("Movement", false),
	Player = Main:CreateTab("Player", false),
	Render = Main:CreateTab("Render", false),
	Exploit = Main:CreateTab("Exploit", false),
	Misc = Main:CreateTab("Misc", true)
}

function IsAlive(entity)
	return entity and entity:FindFirstChildOfClass("Humanoid") and entity:FindFirstChildOfClass("Humanoid").Health > 0
end

function GetNearestEntity(MaxDist, EntityModes, EntityGetModes, EntitySort, EntityTeamCheck)
	local Entity, MinDist, Distance

	for _, entities in pairs(game.Workspace:GetChildren()) do
		if entities:IsA("Model") and entities.Name ~= LocalPlayer.Name then
			if IsAlive(entities) then
				if EntityModes == "Players" then
					for _, player in pairs(Players:GetPlayers()) do
						if player.Name == entities.Name then
							if not EntityTeamCheck or player.Team ~= LocalPlayer.Team then
								Distance = (entities:FindFirstChild("HumanoidRootPart").Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
							end
						end
					end
				elseif EntityModes == "Models" then
					Distance = (entities:FindFirstChild("HumanoidRootPart").Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
				end
				
				if Distance ~= nil then
					if EntityGetModes == "Distance" then
						local Humanoid = entities:FindFirstChild("Humanoid")
						if EntitySort == "Nearest" then
							if Distance <= MaxDist and (not MinDist or Distance < MinDist) then
								MinDist = Distance
								Entity = entities
							end
						elseif EntitySort == "Furthest" then
							if Distance <= MaxDist and (not MinDist or Distance > MinDist) then
								MinDist = Distance
								Entity = entities
							end
						elseif EntitySort == "Health" then
							if Humanoid and Distance <= MaxDist and (not MinDist or Humanoid.Health < MinDist) then
								MinDist = Humanoid.Health
								Entity = entities
							end
						elseif EntitySort == "Threat" then
							if Humanoid and Distance <= MaxDist and (not MinDist or Humanoid.Health > MinDist) then
								MinDist = Humanoid.Health
								Entity = entities
							end
						end
					elseif EntityGetModes == "Mouse" then
						local ScreenPoint = workspace.CurrentCamera:WorldToScreenPoint(entities:FindFirstChild("HumanoidRootPart").Position)
						Distance = (Vector2.new(ScreenPoint.X, ScreenPoint.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
						if Distance <= MaxDist and (not MinDist or Distance < MinDist) then
							MinDist = Distance
							Entity = entities
						end
					end
				end
			end
		end
	end
	return Entity
end


spawn(function()
	local Distance, Mode1, Mode2, Mode3, Mode4, Hold, Check = nil, nil, nil, nil, nil, nil
	local Direction = Vector3.new(0, 0, 0)
	local Connections
	local AimAssist = Tabs.Combat:CreateToggle({
		Name = "AimAssist",
		Callback = function(callback)
			if callback then
				Connections = RunService.Heartbeat:Connect(function()
					local Entities = GetNearestEntity(Distance, Mode1, Mode2, Mode3, Check)
					if Entities then
						if Mode4 == "Head" then
							Direction = (Entities:FindFirstChild("Head").Position - CurrentCamera.CFrame.Position).unit
						elseif Mode4 == "Torso" then
							Direction = (Entities:FindFirstChild("HumanoidRootPart").Position - CurrentCamera.CFrame.Position).unit
						end
						if Hold then
							if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
								CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.Position + Direction)
							end
						else
							CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.Position + Direction)
						end
					end
				end)
			else
				if Connections then
					Connections:Disconnect()
				end
			end
		end
	})
	local CustomDistance = AimAssist:CreateSlider({
		Name = "Distance",
		Min = 0,
		Max = 200,
		Default = 85,
		Callback = function(callback)
			if callback then
				Distance = callback
			end
		end
	})
	local CustomMode1 = AimAssist:CreateDropdown({
		Name = "Mode1Options",
		List = {"Players", "Models"},
		Default = "Players",
		Callback = function(callback)
			if callback then
				Mode1 = callback
			end
		end
	})
	local CustomMode2 = AimAssist:CreateDropdown({
		Name = "Mode2Options",
		List = {"Distance", "Mouse"},
		Default = "Distance",
		Callback = function(callback)
			if callback then
				Mode2 = callback
			end
		end
	})
	local CustomMode3 = AimAssist:CreateDropdown({
		Name = "Mode3Options",
		List = {"Nearest", "Furthest", "Health", "Threat"},
		Default = "Nearest",
		Callback = function(callback)
			if callback then
				Mode3 = callback
			end
		end
	})
	local CustomMode4 = AimAssist:CreateDropdown({
		Name = "Mode3Options",
		List = {"Head", "Torso"},
		Default = "Torso",
		Callback = function(callback)
			if callback then
				Mode4 = callback
			end
		end
	})
	local HoldModes = AimAssist:CreateMiniToggle({
		Name = "Hold",
		Callback = function(callback)
			if callback then
				Hold = callback
			end
		end
	})
	local CheckModes = AimAssist:CreateMiniToggle({
		Name = "Teams",
		Callback = function(callback)
			if callback then
				Check = callback
			end
		end
	})
end)

spawn(function()
	local Enabled, CPS, Hold = false, nil, false
	local AutoClicker = Tabs.Combat:CreateToggle({
		Name = "AutoClicker",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					wait(1 / CPS)
					local Tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
					if Tool then
						if Hold then
							if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
								Tool:Activate()
							end
						else
							Tool:Activate()
						end
					end
				until not Enabled
			end
		end
	})
	local CustomCPS = AutoClicker:CreateSlider({
		Name = "CPS",
		Min = 0,
		Max = 100,
		Default = 50,
		Callback = function(callback)
			if callback then
				CPS = callback
			end
		end
	})
	local HoldModes = AutoClicker:CreateMiniToggle({
		Name = "Hold",
		Callback = function(callback)
			if callback then
				Hold = callback
			end
		end
	})
end)
