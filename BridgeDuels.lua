local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/EternalForRoblox/main/Library.lua"))()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
local CurrentCamera = game.Workspace.CurrentCamera
local Main = Library:CreateMain()
local Tabs = {
	Combat = Main:CreateTab("Combat", false),
	Movement = Main:CreateTab("Movement", false),
	Player = Main:CreateTab("Player", false),
	Render = Main:CreateTab("Render", false),
	Exploit = Main:CreateTab("Exploit", false),
	Misc = Main:CreateTab("Misc", true)
}

--[[ Not Used
game:GetService("ReplicatedStorage").__comm__.RP.gamemode:FireServer()
game:GetService("ReplicatedStorage").Remotes.Jumpscare:FireServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.CombatService.RE.OnKill:FireServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.VoidService.RE.OnFell:FireServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.ModerationService.RF.Ban:InvokeServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.ModerationService.RF.Unban:InvokeServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.NetworkService.RF.SendReport:InvokeServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.GuildService.RF.KickPlayer:InvokeServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.CombatService.RE.KnockBackApplied:FireServer()
--]]


function IsAlive(entity)
	return entity and entity.Character and entity.Character:FindFirstChildOfClass("Humanoid") and entity.Character:FindFirstChildOfClass("Humanoid").Health > 0
end

