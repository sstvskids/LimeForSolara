local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local CoreGui = game:GetService("CoreGui")
local MainFolder, ConfigFolder, LogsFolder = "Eternal", "Eternal/configs", "Eternal/logs"
local Settings = {ToggleButton = {MiniToggle = {}, Sliders = {}, Dropdown = {}}}
local AutoSave = false

local function LoadSettings(path)
	return isfile(path) and HttpService:JSONDecode(readfile(path)) or nil
end

local function SaveSettings(path, settings)
	writefile(path, HttpService:JSONEncode(settings))
end

if isfolder(MainFolder) and isfolder(ConfigFolder) and isfolder(LogsFolder) then
	local FileMain = ConfigFolder .. "/" .. game.PlaceId .. ".lua"
	local LoadedSettings = LoadSettings(FileMain)
	if LoadedSettings then Settings = LoadedSettings end
	AutoSave = true

	spawn(function()
		while AutoSave do
			wait(3)
			SaveSettings(FileMain, Settings)
		end
	end)
end

local Library = {
	CurrentVersion = 2.1,
	Settings = {
		LibraryKeybind = "RightShift",
		LibraryColor = Color3.fromRGB(170, 255, 0),
		MobileSupport = false,
	}
}

function MakeDraggable(object)
	local dragging, dragInput, dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	object.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	object.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

