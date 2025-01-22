local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local Library = {}
if not shared.RektSky then
	shared.RektSky = {
		Visual = {
			Hud = true,
			GuiBlur = true,
			Arraylist = true,
			Watermark = true
		}
	}
end

local getasset = getcustomasset
local clonerf = cloneref
local function MakeDraggable(object)
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
			MainFrame.CanvasSize = UDim2.new(1.8, 0, 0, 0)
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
	
	local BlurGui = Lighting:FindFirstChildWhichIsA("BlurEffect") or Instance.new("BlurEffect")
	BlurGui.Size = 24
	BlurGui.Enabled = false
	BlurGui.Parent = Lighting
	
	local KeybindFrame = Instance.new("Frame")
	KeybindFrame.Parent = ScreenGui
	KeybindFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	KeybindFrame.BackgroundTransparency = 1.000
	KeybindFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	KeybindFrame.Size = UDim2.new(1, 0, 1, 0)
	
	local UIPadding = Instance.new("UIPadding")
	UIPadding.Parent = MainFrame
	UIPadding.PaddingLeft = UDim.new(0, 8)
	UIPadding.PaddingTop = UDim.new(0, 22)
	
	spawn(function()
		local OldX = 0
		for _, v in ipairs(MainFrame:GetChildren()) do
			if v:IsA("GuiObject") then
				v.Position = UDim2.new(0, OldX, 0, 0)
				OldX = OldX + v.Size.X.Offset + 18
			end
		end
	end)
	
	UserInputService.InputBegan:Connect(function(Input, isTyping)
		if Input.KeyCode == Enum.KeyCode.RightShift and not isTyping then
			MainFrame.Visible = not MainFrame.Visible
			if shared.RektSky.Visual.GuiBlur then
				BlurGui.Enabled = MainFrame.Visible
			end
		end
	end)
	
	function Main:CreateTab(name, icon, color)
		local Tabs = {}
		
		local TabHolder = Instance.new("TextButton")
		TabHolder.Parent = MainFrame
		TabHolder.BackgroundColor3 = Color3.fromRGB(41, 40, 58)
		TabHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabHolder.BorderSizePixel = 0
		TabHolder.AutoButtonColor = false
		TabHolder.Text = ""
		TabHolder.Size = UDim2.new(0, 175, 0, 35)
		if not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
			MakeDraggable(TabHolder)
		end
		
		local TabIcon = Instance.new("ImageLabel")
		TabIcon.Parent = TabHolder
		TabIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		TabIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabIcon.BackgroundTransparency = 1.000
		TabIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabIcon.BorderSizePixel = 0
		TabIcon.Position = UDim2.new(0.899999976, 0, 0.5, 0)
		TabIcon.Size = UDim2.new(0, 20, 0, 20)
		TabIcon.Image = "http://www.roblox.com/asset/?id=" .. icon
		TabIcon.ImageColor3 = color
		
		local TabName = Instance.new("TextLabel")
		TabName.Parent = TabHolder
		TabName.AnchorPoint = Vector2.new(0.5, 0.5)
		TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabName.BackgroundTransparency = 1.000
		TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabName.BorderSizePixel = 0
		TabName.Position = UDim2.new(0.45, 0, 0.5, 0)
		TabName.Size = UDim2.new(0, 145, 1, 0)
		TabName.Font = Enum.Font.Nunito
		TabName.RichText = true
		TabName.Text = "<b>" .. name .. "</b>"
		TabName.TextColor3 = Color3.fromRGB(255, 65, 65)
		TabName.TextSize = 20.000
		TabName.TextWrapped = true
		TabName.TextXAlignment = Enum.TextXAlignment.Left
		
		local TogglesList = Instance.new("Frame")
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
		
		if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
			TabHolder.TouchLongPress:Connect(function()
				TogglesList.Visible = not TogglesList.Visible
			end)
		elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
			TabHolder.MouseButton2Click:Connect(function()
				TogglesList.Visible = not TogglesList.Visible
			end)
		end
		
		function Tabs:CreateToggle(ToggleButton)
			ToggleButton = {
				Name = ToggleButton.Name,
				Suffix = ToggleButton.Suffix or "",
				Hidden = ToggleButton.Hidden or false,
				Enabled = ToggleButton.Enabled or false,
				Keybind = ToggleButton.Keybind or "Euro",
				Description = ToggleButton.Description or "",
				Callback = ToggleButton.Callback or function() end
			}
			
			local ToggleHolder = Instance.new("TextButton")
			ToggleHolder.Parent = TogglesList
			ToggleHolder.BackgroundColor3 = Color3.fromRGB(47, 52, 47)
			ToggleHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleHolder.BorderSizePixel = 0
			ToggleHolder.Size = UDim2.new(1, 0, 0, 35)
			ToggleHolder.AutoButtonColor = false
			ToggleHolder.Font = Enum.Font.SourceSans
			ToggleHolder.Text = ""
			ToggleHolder.TextColor3 = Color3.fromRGB(0, 0, 0)
			ToggleHolder.TextSize = 14.000
			
			local ToggleName = Instance.new("TextLabel")
			ToggleName.Parent = ToggleHolder
			ToggleName.AnchorPoint = Vector2.new(0.5, 0.5)
			ToggleName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleName.BackgroundTransparency = 1.000
			ToggleName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleName.BorderSizePixel = 0
			ToggleName.Position = UDim2.new(0.45, 0, 0.5, 0)
			ToggleName.Size = UDim2.new(0, 145, 1, 0)
			ToggleName.Font = Enum.Font.Nunito
			ToggleName.Text = ToggleButton.Name
			ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
			ToggleName.TextSize = 18.000
			ToggleName.TextWrapped = true
			ToggleName.TextXAlignment = Enum.TextXAlignment.Left
			
			local IsOpened = false
			local ToggleInfo = Instance.new("TextLabel")
			ToggleInfo.Parent = MainFrame
			ToggleInfo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			ToggleInfo.BackgroundTransparency = 0.3
			ToggleInfo.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleInfo.BorderSizePixel = 0
			ToggleInfo.AutomaticSize = Enum.AutomaticSize.XY
			ToggleInfo.Font = Enum.Font.Nunito
			ToggleInfo.Text = ToggleButton.Description
			ToggleInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
			ToggleInfo.TextSize = 18.000
			ToggleInfo.Visible = false
			
			local function ToggleClicked()
				if ToggleButton.Enabled then
					if IsOpened then
						ToggleHolder.BackgroundColor3 = Color3.fromRGB(29, 32, 29)
						ToggleName.TextColor3 = color
					else
						ToggleHolder.BackgroundColor3 = color
						ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
					end
				else
					if IsOpened then
						ToggleHolder.BackgroundColor3 = Color3.fromRGB(29, 32, 29)
						ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
					else
						ToggleHolder.BackgroundColor3 = Color3.fromRGB(47, 52, 47)
						ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
					end
				end
			end
			
			local MouseLoop = nil
			if not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
				ToggleHolder.MouseEnter:Connect(function()
					if not ToggleInfo.Visible then
						ToggleInfo.Visible = true
						if not MouseLoop then
							MouseLoop = UserInputService.InputChanged:Connect(function(Input)
								if Input.UserInputType == Enum.UserInputType.MouseMovement then
									ToggleInfo.Position = UDim2.new(0, Input.Position.X + 10, 0, Input.Position.Y)
								end
							end)
						else
							MouseLoop:Disconnect()
							MouseLoop = nil
						end
					end
				end)

				ToggleHolder.MouseLeave:Connect(function()
					if ToggleInfo.Visible then
						ToggleInfo.Visible = false
						if MouseLoop then
							MouseLoop:Disconnect()
							MouseLoop = nil
						end
					end
				end)
			end
			
			local ToggleMenu = Instance.new("Frame")
			ToggleMenu.Parent = TogglesList
			ToggleMenu.BackgroundColor3 = Color3.fromRGB(41, 40, 58)
			ToggleMenu.BackgroundTransparency = 0.080
			ToggleMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleMenu.BorderSizePixel = 0
			ToggleMenu.Position = UDim2.new(0, 0, 25, 0)
			ToggleMenu.Size = UDim2.new(1, 0, 0, 160)
			ToggleMenu.Visible = false
			
			local UIListLayout_2 = Instance.new("UIListLayout")
			UIListLayout_2.Parent = ToggleMenu
			UIListLayout_2.ItemLineAlignment = Enum.ItemLineAlignment.Center
			UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

			if ToggleButton.Enabled then
				ToggleButton.Enabled = true
				ToggleClicked()

				if ToggleButton.Callback then
					ToggleButton.Callback(ToggleButton.Enabled)
				end
			end

			ToggleHolder.MouseButton1Click:Connect(function()
				ToggleButton.Enabled = not ToggleButton.Enabled
				ToggleClicked()

				if ToggleButton.Callback then
					ToggleButton.Callback(ToggleButton.Enabled)
				end
			end)
			
			if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
				ToggleHolder.TouchLongPress:Connect(function()
					IsOpened = not IsOpened
					if IsOpened then
						ToggleMenu.Visible = true
						if ToggleHolder.BackgroundColor3 ~= Color3.fromRGB(29, 32, 29) then
							if ToggleButton.Enabled then
								ToggleHolder.BackgroundColor3 = Color3.fromRGB(29, 32, 29)
								ToggleName.TextColor3 = color
							else
								ToggleHolder.BackgroundColor3 = Color3.fromRGB(29, 32, 29)
								ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
							end
						end
					else
						ToggleMenu.Visible = false
						if ToggleHolder.BackgroundColor3 == Color3.fromRGB(29, 32, 29) and ToggleMenu.Visible ~= true then
							if ToggleButton.Enabled then
								ToggleHolder.BackgroundColor3 = color
								ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
							else
								ToggleHolder.BackgroundColor3 = Color3.fromRGB(47, 52, 47)
								ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
							end
						end
					end
				end)
			elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
				ToggleHolder.MouseButton2Click:Connect(function()
					IsOpened = not IsOpened
					if IsOpened then
						ToggleMenu.Visible = true
						if ToggleHolder.BackgroundColor3 ~= Color3.fromRGB(29, 32, 29) then
							if ToggleButton.Enabled then
								ToggleHolder.BackgroundColor3 = Color3.fromRGB(29, 32, 29)
								ToggleName.TextColor3 = color
							else
								ToggleHolder.BackgroundColor3 = Color3.fromRGB(29, 32, 29)
								ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
							end
						end
					else
						ToggleMenu.Visible = false
						if ToggleHolder.BackgroundColor3 == Color3.fromRGB(29, 32, 29) and ToggleMenu.Visible ~= true then
							if ToggleButton.Enabled then
								ToggleHolder.BackgroundColor3 = color
								ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
							else
								ToggleHolder.BackgroundColor3 = Color3.fromRGB(47, 52, 47)
								ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
							end
						end
					end
				end)
			end
			
			local IsHidden = ToggleButton.Hidden
			local Hidden = Instance.new("Frame")
			Hidden.Parent = ToggleMenu
			Hidden.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Hidden.BackgroundTransparency = 1.000
			Hidden.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Hidden.BorderSizePixel = 0
			Hidden.LayoutOrder = 99
			Hidden.Size = UDim2.new(1, 0, 0, 30)
			
			local HiddenName = Instance.new("TextLabel")
			HiddenName.Parent = Hidden
			HiddenName.AnchorPoint = Vector2.new(0.5, 0.5)
			HiddenName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			HiddenName.BackgroundTransparency = 1.000
			HiddenName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			HiddenName.BorderSizePixel = 0
			HiddenName.Position = UDim2.new(0.46, 0, 0.5, 0)
			HiddenName.Size = UDim2.new(0, 145, 1, 0)
			HiddenName.Font = Enum.Font.Nunito
			HiddenName.Text = "Hidden"
			HiddenName.TextColor3 = Color3.fromRGB(255, 255, 255)
			HiddenName.TextSize = 17.000
			HiddenName.TextWrapped = true
			HiddenName.TextXAlignment = Enum.TextXAlignment.Left
			
			local HiddenClick = Instance.new("TextButton")
			HiddenClick.Parent = Hidden
			HiddenClick.AnchorPoint = Vector2.new(0.5, 0.5)
			HiddenClick.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
			HiddenClick.BorderColor3 = Color3.fromRGB(0, 0, 0)
			HiddenClick.BorderSizePixel = 0
			HiddenClick.Position = UDim2.new(0.899999976, 0, 0.5, 0)
			HiddenClick.Size = UDim2.new(0, 20, 0, 20)
			HiddenClick.AutoButtonColor = false
			HiddenClick.Font = Enum.Font.SourceSans
			HiddenClick.Text = ""
			HiddenClick.TextColor3 = Color3.fromRGB(0, 0, 0)
			HiddenClick.TextSize = 14.000
			
			local HiddenStatus = Instance.new("Frame")
			HiddenStatus.Parent = HiddenClick
			HiddenStatus.AnchorPoint = Vector2.new(0.5, 0.5)
			HiddenStatus.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
			HiddenStatus.BorderColor3 = Color3.fromRGB(0, 0, 0)
			HiddenStatus.BorderSizePixel = 0
			HiddenStatus.Position = UDim2.new(0.5, 0, 0.5, 0)
			HiddenStatus.Size = UDim2.new(0, 14, 0, 14)
			HiddenStatus.Visible = false
			
			local KeybindsValue = nil
			local Listening = false
			local Keybinds = nil
			if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
				if Keybinds == nil then
					local MobileKeybinds, IsKeybind = nil, false
					Keybinds = Instance.new("TextButton")
					Keybinds.Parent = ToggleMenu
					Keybinds.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Keybinds.BackgroundTransparency = 1.000
					Keybinds.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Keybinds.BorderSizePixel = 0
					Keybinds.LayoutOrder = 100
					Keybinds.Size = UDim2.new(1, 0, 0, 30)
					Keybinds.Font = Enum.Font.SourceSans
					Keybinds.Text = ""
					Keybinds.TextColor3 = Color3.fromRGB(0, 0, 0)
					Keybinds.TextSize = 14.000

					KeybindsValue = Instance.new("TextLabel")
					KeybindsValue.Parent = Keybinds
					KeybindsValue.AnchorPoint = Vector2.new(0.5, 0.5)
					KeybindsValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					KeybindsValue.BackgroundTransparency = 1.000
					KeybindsValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
					KeybindsValue.BorderSizePixel = 0
					KeybindsValue.Position = UDim2.new(0.5, 0, 0.5, 0)
					KeybindsValue.Size = UDim2.new(0, 145, 1, 0)
					KeybindsValue.Font = Enum.Font.Nunito
					KeybindsValue.Text = "Show"
					KeybindsValue.TextColor3 = Color3.fromRGB(255, 255, 255)
					KeybindsValue.TextSize = 17.000
					KeybindsValue.TextWrapped = true
					KeybindsValue.TextXAlignment = Enum.TextXAlignment.Center
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
							MobileKeybinds.AnchorPoint = Vector2.new(0.5, 0.5)
							MobileKeybinds.BorderSizePixel = 0
							MobileKeybinds.Position = UDim2.new(0.5, 0, 0.5, 0)
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

							local function MobileClicked()
								if ToggleButton.Enabled then
									if IsOpened then
										ToggleHolder.BackgroundColor3 = Color3.fromRGB(29, 32, 29)
										ToggleName.TextColor3 = color
									else
										ToggleHolder.BackgroundColor3 = color
										ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
									end
								else
									if IsOpened then
										ToggleHolder.BackgroundColor3 = Color3.fromRGB(29, 32, 29)
										ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
									else
										ToggleHolder.BackgroundColor3 = Color3.fromRGB(47, 52, 47)
										ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
									end
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
					Keybinds = Instance.new("TextButton")
					Keybinds.Parent = ToggleMenu
					Keybinds.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Keybinds.BackgroundTransparency = 1.000
					Keybinds.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Keybinds.BorderSizePixel = 0
					Keybinds.LayoutOrder = 100
					Keybinds.Size = UDim2.new(1, 0, 0, 30)
					Keybinds.Font = Enum.Font.SourceSans
					Keybinds.Text = ""
					Keybinds.TextColor3 = Color3.fromRGB(0, 0, 0)
					Keybinds.TextSize = 14.000

					KeybindsValue = Instance.new("TextLabel")
					KeybindsValue.Parent = Keybinds
					KeybindsValue.AnchorPoint = Vector2.new(0.5, 0.5)
					KeybindsValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					KeybindsValue.BackgroundTransparency = 1.000
					KeybindsValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
					KeybindsValue.BorderSizePixel = 0
					KeybindsValue.Position = UDim2.new(0.46, 0, 0.5, 0)
					KeybindsValue.Size = UDim2.new(0, 145, 1, 0)
					KeybindsValue.Font = Enum.Font.Nunito
					KeybindsValue.Text = "Bind NONE"
					KeybindsValue.TextColor3 = Color3.fromRGB(255, 255, 255)
					KeybindsValue.TextSize = 17.000
					KeybindsValue.TextWrapped = true
					KeybindsValue.TextXAlignment = Enum.TextXAlignment.Left

					Keybinds.MouseButton1Click:Connect(function()
						if not Listening then
							Listening = true
							KeybindsValue.Text = "Press any key..."
							UserInputService.InputBegan:Connect(function(Input, IsTyping)
								if not IsTyping and Listening then
									if Input.UserInputType == Enum.UserInputType.Keyboard then
										Listening = false
										KeybindsValue.Text = "Bind " .. Input.KeyCode.Name
										ToggleButton.Keybind = Input.KeyCode.Name
									end
								end
							end)
						end
					end)
				end
			end
			
			if ToggleButton.Keybind then
				if not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
					if ToggleButton.Keybind == "Euro" then
						KeybindsValue.Text = "Bind NONE"
					else
						KeybindsValue.Text = "Bind " .. ToggleButton.Keybind
					end
				end
				UserInputService.InputBegan:Connect(function(Input, isTyping)
					if Input.KeyCode == Enum.KeyCode[ToggleButton.Keybind] and not isTyping then
						ToggleButton.Enabled = not ToggleButton.Enabled
						ToggleClicked()

						if ToggleButton.Callback then
							ToggleButton.Callback(ToggleButton.Enabled)
						end
					end
				end)
			end
			
			spawn(function()
				HiddenClick.MouseButton1Click:Connect(function()
					IsHidden = not IsHidden
					ToggleButton.Hidden = IsHidden
					if IsHidden then
						HiddenStatus.Visible = true
					else
						HiddenStatus.Visible = false
					end
				end)
			end)
			
			function ToggleButton:CreateMiniToggle(MiniToggle)
				MiniToggle = {
					Name = MiniToggle.Name,
					Enabled = MiniToggle.Enabled or false,
					Callback = MiniToggle.Callback or function() end
				}
				
				local MiniToggleMain = Instance.new("Frame")
				MiniToggleMain.Parent = ToggleMenu
				MiniToggleMain.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				MiniToggleMain.BackgroundTransparency = 1.000
				MiniToggleMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleMain.BorderSizePixel = 0
				MiniToggleMain.Size = UDim2.new(1, 0, 0, 30)
				
				local MiniToggleName = Instance.new("TextLabel")
				MiniToggleName.Parent = MiniToggleMain
				MiniToggleName.AnchorPoint = Vector2.new(0.5, 0.5)
				MiniToggleName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleName.BackgroundTransparency = 1.000
				MiniToggleName.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleName.BorderSizePixel = 0
				MiniToggleName.Position = UDim2.new(0.46, 0, 0.5, 0)
				MiniToggleName.Size = UDim2.new(0, 145, 1, 0)
				MiniToggleName.Font = Enum.Font.Nunito
				MiniToggleName.Text = MiniToggle.Name
				MiniToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleName.TextSize = 17.000
				MiniToggleName.TextWrapped = true
				MiniToggleName.TextXAlignment = Enum.TextXAlignment.Left
				
				local MiniToggleClick = Instance.new("TextButton")
				MiniToggleClick.Parent = MiniToggleMain
				MiniToggleClick.AnchorPoint = Vector2.new(0.5, 0.5)
				MiniToggleClick.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
				MiniToggleClick.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleClick.BorderSizePixel = 0
				MiniToggleClick.Position = UDim2.new(0.899999976, 0, 0.5, 0)
				MiniToggleClick.Size = UDim2.new(0, 20, 0, 20)
				MiniToggleClick.AutoButtonColor = false
				MiniToggleClick.Font = Enum.Font.SourceSans
				MiniToggleClick.Text = ""
				MiniToggleClick.TextColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleClick.TextSize = 14.000
				
				local MiniToggleActive = Instance.new("Frame")
				MiniToggleActive.Parent = MiniToggleClick
				MiniToggleActive.AnchorPoint = Vector2.new(0.5, 0.5)
				MiniToggleActive.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
				MiniToggleActive.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleActive.BorderSizePixel = 0
				MiniToggleActive.Position = UDim2.new(0.5, 0, 0.5, 0)
				MiniToggleActive.Size = UDim2.new(0, 14, 0, 14)
				MiniToggleActive.Visible = false
				
				local function MiniToggleClicked()
					if MiniToggle.Enabled then
						MiniToggleActive.Visible = true
					else
						MiniToggleActive.Visible = false
					end
				end
				
				if MiniToggle.Enabled then
					MiniToggle.Enabled = true
					MiniToggleClicked()

					if MiniToggle.Callback then
						MiniToggle.Callback(MiniToggle.Enabled)
					end
				end 

				MiniToggleClick.MouseButton1Click:Connect(function()
					MiniToggle.Enabled = not MiniToggle.Enabled
					MiniToggleClicked()

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
				
				local Value
				local Dragged = false
				local SliderMain = Instance.new("TextButton")
				SliderMain.Parent = ToggleMenu
				SliderMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderMain.BackgroundTransparency = 1.000
				SliderMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderMain.BorderSizePixel = 0
				SliderMain.Size = UDim2.new(0, 165, 0, 24)
				SliderMain.Font = Enum.Font.SourceSans
				SliderMain.Text = ""
				SliderMain.TextColor3 = Color3.fromRGB(0, 0, 0)
				SliderMain.TextSize = 14.000
				
				local SlidersValue = Instance.new("TextLabel")
				SlidersValue.Parent = SliderMain
				SlidersValue.AnchorPoint = Vector2.new(0.5, 0.5)
				SlidersValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SlidersValue.BackgroundTransparency = 1.000
				SlidersValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SlidersValue.BorderSizePixel = 0
				SlidersValue.Position = UDim2.new(0.46, 0, 0.5, 0)
				SlidersValue.Size = UDim2.new(0, 145, 1, 0)
				SlidersValue.ZIndex = 2
				SlidersValue.Font = Enum.Font.Nunito
				SlidersValue.TextColor3 = Color3.fromRGB(255, 255, 255)
				SlidersValue.TextSize = 17.000
				SlidersValue.TextWrapped = true
				SlidersValue.TextXAlignment = Enum.TextXAlignment.Left
				
				local SlidersFront = Instance.new("Frame")
				SlidersFront.Parent = SliderMain
				SlidersFront.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
				SlidersFront.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SlidersFront.BorderSizePixel = 0
				SlidersFront.Size = UDim2.new(0, 100, 1, 0)
				
				local function UpdateValue(input)
					local sliderPos = SliderMain.AbsolutePosition.X
					local sliderWidth = SliderMain.AbsoluteSize.X
					local mouseX = math.clamp(input.Position.X, sliderPos, sliderPos + sliderWidth)
					local percent = (mouseX - sliderPos) / sliderWidth
					Value = math.floor((Slider.Min + (Slider.Max - Slider.Min) * percent) * 10) / 10
					SlidersFront.Size = UDim2.new(percent, 0, 1, 0)
					SlidersValue.Text = string.format("Range: %.1f", Value)
					Slider.Callback(Value)
				end

				SliderMain.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						Dragged = true
					end
				end)

				SliderMain.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						Dragged = false
					end
				end)

				game:GetService("UserInputService").InputChanged:Connect(function(input)
					if Dragged and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						UpdateValue(input)
					end
				end)
				
				if Slider.Default then
					Value = math.clamp(Slider.Default, Slider.Min, Slider.Max)
					SlidersValue.Text = string.format("Range: %.1f", Value)
					local percent = (Value - Slider.Min) / (Slider.Max - Slider.Min)
					SlidersFront.Size = UDim2.fromScale(percent, 1)
					Slider.Callback(Value)
				else
					Value = math.clamp(0, Slider.Min, Slider.Max)
					SlidersValue.Text = string.format("Range: %.1f", Value)
					local percent = (Value - Slider.Min) / (Slider.Max - Slider.Min)
					SlidersFront.Size = UDim2.fromScale(percent, 1)
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
				
				local DropdownMain = Instance.new("TextButton")
				DropdownMain.Parent = ToggleMenu
				DropdownMain.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				DropdownMain.BackgroundTransparency = 1.000
				DropdownMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownMain.BorderSizePixel = 0
				DropdownMain.Size = UDim2.new(1, 0, 0, 30)
				DropdownMain.AutoButtonColor = false
				DropdownMain.Font = Enum.Font.SourceSans
				DropdownMain.Text = ""
				DropdownMain.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownMain.TextSize = 16.000
				DropdownMain.TextWrapped = true
				DropdownMain.TextXAlignment = Enum.TextXAlignment.Left
				
				local DropdownResult = Instance.new("TextLabel")
				DropdownResult.Parent = DropdownMain
				DropdownResult.AnchorPoint = Vector2.new(0.5, 0.5)
				DropdownResult.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownResult.BackgroundTransparency = 1.000
				DropdownResult.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownResult.BorderSizePixel = 0
				DropdownResult.Position = UDim2.new(0.55, 0, 0.5, 0)
				DropdownResult.Size = UDim2.new(0, 175, 1, 0)
				DropdownResult.Font = Enum.Font.Nunito
				DropdownResult.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownResult.TextSize = 17.000
				DropdownResult.TextWrapped = true
				DropdownResult.TextXAlignment = Enum.TextXAlignment.Left
				

				local CurrentDropdown = 1
				DropdownMain.MouseButton1Click:Connect(function()
					DropdownResult.Text = "Mode: " .. Dropdown.List[CurrentDropdown]
					Dropdown.Callback(Dropdown.List[CurrentDropdown])
					CurrentDropdown = CurrentDropdown % #Dropdown.List + 1
				end)

				if Dropdown.Default then
					DropdownResult.Text = "Mode: " .. Dropdown.Default or "None"
					Dropdown.Callback(Dropdown.Default)
				else
					DropdownResult.Text = "Mode: " .. Dropdown.List[1] or "None"
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
