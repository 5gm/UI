# Tzar UI Library

A modern, fluent UI library for Roblox with integrated configuration system and
support for multiple icon sets.

## Getting Started

```lua
local Tzar = require(path.to.Tzar)
```

## Window

Create a new window instance. The window includes a built-in "Settings" tab for
configuration management.

```lua
local Window = Tzar.new({
    Title = "My Application",
    Size = UDim2.fromOffset(550, 350),
    Resizable = true,
    Draggable = true,
    MinimizeKey = Enum.KeyCode.RightControl, -- Key to toggle UI visibility
})
```

## Icons

Tzar supports multiple icon sets via the
[Icons](https://github.com/Footagesus/Icons) library. You can use icons by name,
optionally with a set prefix (default: `lucide`).

Supported sets: `lucide` (default), `geist`, `craft`, `solar`, `sf`.

```lua
-- Use default Lucide icon
Window:AddTab({ Name = "Home", Icon = "home" })

-- Use specific icon set
Window:AddTab({ Name = "Clean", Icon = "geist:box" })

-- Use Roblox Asset ID (legacy)
Window:AddTab({ Name = "Custom", Icon = "rbxassetid://..." })
```

## Configuration System

Tzar includes a powerful configuration system with:

- **Global Registry**: Access all elements via `Tzar.Flags`
- **Profiles**: Built-in profile manager in the Settings tab
- **Auto-save**: Configs are saved to the exploit's workspace folder

### Registration using `Flag`

Elements can be registered with a unique ID using the `Flag` option. If not
provided, one is generated from the Tab/Section/Title names.

```lua
Section:AddToggle({
    Title = "Auto Farm",
    Flag = "AutoFarmEnabled", -- Access via Tzar.Flags["AutoFarmEnabled"]
    Callback = function(v) end
})
```

### Accessing Flags

Access element values globally from anywhere in your script:

```lua
-- Get value
local enabled = Tzar.Flags["AutoFarmEnabled"]:GetValue()

-- Set value (updates UI too)
Tzar.Flags["AutoFarmEnabled"]:SetValue(true)

-- Listen for changes
Tzar.Flags["AutoFarmEnabled"].OnToggle:Connect(function(val)
    print("Changed:", val)
end)
```

## Components

Components are added to **Sections** within **Tabs**.

### Tab

```lua
local MainTab = Window:AddTab({
    Name = "Main",
    Icon = "home",
})
```

### Section

```lua
local Section = MainTab:AddSection({
    Name = "General",
    Collapsed = false,
})
```

### Toggle

```lua
Section:AddToggle({
    Title = "Enabled",
    Flag = "Toggle1",
    Description = "Optional description",
    Default = false,
    Callback = function(state) end,
})
```

### Slider

```lua
Section:AddSlider({
    Title = "Speed",
    Flag = "WalkSpeed",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Suffix = "%",
    Callback = function(value) end,
})
```

### Dropdown

Supports single and multi-selection.

```lua
Section:AddDropdown({
    Title = "Choose Option",
    Flag = "Selector",
    Options = { "A", "B", "C" },
    Default = "A", -- Or {"A", "B"} if Multi = true
    Multi = false,
    Callback = function(selection) end,
})
```

### Color Picker

```lua
Section:AddColorPicker({
    Title = "Accent Color",
    Flag = "AccentColor",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color) end,
})
```

### Keybind

```lua
Section:AddKeybind({
    Title = "Menu Key",
    Flag = "MenuBind",
    Default = Enum.KeyCode.M,
    Callback = function() end,
})
```

### TextBox

```lua
Section:AddTextBox({
    Title = "Input",
    Flag = "Box1",
    Placeholder = "Type here...",
    ClearOnFocus = true,
    Callback = function(text) end,
})
```

## Notifications

Send ephemeral notifications to the user.

```lua
Window:Notify({
    Title = "Notification",
    Message = "Operation successful!",
    Duration = 5,
    Icon = "check",
})
```
