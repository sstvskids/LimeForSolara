repeat wait() until game:IsLoaded()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/LimeForRoblox/refs/heads/main/Library.lua"))()
local Service = {
	UserInputService = game:GetService("UserInputService"),
	TextChatService = game:GetService("TextChatService"),
	TweenService = game:GetService("TweenService"),
	SoundService = game:GetService("SoundService"),
	RunService = game:GetService("RunService"),
	Lighting = game:GetService("Lighting"),
	Players = game:GetService("Players")
}

local LocalPlayer = Service.Players.LocalPlayer
LocalPlayer:SetAttribute("ClientSneaking", false)
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
	World = Main:CreateTab("World", 76313147188124, Color3.fromRGB(255, 170, 0))
}

local BridgeDuel = {
	Blink = require(game:GetService("ReplicatedStorage").Blink.Client),
	Entity = require(game:GetService("ReplicatedStorage").Modules.Entity),
	BlockPlacementController = require(game:GetService("ReplicatedStorage").Client.Controllers.All.BlockPlacementController),
	EffectsController = require(game:GetService("ReplicatedStorage").Client.Controllers.All.EffectsController),
	ToolService = game:GetService("ReplicatedStorage").Services.ToolService
}

local function IsAlive(v)
	return v and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid").Health > 0
end

local function GetWall()
	local Result = nil
	local Raycast = RaycastParams.new()
	Raycast.FilterType = Enum.RaycastFilterType.Exclude
	Raycast.IgnoreWater = true
	Raycast.FilterDescendantsInstances = {LocalPlayer.Character}
	for i, v in pairs(Service.Players:GetPlayers()) do
		if IsAlive(v) then
			for i, z in pairs(v.Character:GetChildren()) do
				if z.ClassName ~= "Script" and z.ClassName ~= "LocalScript" and z.ClassName ~= "ModuleScript" then
					table.insert(Raycast.FilterDescendantsInstances, z)
				end
			end
		end
	end

	local Direction = LocalPlayer.Character:FindFirstChildOfClass("Humanoid").MoveDirection * 1.5
	if Direction and Raycast then
		Result = game.Workspace:Raycast(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position, Direction, Raycast)
	end
	return Result and Result.Instance
end

