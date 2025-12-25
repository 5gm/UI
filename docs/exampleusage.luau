--[[
    Tzar UI Library - Example Usage
    This script demonstrates the features of the Tzar UI Library.
]]

local Tzar = require("./src")

-- 1. Create a Window
local Window = Tzar.new({
	Title = "Tzar UI Example",
	Size = UDim2.fromOffset(550, 350),
	Resizable = true,
	Draggable = true,
	MinimizeKey = Enum.KeyCode.RightControl,
})

-- 2. Create Tabs
local MainTab = Window:AddTab({
	Name = "Main",
	Icon = "home", -- lucide-home
})

local VisualsTab = Window:AddTab({
	Name = "Visuals",
	Icon = "geist:eye", -- geist-eye
})

-- 3. Add Components to Main Tab

-- Section
local MainSection = MainTab:AddSection({
	Name = "General Interaction",
	Collapsed = false,
})

-- Paragraph
MainSection:AddParagraph({
	Title = "Welcome",
	Description = "This example demonstrates Tzar UI's Config System directly.",
})

-- Toggle with Flag
MainSection:AddToggle({
	Title = "Auto Farm",
	Flag = "AutoFarm", -- Access via Tzar.Flags["AutoFarm"]
	Description = "Enables automatic farming functionality.",
	Default = false,
	Callback = function(state)
		print("AutoFarm is now:", state)
	end,
})

-- Slider with Flag
MainSection:AddSlider({
	Title = "WalkSpeed",
	Flag = "WalkSpeed",
	Min = 16,
	Max = 100,
	Default = 16,
	Increment = 1,
	Suffix = " studs/s",
	Callback = function(value)
		-- Example: Directly update character
		-- pcall(function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value end)
		print("WalkSpeed:", value)
	end,
})

-- Dropdown with Flag
MainSection:AddDropdown({
	Title = "Select Team",
	Flag = "TeamSelector",
	Options = { "Red", "Blue", "Green", "Yellow" },
	Default = "Red",
	Multi = false,
	Callback = function(selection)
		print("Selected Team:", selection)
	end,
})

-- 4. Using Flags Globally
-- Buttons allow us to trigger actions that might need flag values
MainSection:AddButton({
	Name = "Print Config Values",
	Variant = "Primary",
	Callback = function()
		-- We can access the values directly from the Tzar.Flags table!
		local farm = Tzar.Flags["AutoFarm"]:GetValue()
		local speed = Tzar.Flags["WalkSpeed"]:GetValue()

		Window:Notify({
			Title = "Current Config",
			Message = string.format("AutoFarm: %s | Speed: %d", tostring(farm), speed),
			Icon = "info",
		})
	end,
})

-- 5. Visuals Tab Components
local ColorsSection = VisualsTab:AddSection({ Name = "Theme" })

ColorsSection:AddColorPicker({
	Title = "ESP Color",
	Flag = "ESPColor",
	Default = Color3.fromRGB(0, 255, 128),
	Callback = function(color)
		print("ESP Color:", color)
	end,
})

-- 6. Settings Tab is automatically created!

-- 5. Select the first tab
Window:SelectTab(1)

-- 6. Notify startup
Window:Notify({
	Title = "Tzar Loaded",
	Message = "The interface has been successfully loaded.",
	Duration = 5,
})

return Window
