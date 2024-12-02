repeat wait() until game:IsLoaded()
-local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/LimeForRoblox/refs/heads/main/Library.lua"))()
local Service = {
	UserInputService = game:GetService("UserInputService"),
	TweenService = game:GetService("TweenService"),
	SoundService = game:GetService("SoundService"),
	RunService = game:GetService("RunService"),
	Lighting = game:GetService("Lighting"),
	Players = game:GetService("Players")
}

local LocalPlayer = Service.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local OldTorsoC0 = LocalPlayer.Character.LowerTorso:FindFirstChild("Root").C0.p
local OldC0 = nil
local Main = Library:CreateMain()
local Tabs = {
	Combat = Main:CreateTab("Combat", 138185990548352, Color3.fromRGB(255, 85, 127)),
	Exploit = Main:CreateTab("Exploit", 71954798465945, Color3.fromRGB(0, 255, 187)),
	Move = Main:CreateTab("Move", 91366694317593, Color3.fromRGB(82, 246, 255)),
	Player = Main:CreateTab("Player", 103157697311305, Color3.fromRGB(255, 255, 127)),
	Visual = Main:CreateTab("Visual", 118420030502964, Color3.fromRGB(170, 85, 255)),
	World = Main:CreateTab("World", 76313147188124, Color3.fromRGB(255, 170, 0)),
}
--1.20000005, -0.5, 0, 0.036033392, -0.746451914, 0.664462984, -0.353553385, 0.612372398, 0.707106769, -0.934720039, -0.26040262, -0.241844743 blocking c1
--game:GetService("Players").LocalPlayer.PlayerGui.MainGui["BRIDGE DUEL"]
--game:GetService("Players").LocalPlayer.PlayerGui.MainGui["BRIDGE DUEL"].Title
local function IsAlive(v)
	return v and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid").Health > 0
end