local function CheckWall(v)
	local Raycast, Result = nil, nil

	local Direction = (v:FindFirstChild("HumanoidRootPart").Position - LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Unit
	local Distance = (v:FindFirstChild("HumanoidRootPart").Position - LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
	if Direction and Distance then
		Raycast = RaycastParams.new()
		Raycast.FilterDescendantsInstances = {LocalPlayer.Character}
		Raycast.FilterType = Enum.RaycastFilterType.Exclude
		Result = game.Workspace:Raycast(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position, Direction * Distance, Raycast)
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
						if entities:FindFirstChild("HumanoidRootPart") then
							Distances = (entities:FindFirstChild("HumanoidRootPart").Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
						end
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
	if LocalPlayer.Character:FindFirstChildWhichIsA("Tool") then
		local Tool = GetITemC0()
		if Tool then
			local Tween = Service.TweenService:Create(Tool, TweenInfo.new(anim.Time), {C0 = OldC0 * anim.CFrame})
			if Tween then
				Tween:Play()
				Tween.Completed:Wait()
			end
		end
	end
end

local function PlaySound(id)
	local Sound = Instance.new("Sound")
	Sound.SoundId = "rbxassetid://" .. id
	Sound.Parent = game:GetService("SoundService")
	Sound:Play()
	Sound.Ended:Connect(function()
		Sound:Destroy()
	end)
end

local function GetStaff()
	for i, v in pairs(Service.Players:GetPlayers()) do
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

local function CloneMe(v)
	if v and v:IsA("Model") then
		v.Archivable = true
		local clone = v:Clone()
		v.Archivable = false
		return clone
	end
end

local function GetBed(MaxDist)
	local MinDist = math.huge
	local Bed = nil
	for i, v in pairs(game.Workspace:FindFirstChild("Map"):GetChildren()) do
		if v:IsA("Model") and v.Name == "Bed" and v:GetAttribute("Team") ~= LocalPlayer.Team.Name then
			local Distance = (v.PrimaryPart.Position - LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
			if Distance < MinDist and Distance <= MaxDist then
				Bed = v
				MinDist = Distance
			end
		end
	end
	return Bed
end

local AntiBotGlobal = false
spawn(function()
	local AntiBot = Tabs.Combat:CreateToggle({
		Name = "Anti Bot",
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

local IsAutoClick = false
spawn(function()
	local Loop, MaxCPS, MinCPS, Randomize = nil, nil, nil, false
	local CPS, Delays = nil, nil
	local Start, ClickTime = nil, 0

	local AutoClicker = Tabs.Combat:CreateToggle({
		Name = "AutoClicker",
		Callback = function(callback)
			if callback then
				Start, ClickTime = nil, 0
				if not Loop then
					Loop = Service.RunService.RenderStepped:Connect(function()
						local Tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
						Start = tick()
						if Randomize then
							CPS = math.random(MinCPS, MaxCPS)
						else
							CPS = MaxCPS
						end
						if CPS ~= nil then
							Delays = 1 / CPS
						end
						if Tool then
							if Service.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
								if Start - ClickTime >= Delays then
									IsAutoClick = true
									Tool:Activate()
									ClickTime = Start
								end
							end
						end
					end)
				else
					Loop:Disconnect()
					Loop = nil
				end
			else
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end
				Start, ClickTime, IsAutoClick = nil, 0, false
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

spawn(function()
	local OldCrit
	local Criticals = Tabs.Combat:CreateToggle({
		Name = "Criticals",
		Callback = function(callback)
			if callback then
				if not OldCrit then
					OldCrit = hookfunction(BridgeDuel.Blink.item_action.attack_entity.fire, function(...)
						local Args = ...
						if type(Args) == 'table' then
							rawset(Args, 'is_crit', 1)
						end
						return OldCrit(...)
					end)
				end
			else
				if OldCrit then
					hookfunction(BridgeDuel.Blink.item_action.attack_entity.fire, OldCrit)
					OldCrit = nil
				end
			end
		end
	})
	local CriticalsMode = Criticals:CreateDropdown({
		Name = "Critical Type",
		List = {"Packet"},
		Default = "Packet",
		Callback = function(callback)
		end
	})
end)

local IsTPAura = false
local IsFakeLag = false
local IsScaffold = false
local C0Animation, SwordModel = nil, nil
local KillAuraSortMode, KillAuraTeamCheck, KillAuraBlock, IsKillAuraEnabled, KillAuraTarget, KillAuraWallCheck = nil, nil, nil, nil, nil, true
spawn(function()
	local Loop, Range, Swing = nil, nil, false
	local Sword, RotationMode = nil, nil
	local KillAura = Tabs.Combat:CreateToggle({
		Name = "Kill Aura",
		Callback = function(callback)
			if callback then
				IsKillAuraEnabled = true
				spawn(function()
					while IsKillAuraEnabled do
						task.wait()
						if Swing then
							if KillAuraTarget then
								if C0Animation ~= nil then
									if KillAuraBlock == "Packet" then
										for i, v in pairs(C0Animation) do
											AnimateC0(v)
										end
									else
										for i, v in pairs(C0Animation) do
											AnimateC0(v)
										end
									end
								else
									Sword:Activate()
								end
							end
						end
					end
				end)
				spawn(function()
					if not Loop then
						Loop = Service.RunService.RenderStepped:Connect(function() 
							if IsAlive(LocalPlayer.Character) then
								local Entity = GetNearestEntity(Range, AntiBotGlobal, KillAuraSortMode, KillAuraTeamCheck, KillAuraWallCheck)
								if Entity then
									local Direction = (Vector3.new(Entity:FindFirstChild("HumanoidRootPart").Position.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y, Entity:FindFirstChild("HumanoidRootPart").Position.Z) - LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Unit
									local LookCFrame = (CFrame.new(Vector3.zero, (LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame):VectorToObjectSpace(Direction)))
									if LocalPlayer.Character:WaitForChild("Head"):FindFirstChild("Neck") and LocalPlayer.Character:WaitForChild("LowerTorso"):FindFirstChild("Root") then
										if not IsFakeLag then
											if RotationMode == "Normal" then
												if not IsScaffold then
													LocalPlayer.Character.LowerTorso:FindFirstChild("Root").C0 = LookCFrame + OldTorsoC0
												end
											elseif RotationMode == "None" then
												if not IsScaffold then
													LocalPlayer.Character.LowerTorso:FindFirstChild("Root").C0 = CFrame.new(OldTorsoC0)
												end
											end
										else
											LocalPlayer.Character.LowerTorso:FindFirstChild("Root").C0 = CFrame.new(OldTorsoC0)
										end
									end
									KillAuraTarget = Entity
									Sword = CheckTool("Sword")
									if Sword then
										SwordModel = GetITemC0()
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
										if BridgeDuel.Blink and BridgeDuel.Entity then
											local EntityID = BridgeDuel.Entity.FindByCharacter(Entity)
											if EntityID then
												BridgeDuel.Blink.item_action.attack_entity.fire({
													target_entity_id = EntityID.Id,
													is_crit = LocalPlayer.Character.PrimaryPart.AssemblyLinearVelocity.Y < 0,
													weapon_name = Sword.Name
												})
											end
										end
									else
										KillAuraTarget = nil
										if SwordModel and OldC0 then
											if SwordModel.C0 ~= OldC0 then
												SwordModel.C0 = OldC0
											end
										end
										if KillAuraBlock == "Packet" then
											local args = {
												[1] = false,
												[2] = Sword.Name
											}
											game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
										end
									end
								else
									KillAuraTarget = nil
									if SwordModel and OldC0 then
										if SwordModel.C0 ~= OldC0 then
											SwordModel.C0 = OldC0
										end
									end
									if KillAuraBlock == "Packet" then
										local args = {
											[1] = false,
											[2] = Sword.Name
										}
										game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
									end
									if not IsScaffold then
										LocalPlayer.Character.LowerTorso:FindFirstChild("Root").C0 = CFrame.new(OldTorsoC0)
									end
								end
							end
						end)
					else
						Loop:Disconnect()
						Loop = nil
					end
				end)
			else
				IsKillAuraEnabled = false
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end
				if KillAuraBlock == "Packet" then
					local args = {
						[1] = false,
						[2] = Sword.Name
					}
					game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
				end
				if SwordModel and OldC0 then
					if SwordModel.C0 ~= OldC0 then
						SwordModel.C0 = OldC0
					end
				end
				if not IsScaffold then
					LocalPlayer.Character.LowerTorso:FindFirstChild("Root").C0 = CFrame.new(OldTorsoC0)
				end
			end
		end
	})
	local KillAuraSort = KillAura:CreateDropdown({
		Name = "Sort Mode",
		List = {"Furthest", "Health", "Threat", "Distance"},
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

spawn(function()
	local Loop, Ranges, TeamCheck = nil, nil, false
	local Entity, Sword = nil, nil
	local TeleportAura = Tabs.Combat:CreateToggle({
		Name = "Teleport Aura",
		Callback = function(callback)
			if callback then
				IsTPAura = true
				if not Loop then
					Loop = Service.RunService.RenderStepped:Connect(function()
						if not IsKillAuraEnabled then
							local PlaygroundService = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):FindFirstChild("PlaygroundService")
							if PlaygroundService then
								Entity = GetNearestEntity(Ranges, AntiBotGlobal, KillAuraSortMode, TeamCheck, false)
								if Entity then
									if Entity:FindFirstChild("HumanoidRootPart").Position.Y > 18 then
										Sword = CheckTool("Sword")
										if Sword then
											Service.TweenService:Create(LocalPlayer.Character:WaitForChild("HumanoidRootPart"), TweenInfo.new(0.1), {CFrame = CFrame.new(Entity:FindFirstChild("HumanoidRootPart").Position.X, Entity:FindFirstChild("HumanoidRootPart").Position.Y + 6.5, Entity:FindFirstChild("HumanoidRootPart").Position.Z)}):Play()
											if BridgeDuel.Blink and BridgeDuel.Interface then
												local EntityInterface = BridgeDuel.Interface.FindByCharacter(Entity)
												if EntityInterface then
													BridgeDuel.Blink.item_action.attack_entity.fire({
														target_entity_id = EntityInterface.Id,
														is_crit = LocalPlayer.Character.PrimaryPart.AssemblyLinearVelocity.Y < 0,
														weapon_name = Sword.Name
													})
												end
											end
										end
									end
								end
							end
						end
					end)
				else
					Loop:Disconnect()
					Loop = nil
				end
			else
				IsTPAura = true
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end
			end
		end
	})
	local TeleportAuraRange = TeleportAura:CreateSlider({
		Name = "Ranges",
		Min = 0,
		Max = 120,
		Default = 120,
		Callback = function(callback)
			if callback then
				Ranges = callback
			end
		end
	})
	local TeleportAuraTeamCheck = TeleportAura:CreateMiniToggle({
		Name = "Teams",
		Callback = function(callback)
			if callback then
				TeamCheck = true
			else
				TeamCheck = false
			end
		end
	})
end)

--[[
OLD TP AURA:
spawn(function()
	local Loop, TPRange, OldCameraType, OldCameraSubject = nil, nil, game.Workspace.CurrentCamera.CameraType, game.Workspace.CurrentCamera.CameraSubject 
	local Sword = nil
	
	local TeleportAura = Tabs.Combat:CreateToggle({
		Name = "Teleport Aura",
		Callback = function(callback)
			if callback then
				Loop = Service.RunService.RenderStepped:Connect(function()
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
							end
						end
					end
				end)
			else
				if Loop then
					Loop:Disconnect()
					Loop = nil
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
	local Loop, AutoLeave, IsStaff = nil, false, false
	local Detector = Tabs.Exploit:CreateToggle({
		Name = "Anti Staff",
		Callback = function(callback)
			if callback then
				if not Loop then
					Loop = Service.RunService.RenderStepped:Connect(function()
						local Staff = GetStaff()
						if not IsStaff then
							if Staff then
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
										Text = "Closing the game...",
										Duration = 1.5,
									})
									wait(2)
									game:Shutdown()
								end
							end
						end
					end)
				else
					Loop:Disconnect()
					Loop = nil
				end
			else
				if Loop then
					Loop:Disconnect()
					Loop = nil
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

spawn(function()
	local DamageSize = nil
	local Damage = Tabs.Exploit:CreateToggle({
		Name = "Damage",
		AutoDisable = true,
		Callback = function(callback)
			if callback then
				if BridgeDuel.Blink then
					BridgeDuel.Blink.player_state.take_fall_damage.fire(DamageSize)
				end
			end
		end
	})
	local CustomDamageSize = Damage:CreateSlider({
		Name = "Damages",
		Min = 0,
		Max = 100,
		Default = 1,
		Callback = function(callback)
			if callback then
				DamageSize = callback
			end
		end
	})
end)

spawn(function()
	local Loop = nil
	local Phase = Tabs.Exploit:CreateToggle({
		Name = "Phase",
		Callback = function(callback)
			if callback then
				if not Loop then
					Loop = Service.RunService.RenderStepped:Connect(function()
						if IsAlive(LocalPlayer.Character) then
							for i, v in pairs(LocalPlayer.Character:GetChildren()) do
								if v:IsA("MeshPart") and v.Name:match("Torso") then
									v.CanCollide = false
								end
							end
							for i, b in pairs(LocalPlayer.Character:GetChildren()) do
								if b:IsA("Part") and b.Name:match("Root") then
									b.CanCollide = false
								end
							end
						end
					end)
				else
					Loop:Disconnect()
					Loop = nil
				end
			else
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end
				for i, v in pairs(LocalPlayer.Character:GetChildren()) do
					if v:IsA("MeshPart") and v.Name:match("Torso") then
						v.CanCollide = true
					end
				end
				for i, b in pairs(LocalPlayer.Character:GetChildren()) do
					if b:IsA("Part") and b.Name:match("Root") then
						b.CanCollide = true
					end
				end
			end
		end
	})
end)

--[[
OLD DISABLER
spawn(function()
	local Loop, SelectedMode = nil, nil
	local Disabler = Tabs.Exploit:CreateToggle({
		Name = "Disabler",
		Callback = function(callback)
			if callback then
				Loop = Service.RunService.RenderStepped:Connect(function()
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
				if Loop then
					Loop:Disconnect()
					Loop = nil
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

spawn(function()
	local Loop, Delays, MoveTo, SelectedMode, Paused = nil, nil, nil, nil, false
	local OldCharacter, NewCharacter = nil, nil
	local Start, Counter = nil, 0
	local function CheckTool2(name)
		local TooResults
		for _,tool in pairs(OldCharacter:GetChildren()) do
			if tool:IsA("Tool") and tool.Name:match(name) then
				TooResults = tool
			end
		end
		return TooResults
	end
	local FakeLag = Tabs.Exploit:CreateToggle({
		Name = "Fake Lag",
		Callback = function(callback)
			if callback then
				IsFakeLag = true
				OldCharacter = LocalPlayer.Character
				if OldCharacter then
					Loop = Service.RunService.RenderStepped:Connect(function()
						if IsAlive(OldCharacter) then
							if NewCharacter == nil then
								NewCharacter = CloneMe(OldCharacter)
								NewCharacter.Parent = game.Workspace
								game:GetService("TweenService"):Create(NewCharacter.HumanoidRootPart, TweenInfo.new(0.4), {CFrame = CFrame.new(NewCharacter.HumanoidRootPart.Position, NewCharacter.HumanoidRootPart.Position + OldCharacter.HumanoidRootPart.CFrame.LookVector)}):Play()
							end
							if IsAlive(OldCharacter) and IsAlive(NewCharacter) then
								NewCharacter:FindFirstChildOfClass("Humanoid").MaxHealth = OldCharacter:FindFirstChildOfClass("Humanoid").MaxHealth
								NewCharacter:FindFirstChildOfClass("Humanoid").Health = OldCharacter:FindFirstChildOfClass("Humanoid").Health
								local Tool = NewCharacter:FindFirstChildWhichIsA("Tool")
								if Tool then
									if not CheckTool2(Tool.Name) then
										Paused = true
										LocalPlayer.Character = OldCharacter
										task.wait(1)
										for _, z in pairs(LocalPlayer.Backpack:GetChildren()) do
											if z:IsA("Tool") and z.Name == Tool.Name then
												LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):EquipTool(z)
												task.wait()
												LocalPlayer.Character = NewCharacter
												Paused = false
											end
										end
									end
								end
								if SelectedMode == "Pulse" then
									if not Paused then
										game.Workspace.CurrentCamera.CameraSubject = NewCharacter:FindFirstChildOfClass("Humanoid")
										LocalPlayer.Character = NewCharacter
										Start = tick()
										if Start - Counter >= 0.38 then
											Counter = Start
											OldCharacter.HumanoidRootPart.CFrame = NewCharacter.HumanoidRootPart.CFrame - NewCharacter.HumanoidRootPart.CFrame.LookVector * 3
										end

									end
								elseif SelectedMode == "Smooth" then
									if not Paused then
										game.Workspace.CurrentCamera.CameraSubject = NewCharacter:FindFirstChildOfClass("Humanoid")
										LocalPlayer.Character = NewCharacter
										task.wait(0.15)
										MoveTo = game:GetService("TweenService"):Create(OldCharacter.HumanoidRootPart, TweenInfo.new(Delays), {CFrame = NewCharacter.HumanoidRootPart.CFrame - NewCharacter.HumanoidRootPart.CFrame.LookVector * 3})
										if MoveTo ~= nil then
											MoveTo:Play()
										end
									end
								end
							end
						else
							Paused = false
							game.Workspace.CurrentCamera.CameraSubject = OldCharacter:FindFirstChildOfClass("Humanoid")
							LocalPlayer.Character = OldCharacter
							if NewCharacter ~= nil then
								NewCharacter:Destroy()
							end
							NewCharacter = nil
						end
					end)
				end
			else
				Paused = false
				IsFakeLag = false
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end
				if MoveTo ~= nil then
					MoveTo:Pause()
				end
				if OldCharacter then
					LocalPlayer.Character = OldCharacter
					game.Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
				end
				if NewCharacter then
					NewCharacter:Destroy()
				end
				NewCharacter = nil
			end
		end
	})
	local FakeLagMethods = FakeLag:CreateDropdown({
		Name = "Fake Lag Methods",
		List = {"Smooth", "Pulse"},
		Default = "Pulse",
		Callback = function(callback)
			if callback then
				SelectedMode = callback
			end
		end
	})
	local FakeLagDelay = FakeLag:CreateSlider({
		Name = "Delay",
		Min = 0.4,
		Max = 5,
		Default = 0.4,
		Callback = function(callback)
			if callback then
				Delays = callback
			end
		end
	})
end)

SELF DAMAGE PATCHED:
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
	local OldCharacter, NewCharacter, OldGravity = nil, nil, game.Workspace.Gravity
	local Start, Counter, IsEnabled = nil, 0, false
	local Loop = nil

	local WeirdFlight = Tabs.Exploit:CreateToggle({
		Name = "Weird Flight",
		Callback = function(callback)
			if callback then
				warn("Do Not Move")
				IsEnabled = true
				if not IsFakeLag and IsEnabled then
					OldCharacter = LocalPlayer.Character
					if not NewCharacter then
						NewCharacter = CloneMe(OldCharacter)
						NewCharacter.Parent = game.Workspace
						game:GetService("TweenService"):Create(OldCharacter.HumanoidRootPart, TweenInfo.new(0.2), {CFrame = CFrame.new(OldCharacter.HumanoidRootPart.Position.X, (OldCharacter.HumanoidRootPart.Position.Y + 20), OldCharacter.HumanoidRootPart.Position.Z)}):Play()
					end
					if OldCharacter and NewCharacter then
						Loop = Service.RunService.RenderStepped:Connect(function()
							if IsAlive(OldCharacter) then
								if IsAlive(OldCharacter) and IsAlive(NewCharacter) then
									NewCharacter:FindFirstChildOfClass("Humanoid").MaxHealth = OldCharacter:FindFirstChildOfClass("Humanoid").MaxHealth
									NewCharacter:FindFirstChildOfClass("Humanoid").Health = OldCharacter:FindFirstChildOfClass("Humanoid").Health
									game.Workspace.CurrentCamera.CameraSubject = NewCharacter:FindFirstChildOfClass("Humanoid")
									game.Workspace.Gravity = 0
									LocalPlayer.Character = NewCharacter
									OldCharacter:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(NewCharacter:FindFirstChild("HumanoidRootPart").Position.X, OldCharacter:FindFirstChild("HumanoidRootPart").Position.Y + 0.2, NewCharacter:FindFirstChild("HumanoidRootPart").Position.Z)
								end
							else
								game.Workspace.Gravity = OldGravity
								game.Workspace.CurrentCamera.CameraSubject = OldCharacter:FindFirstChildOfClass("Humanoid")
								LocalPlayer.Character = OldCharacter
								if NewCharacter ~= nil then
									NewCharacter:Destroy()
								end
								NewCharacter = nil
							end
						end)
					end
				end
			else
				IsEnabled = false
				if not IsFakeLag then
					if Loop then
						Loop:Disconnect()
						Loop = nil
					end
					OldCharacter:FindFirstChild("HumanoidRootPart").CFrame = OldCharacter:FindFirstChild("HumanoidRootPart").CFrame
					game.Workspace.Gravity = OldGravity
					NewCharacter:FindFirstChild("HumanoidRootPart").Anchored = true
					repeat
						task.wait()
					until OldCharacter:FindFirstChildOfClass("Humanoid").FloorMaterial ~= Enum.Material.Air
					if OldCharacter:FindFirstChildOfClass("Humanoid").FloorMaterial ~= Enum.Material.Air then
						LocalPlayer.Character = OldCharacter
						game.Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
						NewCharacter:Destroy()
						NewCharacter = nil
					end
				end
			end
		end
	})
end)
--]]

local IsFlight = false
spawn(function()
	local HumanoidRootPartY = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y
	local Loop, FlightSpeed, SelectedMode, YPos = nil, nil, nil, 0
	local OldGravity = game.Workspace.Gravity
	local IsSneaking = false

	if Service.UserInputService.TouchEnabled and not Service.UserInputService.KeyboardEnabled and not Service.UserInputService.MouseEnabled then
		Service.UserInputService.JumpRequest:Connect(function()
			YPos = YPos + 3
		end)
		LocalPlayer:GetAttributeChangedSignal("ClientSneaking"):Connect(function()
			IsSneaking = not IsSneaking
			if IsSneaking then
				YPos = YPos - 3
			end
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
				IsFlight = true
				YPos = 0
				HumanoidRootPartY = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y
				if not Loop then
					Loop = Service.RunService.RenderStepped:Connect(function()
						if IsAlive(LocalPlayer.Character) then
							local Velocity = LocalPlayer.Character.Humanoid.MoveDirection * FlightSpeed
							LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, Velocity.Z)
							if SelectedMode == "Float" then
								game.Workspace.Gravity = 0
								LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.X, HumanoidRootPartY + YPos, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Z) * LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.Rotation
							elseif SelectedMode == "Jump" then
								game.Workspace.Gravity = OldGravity
								LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
								LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Z)
								while SelectedMode == "Jump" do
									task.wait()
									if LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):GetState() == Enum.HumanoidStateType.Freefall and LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y <= (HumanoidRootPartY - LocalPlayer.Character:FindFirstChildOfClass("Humanoid").HipHeight) + YPos then
										if IsFlight then
											LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
										end
									end
								end
							end
						end
					end)
				else
					Loop:Disconnect()
					Loop = nil
				end
			else
				IsFlight = false
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end
				game.Workspace.Gravity = OldGravity
				HumanoidRootPartY =  LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y
				LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
				LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Z)
			end
		end
	})
	local FlightMode = Flight:CreateDropdown({
		Name = "Flight Mode",
		List = {"Jump", "Float"},
		Default = "Float",
		Callback = function(callback)
			if callback then
				SelectedMode = callback
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
	local AutoJump = false
	local LongJump = Tabs.Move:CreateToggle({
		Name = "Long Jump",
		AutoDisable = true,
		Callback = function(callback)
			if callback then
				if not IsFlight then
					IsEnabled = true
					if IsEnabled then
						game.Workspace.Gravity = 15
						if AutoJump then
							game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
						end
						wait(0.24)
						local Velocity = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 76
						LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, Velocity.Z)
					end
				end
			else
				if WaitToLand then
					while task.wait(0.45) do
						if LocalPlayer.Character:FindFirstChildOfClass("Humanoid").FloorMaterial ~= Enum.Material.Air then
							game.Workspace.Gravity = OldGravity
							IsEnabled = false
						end
					end
				else
					task.wait(1)
					game.Workspace.Gravity = OldGravity
					IsEnabled = false
				end
			end
		end
	})
	local LongJumpAutoJump = LongJump:CreateMiniToggle({
		Name = "Jump",
		Callback = function(callback)
			if callback then
				AutoJump = true
			else
				AutoJump = false
			end
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
					end
				end)
			else
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end
				LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
			end
		end
	})
	local NoSlowMode = NoSlowDown:CreateDropdown({
		Name = "No Slowdown Method",
		List = {"Vanilla"},
		Default = "Vanilla",
		Callback = function(callback)
		end
	})
end)

local IsSpeedEnabled = false
spawn(function()
	local Loop, VelocitySpeed, Velocity, JumpCount = nil, nil, nil, 0
	local SelectedMode = nil
	local Speed = Tabs.Move:CreateToggle({
		Name = "Speed",
		Callback = function(callback)
			if callback then
				IsSpeedEnabled = true
				if not Loop then
					Loop = Service.RunService.RenderStepped:Connect(function()
						if not IsFlight then
							if IsAlive(LocalPlayer.Character) then
								Velocity = LocalPlayer.Character.Humanoid.MoveDirection * VelocitySpeed
								if SelectedMode == "Static" then
									JumpCount = 0
									LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, Velocity.Z)
								elseif SelectedMode == "Hop" then
									LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, Velocity.Z)
									Velocity = LocalPlayer.Character.Humanoid.MoveDirection * VelocitySpeed
									if JumpCount == 0 and IsSpeedEnabled then
										LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
										JumpCount = 1
									end
									while SelectedMode == "Hop" do
										task.wait()
										if LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):GetState() == Enum.HumanoidStateType.Landed then
											if IsSpeedEnabled then
												LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
											end
										end
									end
								end
							end
						end
					end)
				else
					Loop:Disconnect()
					Loop = nil
				end
			else
				IsSpeedEnabled = false
				JumpCount = 0
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end
				LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Z)
			end
		end
	})
	local SpeedModde = Speed:CreateDropdown({
		Name = "Speed Modes",
		List = {"Hop", "Static"},
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
	local Loop = nil
	local Step = Tabs.Move:CreateToggle({
		Name = "Step",
		Callback = function(callback)
			if callback then
				if not Loop then
					Loop = Service.RunService.RenderStepped:Connect(function()
						if IsAlive(LocalPlayer.Character) then
							local Wall = GetWall()
							if Wall then
								LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.X, 28, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Z)
							end
						end
					end)
				else
					Loop:Disconnect()
					Loop = nil
				end
			else
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end
			end
		end
	})
end)

spawn(function()
	local Loop, SelectedMode = nil, nil
	local Animation = Tabs.Visual:CreateToggle({
		Name = "Animations",
		Callback = function(callback)
			if callback then
				if not Loop then
					Loop = Service.RunService.RenderStepped:Connect(function()
						if SelectedMode == "Lime" then
							C0Animation = {
								{CFrame = CFrame.new(0, 0, 1.5) * CFrame.Angles(math.rad(-35), math.rad(50), math.rad(110)), Time = 0.15},
								{CFrame = CFrame.new(0, 0.8, 1.0) * CFrame.Angles(math.rad(-65), math.rad(50), math.rad(110)), Time = 0.15}
							}
						elseif SelectedMode == "Stab" then
							C0Animation = {
								{CFrame = CFrame.new(-2.5, 0, 3.5) * CFrame.Angles(math.rad(0), math.rad(25), math.rad(60)), Time = 0.1},
								{CFrame = CFrame.new(-0.5, 0, 1.3) * CFrame.Angles(math.rad(0), math.rad(25), math.rad(60)), Time = 0.1}
							}
						end
					end)
				else
					Loop:Disconnect()
					Loop = nil
				end
			else
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end
				C0Animation = nil
				if SwordModel ~= nil then
					if OldC0 ~= nil then
						if SwordModel.C0 ~= OldC0 then
							SwordModel.C0 = OldC0
						end
					end
				end
			end
		end
	})
	local AnimationSword = Animation:CreateDropdown({
		Name = "Sword Hit Animation",
		List = {"Stab", "Lime"},
		Default = "Lime",
		Callback = function(callback)
			if callback then
				SelectedMode = callback
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
			highlight.OutlineColor = Color3.new(1, 1, 1)
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
				if not Loop then
					Loop = Service.RunService.RenderStepped:Connect(function()
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
					Loop:Disconnect()
					Loop = nil
				end
			else
				if Loop then
					Loop:Disconnect()
					Loop = nil
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
							UIStoke.Color = Color3.fromRGB(255, 255, 255)
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
				if not Loop then
					Loop = Service.RunService.RenderStepped:Connect(function()
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
					Loop:Disconnect()
					Loop = nil
				end
			else
				if Loop then
					Loop:Disconnect()
					Loop = nil
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
				if not Loop then
					Loop = Service.RunService.RenderStepped:Connect(function()
						Service.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
						Service.Lighting.Brightness = 10
					end)
				else
					Loop:Disconnect()
					Loop = nil
				end
			else
				if Loop then
					Loop:Disconnect()
					Loop = nil
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
				if not Loop then
					Loop = Service.RunService.RenderStepped:Connect(function()
						if shared.Lime.Visual then
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
					Loop:Disconnect()
					Loop = nil
				end
			else
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end
				if shared.Lime.Visual then
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
	local Loop = nil
	local Selected = nil
	local KillTable = {}
	local Dead, Alive = nil, nil
	for _, v in pairs(game:GetService("ReplicatedStorage").Assets.KillEffects:GetChildren()) do
		if v:IsA("ModuleScript") then
			table.insert(KillTable, v.Name)
		end
	end
	local KillEffects = Tabs.Visual:CreateToggle({
		Name = "Kill Effects",
		Callback = function(callback)
			if callback then
				if not Loop then
					Loop = game:GetService("ReplicatedStorage").Modules.Knit.Services.CombatService.RE.OnKill.OnClientEvent:Connect(function(...)
						local Args = {...}
						if BridgeDuel.Entity then
							if type(Args[1]) == "table" then
								if Args[1].Id then
									for i, b in pairs(game:GetService("Players"):GetPlayers()) do
										if b.Character then
											local Entity1 = BridgeDuel.Entity.FindByCharacter(b.Character)
											if Entity1 and Entity1.Id == Args[1].Id then
												Alive = b
											end
										end
									end
								end
							end
							if type(Args[2]) == "table" then
								if Args[2].Id then
									for i, v in pairs(game:GetService("Players"):GetPlayers()) do
										if v.Character then
											local Entity2 = BridgeDuel.Entity.FindByCharacter(v.Character)
											if Entity2 and Entity2.Id == Args[2].Id then
												Dead = v
											end
										end
									end
								end
							end
						end
						if Alive.Name == LocalPlayer.Name and Dead.Name ~= LocalPlayer.Name and Selected then
							for _, v in pairs(game:GetService("ReplicatedStorage").Assets.KillEffects:GetChildren()) do
								if v:IsA("ModuleScript") and v.Name == Selected then
									local EffectResult = require(v)
									if EffectResult then
										EffectResult(Dead.Character:FindFirstChild("HumanoidRootPart").Position)
									end
								end
							end
						elseif Alive.Name ~= LocalPlayer.Name and Dead.Name == LocalPlayer.Name and Selected then
							for _, v in pairs(game:GetService("ReplicatedStorage").Assets.KillEffects:GetChildren()) do
								if v:IsA("ModuleScript") and v.Name == Selected then
									local EffectResult = require(v)
									if EffectResult then
										EffectResult(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position)
									end
								end
							end
						end
					end)
				else
					Loop:Disconnect()
					Loop = nil
				end
			else
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end
			end
		end
	})
	local KillEffectsType = KillEffects:CreateDropdown({
		Name = "KillEffects Modes",
		List = KillTable,
		Default = "LightningKillEffect",
		Callback = function(callback)
			if callback then
				Selected = callback
			end
		end
	})
end)

spawn(function()
	local Loop, UseDisplay = nil, false
	local PName, PHumanoid, PIMG = nil, nil, nil
	local TargetHUD = Tabs.Visual:CreateToggle({
		Name = "Target HUD",
		Callback = function(callback)
			if callback then
				if not Loop then
					Loop = Service.RunService.RenderStepped:Connect(function()
						if IsKillAuraEnabled then
							if KillAuraTarget ~= nil then
								PName = KillAuraTarget.Name
								PHumanoid = KillAuraTarget:FindFirstChildOfClass("Humanoid")
								local TargetPlayer = Service.Players:GetPlayerFromCharacter(KillAuraTarget)
								if TargetPlayer then
									PIMG = Service.Players:GetUserThumbnailAsync(TargetPlayer.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48)
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
						end
					end)
				else
					Loop:Disconnect()
					Loop = nil
				end
			else
				if Loop then
					Loop:Disconnect()
					Loop = nil
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
				if not Loop then
					Loop = Service.RunService.RenderStepped:Connect(function()
						for i, v in pairs(game.Workspace:GetChildren()) do
							if v:IsA("Model") and IsAlive(v) then
								if AntiBotGlobal then
									if Service.Players:FindFirstChild(v.Name) then
										if v.Name ~= LocalPlayer.Name then
											UpdateLine(v)
										end
									else
										if Lines[v] then
											Lines[v]:Destroy()
											Lines[v] = nil
										end
									end
								else
									if v.Name ~= LocalPlayer.Name then
										UpdateLine(v)
									end
								end
							else
								if Lines[v] then
									Lines[v]:Destroy()
									Lines[v] = nil
								end
							end
						end
					end)
				else
					Loop:Disconnect()
					Loop = nil
				end
			else
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end
				for i, v in pairs(Lines) do
					v:Destroy()
				end
				Lines = {}
			end
		end
	})
end)
--[[
spawn(function()
	local Loop = nil
	local AutoTool = Tabs.Player:CreateToggle({
		Name = "Auto Tool",
		Callback = function(callback)
			if callback then
				Loop = Service.RunService.RenderStepped:Connect(function()
					if not IsAutoClick then
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
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end
			end
		end
	})
end)
--]]
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
	PositionHighlight.Color = Color3.new(0.815686, 0.0745098, 1)
	PositionHighlight.Transparency = 1
	PositionHighlight.Parent = game.Workspace

	local AntiVoid = Tabs.Player:CreateToggle({
		Name = "Anti Void",
		Callback = function(callback)
			if callback then
				LastPosition = LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position
				if not Loop then
					Loop = Service.RunService.RenderStepped:Connect(function()
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
								if LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position.Y < -152 then
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
						end
					end)
				else
					Loop:Disconnect()
					Loop = nil
				end
			else
				PositionHighlight.Transparency = 1
				if Loop then
					Loop:Disconnect()
					Loop = nil
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
		List = {"Tween", "TP"},
		Default = "TP",
		Callback = function(callback)
			if callback then
				Mode = callback
			end
		end
	})
end)

spawn(function()
	local SelectedMode = nil
	local ClipDist = nil
	local Clip = Tabs.Player:CreateToggle({
		Name = "Clip",
		AutoDisable = true,
		Callback = function(callback)
			if callback then
				if SelectedMode == "VClip" then
					LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position - Vector3.new(0, ClipDist, 0))
				elseif SelectedMode == "HClip" then
					LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position + Vector3.new(0, ClipDist, 0))
				end
			end
		end
	})
	local ClipMode = Clip:CreateDropdown({
		Name = "Clip Modes",
		List = {"HClip", "VClip"},
		Default = "VClip",
		Callback = function(callback)
			if callback then
				SelectedMode = callback
			end
		end
	})
	local ClipDistance = Clip:CreateSlider({
		Name = "Distancez",
		Min = 0,
		Max = 12,
		Default = 6,
		Callback = function(callback)
			if callback then
				ClipDist = callback
			end
		end
	})
end)

spawn(function()
	local function Kill(plr)
		local msg = {
			plr.Name .. " Haha",
			plr.Name .. " Im just lagging",
			"Me when " .. plr.Name .. " tries lime",
		}
		return msg[math.random(1, #msg)]
	end
	local function Dead(plr)
		local msg = {
			plr.Name .. " My lime expires",
			plr.Name .. " See, i told yall that im legit too!"
		}
		return msg[math.random(1, #msg)]
	end
	local Loop = nil
	local Dead, Alive = nil, nil
	local AutoToxic = Tabs.Player:CreateToggle({
		Name = "Killsults",
		Callback = function(callback)
			if callback then
				if not Loop then
					Loop = game:GetService("ReplicatedStorage").Modules.Knit.Services.CombatService.RE.OnKill.OnClientEvent:Connect(function(...)
						local Args = {...}
						if BridgeDuel.Entity then
							if type(Args[1]) == "table" then
								if Args[1].Id then
									for i, b in pairs(game:GetService("Players"):GetPlayers()) do
										if b.Character then
											local Entity1 = BridgeDuel.Entity.FindByCharacter(b.Character)
											if Entity1 and Entity1.Id == Args[1].Id then
												Alive = b
											end
										end
									end
								end
							end
							if type(Args[2]) == "table" then
								if Args[2].Id then
									for i, v in pairs(game:GetService("Players"):GetPlayers()) do
										if v.Character then
											local Entity2 = BridgeDuel.Entity.FindByCharacter(v.Character)
											if Entity2 and Entity2.Id == Args[2].Id then
												Dead = v
											end
										end
									end
								end
							end
						end
						if Alive.Name == LocalPlayer.Name and Dead.Name ~= LocalPlayer.Name then
							local KillMessage = Kill(Dead)
							local args = {
								[1] = KillMessage,
								[2] = "All"
							}
							game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(unpack(args))
						elseif Alive.Name ~= LocalPlayer.Name and Dead.Name == LocalPlayer.Name then
							local DeadMessage = Dead(Alive)
							local args = {
								[1] = DeadMessage,
								[2] = "All"
							}
							game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(unpack(args))
						end
					end)
				else
					Loop:Disconnect()
					Loop = nil
				end
			else
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end
			end
		end
	})
end)

spawn(function()
	local OldFall = nil
	local NoFall = Tabs.Player:CreateToggle({
		Name = "No Fall",
		Callback = function(callback)
			if callback then
				if BridgeDuel.Blink then
					if not OldFall then
						OldFall = hookfunction(BridgeDuel.Blink.player_state.take_fall_damage.fire, function(...)
						end)
					end
				end
			else
				if OldFall then
					hookfunction(BridgeDuel.Blink.player_state.take_fall_damage.fire, OldFall)
					OldFall = nil
				end
			end
		end
	})
end)

spawn(function()
	local Raycast = RaycastParams.new()
	Raycast.FilterDescendantsInstances = {LocalPlayer.Character}
	Raycast.FilterType = Enum.RaycastFilterType.Exclude
	Raycast.IgnoreWater = true

	local Distance, Selected = nil, nil
	local Direction, Result = nil, nil
	local Pickaxe, Bed = nil, nil
	local IsBreaking = false
	local Blocks = {}
	local Loop = nil
	local Breaker = Tabs.World:CreateToggle({
		Name = "Bed Breaker",
		Callback = function(callback)
			if callback then
				IsBreaking = false
				if not Loop then
					Loop = Service.RunService.Stepped:Connect(function()
						if IsAlive(LocalPlayer.Character) then
							if BridgeDuel.Blink then
								Bed = GetBed(Distance)
								if Bed then
									Direction = Bed.PrimaryPart.Position - LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position
									Result = game.Workspace:Raycast(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position, Direction, Raycast)
									for i, v in pairs(LocalPlayer.Backpack:GetChildren()) do
										if v:IsA("Tool") and v.Name:match("Pickaxe") then
											Pickaxe = v
										end
									end
									for i, b in pairs(LocalPlayer.Character:GetChildren()) do
										if b:IsA("Tool") and b.Name:match("Pickaxe") then
											Pickaxe = b
										end
									end
									if Selected == "Blatant" then
										if Pickaxe then
											if not Bed:FindFirstChildWhichIsA("Highlight") then
												local highlight = Instance.new("Highlight")
												highlight.Parent = Bed
												highlight.FillTransparency = 1
												highlight.OutlineTransparency = 0.45
												highlight.OutlineColor = Color3.new(1, 1, 1)
											end
											if not IsBreaking then
												BridgeDuel.Blink.item_action.start_break_block.fire({
													position = Vector3.new(Bed.PrimaryPart.Position.X, Bed.PrimaryPart.Position.Y, Bed.PrimaryPart.Position.Z),
													pickaxe_name = Pickaxe.Name,
												})
												task.wait(3)
												IsBreaking = true
											end
										end
									elseif Selected == "Legit" then
										if Result and Result.Instance then
											if Result.Instance.Name == "Block" and not table.find(Blocks, Result.Instance) then
												table.insert(Blocks, Result.Instance)
												Result.Instance.CanCollide = false
												Result.Instance.CanTouch = false
												Result.Instance.CanQuery = false
												Result.Instance.Transparency = 0.75
											end
										end
									end
								end
							else
								if Selected == "Legit" then
									for i = #Blocks, 1, -1 do
										local v = Blocks[i]
										if v and v.Parent and not v.CanCollide and not v.CanTouch and not v.CanQuery and v.Transparency ~= 0 then
											local Distances = (v.Position - LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
											if Distances > Distance then
												v.CanCollide = true
												v.CanTouch = true
												v.CanQuery = true
												v.Transparency = 0
												table.remove(Blocks, i)
											end
										end
									end
								end
								if IsBreaking then
									BridgeDuel.Blink.item_action.stop_break_block.fire()
									IsBreaking = false
								end
							end
						end
					end)
				else
					Loop:Disconnect()
					Loop = nil
				end
			else
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end
				if Bed then
					if Bed:FindFirstChildWhichIsA("Highlight") then
						Bed:FindFirstChildWhichIsA("Highlight"):Destroy()
					else
						Bed = nil
					end
				end
				Direction, Result = nil, nil
				IsBreaking = false
				if Selected == "Legit" then
					for i, v in ipairs(Blocks) do
						if v and v.Parent then
							v.CanCollide = true
							v.CanTouch = true
							v.CanQuery = true
							v.Transparency = 0
						end
					end
					Blocks = {}
				end
			end
		end
	})
	local BreakerMode = Breaker:CreateDropdown({
		Name = "Breaker Modes",
		List = {"Legit", "Blatant"},
		Default = "Blatant",
		Callback = function(callback)
			if callback then
				Selected = callback
			end
		end
	})
	local BreakerDistance = Breaker:CreateSlider({
		Name = "Distances",
		Min = 0,
		Max = 28,
		Default = 28,
		Callback = function(callback)
			if callback then
				Distance = callback
			end
		end
	})
end)

spawn(function()
	local BlockNames = {"Blocks", "WoodPlanksBlock", "StoneBlock", "IronBlock", "BricksBlock", "DiamondBlock"}
	local BlocksList = {
		Blocks = "Clay",
		WoodPlanksBlock = "WoodPlanks",
		StoneBlock = "Stone",
		IronBlock = "Iron",
		BricksBlock = "Bricks",
		DiamondBlock = "Diamond"
	}
	local Loop, Expand, Downwards, Rotations, Tower = nil, nil, false, nil, false
	local IsSneaking, IsTowering = false, false
	local JumpStuff = false
	local PlacePos = nil
	local BlockType = nil
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
		Service.UserInputService.InputBegan:Connect(function(Input, IsTyping)
			if IsTyping then return end
			if Input.KeyCode == Enum.KeyCode.Space then
				IsTowering = true
			end
		end)
		Service.UserInputService.InputEnded:Connect(function(Input, IsTyping)
			if IsTyping then return end
			if Input.KeyCode == Enum.KeyCode.Space then
				IsTowering = false
			end
		end)
	elseif Service.UserInputService.TouchEnabled and not Service.UserInputService.KeyboardEnabled and not Service.UserInputService.MouseEnabled then
		LocalPlayer:GetAttributeChangedSignal("ClientSneaking"):Connect(function()
			IsSneaking = not IsSneaking
			if IsSneaking then
				Downwards = true
			else
				Downwards = false
			end
		end)
		Service.UserInputService.JumpRequest:Connect(function()
			JumpStuff = not JumpStuff
			if JumpStuff then
				IsTowering = true
			else
				IsTowering = false
			end
		end)
	end
	local Block = nil
	local Scaffold = Tabs.World:CreateToggle({
		Name = "Scaffold",
		Callback = function(callback)
			if callback then
				IsScaffold = true
				if not Loop then
					Loop = Service.RunService.RenderStepped:Connect(function()
						if IsAlive(LocalPlayer.Character) then
							for i = 1, Expand do
								if Downwards then
									PlacePos = GetPlace(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position + LocalPlayer.Character:FindFirstChildOfClass("Humanoid").MoveDirection * (i * 3.5) - Vector3.yAxis * ((LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Size.Y / 2) + LocalPlayer.Character:FindFirstChildOfClass("Humanoid").HipHeight + 1.5 + 3))
								else
									PlacePos = GetPlace(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position + LocalPlayer.Character:FindFirstChildOfClass("Humanoid").MoveDirection * (i * 3.5) - Vector3.yAxis * ((LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Size.Y / 2) + LocalPlayer.Character:FindFirstChildOfClass("Humanoid").HipHeight + 1.5))
								end
								if Tower then
									if IsTowering then
										LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.X, 14, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Z)
									else
										LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Z)
									end
								end
								if LocalPlayer.Character:WaitForChild("Head"):FindFirstChild("Neck") and LocalPlayer.Character:WaitForChild("LowerTorso"):FindFirstChild("Root") then
									if Rotations == "Normal" then
										LocalPlayer.Character.LowerTorso:FindFirstChild("Root").C0 = CFrame.Angles(0, math.pi, 0)
										task.spawn(function()
											LocalPlayer:SetAttribute("ClientSneaking", true)
											task.wait(0.8)
											LocalPlayer:SetAttribute("ClientSneaking", false)
										end)
									elseif Rotations == "None" then
										LocalPlayer.Character.LowerTorso:FindFirstChild("Root").C0 = CFrame.new(OldTorsoC0)
									end
								end
								if not Service.UserInputService.TouchEnabled and Service.UserInputService.KeyboardEnabled and Service.UserInputService.MouseEnabled then
									if BridgeDuel.BlockPlacementController then
										for i, v in pairs(LocalPlayer.Backpack:GetChildren()) do
											if table.find(BlockNames, v.Name) then
												local GetBlockType = BlocksList[v.Name]
												if GetBlockType then
													BlockType = GetBlockType
													Block = v
													break
												end
											end
										end
										for i, b in pairs(LocalPlayer.Character:GetChildren()) do
											if table.find(BlockNames, b.Name) then
												local GetBlockType = BlocksList[b.Name]
												if GetBlockType then
													BlockType = GetBlockType
													Block = b
													break
												end
											end
										end
										if BlockType and Block then
											BridgeDuel.BlockPlacementController.PlaceBlock(nil, PlacePos, BlockType)
										end
									end
								elseif Service.UserInputService.TouchEnabled and not Service.UserInputService.KeyboardEnabled and not Service.UserInputService.MouseEnabled then
									if BridgeDuel.Blink then
										for i, v in pairs(LocalPlayer.Backpack:GetChildren()) do
											if table.find(BlockNames, v.Name) then
												local GetBlockType = BlocksList[v.Name]
												if GetBlockType then
													BlockType = GetBlockType
													Block = v
												end
											end
										end
										for i, b in pairs(LocalPlayer.Character:GetChildren()) do
											if table.find(BlockNames, b.Name) then
												local GetBlockType = BlocksList[b.Name]
												if GetBlockType then
													BlockType = GetBlockType
													Block = b
												end
											end
										end
										if BlockType and Block then
											BridgeDuel.Blink.item_action.place_block.invoke({
												position = PlacePos,
												block_type = BlockType
											})
										end
									end
								end
							end
						end
					end)
				else
					Loop:Disconnect()
					Loop = nil
				end
			else
				IsScaffold = false
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end
				LocalPlayer.Character.LowerTorso:FindFirstChild("Root").C0 = CFrame.new(OldTorsoC0)
				BlockType, Block = nil, nil
				PlacePos = nil
			end
		end
	})
	local ScaffoldRotations = Scaffold:CreateDropdown({
		Name = "Scaffold Rotations",
		List = {"Normal", "None"},
		Default = "None",
		Callback = function(callback)
			if callback then
				Rotations = callback
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
	local ScaffoldTower = Scaffold:CreateMiniToggle({
		Name = "Tower",
		Callback = function(callback)
			if callback then
				Tower = true
			else
				Tower = false
			end
		end
	})
end)

spawn(function()
	local OldTime, NewTime = Service.Lighting.ClockTime, nil
	local Loop = nil
	local TimeChanger = Tabs.World:CreateToggle({
		Name = "Time Changer",
		Callback = function(callback)
			if callback then
				if not Loop then
					Loop = Service.RunService.RenderStepped:Connect(function()
						Service.Lighting.ClockTime = NewTime
					end)
				else
					Loop:Disconnect()
					Loop = nil
				end
			else
				if Loop then
					Loop:Disconnect()
					Loop = nil
				end
				Service.Lighting.ClockTime = OldTime
			end
		end
	})
	local TimeChangerClock = TimeChanger:CreateSlider({
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
