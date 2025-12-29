# Tzar UI Library

Modern UI library for Roblox with config system and auto-save.

## Installation

```lua
local Tzar = loadstring(game:HttpGet("URL_TO_TZAR"))()
-- or
local Tzar = require(path.to.Tzar)
```

---

## Quick Start

```lua
local Tzar = require("./src")

-- Create window
local Window = Tzar.new({
    Title = "My Script",
    MinimizeKey = Enum.KeyCode.RightControl,
})

-- Create tab
local MainTab = Window:AddTab({
    Name = "Main",
    Icon = "home",
})

-- Create section
local Section = MainTab:AddSection({ Name = "Features" })

-- Add Toggle with Flag (auto-save)
Section:AddToggle({
    Title = "Auto Farm",
    Flag = "AutoFarm",
    Default = false,
    Callback = function(state)
        print("AutoFarm:", state)
    end,
})

-- Access value via Flags
print(Tzar.Flags["AutoFarm"]:GetValue())
```

---

## Window

```lua
local Window = Tzar.new({
    Title = "Application Title",
    MinimizeKey = Enum.KeyCode.RightControl, -- Minimize key
})
```

### Window Methods

| Method                    | Description           |
| ------------------------- | --------------------- |
| `Window:AddTab(options)`  | Create tab            |
| `Window:SelectTab(index)` | Switch to tab         |
| `Window:Notify(options)`  | Show notification     |
| `Window:Minimize()`       | Minimize to mini-bar  |
| `Window:Restore()`        | Restore from mini-bar |
| `Window:Toggle()`         | Toggle minimize state |
| `Window:Destroy()`        | Close and destroy     |

---

## Tab

```lua
local Tab = Window:AddTab({
    Name = "Tab Name",
    Icon = "home",           -- Icon name (lucide/geist)
    LayoutOrder = 1,         -- Order in list
})
```

### Icons

Supports icons from Lucide and Geist:

```lua
Icon = "home"          -- Lucide: home
Icon = "settings"      -- Lucide: settings
Icon = "geist:eye"     -- Geist: eye
Icon = "lucide:star"   -- Lucide: star (explicit)
```

### Tab Methods

| Method                    | Description         |
| ------------------------- | ------------------- |
| `Tab:AddSection(options)` | Create section      |
| `Tab:AddButtonGroup()`    | Create button group |

---

## Section

```lua
local Section = Tab:AddSection({
    Name = "Section Name",
    Collapsed = false,       -- Collapsed by default
})
```

### Section Methods

Section contains all components:

```lua
Section:AddParagraph(options)
Section:AddButton(options)
Section:AddToggle(options)
Section:AddSlider(options)
Section:AddDropdown(options)
Section:AddKeybind(options)
Section:AddTextBox(options)
Section:AddColorPicker(options)
Section:AddButtonGroup()
```

---

## Components

### Paragraph

```lua
Section:AddParagraph({
    Title = "Title",
    Description = "Description text",
})
```

---

### Button

```lua
Section:AddButton({
    Name = "Click Me",
    Variant = "Primary",     -- Primary, Secondary, Outline, Destroy
    Callback = function()
        print("Clicked!")
    end,
})
```

**Style variants:** `Primary` (green), `Secondary` (gray), `Outline`
(transparent), `Destroy` (red)

---

### ButtonGroup

```lua
local Group = Section:AddButtonGroup()

Group:AddButton({
    Name = "Save",
    Variant = "Primary",
    Callback = function() end,
})

Group:AddButton({
    Name = "Load",
    Callback = function() end,
})
```

---

### Toggle

```lua
local toggle = Section:AddToggle({
    Title = "Enable Feature",
    Description = "Optional description",
    Flag = "FeatureEnabled",    -- ID for Config system
    Default = false,
    Callback = function(state)
        print("State:", state)
    end,
})
```

**Methods:**

