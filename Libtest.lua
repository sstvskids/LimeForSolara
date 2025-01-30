repeat task.wait() until game:IsLoaded()
local ConfigTable = {Keybind = "RightShift", Notification = true, ToggleButton = {}, MiniToggle = {}, Slider = {}, Dropdown = {}}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local clonerf = cloneref
local DeviceType
local Library = {
	Render = {
		Hud = true,
		Arraylist = true,
		Watermark = true
	},
	Notification = ConfigTable.Notification or true,
	Keybinds = ConfigTable.Keybind or "RightShift"
}

local MainFile = nil
local MainFolder, ConfigFolder = "Eternal", "Eternal/config"
if isfolder(MainFolder) and isfolder(ConfigFolder) then
	MainFile = ConfigFolder .. "/" .. game.PlaceId .. ".lua"
	if isfile(MainFile) then
		local GetMain = readfile(MainFile)
		if GetMain then
			local OldSettings = HttpService:JSONDecode(GetMain)
			if OldSettings then
				ConfigTable = OldSettings
			end
		end
	end
	
	task.spawn(function()
		repeat
			task.wait(3)
			writefile(MainFile, HttpService:JSONEncode(ConfigTable))
		until not game
	end)
end


if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
	if not DeviceType then
		DeviceType = "Touch"
	end
elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
	if not DeviceType then
		DeviceType = "Mouse"
	end
end

local function MakeDraggable(v)
	local Dragging, Input2, StartDragging, StartPos = nil, nil, nil, nil
	local function Update(Input)
		local Delta = Input.Position - StartDragging
		v.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
	end

	v.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			StartDragging = Input.Position
			StartPos = v.Position

			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	v.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			Input2 = Input
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if Input == Input2 and Dragging then
			Update(Input)
		end
	end)
end

local function GetChildrenY(obj)
	local OldY = 0
	for _, v in ipairs(obj:GetChildren()) do
		if v:IsA("GuiObject") then
			OldY += v.AbsoluteSize.Y + v.Position.Y.Offset
		end
	end
	return UDim2.new(obj.Size.X.Scale, obj.Size.X.Offset, 0, OldY)
end