local function CheckWall(v)
	local Raycast, Result = nil, nil

	local Direction = (v:FindFirstChild("HumanoidRootPart").Position - LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Unit
	local Distance = (v:FindFirstChild("HumanoidRootPart").Position - LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
	if Direction and Distance then
		Raycast = RaycastParams.new()
		Raycast.FilterDescendantsInstances = {LocalPlayer.Character}
		Raycast.FilterType = Enum.RaycastFilterType.Exclude
		Result = workspace:Raycast(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position, Direction * Distance, Raycast)
		if Result then
			if not v:IsAncestorOf(Result.Instance) then
				return false
			end
		end
	end
	return true
end

local function GetNearestEntity(MaxDist, EntityCheck, EntitySort, EntityTeam, EntityWall)
	local Entity, MinDist, Distances

	for _, entities in pairs(game.Workspace:GetChildren()) do
		if entities:IsA("Model") and entities.Name ~= LocalPlayer.Name then
			if IsAlive(entities) then
				if not EntityCheck then
					if not EntityWall or CheckWall(entities) then
						Distances = (entities:FindFirstChild("HumanoidRootPart").Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
					end
				else
					for _, player in pairs(Service.Players:GetPlayers()) do
						if player.Name == entities.Name then
							if not EntityTeam or player.Team ~= LocalPlayer.Team then
								if not EntityWall or CheckWall(entities) then
									Distances = (entities:FindFirstChild("HumanoidRootPart").Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
								end
							end
						end
					end
				end

				if Distances ~= nil then
					if EntitySort == "Distance" then
						if Distances <= MaxDist and (not MinDist or Distances < MinDist) then
							MinDist = Distances
							Entity = entities
						end
					elseif EntitySort == "Furthest" then
						if Distances <= MaxDist and (not MinDist or Distances > MinDist) then
							MinDist = Distances
							Entity = entities
						end
					elseif EntitySort == "Health" then
						if entities:FindFirstChild("Humanoid") and Distances <= MaxDist and (not MinDist or entities:FindFirstChild("Humanoid").Health < MinDist) then
							MinDist = entities:FindFirstChild("Humanoid").Health
							Entity = entities
						end
					elseif EntitySort == "Threat" then
						if entities:FindFirstChild("Humanoid") and Distances <= MaxDist and (not MinDist or entities:FindFirstChild("Humanoid").Health > MinDist) then
							MinDist = entities:FindFirstChild("Humanoid").Health
							Entity = entities
						end
					end	
				end
			end
		end
	end
	return Entity
end

local function GetITemC0()
	local ToolC0 = nil
	local Viewmodel = game.Workspace.CurrentCamera:GetChildren()[1]
	if OldC0 == nil then
		OldC0 = Viewmodel:FindFirstChildWhichIsA("Model"):WaitForChild("Handle"):FindFirstChild("MainPart").C0
	end

	if Viewmodel then
		for i, v in pairs(Viewmodel:GetChildren()) do
			if v:IsA("Model") then
				for i, z in pairs(v:GetChildren()) do
					if z:IsA("Part") and z.Name == "Handle" then
						for i, x in pairs(z:GetChildren()) do
							if x:IsA("Motor6D") and x.Name == "MainPart" then
								ToolC0 = x
							end
						end
					end
				end
			end
		end
	end
	return ToolC0
end

local function AnimateC0(anim)
	local Tool = GetITemC0()
	if Tool then
		local Tween = Service.TweenService:Create(Tool, TweenInfo.new(anim.Time), {C0 = OldC0 * anim.CFrame})
		if Tween then
			Tween:Play()
			Tween.Completed:Wait()
		end
	end
end

local function PlaySound(id)
	local Sound = Instance.new("Sound")
	Sound.SoundId = "rbxassetid://" .. id
	Sound.Parent = game:GetService("SoundService")
	Sound:Play()
	repeat
		wait()
	until not Sound.Playing
	Sound:Destroy()
end

local function GetStaff()
	for _, v in pairs(Service.Players:GetPlayers()) do
		if v.UserId == 913502943 or v.UserId == 562994998 or v.UserId == 2856891486 then
			return v
		end
	end
end

local function GetTool(name)
	local TooResults
	for _,tool in pairs(LocalPlayer.Backpack:GetChildren()) do
		if tool:IsA("Tool") and tool.Name:match(name) then
			TooResults = tool
		end
	end
	return TooResults
end

local function CheckTool(name)
	local TooResults
	for _,tool in pairs(LocalPlayer.Character:GetChildren()) do
		if tool:IsA("Tool") and tool.Name:match(name) then
			TooResults = tool
		end
	end
	return TooResults
end

local function GetPlace(pos)
	local NewPos = Vector3.new(math.floor((pos.X / 3) + 0.5) * 3, math.floor((pos.Y / 3) + 0.5) * 3, math.floor((pos.Z / 3) + 0.5) * 3)
	return NewPos
end

local AntiBotGlobal = false
spawn(function()
	local AntiBot = Tabs.Combat:CreateToggle({
		Name = "Anti Bot",
		Enabled = true,
		Callback = function(callback)
			if callback then
				AntiBotGlobal = true
			else
				AntiBotGlobal = false
			end
		end
	})
	local AntiBotMode = AntiBot:CreateDropdown({
		Name = "Anti Bot Type",
		List = {"Workspace"},
		Default = "Workspace",
		Callback = function(callback)
		end
	})
end)

local IsAutoClickerClicking = nil
spawn(function()
	local MaxCPS, MinCPS, Randomize = nil, nil, false
	local CPS = nil
	local Enabled = false

	local AutoClicker = Tabs.Combat:CreateToggle({
		Name = "AutoClicker",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					if Randomize then
						CPS = math.random(MinCPS, MaxCPS)
					else
						CPS = MaxCPS
					end
					wait(1 / CPS)
					local Tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
					if Service.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
						IsAutoClickerClicking = true
						if Tool then
							Tool:Activate()
						end
					else
						IsAutoClickerClicking = false
					end
				until not Enabled
			end
		end
	})
	local AutoClickerRandomize = AutoClicker:CreateMiniToggle({
		Name = "Randomize",
		Callback = function(callback)
			if callback then
				Randomize = true
			else
				Randomize = false
			end
		end
	})
	local AutoClickerMin = AutoClicker:CreateSlider({
		Name = "Max",
		Min = 0,
		Max = 20,
		Default = 10,
		Callback = function(callback)
			if callback then
				MaxCPS = callback
			end
		end
	})
	local AutoClickerMax = AutoClicker:CreateSlider({
		Name = "Min",
		Min = 0,
		Max = 20,
		Default = 8,
		Callback = function(callback)
			if callback then
				MinCPS = callback
			end
		end
	})
end)
--[[
spawn(function()
	local MinHealth = nil
	local IsEated, EatCount = 0, 0
	local Loop = nil
	local AutoGapple = Tabs.Combat:CreateToggle({
		Name = "Auto Gapple",
		Callback = function(callback)
			if callback then
				Loop = Service.RunService.RenderStepped:Connect(function()
					if LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health < MinHealth then
						local Gapple = CheckTool("GoldApple")
						if Gapple then
							if IsEated == 0 and EatCount == 0 then
								--Gapple:Activate()
								Gapple:WaitForChild("__comm__"):WaitForChild("RF"):FindFirstChild("Eat"):InvokeServer()
								IsEated = 1
								EatCount = 1
							else
								repeat
									wait()
								until IsEated == 0 and EatCount == 0
							end
						else
							local Gapple2 = GetTool("GoldApple")
							if Gapple2 then
								LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):EquipTool(Gapple2)
							end
						end
					else
						if IsEated == 1 and EatCount == 1 then
							repeat
								wait()
							until LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health > MinHealth
							IsEated = 0
							EatCount = 0
						end
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
			end
		end
	})
	local AutoGappleHealth = AutoGapple:CreateSlider({
		Name = "Health",
		Min = 0,
		Max = 100,
		Default = 50,
		Callback = function(callback)
			MinHealth = callback
		end
	})
end)
--]]
local HitCritical = false
spawn(function()
	local Criticals = Tabs.Combat:CreateToggle({
		Name = "Criticals",
		Callback = function(callback)
			if callback then
				HitCritical = true
			else
				HitCritical = false
			end
		end
	})
	local CriticalsMode = Criticals:CreateDropdown({
		Name = "Crit Type",
		List = {"Packet"},
		Default = "Packet",
		Callback = function(callback)
		end
	})
end)

local ScaffoldRotation, IsScaffoldEnabled = nil, nil
local KillAuraSortMode, KillAuraTeamCheck, KillAuraBlock, IsKillAuraEnabled, KillAuraTarget, KillAuraWallCheck = nil, nil, nil, nil, nil, true
spawn(function()
	local Loop, Range, Swing = nil, nil, false
	local Sword, RotationMode = nil, nil

	local KillAura = Tabs.Combat:CreateToggle({
		Name = "Kill Aura",
		Callback = function(callback)
			if callback then
				IsKillAuraEnabled = true
				Loop = Service.RunService.RenderStepped:Connect(function() 
					if IsAlive(LocalPlayer.Character) then
						local Entity = GetNearestEntity(Range, AntiBotGlobal, KillAuraSortMode, KillAuraTeamCheck, KillAuraWallCheck)
						if Entity then
							local Direction = (Vector3.new(Entity:FindFirstChild("HumanoidRootPart").Position.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y, Entity:FindFirstChild("HumanoidRootPart").Position.Z) - LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Unit
							local LookCFrame = (CFrame.new(Vector3.zero, (LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame):VectorToObjectSpace(Direction)))
							if not IsScaffoldEnabled and ScaffoldRotation ~= nil then
								if LocalPlayer.Character:WaitForChild("Head"):FindFirstChild("Neck") and LocalPlayer.Character:WaitForChild("LowerTorso"):FindFirstChild("Root") then
									if RotationMode == "Normal" then
										LocalPlayer.Character.LowerTorso:FindFirstChild("Root").C0 = LookCFrame + OldTorsoC0
									elseif RotationMode == "None" then
										LocalPlayer.Character.LowerTorso:FindFirstChild("Root").C0 = CFrame.new(OldTorsoC0)
									end
								end
							else
								repeat
									task.wait()
								until IsScaffoldEnabled and ScaffoldRotation == nil
							end
							KillAuraTarget = Entity
							Sword = CheckTool("Sword")
							if Sword then
								if KillAuraBlock == "Packet" then
									local args = {
										[1] = true,
										[2] = Sword.Name
									}
									game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
								elseif KillAuraBlock == "None" then
									local args = {
										[1] = false,
										[2] = Sword.Name
									}
									game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
								end
								if Swing and KillAuraBlock == "None" then
									Sword:Activate()
								end
								local args = {
									[1] = Entity,
									[2] = HitCritical,
									[3] = Sword.Name
								}
								game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("AttackPlayerWithSword"):InvokeServer(unpack(args))
							else
								if KillAuraBlock == "Packet" then
									local args = {
										[1] = false,
										[2] = Sword.Name
									}
									game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
								end
							end
						else
							if KillAuraBlock == "Packet" then
								local args = {
									[1] = false,
									[2] = Sword.Name
								}
								game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
							end
							LocalPlayer.Character.LowerTorso:FindFirstChild("Root").C0 = CFrame.new(OldTorsoC0)
						end
					else
						repeat
							task.wait()
						until IsAlive(LocalPlayer.Character)
					end
				end)
			else
				IsKillAuraEnabled = false
				if Loop ~= nil then
					Loop:Disconnect()
				end
				if KillAuraBlock == "Packet" then
					local args = {
						[1] = false,
						[2] = Sword.Name
					}
					game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
				end
				LocalPlayer.Character.LowerTorso:FindFirstChild("Root").C0 = CFrame.new(OldTorsoC0)
			end
		end
	})
	local KillAuraSort = KillAura:CreateDropdown({
		Name = "Sort Mode",
		List = {"Distance", "Furthest", "Health", "Threat"},
		Default = "Distance",
		Callback = function(callback)
			if callback then
				KillAuraSortMode = callback
			end
		end
	})
	local KillAuraRotation = KillAura:CreateDropdown({
		Name = "KillAura Rotations",
		List = {"Normal", "None"},
		Default = "None",
		Callback = function(callback)
			RotationMode = callback
		end
	})
	local KillAuraAutoBlock = KillAura:CreateDropdown({
		Name = "Auto Block",
		List = {"Packet", "None"},
		Default = "None",
		Callback = function(callback)
			if callback then
				KillAuraBlock = callback
			end
		end
	})
	local KillAuraRange = KillAura:CreateSlider({
		Name = "Range",
		Min = 0,
		Max = 20,
		Default = 20,
		Callback = function(callback)
			if callback then
				Range = callback
			end
		end
	})
	local KillAuraCheckForWall = KillAura:CreateMiniToggle({
		Name = "Through Walls",
		Callback = function(callback)
			if callback then
				KillAuraWallCheck = false
			else
				KillAuraWallCheck = true
			end
		end
	})
	local KillAuraSwing = KillAura:CreateMiniToggle({
		Name = "Swing",
		Callback = function(callback)
			if callback then
				Swing = true
			else
				Swing = false
			end
		end
	})
	local KillAuraTeam = KillAura:CreateMiniToggle({
		Name = "Team",
		Callback = function(callback)
			if callback then
				KillAuraTeamCheck = true
			else
				KillAuraTeamCheck = false
			end
		end
	})
end)

--[[
spawn(function()
	local Loop, TPRange, OldCameraType, OldCameraSubject = nil, nil, game.Workspace.CurrentCamera.CameraType, game.Workspace.CurrentCamera.CameraSubject 
	local Sword = nil
	
	local TeleportAura = Tabs.Combat:CreateToggle({
		Name = "Teleport Aura",
		Callback = function(callback)
			if callback then
				Loop = Service.RunService.Heartbeat:Connect(function()
					if IsKillAuraEnabled then
						if IsAlive(LocalPlayer.Character) then
							local Target = GetNearestEntity(TPRange, AntiBotGlobal, KillAuraSortMode, KillAuraTeamCheck)
							if Target and Target.Character:FindFirstChild("HumanoidRootPart") and Target.Character.HumanoidRootPart.Position.Y < -16 then
								Sword = CheckTool("Sword")
								if Sword then
									game.Workspace.CurrentCamera.CameraSubject = Target.Character:FindFirstChildOfClass("Humanoid")
									game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Watch
									if KillAuraBlock == "None" then
										Sword:Activate()
									end
									local TargetPosition = Target.Character:FindFirstChild("HumanoidRootPart")
									if TargetPosition then
										local InfiniteTween = Service.TweenService:Create(LocalPlayer.Character:WaitForChild("HumanoidRootPart"), TweenInfo.new(0.08), {CFrame = CFrame.new(TargetPosition.Position.X, TargetPosition.Position.Y - 6, TargetPosition.Position.Z)})
										InfiniteTween:Play()
									end
								else
									game.Workspace.CurrentCamera.CameraSubject = OldCameraSubject
									game.Workspace.CurrentCamera.CameraType = OldCameraType
								end
							else
								game.Workspace.CurrentCamera.CameraSubject = OldCameraSubject
								game.Workspace.CurrentCamera.CameraType = OldCameraType
								repeat
									task.wait()
								until IsAlive(LocalPlayer.Character)
							end
						end
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				game.Workspace.CurrentCamera.CameraSubject = OldCameraSubject
				game.Workspace.CurrentCamera.CameraType = OldCameraType
			end
		end
	})
	local TeleportAuraRange = TeleportAura:CreateSlider({
		Name = "Range",
		Min = 0,
		Max = 40,
		Default = 40,
		Callback = function(callback)
			if callback then
				TPRange = callback
			end
		end
	})
end)
--]]

spawn(function()
	local RemotePath, OldRemote = nil, nil
	local Velocity = Tabs.Combat:CreateToggle({
		Name = "Velocity",
		Callback = function(callback)
			if callback then
				RemotePath = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("CombatService"):FindFirstChild("RE")
				if RemotePath then
					OldRemote = RemotePath:FindFirstChild("KnockBackApplied"):Clone()
					OldRemote.Parent = game.Workspace
					RemotePath:FindFirstChild("KnockBackApplied"):Destroy()
				end
			else
				if RemotePath and not RemotePath:FindFirstChild("KnockBackApplied")	and OldRemote ~= nil then
					OldRemote.Parent = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("CombatService"):FindFirstChild("RE")
				end
			end
		end
	})
	local VelocityMode = Velocity:CreateDropdown({
		Name = "Velocity Mode",
		List = {"Cancel"},
		Default = "Cancel",
		Callback = function(Callback)
		end
	})
end)

spawn(function()
	local Loop, Reported, Notify = nil, {}, false

	local AutoReport = Tabs.Exploit:CreateToggle({
		Name = "Auto Report",
		Callback = function(callback)
			if callback then
				Loop = Service.RunService.Heartbeat:Connect(function()
					for i, v in pairs(Service.Players:GetPlayers()) do
						if v and v ~= LocalPlayer and not table.find(Reported, v.Name) then
							table.insert(Reported, v.Name)
							local args = {
								[1] = v.Name
							}
							game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("NetworkService"):WaitForChild("RF"):FindFirstChild("ReportPlayer"):InvokeServer(unpack(args))
							if Notify then
								game:GetService("StarterGui"):SetCore("SendNotification", { 
									Title = "Lime | Auto Report",
									Text = "Reported " .. v.Name,
									Icon = Service.Players:GetUserThumbnailAsync(v.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size60x60),
									Duration = 5,
								})
							end
						end
					end
				end)
			else
				if Loop then
					Loop:Disconnect()
				end
			end
		end
	})
	local AutoReportNotify = AutoReport:CreateMiniToggle({
		Name = "Notify",
		Callback = function(callback)
			if callback then
				Notify = true
			else
				Notify = false
			end
		end
	})
end)

spawn(function()
	local Loop, AutoLeave, IsStaff = nil, false, false

	local Detector = Tabs.Exploit:CreateToggle({
		Name = "Detector",
		Enabled = true,
		Callback = function(callback)
			if callback then
				Loop = Service.RunService.Heartbeat:Connect(function()
					local Staff = GetStaff()
					if Staff and not IsStaff then
						IsStaff = true
						PlaySound(4809574295)
						game:GetService("StarterGui"):SetCore("SendNotification", { 
							Title = "Lime | Staff",
							Text = Staff.Name .. " " .. Staff.DisplayName .. " " .. Staff.UserId,
							Icon = Service.Players:GetUserThumbnailAsync(Staff.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size60x60),
							Duration = 15,
						})

						if AutoLeave then
							game:GetService("StarterGui"):SetCore("SendNotification", { 
								Title = "Lime | Staff",
								Text = "Leaving the game..",
								Duration = 5,
							})
							wait(2)
							LocalPlayer:Kick("Leaved the game..")
						end
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				IsStaff = false
			end
		end
	})
	local DetectorAutoLeave = Detector:CreateMiniToggle({
		Name = "Auto Leave",
		Callback = function(callback)
			if callback then
				AutoLeave = true
			else
				AutoLeave = false
			end
		end
	})
end)

--[[
spawn(function()
	local IsEnabled, Shooted = false, false
	local Damage = Tabs.Exploit:CreateToggle({
		Name = "Damage",
		AutoDisable = true,
		Callback = function(callback)
			if callback then
				IsEnabled = true
				local Bow = CheckTool("Bow")
				if Bow then
					if IsEnabled and not Shooted then
						local args = {
							[1] = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position + Vector3.new(0, 3, 0),
							[2] = 0.10
						}
						Bow:WaitForChild("__comm__"):WaitForChild("RF"):FindFirstChild("Fire"):InvokeServer(unpack(args))
						task.wait(0.25)
						Shooted = true
					end
				else
					local Bow1 = GetTool("Bow")
					if Bow1 then
						LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):EquipTool(Bow1)
					end
				end
			else
				if Shooted then
					IsEnabled = false
					Shooted = false
				end
			end
		end
	})
end)

spawn(function()
	local Loop, SelectedMode = nil, nil
	local Disabler = Tabs.Exploit:CreateToggle({
		Name = "Disabler",
		Callback = function(callback)
			if callback then
				Loop = Service.RunService.Heartbeat:Connect(function()
					if SelectedMode == "Playground" then
						if game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):FindFirstChild("PlaygroundService") then
							local args = {
								[1] = false
							}

							game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlaygroundService"):WaitForChild("RF"):WaitForChild("SetAntiCheat"):InvokeServer(unpack(args))
						end
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				local args = {
					[1] = true
				}

				game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlaygroundService"):WaitForChild("RF"):WaitForChild("SetAntiCheat"):InvokeServer(unpack(args))
			end
		end
	})
	local DisablerMode = Disabler:CreateDropdown({
		Name = "Disabler Modes",
		List = {"Playground"},
		Default = "Playground",
		Callback = function(callback)
			if callback then
				SelectedMode = callback
			end
		end
	})
end)
--]]
spawn(function()
	local HumanoidRootPartY = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y
	local Loop, FlightSpeed, SelectedMode, YPos, IsEnabled = nil, nil, nil, 0, false
	local Boost, Start, OldBoost = false, nil, nil
	local OldGravity, Velocity = game.Workspace.Gravity, nil
	--local FireCount, Start2 = 1, nil

	if Service.UserInputService.TouchEnabled and not Service.UserInputService.KeyboardEnabled and not Service.UserInputService.MouseEnabled then
		Service.UserInputService.JumpRequest:Connect(function()
			YPos = YPos + 3
		end)
	elseif not Service.UserInputService.TouchEnabled and Service.UserInputService.KeyboardEnabled and Service.UserInputService.MouseEnabled then
		Service.UserInputService.InputBegan:Connect(function(Input, IsTyping)
			if IsTyping then return end
			if Input.KeyCode == Enum.KeyCode.LeftShift or Input.KeyCode == Enum.KeyCode.Q then
				YPos = YPos - 3
			elseif Input.KeyCode == Enum.KeyCode.Space then
				YPos = YPos + 3
			end
		end)
	end
	
	local Flight = Tabs.Move:CreateToggle({
		Name = "Flight",
		Callback = function(callback)
			if callback then
				IsEnabled = true
				YPos = 0
				HumanoidRootPartY = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y
				if Boost ~= false then
					OldBoost = Boost
				end
				Loop = Service.RunService.Heartbeat:Connect(function()
					if IsAlive(LocalPlayer.Character) then
						if Boost then
							if Start == nil then
								Start = tick()
							end
							if (tick() - Start) < 2 then
								Velocity = LocalPlayer.Character.Humanoid.MoveDirection * (FlightSpeed + 8)
							else
								Start = nil
								Boost = false
								Velocity = LocalPlayer.Character.Humanoid.MoveDirection * (FlightSpeed - 8)
							end
						else
							Velocity = LocalPlayer.Character.Humanoid.MoveDirection * FlightSpeed
						end
						--[[
						if Start2 == nil and FireCount == 1 then
							Start2 = tick()
						end
						if LocalPlayer.Character:FindFirstChildOfClass("Humanoid").FloorMaterial == Enum.Material.Air then
							if (tick() - Start2) > 4.5 then
								warn("Flight is no longer safe, and could lead to a ban")
								task.wait()
								Start2 = nil
							end
						else
							Start2 = nil
							repeat
								task.wait()
							until LocalPlayer.Character:FindFirstChildOfClass("Humanoid").FloorMaterial ~= Enum.Material.Air
							Start2 = tick()
						end
						--]]
						LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, Velocity.Z)
						if SelectedMode == "Float" then
							game.Workspace.Gravity = 0
							LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.X, HumanoidRootPartY + YPos, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Z) * LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.Rotation
						elseif SelectedMode == "Jump" then
							game.Workspace.Gravity = OldGravity
							LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
							LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Z)
							repeat
								task.wait()
							until LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):GetState() == Enum.HumanoidStateType.Freefall and LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y <= (HumanoidRootPartY - LocalPlayer.Character:FindFirstChildOfClass("Humanoid").HipHeight) + YPos
							if IsEnabled then
								LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
							end
						end
					else
						repeat
							task.wait()
						until IsAlive(LocalPlayer.Character)
					end
				end)
			else
				IsEnabled = false
				if Loop ~= nil then
					Loop:Disconnect()
				end
				if OldBoost then
					Boost = true
				end
				--FireCount, Start2 = 1, nil
				Velocity, Start = nil, nil
				game.Workspace.Gravity = OldGravity
				HumanoidRootPartY =  LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y
				LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
				LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Z)
			end
		end
	})
	local FlightMode = Flight:CreateDropdown({
		Name = "Flight Mode",
		List = {"Float", "Jump"},
		Default = "Float",
		Callback = function(callback)
			if callback then
				SelectedMode = callback
			end
		end
	})
	local FlightBoost = Flight:CreateMiniToggle({
		Name = "Boost",
		Callback = function(callback)
			if callback then
				Boost = true
			else
				Boost = false
			end
		end
	})
	local FlightSpeed = Flight:CreateSlider({
		Name = "Speed",
		Min = 0,
		Max = 100,
		Default = 28,
		Callback = function(callback)
			if callback then
				FlightSpeed = callback
			end
		end
	})
end)

spawn(function()
	local OldGravity, StartJump = game.Workspace.Gravity, nil
	local Height = nil
	local HighJump = Tabs.Move:CreateToggle({
		Name = "High Jump",
		AutoDisable = true,
		Callback = function(callback)
			if callback then
				game.Workspace.Gravity = 5
				if StartJump ==  nil then
					StartJump = tick()
				end
				if (tick() - StartJump) < 1.25 then
					LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.X, Height, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Z)
				end
			else
				StartJump = nil
				game.Workspace.Gravity = OldGravity
				LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Z)
			end
		end
	})
	local HighjumpHeigh = HighJump:CreateSlider({
		Name = "Height",
		Min = 0,
		Max = 200,
		Default = 75,
		Callback = function(callback)
			if callback then
				Height = callback
			end
		end
	})
