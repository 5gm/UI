# Tzar UI Library

<div align="center">

![Tzar UI](https://img.shields.io/badge/Tzar-UI%20Library-green?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-1.0.0-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-Proprietary-red?style=for-the-badge)

**Modern UI library for Roblox with config system and auto-save**

[Documentation](./docs/README.md) • [Examples](./docs/exampleusage.luau)

</div>

---

## ✨ Features

- 🎨 **Modern Design** — Fluent-style interface
- 💾 **Config System** — AutoSave, AutoLoad, profiles
- 🏷️ **Flags** — Global element access via `Tzar.Flags`
- 🔍 **Command Menu** — Quick element search (Ctrl+K)
- 📦 **Icons** — Lucide, Geist, Craft and more
- 📱 **Mini-bar** — Collapse to compact panel
- 🔔 **Notifications** — Built-in notification system

---

## 🚀 Quick Start

```lua
local Tzar = require(path.to.Tzar)

-- Create window
local Window = Tzar.new({
    Title = "My Script",
    MinimizeKey = Enum.KeyCode.RightControl,
})

-- Tab with icon
local MainTab = Window:AddTab({
    Name = "Main",
    Icon = "home",
})

-- Section
local Section = MainTab:AddSection({ Name = "Features" })

-- Toggle with auto-save
Section:AddToggle({
    Title = "Auto Farm",
    Flag = "AutoFarm",
    Default = false,
    Callback = function(state)
        print("AutoFarm:", state)
    end,
})

-- Access value from anywhere
print(Tzar.Flags["AutoFarm"]:GetValue())
```

---

## 📦 Components

| Component       | Description                         |
| --------------- | ----------------------------------- |
| **Toggle**      | Switch with description             |
| **Slider**      | Slider with min/max/step            |
| **Dropdown**    | Dropdown list (single/multi select) |
| **Keybind**     | Key binding input                   |
| **TextBox**     | Text input field                    |
| **ColorPicker** | HSV color picker                    |
| **Button**      | Button with style variants          |
| **ButtonGroup** | Horizontal button group             |
| **Paragraph**   | Text block                          |

---

## ⚙️ Config System

```lua
-- All elements with Flag are automatically saved
Section:AddSlider({
    Title = "Speed",
    Flag = "WalkSpeed",  -- ← Unique ID
    Min = 16,
    Max = 100,
    Default = 16,
})

-- Global access
Tzar.Flags["WalkSpeed"]:GetValue()
Tzar.Flags["WalkSpeed"]:SetValue(50)

-- Settings tab is created automatically with:
-- • AutoSave / AutoLoad toggles
-- • Profile selection
-- • Save / Load / Delete buttons
```

---

## 🎨 Icons

```lua
Icon = "home"           -- Lucide (default)
Icon = "geist:eye"      -- Geist
Icon = "lucide:star"    -- Explicit prefix
```

Supported sets: `lucide`, `geist`, `craft`, `solar`, `sf`

---

## 📖 Documentation

Full documentation available at [`docs/README.md`](./docs/README.md)

---

## 📄 License

Copyright © 2025 [tzar.cc](https://tzar.cc)

Proprietary License:

- ✅ Usage allowed
- ✅ Attribution required
- ❌ Modification prohibited
- ❌ Redistribution prohibited

See [LICENSE](./LICENSE) for details
