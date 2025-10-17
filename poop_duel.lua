repeat task.wait() until game:IsLoaded()

local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/sstvskids/LimeForSolara/main/library.lua'))()

local cloneref = cloneref or function(obj)
    return obj
end

local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local UserInputService = cloneref(game:GetService('UserInputService'))
local TextChatService = cloneref(game:GetService('TextChatService'))
local TweenService = cloneref(game:GetService('TweenService'))
local RunService = cloneref(game:GetService('RunService'))
local StarterGui = cloneref(game:GetService('StarterGui'))
local Lighting = cloneref(game:GetService('Lighting'))
local Players = cloneref(game:GetService('Players'))
local lplr = Players.LocalPlayer
local Mouse = cloneref(lplr:GetMouse())

local MainFrame = Library:CreateMain()
local TabSections = {
	Combat = MainFrame:CreateTab('1'),
	Exploit = MainFrame:CreateTab('2'),
	Move = MainFrame:CreateTab('3'),
	Player = MainFrame:CreateTab('4'),
	Visual = MainFrame:CreateTab('5'),
	World = MainFrame:CreateTab('6'),
	Manager = MainFrame:CreateManager()
}

local Swords = {
	['WoodenSword'] = {
		['Damage'] = 15
	},
	['StoneSword'] = {
		['Damage'] = 25
	},
	['IronSword'] = {
		['Damage'] = 30
	}
}

local function IsAlive(v)
	return v and v.PrimaryPart and v:FindFirstChildOfClass('Humanoid') and v:FindFirstChildOfClass('Humanoid').Health > 0
end

local function CheckForWall(v)
	local Raycast = RaycastParams.new()
	Raycast.FilterType = Enum.RaycastFilterType.Exclude
	Raycast.FilterDescendantsInstances = {lplr.Character}
	local Direction = v.PrimaryPart.Position - lplr.Character.PrimaryPart.Position
	local Result = workspace:Raycast(lplr.Character.PrimaryPart.Position, Direction, Raycast)
	if Result and Result.Instance and not v:IsAncestorOf(Result.Instance) then
		return false
	end
	return true
end