end)

spawn(function()
	local OldGravity, IsEnabled, WaitToLand = game.Workspace.Gravity, false, false
	local LongJump = Tabs.Move:CreateToggle({
		Name = "Long Jump",
		AutoDisable = true,
		Callback = function(callback)
			if callback then
				IsEnabled = true
				if IsEnabled then
					game.Workspace.Gravity = 15
					game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
					wait(0.28)
					local Velocity = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 92
					LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, Velocity.Z)
				else
					repeat
						wait()
					until not IsEnabled
				end
			else
				if WaitToLand then
					task.wait(0.45)
					repeat
						wait()
					until LocalPlayer.Character:FindFirstChildOfClass("Humanoid").FloorMaterial ~= Enum.Material.Air
					game.Workspace.Gravity = OldGravity
					IsEnabled = false
				else
					task.wait(1)
					game.Workspace.Gravity = OldGravity
					IsEnabled = false
				end
			end
		end
	})
	local LongJumpMode = LongJump:CreateDropdown({
		Name = "Long Jump Mode",
		List = {"Gravity"},
		Default = "Gravity",
		Callback = function(callback)
		end
	})
	local LongJumpWaitLanding = LongJump:CreateMiniToggle({
		Name = "Wait For Landing",
		Callback = function(callback)
			if callback then
				WaitToLand = true
			else
				WaitToLand = false
			end
		end
	})
