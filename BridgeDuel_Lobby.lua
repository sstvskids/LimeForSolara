local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/LimeForRoblox/refs/heads/main/Library.lua"))()
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

local Main = Library:CreateMain()
local CombatTab = Main:CreateTab("Combat", 138185990548352, Color3.fromRGB(255, 85, 127))
local ExploitTab = Main:CreateTab("Exploit", 71954798465945, Color3.fromRGB(0, 255, 187))
local MoveTab = Main:CreateTab("Move", 91366694317593, Color3.fromRGB(82, 246, 255))
local PlayerTab = Main:CreateTab("Player", 103157697311305, Color3.fromRGB(255, 255, 127))
local VisualTab = Main:CreateTab("Visual", 118420030502964, Color3.fromRGB(170, 85, 255))
local WorldTab = Main:CreateTab("World", 76313147188124, Color3.fromRGB(255, 170, 0))

--[[ Under Development
game:GetService("ReplicatedStorage").__comm__.RP.gamemode:FireServer()
game:GetService("ReplicatedStorage").Remotes.Jumpscare:FireServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.CombatService.RE.OnKill:FireServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.VoidService.RE.OnFell:FireServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.ModerationService.RF.Ban:InvokeServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.ModerationService.RF.Unban:InvokeServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.NetworkService.RF.SendReport:InvokeServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.GuildService.RF.KickPlayer:InvokeServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.CombatService.RE.KnockBackApplied:FireServer()
workspace.Parent:GetService("Workspace").Map.RedBase:GetChildren()[119]
--]]

local function PlaySound(id)
	local Sound = Instance.new("Sound")
	Sound.SoundId = "rbxassetid://" .. id
	Sound.Parent = game.Workspace
	Sound:Play()
	Sound.Ended:Connect(function()
		Sound:Destroy()
	end)
end

local function IsAlive(v)
	return v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0
end

