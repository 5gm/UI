# Tzar UI Library

A modern, fluent UI library for Roblox.

## Getting Started

```lua
local Tzar = require(path.to.Tzar)
```

## Window

Create a new window instance.

```lua
local Window = Tzar.new({
    Title = "My Application",
    Size = UDim2.fromOffset(550, 350),
    Resizable = true,
    Draggable = true,
    MinimizeKey = Enum.KeyCode.RightControl, -- Key to toggle UI visibility
})
```

## Tabs

Organize your content into tabs.

```lua
local MainTab = Window:AddTab({
    Name = "Main",
    Icon = "rbxassetid://...", -- Optional ImageId
})
```

## Components

Components are added to **Sections** within Tabs.

### Section

```lua
local Section = MainTab:AddSection({
    Name = "General",
    Collapsed = false, -- Default state
})
```

### Paragraph

Display text information.

```lua
Section:AddParagraph({
    Title = "Header",
    Description = "Some detailed text goes here.",
})
```

### Button

```lua
Section:AddButton({
    Name = "Click Me",
    Variant = "Primary", -- "Primary", "Secondary", "Outline", "Distract"
    Callback = function()
        print("Clicked!")
    end,
})
```

### Button Group

Group buttons horizontally.

```lua
local Group = Section:AddButtonGroup()
Group:AddButton({ Name = "Action 1", Callback = function() end })
Group:AddButton({ Name = "Action 2", Callback = function() end })
```

### Toggle

```lua
Section:AddToggle({
    Title = "Enabled",
    Description = "Optional description",
    Default = false,
    Callback = function(state) -- state is boolean
        print("Toggled:", state)
    end,
})
```

### Slider

```lua
Section:AddSlider({
    Title = "Speed",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Suffix = "%",
    Callback = function(value)
        print("Value:", value)
    end,
})
```

### Dropdown

Supports single and multi-selection.

```lua
Section:AddDropdown({
    Title = "Choose Option",
    Options = { "A", "B", "C" },
    Default = "A", -- Or {"A", "B"} if Multi = true
    Multi = false,
    Callback = function(selection)
        print("Selected:", selection)
    end,
})
```

### Color Picker

```lua
Section:AddColorPicker({
    Title = "Accent Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("Color:", color)
    end,
})
```

### Keybind

```lua
Section:AddKeybind({
    Title = "Menu Key",
    Default = Enum.KeyCode.M,
    Callback = function()
        print("Key pressed")
    end,
})
```

### TextBox

```lua
Section:AddTextBox({
    Title = "Input",
    Placeholder = "Type here...",
    ClearOnFocus = true,
    Callback = function(text)
        print("Input:", text)
    end,
})
```

## Notifications

Send ephemeral notifications to the user.

```lua
Window:Notify({
    Title = "Notification",
    Message = "Operation successful!",
    Duration = 5, -- Seconds
    Action = "Undo", -- Optional action button
    ActionCallback = function()
        print("Undo requested")
    end,
})
```