end)

--[[ OLD LONGJUMP SAVING
spawn(function()
	local OldGravity, StartJump = game.Workspace.Gravity, nil
	local SelectedMode = nil

	local LongJump = Tabs.Move:CreateToggle({
		Name = "Long Jump",
		AutoDisable = true,
		Callback = function(callback)
			if callback then
				game.Workspace.Gravity = 15
				LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.X, 15, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Z)
				repeat
					wait(0.15)
					if SelectedMode == "TP" then
						if StartJump ==  nil then
							StartJump = tick()
						end
						if (tick() - StartJump) < 1.25 then
							LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame + LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 3
						end
					elseif SelectedMode == "Gravity" then
						game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
						local Velocity = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 92
						wait(0.28)
						LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, Velocity.Z)
						if StartJump ==  nil then
							StartJump = tick()
						end
						if (tick() - StartJump) < 1.25 then
						end
					end
				until (tick() - StartJump) > 1.25
				StartJump = nil
				game.Workspace.Gravity = OldGravity
				LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
				LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Z)
			end
		end
	})
	local LongJumpMode = LongJump:CreateDropdown({
		Name = "Long Jump Mode",
		List = {"TP", "Gravity"},
		Default = "TP",
		Callback = function(callback)
			if callback then
				SelectedMode = callback
			end
		end
	})