function Library:CreateMain()
	local Main = {}

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "Eternal_" .. Library.CurrentVersion
	if RunService:IsStudio() then
		ScreenGui.Parent = PlayerGui
	elseif game.PlaceId == 11630038968 then
		ScreenGui.Parent = PlayerGui:FindFirstChild("MainGui")
	else
		ScreenGui.Parent = CoreGui
	end

	local MainFrame = Instance.new("Frame")
	MainFrame.Parent = ScreenGui
	MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MainFrame.BackgroundTransparency = 1.000
	MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MainFrame.BorderSizePixel = 0
	MainFrame.Size = UDim2.new(1, 0, 1, 0)
	MainFrame.Visible = false

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Parent = MainFrame
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	local UIPadding = Instance.new("UIPadding")
	UIPadding.Parent = MainFrame
	UIPadding.PaddingLeft = UDim.new(0, 20)
	UIPadding.PaddingTop = UDim.new(0, 55)

	local OtherFrame = Instance.new("Frame")
	OtherFrame.Parent = ScreenGui
	OtherFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	OtherFrame.BackgroundTransparency = 1.000
	OtherFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	OtherFrame.BorderSizePixel = 0
	OtherFrame.Size = UDim2.new(1, 0, 1, 0)
	OtherFrame.ZIndex = -1

	local TrashCans = Instance.new("ImageLabel")
	TrashCans.Parent = OtherFrame
	TrashCans.AnchorPoint = Vector2.new(0.5, 0.5)
	TrashCans.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TrashCans.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TrashCans.Visible = false
	TrashCans.BorderSizePixel = 0
	TrashCans.Position = UDim2.new(0.948977232, 0, 0.901647091, 0)
	TrashCans.Size = UDim2.new(0, 80, 0, 80)
	TrashCans.Image = "rbxassetid://8463436236"
	TrashCans.Visible = false
	spawn(function()
		while true do
			wait()
			if Library.Settings.MobileSupport then
				TrashCans.Visible = true
			else
				TrashCans.Visible = false
			end
		end
	end)

	local UICorner_7 = Instance.new("UICorner")
	UICorner_7.CornerRadius = UDim.new(0, 4)
	UICorner_7.Parent = TrashCans

	local HudsFrame = Instance.new("Frame")
	HudsFrame.Parent = ScreenGui
	HudsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HudsFrame.BackgroundTransparency = 1.000
	HudsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HudsFrame.BorderSizePixel = 0
	HudsFrame.Size = UDim2.new(1, 0, 1, 0)
	HudsFrame.ZIndex = -1

	local LogoFrame = Instance.new("Frame")
	LogoFrame.Parent = HudsFrame
	LogoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	LogoFrame.BackgroundTransparency = 0.180
	LogoFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogoFrame.BorderSizePixel = 0
	LogoFrame.Position = UDim2.new(0.00932994019, 0, 0.0187969916, 0)
	LogoFrame.Size = UDim2.new(0, 155, 0, 22)

	local TopFrame = Instance.new("Frame")
	TopFrame.Parent = LogoFrame
	TopFrame.BackgroundColor3 = Library.Settings.LibraryColor
	TopFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TopFrame.BorderSizePixel = 0
	TopFrame.Size = UDim2.new(1, 0, 0, 2)

	local LogoText = Instance.new("TextLabel")
	LogoText.Parent = LogoFrame
	LogoText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LogoText.BackgroundTransparency = 1.000
	LogoText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogoText.BorderSizePixel = 0
	LogoText.Position = UDim2.new(0.0299999993, 0, 0.100000001, 0)
	LogoText.Size = UDim2.new(1, 0, 0, 18)
	LogoText.Font = Enum.Font.SourceSans
	LogoText.Text = "Eternal " .. Library.CurrentVersion .. " | " .. game.Players.LocalPlayer.Name .. " | " .. game.PlaceId
	LogoText.TextColor3 = Library.Settings.LibraryColor
	LogoText.TextSize = 14.000
	LogoText.TextWrapped = true
	LogoText.TextXAlignment = Enum.TextXAlignment.Left

	local NewSize = game:GetService("TextService"):GetTextSize(LogoText.Text, LogoText.TextSize, LogoText.Font, Vector2.new(math.huge, math.huge))
	LogoFrame.Size = UDim2.new(0, NewSize.X + 12, 0, 22)

	local OpenGui = Instance.new("TextButton")
	OpenGui.Parent = ScreenGui
	OpenGui.AnchorPoint = Vector2.new(0.5, 0.5)
	OpenGui.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	OpenGui.BorderColor3 = Color3.fromRGB(0, 0, 0)
	OpenGui.BorderSizePixel = 0
	OpenGui.Position = UDim2.new(0.5, 0, 0.0450000018, 0)
	OpenGui.Size = UDim2.new(0, 18, 0, 18)
	OpenGui.ZIndex = -2
	OpenGui.Font = Enum.Font.SourceSans
	OpenGui.Text = "+"
	OpenGui.TextColor3 = Color3.fromRGB(255, 255, 255)
	OpenGui.TextScaled = true
	OpenGui.TextSize = 14.000
	OpenGui.TextWrapped = true
	OpenGui.AutoButtonColor = false

	local UICorner_5 = Instance.new("UICorner")
	UICorner_5.CornerRadius = UDim.new(0, 4)
	UICorner_5.Parent = OpenGui

	local ArrayTable = {}
	local ArraylistFrame = Instance.new("Frame")
	ArraylistFrame.Parent = HudsFrame
	ArraylistFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ArraylistFrame.BackgroundTransparency = 1.000
	ArraylistFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ArraylistFrame.BorderSizePixel = 0
	ArraylistFrame.Position = UDim2.new(0.799537122, 0, 0.0243661068, 0)
	ArraylistFrame.Size = UDim2.new(0.168943331, 0, 0.975633919, 0)

	local UIListLayout_5 = Instance.new("UIListLayout")
	UIListLayout_5.Parent = ArraylistFrame
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_5.HorizontalAlignment = Enum.HorizontalAlignment.Right

	local function AddArray(name)
		local TextLabel = Instance.new("TextLabel")
		TextLabel.Parent = ArraylistFrame
		TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.BackgroundTransparency = 1.000
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Font = Enum.Font.SourceSans
		TextLabel.Text = name
		TextLabel.TextColor3 = Library.Settings.LibraryColor
		TextLabel.TextScaled = true
		TextLabel.TextSize = 18.000
		TextLabel.TextWrapped = true
		TextLabel.TextXAlignment = Enum.TextXAlignment.Right

		local size = UDim2.new(0.01, game.TextService:GetTextSize(name , 18, Enum.Font.SourceSans, Vector2.new(0,0)).X, 0.03,0)
		if name == "" then
			size = UDim2.fromScale(0,0)
		end

		TextLabel.Size = size
		table.insert(ArrayTable,TextLabel)
		table.sort(ArrayTable,function(a,b) return game.TextService:GetTextSize(a.Text .. "  ", 18, Enum.Font.SourceSans, Vector2.new(0,0)).X > game.TextService:GetTextSize(b.Text .. "  ", 18, Enum.Font.SourceSans,Vector2.new(0,0)).X end)
		for i,v in ipairs(ArrayTable) do
			v.LayoutOrder = i
		end
	end

	local function RemoveArray(name)
		table.sort(ArrayTable,function(a,b) return game.TextService:GetTextSize(a.Text.."  ",18,Enum.Font.SourceSans,Vector2.new(0,0)).X > game.TextService:GetTextSize(b.Text.."  ",18,Enum.Font.SourceSans,Vector2.new(0,0)).X end)
		local c = 0
		for i,v in ipairs(ArrayTable) do
			c += 1
			if (v.Text == name) then
				v:Destroy()
				table.remove(ArrayTable,c)
			else
				v.LayoutOrder = i
			end
		end
	end

	OpenGui.MouseButton1Click:Connect(function()
		MainFrame.Visible = not MainFrame.Visible
		if Library.Settings.MobileSupport then
			TrashCans.Visible = MainFrame.Visible
		end
	end)

	UserInputService.InputBegan:Connect(function(Input, isTyping)
		if Input.KeyCode == Enum.KeyCode[Library.Settings.LibraryKeybind] and not isTyping then
			MainFrame.Visible = not MainFrame.Visible
			if Library.Settings.MobileSupport then
				TrashCans.Visible = MainFrame.Visible
			end
		end
	end)

	local TargetHudFrame = Instance.new("Frame")
	local TargetName = Instance.new("TextLabel")
	local FightResult = Instance.new("TextLabel")
	local HealthBack = Instance.new("Frame")
	local HealthFront = Instance.new("Frame")
	local TargetPicture = Instance.new("ImageLabel")

	function Main:TargetHud(targetname, targetpfp, targethumanoid, localplayerhumanoid, visibletarget)
		local TargetHuds = {}

		TargetHudFrame.Parent = HudsFrame
		TargetHudFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		TargetHudFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		TargetHudFrame.BackgroundTransparency = 0.350
		TargetHudFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TargetHudFrame.BorderSizePixel = 0
		TargetHudFrame.Position = UDim2.new(0.649999976, 0, 0.649999976, 0)
		TargetHudFrame.Size = UDim2.new(0, 165, 0, 50)
		TargetHudFrame.Visible = visibletarget

		TargetName.Parent = TargetHudFrame
		TargetName.AnchorPoint = Vector2.new(0.5, 0.5)
		TargetName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TargetName.BackgroundTransparency = 1.000
		TargetName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TargetName.BorderSizePixel = 0
		TargetName.Position = UDim2.new(0.626893938, 0, 0.25, 0)
		TargetName.Size = UDim2.new(0, 112, 0, 14)
		TargetName.Font = Enum.Font.SourceSans
		TargetName.TextColor3 = Color3.fromRGB(255, 255, 255)
		TargetName.TextScaled = true
		TargetName.TextSize = 14.000
		TargetName.TextWrapped = true
		TargetName.TextXAlignment = Enum.TextXAlignment.Left

		FightResult.Parent = TargetHudFrame
		FightResult.AnchorPoint = Vector2.new(0.5, 0.5)
		FightResult.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		FightResult.BackgroundTransparency = 1.000
		FightResult.BorderColor3 = Color3.fromRGB(0, 0, 0)
		FightResult.BorderSizePixel = 0
		FightResult.Position = UDim2.new(0.6280303, 0, 0.5, 0)
		FightResult.Size = UDim2.new(0, 112, 0, 14)
		FightResult.Font = Enum.Font.SourceSans
		FightResult.TextColor3 = Color3.fromRGB(255, 255, 255)
		FightResult.TextScaled = true
		FightResult.TextSize = 14.000
		FightResult.TextWrapped = true
		FightResult.TextXAlignment = Enum.TextXAlignment.Left

		HealthBack.Parent = TargetHudFrame
		HealthBack.AnchorPoint = Vector2.new(0.5, 0.5)
		HealthBack.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
		HealthBack.BorderColor3 = Color3.fromRGB(0, 0, 0)
		HealthBack.BorderSizePixel = 0
		HealthBack.Position = UDim2.new(0.5, 0, 0.850000024, 0)
		HealthBack.Size = UDim2.new(0, 155, 0, 5)

		HealthFront.Parent = HealthBack
		HealthFront.BackgroundColor3 = Library.Settings.LibraryColor
		HealthFront.BorderColor3 = Color3.fromRGB(0, 0, 0)
		HealthFront.BorderSizePixel = 0
		HealthFront.Size = UDim2.new(0, 155, 0, 5)

		TargetPicture.Name = "TargetPicture"
		TargetPicture.Parent = TargetHudFrame
		TargetPicture.AnchorPoint = Vector2.new(0.5, 0.5)
		TargetPicture.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TargetPicture.BackgroundTransparency = 1.000
		TargetPicture.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TargetPicture.BorderSizePixel = 0
		TargetPicture.Position = UDim2.new(0.150000006, 0, 0.400000006, 0)
		TargetPicture.Size = UDim2.new(0, 28, 0, 28)

		TargetName.Text = targetname
		TargetPicture.Image = targetpfp

		if targethumanoid and localplayerhumanoid then
			if localplayerhumanoid.Health > targethumanoid.Health then
				FightResult.Text = "Winning"
			elseif localplayerhumanoid.Health < targethumanoid.Health then
				FightResult.Text = "Losing"
			else
				FightResult.Text = "Tie"
			end
		end

		HealthFront.Size = UDim2.new(targethumanoid.Health /targethumanoid.MaxHealth, 0, 1, 0)
		return TargetHuds
	end	

	function Main:CreateTab(name, customsettings)
		local Tabs = {}

		local TabHolder = Instance.new("Frame")
		TabHolder.Parent = MainFrame
		TabHolder.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
		TabHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabHolder.BorderSizePixel = 0
		TabHolder.Size = UDim2.new(0, 118, 0, 25)

		local TabName = Instance.new("TextLabel")
		TabName.Parent = TabHolder
		TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabName.BackgroundTransparency = 1.000
		TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabName.BorderSizePixel = 0
		TabName.Size = UDim2.new(1, 0, 1, 0)
		TabName.Font = Enum.Font.SourceSans
		TabName.Text = name
		TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabName.TextScaled = true
		TabName.TextSize = 14.000
		TabName.TextWrapped = true

		local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
		UITextSizeConstraint.Parent = TabName
		UITextSizeConstraint.MaxTextSize = 14

		local TogglesList = Instance.new("Frame")
		TogglesList.Parent = TabHolder
		TogglesList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TogglesList.BackgroundTransparency = 1
		TogglesList.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TogglesList.BorderSizePixel = 0
		TogglesList.Position = UDim2.new(0, 0, 1, 0)
		TogglesList.Size = UDim2.new(1, 0, -6.24980021, 211)

		local UIListLayout_2 = Instance.new("UIListLayout")
		UIListLayout_2.Parent = TogglesList
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

		local ClientSettings = Instance.new("TextButton")
		ClientSettings.Parent = TogglesList
		ClientSettings.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		ClientSettings.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ClientSettings.BorderSizePixel = 0
		ClientSettings.LayoutOrder = 99
		ClientSettings.AutoButtonColor = false
		ClientSettings.Text = ""
		ClientSettings.Size = UDim2.new(1, 0, 0, 22)
		ClientSettings.Visible = false

		local OpenClientMenu = false
		local ClientOpen = Instance.new("TextButton")
		ClientOpen.Parent = ClientSettings
		ClientOpen.AnchorPoint = Vector2.new(0.5, 0.5)
		ClientOpen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ClientOpen.BackgroundTransparency = 1.000
		ClientOpen.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ClientOpen.BorderSizePixel = 0
		ClientOpen.Position = UDim2.new(0.899999976, 0, 0.5, 0)
		ClientOpen.Size = UDim2.new(0, 18, 0, 18)
		ClientOpen.Font = Enum.Font.SourceSans
		ClientOpen.Text = "+"
		ClientOpen.TextColor3 = Color3.fromRGB(255, 255, 255)
		ClientOpen.TextScaled = true
		ClientOpen.TextSize = 14.000
		ClientOpen.TextWrapped = true

		local SettingsName = Instance.new("TextLabel")
		SettingsName.Parent = ClientSettings
		SettingsName.AnchorPoint = Vector2.new(0.5, 0.5)
		SettingsName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SettingsName.BackgroundTransparency = 1.000
		SettingsName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SettingsName.BorderSizePixel = 0
		SettingsName.Position = UDim2.new(0.5, 0, 0.5, 0)
		SettingsName.Size = UDim2.new(0, 80, 0, 15)
		SettingsName.Font = Enum.Font.SourceSans
		SettingsName.Text = "Client Settings"
		SettingsName.TextColor3 = Color3.fromRGB(255, 255, 255)
		SettingsName.TextSize = 13.000
		SettingsName.TextXAlignment = Enum.TextXAlignment.Left

		local ClientMenuOld = UDim2.new(1, 0, 0, 0)
		local ClientMenuNew = UDim2.new(1, 0, 0, 65)
		local ClientMenu = Instance.new("Frame")
		ClientMenu.Parent = TogglesList
		ClientMenu.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		ClientMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ClientMenu.BorderSizePixel = 0
		ClientMenu.LayoutOrder = 100
		ClientMenu.Position = UDim2.new(0, 0, 0.497959971, 0)
		ClientMenu.Size = UDim2.new(1, 0, 0, 65)
		ClientMenu.Visible = false

		local ClientList = Instance.new("ScrollingFrame")
		ClientList.Parent = ClientMenu
		ClientList.Active = true
		ClientList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ClientList.BackgroundTransparency = 1.000
		ClientList.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ClientList.BorderSizePixel = 0
		ClientList.Size = UDim2.new(1, 0, 1, 0)
		ClientList.ScrollBarThickness = 2
		ClientList.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
		ClientList.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
		ClientList.CanvasSize = UDim2.new(0, 0, 1, 0)

		local UIListLayout_4 = Instance.new("UIListLayout")
		UIListLayout_4.Parent = ClientList
		UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder


		local MobileSupport = Instance.new("TextButton")
		MobileSupport.Parent = ClientList
		MobileSupport.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		MobileSupport.BackgroundTransparency = 1.000
		MobileSupport.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MobileSupport.BorderSizePixel = 0
		MobileSupport.Size = UDim2.new(1, 0, 0, 23)
		MobileSupport.AutoButtonColor = false
		MobileSupport.Font = Enum.Font.SourceSans
		MobileSupport.Text = ""
		MobileSupport.TextColor3 = Color3.fromRGB(0, 0, 0)
		MobileSupport.TextSize = 14.000

		local MobileSupportName = Instance.new("TextLabel")
		MobileSupportName.Parent = MobileSupport
		MobileSupportName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		MobileSupportName.BackgroundTransparency = 1.000
		MobileSupportName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MobileSupportName.BorderSizePixel = 0
		MobileSupportName.Position = UDim2.new(0.200000003, 0, 0.158999994, 0)
		MobileSupportName.Size = UDim2.new(0, 80, 0, 15)
		MobileSupportName.Font = Enum.Font.SourceSans
		MobileSupportName.Text = "MobileSupport"
		MobileSupportName.TextColor3 = Color3.fromRGB(255, 255, 255)
		MobileSupportName.TextSize = 13.000
		MobileSupportName.TextXAlignment = Enum.TextXAlignment.Left

		local MobileSupportEnabled = false
		local MobileSupportStatus = Instance.new("Frame")
		MobileSupportStatus.Parent = MobileSupport
		MobileSupportStatus.BackgroundColor3 = Color3.fromRGB(175, 0, 0)
		MobileSupportStatus.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MobileSupportStatus.BorderSizePixel = 0
		MobileSupportStatus.Position = UDim2.new(0.075000003, 0, 0.254000008, 0)
		MobileSupportStatus.Size = UDim2.new(0, 10, 0, 10)

		local UICorner_4 = Instance.new("UICorner")
		UICorner_4.CornerRadius = UDim.new(0, 3)
		UICorner_4.Parent = MobileSupportStatus

		MobileSupport.MouseButton1Click:Connect(function()
			MobileSupportEnabled = not MobileSupportEnabled
			if MobileSupportEnabled then
				Library.Settings.MobileSupport = true
				MobileSupportStatus.BackgroundColor3 = Color3.fromRGB(0, 175, 0)
			else
				Library.Settings.MobileSupport = false
				MobileSupportStatus.BackgroundColor3 = Color3.fromRGB(175, 0, 0)
			end
		end)

		local KeybindChanger = Instance.new("TextBox")
		KeybindChanger.Parent = ClientList
		KeybindChanger.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		KeybindChanger.BorderColor3 = Color3.fromRGB(0, 0, 0)
		KeybindChanger.BorderSizePixel = 0
		KeybindChanger.Size = UDim2.new(1, 0, 0, 23)
		KeybindChanger.Font = Enum.Font.SourceSans
		KeybindChanger.PlaceholderText = Library.Settings.LibraryKeybind
		KeybindChanger.Text = ""
		KeybindChanger.TextXAlignment = Enum.TextXAlignment.Center
		KeybindChanger.TextYAlignment = Enum.TextYAlignment.Center
		KeybindChanger.TextColor3 = Color3.fromRGB(255, 255, 255)
		KeybindChanger.TextSize = 14.000
		UserInputService.InputBegan:Connect(function(Input, isTyping)
			if Input.UserInputType == Enum.UserInputType.Keyboard then
				if KeybindChanger:IsFocused() then
					Library.Settings.LibraryKeybind = Input.KeyCode.Name
					KeybindChanger.Text = Input.KeyCode.Name
					KeybindChanger.PlaceholderText = Input.KeyCode.Name
					KeybindChanger:ReleaseFocus() 
				end       
			end
		end)

		if customsettings then
			ClientSettings.Visible = true
		end

		ClientSettings.MouseButton2Click:Connect(function()
			OpenClientMenu = not OpenClientMenu
			if OpenClientMenu then
				ClientOpen.Text = "-"
				TweenService:Create(ClientMenu, TweenInfo.new(0.2), {Visible = true, Size = ClientMenuNew}):Play()
			else
				ClientOpen.Text = "+"
				TweenService:Create(ClientMenu, TweenInfo.new(0.2), {Visible = false, Size = ClientMenuOld}):Play()
			end
		end)

		ClientOpen.MouseButton1Click:Connect(function()
			OpenClientMenu = not OpenClientMenu
			if OpenClientMenu then
				ClientOpen.Text = "-"
				TweenService:Create(ClientMenu, TweenInfo.new(0.2), {Visible = true, Size = ClientMenuNew}):Play()
			else
				ClientOpen.Text = "+"
				TweenService:Create(ClientMenu, TweenInfo.new(0.2), {Visible = false, Size = ClientMenuOld}):Play()
			end
		end)

		function Tabs:CreateToggle(ToggleButton)
			ToggleButton = {
				Name = ToggleButton.Name,
				Enabled = ToggleButton.Enabled or false,
				AutoDisable = ToggleButton.AutoDisable or false,
				Keybind = ToggleButton.Keybind or "Insert",
				Callback = ToggleButton.Callback or function() end
			}
			if not Settings.ToggleButton[ToggleButton.Name] then
				Settings.ToggleButton[ToggleButton.Name] = {
					Enabled = ToggleButton.Enabled,
					Keybind = ToggleButton.Keybind,
				}
			else
				ToggleButton.Enabled = Settings.ToggleButton[ToggleButton.Name].Enabled
				ToggleButton.Keybind = Settings.ToggleButton[ToggleButton.Name].Keybind
			end

			local ToggleButtonHolder = Instance.new("TextButton")
			ToggleButtonHolder.Parent = TogglesList
			ToggleButtonHolder.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
			ToggleButtonHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleButtonHolder.BorderSizePixel = 0
			ToggleButtonHolder.LayoutOrder = 1
			ToggleButtonHolder.Size = UDim2.new(1, 0, 0, 27)
			ToggleButtonHolder.AutoButtonColor = false
			ToggleButtonHolder.Font = Enum.Font.SourceSans
			ToggleButtonHolder.Text = ""
			ToggleButtonHolder.TextColor3 = Color3.fromRGB(0, 0, 0)
			ToggleButtonHolder.TextSize = 14.000

			local OpenToggleMenu = false
			local OpenMenu = Instance.new("TextButton")
			OpenMenu.Parent = ToggleButtonHolder
			OpenMenu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			OpenMenu.BackgroundTransparency = 1.000
			OpenMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
			OpenMenu.BorderSizePixel = 0
			OpenMenu.Position = UDim2.new(0.829999983, 0, 0.150999993, 0)
			OpenMenu.Size = UDim2.new(0, 18, 0, 18)
			OpenMenu.Font = Enum.Font.SourceSans
			OpenMenu.Text = "+"
			OpenMenu.TextColor3 = Color3.fromRGB(255, 255, 255)
			OpenMenu.TextScaled = true
			OpenMenu.TextSize = 14.000
			OpenMenu.TextWrapped = true
			OpenMenu.AutoButtonColor = false

			local ToggleStatus = Instance.new("Frame")
			ToggleStatus.Parent = ToggleButtonHolder
			ToggleStatus.BackgroundColor3 = Color3.fromRGB(175, 0, 0)
			ToggleStatus.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleStatus.BorderSizePixel = 0
			ToggleStatus.Position = UDim2.new(0.0508474559, 0, 0.254365265, 0)
			ToggleStatus.Size = UDim2.new(0, 10, 0, 10)

			local UICorner_2 = Instance.new("UICorner")
			UICorner_2.CornerRadius = UDim.new(0, 3)
			UICorner_2.Parent = ToggleStatus

			local ToggleName = Instance.new("TextLabel")
			ToggleName.Parent = ToggleButtonHolder
			ToggleName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleName.BackgroundTransparency = 1.000
			ToggleName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleName.BorderSizePixel = 0
			ToggleName.Position = UDim2.new(0.180000007, 0, 0.158999994, 0)
			ToggleName.Size = UDim2.new(0, 80, 0, 15)
			ToggleName.Font = Enum.Font.SourceSans
			ToggleName.Text = ToggleButton.Name
			ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
			ToggleName.TextSize = 13.000
			ToggleName.TextXAlignment = Enum.TextXAlignment.Left

			local ToggleMenuOld = UDim2.new(1, 0, 0, 0)
			local ToggleMenuNew = UDim2.new(1, 0, 0, 65)
			local ToggleMenu = Instance.new("Frame")
			ToggleMenu.Parent = TogglesList
			ToggleMenu.LayoutOrder = ToggleButtonHolder.LayoutOrder + 1
			ToggleMenu.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			ToggleMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleMenu.BorderSizePixel = 0
			ToggleMenu.LayoutOrder = 1
			ToggleMenu.Position = UDim2.new(0, 0, 0.497959971, 0)
			ToggleMenu.Size = UDim2.new(1, 0, 0, 0)
			ToggleMenu.Visible = false

			local KeyBinds = Instance.new("TextBox")
			KeyBinds.Parent = ToggleMenu
			KeyBinds.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			KeyBinds.BorderColor3 = Color3.fromRGB(0, 0, 0)
			KeyBinds.BorderSizePixel = 0
			KeyBinds.Position = UDim2.new(0, 0, 0.786514044, 0)
			KeyBinds.Size = UDim2.new(1, 0, -0.13670516, 23)
			KeyBinds.Font = Enum.Font.SourceSans
			KeyBinds.PlaceholderText = "None"
			KeyBinds.Text = ""
			KeyBinds.TextColor3 = Color3.fromRGB(255, 255, 255)
			KeyBinds.TextSize = 14.000
			UserInputService.InputBegan:Connect(function(Input, isTyping)
				if Input.UserInputType == Enum.UserInputType.Keyboard then
					if KeyBinds:IsFocused() then
						ToggleButton.Keybind = Input.KeyCode.Name
						KeyBinds.Text = Input.KeyCode.Name
						KeyBinds.PlaceholderText = Input.KeyCode.Name
						KeyBinds:ReleaseFocus() 
						Settings.ToggleButton[ToggleButton.Name].Keybind = ToggleButton.Keybind
					end       
				end
			end)

			local SettingsList = Instance.new("ScrollingFrame")
			SettingsList.Parent = ToggleMenu
			SettingsList.Active = true
			SettingsList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SettingsList.BackgroundTransparency = 1.000
			SettingsList.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SettingsList.BorderSizePixel = 0
			SettingsList.Size = UDim2.new(1, 0, 0, 50)
			SettingsList.ScrollBarThickness = 4
			SettingsList.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
			SettingsList.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
			SettingsList.Visible = false

			local UIListLayout_3 = Instance.new("UIListLayout")
			UIListLayout_3.Parent = SettingsList
			UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder

			local function ToggleButtonClicked()
				if ToggleButton.Enabled then
					ToggleStatus.BackgroundColor3 = Color3.fromRGB(0, 175, 0)
					AddArray(ToggleButton.Name)
					Settings.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
				else
					ToggleStatus.BackgroundColor3 = Color3.fromRGB(175, 0, 0)
					RemoveArray(ToggleButton.Name)
					Settings.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
				end
			end

			local function ToggleButtonOnHeld()
				local MobileButtons = Instance.new("TextButton")
				MobileButtons.Parent = OtherFrame
				MobileButtons.BackgroundColor3 = Color3.fromRGB(175, 0, 0)
				MobileButtons.BackgroundTransparency = 0.750
				MobileButtons.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MobileButtons.BorderSizePixel = 0
				MobileButtons.Position = UDim2.new(0.192740932, 0, 0.301066756, 0)
				MobileButtons.Size = UDim2.new(0, 35, 0, 35)
				MobileButtons.Font = Enum.Font.SourceSans
				MobileButtons.Text = ToggleButton.Name
				MobileButtons.Name = ToggleButton.Name
				MobileButtons.TextColor3 = Color3.fromRGB(0, 0, 0)
				MobileButtons.TextScaled = true
				MobileButtons.TextSize = 14.000
				MobileButtons.TextWrapped = true
				MobileButtons.TextScaled = true
				MakeDraggable(MobileButtons)

				local UICorner_6 = Instance.new("UICorner")
				UICorner_6.CornerRadius = UDim.new(1, 0)
				UICorner_6.Parent = MobileButtons

				local function MobileButtonsOnClicked()
					if ToggleButton.Enabled then
						MobileButtons.BackgroundColor3 = Color3.fromRGB(0, 175, 0)
						ToggleStatus.BackgroundColor3 = Color3.fromRGB(0, 175, 0)
						AddArray(ToggleButton.Name)
						Settings.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
					else
						ToggleStatus.BackgroundColor3 = Color3.fromRGB(175, 0, 0)
						MobileButtons.BackgroundColor3 = Color3.fromRGB(175, 0, 0)
						RemoveArray(ToggleButton.Name)
						Settings.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
					end
				end

				local function CheckPos()
					local CheckX = MobileButtons.AbsolutePosition.X >= TrashCans.AbsolutePosition.X and MobileButtons.AbsolutePosition.X + MobileButtons.AbsoluteSize.X <= TrashCans.AbsolutePosition.X + TrashCans.AbsoluteSize.X
					local CheckY = MobileButtons.AbsolutePosition.Y >= TrashCans.AbsolutePosition.Y and MobileButtons.AbsolutePosition.Y + MobileButtons.AbsoluteSize.Y <= TrashCans.AbsolutePosition.Y + TrashCans.AbsoluteSize.Y
					return CheckX and CheckY
				end

				MobileButtons.MouseButton1Click:Connect(function()
					ToggleButton.Enabled = not ToggleButton.Enabled
					MobileButtonsOnClicked()

					if ToggleButton.Callback then
						ToggleButton.Callback(ToggleButton.Enabled)
					end
				end)

				spawn(function()
					while true do
						wait()
						if TrashCans.Visible and CheckPos() then
							MobileButtons:Destroy()
						end
					end
				end)
			end

			ToggleButtonHolder.MouseButton1Click:Connect(function()
				ToggleButton.Enabled = not ToggleButton.Enabled
				ToggleButtonClicked()

				if ToggleButton.Callback then
					ToggleButton.Callback(ToggleButton.Enabled)
				end
			end)

			OpenMenu.MouseButton1Click:Connect(function()
				OpenToggleMenu = not OpenToggleMenu
				if OpenToggleMenu then
					OpenMenu.Text = "-"
					TweenService:Create(ToggleMenu, TweenInfo.new(0.2), {Visible = true, Size = ToggleMenuNew}):Play()
					SettingsList.Visible = true
				else
					OpenMenu.Text = "+"
					TweenService:Create(ToggleMenu, TweenInfo.new(0.2), {Visible = false, Size = ToggleMenuOld}):Play()
					SettingsList.Visible = false
				end
			end)

			local HoldTime = 3
			local Holding = false
			ToggleButtonHolder.MouseButton1Down:Connect(function()
				if Library.Settings.MobileSupport then
					Holding = true
					wait(HoldTime)
					if Holding then
						ToggleButtonOnHeld()
					end
				end
			end)

			ToggleButtonHolder.MouseButton2Click:Connect(function()
				OpenToggleMenu = not OpenToggleMenu
				if OpenToggleMenu then
					OpenMenu.Text = "-"
					TweenService:Create(ToggleMenu, TweenInfo.new(0.2), {Visible = true, Size = ToggleMenuNew}):Play()
					SettingsList.Visible = true
				else
					OpenMenu.Text = "+"
					TweenService:Create(ToggleMenu, TweenInfo.new(0.2), {Visible = false, Size = ToggleMenuOld}):Play()
					SettingsList.Visible = false
				end
			end)

			if ToggleButton.Keybind then
				UserInputService.InputBegan:Connect(function(Input, isTyping)
					if Input.KeyCode == Enum.KeyCode[ToggleButton.Keybind] and not isTyping then
						ToggleButton.Enabled = not ToggleButton.Enabled
						ToggleButtonClicked()

						if ToggleButton.Callback then
							ToggleButton.Callback(ToggleButton.Enabled)
						end
					end
				end)
			end

			if ToggleButton.Enabled then
				ToggleButton.Enabled = true
				ToggleButtonClicked()
			elseif not ToggleButton.Enabled then
				ToggleButton.Enabled = false
				ToggleButtonClicked()

				if ToggleButton.Callback then
					ToggleButton.Callback(ToggleButton.Enabled)
				end
			end

			spawn(function()
				repeat
					wait()
					if ToggleButton.AutoDisable and ToggleButton.Enabled then
						ToggleButton.Enabled = false
						ToggleButtonClicked()

						if ToggleButton.Callback then
							ToggleButton.Callback(ToggleButton.Enabled)
						end
					end
				until not ToggleButton.AutoDisable
			end)

			function ToggleButton:CreateMiniToggle(MiniToggle)
				MiniToggle = {
					Name = MiniToggle.Name,
					Enabled = MiniToggle.Enabled or false,
					Callback = MiniToggle.Callback or function() end
				}
				if not Settings.ToggleButton.MiniToggle[MiniToggle.Name] then
					Settings.ToggleButton.MiniToggle[MiniToggle.Name] = {
						Enabled = MiniToggle.Enabled
					}
				else
					MiniToggle.Enabled = Settings.ToggleButton.MiniToggle[MiniToggle.Name].Enabled
				end

				local MiniToggleHolder = Instance.new("TextButton")
				MiniToggleHolder.Parent = SettingsList
				MiniToggleHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleHolder.BackgroundTransparency = 1.000
				MiniToggleHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleHolder.BorderSizePixel = 0
				MiniToggleHolder.Size = UDim2.new(1, 0, 0, 23)
				MiniToggleHolder.AutoButtonColor = false
				MiniToggleHolder.Font = Enum.Font.SourceSans
				MiniToggleHolder.Text = ""
				MiniToggleHolder.TextColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleHolder.TextSize = 14.000

				local MiniToggleHolderName = Instance.new("TextLabel")
				MiniToggleHolderName.Parent = MiniToggleHolder
				MiniToggleHolderName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleHolderName.BackgroundTransparency = 1.000
				MiniToggleHolderName.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleHolderName.BorderSizePixel = 0
				MiniToggleHolderName.Position = UDim2.new(0.200000003, 0, 0.158999994, 0)
				MiniToggleHolderName.Size = UDim2.new(0, 80, 0, 15)
				MiniToggleHolderName.Font = Enum.Font.SourceSans
				MiniToggleHolderName.Text = MiniToggle.Name
				MiniToggleHolderName.TextColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleHolderName.TextSize = 13.000
				MiniToggleHolderName.TextXAlignment = Enum.TextXAlignment.Left

				local MiniToggleHolderStatus = Instance.new("Frame")
				MiniToggleHolderStatus.Parent = MiniToggleHolder
				MiniToggleHolderStatus.BackgroundColor3 = Color3.fromRGB(175, 0, 0)
				MiniToggleHolderStatus.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleHolderStatus.BorderSizePixel = 0
				MiniToggleHolderStatus.Position = UDim2.new(0.075000003, 0, 0.254000008, 0)
				MiniToggleHolderStatus.Size = UDim2.new(0, 10, 0, 10)

				local UICorner = Instance.new("UICorner")
				UICorner.CornerRadius = UDim.new(0, 3)
				UICorner.Parent = MiniToggleHolderStatus

				local function MiniToggleClick()
					if MiniToggle.Enabled then
						MiniToggleHolderStatus.BackgroundColor3 = Color3.fromRGB(0, 175, 0)
						Settings.ToggleButton.MiniToggle[MiniToggle.Name].Enabled = MiniToggle.Enabled
					else
						MiniToggleHolderStatus.BackgroundColor3 = Color3.fromRGB(175, 0, 0)
						Settings.ToggleButton.MiniToggle[MiniToggle.Name].Enabled = MiniToggle.Enabled
					end
				end

				MiniToggleHolder.MouseButton1Click:Connect(function()
					MiniToggle.Enabled = not MiniToggle.Enabled
					MiniToggleClick()

					if MiniToggle.Callback then
						MiniToggle.Callback(MiniToggle.Enabled)
					end
				end)

				if MiniToggle.Enabled then
					MiniToggle.Enabled = true
					MiniToggleClick()
				elseif not MiniToggle.Enabled then
					MiniToggle.Enabled = false
					MiniToggleClick()

					if MiniToggle.Callback then
						MiniToggle.Callback(MiniToggle.Enabled)
					end
				end
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
				if not Settings.ToggleButton.Sliders[Slider.Name] then
					Settings.ToggleButton.Sliders[Slider.Name] = {
						Default = Slider.Default
					}
				else
					Slider.Default = Settings.ToggleButton.Sliders[Slider.Name].Default
				end

				local Value
				local Dragged = false

				local SliderHolder = Instance.new("Frame")
				SliderHolder.Parent = SettingsList
				SliderHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderHolder.BackgroundTransparency = 1.000
				SliderHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolder.BorderSizePixel = 0
				SliderHolder.Size = UDim2.new(1, 0, 0, 25)

				local SliderHolderName = Instance.new("TextLabel")
				SliderHolderName.Parent = SliderHolder
				SliderHolderName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderHolderName.BackgroundTransparency = 1.000
				SliderHolderName.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderName.BorderSizePixel = 0
				SliderHolderName.Position = UDim2.new(0.100000001, 0, 0.180000007, 0)
				SliderHolderName.Size = UDim2.new(0, 80, 0, 8)
				SliderHolderName.Font = Enum.Font.SourceSans
				SliderHolderName.Text = Slider.Name
				SliderHolderName.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderHolderName.TextSize = 13.000
				SliderHolderName.TextXAlignment = Enum.TextXAlignment.Left

				local SliderHolderBack = Instance.new("Frame")
				SliderHolderBack.Parent = SliderHolder
				SliderHolderBack.BackgroundColor3 = Color3.fromRGB(105, 85, 85)
				SliderHolderBack.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderBack.BorderSizePixel = 0
				SliderHolderBack.Position = UDim2.new(0.0850000009, 0, 0.800000012, 0)
				SliderHolderBack.Size = UDim2.new(0, 100, 0, 2)

				local SliderHolderFront = Instance.new("Frame")
				SliderHolderFront.Parent = SliderHolderBack
				SliderHolderFront.BackgroundColor3 = Color3.fromRGB(89, 143, 77)
				SliderHolderFront.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderFront.BorderSizePixel = 0
				SliderHolderFront.Size = UDim2.new(0, 50, 0, 2)

				local SliderHolderTriggerer = Instance.new("TextButton")
				SliderHolderTriggerer.Parent = SliderHolderFront
				SliderHolderTriggerer.BackgroundColor3 = Color3.fromRGB(88, 117, 153)
				SliderHolderTriggerer.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderTriggerer.BorderSizePixel = 0
				SliderHolderTriggerer.Position = UDim2.new(1, 0, -0.899999976, 0)
				SliderHolderTriggerer.Size = UDim2.new(0, 5, 0, 5)
				SliderHolderTriggerer.Font = Enum.Font.SourceSans
				SliderHolderTriggerer.Text = ""
				SliderHolderTriggerer.TextColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderTriggerer.TextSize = 14.000

				local function SliderDragged(input)
					local InputPos = input.Position
					Value = math.clamp((InputPos.X - SliderHolderBack.AbsolutePosition.X) / SliderHolderBack.AbsoluteSize.X, 0, 1)
					local SliderValue = math.round(Value * (Slider.Max - Slider.Min)) + Slider.Min
					SliderHolderFront.Size = UDim2.fromScale(Value, 1)
					SliderHolderName.Text = Slider.Name .. ": " .. SliderValue
					Slider.Callback(SliderValue)
					Settings.ToggleButton.Sliders[Slider.Name].Default = SliderValue
				end

				SliderHolderTriggerer.MouseButton1Down:Connect(function()
					Dragged = true
				end)

				UserInputService.InputChanged:Connect(function(input)
					if Dragged and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						SliderDragged(input)
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						Dragged = false
					end
				end)

				if Slider.Default then
					Value = (Slider.Default - Slider.Min) / (Slider.Max - Slider.Min)
					SliderHolderFront.Size = UDim2.fromScale(Value, 1)
					SliderHolderName.Text = Slider.Name .. ": " .. Slider.Default
					Slider.Callback(Slider.Default)
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
				if not Settings.ToggleButton.Dropdown[Dropdown.Name] then
					Settings.ToggleButton.Dropdown[Dropdown.Name] = {
						Default = Dropdown.Default
					}
				else
					Dropdown.Default = Settings.ToggleButton.Dropdown[Dropdown.Name].Default
				end

				local Selected

				local DropdownHolder = Instance.new("TextButton")
				DropdownHolder.Name = "DropdownHolder"
				DropdownHolder.Parent = SettingsList
				DropdownHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownHolder.BackgroundTransparency = 1.000
				DropdownHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownHolder.BorderSizePixel = 0
				DropdownHolder.Size = UDim2.new(1, 0, 0, 23)
				DropdownHolder.Font = Enum.Font.SourceSans
				DropdownHolder.Text = ""
				DropdownHolder.TextColor3 = Color3.fromRGB(0, 0, 0)
				DropdownHolder.TextSize = 14.000

				local ModeText = Instance.new("TextLabel")
				ModeText.Parent = DropdownHolder
				ModeText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ModeText.BackgroundTransparency = 1.000
				ModeText.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ModeText.BorderSizePixel = 0
				ModeText.Position = UDim2.new(0.100000024, 0, 0.158999905, 0)
				ModeText.Size = UDim2.new(0, 30, 0, 15)
				ModeText.Font = Enum.Font.SourceSans
				ModeText.Text = "Mode:"
				ModeText.TextColor3 = Color3.fromRGB(255, 255, 255)
				ModeText.TextSize = 13.000
				ModeText.TextXAlignment = Enum.TextXAlignment.Left

				local SelectedText = Instance.new("TextLabel")
				SelectedText.Parent = DropdownHolder
				SelectedText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SelectedText.BackgroundTransparency = 1.000
				SelectedText.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SelectedText.BorderSizePixel = 0
				SelectedText.Position = UDim2.new(0.349999994, 0, 0.158999994, 0)
				SelectedText.Size = UDim2.new(0, 68, 0, 15)
				SelectedText.Font = Enum.Font.SourceSans
				SelectedText.Text = Dropdown.Default or "None"
				SelectedText.TextColor3 = Color3.fromRGB(255, 255, 255)
				SelectedText.TextSize = 13.000
				SelectedText.TextXAlignment = Enum.TextXAlignment.Left

				local CurrentDropdown = 1
				DropdownHolder.MouseButton1Click:Connect(function()
					SelectedText.Text = Dropdown.List[CurrentDropdown]
					Selected = Dropdown.List[CurrentDropdown]
					Dropdown.Callback(Dropdown.List[CurrentDropdown])
					CurrentDropdown = CurrentDropdown % #Dropdown.List + 1
					Settings.ToggleButton.Dropdown[Dropdown.Name].Default = Selected
				end)

				if Dropdown.Default then
					Dropdown.Callback(Dropdown.Default)
					SelectedText.Text = Dropdown.Default
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