function Library:CreateMain()
	local Main = {}

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = HttpService:GenerateGUID(false)
	ScreenGui.ResetOnSpawn = false
	if RunService:IsStudio() then
		ScreenGui.Parent = PlayerGui
	elseif game.PlaceId == 11630038968 or game.PlaceId == 10810646982 then
		if clonerf then
			ScreenGui.Parent= clonerf(CoreGui)
		else
			ScreenGui.Parent = PlayerGui:FindFirstChild("MainGui")
		end
	else
		if clonerf then
			ScreenGui.Parent= clonerf(CoreGui)
		else
			ScreenGui.Parent = PlayerGui:FindFirstChild("MainGui")
		end
	end

	local MainFrame, UIListLayout, UIPadding
	if DeviceType == "Mouse" then
		MainFrame = Instance.new("Frame")
		MainFrame.Parent = ScreenGui
		MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		MainFrame.BackgroundTransparency = 1.000
		MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MainFrame.BorderSizePixel = 0
		MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		MainFrame.Size = UDim2.new(1, 0, 1, 0)
		MainFrame.Visible = false

		UIListLayout = Instance.new("UIListLayout")
		UIListLayout.Parent = MainFrame
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 8)

		UIPadding = Instance.new("UIPadding")
		UIPadding.Parent = MainFrame
		UIPadding.PaddingLeft = UDim.new(0.180000007, 0)
		UIPadding.PaddingTop = UDim.new(0.150000006, 0)
	elseif DeviceType == "Touch" then
		MainFrame = Instance.new("ScrollingFrame")
		MainFrame.Parent = ScreenGui
		MainFrame.Active = true
		MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		MainFrame.BackgroundTransparency = 1.000
		MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MainFrame.BorderSizePixel = 0
		MainFrame.Size = UDim2.new(1, 0, 1, 0)
		MainFrame.CanvasSize = UDim2.new(2, 0, 0, 0)
		MainFrame.Visible = false

		UIListLayout = Instance.new("UIListLayout")
		UIListLayout.Parent = MainFrame
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 8)

		UIPadding = Instance.new("UIPadding")
		UIPadding.Parent = MainFrame
		UIPadding.PaddingLeft = UDim.new(0.008, 0)
		UIPadding.PaddingTop = UDim.new(0.150000006, 0)
	end

	local MainOpen, UICorner_2
	if DeviceType == "Touch" then
		MainOpen = Instance.new("TextButton")
		MainOpen.Parent = ScreenGui
		MainOpen.AnchorPoint = Vector2.new(0.5, 0.5)
		MainOpen.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		MainOpen.BackgroundTransparency = 0.2
		MainOpen.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MainOpen.BorderSizePixel = 0
		MainOpen.Position = UDim2.new(0.5, 0, 0.0380000018, 0)
		MainOpen.Size = UDim2.new(0, 25, 0, 25)
		MainOpen.ZIndex = 5
		MainOpen.Font = Enum.Font.Roboto
		MainOpen.Text = "+"
		MainOpen.TextColor3 = Color3.fromRGB(255, 255, 255)
		MainOpen.TextScaled = true
		MainOpen.TextSize = 14.000
		MainOpen.TextWrapped = true

		UICorner_2 = Instance.new("UICorner")
		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = MainOpen

		MainOpen.MouseButton1Click:Connect(function()
			MainFrame.Visible = not MainFrame.Visible
		end)
	end

	local HudFrame = Instance.new("Frame")
	HudFrame.Parent = ScreenGui
	HudFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HudFrame.BackgroundTransparency = 1.000
	HudFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HudFrame.BorderSizePixel = 0
	HudFrame.Size = UDim2.new(1, 0, 1, 0)
	Library.HudMainFrame = HudFrame

	local KeybindFrame = Instance.new("Frame")
	KeybindFrame.Parent = ScreenGui
	KeybindFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	KeybindFrame.BackgroundTransparency = 1.000
	KeybindFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	KeybindFrame.Size = UDim2.new(1, 0, 1, 0)

	task.spawn(function()
		repeat
			task.wait()
			if Library.Render.Hud then
				HudFrame.Visible = true
			else
				HudFrame.Visible = false
			end
		until not game
	end)

	local Watermark = Instance.new("Frame")
	Watermark.Parent = HudFrame
	Watermark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Watermark.BackgroundTransparency = 0.250
	Watermark.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Watermark.BorderSizePixel = 0
	Watermark.Position = UDim2.new(0, 10, 0, 20)
	Watermark.Size = UDim2.new(0, 155, 0, 22)
	Watermark.AutomaticSize = Enum.AutomaticSize.XY

	local WatermarkLine = Instance.new("Frame")
	WatermarkLine.Parent = Watermark
	WatermarkLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	WatermarkLine.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WatermarkLine.BorderSizePixel = 0
	WatermarkLine.Position = UDim2.new(0, 2, 0, 2)
	WatermarkLine.Size = UDim2.new(0, 151, 0, 1)

	local WatermarkText = Instance.new("TextLabel")
	WatermarkText.Parent = Watermark
	WatermarkText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	WatermarkText.BackgroundTransparency = 1.000
	WatermarkText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WatermarkText.BorderSizePixel = 0
	WatermarkText.Position = UDim2.new(0, 0, 0, 4)
	WatermarkText.Size = UDim2.new(0, 171, 0, 20)
	WatermarkText.Font = Enum.Font.Roboto
	WatermarkText.Text = " Eternal v.2.2 | " .. os.date("%I:%M:%S %p")
	WatermarkText.TextColor3 = Color3.fromRGB(255, 255, 255)
	WatermarkText.TextSize = 16.000
	WatermarkText.TextWrapped = true
	WatermarkText.TextXAlignment = Enum.TextXAlignment.Left

	task.spawn(function()
		while task.wait(1) do
			WatermarkText.Text = " Eternal v.2.2 | " .. os.date("%I:%M %p") .. " "
			local NewSize1 = game.TextService:GetTextSize(WatermarkText.Text, WatermarkText.TextSize, WatermarkText.Font, Vector2.new(10000, 10000))
			WatermarkLine.Size = UDim2.new(0, NewSize1.X - 4, 0, 1)
			WatermarkText.Size = UDim2.new(0, NewSize1.X, 0, NewSize1.Y)
		end
	end)

	task.spawn(function()
		repeat
			task.wait()
			if Library.Render.Watermark then
				Watermark.Visible = true
			else
				Watermark.Visible = false
			end
		until not game
	end)

	local ArrayTable = {}
	local ArrayFrame = Instance.new("Frame")
	ArrayFrame.Parent = HudFrame
	ArrayFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ArrayFrame.BackgroundTransparency = 1.000
	ArrayFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ArrayFrame.BorderSizePixel = 0
	ArrayFrame.Position = UDim2.new(0.793529391, 0, 0, 20)
	ArrayFrame.Size = UDim2.new(0.196470603, 0, 0.855223835, 0)

	local UIListLayout_4 = Instance.new("UIListLayout")
	UIListLayout_4.Parent = ArrayFrame
	UIListLayout_4.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder

	task.spawn(function()
		repeat
			task.wait()
			if Library.Render.Arraylist then
				ArrayFrame.Visible = true
			else
				ArrayFrame.Visible = false
			end
		until not game
	end)

	local function AddArray(name, suffix)
		local TextLabel = Instance.new("TextLabel")
		TextLabel.Parent = ArrayFrame
		TextLabel.TextTransparency = 1
		TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BackgroundTransparency = 0.500
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Position = UDim2.new(0.063517727, 0, 0, 0)
		TextLabel.Size = UDim2.new(0, 0, 0, 20)
		TextLabel.Font = Enum.Font.Roboto
		TextLabel.RichText = true
		TextLabel.Text = " " .. name .. " <font color='rgb(185, 185, 185)'>" .. (suffix or "") .. " " .. "</font>" .. " "
		TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.TextSize = 14.000
		TextLabel.TextWrapped = true
		TextLabel.TextXAlignment = Enum.TextXAlignment.Right

		local NewWidth = game.TextService:GetTextSize(name .. (suffix or ""), 18, Enum.Font.SourceSans, Vector2.new(0, 0)).X
		local NewSize2 = UDim2.new(0.01, NewWidth, 0, 20)
		if name .. (suffix or "") == "" then
			NewSize2 = UDim2.fromScale(0, 0)
		end

		if NewSize2 and NewWidth then
			local ArrayIn = TweenService:Create(TextLabel, TweenInfo.new(0.2), {Size = NewSize2, Position = UDim2.new(1, -NewWidth, 0, 0)})
			if ArrayIn then
				ArrayIn:Play()
				ArrayIn.Completed:Connect(function()
					TextLabel.TextTransparency = 0
				end)
			end
		end

		table.insert(ArrayTable, TextLabel)
		table.sort(ArrayTable, function(a, b) return game.TextService:GetTextSize(a.Text .. "", 18, Enum.Font.SourceSans, Vector2.new(0, 20)).X > game.TextService:GetTextSize(b.Text .. "", 18, Enum.Font.SourceSans, Vector2.new(0, 20)).X end)
		for i, v in ipairs(ArrayTable) do
			v.LayoutOrder = i
		end
	end

	local function RemoveArray(name, suffix)
		table.sort(ArrayTable, function(a, b) return game.TextService:GetTextSize(a.Text .. "", 18, Enum.Font.SourceSans, Vector2.new(0, 20)).X > game.TextService:GetTextSize(b.Text .. "", 18, Enum.Font.SourceSans, Vector2.new(0, 20)).X end)
		local c = 0
		for i, v in ipairs(ArrayTable) do
			c += 1
			if v.Text:match(name) then
				v.TextTransparency = 1
				local NewWidth = game.TextService:GetTextSize(name .. (suffix or ""), 18, Enum.Font.SourceSans, Vector2.new(0, 0)).X
				if NewWidth then
					local ArrayOut = TweenService:Create(v, TweenInfo.new(0.2), {Size = UDim2.new(0.01, -NewWidth + NewWidth, 0, 20)})
					if ArrayOut then
						ArrayOut:Play()
						ArrayOut.Completed:Connect(function()
							v:Destroy()
							table.remove(ArrayTable, c)	
						end)
					end
				end
			else
				v.LayoutOrder = i
			end
		end
	end

	local TargetHUD = Instance.new("Frame")
	TargetHUD.Parent = HudFrame
	TargetHUD.AnchorPoint = Vector2.new(0.5, 0.5)
	TargetHUD.BackgroundColor3 = Color3.fromRGB(4, 3, 3)
	TargetHUD.BackgroundTransparency = 0.150
	TargetHUD.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TargetHUD.BorderSizePixel = 0
	TargetHUD.Position = UDim2.new(0.649999976, 0, 0.649999976, 0)
	TargetHUD.Size = UDim2.new(0, 190, 0, 65)
	TargetHUD.Visible = false
	MakeDraggable(TargetHUD)

	local HealthBack = Instance.new("Frame")
	HealthBack.Parent = TargetHUD
	HealthBack.AnchorPoint = Vector2.new(0.5, 0.5)
	HealthBack.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
	HealthBack.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HealthBack.BorderSizePixel = 0
	HealthBack.Position = UDim2.new(0, 95, 0, 55)
	HealthBack.Size = UDim2.new(0, 180, 0, 10)

	local HealthFront = Instance.new("Frame")
	HealthFront.Parent = HealthBack
	HealthFront.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HealthFront.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HealthFront.BorderSizePixel = 0
	HealthFront.Position = UDim2.new(0, 3, 0, 3)
	HealthFront.Size = UDim2.new(0, 85, 0, 4)

	local UIGradient = Instance.new("UIGradient")
	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(205, 205, 205)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(111, 111, 111))}
	UIGradient.Parent = HealthFront

	local TargetPicture = Instance.new("ImageLabel")
	TargetPicture.Parent = TargetHUD
	TargetPicture.AnchorPoint = Vector2.new(0.5, 0.5)
	TargetPicture.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TargetPicture.BackgroundTransparency = 1.000
	TargetPicture.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TargetPicture.BorderSizePixel = 0
	TargetPicture.Position = UDim2.new(0, 25, 0, 25)
	TargetPicture.Size = UDim2.new(0, 40, 0, 40)

	local FightStatus = Instance.new("TextLabel")
	FightStatus.Parent = TargetHUD
	FightStatus.AnchorPoint = Vector2.new(0.5, 0.5)
	FightStatus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	FightStatus.BackgroundTransparency = 1.000
	FightStatus.BorderColor3 = Color3.fromRGB(0, 0, 0)
	FightStatus.BorderSizePixel = 0
	FightStatus.Position = UDim2.new(0, 119, 0, 34)
	FightStatus.Size = UDim2.new(0, 130, 0, 18)
	FightStatus.Font = Enum.Font.Roboto
	FightStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
	FightStatus.TextSize = 15.000
	FightStatus.TextWrapped = true
	FightStatus.TextXAlignment = Enum.TextXAlignment.Left

	local TargetName = Instance.new("TextLabel")
	TargetName.Parent = TargetHUD
	TargetName.AnchorPoint = Vector2.new(0.5, 0.5)
	TargetName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TargetName.BackgroundTransparency = 1.000
	TargetName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TargetName.BorderSizePixel = 0
	TargetName.Position = UDim2.new(0, 119, 0, 14)
	TargetName.Size = UDim2.new(0, 130, 0, 18)
	TargetName.Font = Enum.Font.Roboto
	TargetName.TextColor3 = Color3.fromRGB(255, 255, 255)
	TargetName.TextSize = 15.000
	TargetName.TextWrapped = true
	TargetName.TextXAlignment = Enum.TextXAlignment.Left

	function Main:DisplayTarget(name, image, humanoid, isvisible)
		local Target = {}

		if isvisible then
			TargetHUD.Visible = true
			if name and humanoid then
				TargetPicture.Image = image
				TargetName.Text = name

				local NewSize3 = UDim2.new((humanoid.Health / humanoid.MaxHealth) - 0.025 * 2, 0, HealthFront.Size.Y.Scale, HealthFront.Size.Y.Offset)
				local NewPos1 = UDim2.new(0.02, 0, HealthFront.Position.Y.Scale, HealthFront.Position.Y.Offset)
				if NewSize3 and NewPos1 then
					if LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health > humanoid.Health then
						FightStatus.Text = "Winning"
					elseif LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health == humanoid.Health then
						FightStatus.Text = "Tie"
					elseif LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health < humanoid.Health then
						FightStatus.Text = "Losing"
					end
					TweenService:Create(HealthFront, TweenInfo.new(0.5), {Size = NewSize3, Position = NewPos1}):Play()
				end
			end
		else
			TargetHUD.Visible = false
		end

		return Target
	end

	local NotificationFrame = Instance.new("Frame")
	NotificationFrame.Parent = HudFrame
	NotificationFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NotificationFrame.BackgroundTransparency = 1.000
	NotificationFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	NotificationFrame.BorderSizePixel = 0
	NotificationFrame.Position = UDim2.new(0.354509801, 0, 0, 20)
	NotificationFrame.Size = UDim2.new(0.64549017, 0, 0.920000017, 0)

	local UIListLayout_5 = Instance.new("UIListLayout")
	UIListLayout_5.Parent = NotificationFrame
	UIListLayout_5.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_5.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout_5.Padding = UDim.new(0.00999999978, 0)

	local NotificationTable = {}
	function Main:Notify(name, description, types, duration, allowspam)
		local Notification = {}

		task.spawn(function()
			local Frame = Instance.new("Frame")
			Frame.Parent = NotificationFrame
			Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			Frame.BackgroundTransparency = 0.3
			Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame.BorderSizePixel = 0
			Frame.Size = UDim2.new(0, 0, 0, 51)
			Frame.Visible = false
			Frame.AutomaticSize = Enum.AutomaticSize.X

			local NotifIcon = Instance.new("ImageLabel")
			NotifIcon.Parent = Frame
			NotifIcon.AnchorPoint = Vector2.new(0.5, 0.5)
			NotifIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NotifIcon.BackgroundTransparency = 1.000
			NotifIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NotifIcon.BorderSizePixel = 0
			NotifIcon.Position = UDim2.new(0.0978856683, 0, 0.487686872, 0)
			NotifIcon.Size = UDim2.new(0.18, 0, 0.902, 0)
			if types == "i" then
				NotifIcon.Image = "http://www.roblox.com/asset/?id=73161077983280"
			elseif types == "w" then
				NotifIcon.Image = "http://www.roblox.com/asset/?id=103548733140422"
			elseif types == "e" then
				NotifIcon.Image = "http://www.roblox.com/asset/?id=113691811173766"
			elseif types == "s" then
				NotifIcon.Image = "http://www.roblox.com/asset/?id=70698530565147"        
			end

			local NotifName = Instance.new("TextLabel")
			NotifName.Parent = Frame
			NotifName.AnchorPoint = Vector2.new(0.5, 0.5)
			NotifName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NotifName.BackgroundTransparency = 1.000
			NotifName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NotifName.BorderSizePixel = 0
			NotifName.Position = UDim2.new(0.465935767, 0, 0.3, 0)
			NotifName.Size = UDim2.new(0.509005487, 0, 0.351134539, 0)
			NotifName.Font = Enum.Font.Roboto
			NotifName.Text = name
			NotifName.TextColor3 = Color3.fromRGB(255, 255, 255)
			NotifName.TextSize = 16.000
			NotifName.TextWrapped = true
			NotifName.TextXAlignment = Enum.TextXAlignment.Left

			local NotifInfo = Instance.new("TextLabel")
			NotifInfo.Parent = Frame
			NotifInfo.AnchorPoint = Vector2.new(0.5, 0.5)
			NotifInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NotifInfo.BackgroundTransparency = 1.000
			NotifInfo.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NotifInfo.BorderSizePixel = 0
			NotifInfo.Position = UDim2.new(0.612716615, 0, 0.7, 0)
			NotifInfo.Size = UDim2.new(0.802566648, 0, 0.32, 0)
			NotifInfo.Font = Enum.Font.Roboto
			NotifInfo.Text = description
			NotifInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
			NotifInfo.TextSize = 16.000
			NotifInfo.TextTransparency = 0.500
			NotifInfo.TextWrapped = true
			NotifInfo.TextXAlignment = Enum.TextXAlignment.Left

			if allowspam then
				Frame.Visible = true
				TweenService:Create(Frame, TweenInfo.new(0.4), {Size = UDim2.new(0, 255, 0, 51)}):Play()
				task.wait(duration)
				local CloseTween = TweenService:Create(Frame, TweenInfo.new(0.4), {Size = UDim2.new(0, 0, 0, 51)})
				if CloseTween then
					CloseTween:Play()
					CloseTween.Completed:Connect(function()
						Frame:Destroy()
					end)
				end
			else
				if not table.find(NotificationTable, name) then
					table.insert(NotificationTable, name)
					Frame.Visible = true
					TweenService:Create(Frame, TweenInfo.new(0.4), {Size = UDim2.new(0, 255, 0, 51)}):Play()
					task.wait(duration)
					local CloseTween = TweenService:Create(Frame, TweenInfo.new(0.4), {Size = UDim2.new(0, 0, 0, 51)})
					if CloseTween then
						CloseTween:Play()
						CloseTween.Completed:Connect(function()
							Frame:Destroy()
							local Current = table.find(NotificationTable, name)
							if Current then
								table.remove(NotificationTable, Current)
							end
						end)
					end
				end
			end
		end)

		return Notification
	end


	UserInputService.InputBegan:Connect(function(Input, IsTyping)
		if Input.KeyCode == Enum.KeyCode[Library.Keybinds] and not IsTyping then
			MainFrame.Visible = not MainFrame.Visible
		end
	end)

	function Main:CreateTab(name, advance)
		local Tabs = {}

		local TabHolder = Instance.new("Frame")
		TabHolder.Parent = MainFrame
		TabHolder.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
		TabHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabHolder.BorderSizePixel = 0
		TabHolder.Size = UDim2.new(0, 172, 0, 36)

		local TabName = Instance.new("TextLabel")
		TabName.Parent = TabHolder
		TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabName.BackgroundTransparency = 1.000
		TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabName.BorderSizePixel = 0
		TabName.Size = UDim2.new(1, 0, 1, 0)
		TabName.Font = Enum.Font.Roboto
		TabName.Text = name
		TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabName.TextSize = 16.000
		TabName.TextWrapped = true

		local ToggleList = Instance.new("Frame")
		ToggleList.Parent = TabHolder
		ToggleList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ToggleList.BackgroundTransparency = 1.000
		ToggleList.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ToggleList.BorderSizePixel = 0
		ToggleList.Position = UDim2.new(0, 0, 1.00000024, 0)
		ToggleList.Size = UDim2.new(1, 0, 0, 0)

		local UIListLayout_2 = Instance.new("UIListLayout")
		UIListLayout_2.Parent = ToggleList
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

		if advance then
			local IsLibraryMenu = false
			local LibraryMain = Instance.new("TextButton")
			LibraryMain.Parent = ToggleList
			LibraryMain.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
			LibraryMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
			LibraryMain.BorderSizePixel = 0
			LibraryMain.LayoutOrder = 98
			LibraryMain.Size = UDim2.new(1, 0, 0, 34)
			LibraryMain.AutoButtonColor = false
			LibraryMain.Font = Enum.Font.SourceSans
			LibraryMain.Text = ""
			LibraryMain.TextColor3 = Color3.fromRGB(0, 0, 0)
			LibraryMain.TextSize = 14.000

			local LibraryTitle = Instance.new("TextLabel")
			LibraryTitle.Parent = LibraryMain
			LibraryTitle.AnchorPoint = Vector2.new(0.5, 0.5)
			LibraryTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			LibraryTitle.BackgroundTransparency = 1.000
			LibraryTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			LibraryTitle.BorderSizePixel = 0
			LibraryTitle.Position = UDim2.new(0.5, 0, 0.5, 0)
			LibraryTitle.Size = UDim2.new(1, 0, 1, 0)
			LibraryTitle.Font = Enum.Font.Roboto
			LibraryTitle.Text = "Client Settings"
			LibraryTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			LibraryTitle.TextSize = 18.000
			LibraryTitle.TextWrapped = true

			local OpenLibrary = Instance.new("TextButton")
			OpenLibrary.Parent = LibraryMain
			OpenLibrary.AnchorPoint = Vector2.new(0.5, 0.5)
			OpenLibrary.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			OpenLibrary.BackgroundTransparency = 1.000
			OpenLibrary.BorderColor3 = Color3.fromRGB(0, 0, 0)
			OpenLibrary.BorderSizePixel = 0
			OpenLibrary.Position = UDim2.new(0.930000007, 0, 0.5, 0)
			OpenLibrary.Size = UDim2.new(0, 20, 0, 20)
			OpenLibrary.Font = Enum.Font.SourceSans
			OpenLibrary.Text = "+"
			OpenLibrary.TextColor3 = Color3.fromRGB(255, 255, 255)
			OpenLibrary.TextScaled = true
			OpenLibrary.TextSize = 14.000
			OpenLibrary.TextWrapped = true

			local LibraryMenu = Instance.new("Frame")
			LibraryMenu.Parent = ToggleList
			LibraryMenu.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
			LibraryMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
			LibraryMenu.BorderSizePixel = 0
			LibraryMenu.LayoutOrder = 99
			LibraryMenu.Position = UDim2.new(0, 0, 34, 0)
			LibraryMenu.Size = UDim2.new(1, 0, 0, 0)
			LibraryMenu.AutomaticSize = Enum.AutomaticSize.Y
			LibraryMenu.Visible = false

			local LibraryLayout = Instance.new("UIListLayout")
			LibraryLayout.Parent = LibraryMenu
			LibraryLayout.SortOrder = Enum.SortOrder.LayoutOrder

			local IsToggleNotif = false
			local ToggleNotif = Instance.new("TextButton")
			ToggleNotif.Parent = LibraryMenu
			ToggleNotif.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleNotif.BackgroundTransparency = 1.000
			ToggleNotif.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleNotif.BorderSizePixel = 0
			ToggleNotif.Size = UDim2.new(1, 0, 0, 34)
			ToggleNotif.AutoButtonColor = false
			ToggleNotif.Font = Enum.Font.SourceSans
			ToggleNotif.Text = ""
			ToggleNotif.TextColor3 = Color3.fromRGB(0, 0, 0)
			ToggleNotif.TextSize = 14.000
			ToggleNotif.Visible = false

			local ToggleNotifName = Instance.new("TextLabel")
			ToggleNotifName.Parent = ToggleNotif
			ToggleNotifName.AnchorPoint = Vector2.new(0.5, 0.5)
			ToggleNotifName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleNotifName.BackgroundTransparency = 1.000
			ToggleNotifName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleNotifName.BorderSizePixel = 0
			ToggleNotifName.Position = UDim2.new(0.699999988, 0, 0.5, 0)
			ToggleNotifName.Size = UDim2.new(1, 0, 1, 0)
			ToggleNotifName.Font = Enum.Font.Roboto
			ToggleNotifName.Text = "Toggle Notification"
			ToggleNotifName.TextColor3 = Color3.fromRGB(255, 255, 255)
			ToggleNotifName.TextSize = 15.000
			ToggleNotifName.TextWrapped = true
			ToggleNotifName.TextXAlignment = Enum.TextXAlignment.Left

			local ToggleNotifStatus = Instance.new("Frame")
			ToggleNotifStatus.Parent = ToggleNotif
			ToggleNotifStatus.AnchorPoint = Vector2.new(0.5, 0.5)
			ToggleNotifStatus.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
			ToggleNotifStatus.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleNotifStatus.BorderSizePixel = 0
			ToggleNotifStatus.Position = UDim2.new(0.119999997, 0, 0.5, 0)
			ToggleNotifStatus.Size = UDim2.new(0, 14, 0, 14)

			ToggleNotif.MouseButton1Click:Connect(function()
				IsToggleNotif = not IsToggleNotif
				if IsToggleNotif then
					Library.Notification = false
					ConfigTable.Notification = false
					ToggleNotifStatus.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
				else
					Library.Notification = true
					ConfigTable.Notification = true
					ToggleNotifStatus.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
				end
			end)

			local UICorner = Instance.new("UICorner")
			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = ToggleNotifStatus

			local LibraryTween = "C"
			task.spawn(function()
				repeat
					task.wait()
					if LibraryTween == "O" then
						for _, v in pairs(LibraryMenu:GetChildren()) do
							if v:IsA("GuiObject") then
								v.Visible = true
							end
						end
					elseif LibraryTween == "C" then
						for _, v in pairs(LibraryMenu:GetChildren()) do
							if v:IsA("GuiObject") then
								v.Visible = false
							end
						end
					end
				until not game
			end)

			local LibraryKeybind = Instance.new("TextBox")
			LibraryKeybind.Parent = LibraryMenu
			LibraryKeybind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			LibraryKeybind.BackgroundTransparency = 1.000
			LibraryKeybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
			LibraryKeybind.BorderSizePixel = 0
			LibraryKeybind.LayoutOrder = 99
			LibraryKeybind.Position = UDim2.new(0.273255825, 0, 2.98461533, 0)
			LibraryKeybind.Size = UDim2.new(1, 0, 0, 34)
			LibraryKeybind.Font = Enum.Font.Roboto
			LibraryKeybind.PlaceholderText = Library.Keybinds
			LibraryKeybind.Text = ""
			LibraryKeybind.TextColor3 = Color3.fromRGB(255, 255, 255)
			LibraryKeybind.TextSize = 14.000
			LibraryKeybind.Visible = false
			UserInputService.InputBegan:Connect(function(Input, isTyping)
				if Input.UserInputType == Enum.UserInputType.Keyboard then
					if LibraryKeybind:IsFocused() then
						Library.Keybinds = Input.KeyCode.Name
						LibraryKeybind.Text = Input.KeyCode.Name
						LibraryKeybind.PlaceholderText = ""
						LibraryKeybind:ReleaseFocus()
						task.wait(0.1)
						LibraryKeybind.Text = ""
						LibraryKeybind.PlaceholderText = Input.KeyCode.Name
						ConfigTable.Keybind = Input.KeyCode.Name
					end       
				end
			end)

			OpenLibrary.MouseButton1Click:Connect(function()
				IsLibraryMenu = not IsLibraryMenu
				if IsLibraryMenu then
					LibraryMenu.Visible = true
					OpenLibrary.Text = "-"
					if GetChildrenY(LibraryMenu) then
						local OpeningLibrary = TweenService:Create(LibraryMenu, TweenInfo.new(0.2), {Size = GetChildrenY(LibraryMenu)})
						if OpenLibrary then
							OpeningLibrary:Play()
							OpeningLibrary.Completed:Connect(function()
								LibraryTween = "O"
								LibraryMenu.AutomaticSize = Enum.AutomaticSize.Y
							end)
						end
					end
				else
					OpenLibrary.Text = "+"
					local ClosingLibrary = TweenService:Create(LibraryMenu, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)})
					if ClosingLibrary then
						LibraryTween = "C"
						ClosingLibrary:Play()
						LibraryMenu.AutomaticSize = Enum.AutomaticSize.None
						ClosingLibrary.Completed:Connect(function()
							LibraryMenu.Visible = false
						end)
					end
				end
			end)

			LibraryMain.MouseButton2Click:Connect(function()
				IsLibraryMenu = not IsLibraryMenu
				if IsLibraryMenu then
					LibraryMenu.Visible = true
					OpenLibrary.Text = "-"
					if GetChildrenY(LibraryMenu) then
						local OpeningLibrary = TweenService:Create(LibraryMenu, TweenInfo.new(0.2), {Size = GetChildrenY(LibraryMenu)})
						if OpenLibrary then
							OpeningLibrary:Play()
							OpeningLibrary.Completed:Connect(function()
								LibraryTween = "O"
								LibraryMenu.AutomaticSize = Enum.AutomaticSize.Y
							end)
						end
					end
				else
					OpenLibrary.Text = "+"
					local ClosingLibrary = TweenService:Create(LibraryMenu, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)})
					if ClosingLibrary then
						LibraryTween = "C"
						ClosingLibrary:Play()
						LibraryMenu.AutomaticSize = Enum.AutomaticSize.None
						ClosingLibrary.Completed:Connect(function()
							LibraryMenu.Visible = false
						end)
					end
				end
			end)
		end

		function Tabs:CreateToggle(ToggleButton)
			ToggleButton = {
				Name = ToggleButton.Name,
				Suffix = ToggleButton.Suffix or "",
				Enabled = ToggleButton.Enabled or false,
				Keybind = ToggleButton.Keybind or "Euro",
				AutoEnable = ToggleButton.AutoEnable or false,
				AutoDisable = ToggleButton.AutoDisable or false,
				Callback = ToggleButton.Callback or function() end,
			}
			if not ConfigTable.ToggleButton[ToggleButton.Name] then
				ConfigTable.ToggleButton[ToggleButton.Name] = {
					Enabled = ToggleButton.Enabled,
					Keybind = ToggleButton.Keybind,
				}
			else
				ToggleButton.Enabled = ConfigTable.ToggleButton[ToggleButton.Name].Enabled
				ToggleButton.Keybind = ConfigTable.ToggleButton[ToggleButton.Name].Keybind
			end

			local ToggleMain = Instance.new("TextButton")
			ToggleMain.Parent = ToggleList
			ToggleMain.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
			ToggleMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleMain.BorderSizePixel = 0
			ToggleMain.Size = UDim2.new(1, 0, 0, 34)
			ToggleMain.AutoButtonColor = false
			ToggleMain.Font = Enum.Font.SourceSans
			ToggleMain.Text = ""
			ToggleMain.TextColor3 = Color3.fromRGB(0, 0, 0)
			ToggleMain.TextSize = 14.000

			local ToggleName = Instance.new("TextLabel")
			ToggleName.Parent = ToggleMain
			ToggleName.AnchorPoint = Vector2.new(0.5, 0.5)
			ToggleName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleName.BackgroundTransparency = 1.000
			ToggleName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleName.BorderSizePixel = 0
			ToggleName.Position = UDim2.new(0.479999989, 0, 0.5, 0)
			ToggleName.Size = UDim2.new(0, 110, 1, 0)
			ToggleName.Font = Enum.Font.Roboto
			ToggleName.Text = ToggleButton.Name
			ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
			ToggleName.TextSize = 15.000
			ToggleName.TextWrapped = true
			ToggleName.TextXAlignment = Enum.TextXAlignment.Left

			local OpenToggleMenu = Instance.new("TextButton")
			OpenToggleMenu.Parent = ToggleMain
			OpenToggleMenu.AnchorPoint = Vector2.new(0.5, 0.5)
			OpenToggleMenu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			OpenToggleMenu.BackgroundTransparency = 1.000
			OpenToggleMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
			OpenToggleMenu.BorderSizePixel = 0
			OpenToggleMenu.Position = UDim2.new(0.930000007, 0, 0.5, 0)
			OpenToggleMenu.Size = UDim2.new(0, 20, 0, 20)
			OpenToggleMenu.Font = Enum.Font.SourceSans
			OpenToggleMenu.Text = "+"
			OpenToggleMenu.TextColor3 = Color3.fromRGB(255, 255, 255)
			OpenToggleMenu.TextScaled = true
			OpenToggleMenu.TextSize = 14.000
			OpenToggleMenu.TextWrapped = true

			--red Color3.fromRGB(192, 57, 43)
			--green Color3.fromRGB(46, 204, 113)
			local IsToggleClicked = false
			local ToggleStatus = Instance.new("Frame")
			ToggleStatus.Parent = ToggleMain
			ToggleStatus.AnchorPoint = Vector2.new(0.5, 0.5)
			ToggleStatus.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
			ToggleStatus.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleStatus.BorderSizePixel = 0
			ToggleStatus.Position = UDim2.new(0.0799999982, 0, 0.5, 0)
			ToggleStatus.Size = UDim2.new(0, 14, 0, 14)

			local UICorner_3 = Instance.new("UICorner")
			UICorner_3.CornerRadius = UDim.new(0, 4)
			UICorner_3.Parent = ToggleStatus

			local IsToggleMenu = false
			local ToggleMenu = Instance.new("Frame")
			ToggleMenu.Parent = ToggleList
			ToggleMenu.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
			ToggleMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleMenu.BorderSizePixel = 0
			ToggleMenu.LayoutOrder = 1
			ToggleMenu.Position = UDim2.new(0, 0, 34, 0)
			ToggleMenu.Size = UDim2.new(1, 0, 0, 0)
			ToggleMenu.Visible = false
			ToggleMenu.AutomaticSize = Enum.AutomaticSize.None

			local MenuTween = "C"
			task.spawn(function()
				repeat
					task.wait()
					if MenuTween == "O" then
						for _, v in pairs(ToggleMenu:GetChildren()) do
							if v:IsA("GuiObject") then
								v.Visible = true
							end
						end
					elseif MenuTween == "C" then
						for _, v in pairs(ToggleMenu:GetChildren()) do
							if v:IsA("GuiObject") then
								v.Visible = false
							end
						end
					end
				until not game
			end)

			local KeyBinds = nil
			if DeviceType == "Mouse" then
				KeyBinds = Instance.new("TextBox")
				KeyBinds.Parent = ToggleMenu
				KeyBinds.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				KeyBinds.BackgroundTransparency = 1.000
				KeyBinds.BorderColor3 = Color3.fromRGB(0, 0, 0)
				KeyBinds.BorderSizePixel = 0
				KeyBinds.LayoutOrder = 99
				KeyBinds.Position = UDim2.new(0.273255825, 0, 2.98461533, 0)
				KeyBinds.Size = UDim2.new(1, 0, 0, 34)
				KeyBinds.Font = Enum.Font.Roboto
				KeyBinds.PlaceholderText = "None"
				KeyBinds.Text = ""
				KeyBinds.TextColor3 = Color3.fromRGB(255, 255, 255)
				KeyBinds.TextSize = 14.000
			elseif DeviceType == "Touch" then
				local SmallKeybinds, IsKeybind = nil, false
				KeyBinds = Instance.new("TextButton")
				KeyBinds.Parent = ToggleMenu
				KeyBinds.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				KeyBinds.BackgroundTransparency = 1.000
				KeyBinds.BorderColor3 = Color3.fromRGB(0, 0, 0)
				KeyBinds.BorderSizePixel = 0
				KeyBinds.LayoutOrder = 99
				KeyBinds.Position = UDim2.new(0.273255825, 0, 2.98461533, 0)
				KeyBinds.Size = UDim2.new(1, 0, 0, 34)
				KeyBinds.Text = "Show"
				KeyBinds.Font = Enum.Font.Roboto
				KeyBinds.TextColor3 = Color3.fromRGB(255, 255, 255)
				KeyBinds.TextSize = 14.000
				KeyBinds.MouseButton1Click:Connect(function()
					IsKeybind = not IsKeybind
					if IsKeybind then
						KeyBinds.TextTransparency = 0.5
						local NewSize4 = game:GetService("TextService"):GetTextSize(ToggleButton.Name, 14, Enum.Font.Roboto, Vector2.new(200, math.huge))
						local MiniKeybind = Instance.new("TextButton")
						MiniKeybind.Parent = KeybindFrame
						MiniKeybind.AnchorPoint = Vector2.new(0.5, 0.5)
						MiniKeybind.BackgroundTransparency = 0.750
						MiniKeybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
						MiniKeybind.BorderSizePixel = 0
						MiniKeybind.Position = UDim2.new(0.5, 0, 0.5, 0)
						MiniKeybind.Size = UDim2.new(0, 65, 0, NewSize4.Y + 15)
						MiniKeybind.Font = Enum.Font.SourceSans
						MiniKeybind.Text = ToggleButton.Name
						MiniKeybind.Name = ToggleButton.Name
						MiniKeybind.TextColor3 = Color3.fromRGB(0, 0, 0)
						MiniKeybind.TextScaled = true
						MiniKeybind.TextSize = 14.000
						MiniKeybind.TextWrapped = true
						MiniKeybind.TextScaled = true
						MakeDraggable(MiniKeybind)

						task.spawn(function()
							repeat
								task.wait()
								if ToggleButton.Enabled then
									MiniKeybind.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
								else
									MiniKeybind.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
								end
							until not game
						end)

						MiniKeybind.MouseButton1Click:Connect(function()
							ToggleButton.Enabled = not ToggleButton.Enabled
							if ToggleButton.Enabled then
								ConfigTable.ToggleButton[ToggleButton.Name].Enabled = true
								ToggleStatus.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
								AddArray(ToggleButton.Name, ToggleButton.Suffix)
								if Library.Notification then
									Main:Notify(ToggleButton.Name, ToggleButton.Name .. " enabled", "i", 5, true)
								end
							else
								ConfigTable.ToggleButton[ToggleButton.Name].Enabled = false
								ToggleStatus.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
								RemoveArray(ToggleButton.Name)
								if Library.Notification then
									Main:Notify(ToggleButton.Name, ToggleButton.Name .. " disabled", "i", 5, true)
								end
							end
							if ToggleButton.Callback then
								ToggleButton.Callback(ToggleButton.Enabled)
							end
						end)
					else
						for _, v in pairs(KeybindFrame:GetChildren()) do
							if v.Name == ToggleButton.Name then
								v:Destroy()
							end
						end
						KeyBinds.TextTransparency = 0
					end
				end)
			end


			UserInputService.InputBegan:Connect(function(Input, isTyping)
				if Input.UserInputType == Enum.UserInputType.Keyboard then
					if KeyBinds:IsFocused() then
						ToggleButton.Keybind = Input.KeyCode.Name
						KeyBinds.Text = Input.KeyCode.Name
						KeyBinds.PlaceholderText = ""
						KeyBinds:ReleaseFocus()
						KeyBinds.PlaceholderText = Input.KeyCode.Name
						KeyBinds.Text = ""
						ConfigTable.ToggleButton[ToggleButton.Name].Keybind = ToggleButton.Keybind
					elseif ToggleButton.Keybind == "Backspace" then
						ToggleButton.Keybind = "Euro"
						KeyBinds.PlaceholderText = "None"
						KeyBinds.Text = ""
						ConfigTable.ToggleButton[ToggleButton.Name].Keybind = ToggleButton.Keybind
					end
				end
				task.spawn(function()
					repeat
						task.wait()
						if ToggleButton.Keybind ~= "Euro" then
							if KeyBinds then
								KeyBinds.PlaceholderText = ""
								KeyBinds.Text = ToggleButton.Keybind
							end
						end
					until not game
				end)
			end)

			local UIListLayout_3 = Instance.new("UIListLayout")
			UIListLayout_3.Parent = ToggleMenu
			UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder

			task.spawn(function()
				repeat
					task.wait()
					if ToggleButton.Suffix then
						for _, v in ipairs(ArrayTable) do
							if v.Text:match(ToggleButton.Name) then
								local NewSuffix = " " .. ToggleButton.Name .. " <font color='rgb(185, 185, 185)'>" .. ToggleButton.Suffix .. " " .. "</font>" .. " "
								if v.Text ~= NewSuffix then
									v.Text = NewSuffix
								end
							end
						end
					end
				until not game
			end)

			OpenToggleMenu.MouseButton1Click:Connect(function()
				IsToggleMenu = not IsToggleMenu
				if IsToggleMenu then
					ToggleMenu.Visible = true
					OpenToggleMenu.Text = "-"
					if GetChildrenY(ToggleMenu) then
						local OpeningMenu = TweenService:Create(ToggleMenu, TweenInfo.new(0.2), {Size = GetChildrenY(ToggleMenu)})
						if OpeningMenu then
							OpeningMenu:Play()
							OpeningMenu.Completed:Connect(function()
								MenuTween = "O"
								ToggleMenu.AutomaticSize = Enum.AutomaticSize.Y
							end)
						end
					end
				else
					OpenToggleMenu.Text = "+"
					local ClosingMenu = TweenService:Create(ToggleMenu, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)})
					if ClosingMenu then
						MenuTween = "C"
						ClosingMenu:Play()
						ToggleMenu.AutomaticSize = Enum.AutomaticSize.None
						ClosingMenu.Completed:Connect(function()
							ToggleMenu.Visible = false
						end)
					end
				end
			end)

			ToggleMain.MouseButton2Click:Connect(function()
				IsToggleMenu = not IsToggleMenu
				if IsToggleMenu then
					ToggleMenu.Visible = true
					OpenToggleMenu.Text = "-"
					if GetChildrenY(ToggleMenu) then
						local OpeningMenu = TweenService:Create(ToggleMenu, TweenInfo.new(0.2), {Size = GetChildrenY(ToggleMenu)})
						if OpeningMenu then
							OpeningMenu:Play()
							OpeningMenu.Completed:Connect(function()
								MenuTween = "O"
								ToggleMenu.AutomaticSize = Enum.AutomaticSize.Y
							end)
						end
					end
				else
					OpenToggleMenu.Text = "+"
					local ClosingMenu = TweenService:Create(ToggleMenu, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)})
					if ClosingMenu then
						MenuTween = "C"
						ClosingMenu:Play()
						ToggleMenu.AutomaticSize = Enum.AutomaticSize.None
						ClosingMenu.Completed:Connect(function()
							ToggleMenu.Visible = false
						end)
					end
				end
			end)

			ToggleMain.MouseButton1Click:Connect(function()
				ToggleButton.Enabled = not ToggleButton.Enabled
				if ToggleButton.Enabled then
					ConfigTable.ToggleButton[ToggleButton.Name].Enabled = true
					ToggleStatus.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
					AddArray(ToggleButton.Name, ToggleButton.Suffix)
					if Library.Notification then
						Main:Notify(ToggleButton.Name, ToggleButton.Name .. " enabled", "i", 5, true)
					end
				else
					ConfigTable.ToggleButton[ToggleButton.Name].Enabled = false
					ToggleStatus.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
					RemoveArray(ToggleButton.Name)
					if Library.Notification then
						Main:Notify(ToggleButton.Name, ToggleButton.Name .. " disabled", "i", 5, true)
					end
				end
				if ToggleButton.Callback then
					ToggleButton.Callback(ToggleButton.Enabled)
				end
			end)

			if ToggleButton.Keybind then
				UserInputService.InputBegan:Connect(function(Input, isTyping)
					if Input.KeyCode == Enum.KeyCode[ToggleButton.Keybind] and not isTyping then
						ToggleButton.Enabled = not ToggleButton.Enabled
						if ToggleButton.Enabled then
							ConfigTable.ToggleButton[ToggleButton.Name].Enabled = true
							ToggleStatus.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
							AddArray(ToggleButton.Name, ToggleButton.Suffix)
							if Library.Notification then
								Main:Notify(ToggleButton.Name, ToggleButton.Name .. " enabled", "i", 5, true)
							end
						else
							ConfigTable.ToggleButton[ToggleButton.Name].Enabled = false
							ToggleStatus.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
							RemoveArray(ToggleButton.Name)
							if Library.Notification then
								Main:Notify(ToggleButton.Name, ToggleButton.Name .. " disabled", "i", 5, true)
							end
						end
						if ToggleButton.Callback then
							ToggleButton.Callback(ToggleButton.Enabled)
						end
					end
				end)
			end

			function ToggleButton:CreateMiniToggle(MiniToggle)
				MiniToggle = {
					Name = MiniToggle.Name,
					Enabled = MiniToggle.Enabled or false,
					Callback = MiniToggle.Callback or function() end
				}
				if not ConfigTable.MiniToggle[MiniToggle.Name] then
					ConfigTable.MiniToggle[MiniToggle.Name] = {
						Enabled = MiniToggle.Enabled
					}
				else
					MiniToggle.Enabled = ConfigTable.MiniToggle[MiniToggle.Name].Enabled
				end

				local MiniToggleMain = Instance.new("TextButton")
				MiniToggleMain.Parent = ToggleMenu
				MiniToggleMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleMain.BackgroundTransparency = 1.000
				MiniToggleMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleMain.BorderSizePixel = 0
				MiniToggleMain.Size = UDim2.new(1, 0, 0, 34)
				MiniToggleMain.AutoButtonColor = false
				MiniToggleMain.Font = Enum.Font.SourceSans
				MiniToggleMain.Text = ""
				MiniToggleMain.TextColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleMain.TextSize = 14.000

				local MiniToggleName = Instance.new("TextLabel")
				MiniToggleName.Parent = MiniToggleMain
				MiniToggleName.AnchorPoint = Vector2.new(0.5, 0.5)
				MiniToggleName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleName.BackgroundTransparency = 1.000
				MiniToggleName.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleName.BorderSizePixel = 0
				MiniToggleName.Position = UDim2.new(0.519999981, 0, 0.5, 0)
				MiniToggleName.Size = UDim2.new(0, 110, 1, 0)
				MiniToggleName.Font = Enum.Font.Roboto
				MiniToggleName.Text = MiniToggle.Name
				MiniToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleName.TextSize = 15.000
				MiniToggleName.TextWrapped = true
				MiniToggleName.TextXAlignment = Enum.TextXAlignment.Left

				local MiniToggleStatus = Instance.new("Frame")
				MiniToggleStatus.Parent = MiniToggleMain
				MiniToggleStatus.AnchorPoint = Vector2.new(0.5, 0.5)
				MiniToggleStatus.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
				MiniToggleStatus.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleStatus.BorderSizePixel = 0
				MiniToggleStatus.Position = UDim2.new(0.119999997, 0, 0.5, 0)
				MiniToggleStatus.Size = UDim2.new(0, 14, 0, 14)

				local UICorner_4 = Instance.new("UICorner")
				UICorner_4.CornerRadius = UDim.new(0, 4)
				UICorner_4.Parent = MiniToggleStatus

				MiniToggleMain.MouseButton1Click:Connect(function()
					MiniToggle.Enabled = not MiniToggle.Enabled
					if MiniToggle.Enabled then
						ConfigTable.MiniToggle[MiniToggle.Name].Enabled = true
						MiniToggleStatus.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
					else
						ConfigTable.MiniToggle[MiniToggle.Name].Enabled = false
						MiniToggleStatus.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
					end
					if MiniToggle.Callback then
						MiniToggle.Callback(MiniToggle.Enabled)
					end
				end)

				return MiniToggle
			end

			function ToggleButton:CreateSlider(Slider)
				Slider = {
					Name = Slider.Name,
					Min = Slider.Min or 0,
					Max = Slider.Max or 100,
					Default = Slider.Default,
					Callback = Slider.Callback or function() end
				}
				if not ConfigTable.Slider[Slider.Name] then
					ConfigTable.Slider[Slider.Name] = {
						Default = Slider.Default
					}
				else
					Slider.Default = ConfigTable.Slider[Slider.Name].Default
				end

				local Value
				local Dragged = false
				local SliderMain = Instance.new("Frame")
				SliderMain.Parent = ToggleMenu
				SliderMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderMain.BackgroundTransparency = 1.000
				SliderMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderMain.BorderSizePixel = 0
				SliderMain.Size = UDim2.new(1, 0, 0, 34)

				local SliderBack = Instance.new("Frame")
				SliderBack.Parent = SliderMain
				SliderBack.AnchorPoint = Vector2.new(0.5, 0.5)
				SliderBack.BackgroundColor3 = Color3.fromRGB(124, 92, 92)
				SliderBack.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderBack.BorderSizePixel = 0
				SliderBack.Position = UDim2.new(0.5, 0, 0.800000012, 0)
				SliderBack.Size = UDim2.new(0, 150, 0, 3)

				local SliderFront = Instance.new("Frame")
				SliderFront.Parent = SliderBack
				SliderFront.BackgroundColor3 = Color3.fromRGB(92, 124, 92)
				SliderFront.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderFront.BorderSizePixel = 0

				local SliderDrag = Instance.new("TextButton")
				SliderDrag.Parent = SliderFront
				SliderDrag.BackgroundColor3 = Color3.fromRGB(92, 92, 124)
				SliderDrag.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderDrag.BorderSizePixel = 0
				SliderDrag.Position = UDim2.new(1, 0, -0.899999976, 0)
				SliderDrag.Size = UDim2.new(0, 8, 0, 8)
				SliderDrag.Font = Enum.Font.SourceSans
				SliderDrag.Text = ""
				SliderDrag.TextColor3 = Color3.fromRGB(0, 0, 0)
				SliderDrag.TextSize = 14.000

				local SliderName = Instance.new("TextLabel")
				SliderName.Parent = SliderMain
				SliderName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderName.BackgroundTransparency = 1.000
				SliderName.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderName.BorderSizePixel = 0
				SliderName.Position = UDim2.new(0.0697674453, 0, -0.150000006, 0)
				SliderName.Size = UDim2.new(0, 115, 1, 0)
				SliderName.Font = Enum.Font.Roboto
				SliderName.Text = "Range: 11.0"
				SliderName.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderName.TextSize = 13.000
				SliderName.TextWrapped = true
				SliderName.TextXAlignment = Enum.TextXAlignment.Left

				local function UpdateValue(input)
					local sliderPos = SliderMain.AbsolutePosition.X
					local sliderWidth = SliderMain.AbsoluteSize.X
					local mouseX = math.clamp(input.Position.X, sliderPos, sliderPos + sliderWidth)
					local percent = (mouseX - sliderPos) / sliderWidth
					Value = math.floor((Slider.Min + (Slider.Max - Slider.Min) * percent) * 10) / 10
					SliderFront.Size = UDim2.new(percent, 0, 1, 0)
					SliderName.Text = string.format(Slider.Name .. ": %.1f", Value)
					Slider.Callback(Value)
					ConfigTable.Slider[Slider.Name].Default = Value
				end

				SliderDrag.MouseButton1Down:Connect(function()
					Dragged = true
				end)

				UserInputService.InputChanged:Connect(function(Input)
					if Dragged and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
						UpdateValue(Input)
					end
				end)

				UserInputService.InputEnded:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						Dragged = false
					end
				end)

				if Slider.Default then
					Value = math.clamp(Slider.Default, Slider.Min, Slider.Max)
					SliderName.Text = string.format(Slider.Name .. ": %.1f", Value)
					local percent = (Value - Slider.Min) / (Slider.Max - Slider.Min)
					SliderFront.Size = UDim2.fromScale(percent, 1)
					Slider.Callback(Value)
				else
					Value = math.clamp(0, Slider.Min, Slider.Max)
					SliderName.Text = string.format(Slider.Name .. ": %.1f", Value)
					local percent = (Value - Slider.Min) / (Slider.Max - Slider.Min)
					SliderFront.Size = UDim2.fromScale(percent, 1)
					Slider.Callback(Value)
				end

				return Slider
			end

			function ToggleButton:CreateDropdown(Dropdown)
				Dropdown = {
					Name = Dropdown.Name,
					List = Dropdown.List or {},
					Default = Dropdown.Default,
					Callback = Dropdown.Callback or function() end
				}
				if not ConfigTable.Dropdown[Dropdown.Name] then
					ConfigTable.Dropdown[Dropdown.Name] = {
						Default = Dropdown.Default
					}
				else
					Dropdown.Default = ConfigTable.Dropdown[Dropdown.Name].Default
				end
				
				local Selected
				local CurrentDropdown = 1
				local DropdownMain = Instance.new("TextButton")
				DropdownMain.Parent = ToggleMenu
				DropdownMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownMain.BackgroundTransparency = 1.000
				DropdownMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownMain.BorderSizePixel = 0
				DropdownMain.Size = UDim2.new(1, 0, 0, 34)
				DropdownMain.Font = Enum.Font.SourceSans
				DropdownMain.Text = ""
				DropdownMain.TextColor3 = Color3.fromRGB(0, 0, 0)
				DropdownMain.TextSize = 14.000

				local DropdownResult = Instance.new("TextLabel")
				DropdownResult.Parent = DropdownMain
				DropdownResult.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownResult.BackgroundTransparency = 1.000
				DropdownResult.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownResult.BorderSizePixel = 0
				DropdownResult.Position = UDim2.new(0.0697674453, 0, 0, 0)
				DropdownResult.Size = UDim2.new(1, 0, 1, 0)
				DropdownResult.Font = Enum.Font.Roboto
				DropdownResult.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownResult.TextSize = 15.000
				DropdownResult.TextWrapped = true
				DropdownResult.TextXAlignment = Enum.TextXAlignment.Left

				DropdownMain.MouseButton1Click:Connect(function()
					CurrentDropdown = CurrentDropdown % #Dropdown.List + 1
					DropdownResult.Text = Dropdown.Name .. ": " .. Dropdown.List[CurrentDropdown]
					Selected = Dropdown.List[CurrentDropdown]
					Dropdown.Callback(Selected)
					ConfigTable.Dropdown[Dropdown.Name].Default = Selected
				end)

				DropdownMain.MouseButton2Click:Connect(function()
					CurrentDropdown = (CurrentDropdown - 2) % #Dropdown.List + 1
					DropdownResult.Text = Dropdown.Name .. ": " .. Dropdown.List[CurrentDropdown]
					Selected = Dropdown.List[CurrentDropdown]
					Dropdown.Callback(Dropdown.List[CurrentDropdown])
					ConfigTable.Dropdown[Dropdown.Name].Default = Selected
				end)

				if Dropdown.Default then
					DropdownResult.Text =  Dropdown.Name .. ": " .. Dropdown.Default or "None"
					Dropdown.Callback(Dropdown.Default)
				else
					DropdownResult.Text = Dropdown.Name .. ": " .. Dropdown.List[1] or "None"
					Dropdown.Callback(Dropdown.List[1])
				end

				return Dropdown	
			end

			return ToggleButton
		end

		return Tabs	
	end

	return Main
end

return Library