end)
--]]
spawn(function()
	local Loop = nil

	local NoSlowDown = Tabs.Move:CreateToggle({
		Name = "No Slow Down",
		Callback = function(callback)
			if callback then
				Loop = LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):GetPropertyChangedSignal("WalkSpeed"):Connect(function()
					if IsAlive(LocalPlayer.Character) then
						if LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed ~= 16 then
							LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
						end
					else
						repeat
							task.wait()
						until IsAlive(LocalPlayer.Character)
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
			end
		end
	})
	local NoSlowMode = NoSlowDown:CreateDropdown({
		Name = "NoSlow Method",
		List = {"Spoof"},
		Default = "Spoof",
		Callback = function(callback)
		end
	})
end)

spawn(function()
	local Loop, VelocitySpeed, Velocity, JumpCount = nil, nil, nil, 0
	local SelectedMode, IsEnabled = nil, false
	local Speed = Tabs.Move:CreateToggle({
		Name = "Speed",
		Callback = function(callback)
			if callback then
				IsEnabled = true
				Loop = Service.RunService.Heartbeat:Connect(function()
					if IsAlive(LocalPlayer.Character) then
						Velocity = LocalPlayer.Character.Humanoid.MoveDirection * VelocitySpeed
						if SelectedMode == "Static" then
							JumpCount = 0
							LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, Velocity.Z)
						elseif SelectedMode == "Hop" then
							LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, Velocity.Z)
							Velocity = LocalPlayer.Character.Humanoid.MoveDirection * VelocitySpeed
							if JumpCount == 0 and IsEnabled then
								LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
								JumpCount = 1
							end
							repeat
								wait()
							until LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):GetState() == Enum.HumanoidStateType.Landed
							if IsEnabled then
								LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
							end
						end
					else
						repeat
							wait()
						until IsAlive(LocalPlayer.Character)
					end
				end)
			else
				IsEnabled = false
				JumpCount = 0
				if Loop ~= nil then
					Loop:Disconnect()
				end
				LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Z)
			end
		end
	})
	local SpeedModde = Speed:CreateDropdown({
		Name = "Speed Modes",
		List = {"Static", "Hop"},
		Default = "Static",
		Callback = function(callback)
			if callback then
				SelectedMode = callback
			end
		end
	})
	local SpeedSpeedValue = Speed:CreateSlider({
		Name = "Speeds",
		Min = 0,
		Max = 100, 
		Default = 28,
		Callback = function(callback)
			if callback then
				VelocitySpeed = callback
			end
		end
	})
end)

