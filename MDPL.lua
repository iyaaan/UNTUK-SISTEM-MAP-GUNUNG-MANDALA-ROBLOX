local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

local zeroMDPL_Y = 204
local maxAltitude = 2250

-- GUI Container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MDPLGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- === FRAME UTAMA ===
local mdplFrame = Instance.new("Frame")
mdplFrame.Name = "MDPLFrame"
mdplFrame.Size = UDim2.new(0, 180, 0, 40)
mdplFrame.Position = UDim2.new(0.11, 0, 0.85, 0)
mdplFrame.BackgroundTransparency = 1
mdplFrame.BorderSizePixel = 0
mdplFrame.Parent = screenGui

-- === TEKS MDPL ===
local mdplText = Instance.new("TextLabel")
mdplText.Name = "MDPLText"
mdplText.Size = UDim2.new(0, 120, 0, 24)
mdplText.Position = UDim2.new(0, 0, 0, 0)
mdplText.BackgroundTransparency = 1
mdplText.TextScaled = true
mdplText.Font = Enum.Font.GothamSemibold
mdplText.TextStrokeTransparency = 0.3
mdplText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0) -- bayangan hitam
mdplText.TextXAlignment = Enum.TextXAlignment.Left
mdplText.TextColor3 = Color3.fromRGB(255, 255, 255) -- ?? teks putih
mdplText.Text = "0 MDPL"
mdplText.Parent = mdplFrame

-- Hapus atau matikan gradient agar teks tetap putih
-- (jika ingin tetap ada efek, bisa gunakan gradient putih ke putih)

-- === INDIKATOR NAIK/TURUN ===
local indicator = Instance.new("TextLabel")
indicator.Name = "Indicator"
indicator.Size = UDim2.new(0, 26, 0, 26)
indicator.Position = UDim2.new(1, -28, 0, 0)
indicator.BackgroundTransparency = 1
indicator.TextScaled = true
indicator.Font = Enum.Font.GothamBold
indicator.TextStrokeTransparency = 0.3
indicator.TextStrokeColor3 = Color3.fromRGB(0, 0, 0) -- bayangan hitam
indicator.TextColor3 = Color3.fromRGB(255, 255, 255) -- ?? putih
indicator.Text = "?"
indicator.Parent = mdplFrame

-- === BAR INDIKATOR ===
local altitudeBar = Instance.new("Frame")
altitudeBar.Name = "AltitudeBar"
altitudeBar.Size = UDim2.new(0, 5, 0, 80)
altitudeBar.Position = UDim2.new(1, 5, 0, -20)
altitudeBar.BackgroundTransparency = 1
altitudeBar.BorderSizePixel = 0
altitudeBar.Parent = mdplFrame

local fillBar = Instance.new("Frame")
fillBar.Name = "FillBar"
fillBar.Size = UDim2.new(1, 0, 0, 0)
fillBar.Position = UDim2.new(0, 0, 1, 0)
fillBar.BorderSizePixel = 0
fillBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- ?? putih
fillBar.Parent = altitudeBar

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = fillBar

-- Tidak perlu gradient, karena kita ingin putih solid

-- === UPDATE ALTITUDE ===
local function getHRP()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart")
end

local hrp = getHRP()
local lastAltitude = 0

runService.RenderStepped:Connect(function()
	if hrp then
		local altitude = hrp.Position.Y - zeroMDPL_Y
		if altitude < 0 then altitude = 0 end
		if altitude > maxAltitude then altitude = maxAltitude end

		-- Update teks MDPL
		mdplText.Text = math.floor(altitude) .. " MDPL"

		-- Update bar
		local fillPercent = altitude / maxAltitude
		fillBar.Size = UDim2.new(1, 0, fillPercent, 0)
		fillBar.Position = UDim2.new(0, 0, 1 - fillPercent, 0)

		-- Indikator naik/turun putih
		if altitude > lastAltitude + 1 then
			indicator.Text = "?"
			indicator.TextColor3 = Color3.fromRGB(255, 255, 255)
		elseif altitude < lastAltitude - 1 then
			indicator.Text = "?"
			indicator.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			indicator.Text = ""
		end

		lastAltitude = altitude
	end
end)

player.CharacterAdded:Connect(function()
	hrp = getHRP()
end)