local function GetNearestPlayer(MaxDist, Sort, Team)
	local Entity, MinDist, Distance

	for i,v in pairs(Players:GetPlayers()) do
		if v ~= LocalPlayer and IsAlive(v) then
			if v.Character:FindFirstChild("HumanoidRootPart") then
				if not Team or v.Team ~= LocalPlayer.Team then
					Distance = (v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

					if Sort == "Distance" then
						if Distance <= MaxDist and (not MinDist or Distance < MinDist) then
							MinDist = Distance
							Entity = v
						end
					elseif Sort == "Furthest" then
						if Distance <= MaxDist and (not MinDist or Distance > MinDist) then
							MinDist = Distance
							Entity = v
						end
					elseif Sort == "Health" then
						local Humanoid = v.Character:FindFirstChildOfClass("Humanoid")
						if Humanoid and Distance <= MaxDist and (not MinDist or Humanoid.Health < MinDist) then
							MinDist = Humanoid.Health
							Entity = v
						end
					elseif Sort == "Threat" then
						local Humanoid = v.Character:FindFirstChildOfClass("Humanoid")
						if Humanoid and Distance <= MaxDist and (not MinDist or Humanoid.Health > MinDist) then
							MinDist = Humanoid.Health
							Entity = v
						end
					end
				end
			end
		end
	end

	return Entity
end

local function GetStaff()
	for _, v in pairs(Players:GetPlayers()) do
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

local HitCritical = false
spawn(function()
	local Criticals = CombatTab:CreateToggle({
		Name = "Criticals",
		Callback = function(callback)
			if callback then
				HitCritical = true
			else
				HitCritical = false
			end
		end
	})
end)

local KillAuraSortMode, KillAuraTeamCheck, KillAuraBlock, IsKillAuraEnabled = nil, nil, nil, nil
spawn(function()
	local Loop, Range, Swing = nil, nil, false
	local Sword = nil

	local KillAura = CombatTab:CreateToggle({
		Name = "Kill Aura",
		Callback = function(callback)
			IsKillAuraEnabled = callback
			if callback then
				Loop = RunService.RenderStepped:Connect(function()
					if IsAlive(LocalPlayer) then
						local Target = GetNearestPlayer(Range, KillAuraSortMode, KillAuraTeamCheck)
						if Target then
							Sword = CheckTool("Sword")
							if Sword then
								if KillAuraBlock == "Packet" then
									local args = {
										[1] = true,
										[2] = Sword.Name
									}
									game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
								elseif KillAuraBlock == "None" then
									local args = {
										[1] = false,
										[2] = Sword.Name
									}
									game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
								end
								if Swing and KillAuraBlock == "None" then
									Sword:Activate()
								end
								local args = {
									[1] = Target.Character,
									[2] = HitCritical,
									[3] = Sword.Name
								}
								game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("AttackPlayerWithSword"):InvokeServer(unpack(args))
							else
								if KillAuraBlock == "Packet" then
									local args = {
										[1] = false,
										[2] = Sword.Name
									}
									game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
								end
							end
						else
							if KillAuraBlock == "Packet" then
								local args = {
									[1] = false,
									[2] = Sword.Name
								}
								game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
							end
						end
					else
						repeat
							task.wait()
						until IsAlive(LocalPlayer)
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
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
	local Loop, TPRange, OldCameraType, OldCameraSubject = nil, nil, game.Workspace.CurrentCamera.CameraType, game.Workspace.CurrentCamera.CameraSubject 
	local Sword = nil
	local TeleportAura = CombatTab:CreateToggle({
		Name = "Teleport Aura",
		Callback = function(callback)
			if callback then
				Loop = RunService.Heartbeat:Connect(function()
					if IsKillAuraEnabled then
						if IsAlive(LocalPlayer) then
							local Target = GetNearestPlayer(TPRange, KillAuraSortMode, KillAuraTeamCheck)
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
										local InfiniteTween = TweenService:Create(LocalPlayer.Character:WaitForChild("HumanoidRootPart"), TweenInfo.new(0.08), {CFrame = CFrame.new(TargetPosition.Position.X, TargetPosition.Position.Y - 6, TargetPosition.Position.Z)})
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
								until IsAlive(LocalPlayer)
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
--[[
spawn(function()
	local VelocityMethod = nil
	local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local Remote
	local OldFireServer, OldRemote,OldConnect
	local Velocity = CombatTab:CreateToggle({
		Name = "Velocity",
		Callback = function(callback)
			if callback then
				Remote = game:GetService("ReplicatedStorage").Packages.Knit.Services.CombatService.RE.KnockBackApplied
				if Remote then
					if VelocityMethod == "Hookfunction" then
						OldFireServer = Remote.FireServer
						Remote.FireServer = hookfunction(OldFireServer, function(self, ...)
							local args = {...}
							game:GetService("StarterGui"):SetCore("SendNotification", { 
								Title = "Lime",
								Text = "Velocity Debug",
							})
							return
						end)
					elseif VelocityMethod == "Hookmetamethod" then
						OldRemote = hookmetamethod(game, "__namecall", function(self, ...)
							local args = {...}
							local method = getnamecallmethod()
							if self == Remote and method == "FireServer" then
								game:GetService("StarterGui"):SetCore("SendNotification", { 
									Title = "Lime",
									Text = "Velocity Debug",
								})
								return false
							end
							return OldRemote(self, unpack(args))
						end)
					elseif VelocityMethod == "Hooksignal" then
						OldConnect = Remote.OnServerEvent
						Remote.OnServerEvent = hooksignal(OldConnect, function(player, ...)
							local args = {...}
							game:GetService("StarterGui"):SetCore("SendNotification", { 
								Title = "Lime",
								Text = "Velocity Debug",
							})
							return
						end)
					end
				end
			else
				Remote = nil
				if VelocityMethod == "Hooksignal" then
					unhooksignal(Remote.OnServerEvent)
				elseif VelocityMethod == "Hookfunction" then
					Remote.FireServer = OldFireServer
				elseif VelocityMethod == "Hookmetamethod" then
					OldRemote:Disconnect()
				end
			end
		end
	})
	local VelocityMode = Velocity:CreateDropdown({
		Name = "Velocity Mode",
		List = {"Hookfunction", "Hookmetamethod", "Hooksignal"},
		Default = "Hookmetamethod",
		Callback = function(callback)
			if callback then
				VelocityMethod = callback
			end
		end
	})
end)
--]]

spawn(function()
	local Loop, Reported = nil, {}
	local AutoReport = ExploitTab:CreateToggle({
		Name = "Auto Report",
		Callback = function(callback)
			if callback then
				Loop = RunService.Heartbeat:Connect(function()
					for i, v in pairs(Players:GetPlayers()) do
						if v and v ~= LocalPlayer and not table.find(Reported, v.Name) then
							table.insert(Reported, v.Name)
							local args = {
								[1] = v.Name
							}
							game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("NetworkService"):WaitForChild("RF"):WaitForChild("ReportPlayer"):InvokeServer(unpack(args))
							game:GetService("StarterGui"):SetCore("SendNotification", { 
								Title = "Lime | Auto Report",
								Text = "Reported " .. v.Name,
								Icon = Players:GetUserThumbnailAsync(v.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size60x60),
								Duration = 3,
							})

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
end)

spawn(function()
	local Loop, AutoLeave, IsStaff = nil, false, false
	local Detector = ExploitTab:CreateToggle({
		Name = "Detector",
		Callback = function(callback)
			if callback then
				Loop = RunService.Heartbeat:Connect(function()
					local Staff = GetStaff()
					if Staff and not IsStaff then
						IsStaff = true
						PlaySound(4809574295)
						game:GetService("StarterGui"):SetCore("SendNotification", { 
							Title = "Lime | Staff",
							Text = Staff.Name .. " " .. Staff.DisplayName .. " " .. Staff.UserId,
							Icon = Players:GetUserThumbnailAsync(Staff.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size60x60),
							Duration = 10,
						})
						
						if AutoLeave then
							LocalPlayer:Kick("Detected: " .. Staff.Name .. " " .. Staff.DisplayName .. " " .. Staff.UserId)
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

spawn(function()
	local DisablerType = nil
	local Disabler = ExploitTab:CreateToggle({
		Name = "Disabler",
		Callback = function(callback)
			if callback then
				if DisablerType == "Playground" then
					if game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):FindFirstChild("PlaygroundService") then
						local args = {
							[1] = false
						}

						game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlaygroundService"):WaitForChild("RF"):WaitForChild("SetAntiCheat"):InvokeServer(unpack(args))
					end
				end
			else
				local args = {
					[1] = true
				}

				game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlaygroundService"):WaitForChild("RF"):WaitForChild("SetAntiCheat"):InvokeServer(unpack(args))

			end
		end
	})
	local DisablerMode = Disabler:CreateDropdown({
		Name = "Disabler Modes",
		List = {"Playground"},
		Default = "Playground",
		Callback = function(callback)
			if callback then
				DisablerType = callback
			end
		end
	})
end)

spawn(function()
	local HumanoidRootPartY = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y
	local Loop, Speed, FlyMode, YPos = nil, nil, nil, 0
	local Boost, Start, Duration, BoostValue, OldBoost = false, nil, nil, nil, nil
	local OldGravity, Velocity = game.Workspace.Gravity, nil
	
	UserInputService.InputBegan:Connect(function(Input, IsTyping)
		if IsTyping then return end
		if Input.KeyCode == Enum.KeyCode.LeftShift or Input.KeyCode == Enum.KeyCode.Q then
			YPos = YPos - 3
		elseif Input.KeyCode == Enum.KeyCode.Space then
			YPos = YPos + 3
		end
	end)
	
	local Flight = MoveTab:CreateToggle({
		Name = "Flight",
		Callback = function(callback)
			if callback then
				YPos = 0
				HumanoidRootPartY = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y
				if Boost ~= false then
					OldBoost = Boost
				end
				Loop = RunService.Heartbeat:Connect(function()
					if IsAlive(LocalPlayer) then
						if Boost then
							if Start == nil then
								Start = tick()
							end
							if (tick() - Start) < 0.32 then
								Velocity = LocalPlayer.Character.Humanoid.MoveDirection * (Speed + BoostValue)
							else
								Start = nil
								Boost = false
								Velocity = LocalPlayer.Character.Humanoid.MoveDirection * (Speed - BoostValue)
							end
						else
							Velocity = LocalPlayer.Character.Humanoid.MoveDirection * Speed
						end
						LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, Velocity.Z)
						if FlyMode == "Float" then
							game.Workspace.Gravity = 0
							LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.X, HumanoidRootPartY + YPos, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Z) * LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.Rotation
						elseif FlyMode == "Jump" then
							repeat
								wait()
							until Humanoid:GetState() == Enum.HumanoidStateType.Freefall and LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y <= (HumanoidRootPartY - Humanoid.HipHeight) + YPos
							Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
						end
					else
						repeat
							task.wait()
						until IsAlive(LocalPlayer)
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				if OldBoost then
					Boost = true
				end
				Velocity, Start = nil, nil
				game.Workspace.Gravity = OldGravity
				HumanoidRootPartY =  LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y
				LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
			end
		end
	})
	local FlightMode = Flight:CreateDropdown({
		Name = "Flight Mode",
		List = {"Float", "Jump"},
		Default = "Float",
		Callback = function(callback)
			if callback then
				FlyMode = callback
			end
		end
	})
	local FlightSpeed = Flight:CreateSlider({
		Name = "Speed",
		Min = 0,
		Max = 32,
		Default = 32,
		Callback = function(callback)
			if callback then
				Speed = callback
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
	local FlightBoostValue = Flight:CreateSlider({
		Name = "Boost",
		Min = 0,
		Max = 8,
		Default = 4,
		Callback = function(callback)
			if callback then
				BoostValue = callback
			end
		end
	})
end)

spawn(function()
	local Loop = nil
	local NoSlow = MoveTab:CreateToggle({
		Name = "No Slow",
		Callback = function(callback)
			if callback then
				Loop = Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
					if IsAlive(LocalPlayer) then
						if Humanoid.WalkSpeed ~= 16 then
							Humanoid.WalkSpeed = 16
						end
					else
						repeat
							task.wait()
						until IsAlive(LocalPlayer)
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				Humanoid.WalkSpeed = 16
			end
		end
	})
end)

spawn(function()
	local Loop, SpeedVal, AutoJump = nil, nil, false
	
	local Speed = MoveTab:CreateToggle({
		Name = "Speed",
		Callback = function(callback)
			if callback then
				Loop = RunService.Heartbeat:Connect(function()
					if IsAlive(LocalPlayer) then
						local Velocity = LocalPlayer.Character.Humanoid.MoveDirection * SpeedVal
						LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, Velocity.Z)
						if AutoJump then
							spawn(function()
								Humanoid.Jump = true
							end)
						end
					else
						repeat
							task.wait()
						until IsAlive(LocalPlayer)
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Z)
			end
		end
	})
	local SpeedSpeedValue = Speed:CreateSlider({
		Name = "Speed",
		Min = 0,
		Max = 32, 
		Default = 28,
		Callback = function(callback)
			if callback then
				SpeedVal = callback
			end
		end
	})
	local SpeedAutoJump = Speed:CreateMiniToggle({
		Name = "Auto Jump",
		Callback = function(callback)
			if callback then
				AutoJump = true
			else
				AutoJump = false
			end
		end
	})
end)

spawn(function()
	local OldAmbience, OldBrightness = Lighting.Ambient, Lighting.Brightness
	local Loop = nil
	
	local Fullbright = VisualTab:CreateToggle({
		Name = "Fullbright",
		Callback = function(callback)
			if callback then
				Loop = RunService.Heartbeat:Connect(function()
					Lighting.Ambient = Color3.fromRGB(255, 255, 255)
					Lighting.Brightness = 10
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				Lighting.Ambient = OldAmbience
				Lighting.Brightness = OldBrightness
			end
		end
	}) 
end)

spawn(function()
	local Loop, Ticks = false, nil

	local FastPlace = PlayerTab:CreateToggle({
		Name = "Fast Place",
		Callback = function(callback)
			Loop = callback
			if callback then
				if IsAlive(LocalPlayer) then
					repeat
						wait(1 / Ticks)
						local Tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
						if Tool and Tool.Name:match("Blocks") then
							if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
								Tool:Activate()
							end
						end
					until not Loop
				else
					repeat
						task.wait()
					until IsAlive(LocalPlayer)
				end
			end
		end
	})
	local FastPlaceCPS = FastPlace:CreateSlider({
		Name = "Ticks",
		Min = 0,
		Max = 100,
		Default = 20,
		Callback = function(callback)
			Ticks = callback
		end
	})
end)

spawn(function()
	local SelectedMode = nil
	
	local Phase = PlayerTab:CreateToggle({
		Name = "Phase",
		AutoDisable = true,
		Callback = function(callback)
			if callback then
				if SelectedMode == "VClip" then
					LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position - Vector3.new(0, 6, 0))
				elseif SelectedMode == "HClip" then
					LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position + Vector3.new(0, 9, 0))
				elseif SelectedMode == "Collide" then
					LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position - Vector3.new(0, 5, 0))
					for i,v in pairs(LocalPlayer.Character:GetChildren()) do
						if v:IsA("MeshPart") then
							v.CanCollide = false
						end
					end
					for i,v in pairs(LocalPlayer.Character:GetChildren()) do
						if v:IsA("Part") and v.Name == "HumanoidRootPart" then
							v.CanCollide = false
						end
					end
				end
			else
				for i,v in pairs(LocalPlayer.Character:GetChildren()) do
					if v:IsA("MeshPart") and v.Name == "LowerTorso" and "UpperTorso" then
						v.CanCollide = true
					end
				end
				for i,v in pairs(LocalPlayer.Character:GetChildren()) do
					if v:IsA("Part") and v.Name == "HumanoidRootPart" then
						v.CanCollide = true
					end
				end
			end
		end
	})
	local PhaseMode = Phase:CreateDropdown({
		Name = "Phase Modes",
		List = {"VClip", "HClip", "Collide"},
		Default = "VClip",
		Callback = function(callback)
			if callback then
				SelectedMode = callback
			end
		end
	})
end)
--[[
spawn(function()
	local Event = nil
	local function Kill(plr)
		local messages = {
			"Lime Yummy🤤",
			"Lime might not be the best, but it can still beat you " .. plr.Name,
			"Eternal rebrand is the best (Lime)"
		}
		return messages[math.random(1, #messages)]
	end
	local function Dead(plr)
		local messages = {
			"Wow what a pro, is that right? " .. plr.Name,
			"Someone that can defeat me probably uses cheats too!"
		}
		return messages[math.random(1, #messages)]
	end

	local AutoToxic = PlayerTab:CreateToggle({
		Name = "Auto Toxic",
		Callback = function(enabled)
			if enabled then
				Event = game:GetService("ReplicatedStorage").Packages.Knit.Services.CombatService.RE.OnKill
				if Event then
					Event.OnClientEvent:Connect(function(alive, dead, ...)
						if alive.Name == LocalPlayer.Name and dead.Name ~= LocalPlayer.Name then
							local KillMessage = Kill(dead)
							local args = {
								[1] = KillMessage,
								[2] = "All"
							}
							game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(unpack(args))
						elseif alive.Name ~= LocalPlayer.Name and dead.Name == LocalPlayer.Name then
							local DeadMessage = Dead(alive)
							local args = {
								[1] = DeadMessage,
								[2] = "All"
							}
							game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(unpack(args))
						end
					end)
				end
			else
				Event = nil
			end
		end
	})
end)
--]]
spawn(function()
	local Loop, LastPosition, Mode, ShowLastPos, AlwaysTrack = nil, nil, nil, false, false

	local PositionHighlight = Instance.new("Part")
	PositionHighlight.Size = Vector3.new(3, 0.4, 3)
	PositionHighlight.Anchored = true
	PositionHighlight.CanCollide = false
	PositionHighlight.Material = Enum.Material.Neon
	PositionHighlight.CastShadow = false
	PositionHighlight.Color = Color3.new(0.815686, 0.0745098, 1)
	PositionHighlight.Transparency = 1
	PositionHighlight.Parent = game.Workspace

	local AntiVoid = PlayerTab:CreateToggle({
		Name = "Anti Void",
		Callback = function(callback)
			if callback then
				LastPosition = LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position
				Loop = RunService.Heartbeat:Connect(function()
					if IsAlive(LocalPlayer) then
						if ShowLastPos then
							PositionHighlight.Transparency = 0.75
						else
							PositionHighlight.Transparency = 1
						end
						if AlwaysTrack then
							if Humanoid.FloorMaterial ~= Enum.Material.Air then
								LastPosition = LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position
								PositionHighlight.Position = LastPosition - Vector3.new(0, 2.8, 0)
							end
						else
							Humanoid:GetPropertyChangedSignal("FloorMaterial"):Connect(function()
								if Humanoid.FloorMaterial ~= Enum.Material.Air then
									LastPosition = LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position
									PositionHighlight.Position = LastPosition - Vector3.new(0, 2.8, 0)
								end
							end)
						end
						if LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position.Y < -132 then
							if Mode == "TP" then
								LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(LastPosition + Vector3.new(0, 15, 0))
							elseif Mode == "Tween" then
								local TweenY = TweenService:Create(LocalPlayer.Character:WaitForChild("HumanoidRootPart"), TweenInfo.new(0.1), {CFrame = CFrame.new(LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position.X, LastPosition.Y + 9, LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position.Z)})
								TweenY:Play()
								TweenY.Completed:Wait(1)
								local TweenX = TweenService:Create(LocalPlayer.Character:WaitForChild("HumanoidRootPart"), TweenInfo.new(0.1), {CFrame = CFrame.new(LastPosition.X, LastPosition.Y + 9, LastPosition.Z)})
								TweenX:Play()
							end
						end
					else
						repeat
							task.wait()
						until IsAlive(LocalPlayer)
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
	local AntiVoidTrack = AntiVoid:CreateMiniToggle({
		Name = "Always Track",
		Callback = function(callback)
			if callback then
				AlwaysTrack = true
			else
				AlwaysTrack = false
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
	local DefaultPos = Vector3.new(0, 0, 0)
	local Loop, Expand, Swings = nil, nil, false
	local Scaffold = WorldTab:CreateToggle({
		Name = "Scaffold",
		Callback = function(callback)
			if callback then
				Loop = RunService.RenderStepped:Connect(function()
					if IsAlive(LocalPlayer) then
						for i = 1, Expand do
							local PlacePos = GetPlace(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position + Humanoid.MoveDirection * (i * 3.5) - Vector3.yAxis * ((LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Size.Y / 2) + Humanoid.HipHeight + 1.5))
							if PlacePos then
							DefaultPos = PlacePos
							UserInputService.InputBegan:Connect(function(Input, IsTyping)
								if IsTyping then return end
								if Input.KeyCode == Enum.KeyCode.LeftShift or Input.KeyCode == Enum.KeyCode.Q then
									PlacePos = PlacePos - Vector3.yAxis * 3.5
								end
							end)
							if Swings then
								local Tools = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
								if Tools then
									Tools:Activate()
								end
							end
							local args = {
								[1] = PlacePos
							}

							game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("PlaceBlock"):InvokeServer(unpack(args))
							end
						end
					else
						repeat
							task.wait()
						until IsAlive(LocalPlayer)
					end
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				DefaultPos = Vector3.new(0, 0, 0)
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
	local ScaffoldSwing = Scaffold:CreateMiniToggle({
		Name = "Swing",
		Callback = function(callback)
			if callback then
				Swings = true
			else
				Swings = false
			end
		end
	})
end)

spawn(function()
	local OldTime, NewTime = Lighting.ClockTime, nil
	local Loop = nil
	local TimeChanger = WorldTab:CreateToggle({
		Name = "Time Changer",
		Callback = function(callback)
			if callback then
				Loop = RunService.Heartbeat:Connect(function()
					Lighting.ClockTime = NewTime
				end)
			else
				if Loop ~= nil then
					Loop:Disconnect()
				end
				Lighting.ClockTime = OldTime
			end
		end
	})
	local TimeChangerClock = TimeChanger:CreateSlider({
		Name = "Time",
		Min = 0,
		Max = 24,
		Default = 18,
		Callback = function(callback)
			if callback then
				NewTime = callback
			end
		end
	})
end)