spawn(function()
	local OldTime, NewTime = Service.Lighting.ClockTime, nil
	local Loop = nil

	local Ambience = Tabs.Visual:CreateToggle({
		Name = "Ambience",
		Enabled = true,
		Callback = function(callback)
			if callback then
				Loop = Service.RunService.Heartbeat:Connect(function()
					Service.Lighting.ClockTime = NewTime
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				Service.Lighting.ClockTime = OldTime
			end
		end
	})
	local TimeChangerClock = Ambience:CreateSlider({
		Name = "Time",
		Min = 0,
		Max = 24,
		Default = 3,
		Callback = function(callback)
			if callback then
				NewTime = callback
			end
		end
	})
end)

spawn(function()
	local Loop, RenderSelf = nil, false
	local function Highlight(v)
		if not v:FindFirstChildWhichIsA("Highlight") then
			local highlight = Instance.new("Highlight")
			highlight.Parent = v
			highlight.FillTransparency = 1
			highlight.OutlineTransparency = 0.45
			highlight.OutlineColor = Color3.new(0.470588, 0.886275, 1)
		end
	end
	local function RemoveHighlight(v)
		if v:FindFirstChildWhichIsA("Highlight") then
			v:FindFirstChildWhichIsA("Highlight"):Destroy()
		end
	end
	local Chams = Tabs.Visual:CreateToggle({
		Name = "Chams",
		Callback = function(callback)
			if callback then
				Loop = Service.RunService.Heartbeat:Connect(function()
					for i, v in pairs(game.Workspace:GetChildren()) do
						if v:IsA("Model") and IsAlive(v) then
							if AntiBotGlobal then
								if Service.Players:FindFirstChild(v.Name) then
									if RenderSelf or v.Name ~= LocalPlayer.Name then
										Highlight(v)
									else
										RemoveHighlight(v)
									end
								else
									RemoveHighlight(v)
								end
							else
								if RenderSelf or v.Name ~= LocalPlayer.Name then
									Highlight(v)
								else
									RemoveHighlight(v)
								end
							end
						end
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				for i, v in pairs(game.Workspace:GetChildren()) do
					if v:IsA("Model") and IsAlive(v) then
						RemoveHighlight(v)
					end
				end
			end
		end
	})
	local ChamsRenderSelf = Chams:CreateMiniToggle({
		Name = "Render Self",
		Callback = function(callback)
			if callback then
				RenderSelf = true
			else
				RenderSelf = false
			end
		end
	})
end)

spawn(function()
	local ClickGui = Tabs.Visual:CreateToggle({
		Name = "ClickGUI",
		AutoEnable = true,
		Callback = function(callback)
		end
	}) 
	local UninjectLime = ClickGui:CreateMiniToggle({
		Name = "Uninject",
		AutoDisable = true,
		Callback = function(callback)
			if callback then
				if shared.Lime then
					shared.Lime.Uninject = true
				end
			else
				if shared.Lime then
					task.wait(1.85)
					shared.Lime.Uninject = false
				end
			end
		end
	})
end)

spawn(function()
	local Loop, RenderSelf = nil, false
	local function AddBox(v)
		if not v:FindFirstChildWhichIsA("BillboardGui") then
			local Frame, UIStoke = nil, nil
			local BillboardGui = Instance.new("BillboardGui")
			BillboardGui.Parent = v
			BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			BillboardGui.Active = true
			BillboardGui.AlwaysOnTop = true
			BillboardGui.LightInfluence = 1.000
			BillboardGui.Size = UDim2.new(4.5, 0, 6.5, 0)
			if BillboardGui then
				if not BillboardGui:FindFirstChildWhichIsA("Frame") then
					Frame = Instance.new("Frame")
					Frame.Parent = BillboardGui
					Frame.AnchorPoint = Vector2.new(0.5, 0.5)
					Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Frame.BackgroundTransparency = 1.000
					Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
					Frame.Size = UDim2.new(0.949999988, 0, 0.949999988, 0)
					if Frame then
						if not Frame:FindFirstChildWhichIsA("UIStroke") then
							UIStoke = Instance.new("UIStroke")
							UIStoke.Parent = Frame
							UIStoke.Color = Color3.fromRGB(128, 204, 255)
							UIStoke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
							UIStoke.LineJoinMode = Enum.LineJoinMode.Miter
							UIStoke.Thickness = 2
							UIStoke.Transparency = 0
						end
					end
				end
			end
		end
	end
	local function RemoveBox(v)
		if v:FindFirstChildWhichIsA("BillboardGui") then
			v:FindFirstChildWhichIsA("BillboardGui"):Destroy()
		end
	end
	local ESP = Tabs.Visual:CreateToggle({
		Name = "ESP",
		Callback = function(callback)
			if callback then
				Loop = Service.RunService.Heartbeat:Connect(function()
					for i, v in pairs(game.Workspace:GetChildren()) do
						if v:IsA("Model") and IsAlive(v) then
							if AntiBotGlobal then
								if Service.Players:FindFirstChild(v.Name) then
									if RenderSelf or v.Name ~= LocalPlayer.Name then
										AddBox(v)
									else
										RemoveBox(v)
									end
								else
									RemoveBox(v)
								end
							else
								if RenderSelf or v.Name ~= LocalPlayer.Name then
									AddBox(v)
								else
									RemoveBox(v)
								end
							end
						end
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				for i, v in pairs(game.Workspace:GetChildren()) do
					if v:IsA("Model") and IsAlive(v) then
						RemoveBox(v)
					end
				end
			end
		end
	})
	local ESPRenderSelf = ESP:CreateMiniToggle({
		Name = "Render Self",
		Callback = function(callback)
			if callback then
				RenderSelf = true
			else
				RenderSelf = false
			end
		end
	})
end)

spawn(function()
	local OldAmbience, OldBrightness = Service.Lighting.Ambient, Service.Lighting.Brightness
	local Loop = nil

	local Fullbright = Tabs.Visual:CreateToggle({
		Name = "Fullbright",
		Callback = function(callback)
			if callback then
				Loop = Service.RunService.Heartbeat:Connect(function()
					Service.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
					Service.Lighting.Brightness = 10
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				Service.Lighting.Ambient = OldAmbience
				Service.Lighting.Brightness = OldBrightness
			end
		end
	}) 
end)

spawn(function()
	local Loop, Arraylist, Watermark = nil, false, false
	local HUD = Tabs.Visual:CreateToggle({
		Name = "HUD",
		Enabled = true,
		Callback = function(callback)
			if callback then
				Loop = Service.RunService.Heartbeat:Connect(function()
					if shared.Lime and shared.Lime.Visual then
						shared.Lime.Visual.Hud = true
						if Arraylist then
							shared.Lime.Visual.Arraylist = true
						else
							shared.Lime.Visual.Arraylist = false
						end
						if Watermark then
							shared.Lime.Visual.Watermark = true
						else
							shared.Lime.Visual.Watermark = false
						end
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				if shared.Lime and shared.Lime.Visual then
					shared.Lime.Visual.Hud = false
					if Arraylist then
						shared.Lime.Visual.Arraylist = false
					end
					if Watermark then
						shared.Lime.Visual.Watermark = false
					end
				end
			end
		end
	})
	local HUDArraylist = HUD:CreateMiniToggle({
		Name = "Arraylist",
		Enabled = true,
		Callback = function(callback)
			if callback then
				Arraylist = true
			else
				Arraylist = false
			end
		end
	})
	local HUDWatermark = HUD:CreateMiniToggle({
		Name = "Watermark",
		Enabled = true,
		Callback = function(callback)
			if callback then
				Watermark = true
			else
				Watermark = false
			end
		end
	})
end)

spawn(function()
	local Loop, UserID, UseDisplay = nil, nil, false
	local PName, PHumanoid, PIMG = nil, nil, nil
	local TargetHUD = Tabs.Visual:CreateToggle({
		Name = "Target HUD",
		Callback = function(callback)
			if callback then
				Loop = Service.RunService.RenderStepped:Connect(function()
					if IsKillAuraEnabled then
						if KillAuraTarget ~= nil then
							PName = KillAuraTarget.Name
							PHumanoid = KillAuraTarget:FindFirstChildOfClass("Humanoid")
							for i, v in pairs(Service.Players:GetPlayers()) do
								if v and v ~= LocalPlayer and v.Name:match(KillAuraTarget.Name) then
									UserID = v.UserId
								end						
							end
							if UserID ~= nil then
								PIMG = Service.Players:GetUserThumbnailAsync(UserID, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48)
							else
								PIMG = "rbxassetid://14025674892"
							end
							if UseDisplay then
								Main:CreateTargetHUD(PHumanoid.DisplayName, PIMG, PHumanoid, true)
							else
								Main:CreateTargetHUD(PName, PIMG, PHumanoid, true)
							end
						end
					else
						Main:CreateTargetHUD(LocalPlayer.Name, Service.Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48), LocalPlayer.Character:FindFirstChildOfClass("Humanoid"), true)
						repeat
							wait()
						until IsKillAuraEnabled
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				Main:CreateTargetHUD(LocalPlayer.Name, Service.Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48), LocalPlayer.Character:FindFirstChildOfClass("Humanoid"), false)
			end
		end
	})
	local TargetHUDNaming = TargetHUD:CreateMiniToggle({
		Name = "Use Display Name",
		Callback = function(callback)
			if callback then
				UseDisplay = true
			else
				UseDisplay = false
			end
		end
	})
end)

spawn(function()
	local Loop, Lines = nil, {}
	local function UpdateLine(v)
		if IsAlive(v) then
			local Vector, OnScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(v:FindFirstChild("HumanoidRootPart").Position)
			if OnScreen then
				local Origin = Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X / 2, game.Workspace.CurrentCamera.ViewportSize.Y / 2)
				local Destination = Vector2.new(Vector.X, Vector.Y)

				if not Lines[v] then
					Lines[v] = Main:CreateLine(Origin, Destination)
				else
					local Line = Lines[v]
					Line.Position = UDim2.new(0, (Origin + Destination).X / 2, 0, (Origin + Destination).Y / 2)
					Line.Size = UDim2.new(0, (Origin - Destination).Magnitude, 0, 0.02)
					Line.Rotation = math.deg(math.atan2(Destination.Y - Origin.Y, Destination.X - Origin.X))
				end
			elseif Lines[v] then
				Lines[v]:Destroy()
				Lines[v] = nil
			end
		elseif Lines[v] then
			Lines[v]:Destroy()
			Lines[v] = nil
		end
	end
	local Tracers = Tabs.Visual:CreateToggle({
		Name = "Tracers",
		Callback = function(callback)
			if callback then
				Loop = Service.RunService.Heartbeat:Connect(function()
					for i, v in pairs(game.Workspace:GetChildren()) do
						if v:IsA("Model") and IsAlive(v) then
							if v.Name ~= LocalPlayer.Name then
								UpdateLine(v)
							end
						end
					end
					for z, l in pairs(Lines) do
						if not IsAlive(z) then
							l:Destroy()
							Lines[z] = nil
						end
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				for i, v in pairs(Lines) do
					v:Destroy()
				end
				Lines = {}
			end
		end
	})
end)

spawn(function()
	local Loop, LastPosition, Mode, ShowLastPos = nil, nil, nil, false

	local PositionHighlight = Instance.new("Part")
	PositionHighlight.Size = Vector3.new(3, 0.4, 3)
	PositionHighlight.Anchored = true
	PositionHighlight.CanCollide = false
	PositionHighlight.CanTouch = false
	PositionHighlight.CanQuery = false
	PositionHighlight.Material = Enum.Material.Neon
	PositionHighlight.CastShadow = false
	PositionHighlight.Color = Color3.new(0.470588, 0.886275, 1)
	PositionHighlight.Transparency = 1
	PositionHighlight.Parent = game.Workspace

	local AntiVoid = Tabs.Player:CreateToggle({
		Name = "Anti Void",
		Callback = function(callback)
			if callback then
				LastPosition = LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position
				Loop = Service.RunService.Heartbeat:Connect(function()
					if IsAlive(LocalPlayer.Character) then
						if ShowLastPos then
							PositionHighlight.Transparency = 0.75
						else
							PositionHighlight.Transparency = 1
						end
						if LocalPlayer.Character:FindFirstChildOfClass("Humanoid").FloorMaterial ~= Enum.Material.Air then
							LastPosition = LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position
							PositionHighlight.Position = LastPosition - Vector3.new(0, 2.8, 0)
						end
						if game.Workspace:FindFirstChild("Map"):FindFirstChild("PvpArena") then
							if LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position.Y < -148 then
								if Mode == "TP" then
									LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(LastPosition + Vector3.new(0, 15, 0))
								elseif Mode == "Tween" then
									local TweenY = Service.TweenService:Create(LocalPlayer.Character:WaitForChild("HumanoidRootPart"), TweenInfo.new(0.1), {CFrame = CFrame.new(LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position.X, LastPosition.Y + 9, LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position.Z)})
									TweenY:Play()
									TweenY.Completed:Wait(1)
									local TweenX = Service.TweenService:Create(LocalPlayer.Character:WaitForChild("HumanoidRootPart"), TweenInfo.new(0.1), {CFrame = CFrame.new(LastPosition.X, LastPosition.Y + 9, LastPosition.Z)})
									TweenX:Play()
								end
							end
						else
							if LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position.Y < 18 then
								if Mode == "TP" then
									LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(LastPosition + Vector3.new(0, 15, 0))
								elseif Mode == "Tween" then
									local TweenY = Service.TweenService:Create(LocalPlayer.Character:WaitForChild("HumanoidRootPart"), TweenInfo.new(0.1), {CFrame = CFrame.new(LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position.X, LastPosition.Y + 9, LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position.Z)})
									TweenY:Play()
									TweenY.Completed:Wait(1)
									local TweenX = Service.TweenService:Create(LocalPlayer.Character:WaitForChild("HumanoidRootPart"), TweenInfo.new(0.1), {CFrame = CFrame.new(LastPosition.X, LastPosition.Y + 9, LastPosition.Z)})
									TweenX:Play()
								end
							end
						end
					else
						repeat
							task.wait()
						until IsAlive(LocalPlayer.Character)
					end
				end)
			else
				PositionHighlight.Transparency = 1
				if Loop ~= nil then
					Loop:Disconnect()
				end
			end
		end
	})
	local AntiVoidVisual = AntiVoid:CreateMiniToggle({
		Name = "Visualize",
		Callback = function(callback)
			if callback then
				ShowLastPos = true
			else
				ShowLastPos = false
			end
		end
	})
	local AntiVoidMode = AntiVoid:CreateDropdown({
		Name = "AntiVoid Mode",
		List = {"TP", "Tween"},
		Default = "TP",
		Callback = function(callback)
			if callback then
				Mode = callback
			end
		end
	})
end)

spawn(function()
	local Loop = nil
	local AutoTool = Tabs.Player:CreateToggle({
		Name = "Auto Tool",
		Callback = function(callback)
			if callback then
				Loop = Service.RunService.Heartbeat:Connect(function()
					if not IsAutoClickerClicking then
						if Service.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
							if Mouse.Target and Mouse.Target:IsA("Part") and Mouse.Target.Name == "Block" then
								task.wait(0.28)
								local Pickaxe = CheckTool("Pickaxe")
								if not Pickaxe then
									local PickaxeTool = GetTool("Pickaxe")
									if PickaxeTool then
										LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):EquipTool(PickaxeTool)
									end
								end
							end
						end
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
			end
		end
	})
end)

spawn(function()
	local SelectedMode = nil
	local PhaseDist = nil
	local Phase = Tabs.Player:CreateToggle({
		Name = "Phase",
		AutoDisable = true,
		Callback = function(callback)
			if callback then
				if SelectedMode == "VClip" then
					LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position - Vector3.new(0, PhaseDist, 0))
				end
			end
		end
	})
	local PhaseMode = Phase:CreateDropdown({
		Name = "Phase Modes",
		List = {"VClip"},
		Default = "VClip",
		Callback = function(callback)
			if callback then
				SelectedMode = callback
			end
		end
	})
	local PhaseDistance = Phase:CreateSlider({
		Name = "Distance",
		Min = 0,
		Max = 12,
		Default = 6,
		Callback = function(callback)
			if callback then
				PhaseDist = callback
			end
		end
	})
end)

spawn(function()	
	local Loop, Expand, Downwards = nil, nil, false
	local PlacePos, PickMode = nil,nil

	if not Service.UserInputService.TouchEnabled and Service.UserInputService.KeyboardEnabled and Service.UserInputService.MouseEnabled then
		Service.UserInputService.InputBegan:Connect(function(Input, IsTyping)
			if IsTyping then return end
			if Input.KeyCode == Enum.KeyCode.Q or Input.KeyCode == Enum.KeyCode.LeftShift then
				Downwards = true
			end
		end)

		Service.UserInputService.InputEnded:Connect(function(Input, IsTyping)
			if IsTyping then return end
			if Input.KeyCode == Enum.KeyCode.Q or Input.KeyCode == Enum.KeyCode.LeftShift then
				Downwards = false
			end
		end)
	end

	local Scaffold = Tabs.World:CreateToggle({
		Name = "Scaffold",
		Callback = function(callback)
			IsScaffoldEnabled = callback
			if callback then
				Loop = Service.RunService.Heartbeat:Connect(function()
					if IsAlive(LocalPlayer.Character) then
						for i = 1, Expand do
							if Downwards then
								PlacePos = GetPlace(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position + LocalPlayer.Character:FindFirstChildOfClass("Humanoid").MoveDirection * (i * 3.5) - Vector3.yAxis * ((LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Size.Y / 2) + LocalPlayer.Character:FindFirstChildOfClass("Humanoid").HipHeight + 1.5 + 3))
							else
								PlacePos = GetPlace(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position + LocalPlayer.Character:FindFirstChildOfClass("Humanoid").MoveDirection * (i * 3.5) - Vector3.yAxis * ((LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Size.Y / 2) + LocalPlayer.Character:FindFirstChildOfClass("Humanoid").HipHeight + 1.5))
							end
							if LocalPlayer.Character:WaitForChild("Head"):FindFirstChild("Neck") and LocalPlayer.Character:WaitForChild("LowerTorso"):FindFirstChild("Root") then
								if ScaffoldRotation == "Normal" then
									LocalPlayer.Character.LowerTorso:FindFirstChild("Root").C0 = CFrame.Angles(0, math.pi, 0)
								elseif ScaffoldRotation == "None" then
									LocalPlayer.Character.LowerTorso:FindFirstChild("Root").C0 = CFrame.new(OldTorsoC0)
								end
							end
							if PickMode == "None" then
								local args = {
									[1] = PlacePos
								}

								game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("PlaceBlock"):InvokeServer(unpack(args))
							elseif PickMode == "Switch" then
								local Block = CheckTool("Block")
								if Block then
									local args = {
										[1] = PlacePos
									}

									game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("PlaceBlock"):InvokeServer(unpack(args))
								else
									local BlockTool = GetTool("Block")
									if BlockTool then
										LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):EquipTool(BlockTool)
									end
								end
							end
						end
					else
						repeat
							task.wait()
						until IsAlive(LocalPlayer.Character)
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				LocalPlayer.Character.LowerTorso:FindFirstChild("Root").C0 = CFrame.new(OldTorsoC0)
				PlacePos = nil
				if PickMode == "Switch" then
					local Block = CheckTool("Block")
					if Block then
						LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):UnequipTools(Block)
					end
				end
			end
		end
	})
	local ScaffoldPickMode = Scaffold:CreateDropdown({
		Name = "Scaffold Block Picking",
		List = {"Switch", "None"},
		Default = "None",
		Callback = function(callback)
			if callback then
				PickMode = callback
			end
		end
	})
	local ScaffoldRotations = Scaffold:CreateDropdown({
		Name = "Scaffold Rotations",
		List = {"Normal", "None"},
		Default = "None",
		Callback = function(callback)
			if callback then
				ScaffoldRotation = callback
			end
		end
	})
	local ScaffoldExpand = Scaffold:CreateSlider({
		Name = "Expand",
		Min = 0,
		Max = 6,
		Default = 1,
		Callback = function(callback)
			if callback then
				Expand = callback
			end
		end
	})
end)
