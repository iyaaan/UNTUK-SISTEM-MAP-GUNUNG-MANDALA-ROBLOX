-- ? Elegant Run Toggle ? (Tengah Vertikal + Dekat Kiri + Berdenyut)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ?? GUI utama
local gui = Instance.new("ScreenGui")
gui.Name = "RunToggleUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

-- ?? Tombol toggle di tengah vertikal, dekat kiri
local button = Instance.new("TextButton")
button.Name = "RunButton"
button.Size = UDim2.new(0, 60, 0, 60)
button.Position = UDim2.new(0, 30, 0.5, 0) -- 0.5 untuk tengah vertikal, 30 px dari kiri
button.AnchorPoint = Vector2.new(0, 0.5) -- pivot di tengah vertikal
button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
button.BackgroundTransparency = 0.12
button.Text = "?"
button.TextColor3 = Color3.fromRGB(255, 215, 120)
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.AutoButtonColor = false
button.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = button

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.4
stroke.Color = Color3.fromRGB(255, 220, 120)
stroke.Transparency = 0.4
stroke.Parent = button

-- ?? Hover effect lembut + melayang
button.MouseEnter:Connect(function()
	TweenService:Create(button, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 64, 0, 64),
		Position = UDim2.new(0, 25, 0.5, 0),
		BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	}):Play()
	TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0.1}):Play()
end)
button.MouseLeave:Connect(function()
	TweenService:Create(button, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 60, 0, 60),
		Position = UDim2.new(0, 30, 0.5, 0),
		BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	}):Play()
	TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0.4}):Play()
end)

-- ?? Efek berdenyut halus saat idle
spawn(function()
	while true do
		if not button:IsDescendantOf(game) then break end
		TweenService:Create(button, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			Size = UDim2.new(0, 62, 0, 62)
		}):Play()
		wait(1.2)
	end
end)

-- ?? Frame status teks atas
local statusFrame = Instance.new("Frame")
statusFrame.Name = "StatusFrame"
statusFrame.Size = UDim2.new(0, 200, 0, 40)
statusFrame.Position = UDim2.new(0.5, 0, 0.07, 0)
statusFrame.AnchorPoint = Vector2.new(0.5, 0)
statusFrame.BackgroundTransparency = 1
statusFrame.Visible = false
statusFrame.Parent = gui

local bgGradient = Instance.new("UIGradient")
bgGradient.Rotation = 0
bgGradient.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.2, 0),
	NumberSequenceKeypoint.new(0.8, 0),
	NumberSequenceKeypoint.new(1, 1)
})
bgGradient.Parent = statusFrame

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = statusFrame

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = ""
label.TextScaled = true
label.Font = Enum.Font.GothamSemibold
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextTransparency = 1
label.Parent = statusFrame

-- ?? Variabel utama
local isRunning = false
local normalSpeed = 16
local runSpeed = 100

-- ?? Fungsi tampil status elegan
local function showStatus(text, color1, color2)
	statusFrame.Visible = true
	label.Text = text
	statusFrame.BackgroundTransparency = 0
	bgGradient.Color = ColorSequence.new(color1, color2)

	TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
	TweenService:Create(statusFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()

	task.wait(1.2)
	TweenService:Create(label, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
	TweenService:Create(statusFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
	task.wait(0.4)
	statusFrame.Visible = false
end

-- ??? Aura putih tipis saat ON
local function addAura(char)
	if char:FindFirstChild("RunAura") then return end
	local aura = Instance.new("ParticleEmitter")
	aura.Name = "RunAura"
	aura.Texture = "rbxassetid://6518818791"
	aura.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
	aura.LightEmission = 0.9
	aura.Lifetime = NumberRange.new(0.3)
	aura.Rate = 10
	aura.Speed = NumberRange.new(0)
	aura.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.25),
		NumberSequenceKeypoint.new(1, 0.05)
	})
	aura.Parent = char:WaitForChild("HumanoidRootPart")
end

local function removeAura(char)
	local aura = char:FindFirstChild("RunAura")
	if aura then
		TweenService:Create(aura, TweenInfo.new(0.3), {Transparency = NumberSequence.new(1)}):Play()
		task.wait(0.3)
		aura:Destroy()
	end
end

-- ?? Suara lembut
local function playSoftSound(id, volume)
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://"..id
	s.Volume = volume
	s.PlayOnRemove = true
	s.Parent = workspace
	s:Destroy()
end

-- ??? Klik tombol toggle
button.MouseButton1Click:Connect(function()
	isRunning = not isRunning
	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:FindFirstChildOfClass("Humanoid")

	if isRunning then
		humanoid.WalkSpeed = runSpeed
		addAura(char)
		playSoftSound("9120871285", 0.6)
		TweenService:Create(button, TweenInfo.new(0.3), {
			BackgroundColor3 = Color3.fromRGB(40, 160, 70),
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(120, 255, 140)}):Play()
		showStatus("LARI: ON", Color3.fromRGB(80,255,110), Color3.fromRGB(40,160,70))
	else
		humanoid.WalkSpeed = normalSpeed
		removeAura(char)
		playSoftSound("9120871795", 0.5)
		TweenService:Create(button, TweenInfo.new(0.3), {
			BackgroundColor3 = Color3.fromRGB(28, 28, 28),
			TextColor3 = Color3.fromRGB(255, 215, 120)
		}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(255, 220, 120)}):Play()
		showStatus("LARI: OFF", Color3.fromRGB(255,110,110), Color3.fromRGB(150,40,40))
	end
end)

-- ?? Reset setiap respawn
player.CharacterAdded:Connect(function(char)
	isRunning = false
	task.wait(0.3)
	local humanoid = char:WaitForChild("Humanoid")
	humanoid.WalkSpeed = normalSpeed
	removeAura(char)
	TweenService:Create(button, TweenInfo.new(0.3), {
		BackgroundColor3 = Color3.fromRGB(28, 28, 28),
		TextColor3 = Color3.fromRGB(255, 215, 120)
	}):Play()
	TweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(255, 220, 120)}):Play()
end)