- `toggle:GetValue()` → `boolean`
- `toggle:SetValue(bool)`
- `toggle:Toggle()`

---

### Slider

```lua
local slider = Section:AddSlider({
    Title = "Walk Speed",
    Flag = "WalkSpeed",
    Min = 16,
    Max = 100,
    Default = 16,
    Increment = 1,              -- Value step
    Suffix = " studs/s",        -- Suffix after number
    Callback = function(value)
        print("Speed:", value)
    end,
})
```

**Methods:**

- `slider:GetValue()` → `number`
- `slider:SetValue(number)`

---

### Dropdown

```lua
-- Single selection
local dropdown = Section:AddDropdown({
    Title = "Select Team",
    Flag = "SelectedTeam",
    Options = {"Red", "Blue", "Green"},
    Default = "Red",
    Multi = false,
    Callback = function(selected)
        print("Selected:", selected)
    end,
})

-- Multi selection
Section:AddDropdown({
    Title = "Select Items",
    Flag = "SelectedItems",
    Options = {"Item1", "Item2", "Item3"},
    Default = {"Item1", "Item2"},
    Multi = true,
    Callback = function(selected)
        -- selected is a table
        for _, item in ipairs(selected) do
            print(item)
        end
    end,
})
```

**Methods:**

- `dropdown:GetValue()` → `string` or `table` (for Multi)
- `dropdown:SetValue(value)`
- `dropdown:Refresh(options, default)` — update list
- `dropdown:SelectAll()` — select all (Multi)
- `dropdown:DeselectAll()` — deselect all (Multi)

---

### Keybind

```lua
local keybind = Section:AddKeybind({
    Title = "Toggle Key",
    Flag = "ToggleKey",
    Default = Enum.KeyCode.E,
    Callback = function(key)
        print("Key set to:", key.Name)
    end,
})
```

**Methods:**

- `keybind:GetValue()` / `keybind:GetKey()` → `Enum.KeyCode`
- `keybind:SetValue(key)` / `keybind:SetKey(key)`
- `keybind:IsPressed()` → `boolean`

**Controls:**

- Click button — start recording
- Press key — set key
- `Escape` — cancel
- `Backspace` — clear (None)

---

### TextBox

```lua
local textbox = Section:AddTextBox({
    Title = "Player Name",
    Flag = "TargetPlayer",
    Placeholder = "Enter name...",
    Default = "",
    ClearOnFocus = false,
    Callback = function(text)
        print("Input:", text)
    end,
})
```

**Methods:**

- `textbox:GetValue()` → `string`
- `textbox:SetValue(string)`

---

### ColorPicker

```lua
local colorpicker = Section:AddColorPicker({
    Title = "ESP Color",
    Flag = "ESPColor",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("Color:", color)
    end,
})
```

**Methods:**

- `colorpicker:GetValue()` → `Color3`
- `colorpicker:SetValue(Color3)`
- `colorpicker:Toggle()` — open/close picker

---

## Notifications

```lua
Window:Notify({
    Title = "Success",
    Message = "Operation completed!",
    Duration = 5,                    -- Seconds (default 5)
    Action = "Undo",                 -- Optional button
    ActionCallback = function()
        print("Undo clicked")
    end,
})
```

---

## Config System

Tzar automatically creates a **Settings** tab with config management.

### Flags

Any component with a `Flag` parameter is registered in the global registry:

```lua
-- Create with Flag
Section:AddToggle({
    Title = "Feature",
    Flag = "MyFeature",  -- ← Flag ID
    Default = false,
})

-- Access value from anywhere
local value = Tzar.Flags["MyFeature"]:GetValue()

-- Change value
Tzar.Flags["MyFeature"]:SetValue(true)
```

### AutoSave / AutoLoad

| Setting  | Default | Description          |
| -------- | ------- | -------------------- |
| AutoSave | `true`  | Auto-save on change  |
| AutoLoad | `true`  | Auto-load on startup |

Settings available in **Settings → Configuration**.

