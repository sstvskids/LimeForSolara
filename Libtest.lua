local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local getasset = getcustomasset
local clonerf = cloneref
local Library = {}
if not shared.Lime then
	shared.Lime = {
		Visual = {
			Hud = true,
			Arraylist = true,
			Watermark = true
		},
		Uninjected = false,
		LimeStopped = false
	}
end

local ConfigName = nil
local LimeFolder = "Lime"
local CurrentGameFolder = nil
local CurrentGameConfig = nil
local AssetsFolder = "Lime/assets"
local ConfigsFolder = "Lime/configs"
local ConfigTable = {ToggleButton = {Position = {}, MiniToggle = {},  Sliders = {},  Dropdown = {}}}

if not isfolder(LimeFolder) then makefolder(LimeFolder) end
if not isfolder(AssetsFolder) then makefolder(AssetsFolder) end
if not isfolder(ConfigsFolder) then makefolder(ConfigsFolder) end

local AutoSave = true
local ManagerMenu, TextBox_2, DeleteConfig, CreateConfig, LoadConfig, Manager
if isfolder(LimeFolder) and isfolder(AssetsFolder) and isfolder(ConfigsFolder) then
	CurrentGameConfig = LimeFolder .. "/" .. game.PlaceId .. ".lua"
	if not isfolder(ConfigsFolder .. "/" .. game.PlaceId) then
		CurrentGameFolder = ConfigsFolder .. "/" .. game.PlaceId
		makefolder(PlaceIdFolder)
	end
	if isfile(CurrentGameConfig) then
		local GetMain = readfile(CurrentGameConfig)
		if GetMain then
			local OldSettings = HttpService:JSONDecode(GetMain)
			if OldSettings then
				ConfigTable = OldSettings
			end
		end
	end
	spawn(function()
		repeat
			task.wait()
			if shared.Lime.Uninjected then
				AutoSave = false
			else
				if AutoSave then
					writefile(PlaceIdAutoSave, HttpService:JSONEncode(ConfigTable))
				end
			end
		until shared.Lime.LimeStopped
	end)
end