function GetPlayer(MaxDist, Mode)
	local Nearest, MinDist

	for i, v in pairs(Players:GetChildren()) do
		if v ~= LocalPlayer and IsAlive(v) then
			local Distance = (v.Character:FindFirstChild("HumanoidRootPart").Position - LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
			if Mode == "Distance" then
				if Distance <= MaxDist and (not MinDist or Distance < MinDist) then
					MinDist = Distance
					Nearest = v
				end
			elseif Mode == "Health" then
				local Humanoid = v.Character:FindFirstChild("Humanoid")
				if Humanoid then
					local Health = Humanoid.Health
					if Distance <= MaxDist and (not MinDist or Health < MinDist) then
						MinDist = Health
						Nearest = v
					end
				end
			end
		end
	end
	return Nearest
end

function GetTools(name)
	local TooResults
	for _,tool in pairs(LocalPlayer.Backpack:GetChildren()) do
		if tool:IsA("Tool") and tool.Name:match(name) then
			TooResults = tool
		end
	end
	return TooResults
end

function CheckTools(name)
	local TooResults
	for _,tool in pairs(LocalPlayer.Character:GetChildren()) do
		if tool:IsA("Tool") and tool.Name:match(name) then
			TooResults = tool
		end
	end
	return TooResults
end

function BowFire(pos, power)
	local Bow = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
	if Bow.Name:match("Bow") then
		Bow:WaitForChild("__comm__"):WaitForChild("RF"):FindFirstChild("Fire"):InvokeServer({
			[1] = pos,
			[2] = power
		})
	end
end

function PlaceFire(pos)
	ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("PlaceBlock"):InvokeServer({
		[1] = pos
	})
end

spawn(function()
	local Enabled, Hold, HoldType, Distance, Aim = false, false, nil, nil, nil
	local Direction = Vector3.zero
	local AimAssist = Tabs.Combat:CreateToggle({
		Name = "AimAssist",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					wait(0.01)
					local Player = GetPlayer(Distance, "Distance")
					if Aim == "Head" then
						Direction = (Player.Character:FindFirstChild("Head").Position - CurrentCamera.CFrame.Position).unit
					elseif Aim == "Torso" then
						Direction = (Player.Character:FindFirstChild("HumanoidRootPart").Position - CurrentCamera.CFrame.Position).unit
					elseif Aim == "Leg" then
						Direction = (Player.Character:FindFirstChild("LowerTorso").Position - CurrentCamera.CFrame.Position).unit
					end
					local NewCFrame = CFrame.new(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.Position + Direction)
					if Hold then
						if Player then
							if UserInputService:IsMouseButtonPressed(Enum.UserInputType[HoldType]) then
								CurrentCamera.CFrame = NewCFrame
							end
						else
							CurrentCamera.CFrame = NewCFrame
						end
					end
				until not Enabled
			end
		end
	})
	local CustomDirection = AimAssist:CreateDropdown({
		Name = "Directions",
		List = {"Head", "Torso", "Leg"},
		Default = "Torso",
		Callback = function(callback)
			if callback then
				Aim = callback
			end
		end
	})
	local CustomHoldType = AimAssist:CreateDropdown({
		Name = "Type",
		List = {"MouseButton1", "MouseButton2"},
		Default = "MouseButton1",
		Callback = function(callback)
			if callback then
				HoldType = callback
			end
		end
	})
	local HoldMode = AimAssist:CreateMiniToggle({
		Name = "Hold",
		Enabled = true,
		Callback = function(callback)
			Hold = callback
		end
	})
	local CustomDistance = AimAssist:CreateSlider({
		Name = "Distances",
		Min = 0,
		Max = 100,
		Default = 20,
		Callback = function(callback)
			if callback then
				Distance = callback
			end
		end
	})
end)

spawn(function()
	local Enabled, CPS = false, nil
	local AutoClicker = Tabs.Combat:CreateToggle({
		Name = "AutoClicker",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					wait(1 / CPS)
					local Tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
					if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
						if Tool then
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
		Default = 12,
		Callback = function(callback)
			if callback then
				CPS = callback
			end
		end
	})
end)

spawn(function()
	local Enabled, Distance, Sword = false, nil, nil
	local AutoSword = Tabs.Combat:CreateToggle({
		Name = "AutoSword",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					wait()
					local Player = GetPlayer(Distance, "Distance")
					Sword = GetTools("Sword")
					if Players then
						if Sword then
							Humanoid:EquipTool(Sword)
						end
					end
				until not Enabled
				Humanoid:UnequipTools(Sword)
			end
		end
	})
	local CustomDistance = AutoSword:CreateSlider({
		Name = "Distance",
		Min = 0,
		Max = 100,
		Default = 20,
		Callback = function(callback)
			if callback then
				Distance = callback
			end
		end
	})
end)

local HitCrit = false
spawn(function()
	local Criticals = Tabs.Combat:CreateToggle({
		Name = "Criticals",
		Callback = function(callback)
			if callback then
				HitCrit = true
			else
				HitCrit = false
			end
		end
	})
end)

spawn(function()
	local function KillRandom(plr)
		local Messages = {
			"Ez " .. plr.Name,
			"Im the best!, is that right " .. plr.Name .. "?",
			"Train harder unless you wanna be this noob called " .. plr.Name
		}
		return Messages[math.random(1, #Messages)]
	end

	local function DiedRandom(plr)
		local Messages = {
			"Lag! Real! ",
			"Oops, " .. plr.Name .. ", You Cheater!"
		}
		return Messages[math.random(1, #Messages)]
	end

	local function SendMessages(msg)
		local args = {
			[1] = msg,
			[2] = "All"
		}
		game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(unpack(args))
	end

	local Enabled = false
	local KillSults = Tabs.Combat:CreateToggle({
		Name = "KillSults",
		Callback = function(callback)
			Enabled = callback
			if callback then
				game:GetService("ReplicatedStorage").Packages.Knit.Services.CombatService.RE.OnKill.OnClientEvent:Connect(function(killer, killed, ...)
					if Enabled then
						if  killer.Name == LocalPlayer.Name and killed.Name ~= LocalPlayer.Name then
							local message = KillRandom(killed)
							SendMessages(message)
						elseif killer.Name ~= LocalPlayer.Name and killed.Name == LocalPlayer.Name then
							local message = DiedRandom(killer)
							SendMessages(message)
						end
					end
				end)
			end
		end
	})
end)

local KillAuraDistance = nil
local KillAuraPlayerModes = nil
spawn(function()
	local Enabled, BlockingMode = false, nil
	local BlockAnim, SwingAnim
	local KillAura = Tabs.Combat:CreateToggle({
		Name = "KillAura",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					wait()
					if IsAlive(LocalPlayer) then
						local Player = GetPlayer(KillAuraDistance, KillAuraPlayerModes)
						if Player then
							local Sword = CheckTools("Sword")
							if Sword then
								BlockAnim = Sword:WaitForChild("Animations").BlockHit
								SwingAnim = Sword:WaitForChild("Animations").Swing
								if BlockingMode == "Fake" then
									Humanoid:LoadAnimation(BlockAnim):Play()
									local args = {
										[1] = false,
										[2] = Sword.Name
									}
									game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
								elseif	BlockingMode == "Remote" then
									Humanoid:LoadAnimation(BlockAnim):Stop()
									local args = {
										[1] = true,
										[2] = Sword.Name
									}
									game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
								elseif BlockingMode == "SemiLegit" then
									Humanoid:LoadAnimation(BlockAnim):Play()
									local args = {
										[1] = true,
										[2] = Sword.Name
									}
									game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
								end
								local args = {
									[1] = Player.Character,
									[2] = HitCrit,
									[3] = Sword.Name
								}
								game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("AttackPlayerWithSword"):InvokeServer(unpack(args))
							end
						end
					end
				until not Enabled
			end
		end
	})
	local CustomKillAuraPlayerModes = KillAura:CreateDropdown({
		Name = "PlayerMode",
		List = {"Distance", "Health"},
		Default = "Distance",
		Callback = function(callback)
			if callback then
				KillAuraPlayerModes = callback
			end
		end
	})
	local CustomBlockingMode = KillAura:CreateDropdown({
		Name = "BlockingMode",
		List = {"Fake", "Remote", "SemiLegit"},
		Default = "Fake",
		Callback = function(callback)
			if callback then
				BlockingMode = callback
			end
		end
	})
	local CustomDistance = KillAura:CreateSlider({
		Name = "Distance",
		Min = 0,
		Max = 20,
		Default = 20,
		Callback = function(callback)
			if callback then
				KillAuraDistance = callback
			end
		end
	})
end)

--Velocity
--[[
spawn(function()
	local Enabled = false
	local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local Velocity = Tabs.Combat:CreateToggle({
		Name = "Velocity",
		Callback = function(callback)
			Enabled = callback
			if callback then
				ReplicatedStorage.Packages.Knit.Services.CombatService.RE.KnockBackApplied.OnClientEvent:Connect(function()
					if Enabled then
						HumanoidRootPart.Anchored = true
						wait(1)
						HumanoidRootPart.Anchored = false
					end
				end)
			end
		end
	})
end)
--]]

spawn(function()
	local Enabled, Speed, YPos = false, nil, 0
	local HumanoidRootPartY = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y
	local OldGravity = game.Workspace.Gravity

	UserInputService.JumpRequest:Connect(function()
		YPos = YPos + 6
	end)
	UserInputService.InputBegan:Connect(function(Input, IsTyping)
		if IsTyping then return end
		if Input.KeyCode == Enum.KeyCode.LeftShift then
			YPos = YPos - 6
		end
	end)

	local Fly = Tabs.Movement:CreateToggle({
		Name = "Fly",
		Callback = function(callback)
			Enabled = callback
			if callback then
				YPos = 0
				HumanoidRootPartY = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y
				repeat
					task.wait()
					local Motion = LocalPlayer.Character.Humanoid.MoveDirection * Speed
					LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(Motion.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, Motion.Z)
					LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.X, HumanoidRootPartY + YPos, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Z) * LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.Rotation
					game.Workspace.Gravity = 0
				until not Enabled
				YPos = 0
				game.Workspace.Gravity = OldGravity
				HumanoidRootPartY =  LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y
				LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
			end
		end
	})
	local CustomSpeed = Fly:CreateSlider({
		Name = "Speed",
		Min = 0,
		Max = 38,
		Default = 28,
		Callback = function(callback)
			if callback then
				Speed = callback
			end
		end
	})
end)

spawn(function()
	local Enabled, Boost = false, nil
	local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local HighJump = Tabs.Movement:CreateToggle({
		Name = "HighJump",
		AutoDisable = true,
		Callback = function(callback)
			Enabled = callback
			if callback then
				local OldBodyVelocity = LocalPlayer.Character:FindFirstChildWhichIsA("BodyVelocity")
				if OldBodyVelocity then
					OldBodyVelocity:Destroy()
				end
				local NewBodyVelocity = Instance.new("BodyVelocity")
				NewBodyVelocity.Velocity = Vector3.new(0, Boost, 0)
				NewBodyVelocity.P = Boost
				NewBodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
				NewBodyVelocity.Parent = HumanoidRootPart
			else
				wait(0.3)
				local OldBodyVelocity = HumanoidRootPart:FindFirstChildWhichIsA("BodyVelocity")
				if OldBodyVelocity then
					OldBodyVelocity:Destroy()
				end
			end
		end
	})
	local CustomBoost = HighJump:CreateSlider({
		Name = "Boost",
		Min = 0,
		Max = 220,
		Default = 140,
		Callback = function(callback)
			if callback then
				Boost = callback
			end
		end
	})
end)

spawn(function()
	local Boost = nil
	local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local LongJump = Tabs.Movement:CreateToggle({
		Name = "LongJump",
		AutoDisable = true,
		Enabled = false,
		Callback = function(enabled)
			if enabled then
				if HumanoidRootPart then
					spawn(function()
						Humanoid.Jump = true
					end)
					local Motion = HumanoidRootPart.CFrame.LookVector * Boost
					HumanoidRootPart.Velocity = Vector3.new(Motion.X, HumanoidRootPart.Velocity.Y, Motion.Z)
				end
			end
		end
	})
	local CustomBoostL = LongJump:CreateSlider({
		Name = "Boost",
		Min = 50,
		Max = 100,
		Default = 65,
		Callback = function(value)
			Boost = value
		end
	})
end)

spawn(function()
	local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local Enabled, Diagonal, Expand = false, false, 1
	local DefaultPos = Vector3.zero

	local function GetPlacePos(pos, diagonalmode)
		local NewPos = Vector3.new(math.floor((pos.X / 3) + 0.5) * 3, math.floor((pos.Y / 3) + 0.5) * 3, math.floor((pos.Z / 3) + 0.5) * 3)
		local Offset = (DefaultPos - NewPos)
		if IsAlive(LocalPlayer) then
			local HumanoidAngle = math.deg(math.atan2(-Humanoid.MoveDirection.X, -Humanoid.MoveDirection.Z))
			local DiagonalCheck = (HumanoidAngle >= 130 and HumanoidAngle <= 150) or (HumanoidAngle <= -35 and HumanoidAngle >= -50) or (HumanoidAngle >= 35 and HumanoidAngle <= 50) or (HumanoidAngle <= -130 and HumanoidAngle >= -150)
			if DiagonalCheck and ((NewPos.X == 0 and NewPos.Z ~= 0) or (NewPos.X ~= 0 and NewPos.Z == 0)) and diagonalmode then
				return DefaultPos
			end
		end
		return NewPos
	end

	local Scaffold = Tabs.Movement:CreateToggle({
		Name = "Scaffold",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					task.wait()
					if IsAlive(LocalPlayer) then
						for i = 1, Expand do
							local PlacePos = GetPlacePos((HumanoidRootPart.Position + (Humanoid.MoveDirection * (i * 3.5))) + Vector3.new(0, -((HumanoidRootPart.Size.Y / 2) + Humanoid.HipHeight + 1.5)), Diagonal)
							PlacePos = Vector3.new(PlacePos.X, PlacePos.Y, PlacePos.Z)
							local args = {
								[1] = PlacePos
							}

							game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("PlaceBlock"):InvokeServer(unpack(args))
							if Expand > 1 then
								task.wait()
							end
							DefaultPos = PlacePos
						end
					end
				until not Enabled
				DefaultPos = Vector3.zero
			end
		end
	})
	local DiagonalMode = Scaffold:CreateMiniToggle({
		Name = "Diagonal",
		Enabled = true,
		Callback = function(callback)
			if callback then
				Diagonal = true
			else
				Diagonal = false
			end
		end
	})
end)

spawn(function()
	local Enabled, NewSpeed, Mode = true, nil, nil
	local OldGravity = game.Workspace.Gravity
	local OldJumpHeight = Humanoid.JumpHeight
	local OldWalkspeed = Humanoid.WalkSpeed
	local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local Speed = Tabs.Movement:CreateToggle({
		Name = "Speed",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					task.wait()
					if IsAlive(LocalPlayer) then
						if Mode == "WalkSpeed" then
							Humanoid.JumpHeight = OldJumpHeight
							Humanoid.WalkSpeed = NewSpeed
						elseif Mode == "Hop" then
							game.Workspace.Gravity = 82
							Humanoid.WalkSpeed = OldWalkspeed
							local velo = LocalPlayer.Character.Humanoid.MoveDirection * NewSpeed
							HumanoidRootPart.Velocity = Vector3.new(velo.X, HumanoidRootPart.Velocity.Y, velo.Z)
							spawn(function()
								while Enabled do
									wait()
									Humanoid.Jump = true
								end
							end)
						elseif Mode == "LowHop" then
							Humanoid.WalkSpeed = OldWalkspeed
							game.Workspace.Gravity = OldGravity
							Humanoid.JumpHeight = 0.20
							local velo = LocalPlayer.Character.Humanoid.MoveDirection * NewSpeed
							HumanoidRootPart.Velocity = Vector3.new(velo.X, HumanoidRootPart.Velocity.Y, velo.Z)
							spawn(function()
								while Enabled do
									wait()
									Humanoid.Jump = true
								end
							end)
						end
					end
				until not Enabled
				Humanoid.WalkSpeed = OldWalkspeed
				game.Workspace.Gravity = OldGravity
				Humanoid.JumpHeight = OldJumpHeight
			end
		end
	})
	local CustomSpeedMode = Speed:CreateDropdown({
		Name = "SpeedMode",
		List = {"WalkSpeed", "Hop", "LowHop"},
		Default = "Hop",
		Callback = function(callback)
			if callback then
				Mode = callback
			end
		end
	})
	local CustomSpeed = Speed:CreateSlider({
		Name = "Speed",
		Min = 0,
		Max = 50,
		Default = 28,
		Callback = function(callback)
			if callback then
				NewSpeed = callback
			end
		end
	})
end)

spawn(function()
	local Blurz, Size, Enabled = nil, nil, false
	local Blur = Tabs.Render:CreateToggle({
		Name = "Blur",
		Callback = function(callback)
			Enabled = callback
			if callback then
				if not Lighting:FindFirstChildWhichIsA("BlurEffect") then
					Blurz = Instance.new("BlurEffect")
					Blurz.Parent = Lighting
				end
				repeat
					wait()
					Blurz.Size = Size
				until not Enabled
			else
				if Blurz then
					Blurz:Destroy()
				end
			end
		end
	})
	local CustomSize = Blur:CreateSlider({
		Name = "Size",
		Min = 0,
		Max = 100,
		Default = 28,
		Callback = function(callback)
			if callback then
				Size = callback
			end
		end
	})
end)

spawn(function()
	local function Hightlight(player)
		if player ~= LocalPlayer and IsAlive(player) then
			if not player.Character:FindFirstChildOfClass("Highlight") then
				local highlight = Instance.new("Highlight")
				highlight.Parent = player.Character
				highlight.FillTransparency = 1
				highlight.OutlineTransparency = 0.45
			end
		end
	end

	local function RemoveHighlight(player)
		if player ~= LocalPlayer and IsAlive(player) and player.Character:FindFirstChildOfClass("Highlight") then
			player.Character:FindFirstChildOfClass("Highlight"):Destroy()
		end
	end

	local Enabled = false
	local Chams = Tabs.Render:CreateToggle({
		Name = "Chams",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					task.wait()
					Players.PlayerAdded:Connect(Hightlight)
					Players.PlayerRemoving:Connect(RemoveHighlight)
					for i,v in pairs(Players:GetChildren()) do
						Hightlight(v)
					end
				until not Enabled
				for i,v in pairs(Players:GetChildren()) do
					RemoveHighlight(v)
				end
			end
		end
	})
end)

spawn(function()
	local Enabled, NearestPlayer, TargetImage  = false, nil, nil
	local TargetHUD = Tabs.Render:CreateToggle({
		Name = "TargetHUD",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					wait()
					NearestPlayer = GetPlayer(KillAuraDistance, KillAuraPlayerModes)
					if NearestPlayer then
						TargetImage = Players:GetUserThumbnailAsync(NearestPlayer.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48)
						Main:TargetHud(NearestPlayer.Name, TargetImage, NearestPlayer.Character:FindFirstChildOfClass("Humanoid"), Humanoid, true)
					end
				until not Enabled
				Main:TargetHud(NearestPlayer.Name, TargetImage, NearestPlayer.Character:FindFirstChildOfClass("Humanoid"), Humanoid, false)
			end
		end
	})
end)

spawn(function()
	local Enabled, Distance, PlayerModes = false, nil, nil
	local BowAura = Tabs.Exploit:CreateToggle({
		Name = "BowAura",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					wait()
					local Player = GetPlayer(Distance, PlayerModes)
					if Player then
						local Bow = CheckTools("Bow")
						if Bow then
							local args = {
								[1] = Player.Character:FindFirstChild("HumanoidRootPart").Position,
								[2] = 2.9958127420395613
							}
							Bow:WaitForChild("__comm__"):WaitForChild("RF"):FindFirstChild("Fire"):InvokeServer(unpack(args))
						end
					end
				until not Enabled
			end
		end
	})
	local CustomDistance = BowAura:CreateSlider({
		Name = "Distance",
		Callback = function(callback)
			if callback then
				Distance = callback
			end
		end
	})
	local CustomPlayerModes = BowAura:CreateDropdown({
		Name = "PlayerMode",
		List = {"Distance", "Health"},
		Default = "Distance",
		Callback = function(callback)
			if callback then
				PlayerModes = callback
			end
		end
	})
end)