### Profiles

- **Default** — default profile (cannot be deleted)
- Unlimited custom profiles
- Profile switching instantly applies all values

### File Structure

```
TzarConfigs/
├── Default.json      -- Profile
├── MyProfile.json    -- Custom profile
└── metrics.json      -- Settings (AutoSave, AutoLoad, LastProfile)
```

---

## API Reference

### Tzar

```lua
Tzar.new(options)           -- Create window
Tzar.Flags                  -- Table of all registered elements
Tzar.Components             -- Access to component classes
```

### Common Component Methods

All input components have a unified interface:

| Method                   | Description        |
| ------------------------ | ------------------ |
| `GetValue()`             | Get current value  |
| `SetValue(value)`        | Set value          |
| `SetTitle(string)`       | Change title       |
| `SetDescription(string)` | Change description |
| `SetVisible(bool)`       | Show/hide          |
| `Destroy()`              | Destroy element    |

### Signals

```lua
-- Toggle
toggle.OnToggle:Connect(function(state) end)
toggle.Changed:Connect(function(state) end)  -- Alias

-- Slider, Dropdown, TextBox, ColorPicker, Keybind
element.OnChanged:Connect(function(value) end)
element.Changed:Connect(function(value) end)  -- Alias
```

---

## Full Example Script

```lua
local Tzar = require("./src")

-- Window
local Window = Tzar.new({
    Title = "My Script v1.0",
    MinimizeKey = Enum.KeyCode.RightControl,
})

-- Tabs
local MainTab = Window:AddTab({ Name = "Main", Icon = "home" })
local VisualsTab = Window:AddTab({ Name = "Visuals", Icon = "eye" })
local MiscTab = Window:AddTab({ Name = "Misc", Icon = "settings" })

-- Main Tab
local FarmSection = MainTab:AddSection({ Name = "Farming" })

FarmSection:AddToggle({
    Title = "Auto Farm",
    Flag = "AutoFarm",
    Description = "Automatically farms resources",
    Default = false,
    Callback = function(state)
        -- Auto-farm logic
    end,
})

FarmSection:AddSlider({
    Title = "Farm Speed",
    Flag = "FarmSpeed",
    Min = 1,
    Max = 10,
    Default = 5,
    Callback = function(value)
        -- Change speed
    end,
})

-- Visuals Tab
local ESPSection = VisualsTab:AddSection({ Name = "ESP" })

ESPSection:AddToggle({
    Title = "Player ESP",
    Flag = "PlayerESP",
    Default = false,
})

ESPSection:AddColorPicker({
    Title = "ESP Color",
    Flag = "ESPColor",
    Default = Color3.fromRGB(255, 0, 0),
})

ESPSection:AddDropdown({
    Title = "ESP Type",
    Flag = "ESPType",
    Options = {"Box", "Corner", "Highlight"},
    Default = "Box",
})

-- Misc Tab
local SettingsSection = MiscTab:AddSection({ Name = "Character" })

SettingsSection:AddSlider({
    Title = "Walk Speed",
    Flag = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Suffix = " studs/s",
    Callback = function(value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end)
    end,
})

SettingsSection:AddSlider({
    Title = "Jump Power",
    Flag = "JumpPower",
    Min = 50,
    Max = 200,
    Default = 50,
    Callback = function(value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
        end)
    end,
})

-- Notification on load
Window:Notify({
    Title = "Loaded",
    Message = "Script loaded successfully!",
    Duration = 3,
})

return Window
```

---

## Hotkeys

| Key           | Action                     |
| ------------- | -------------------------- |
| `MinimizeKey` | Minimize/restore UI        |
| `Ctrl+K`      | Open Command Menu (search) |

---

## Compatibility

UI library is compatible with all popular exploits:

- Synapse X
- Script-Ware
- Fluxus
- Solara
- Wave
- And others

File functions (`writefile`, `readfile`, etc.) are automatically detected.