local function MakeDraggable(obj)
	local CanDrag, DragInput, Start, StartPos

	local function update(input)
		local delta = input.Position - Start
		obj.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
	end

	obj.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			CanDrag = true
			Start = Input.Position
			StartPos = obj.Position
			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					CanDrag = false
				end
			end)
		end
	end)

	obj.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			DragInput = Input
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if Input == DragInput and CanDrag then
			update(Input)
		end
	end)
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
			ScreenGui.Parent = CoreGui
		end
	end
	
	spawn(function()
		repeat
			task.wait()
			if ScreenGui and shared.Lime.Uninjected then
				task.wait(1.8)
				ScreenGui:Destroy()
				shared.Lime.Uninjected = false
				shared.Lime.LimeStopped = true
			end
		until shared.Lime.LimeStopped
	end)

	local MainFrame
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
		if not MainFrame then
			MainFrame = Instance.new("ScrollingFrame")
			MainFrame.Parent = ScreenGui
			MainFrame.Active = true
			MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			MainFrame.BackgroundTransparency = 1.000
			MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			MainFrame.BorderSizePixel = 0
			MainFrame.Size = UDim2.new(1, 0, 1, 0)
			MainFrame.CanvasPosition = Vector2.new(240, 0)
			MainFrame.CanvasSize = UDim2.new(1.9, 0, 0, 0)
			MainFrame.ScrollBarThickness = 8
			MainFrame.Visible = false
		end
	elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
		if not MainFrame then
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
		local NewX = 0
		if MainFrame then
			for _, v in ipairs(MainFrame:GetChildren()) do
				if v:IsA("GuiObject") then
					v.Position = UDim2.new(0, NewX, 0, 0)
					NewX = NewX + v.Size.X.Offset + 18
				end
			end
		end
	end)
	
	local HudFrame = Instance.new("Frame")
	HudFrame.Parent = ScreenGui
	HudFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HudFrame.BackgroundTransparency = 1.000
	HudFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HudFrame.BorderSizePixel = 0
	HudFrame.Size = UDim2.new(1, 0, 1, 0)
	
	spawn(function()
		repeat
			task.wait()
			if HudFrame then
				if shared.Lime.Visual.Hud then
					HudFrame.Visible = true
				else
					HudFrame.Visible = false
				end
			end
		until shared.Lime.LimeStopped
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

	local Watermark = Instance.new("TextLabel")
	Watermark.Parent = HudFrame
	Watermark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Watermark.BackgroundTransparency = 1.000
	Watermark.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Watermark.BorderSizePixel = 0
	Watermark.Position = UDim2.new(0, 20, 0, 18)
	Watermark.Size = UDim2.new(0, 345, 0, 30)
	Watermark.RichText = true
	Watermark.Text = "<font size='14'>Lime</font> <font size='12'>Beta</font>"
	Watermark.Font = Enum.Font.SourceSans
	Watermark.TextColor3 = Color3.fromRGB(255, 0, 127)
	Watermark.TextScaled = true
	Watermark.TextSize = 14.000
	Watermark.TextWrapped = true
	Watermark.TextXAlignment = Enum.TextXAlignment.Left
	Watermark.ZIndex = -1

	local WatermarkGradient = Instance.new("UIGradient")
	WatermarkGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(138, 230, 255))}
	WatermarkGradient.Parent = Watermark

	spawn(function()
		repeat
			task.wait()
			if Watermark then
				if shared.Lime.Visual.Watermark then
					Watermark.Visible = true
				else
					Watermark.Visible = false
				end
			end
		until shared.Lime.LimeStopped
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
		repeat
			task.wait()
			if ArrayFrame then
				if shared.Lime.Visual.Arraylist then
					ArrayFrame.Visible = true
				else
					ArrayFrame.Visible = false
				end
			end
		until shared.Lime.LimeStopped
	end)
	
	local oldasset = {}
	local function GetAssets(path)
		if not isfile(path) then
			local Response = HttpService:RequestAsync({
				Url = "https://raw.githubusercontent.com/AfgMS/LimeForRoblox/main/assets/" .. path,
				Method = "GET"
			})
			local TextLabel_4 = Instance.new("TextLabel")
			TextLabel_4.Parent = HudFrame
			TextLabel_4.AnchorPoint = Vector2.new(0.5, 0.5)
			TextLabel_4.BackgroundTransparency = 1
			TextLabel_4.Position = UDim2.new(0.5, 0, 0.55, 0)
			TextLabel_4.Size = UDim2.new(1, 0, 0, 18)
			TextLabel_4.Font = Enum.Font.SourceSans
			TextLabel_4.Text = "Downloading " .. path
			TextLabel_4.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel_4.TextScaled = true
			task.spawn(function()
				repeat task.wait() until isfile(path)
				TextLabel_4:Destroy()
			end)

			if Response.StatusCode == 200 then
				writefile(path, Response.Body)
			else
				TextLabel_4.Text = "Failed to get assets"
			end
		end

		if not oldasset[path] then
			oldasset[path] = getasset(path)
		end

		return oldasset[path]
	end

	local function AddArray(name, suffix)
		local TextLabel = Instance.new("TextLabel")
		TextLabel.Parent = ArrayFrame
		TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.TextTransparency = 1
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Font = Enum.Font.SourceSans
		TextLabel.RichText = true
		TextLabel.Text = name .. " <font color='rgb(180, 180, 180)'>" .. (suffix or "") .. "</font>"
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

		local NewWidth = game.TextService:GetTextSize(name .. (suffix or ""), 18, Enum.Font.SourceSans, Vector2.new(0, 0)).X
		local NewSize = UDim2.new(0.01, game.TextService:GetTextSize(name .. (suffix or "") , 18, Enum.Font.SourceSans, Vector2.new(0,0)).X, 0,20)
		if name .. (suffix or "") == "" then
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
			if (v.Text:match(name)) then
				v:Destroy()
				table.remove(ArrayTable,c)
			else
				v.LayoutOrder = i
			end
		end
	end

	local MainOpen, UICorner_2
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
		if MainFrame and MainFrame:IsA("ScrollingFrame") then
			MainOpen = Instance.new("TextButton")
			MainOpen.Parent = ScreenGui
			MainOpen.AnchorPoint = Vector2.new(0.5, 0.5)
			MainOpen.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			MainOpen.BackgroundTransparency = 0.550
			MainOpen.BorderColor3 = Color3.fromRGB(0, 0, 0)
			MainOpen.BorderSizePixel = 0
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
	
	function Main:CreateManager()
		local Managers = {}

		Manager = Instance.new("Frame")
		Manager.Parent = MainFrame
		Manager.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		Manager.BackgroundTransparency = 0.030
		Manager.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Manager.BorderSizePixel = 0
		Manager.Position = UDim2.new(0, 222, 0, 0)
		Manager.Size = UDim2.new(0, 185, 0, 25)
		if not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
			MakeDraggable(Manager)
		end

		local ManagerName = Instance.new("TextLabel")
		ManagerName.Parent = Manager
		ManagerName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ManagerName.BackgroundTransparency = 1.000
		ManagerName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ManagerName.BorderSizePixel = 0
		ManagerName.Position = UDim2.new(0, 5, 0, 0)
		ManagerName.Size = UDim2.new(0, 145, 1, 0)
		ManagerName.Font = Enum.Font.Nunito
		ManagerName.Text = "Manager"
		ManagerName.TextColor3 = Color3.fromRGB(255, 255, 255)
		ManagerName.TextSize = 18.000
		ManagerName.TextWrapped = true
		ManagerName.TextXAlignment = Enum.TextXAlignment.Left

		local ManagerIcon = Instance.new("ImageLabel")
		ManagerIcon.Parent = Manager
		ManagerIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		ManagerIcon.BackgroundColor3 = Color3.fromRGB(145, 145, 145)
		ManagerIcon.BackgroundTransparency = 1.000
		ManagerIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ManagerIcon.BorderSizePixel = 0
		ManagerIcon.Position = UDim2.new(0.930000007, 0, 0.5, 0)
		ManagerIcon.Size = UDim2.new(0, 18, 0, 18)
		ManagerIcon.Image = "rbxassetid://12403099678"

		local ManagerList = Instance.new("Frame")
		ManagerList.Parent = Manager
		ManagerList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ManagerList.BackgroundTransparency = 1.000
		ManagerList.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ManagerList.BorderSizePixel = 0
		ManagerList.Position = UDim2.new(0, 0, 1, 0)
		ManagerList.Size = UDim2.new(1, 0, 0, 0)

		local UIListLayout_3 = Instance.new("UIListLayout")
		UIListLayout_3.Parent = ManagerList
		UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder

		ManagerMenu = Instance.new("Frame")
		ManagerMenu.Parent = ManagerList
		ManagerMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		ManagerMenu.BackgroundTransparency = 0.150
		ManagerMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ManagerMenu.BorderSizePixel = 0
		ManagerMenu.Position = UDim2.new(0, 0, 25, 0)
		ManagerMenu.Size = UDim2.new(1, 0, 0, 125)

		local UIListLayout_5 = Instance.new("UIListLayout")
		UIListLayout_5.Parent = ManagerMenu
		UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
		
		spawn(function()
			repeat
				task.wait()
				if ManagerMenu and isfolder(CurrentGameFolder) then
					for _, v in ipairs(listfiles(CurrentGameFolder)) do
						if isfile(v) then
							for _, b in pairs(ManagerMenu:GetChildren()) do
								if b:IsA("TextLabel") and b.Text ~= v then
									local TextLabel_1 = Instance.new("TextLabel")
									TextLabel_1.Parent = ManagerMenu
									TextLabel_1.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
									TextLabel_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
									TextLabel_1.BorderSizePixel = 0
									TextLabel_1.Size = UDim2.new(1, 0, 0, 25)
									TextLabel_1.Font = Enum.Font.SourceSans
									TextLabel_1.Text = v
									TextLabel_1.TextColor3 = Color3.fromRGB(255, 255, 255)
									TextLabel_1.TextSize = 14.000
									break
								end
							end
						else
							for _ , b in pairs(ManagerMenu:GetChildren()) do
								if b:IsA("TextLabel") and b.Text == v then
									b:Destroy()
									break
								end
							end
						end
					end
				end
			until shared.Lime.LimeStopped
		end)

		local TextLabel_3 = Instance.new("TextLabel")
		TextLabel_3.Parent = ManagerMenu
		TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel_3.BackgroundTransparency = 1.000
		TextLabel_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel_3.BorderSizePixel = 0
		TextLabel_3.LayoutOrder = -1
		TextLabel_3.Size = UDim2.new(1, 0, 0, 25)
		TextLabel_3.Font = Enum.Font.SourceSans
		TextLabel_3.Text = "Available Config:"
		TextLabel_3.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel_3.TextSize = 14.000
		TextLabel_3.TextTransparency = 0.350

		local ManagerControl = Instance.new("Frame")
		ManagerControl.Parent = ManagerList
		ManagerControl.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		ManagerControl.BackgroundTransparency = 0.230
		ManagerControl.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ManagerControl.BorderSizePixel = 0
		ManagerControl.Size = UDim2.new(1, 0, 0, 25)

		TextBox_2 = Instance.new("TextBox")
		TextBox_2.Parent = ManagerControl
		TextBox_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextBox_2.BackgroundTransparency = 1.000
		TextBox_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox_2.BorderSizePixel = 0
		TextBox_2.Position = UDim2.new(0, 5, 0, 0)
		TextBox_2.Size = UDim2.new(0, 125, 1, 0)
		TextBox_2.Font = Enum.Font.SourceSans
		TextBox_2.PlaceholderText = "Config Name"
		TextBox_2.Text = ""
		TextBox_2.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextBox_2.TextSize = 16.000
		TextBox_2.TextWrapped = true
		TextBox_2.TextXAlignment = Enum.TextXAlignment.Left
		TextBox_2.FocusLost:Connect(function()
			ConfigName = TextBox_2.Text
		end)

		DeleteConfig = Instance.new("ImageButton")
		DeleteConfig.Parent = ManagerControl
		DeleteConfig.AnchorPoint = Vector2.new(0.5, 0.5)
		DeleteConfig.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		DeleteConfig.BackgroundTransparency = 1.000
		DeleteConfig.BorderColor3 = Color3.fromRGB(0, 0, 0)
		DeleteConfig.BorderSizePixel = 0
		DeleteConfig.Position = UDim2.new(0.930000007, 0, 0.5, 0)
		DeleteConfig.Size = UDim2.new(0, 20, 0, 20)
		DeleteConfig.AutoButtonColor = true
		DeleteConfig.Image = "rbxassetid://15921650550"
		DeleteConfig.MouseButton1Click:Connect(function()
			if isfile(CurrentGameConfig) and ConfigName then
				local OldConfig = ConfigsFolder .. "/" .. game.PlaceId .. "/" .. ConfigName .. ".lua"
				if isfile(OldConfig) then
					delfile(OldConfig)
				end
			end
		end)
		
		CreateConfig = Instance.new("ImageButton")
		CreateConfig.Parent = ManagerControl
		CreateConfig.AnchorPoint = Vector2.new(0.5, 0.5)
		CreateConfig.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		CreateConfig.BackgroundTransparency = 1.000
		CreateConfig.BorderColor3 = Color3.fromRGB(0, 0, 0)
		CreateConfig.BorderSizePixel = 0
		CreateConfig.Position = UDim2.new(0.730000019, 0, 0.5, 0)
		CreateConfig.Size = UDim2.new(0, 20, 0, 20)
		CreateConfig.AutoButtonColor = true
		CreateConfig.Image = "rbxassetid://9063830322"
		CreateConfig.MouseButton1Click:Connect(function()
			if isfile(CurrentGameConfig) and ConfigName then
				local NewConfig = ConfigsFolder .. "/" .. game.PlaceId .. "/" .. ConfigName .. ".lua"
				if not isfile(NewConfig) then
					writefile(NewConfig, readfile(CurrentGameConfig))
				end
			end
		end)

		LoadConfig = Instance.new("ImageButton")
		LoadConfig.Parent = ManagerControl
		LoadConfig.AnchorPoint = Vector2.new(0.5, 0.5)
		LoadConfig.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LoadConfig.BackgroundTransparency = 1.000
		LoadConfig.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LoadConfig.BorderSizePixel = 0
		LoadConfig.Position = UDim2.new(0.829999983, 0, 0.5, 0)
		LoadConfig.Size = UDim2.new(0, 18, 0, 18)
		LoadConfig.AutoButtonColor = true
		LoadConfig.Image = "rbxassetid://15911231575"
		LoadConfig.MouseButton1Click:Connect(function()
			if isfolder(CurrentGameFolder) and isfile(CurrentGameConfig) and ConfigName then
				local GetConfig = CurrentGameFolder .. "/" .. ConfigName .. ".lua"
				if isfile(GetConfig) then
					shared.Lime.Uninjected = true
					shared.Lime.LimeStopped = true
					task.wait(2)
					writefile(CurrentGameConfig, readfile(GetConfig))
					loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/LimeForRoblox/refs/heads/main/Loader.lua"))()
				end
			end
		end)
		
		return Managers
	end
	
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
	
	function Main:CreateTab(types)
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
		
		if types == "1" then
			TabName.Text = "Combat"
			ImageLabel.ImageColor3 = Color3.fromRGB(255, 85, 127)
			if getasset then
				ImageLabel.Image = GetAssets("combat.png") or getasset("combat.png")
			else
				ImageLabel.Image = "http://www.roblox.com/asset/?id=138185990548352"
			end
		elseif types == "2" then
			TabName.Text = "Exploit"
			ImageLabel.ImageColor3 = Color3.fromRGB(0, 255, 187)
			if getasset then
				ImageLabel.Image = GetAssets("exploit.png") or getasset("exploit.png")
			else
				ImageLabel.Image = "http://www.roblox.com/asset/?id=71954798465945"
			end
		elseif types == "3" then
			TabName.Text = "Move"
			ImageLabel.ImageColor3 = Color3.fromRGB(82, 246, 255)
			if getasset then
				ImageLabel.Image = GetAssets("movement.png") or getasset("movement.png")
			else
				ImageLabel.Image = "http://www.roblox.com/asset/?id=91366694317593"
			end
		elseif types == "4" then
			TabName.Text = "Player"
			ImageLabel.ImageColor3 = Color3.fromRGB(255, 255, 127)
			if getasset then
				ImageLabel.Image = GetAssets("player.png") or getasset("player.png")
			else
				ImageLabel.Image = "http://www.roblox.com/asset/?id=103157697311305"
			end
		elseif types == "5" then
			TabName.Text = "Visual"
			ImageLabel.ImageColor3 = Color3.fromRGB(170, 85, 255)
			if getasset then
				ImageLabel.Image = GetAssets("render.png") or getasset("render.png")
			else
				ImageLabel.Image = "http://www.roblox.com/asset/?id=118420030502964"
			end
		elseif types == "6" then
			TabName.Text = "World"
			ImageLabel.ImageColor3 = Color3.fromRGB(255, 170, 0)
			if getasset then
				ImageLabel.Image = GetAssets("world.png") or getasset("world.png")
			else
				ImageLabel.Image = "http://www.roblox.com/asset/?id=76313147188124"
			end
		end

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
				Suffix = ToggleButton.Suffix or "",
				Enabled = ToggleButton.Enabled or false,
				Keybind = ToggleButton.Keybind or "Euro",
				AutoEnable = ToggleButton.AutoEnable or false,
				AutoDisable = ToggleButton.AutoDisable or false,
				IsMobileKey = ToggleButton.IsMobileKey or false,
				Callback = ToggleButton.Callback or function() end,
				Position = ToggleButton.Position or UDim2.new(0, 0.5, 0, 0.5),
			}
			if not ConfigTable.ToggleButton[ToggleButton.Name] then
				ConfigTable.ToggleButton[ToggleButton.Name] = {
					Enabled = ToggleButton.Enabled,
					Keybind = ToggleButton.Keybind,
					Position = ToggleButton.Position,
					IsMobileKey = ToggleButton.IsMobileKey
				}
			else
				ToggleButton.Enabled = ConfigTable.ToggleButton[ToggleButton.Name].Enabled
				ToggleButton.Keybind = ConfigTable.ToggleButton[ToggleButton.Name].Keybind
				ToggleButton.Position = ConfigTable.ToggleButton[ToggleButton.Name].Position
				ToggleButton.IsMobileKey = ConfigTable.ToggleButton[ToggleButton.Name].IsMobileKey
			end

			local ToggleButtonMain = Instance.new("TextButton")
			ToggleButtonMain.Parent = TogglesList
			ToggleButtonMain.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			ToggleButtonMain.BackgroundTransparency = 0.230
			ToggleButtonMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleButtonMain.BorderSizePixel = 0
			ToggleButtonMain.Size = UDim2.new(1, 0, 0, 25)
			ToggleButtonMain.AutoButtonColor = false
			ToggleButtonMain.Font = Enum.Font.SourceSans
			ToggleButtonMain.Text = ""
			ToggleButtonMain.ZIndex = 2
			ToggleButtonMain.TextColor3 = Color3.fromRGB(0, 0, 0)
			ToggleButtonMain.TextSize = 14.000

			local ToggleName = Instance.new("TextLabel")
			ToggleName.Parent = ToggleButtonMain
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
			OpenMenu.Parent = ToggleButtonMain
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
			UIGradient.Parent = ToggleButtonMain
			UIGradient.Enabled = false
			
			local ToggleMenuOpened = false
			local ToggleMenuOld = UDim2.new(1, 0, 0, 0)
			local ToggleMenuNew = UDim2.new(1, 0, 0, 125)
			local ToggleMenu, ScrollingMenu, UIListLayout_2
			if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
				if not ToggleMenu and not ScrollingMenu and not UIListLayout_2 then
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
					
					UIListLayout_2 = Instance.new("UIListLayout")
					UIListLayout_2.Parent = ScrollingMenu
					UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
					
				end
			elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
				if not ToggleMenu and not UIListLayout_2 then
					ToggleMenu = Instance.new("Frame")
					ToggleMenu.Parent = TogglesList
					ToggleMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
					ToggleMenu.BackgroundTransparency = 0.150
					ToggleMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
					ToggleMenu.BorderSizePixel = 0
					ToggleMenu.Position = UDim2.new(0, 0, 25, 0)
					ToggleMenu.Size = UDim2.new(1, 0, 0, 125)
					ToggleMenu.Visible = false
					
					UIListLayout_2 = Instance.new("UIListLayout")
					UIListLayout_2.Parent = ToggleMenu
					UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
				end
			end
			
			local Keybinds
			if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
				if not Keybinds then
					local IsKeybind = false
					Keybinds = Instance.new("TextButton")
					Keybinds.Parent = ScrollingMenu
					Keybinds.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
					Keybinds.BackgroundTransparency = 1
					Keybinds.BorderSizePixel = 0
					Keybinds.LayoutOrder = -1
					Keybinds.Size = UDim2.new(1, 0, 0, 25)
					Keybinds.Font = Enum.Font.SourceSans
					Keybinds.Text = "Show"
					Keybinds.TextColor3 = Color3.fromRGB(255, 255, 255)
					Keybinds.TextSize = 14

					local MobileKeybindY = game:GetService("TextService"):GetTextSize(ToggleButton.Name, 14, Enum.Font.SourceSans, Vector2.new(200, math.huge))
					local MobileKeybinds = Instance.new("TextButton")
					MobileKeybinds.Parent = KeybindFrame
					MobileKeybinds.BackgroundTransparency = 0.75
					MobileKeybinds.AnchorPoint = Vector2.new(0.5, 0.5)
					MobileKeybinds.BorderSizePixel = 0
					MobileKeybinds.Position = ToggleButton.Position
					MobileKeybinds.Size = UDim2.new(0, 65, 0, MobileKeybindY.Y + 15)
					MobileKeybinds.Font = Enum.Font.SourceSans
					MobileKeybinds.Text = ToggleButton.Name
					MobileKeybinds.Name = ToggleButton.Name
					MobileKeybinds.TextColor3 = Color3.fromRGB(0, 0, 0)
					MobileKeybinds.TextScaled = true
					MobileKeybinds.TextWrapped = true
					MobileKeybinds.Visible = false
					MakeDraggable(MobileKeybinds)

					local UICorner = Instance.new("UICorner")
					UICorner.CornerRadius = UDim.new(0, 4)
					UICorner.Parent = MobileKeybinds

					Keybinds.MouseButton1Click:Connect(function()
						IsKeybind = not IsKeybind
						Keybinds.BackgroundColor3 = IsKeybind and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
						if IsKeybind then
							task.spawn(function()
								repeat
									task.wait()
									MobileKeybinds.BackgroundColor3 = ToggleButton.Enabled and Color3.fromRGB(0, 175, 0) or Color3.fromRGB(175, 0, 0)
									if shared.Lime.Uninjected then
										for _, v in pairs(KeybindFrame:GetChildren()) do
											if v:IsA("TextButton") and v.Name == ToggleButton.Name then
												v:Destroy()
											end
										end
										Keybinds.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
									end
									ConfigTable.ToggleButton[ToggleButton.Name].Position = MobileKeybinds.Position
									ConfigTable.ToggleButton[ToggleButton.Name].IsMobileKey = MobileKeybinds.Visible
								until shared.Lime.LimeStopped
							end)
						end
					end)
					
					local function MobileClicked()
						if ToggleButton.Enabled then
							MobileKeybinds.Visible = true
							TweenService:Create(ToggleButtonMain, TweenInfo.new(0.4), {Transparency = 0,BackgroundColor3 = Color3.fromRGB(255, 0, 127)}):Play()
							TweenService:Create(UIGradient, TweenInfo.new(0.4), {Enabled = true}):Play()
							AddArray(ToggleButton.Name)
						else
							MobileKeybinds.Visible = false
							TweenService:Create(ToggleButtonMain, TweenInfo.new(0.4), {Transparency = 0.230,BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
							TweenService:Create(UIGradient, TweenInfo.new(0.4), {Enabled = false}):Play()
							RemoveArray(ToggleButton.Name)
						end
					end

					MobileKeybinds.MouseButton1Click:Connect(function()
						ToggleButton.Enabled = not ToggleButton.Enabled
						MobileClicked()

						if ToggleButton.Callback then
							ToggleButton.Callback(ToggleButton.Enabled)
						end
					end)
				else
					for _, v in pairs(KeybindFrame:GetChildren()) do
						if v:IsA("TextButton") and v.Name == ToggleButton.Name then
							v.Visible = false
						end
					end
					Keybinds.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				end
			elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
				if not Keybinds then
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
								ConfigTable.ToggleButton[ToggleButton.Name].Keybind = ToggleButton.Keybind
							elseif ToggleButton.Keybind == "Backspace" then
								ToggleButton.Keybind = "Home"
								Keybinds.Text = ""
								Keybinds.PlaceholderText = "None"
								ConfigTable.ToggleButton[ToggleButton.Name].Keybind = ToggleButton.Keybind
							end       
						end
						spawn(function()
							repeat
								task.wait()
								if ToggleButton.Keybind ~= "Home" then
									Keybinds.PlaceholderText = ""
									Keybinds.Text = ToggleButton.Keybind
								end
								if shared.Lime.Uninjected then
									if Keybinds then
										Keybinds.Text = ""
										Keybinds.PlaceholderText = "None"
									end
								end
							until shared.Lime.LimeStopped
						end)
					end)
				end
			end
			
			spawn(function()
				repeat
					task.wait()
					if ToggleButton.Suffix then
						for _, v in ipairs(ArrayTable) do
							if v.Text:match(ToggleButton.Name) then
								local NewSuffix = ToggleButton.Name .. " <font color='rgb(180, 180, 180)'>" .. ToggleButton.Suffix .. "</font>"
								if v.Text ~= NewSuffix then
									v.Text = NewSuffix
								end
							end
						end
					end
				until shared.Lime.LimeStopped
			end)

			local function ToggleButtonClicked()
				if ToggleButton.Enabled then
					ConfigTable.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
					TweenService:Create(ToggleButtonMain, TweenInfo.new(0.4), {Transparency = 0,BackgroundColor3 = Color3.fromRGB(255, 0, 127)}):Play()
					TweenService:Create(UIGradient, TweenInfo.new(0.4), {Enabled = true}):Play()
					AddArray(ToggleButton.Name, ToggleButton.Suffix)
				else
					ConfigTable.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
					TweenService:Create(ToggleButtonMain, TweenInfo.new(0.4), {Transparency = 0.230,BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
					TweenService:Create(UIGradient, TweenInfo.new(0.4), {Enabled = false}):Play()
					RemoveArray(ToggleButton.Name)
				end
			end
			
			spawn(function()
				repeat
					task.wait()
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
						task.wait(1.2)
						if ToggleButton.Enabled then
							ToggleButton.Enabled = false
							ToggleButtonClicked()

							if ToggleButton.Callback then
								ToggleButton.Callback(ToggleButton.Enabled)
							end
						end
					end
				until shared.Lime.LimeStopped
			end)

			if ToggleButton.Enabled then
				ToggleButton.Enabled = true
				ToggleButtonClicked()

				if ToggleButton.Callback then
					ToggleButton.Callback(ToggleButton.Enabled)
				end
			end

			ToggleButtonMain.MouseButton1Click:Connect(function()
				ToggleButton.Enabled = not ToggleButton.Enabled
				ToggleButtonClicked()

				if ToggleButton.Callback then
					ToggleButton.Callback(ToggleButton.Enabled)
				end
			end)

			ToggleButtonMain.MouseButton2Click:Connect(function()
				ToggleMenuOpened = not ToggleMenuOpened
				if ToggleMenuOpened then
					ToggleMenu.Visible = true
					ToggleMenu.AutomaticSize = Enum.AutomaticSize.Y
					TweenService:Create(OpenMenu, TweenInfo.new(0.4), {Rotation = 90}):Play()
					TweenService:Create(ToggleMenu, TweenInfo.new(0.6), {Size = ToggleMenuNew}):Play()
				else
					ToggleMenu.Visible = false
					TweenService:Create(OpenMenu, TweenInfo.new(0.4), {Rotation = 0}):Play()
					TweenService:Create(ToggleMenu, TweenInfo.new(0.6), {Size = ToggleMenuOld}):Play()
					ToggleMenu.AutomaticSize = Enum.AutomaticSize.None
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
					Callback = MiniToggle.Callback or function() end
				}
				if not ConfigTable.ToggleButton.MiniToggle[MiniToggle.Name] then
					ConfigTable.ToggleButton.MiniToggle[MiniToggle.Name] = {
						Enabled = MiniToggle.Enabled,
					}
				else
					MiniToggle.Enabled = ConfigTable.ToggleButton.MiniToggle[MiniToggle.Name].Enabled
				end

				local MiniToggleHolder = Instance.new("Frame")
				MiniToggleHolder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				MiniToggleHolder.BackgroundTransparency = 1.000
				MiniToggleHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleHolder.BorderSizePixel = 0
				MiniToggleHolder.Size = UDim2.new(1, 0, 0, 25)
				if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
					if ToggleMenu and ScrollingMenu then
						MiniToggleHolder.Parent = ScrollingMenu
					end
				elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
					if ToggleMenu then
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
						ConfigTable.ToggleButton.MiniToggle[MiniToggle.Name].Enabled = MiniToggle.Enabled
						TweenService:Create(MiniToggleHolderTrigger, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
					else
						ConfigTable.ToggleButton.MiniToggle[MiniToggle.Name].Enabled = MiniToggle.Enabled
						TweenService:Create(MiniToggleHolderTrigger, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
					end
				end

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
				if not ConfigTable.ToggleButton.Sliders[Slider.Name] then
					ConfigTable.ToggleButton.Sliders[Slider.Name] = {
						Default = Slider.Default
					}
				else
					Slider.Default = ConfigTable.ToggleButton.Sliders[Slider.Name].Default
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
					if ToggleMenu then
						SliderHolder.Parent = ScrollingMenu
					end
				elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
					if ToggleMenu then
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
					ConfigTable.ToggleButton.Sliders[Slider.Name].Default = SliderValue
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
				else
					Slider.Default = 0
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
				if not ConfigTable.ToggleButton.Dropdown[Dropdown.Name] then
					ConfigTable.ToggleButton.Dropdown[Dropdown.Name] = {
						Default = Dropdown.Default
					}
				else
					Dropdown.Default = ConfigTable.ToggleButton.Dropdown[Dropdown.Name].Default
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
					if ToggleMenu then
						DropdownHolder.Parent = ScrollingMenu
					end
				elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
					if ToggleMenu then
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
					ConfigTable.ToggleButton.Dropdown[Dropdown.Name].Default = Selected
				end)
				
				if Dropdown.Default then
					DropdownSelected.Text = Dropdown.Default
					Dropdown.Callback(Dropdown.Default)
				else
					DropdownSelected.Text = Dropdown.List[1]
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