local function GetNearestEntity(MaxDist, EntityCheck, EntitySort, EntityTeam, EntityWall, EntityDirection)
	local Entity
	local MinDist = math.huge
	for _, v in pairs(workspace:GetChildren()) do
		if v:IsA('Model') and v.Name ~= lplr.Name and IsAlive(v) then
			local IsEntity = false
			if not EntityCheck then
				if not EntityWall or CheckForWall(v) then
					IsEntity = true
				end
			else
				for _, plr in pairs(Players:GetPlayers()) do
					if plr.Name == v.Name and (not EntityTeam or plr.TeamColor ~= lplr.TeamColor) then
						if not EntityWall or CheckForWall(v) then
							IsEntity = true
						end
					end
				end
			end
			if IsEntity then
				local Direction = (v.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Unit
				local Angle = math.deg(lplr.Character.PrimaryPart.CFrame.LookVector:Angle(Direction))
				if EntityDirection >= 360 or Angle <= EntityDirection / 2 then
					local Distance = (v.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude
					if EntitySort == 'Distance' and Distance <= MaxDist and (not MinDist or Distance < MinDist) then
						MinDist = Distance
						Entity = v
					elseif EntitySort == 'Furthest' and Distance <= MaxDist and (not MinDist or Distance > MinDist) then
						MinDist = Distance
						Entity = v
					elseif EntitySort == 'Health' and Distance <= MaxDist and v:FindFirstChild('Humanoid') and (not MinDist or v.Humanoid.Health < MinDist) then
						MinDist = v.Humanoid.Health
						Entity = v
					elseif EntitySort == 'Threat' and Distance <= MaxDist and v:FindFirstChild('Humanoid') and (not MinDist or v.Humanoid.Health > MinDist) then
						MinDist = v.Humanoid.Health
						Entity = v
					end
				end
			end
		end
	end
	return Entity
end

local function getPos(pos)
	return Vector3.new(math.floor((pos.X / 3) + 0.5) * 3,math.floor((pos.Y / 3) + 0.5) * 3,math.floor((pos.Z / 3) + 0.5) * 3)
end

local function getTool()
    return lplr.Character and lplr.Character:FindFirstChildOfClass('Tool') or nil
end

local Hitbox
task.defer(function()
	local Size = {X = 2.4, Y = 5, Z = 2.4}
	Hitbox = TabSections.Combat:CreateToggle({
		Name = 'Hitbox',
		Callback = function(callback)
			if callback then
				task.spawn(function()
					repeat
						for _, plr in pairs(Players:GetPlayers()) do
							if plr ~= lplr and IsAlive(plr.Character) then
								local Hitbox = plr.Character:FindFirstChild('Hitbox')
								if Hitbox and Hitbox.Size ~= Vector3.new(Size.X, Size.Y, Size.Z) then
									Hitbox.Size = Vector3.new(Size.X, Size.Y, Size.Z)
								end
							end
						end

						task.wait(2)
					until not Hitbox.Enabled

					for _, plr in pairs(Players:GetPlayers()) do
						if plr ~= lplr and IsAlive(plr.Character) then
							local Hitbox = plr.Character:FindFirstChild('Hitbox')
							if Hitbox and Hitbox.Size ~= Vector3.new(2.5, 5.572000026702881, 2.5) then
								Hitbox.Size = Vector3.new(2.5, 5.572000026702881, 2.5)
							end
						end
					end
				end)
			end
		end
	})
	local HitboxSizeX = Hitbox:CreateSlider({
		Name = 'X',
		Min = 0,
		Max = 16,
		Default = 2.4,
		Callback = function(callback)
			if callback then
				Size.X = callback
			end
		end
	})
	local HitboxSizeY = Hitbox:CreateSlider({
		Name = 'Y',
		Min = 0,
		Max = 16,
		Default = 5,
		Callback = function(callback)
			if callback then
				Size.Y = callback
			end
		end
	})
	local HitboxSizeZ = Hitbox:CreateSlider({
		Name = 'Z',
		Min = 0,
		Max = 16,
		Default = 2.4,
		Callback = function(callback)
			if callback then
				Size.Z = callback
			end
		end
	})
end)

local KillAura
local EntityCFrame
local KillAuraEntity
task.defer(function()
	local WallCheck, TeamCheck, SortType, ADirection = true, false, nil, nil
	local Distance, ADelay, AType = nil, nil, 'Blatant'
	local CanSwing = false
	local SwingAnim
	local Sword
	KillAura = TabSections.Combat:CreateToggle({
		Name = 'Kill Aura',
		Callback = function(callback)
			if callback then
				task.spawn(function()
					repeat
						if AType == 'Blatant' then
							ADelay = 0.1
						elseif AType == 'Legit' then
							ADelay = 0.2
						end
						if IsAlive(lplr.Character) then
							local Entity = GetNearestEntity(Distance, AntiBot.Enabled, SortType, TeamCheck, WallCheck, ADirection)
							if Entity and Entity.PrimaryPart then
								KillAuraEntity = Entity
								EntityCFrame = CFrame.lookAt(lplr.Character.PrimaryPart.Position, Vector3.new(Entity.PrimaryPart.Position.X, lplr.Character.PrimaryPart.Position.Y, Entity.PrimaryPart.Position.Z))
								Sword = getTool()
								if Sword and Swords[Sword.Name] then
									if not SwingAnim then
										SwingAnim = lplr.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(ReplicatedStorage:WaitForChild('Assets'):WaitForChild('Animations'):WaitForChild('Swing'))
										SwingAnim.Looped = true
									end
									if CanSwing and not SwingAnim.IsPlaying then
										SwingAnim:Play()
									end
									ReplicatedStorage.Remotes.MeleeHit:FireServer(Entity.Character, Sword.Name, lplr.Character.Humanoid.FloorMaterial)
								else
									if SwingAnim and SwingAnim.IsPlaying then
										SwingAnim:Stop()
									end
								end
							else
								EntityCFrame = nil
								KillAuraEntity = nil
								if SwingAnim and SwingAnim.IsPlaying then
									SwingAnim:Stop()
								end
							end
						end
						task.wait(ADelay)
					until not KillAura.Enabled
					EntityCFrame = nil
					KillAuraEntity = nil
					if SwingAnim and SwingAnim.IsPlaying then
						SwingAnim:Stop()
					end
				end)
			end
		end
	})
	local KillAuraType = KillAura:CreateDropdown({
		Name = 'Kill_Aura_Type',
		List = {'Legit', 'Blatant'},
		Default = 'Blatant',
		Callback = function(callback)
			if callback then
				AType = callback
			end
		end
	})
	local KillAuraSort = KillAura:CreateDropdown({
		Name = 'Kill_Aura_Sort',
		List = {'Furthest', 'Health', 'Threat', 'Distance'},
		Default = 'Distance',
		Callback = function(callback)
			if callback then
				SortType = callback
			end
		end
	})
	local KillAuraDirection = KillAura:CreateSlider({
		Name = 'Direction',
		Min = 0,
		Max = 360,
		Default = 360,
		Callback = function(callback)
			if callback then
				ADirection = callback
			end
		end
	})
	local KillAuraDistance = KillAura:CreateSlider({
		Name = 'Distance',
		Min = 0,
		Max = 22,
		Default = 20,
		Callback = function(callback)
			if callback then
				Distance = callback
			end
		end
	})
	local KillAuraWall = KillAura:CreateMiniToggle({
		Name = 'Through Walls',
		Callback = function(callback)
			if callback then
				WallCheck = false
			else
				WallCheck = true
			end
		end
	})
	local KillAuraSwing = KillAura:CreateMiniToggle({
		Name = 'Swing',
		Callback = function(callback)
			if callback then
				CanSwing = true
			else
				CanSwing = false
			end
		end
	})
	local KillAuraTeam = KillAura:CreateMiniToggle({
		Name = 'Team',
		Callback = function(callback)
			if callback then
				TeamCheck = true
			else
				TeamCheck = false
			end
		end
	})
end)