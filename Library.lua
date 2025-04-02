local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local MainFolder, ConfigFolder = "Lime", "Lime/configs"
local ConfigSetting = {ToggleButton = {MiniToggle = {}, Sliders = {}, Dropdown = {}}}
local MainFile = nil
local Library = {}
if not shared.Lime then
	shared.Lime = {
		Uninjected = false,
		Visual = {
			Hud = true,
			Arraylist = true,
			Watermark = true
		}
	}
end

if isfolder(MainFolder) and isfolder(ConfigFolder) then
	MainFile = ConfigFolder .. "/" .. game.PlaceId .. ".lua"
	if isfile(MainFile) then
		local GetMain = readfile(MainFile)
		if GetMain then
			local OldSettings = HttpService:JSONDecode(GetMain)
			if OldSettings then
				ConfigSetting = OldSettings
			end
		end
	end
	
	local AutoSave = true
	spawn(function()
		RunService.RenderStepped:Connect(function()
			if AutoSave then
				if shared.Lime.Uninjected then
					AutoSave = false
				end
				writefile(MainFile, HttpService:JSONEncode(ConfigSetting))
			end
		end)
	end)
end

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

function Spoof(length)
	local Letter = {}
	for i = 1, length do
		local RandomLetter = string.char(math.random(97, 122))
		table.insert(Letter, RandomLetter)
	end
	return table.concat(Letter)
end

