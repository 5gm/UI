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
	Icon = "rbxassetid://10709752906", -- lucide-home
})

local SettingsTab = Window:AddTab({
	Name = "Settings",
	Icon = "rbxassetid://10734918566", -- lucide-settings
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
	Description = "This is an example usage of the Tzar UI Library. Explore the controls below.",
})

-- Button
MainSection:AddButton({
	Name = "Click Me",
	Variant = "Primary",
	Callback = function()
		Window:Notify({
			Title = "Button Pressed",
			Message = "You clicked the primary button!",
			Action = "Undo",
			ActionCallback = function()
				print("Undo clicked!")
			end,
		})
	end,
})

-- Button Group
local Group = MainSection:AddButtonGroup()
Group:AddButton({
	Name = "Option A",
	Callback = function()
		print("Option A")
	end,
})
Group:AddButton({
	Name = "Option B",
	Callback = function()
		print("Option B")
	end,
})

-- Toggle
MainSection:AddToggle({
	Title = "Enable Feature",
	Description = "Turns on the amazing feature.",
	Default = false,
	Callback = function(state)
		print("Feature is now:", state)
	end,
})

-- Slider
MainSection:AddSlider({
	Title = "WalkSpeed",
	Min = 16,
	Max = 100,
	Default = 16,
	Increment = 1,
	Suffix = " studs/s",
	Callback = function(value)
		print("WalkSpeed set to:", value)
	end,
})

-- Dropdown
MainSection:AddDropdown({
	Title = "Select Team",
	Options = { "Red", "Blue", "Green", "Yellow" },
	Default = "Red",
	Multi = false,
	Callback = function(selection)
		print("Selected Team:", selection)
	end,
})

-- Multi Dropdown
MainSection:AddDropdown({
	Title = "Select Weapons",
	Options = { "Sword", "Bow", "Magic", "Shield" },
	Default = "Sword",
	Multi = true,
	Callback = function(selection)
		print("Selected Weapons:", typeof(selection) == "table" and table.concat(selection, ", ") or selection)
	end,
})

-- Color Picker
MainSection:AddColorPicker({
	Title = "Accent Color",
	Default = Color3.fromRGB(0, 170, 255),
	Callback = function(color)
		print("Color changed to:", color)
	end,
})

-- Keybind (Note: Toggle UI is already handled by MinimizeKey in Window options)
MainSection:AddKeybind({
	Title = "Quick Notify",
	Default = Enum.KeyCode.N,
	Callback = function()
		Window:Notify({
			Title = "Keybind Pressed",
			Message = "You pressed the N key!",
		})
	end,
})

-- TextBox
MainSection:AddTextBox({
	Title = "Player Name",
	Placeholder = "Enter username...",
	ClearOnFocus = true,
	Callback = function(text)
		Window:Notify({
			Title = "Input Received",
			Message = "Hello, " .. text .. "!",
		})
	end,
})

-- 4. Components in Settings Tab
local ConfigSection = SettingsTab:AddSection({
	Name = "Configuration",
})

ConfigSection:AddToggle({
	Title = "Dark Mode",
	Default = true,
	Callback = function(state)
		print("Dark mode:", state)
	end,
})

-- 5. Select the first tab
Window:SelectTab(1)

-- 6. Notify startup
Window:Notify({
	Title = "Tzar Loaded",
	Message = "The interface has been successfully loaded.",
	Duration = 5,
})

return Window