function Library:CreateMain()
	local Main = {}

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Name = Spoof(math.random(8, 12))
	if RunService:IsStudio() then
		ScreenGui.Parent = PlayerGui
	elseif game.PlaceId == 11630038968 or game.PlaceId == 10810646982 then
		ScreenGui.Parent = PlayerGui:FindFirstChild("MainGui")
	else
		ScreenGui.Parent = CoreGui
	end

	spawn(function()
		RunService.RenderStepped:Connect(function()
			if ScreenGui then
				if shared.Lime.Uninjected then
					task.wait(1.2)
					ScreenGui:Destroy()
					shared.Lime.Uninjected = false
				end
			end
		end)
	end)

	local MainFrame = nil
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
		if MainFrame == nil then
			MainFrame = Instance.new("ScrollingFrame")
			MainFrame.Parent = ScreenGui
			MainFrame.Active = true
			MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			MainFrame.BackgroundTransparency = 1.000
			MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			MainFrame.BorderSizePixel = 0
			MainFrame.Size = UDim2.new(1, 0, 1, 0)
			MainFrame.CanvasPosition = Vector2.new(240, 0)
			MainFrame.CanvasSize = UDim2.new(1.60000002, 0, 0, 0)
			MainFrame.ScrollBarThickness = 8
			MainFrame.Visible = false
		end
	elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
		if MainFrame == nil then
			MainFrame = Instance.new("Frame")
			MainFrame.Parent = ScreenGui
			MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			MainFrame.BackgroundTransparency = 1.000
			MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			MainFrame.Size = UDim2.new(1, 0, 1, 0)
			MainFrame.Visible = false
		end
	end

	spawn(function()
		local OldX = 0
		if MainFrame ~= nil and MainFrame.Parent then
			for _, child in ipairs(MainFrame:GetChildren()) do
				if child:IsA("GuiObject") then
					child.Position = UDim2.new(0, OldX, 0, 0)
					OldX = OldX + child.Size.X.Offset + 18
				end
			end
		end
	end)

	local KeybindFrame = Instance.new("Frame")
	KeybindFrame.Parent = ScreenGui
	KeybindFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	KeybindFrame.BackgroundTransparency = 1.000
	KeybindFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	KeybindFrame.Size = UDim2.new(1, 0, 1, 0)
	KeybindFrame.Visible = true

	local UIPadding = Instance.new("UIPadding")
	UIPadding.Parent = MainFrame
	UIPadding.PaddingLeft = UDim.new(0, 20)
	UIPadding.PaddingTop = UDim.new(0, 22)

	local HudFrame = Instance.new("Frame")
	HudFrame.Parent = ScreenGui
	HudFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HudFrame.BackgroundTransparency = 1.000
	HudFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HudFrame.BorderSizePixel = 0
	HudFrame.Size = UDim2.new(1, 0, 1, 0)
	Library.HudMainFrame = HudFrame

	spawn(function()
		RunService.RenderStepped:Connect(function()	
			if HudFrame then
				if shared.Lime.Visual.Hud then
					HudFrame.Visible = true
				else
					HudFrame.Visible = false
				end
			end
		end)
	end)

	local LibraryTitle = Instance.new("TextLabel")
	LibraryTitle.Parent = HudFrame
	LibraryTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LibraryTitle.BackgroundTransparency = 1.000
	LibraryTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LibraryTitle.BorderSizePixel = 0
	LibraryTitle.Position = UDim2.new(0, 20, 0, 18)
	LibraryTitle.Size = UDim2.new(0, 345, 0, 30)
	LibraryTitle.Text = "Lime"
	LibraryTitle.Font = Enum.Font.SourceSans
	LibraryTitle.TextColor3 = Color3.fromRGB(255, 0, 127)
	LibraryTitle.TextScaled = true
	LibraryTitle.TextSize = 14.000
	LibraryTitle.TextWrapped = true
	LibraryTitle.TextXAlignment = Enum.TextXAlignment.Left
	LibraryTitle.ZIndex = -1

	local TitleGradient = Instance.new("UIGradient")
	TitleGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(138, 230, 255))}
	TitleGradient.Parent = LibraryTitle
	
	spawn(function()
		RunService.RenderStepped:Connect(function()	
			if HudFrame and LibraryTitle then
				if shared.Lime.Visual.Watermark then
					LibraryTitle.Visible = true
				else
					LibraryTitle.Visible = false
				end
			end
		end)
	end)

	local ArrayTable = {}
	local ArrayFrame = Instance.new("Frame")
	ArrayFrame.Parent = HudFrame
	ArrayFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ArrayFrame.BackgroundTransparency = 1.000
	ArrayFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ArrayFrame.BorderSizePixel = 0
	ArrayFrame.Position = UDim2.new(0.819999993, 0, 0.0399999991, 0)
	ArrayFrame.Size = UDim2.new(0.162, 0, 0.930000007, 0)

	local UIListLayout_4 = Instance.new("UIListLayout")
	UIListLayout_4.Parent = ArrayFrame
	UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_4.HorizontalAlignment = Enum.HorizontalAlignment.Right
	
	spawn(function()
		RunService.RenderStepped:Connect(function()	
			if HudFrame and ArrayFrame then
				if shared.Lime.Visual.Arraylist then
					ArrayFrame.Visible = true
				else
					ArrayFrame.Visible = false
				end
			end
		end)
	end)
	
	local function AddArray(name)
		local TextLabel = Instance.new("TextLabel")
		TextLabel.Parent = ArrayFrame
		TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.TextTransparency = 1
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Font = Enum.Font.SourceSans
		TextLabel.Text = name
		TextLabel.TextColor3 = Color3.fromRGB(255, 0, 127)
		TextLabel.TextScaled = true
		TextLabel.TextSize = 18.000
		TextLabel.TextWrapped = true
		TextLabel.ZIndex = -1
		TextLabel.TextXAlignment = Enum.TextXAlignment.Right
		TweenService:Create(TextLabel, TweenInfo.new(1.8), {TextTransparency = 0, BackgroundTransparency = 0.750}):Play()

		local TextGradient = Instance.new("UIGradient")
		TextGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(138, 230, 255))}
		TextGradient.Parent = TextLabel

		local NewWidth = game.TextService:GetTextSize(name, 18, Enum.Font.SourceSans, Vector2.new(0, 0)).X
		local NewSize = UDim2.new(0.01, game.TextService:GetTextSize(name , 18, Enum.Font.SourceSans, Vector2.new(0,0)).X, 0,20)
		if name == "" then
			NewSize = UDim2.fromScale(0,0)
		end

		TextLabel.Position = UDim2.new(1, -NewWidth, 0, 0)
		TextLabel.Size = NewSize
		table.insert(ArrayTable,TextLabel)
		table.sort(ArrayTable,function(a,b) return game.TextService:GetTextSize(a.Text .. "  ", 18, Enum.Font.SourceSans, Vector2.new(0,20)).X > game.TextService:GetTextSize(b.Text .. "  ", 18, Enum.Font.SourceSans,Vector2.new(0,20)).X end)
		for i,v in ipairs(ArrayTable) do
			v.LayoutOrder = i
		end
	end

	local function RemoveArray(name)
		table.sort(ArrayTable,function(a,b) return game.TextService:GetTextSize(a.Text.."  ",18,Enum.Font.SourceSans,Vector2.new(0,20)).X > game.TextService:GetTextSize(b.Text.."  ",18,Enum.Font.SourceSans,Vector2.new(0,20)).X end)
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

	local MainOpen = nil
	local UICorner_2 = nil
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
		if MainFrame:IsA("ScrollingFrame") and MainFrame.Parent then
			MainOpen = Instance.new("TextButton")
			MainOpen.Parent = ScreenGui
			MainOpen.AnchorPoint = Vector2.new(0.5, 0.5)
			MainOpen.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			MainOpen.BackgroundTransparency = 0.550
			MainOpen.BorderColor3 = Color3.fromRGB(0, 0, 0)
			MainOpen.BorderSizePixel = 0
			--MainOpen.Position = UDim2.new(0.02, 0, 0.95, 0)
			MainOpen.Position = UDim2.new(0.5, 0, 0.0380000018, 0)
			MainOpen.Size = UDim2.new(0, 25, 0, 25)
			MainOpen.ZIndex = 5
			MainOpen.Font = Enum.Font.SourceSans
			MainOpen.Text = "Lime"
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
	end

	UserInputService.InputBegan:Connect(function(Input, isTyping)
		if Input.KeyCode == Enum.KeyCode.RightShift and not isTyping then
			MainFrame.Visible = not MainFrame.Visible
		end
	end)

	local Frame = Instance.new("Frame")
	Frame.Parent = HudFrame
	Frame.AnchorPoint = Vector2.new(0, 0.5)
	Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Frame.BackgroundTransparency = 0.15
	Frame.BorderSizePixel = 0
	Frame.Size = UDim2.new(0, 231, 0, 50)
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.Visible = false
	MakeDraggable(Frame)

	local ImageLabel_2 = Instance.new("ImageLabel")
	ImageLabel_2.Parent = Frame
	ImageLabel_2.AnchorPoint = Vector2.new(0, 0.5)
	ImageLabel_2.BackgroundTransparency = 1
	ImageLabel_2.Position = UDim2.new(0, 5, 0.5, 0)
	ImageLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ImageLabel_2.Size = UDim2.new(0, 40, 0, 40)

	local Frame_2 = Instance.new("Frame")
	Frame_2.Parent = Frame
	Frame_2.AnchorPoint = Vector2.new(0, 0.5)
	Frame_2.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Frame_2.BackgroundTransparency = 0.35
	Frame_2.Position = UDim2.new(0, 50, 0.75, 0)
	Frame_2.Size = UDim2.new(0, 100, 0, 8)
	Frame_2.BorderSizePixel = 0

	local TextLabel_2 = Instance.new("TextLabel")
	TextLabel_2.Parent = Frame
	TextLabel_2.BackgroundTransparency = 1
	TextLabel_2.Font = Enum.Font.SourceSansBold
	TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel_2.TextSize = 18
	TextLabel_2.TextWrapped = true
	TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

	local Frame_3 = Instance.new("Frame")
	Frame_3.Parent = Frame_2
	Frame_3.AnchorPoint = Vector2.new(0, 0.5)
	Frame_3.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
	Frame_3.Position = UDim2.new(0, 0, 0.5, 0)
	Frame_3.Size = UDim2.new(0, 50, 0, 8)
	Frame_3.BorderSizePixel = 0

	local Frame3Gradient = Instance.new("UIGradient")
	Frame3Gradient.Parent = Frame_3
	Frame3Gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(138, 230, 255))}

	function Main:CreateTargetHUD(name, thumbnail, humanoid, ishere)
		local TargetHUD = {}

		if ishere then
			Frame.Visible = true
			if name and humanoid then
				ImageLabel_2.Image = thumbnail
				TextLabel_2.Text = name

				local Calculation = humanoid.Health / humanoid.MaxHealth
				local NewTextSize = game:GetService("TextService"):GetTextSize(TextLabel_2.Text, TextLabel_2.TextSize, TextLabel_2.Font, Vector2.new(9999, 50))
				local Width = NewTextSize.X + ImageLabel_2.Size.X.Offset + 20
				local NewSize_2 = UDim2.new(0, Width, 0, 50)

				Frame.Size = NewSize_2
				Frame_2.Size = UDim2.new(0, NewTextSize.X, 0, 8)
				TextLabel_2.Size = UDim2.new(0, NewTextSize.X, 0, NewTextSize.Y)
				TextLabel_2.Position = UDim2.new(0, Frame_2.Position.X.Offset, 0.12, 0)

				if humanoid.Health > 0 then
					TweenService:Create(Frame_3, TweenInfo.new(0.5), {Size = UDim2.new(Calculation, 0, 0, 8)}):Play()
				elseif humanoid.Health < 0 then
					TweenService:Create(Frame_3, TweenInfo.new(0.5), {Size = UDim2.new(-0, 0, 0, 8)}):Play()
				else
					TweenService:Create(Frame_3, TweenInfo.new(0.5), {Size = UDim2.new(-0, 0, 0, 8)}):Play()
				end
			end
		else
			Frame.Visible = false
		end

		return TargetHUD
	end

	function Main:CreateLine(Origin, Destination)
		local Position = (Origin + Destination) / 2

		local Line = Instance.new("Frame")
		Line.Name = "Line"
		Line.AnchorPoint = Vector2.new(0.5, 0.5)
		Line.Parent = HudFrame
		Line.Position = UDim2.new(0, Position.X, 0, Position.Y)
		Line.Size = UDim2.new(0, (Origin - Destination).Magnitude, 0, 0.02)
		Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Line.BorderColor3 = Color3.fromRGB(255, 255, 255)
		Line.Rotation = math.deg(math.atan2(Destination.Y - Origin.Y, Destination.X - Origin.X))

		return Line
	end

	function Main:CreateTab(name, icon, iconcolor)
		local Tabs = {}

		local TabHolder = Instance.new("Frame")
		TabHolder.ZIndex = 2
		TabHolder.Parent = MainFrame
		TabHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		TabHolder.BackgroundTransparency = 0.030
		TabHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabHolder.BorderSizePixel = 0
		TabHolder.Size = UDim2.new(0, 185, 0, 25)
		if not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
			MakeDraggable(TabHolder)
		end

		local TabName = Instance.new("TextLabel")
		TabName.ZIndex = 2
		TabName.Parent = TabHolder
		TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabName.BackgroundTransparency = 1.000
		TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabName.BorderSizePixel = 0
		TabName.Position = UDim2.new(0, 5, 0, 0)
		TabName.Size = UDim2.new(0, 145, 1, 0)
		TabName.Font = Enum.Font.Nunito
		TabName.Text = name
		TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabName.TextSize = 18.000
		TabName.TextWrapped = true
		TabName.TextXAlignment = Enum.TextXAlignment.Left

		local ImageLabel = Instance.new("ImageLabel")
		ImageLabel.ZIndex = 2
		ImageLabel.Parent = TabHolder
		ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BackgroundTransparency = 1.000
		ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Position = UDim2.new(0, 172, 0.5, 0)
		ImageLabel.Size = UDim2.new(0, 18, 0, 18)
		ImageLabel.Image = "http://www.roblox.com/asset/?id=" .. icon
		ImageLabel.ImageColor3 = iconcolor

		local TogglesList = Instance.new("Frame")
		TogglesList.ZIndex = 2
		TogglesList.Parent = TabHolder
		TogglesList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TogglesList.BackgroundTransparency = 1.000
		TogglesList.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TogglesList.BorderSizePixel = 0
		TogglesList.Position = UDim2.new(0, 0, 1, 0)
		TogglesList.Size = UDim2.new(1, 0, 0, 0)

		local UIListLayout = Instance.new("UIListLayout")
		UIListLayout.Parent = TogglesList
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

		function Tabs:CreateToggle(ToggleButton)
			ToggleButton = {
				Name = ToggleButton.Name,
				Keybind = ToggleButton.Keybind or "Home",
				Enabled = ToggleButton.Enabled or false,
				AutoEnable = ToggleButton.AutoEnable or false,
				AutoDisable = ToggleButton.AutoDisable or false,
				Hide = ToggleButton.Hide or false,
				Callback = ToggleButton.Callback or function() end
			}
			if not ConfigSetting.ToggleButton[ToggleButton.Name] then
				ConfigSetting.ToggleButton[ToggleButton.Name] = {
					Enabled = ToggleButton.Enabled,
					Keybind = ToggleButton.Keybind,
				}
			else
				ToggleButton.Enabled = ConfigSetting.ToggleButton[ToggleButton.Name].Enabled
				ToggleButton.Keybind = ConfigSetting.ToggleButton[ToggleButton.Name].Keybind
			end

			local ToggleButtonHolder = Instance.new("TextButton")
			ToggleButtonHolder.Parent = TogglesList
			ToggleButtonHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			ToggleButtonHolder.BackgroundTransparency = 0.230
			ToggleButtonHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleButtonHolder.BorderSizePixel = 0
			ToggleButtonHolder.Size = UDim2.new(1, 0, 0, 25)
			ToggleButtonHolder.AutoButtonColor = false
			ToggleButtonHolder.Font = Enum.Font.SourceSans
			ToggleButtonHolder.Text = ""
			ToggleButtonHolder.ZIndex = 2
			ToggleButtonHolder.TextColor3 = Color3.fromRGB(0, 0, 0)
			ToggleButtonHolder.TextSize = 14.000

			local ToggleName = Instance.new("TextLabel")
			ToggleName.Parent = ToggleButtonHolder
			ToggleName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleName.BackgroundTransparency = 1.000
			ToggleName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleName.BorderSizePixel = 0
			ToggleName.Position = UDim2.new(0, 5, 0, 0)
			ToggleName.Size = UDim2.new(0, 145, 1, 0)
			ToggleName.Font = Enum.Font.SourceSans
			ToggleName.Text = ToggleButton.Name
			ToggleName.ZIndex = 2
			ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
			ToggleName.TextSize = 16.000
			ToggleName.TextWrapped = true
			ToggleName.TextXAlignment = Enum.TextXAlignment.Left

			local OpenMenu = Instance.new("TextButton")
			OpenMenu.Parent = ToggleButtonHolder
			OpenMenu.AnchorPoint = Vector2.new(0.5, 0.5)
			OpenMenu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			OpenMenu.BackgroundTransparency = 1.000
			OpenMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
			OpenMenu.BorderSizePixel = 0
			OpenMenu.Position = UDim2.new(0, 173, 0.5, 0)
			OpenMenu.Size = UDim2.new(0, 20, 0, 20)
			OpenMenu.Font = Enum.Font.SourceSans
			OpenMenu.ZIndex = 2
			OpenMenu.Text = ">"
			OpenMenu.TextColor3 = Color3.fromRGB(255, 255, 255)
			OpenMenu.TextScaled = true
			OpenMenu.TextSize = 14.000
			OpenMenu.TextWrapped = true

			local UIGradient = Instance.new("UIGradient")
			UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(138, 230, 255))}
			UIGradient.Parent = ToggleButtonHolder
			UIGradient.Enabled = false

			local ToggleMenuOpened = false
			local ToggleMenuOld = UDim2.new(1, 0, 0, 0)
			local ToggleMenuNew = UDim2.new(1, 0, 0, 125)
			local ToggleMenu, ScrollingMenu = nil, nil
			if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
				if ToggleMenu == nil then
					ToggleMenu = Instance.new("Frame")
					ToggleMenu.Parent = TogglesList
					ToggleMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
					ToggleMenu.BackgroundTransparency = 1
					ToggleMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
					ToggleMenu.BorderSizePixel = 0
					ToggleMenu.Position = UDim2.new(0, 0, 25, 0)
					ToggleMenu.Size = UDim2.new(1, 0, 0, 125)
					ToggleMenu.Visible = false

					ScrollingMenu = Instance.new("ScrollingFrame")
					ScrollingMenu.Parent = ToggleMenu
					ScrollingMenu.Active = true
					ScrollingMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
					ScrollingMenu.BackgroundTransparency = 0.150
					ScrollingMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
					ScrollingMenu.BorderSizePixel = 0
					ScrollingMenu.Size = UDim2.new(1, 0, 0, 125)
					ScrollingMenu.ScrollBarThickness = 0
				end
			elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
				if ToggleMenu == nil then
					ToggleMenu = Instance.new("Frame")
					ToggleMenu.Parent = TogglesList
					ToggleMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
					ToggleMenu.BackgroundTransparency = 0.150
					ToggleMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
					ToggleMenu.BorderSizePixel = 0
					ToggleMenu.Position = UDim2.new(0, 0, 25, 0)
					ToggleMenu.Size = UDim2.new(1, 0, 0, 125)
					ToggleMenu.Visible = false
					ScrollingMenu = nil
				end
			end

			--Here
			local Keybinds = nil
			if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
				if Keybinds == nil then
					local MobileKeybinds, IsKeybind = nil, false
					Keybinds = Instance.new("TextButton")
					Keybinds.Parent = ScrollingMenu
					Keybinds.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
					Keybinds.BackgroundTransparency = 1.000
					Keybinds.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Keybinds.BorderSizePixel = 0
					Keybinds.LayoutOrder = -1
					Keybinds.Size = UDim2.new(1, 0, 0, 25)
					Keybinds.Font = Enum.Font.SourceSans
					Keybinds.Text = "Show"
					Keybinds.TextColor3 = Color3.fromRGB(255, 255, 255)
					Keybinds.TextSize = 14.000
					Keybinds.MouseButton1Click:Connect(function()
						IsKeybind = not IsKeybind
						if IsKeybind then
							Keybinds.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
							local MobileKeybinds = Instance.new("TextButton")
							MobileKeybinds.Parent = KeybindFrame

							spawn(function()
								while true do
									task.wait()
									if ToggleButton.Enabled then
										MobileKeybinds.BackgroundColor3 = Color3.fromRGB(0, 175, 0)
									else
										MobileKeybinds.BackgroundColor3 = Color3.fromRGB(175, 0, 0)
									end
								end
							end)

							local MobileKeybindText = string.len(ToggleButton.Name)
							local MobileKeybindY = game:GetService("TextService"):GetTextSize(ToggleButton.Name, 14, Enum.Font.SourceSans, Vector2.new(200, math.huge))
							MobileKeybinds.BackgroundTransparency = 0.750
							MobileKeybinds.BorderColor3 = Color3.fromRGB(0, 0, 0)
							MobileKeybinds.BorderSizePixel = 0
							MobileKeybinds.Position = UDim2.new(0.192740932, 0, 0.301066756, 0)
							MobileKeybinds.Size = UDim2.new(0, 65, 0, MobileKeybindY.Y + 15)
							MobileKeybinds.Font = Enum.Font.SourceSans
							MobileKeybinds.Text = ToggleButton.Name
							MobileKeybinds.Name = ToggleButton.Name
							MobileKeybinds.TextColor3 = Color3.fromRGB(0, 0, 0)
							MobileKeybinds.TextScaled = true
							MobileKeybinds.TextSize = 14.000
							MobileKeybinds.TextWrapped = true
							MobileKeybinds.TextScaled = true
							MakeDraggable(MobileKeybinds)

							local UICorner_3 = Instance.new("UICorner")
							UICorner_3.CornerRadius = UDim.new(0, 4)
							UICorner_3.Parent = MobileKeybinds

							local function MobileButtonsOnClicked()
								if ToggleButton.Enabled then
									TweenService:Create(ToggleButtonHolder, TweenInfo.new(0.4), {Transparency = 0,BackgroundColor3 = Color3.fromRGB(255, 0, 127)}):Play()
									TweenService:Create(UIGradient, TweenInfo.new(0.4), {Enabled = true}):Play()
									if not ToggleButton.Hide then
										AddArray(ToggleButton.Name)
									end
								else
									TweenService:Create(ToggleButtonHolder, TweenInfo.new(0.4), {Transparency = 0.230,BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
									TweenService:Create(UIGradient, TweenInfo.new(0.4), {Enabled = false}):Play()
									RemoveArray(ToggleButton.Name)
								end
							end

							MobileKeybinds.MouseButton1Click:Connect(function()
								ToggleButton.Enabled = not ToggleButton.Enabled
								MobileButtonsOnClicked()

								if ToggleButton.Callback then
									ToggleButton.Callback(ToggleButton.Enabled)
								end
							end)
								spawn(function()
									RunService.RenderStepped:Connect(function()
										if KeybindFrame then
											if shared.Lime.Uninjected then
												for i, v in pairs(KeybindFrame:GetChildren()) do
													if v:IsA("TextButton") and v.Name == ToggleButton.Name then
														v:Destroy()
													end
												end
												Keybinds.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
											end
										end
									end)
								end)
						else
							for i,v in pairs(KeybindFrame:GetChildren()) do
								if v:IsA("TextButton") and v.Name == ToggleButton.Name then
									v:Destroy()
								end
							end
							Keybinds.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
						end
					end)
				end
			elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
				if Keybinds == nil then
					Keybinds = Instance.new("TextBox")
					Keybinds.Parent = ToggleMenu
					Keybinds.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
					Keybinds.BackgroundTransparency = 1.000
					Keybinds.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Keybinds.BorderSizePixel = 0
					Keybinds.LayoutOrder = -1
					Keybinds.Size = UDim2.new(1, 0, 0, 25)
					Keybinds.Font = Enum.Font.SourceSans
					Keybinds.PlaceholderColor3 = Color3.fromRGB(220, 220, 220)
					Keybinds.PlaceholderText = "None"
					Keybinds.Text = ""
					Keybinds.TextColor3 = Color3.fromRGB(255, 255, 255)
					Keybinds.TextSize = 14.000
					UserInputService.InputBegan:Connect(function(Input, isTyping)
						if Input.UserInputType == Enum.UserInputType.Keyboard then
							if Keybinds:IsFocused() then
								ToggleButton.Keybind = Input.KeyCode.Name
								Keybinds.PlaceholderText = ""
								Keybinds.Text = Input.KeyCode.Name
								Keybinds:ReleaseFocus()
								ConfigSetting.ToggleButton[ToggleButton.Name].Keybind = ToggleButton.Keybind
							elseif ToggleButton.Keybind == "Backspace" then
								ToggleButton.Keybind = "Home"
								Keybinds.Text = ""
								Keybinds.PlaceholderText = "None"
								ConfigSetting.ToggleButton[ToggleButton.Name].Keybind = ToggleButton.Keybind
							end       
						end
						spawn(function()
							RunService.RenderStepped:Connect(function()
								if ToggleButton.Keybind ~= "Home" then
									if Keybinds then
										Keybinds.PlaceholderText = ""
										Keybinds.Text = ToggleButton.Keybind
									end
								end
								if shared.Lime.Uninjected then
									if Keybinds then
										Keybinds.Text = ""
										Keybinds.PlaceholderText = "None"
									end
								end
							end)
						end)
					end)
				end
			end

			local UIListLayout_2 = Instance.new("UIListLayout")
			UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

			if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
				if ToggleMenu ~= nil then
					UIListLayout_2.Parent = ScrollingMenu
				end
			elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
				if ToggleMenu ~= nil then
					UIListLayout_2.Parent = ToggleMenu
				end
			end

			local function ToggleButtonClicked()
				if ToggleButton.Enabled then
					ConfigSetting.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
					TweenService:Create(ToggleButtonHolder, TweenInfo.new(0.4), {Transparency = 0,BackgroundColor3 = Color3.fromRGB(255, 0, 127)}):Play()
					TweenService:Create(UIGradient, TweenInfo.new(0.4), {Enabled = true}):Play()
					AddArray(ToggleButton.Name)
					--[[
					ToggleButtonHolder.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
					ToggleButtonHolder.Transparency = 0
					UIGradient.Enabled = true
					--]]
				else
					ConfigSetting.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
					TweenService:Create(ToggleButtonHolder, TweenInfo.new(0.4), {Transparency = 0.230,BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
					TweenService:Create(UIGradient, TweenInfo.new(0.4), {Enabled = false}):Play()
					RemoveArray(ToggleButton.Name)
					--[[
					ToggleButtonHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
					ToggleButtonHolder.Transparency = 0.230
					UIGradient.Enabled = false
					--]]
				end
			end

			--[[
			spawn(function()
				while true do
					wait()
					if ToggleButton.AutoDisable then
						if ToggleButton.AutoDisable and ToggleButton.Enabled then
							ToggleButton.Enabled = false
							ToggleButtonClicked()

							if ToggleButton.Callback then
								ToggleButton.Callback(ToggleButton.Enabled)
							end
						end
					end
					if ToggleButton.AutoEnable then
						if ToggleButton.AutoEnable and not ToggleButton.Enabled then
							ToggleButton.Enabled = true
							ToggleButtonClicked()

							if ToggleButton.Callback then
								ToggleButton.Callback(ToggleButton.Enabled)
							end
						end
					end
				end
			end)
			--]]

			spawn(function()
				RunService.RenderStepped:Connect(function()
					if ToggleButton.AutoDisable then
						if ToggleButton.Enabled then
							ToggleButton.Enabled = false
							ToggleButtonClicked()

							if ToggleButton.Callback then
								ToggleButton.Callback(ToggleButton.Enabled)
							end
						end
					end
					if ToggleButton.AutoEnable then
						if not ToggleButton.Enabled then
							ToggleButton.Enabled = true
							ToggleButtonClicked()
								
							if ToggleButton.Callback then
								ToggleButton.Callback(ToggleButton.Enabled)
							end
						end
					end
					if shared.Lime.Uninjected then
						if ToggleButton.Enabled then
							ToggleButton.Enabled = false
							ToggleButtonClicked()

							if ToggleButton.Callback then
								ToggleButton.Callback(ToggleButton.Enabled)
							end
						end
					end
				end)
			end)

			if ToggleButton.Enabled then
				ToggleButton.Enabled = true
				ToggleButtonClicked()

				if ToggleButton.Callback then
					ToggleButton.Callback(ToggleButton.Enabled)
				end
			end

			ToggleButtonHolder.MouseButton1Click:Connect(function()
				ToggleButton.Enabled = not ToggleButton.Enabled
				ToggleButtonClicked()

				if ToggleButton.Callback then
					ToggleButton.Callback(ToggleButton.Enabled)
				end
			end)

			ToggleButtonHolder.MouseButton2Click:Connect(function()
				ToggleMenuOpened = not ToggleMenuOpened
				if ToggleMenuOpened then
					ToggleMenu.AutomaticSize = Enum.AutomaticSize.Y
					TweenService:Create(OpenMenu, TweenInfo.new(0.4), {Rotation = 90}):Play()
					TweenService:Create(ToggleMenu, TweenInfo.new(0.6), {Size = ToggleMenuNew}):Play()
					ToggleMenu.Visible = true
				else
					ToggleMenu.AutomaticSize = Enum.AutomaticSize.None
					ToggleMenu.Visible = false
					TweenService:Create(OpenMenu, TweenInfo.new(0.4), {Rotation = 0}):Play()
					TweenService:Create(ToggleMenu, TweenInfo.new(0.6), {Size = ToggleMenuOld}):Play()
				end
			end)

			OpenMenu.MouseButton1Click:Connect(function()
				ToggleMenuOpened = not ToggleMenuOpened
				if ToggleMenuOpened then
					ToggleMenu.AutomaticSize = Enum.AutomaticSize.Y
					TweenService:Create(OpenMenu, TweenInfo.new(0.4), {Rotation = 90}):Play()
					TweenService:Create(ToggleMenu, TweenInfo.new(0.6), {Size = ToggleMenuNew}):Play()
					ToggleMenu.Visible = true
				else
					ToggleMenu.AutomaticSize = Enum.AutomaticSize.None
					ToggleMenu.Visible = false
					TweenService:Create(OpenMenu, TweenInfo.new(0.4), {Rotation = 0}):Play()
					TweenService:Create(ToggleMenu, TweenInfo.new(0.6), {Size = ToggleMenuOld}):Play()
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

			function ToggleButton:CreateMiniToggle(MiniToggle)
				MiniToggle = {
					Name = MiniToggle.Name,
					Enabled = MiniToggle.Enabled or false,
					--AutoDisable = MiniToggle.AutoDisable or false,
					Callback = MiniToggle.Callback or function() end
				}
				if not ConfigSetting.ToggleButton.MiniToggle[MiniToggle.Name] then
					ConfigSetting.ToggleButton.MiniToggle[MiniToggle.Name] = {
						Enabled = MiniToggle.Enabled,
					}
				else
					MiniToggle.Enabled = ConfigSetting.ToggleButton.MiniToggle[MiniToggle.Name].Enabled
				end

				local MiniToggleHolder = Instance.new("Frame")
				MiniToggleHolder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				MiniToggleHolder.BackgroundTransparency = 1.000
				MiniToggleHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleHolder.BorderSizePixel = 0
				MiniToggleHolder.Size = UDim2.new(1, 0, 0, 25)
				if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
					if ToggleMenu ~= nil then
						MiniToggleHolder.Parent = ScrollingMenu
					end
				elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
					if ToggleMenu ~= nil then
						MiniToggleHolder.Parent = ToggleMenu
					end
				end

				local MiniToggleHolderName = Instance.new("TextLabel")
				MiniToggleHolderName.Parent = MiniToggleHolder
				MiniToggleHolderName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleHolderName.BackgroundTransparency = 1.000
				MiniToggleHolderName.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleHolderName.BorderSizePixel = 0
				MiniToggleHolderName.Position = UDim2.new(0, 5, 0, 0)
				MiniToggleHolderName.Size = UDim2.new(0, 175, 1, 0)
				MiniToggleHolderName.Font = Enum.Font.SourceSans
				MiniToggleHolderName.Text = MiniToggle.Name
				MiniToggleHolderName.TextColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleHolderName.TextSize = 16.000
				MiniToggleHolderName.TextWrapped = true
				MiniToggleHolderName.TextXAlignment = Enum.TextXAlignment.Left

				local MiniToggleHolderTrigger = Instance.new("TextButton")
				MiniToggleHolderTrigger.Parent = MiniToggleHolder
				MiniToggleHolderTrigger.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				MiniToggleHolderTrigger.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleHolderTrigger.BorderSizePixel = 0
				MiniToggleHolderTrigger.Position = UDim2.new(0, 165, 0, 5)
				MiniToggleHolderTrigger.Size = UDim2.new(0, 15, 0, 15)
				MiniToggleHolderTrigger.AutoButtonColor = false
				MiniToggleHolderTrigger.Font = Enum.Font.SourceSans
				MiniToggleHolderTrigger.Text = "x"
				MiniToggleHolderTrigger.TextTransparency = 1
				MiniToggleHolderTrigger.TextColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleHolderTrigger.TextSize = 18.000
				MiniToggleHolderTrigger.TextWrapped = true
				MiniToggleHolderTrigger.TextYAlignment = Enum.TextYAlignment.Bottom

				local UICorner = Instance.new("UICorner")
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = MiniToggleHolderTrigger

				local function MiniToggleClick()
					if MiniToggle.Enabled then
						ConfigSetting.ToggleButton.MiniToggle[MiniToggle.Name].Enabled = MiniToggle.Enabled
						TweenService:Create(MiniToggleHolderTrigger, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
					else
						ConfigSetting.ToggleButton.MiniToggle[MiniToggle.Name].Enabled = MiniToggle.Enabled
						TweenService:Create(MiniToggleHolderTrigger, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
					end
				end

				--[[
				spawn(function()
					while true do
						task.wait()
						if MiniToggle.AutoDisable then
							if MiniToggle.Enabled then
								MiniToggle.Enabled = false
								MiniToggleClick()

								if MiniToggle.Callback then
									MiniToggle.Callback(MiniToggle.Enabled)
								end
							end
						end
					end
				end)
				--]]

				if MiniToggle.Enabled then
					MiniToggle.Enabled = true
					MiniToggleClick()

					if MiniToggle.Callback then
						MiniToggle.Callback(MiniToggle.Enabled)
					end
				end 

				MiniToggleHolderTrigger.MouseButton1Click:Connect(function()
					MiniToggle.Enabled = not MiniToggle.Enabled
					MiniToggleClick()

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
				if not ConfigSetting.ToggleButton.Sliders[Slider.Name] then
					ConfigSetting.ToggleButton.Sliders[Slider.Name] = {
						Default = Slider.Default
					}
				else
					Slider.Default = ConfigSetting.ToggleButton.Sliders[Slider.Name].Default
				end

				local Value
				local Dragged = false
				local SliderHolder = Instance.new("Frame")
				SliderHolder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				SliderHolder.BackgroundTransparency = 1.000
				SliderHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolder.BorderSizePixel = 0
				SliderHolder.Size = UDim2.new(1, 0, 0, 28)
				if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
					if ToggleMenu ~= nil then
						SliderHolder.Parent = ScrollingMenu
					end
				elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
					if ToggleMenu ~= nil then
						SliderHolder.Parent = ToggleMenu
					end
				end

				local SliderHolderName = Instance.new("TextLabel")
				SliderHolderName.Parent = SliderHolder
				SliderHolderName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderHolderName.BackgroundTransparency = 1.000
				SliderHolderName.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderName.BorderSizePixel = 0
				SliderHolderName.Position = UDim2.new(0, 5, 0, 0)
				SliderHolderName.Size = UDim2.new(1, 0, 0, 15)
				SliderHolderName.Font = Enum.Font.SourceSans
				SliderHolderName.Text = Slider.Name
				SliderHolderName.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderHolderName.TextScaled = true
				SliderHolderName.TextSize = 16.000
				SliderHolderName.TextWrapped = true
				SliderHolderName.TextXAlignment = Enum.TextXAlignment.Left

				local SliderHolderValue = Instance.new("TextLabel")
				SliderHolderValue.Parent = SliderHolder
				SliderHolderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderHolderValue.BackgroundTransparency = 1.000
				SliderHolderValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderValue.BorderSizePixel = 0
				SliderHolderValue.Size = UDim2.new(0, 180, 0, 15)
				SliderHolderValue.Font = Enum.Font.SourceSans
				SliderHolderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderHolderValue.TextScaled = true
				SliderHolderValue.TextSize = 16.000
				SliderHolderValue.TextWrapped = true
				SliderHolderValue.TextXAlignment = Enum.TextXAlignment.Right

				local SliderHolderBack = Instance.new("Frame")
				SliderHolderBack.Parent = SliderHolder
				SliderHolderBack.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
				SliderHolderBack.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderBack.BorderSizePixel = 0
				SliderHolderBack.Position = UDim2.new(0, 5, 0, 18)
				SliderHolderBack.Size = UDim2.new(0, 172, 0, 8)

				local SliderHolderFront = Instance.new("Frame")
				SliderHolderFront.Parent = SliderHolderBack
				SliderHolderFront.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
				SliderHolderFront.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderFront.BorderSizePixel = 0
				SliderHolderFront.Size = UDim2.new(0, 50, 1, 0)

				local SliderHolderGradient = Instance.new("UIGradient")
				SliderHolderGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(138, 230, 255))}
				SliderHolderGradient.Parent = SliderHolderFront

				local SliderHolderMain = Instance.new("TextButton")
				SliderHolderMain.Parent = SliderHolderFront
				SliderHolderMain.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				SliderHolderMain.BackgroundTransparency = 0.150
				SliderHolderMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderMain.BorderSizePixel = 0
				SliderHolderMain.Position = UDim2.new(1, 0, 0, -2)
				SliderHolderMain.Size = UDim2.new(0, 8, 0, 12)
				SliderHolderMain.Font = Enum.Font.SourceSans
				SliderHolderMain.Text = ""
				SliderHolderMain.TextColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderMain.TextSize = 14.000

				local function SliderDragged(input)
					local InputPos = input.Position
					Value = math.clamp((InputPos.X - SliderHolderBack.AbsolutePosition.X) / SliderHolderBack.AbsoluteSize.X, 0, 1)
					local SliderValue = math.round(Value * (Slider.Max - Slider.Min)) + Slider.Min
					SliderHolderFront.Size = UDim2.fromScale(Value, 1)
					SliderHolderValue.Text = SliderValue
					Slider.Callback(SliderValue)
					ConfigSetting.ToggleButton.Sliders[Slider.Name].Default = SliderValue
				end

				SliderHolderMain.MouseButton1Down:Connect(function()
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
					SliderHolderValue.Text = Slider.Default
					Value = (Slider.Default - Slider.Min) / (Slider.Max - Slider.Min)
					SliderHolderFront.Size = UDim2.fromScale(Value, 1)
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
				if not ConfigSetting.ToggleButton.Dropdown[Dropdown.Name] then
					ConfigSetting.ToggleButton.Dropdown[Dropdown.Name] = {
						Default = Dropdown.Default
					}
				else
					Dropdown.Default = ConfigSetting.ToggleButton.Dropdown[Dropdown.Name].Default
				end

				local Selected
				local DropdownHolder = Instance.new("TextButton")
				DropdownHolder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				DropdownHolder.BackgroundTransparency = 1.000
				DropdownHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownHolder.BorderSizePixel = 0
				DropdownHolder.Size = UDim2.new(1, 0, 0, 25)
				DropdownHolder.AutoButtonColor = false
				DropdownHolder.Font = Enum.Font.SourceSans
				DropdownHolder.Text = ""
				DropdownHolder.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownHolder.TextSize = 16.000
				DropdownHolder.TextWrapped = true
				DropdownHolder.TextXAlignment = Enum.TextXAlignment.Left
				if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
					if ToggleMenu ~= nil then
						DropdownHolder.Parent = ScrollingMenu
					end
				elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
					if ToggleMenu ~= nil then
						DropdownHolder.Parent = ToggleMenu
					end
				end

				local DropdownSelected = Instance.new("TextLabel")
				DropdownSelected.Parent = DropdownHolder
				DropdownSelected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownSelected.BackgroundTransparency = 1.000
				DropdownSelected.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownSelected.BorderSizePixel = 0
				DropdownSelected.Size = UDim2.new(0, 180, 1, 0)
				DropdownSelected.Font = Enum.Font.SourceSans
				DropdownSelected.Text = Dropdown.Default or "None"
				DropdownSelected.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownSelected.TextSize = 16.000
				DropdownSelected.TextWrapped = true
				DropdownSelected.TextXAlignment = Enum.TextXAlignment.Right

				local DropdownMode = Instance.new("TextLabel")
				DropdownMode.Parent = DropdownHolder
				DropdownMode.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownMode.BackgroundTransparency = 1.000
				DropdownMode.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownMode.BorderSizePixel = 0
				DropdownMode.Position = UDim2.new(0, 5, 0, 0)
				DropdownMode.Size = UDim2.new(0, 45, 1, 0)
				DropdownMode.Font = Enum.Font.SourceSans
				DropdownMode.Text = "Mode"
				DropdownMode.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownMode.TextSize = 16.000
				DropdownMode.TextWrapped = true
				DropdownMode.TextXAlignment = Enum.TextXAlignment.Left

				local CurrentDropdown = 1
				DropdownHolder.MouseButton1Click:Connect(function()
					DropdownSelected.Text = Dropdown.List[CurrentDropdown]
					Dropdown.Callback(Dropdown.List[CurrentDropdown])
					Selected = Dropdown.List[CurrentDropdown]
					CurrentDropdown = CurrentDropdown % #Dropdown.List + 1
					ConfigSetting.ToggleButton.Dropdown[Dropdown.Name].Default = Selected
				end)

				if Dropdown.Default then
					Dropdown.Callback(Dropdown.Default)
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
