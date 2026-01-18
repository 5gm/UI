type Connection__DARKLUA_TYPE_a = {
	Disconnect: (self: Connection__DARKLUA_TYPE_a) -> (),
}

type Signal__DARKLUA_TYPE_b<T...> = {
	Connect: (self: Signal__DARKLUA_TYPE_b<T...>, callback: (T...) -> ()) -> Connection__DARKLUA_TYPE_a,
	Once: (self: Signal__DARKLUA_TYPE_b<T...>, callback: (T...) -> ()) -> Connection__DARKLUA_TYPE_a,
	Fire: (self: Signal__DARKLUA_TYPE_b<T...>,T...) -> (),
	Wait: (self: Signal__DARKLUA_TYPE_b<T...>) -> T...,
	Destroy: (self: Signal__DARKLUA_TYPE_b<T...>) -> (),
}

type ThemeColors__DARKLUA_TYPE_c = {
	Background: Color3,
	BackgroundSecondary: Color3,
	BackgroundTertiary: Color3,
	Border: Color3,
	Text: Color3,
	TextSecondary: Color3,
	Primary: Color3,
	Distract: Color3,
	Accent: Color3,
}

type ThemeFonts__DARKLUA_TYPE_d = {
	Regular: Enum.Font,
	Medium: Enum.Font,
	Bold: Enum.Font,
}

type ThemeSizes__DARKLUA_TYPE_e = {
	CornerRadius: number,
	CornerRadiusSmall: number,
	CornerRadiusLarge: number,
	Padding: number,
	PaddingSmall: number,
	PaddingLarge: number,
	FontSize: number,
	FontSizeSmall: number,
	FontSizeLarge: number,
}

type Theme__DARKLUA_TYPE_f = {
	Colors: ThemeColors__DARKLUA_TYPE_c,
	Fonts: ThemeFonts__DARKLUA_TYPE_d,
	Sizes: ThemeSizes__DARKLUA_TYPE_e,
}

type ButtonVariant__DARKLUA_TYPE_g = "Primary" | "Secondary" | "Outline" | "Distract"

type ButtonOptions__DARKLUA_TYPE_h = {
	Title: string,
	Description: string?,
	Variant: ButtonVariant__DARKLUA_TYPE_g?,
	Callback: (() -> ())?,
	LayoutOrder: number?,
}

type ToggleOptions__DARKLUA_TYPE_i = {
	Title: string,
	Description: string?,
	Default: boolean?,
	Callback: ((value: boolean) -> ())?,
	LayoutOrder: number?,
}

type SliderOptions__DARKLUA_TYPE_j = {
	Title: string,
	Description: string?,
	Min: number?,
	Max: number?,
	Default: number?,
	Increment: number?,
	Suffix: string?,
	Callback: ((value: number) -> ())?,
	LayoutOrder: number?,
}

type DropdownOptions__DARKLUA_TYPE_k = {
	Title: string,
	Description: string?,
	Options: { string },
	Default: string?,
	Callback: ((value: string) -> ())?,
	LayoutOrder: number?,
}

type InputOptions__DARKLUA_TYPE_l = {
	Title: string,
	Description: string?,
	Placeholder: string?,
	Default: string?,
	ClearOnFocus: boolean?,
	Callback: ((value: string) -> ())?,
	LayoutOrder: number?,
}

type KeybindOptions__DARKLUA_TYPE_m = {
	Title: string,
	Description: string?,
	Default: Enum.KeyCode?,
	Callback: ((key: Enum.KeyCode) -> ())?,
	LayoutOrder: number?,
}

type LabelOptions__DARKLUA_TYPE_n = {
	Text: string,
	Color: Color3?,
	Size: number?,
	RichText: boolean?,
	LayoutOrder: number?,
}

type ColorpickerOptions__DARKLUA_TYPE_o = {
	Title: string,
	Description: string?,
	Default: Color3?,
	Callback: ((color: Color3) -> ())?,
	LayoutOrder: number?,
}

type SectionOptions__DARKLUA_TYPE_p = {
	Name: string,
	Collapsed: boolean?,
	LayoutOrder: number?,
}

type TabOptions__DARKLUA_TYPE_q = {
	Name: string,
	Icon: string?,
	LayoutOrder: number?,
}

type WindowOptions__DARKLUA_TYPE_r = {
	Title: string?,
	Size: UDim2?,
	Position: UDim2?,
	Draggable: boolean?,
	MinimizeKey: Enum.KeyCode?,
}

type ListLayoutOptions__DARKLUA_TYPE_s = {
	Padding: number?,
	Direction: Enum.FillDirection?,
	HorizontalAlignment: Enum.HorizontalAlignment?,
	VerticalAlignment: Enum.VerticalAlignment?,
	SortOrder: Enum.SortOrder?,
	Wraps: boolean?,
}

type StrokeOptions__DARKLUA_TYPE_t = {
	Color: Color3?,
	Thickness: number?,
	Mode: Enum.ApplyStrokeMode?,
}

type TextOptions__DARKLUA_TYPE_u = {
	Text: string?,
	Size: number?,
	Color: Color3?,
	Font: Enum.Font?,
	XAlignment: Enum.TextXAlignment?,
	YAlignment: Enum.TextYAlignment?,
	RichText: boolean?,
	Wrapped: boolean?,
	AutoSize: Enum.AutomaticSize?,
}
local __TZAR_MODULES={cache={}::any}do do local function __modImpl()
--// Signal Implementation


















local Signal = {}
Signal.__index = Signal

function Signal.new<T...>(): Signal__DARKLUA_TYPE_b<T...>
	local self = setmetatable({}, Signal)
	self._connections = {}
	self._waiting = {}
	return self :: any
end

function Signal:Connect(callback: (...any) -> ()): Connection__DARKLUA_TYPE_a
	local connection = {
		_callback = callback,
		_connected = true,
	}

	function connection:Disconnect()
		self._connected = false
	end

	table.insert(self._connections, connection)
	return connection
end

function Signal:Once(callback: (...any) -> ()): Connection__DARKLUA_TYPE_a
	local connection
	connection = self:Connect(function(...)
		connection:Disconnect()
		callback(...)
	end)
	return connection
end

function Signal:Fire(...)
	-- Resume waiting threads
	for _, thread in self._waiting do
		task.spawn(thread, ...)
	end
	table.clear(self._waiting)

	-- Call connected callbacks
	for i = #self._connections, 1, -1 do
		local connection = self._connections[i]
		if connection._connected then
			task.spawn(connection._callback, ...)
		else
			table.remove(self._connections, i)
		end
	end
end

function Signal:Wait()
	table.insert(self._waiting, coroutine.running())
	return coroutine.yield()
end

function Signal:Destroy()
	table.clear(self._connections)
	table.clear(self._waiting)
end

return Signal
end function __TZAR_MODULES.a():typeof(__modImpl())local v=__TZAR_MODULES.cache.a if not v then v={c=__modImpl()}__TZAR_MODULES.cache.a=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - Config System
    Global registry and profile management
]]


local HttpService = game:GetService("HttpService")
local Signal = __TZAR_MODULES.a()

local Config = {}
Config.Flags = {} -- Global registry (Tzar.Flags)
Config.Profiles = {}
Config.ActiveProfile = "Default"
Config.Folder = "TzarConfigs"
Config.Extension = ".json"
Config.AutoSave = true -- Autosave configs on value change
Config.AutoLoad = true -- Autoload selected config on startup

-- Safe file functions (exploit compatibility)
local writefile = writefile or function() end
local readfile = readfile or function() end
local isfile = isfile or function()
	return false
end
local listfiles = listfiles or function()
	return {}
end
local makefolder = makefolder or function() end
local isfolder = isfolder or function()
	return false
end
local delfile = delfile or function() end

function Config:Init()
	if not isfolder(self.Folder) then
		makefolder(self.Folder)
	end

	-- Load profiles
	self:RefreshProfiles()

	-- Load settings and last active profile from metrics
	if isfile(self.Folder .. "/metrics" .. self.Extension) then
		local success, data = pcall(function()
			return HttpService:JSONDecode(readfile(self.Folder .. "/metrics" .. self.Extension))
		end)
		if success and data then
			-- Load AutoSave/AutoLoad settings
			if data.AutoSave ~= nil then
				self.AutoSave = data.AutoSave
			end
			if data.AutoLoad ~= nil then
				self.AutoLoad = data.AutoLoad
			end

			-- Load last active profile if exists
			if data.LastProfile and isfile(self.Folder .. "/" .. data.LastProfile .. self.Extension) then
				self.ActiveProfile = data.LastProfile
			end
		end
	end

	-- Initial load (only if AutoLoad is enabled)
	if self.AutoLoad then
		self:Load(self.ActiveProfile)
	end
end

function Config:RefreshProfiles()
	self.Profiles = {}
	if not isfolder(self.Folder) then
		return
	end

	local files = listfiles(self.Folder)
	for _, file in ipairs(files) do
		if file:find(self.Extension .. "$") and not file:find("metrics" .. self.Extension) then
			local name = file:match("([^/\\]+)" .. self.Extension .. "$")
			if name then
				table.insert(self.Profiles, name)
			end
		end
	end

	-- Ensure default exists in list
	local hasDefault = false
	for _, p in ipairs(self.Profiles) do
		if p == "Default" then
			hasDefault = true
			break
		end
	end
	if not hasDefault then
		table.insert(self.Profiles, "Default")
	end
end

function Config:CreateProfile(name)
	if not name or name == "" then
		return
	end
	if not table.find(self.Profiles, name) then
		table.insert(self.Profiles, name)
		self:Save(name) -- Save empty or current state
	end
	self:SwitchProfile(name)
end

function Config:SwitchProfile(name)
	self.ActiveProfile = name
	self:Load(name)
	self:SaveMetrics()
end

function Config:DeleteProfile(name)
	if name == "Default" then
		return
	end -- Prevent deleting default

	local path = self.Folder .. "/" .. name .. self.Extension
	if isfile(path) then
		delfile(path)
	end

	local index = table.find(self.Profiles, name)
	if index then
		table.remove(self.Profiles, index)
	end

	if self.ActiveProfile == name then
		self:SwitchProfile("Default")
	end
end

function Config:Save(profileName)
	profileName = profileName or self.ActiveProfile
	local data = {}

	for id, element in pairs(self.Flags) do
		if element.GetValue then
			local success, value = pcall(function()
				return element:GetValue()
			end)
			if success then
				-- Convert Color3 to hex string for saving
				if typeof(value) == "Color3" then
					value = value:ToHex()
				end
				data[id] = value
			end
		end
	end

	local json = HttpService:JSONEncode(data)
	writefile(self.Folder .. "/" .. profileName .. self.Extension, json)
end

function Config:Load(profileName)
	profileName = profileName or self.ActiveProfile
	local path = self.Folder .. "/" .. profileName .. self.Extension

	if not isfile(path) then
		return
	end

	local success, data = pcall(function()
		return HttpService:JSONDecode(readfile(path))
	end)

	if not success then
		return
	end

	for id, value in pairs(data) do
		local element = self.Flags[id]
		if element and element.SetValue then
			-- Convert hex back to Color3 if needed
			if element.Type == "ColorPicker" and type(value) == "string" then
				value = Color3.fromHex(value)
			end
			-- Handle Enum.KeyCode for Keybinds
			if element.Type == "Keybind" and type(value) == "string" then
				local key = Enum.KeyCode[value]
				if key then
					value = key
				end
			elseif element.Type == "Keybind" and type(value) == "number" then
				-- Handle keycode saved as integer number
				local enums = Enum.KeyCode:GetEnumItems()
				for _, enum in ipairs(enums) do
					if enum.Value == value then
						value = enum
						break
					end
				end
			end

			element:SetValue(value)
		end
	end
end

function Config:SaveMetrics()
	local data = {
		LastProfile = self.ActiveProfile,
		AutoSave = self.AutoSave,
		AutoLoad = self.AutoLoad,
	}
	writefile(self.Folder .. "/metrics" .. self.Extension, HttpService:JSONEncode(data))
end

-- Global Registry Helper
function Config:Register(id, element)
	if not id then
		return
	end
	self.Flags[id] = element

	-- Setup autosave if enabled and element has Changed signal
	if self.AutoSave and element.Changed then
		element.Changed:Connect(function()
			self:Save()
		end)
	end
end

function Config:Unregister(id)
	if not id then
		return
	end
	self.Flags[id] = nil
end

return Config
end function __TZAR_MODULES.b():typeof(__modImpl())local v=__TZAR_MODULES.cache.b if not v then v={c=__modImpl()}__TZAR_MODULES.cache.b=v end return v.c end end do local function __modImpl()

















































































































































return nil
end function __TZAR_MODULES.c():typeof(__modImpl())local v=__TZAR_MODULES.cache.c if not v then v={c=__modImpl()}__TZAR_MODULES.cache.c=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - Theme System
    Centralized theming with colors, fonts, and sizes
]]


local Types = __TZAR_MODULES.c()

--// Theme Definitions

local Dark: Theme__DARKLUA_TYPE_f= {
	Colors = {
		-- Base backgrounds
		Background = Color3.fromRGB(11, 11, 11), -- Main background
		BackgroundSecondary = Color3.fromRGB(22, 22, 22), -- TopBar, TabContainer
		BackgroundTertiary = Color3.fromRGB(16, 16, 16), -- Section background
		BackgroundElement = Color3.fromRGB(20, 20, 20), -- Component background

		-- Interactive states
		BackgroundHover = Color3.fromRGB(26, 26, 26), -- Hover state
		BackgroundPress = Color3.fromRGB(16, 16, 16), -- Press state
		BackgroundActive = Color3.fromRGB(30, 30, 30), -- Active/focused state

		-- Borders and strokes
		Border = Color3.fromRGB(65, 65, 65), -- Stroke color
		BorderSubtle = Color3.fromRGB(40, 40, 40), -- Subtle borders
		BorderActive = Color3.fromRGB(50, 50, 50), -- Active borders

		-- Text colors
		Text = Color3.fromRGB(249, 249, 249), -- Primary text
		TextSecondary = Color3.fromRGB(212, 212, 212), -- Secondary text
		TextMuted = Color3.fromRGB(140, 140, 140), -- Muted/placeholder text
		TextDisabled = Color3.fromRGB(100, 100, 100), -- Disabled text

		-- Brand/Accent colors
		Primary = Color3.fromRGB(9, 156, 75), -- Green accent (main)
		PrimaryHover = Color3.fromRGB(11, 180, 87), -- Green hover
		PrimaryPress = Color3.fromRGB(7, 130, 62), -- Green press
		Distract = Color3.fromRGB(227, 29, 29), -- Red accent (destructive)
		DistractHover = Color3.fromRGB(245, 50, 50), -- Red hover
		DistractPress = Color3.fromRGB(190, 25, 25), -- Red press
		Accent = Color3.fromRGB(45, 45, 45), -- Scrollbar, borders

		-- Component-specific colors
		SwitchOff = Color3.fromRGB(40, 40, 40), -- Toggle off state
		SwitchKnobOff = Color3.fromRGB(180, 180, 180), -- Toggle knob off
		SwitchKnobOn = Color3.fromRGB(255, 255, 255), -- Toggle knob on
		SliderTrack = Color3.fromRGB(40, 40, 40), -- Slider background
		SliderFill = Color3.fromRGB(9, 156, 75), -- Slider filled portion
		DropdownOption = Color3.fromRGB(32, 32, 32), -- Dropdown option bg
		DropdownOptionHover = Color3.fromRGB(42, 42, 42), -- Dropdown option hover

		-- Semantic/Status colors
		Success = Color3.fromRGB(9, 156, 75),
		Warning = Color3.fromRGB(245, 158, 11),
		Error = Color3.fromRGB(227, 29, 29),
		Info = Color3.fromRGB(59, 130, 246),

		-- Overlay
		Overlay = Color3.fromRGB(0, 0, 0), -- Dialog/modal overlay
	},
	Fonts = {
		Regular = Enum.Font.Gotham,
		Medium = Enum.Font.GothamMedium,
		Bold = Enum.Font.GothamBold,
	},
	Sizes = {
		CornerRadius = 8,
		CornerRadiusSmall = 4,
		CornerRadiusLarge = 16,
		Padding = 8,
		PaddingSmall = 4,
		PaddingLarge = 12,
		FontSize = 14,
		FontSizeSmall = 12,
		FontSizeLarge = 16,
	},
}

--// Theme Module

local Theme = {
	Current = Dark,
	Themes = {
		Dark = Dark,
	},
}

--// Get current theme value
function Theme:Get(): Theme__DARKLUA_TYPE_f	
return self.Current
end

--// Set active theme
function Theme:Set(theme: Theme__DARKLUA_TYPE_f)
	self.Current = theme
end

--// Quick access to colors
function Theme:Colors(): ThemeColors__DARKLUA_TYPE_c	
return self.Current.Colors
end

--// Quick access to fonts
function Theme:Fonts(): ThemeFonts__DARKLUA_TYPE_d	
return self.Current.Fonts
end

--// Quick access to sizes
function Theme:Sizes(): ThemeSizes__DARKLUA_TYPE_e	
return self.Current.Sizes
end

return Theme
end function __TZAR_MODULES.d():typeof(__modImpl())local v=__TZAR_MODULES.cache.d if not v then v={c=__modImpl()}__TZAR_MODULES.cache.d=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - Utilities
    Helper functions for UI creation
]]


local Theme = __TZAR_MODULES.d()

local Utils = {}

--// Create instance with properties
function Utils.create<T>(className: string, properties: { [string]: any }?): T
	local instance = Instance.new(className)

	if properties then
		for key, value in properties do
			if key == "Parent" then
				continue
			end
			(instance :: any)[key] = value
		end

		-- Set parent last to avoid property change events
		if properties.Parent then
			instance.Parent = properties.Parent
		end
	end

	return instance :: any
end

--// Apply UICorner
function Utils.applyCorner(instance: GuiObject, radius: number?): UICorner
	local sizes = Theme:Sizes()
	return Utils.create("UICorner", {
		CornerRadius = UDim.new(0, radius or sizes.CornerRadius),
		Parent = instance,
	})
end

--// Apply UIPadding
function Utils.applyPadding(
	instance: GuiObject,
	top: number?,
	right: number?,
	bottom: number?,
	left: number?
): UIPadding
	local sizes = Theme:Sizes()
	local defaultPadding = sizes.Padding

	return Utils.create("UIPadding", {
		PaddingTop = UDim.new(0, top or defaultPadding),
		PaddingRight = UDim.new(0, right or top or defaultPadding),
		PaddingBottom = UDim.new(0, bottom or top or defaultPadding),
		PaddingLeft = UDim.new(0, left or right or top or defaultPadding),
		Parent = instance,
	})
end











function Utils.applyListLayout(instance: GuiObject, options: ListLayoutOptions__DARKLUA_TYPE_s?): UIListLayout
	local opts = options or {}
	return Utils.create("UIListLayout", {
		Padding = UDim.new(0, opts.Padding or 4),
		FillDirection = opts.Direction or Enum.FillDirection.Vertical,
		HorizontalAlignment = opts.HorizontalAlignment or Enum.HorizontalAlignment.Left,
		VerticalAlignment = opts.VerticalAlignment or Enum.VerticalAlignment.Top,
		SortOrder = opts.SortOrder or Enum.SortOrder.LayoutOrder,
		Wraps = opts.Wraps or false,
		Parent = instance,
	})
end








function Utils.applyStroke(instance: GuiObject, options: StrokeOptions__DARKLUA_TYPE_t?): UIStroke
	local opts = options or {}
	local colors = Theme:Colors()

	return Utils.create("UIStroke", {
		Color = opts.Color or colors.Border,
		Thickness = opts.Thickness or 1,
		ApplyStrokeMode = opts.Mode or Enum.ApplyStrokeMode.Border,
		Parent = instance,
	})
end

--// Apply UIFlexItem
function Utils.applyFlex(instance: GuiObject, mode: Enum.UIFlexMode?): UIFlexItem
	return Utils.create("UIFlexItem", {
		FlexMode = mode or Enum.UIFlexMode.Fill,
		Parent = instance,
	})
end














function Utils.createText(options: TextOptions__DARKLUA_TYPE_u): TextLabel
	local colors = Theme:Colors()
	local fonts = Theme:Fonts()
	local sizes = Theme:Sizes()

	return Utils.create("TextLabel", {
		Text = options.Text or "",
		TextSize = options.Size or sizes.FontSize,
		TextColor3 = options.Color or colors.Text,
		Font = options.Font or fonts.Regular,
		TextXAlignment = options.XAlignment or Enum.TextXAlignment.Left,
		TextYAlignment = options.YAlignment or Enum.TextYAlignment.Center,
		RichText = options.RichText or false,
		TextWrapped = options.Wrapped or false,
		AutomaticSize = options.AutoSize or Enum.AutomaticSize.None,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	})
end

return Utils
end function __TZAR_MODULES.e():typeof(__modImpl())local v=__TZAR_MODULES.cache.e if not v then v={c=__modImpl()}__TZAR_MODULES.cache.e=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - Assets
    Central asset management using Icons library
]]


local Assets = {}

-- Load Icons library (V2)
local Icons = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"))()

-- Set default icon type to lucide
Icons.SetIconsType("lucide")

-- Expose Icons module for direct access if needed
Assets.Icons = Icons

-- Get icon image URL by name
-- Supports prefixed icons like "geist:house" or just "house" for default lucide
function Assets.GetIcon(name: string): string
	if not name or name == "" then
		return ""
	end

	-- Check for prefix (e.g., "geist:house", "craft:folder")
	local prefix, iconName = string.match(name, "^(%w+):(.+)$")

	if prefix then
		-- Temporarily switch icon type for this request
		local currentType = Icons.GetIconsType and Icons.GetIconsType() or "lucide"
		Icons.SetIconsType(prefix)
		local icon = Icons.GetIcon(iconName)
		Icons.SetIconsType(currentType)
		return icon or ""
	else
		-- Use default icon type (lucide)
		return Icons.GetIcon(name) or ""
	end
end

-- Create an ImageLabel with the icon (using Icons.Image)
function Assets.CreateIconImage(options: {
	Icon: string,
	Size: UDim2?,
	Colors: { any }?,
	Parent: Instance?,
})
	local iconData = Icons.Image({
		Icon = options.Icon,
		Colors = options.Colors,
		Size = options.Size or UDim2.new(0, 16, 0, 16),
	})

	if options.Parent and iconData and iconData.IconFrame then
		iconData.IconFrame.Parent = options.Parent
	end

	return iconData
end

-- Common icon names (for convenience)
Assets.CommonIcons = {
	Close = "x",
	Minimize = "minus",
	Search = "search",
	Check = "check",
	ChevronDown = "chevron-down",
	ChevronRight = "chevron-right",
	Settings = "settings",
	Info = "info",
	Warning = "alert-triangle",
	Error = "alert-circle",
	Home = "home",
	User = "user",
	Folder = "folder",
	File = "file",
	Star = "star",
	Heart = "heart",
	Trash = "trash",
	Edit = "edit",
	Plus = "plus",
	Menu = "menu",
}

return Assets
end function __TZAR_MODULES.f():typeof(__modImpl())local v=__TZAR_MODULES.cache.f if not v then v={c=__modImpl()}__TZAR_MODULES.cache.f=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - TabButton Component
    Tab navigation button with icon and name
]]


local TweenService = game:GetService("TweenService")

local Utils = __TZAR_MODULES.e()
local Signal = __TZAR_MODULES.a()
local Assets = __TZAR_MODULES.f()

local TabButton = {}
TabButton.__index = TabButton

-- Colors
local COLOR_ENABLED = Color3.fromRGB(30, 30, 30) -- Active tab
local COLOR_HOVER = Color3.fromRGB(26, 26, 26) -- Hover when not active
local COLOR_DEFAULT = Color3.fromRGB(22, 22, 22) -- Default/inactive

local TWEEN_FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Helper to resolve icon (name or rbxassetid)
local function resolveIcon(icon)
	if not icon or icon == "" then
		return ""
	end
	-- If it's already an asset ID, return as-is
	if string.match(icon, "^rbxassetid://") then
		return icon
	end
	-- Otherwise, resolve via Icons library
	return Assets.GetIcon(icon)
end

function TabButton.new(options)
	local self = setmetatable({}, TabButton)

	self._active = false
	self._iconName = options.Icon or ""

	-- Main button
	self.Instance = Utils.create("TextButton", {
		Name = "TabBtn",
		Text = "",
		Font = Enum.Font.GothamMedium,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(212, 212, 212),
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundColor3 = COLOR_DEFAULT,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 36),
		AutoButtonColor = false,
		LayoutOrder = options.LayoutOrder or 0,
	})

	Utils.applyCorner(self.Instance)
	Utils.applyPadding(self.Instance, 8, 12, 8, 12)
	Utils.applyListLayout(self.Instance, {
		Padding = 6,
		Direction = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})

	-- Icon (resolve name to URL via Icons library)
	self._icon = Utils.create("ImageLabel", {
		Name = "Icon",
		Image = resolveIcon(options.Icon),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 14, 0, 14),
		Parent = self.Instance,
	})

	-- Name label
	self._nameLabel = Utils.create("TextLabel", {
		Name = "Name",
		Text = options.Name or "Tab",
		Font = Enum.Font.GothamMedium,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(212, 212, 212),
		TextXAlignment = Enum.TextXAlignment.Left,
		RichText = true,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 0, 14),
		Parent = self.Instance,
	})

	-- Signal
	self.OnClick = Signal.new()

	-- Click handler
	self.Instance.MouseButton1Click:Connect(function()
		self.OnClick:Fire()
	end)

	-- Hover animations (only when not active)
	self.Instance.MouseEnter:Connect(function()
		if not self._active then
			TweenService:Create(self.Instance, TWEEN_FAST, {
				BackgroundColor3 = COLOR_HOVER,
			}):Play()
		end
	end)

	self.Instance.MouseLeave:Connect(function()
		if not self._active then
			TweenService:Create(self.Instance, TWEEN_FAST, {
				BackgroundColor3 = COLOR_DEFAULT,
			}):Play()
		end
	end)

	return self
end

function TabButton:SetActive(active: boolean)
	self._active = active

	local targetColor = active and COLOR_ENABLED or COLOR_DEFAULT
	TweenService:Create(self.Instance, TWEEN_FAST, {
		BackgroundColor3 = targetColor,
	}):Play()

	return self
end

function TabButton:IsActive(): boolean
	return self._active
end

function TabButton:SetName(name: string)
	self._nameLabel.Text = name
	return self
end

function TabButton:SetIcon(iconOrId: string, offset: Vector2?, size: Vector2?)
	self._iconName = iconOrId
	-- Resolve icon name to URL if not already an asset ID
	if string.match(iconOrId, "^rbxassetid://") then
		self._icon.Image = iconOrId
	else
		self._icon.Image = Assets.GetIcon(iconOrId)
	end
	if offset then
		self._icon.ImageRectOffset = offset
	end
	if size then
		self._icon.ImageRectSize = size
	end
	return self
end

function TabButton:Destroy()
	self.OnClick:Destroy()
	self.Instance:Destroy()
end

return TabButton
end function __TZAR_MODULES.g():typeof(__modImpl())local v=__TZAR_MODULES.cache.g if not v then v={c=__modImpl()}__TZAR_MODULES.cache.g=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - Tooltip System
    Hover tooltips for UI elements
]]


local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Utils = __TZAR_MODULES.e()

local Tooltip = {}
Tooltip._instance = nil
Tooltip._currentTarget = nil
Tooltip._showDelay = 0.5
Tooltip._hideDelay = nil

-- Tween presets
local TWEEN_FAST = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Initialize tooltip UI (singleton)
function Tooltip:_init(screenGui)
	if self._instance then
		return
	end

	self._screenGui = screenGui

	self._instance = Utils.create("Frame", {
		Name = "Tooltip",
		AnchorPoint = Vector2.new(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 1000,
		Parent = screenGui,
	})
	Utils.applyCorner(self._instance, 6)
	Utils.applyPadding(self._instance, 6, 10, 6, 10)
	Utils.applyStroke(self._instance, { Color = Color3.fromRGB(60, 60, 60), Thickness = 1 })

	self._label = Utils.create("TextLabel", {
		Name = "Text",
		Text = "",
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = Color3.fromRGB(220, 220, 220),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		ZIndex = 1001,
		Parent = self._instance,
	})

	-- Track mouse movement
	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and self._instance.Visible then
			self:_updatePosition(input.Position)
		end
	end)
end

function Tooltip:_updatePosition(mousePos)
	if not self._instance then
		return
	end

	local screenSize = self._screenGui.AbsoluteSize
	local tooltipSize = self._instance.AbsoluteSize

	local x = mousePos.X + 15
	local y = mousePos.Y + 15

	-- Keep on screen
	if x + tooltipSize.X > screenSize.X then
		x = mousePos.X - tooltipSize.X - 10
	end
	if y + tooltipSize.Y > screenSize.Y then
		y = mousePos.Y - tooltipSize.Y - 10
	end

	self._instance.Position = UDim2.new(0, x, 0, y)
end

-- Register tooltip for an element
function Tooltip:Register(element: GuiObject, text: string)
	if not self._instance then
		return
	end

	local showThread = nil

	element.MouseEnter:Connect(function()
		if showThread then
			task.cancel(showThread)
		end

		showThread = task.delay(self._showDelay, function()
			self._label.Text = text
			self._currentTarget = element
			self._instance.Visible = true
			self._instance.BackgroundTransparency = 1

			local mousePos = UserInputService:GetMouseLocation()
			self:_updatePosition(mousePos)

			TweenService:Create(self._instance, TWEEN_FAST, {
				BackgroundTransparency = 0,
			}):Play()
		end)
	end)

	element.MouseLeave:Connect(function()
		if showThread then
			task.cancel(showThread)
			showThread = nil
		end

		if self._currentTarget == element then
			TweenService:Create(self._instance, TWEEN_FAST, {
				BackgroundTransparency = 1,
			}):Play()

			task.delay(0.1, function()
				if self._currentTarget == element then
					self._instance.Visible = false
					self._currentTarget = nil
				end
			end)
		end
	end)
end

-- Update tooltip text for an element
function Tooltip:Update(element: GuiObject, text: string)
	if self._currentTarget == element then
		self._label.Text = text
	end
end

-- Hide current tooltip
function Tooltip:Hide()
	if self._instance then
		self._instance.Visible = false
		self._currentTarget = nil
	end
end

return Tooltip
end function __TZAR_MODULES.h():typeof(__modImpl())local v=__TZAR_MODULES.cache.h if not v then v={c=__modImpl()}__TZAR_MODULES.cache.h=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - Notification Component
    Sonner/Shadcn-style toast notifications
]]


local TweenService = game:GetService("TweenService")

local Utils = __TZAR_MODULES.e()

local Notification = {}
Notification.__index = Notification

-- Tween presets
local TWEEN_SLIDE = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local TWEEN_FADE = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Dimensions - Sonner style (wider, shorter)
local NOTIFICATION_WIDTH = 356
local NOTIFICATION_HEIGHT = 64

function Notification.new(options)
	local self = setmetatable({}, Notification)

	local duration = options.Duration or 5

	-- Main container - Sonner dark style
	self.Instance = Utils.create("Frame", {
		Name = "Notification",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, NOTIFICATION_WIDTH + 20, 0, 0),
		Size = UDim2.new(0, NOTIFICATION_WIDTH, 0, NOTIFICATION_HEIGHT),
		BackgroundColor3 = Color3.fromRGB(24, 24, 24),
		BorderSizePixel = 0,
		ClipsDescendants = true,
	})
	Utils.applyCorner(self.Instance, 10)
	Utils.applyStroke(self.Instance, { Color = Color3.fromRGB(45, 45, 45), Thickness = 1 })

	-- Content container with padding
	local content = Utils.create("Frame", {
		Name = "Content",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Parent = self.Instance,
	})
	Utils.applyPadding(content, 14, 16, 14, 16)

	-- Text container (left side)
	local textContainer = Utils.create("Frame", {
		Name = "Text",
		Size = UDim2.new(1, -80, 1, 0),
		BackgroundTransparency = 1,
		Parent = content,
	})
	Utils.applyListLayout(textContainer, { Padding = 2, VerticalAlignment = Enum.VerticalAlignment.Center })

	-- Title - Bold, clean
	Utils.create("TextLabel", {
		Name = "Title",
		Text = options.Title or "Notification",
		Font = Enum.Font.GothamMedium,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(250, 250, 250),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 18),
		LayoutOrder = 1,
		Parent = textContainer,
	})

	-- Description/Message
	if options.Message or options.Description then
		Utils.create("TextLabel", {
			Name = "Description",
			Text = options.Message or options.Description or "",
			Font = Enum.Font.Gotham,
			TextSize = 13,
			TextColor3 = Color3.fromRGB(160, 160, 160),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 16),
			LayoutOrder = 2,
			Parent = textContainer,
		})
	end

	-- Action button container (right side) - Sonner "Undo" style
	local actionContainer = Utils.create("Frame", {
		Name = "Actions",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, 60, 1, 0),
		BackgroundTransparency = 1,
		Parent = content,
	})

	-- Action button if callback provided
	if options.Action and options.ActionCallback then
		local actionBtn = Utils.create("TextButton", {
			Name = "ActionButton",
			Text = options.Action,
			Font = Enum.Font.GothamMedium,
			TextSize = 13,
			TextColor3 = Color3.fromRGB(30, 30, 30),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 56, 0, 32),
			BackgroundColor3 = Color3.fromRGB(250, 250, 250),
			AutoButtonColor = false,
			Parent = actionContainer,
		})
		Utils.applyCorner(actionBtn, 6)

		-- Hover effect
		actionBtn.MouseEnter:Connect(function()
			TweenService:Create(actionBtn, TWEEN_FADE, {
				BackgroundColor3 = Color3.fromRGB(230, 230, 230),
			}):Play()
		end)

		actionBtn.MouseLeave:Connect(function()
			TweenService:Create(actionBtn, TWEEN_FADE, {
				BackgroundColor3 = Color3.fromRGB(250, 250, 250),
			}):Play()
		end)

		actionBtn.MouseButton1Click:Connect(function()
			if options.ActionCallback then
				options.ActionCallback()
			end
			self:Dismiss()
		end)
	else
		-- Dismiss button (X) if no action
		local closeBtn = Utils.create("TextButton", {
			Name = "Close",
			Text = "",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 28, 0, 28),
			BackgroundColor3 = Color3.fromRGB(40, 40, 40),
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Parent = actionContainer,
		})
		Utils.applyCorner(closeBtn, 6)

		Utils.create("ImageLabel", {
			Name = "Icon",
			Image = "rbxassetid://6031094670",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 14, 0, 14),
			ImageColor3 = Color3.fromRGB(120, 120, 120),
			BackgroundTransparency = 1,
			Parent = closeBtn,
		})

		closeBtn.MouseEnter:Connect(function()
			TweenService:Create(closeBtn, TWEEN_FADE, { BackgroundTransparency = 0 }):Play()
			TweenService:Create(closeBtn.Icon, TWEEN_FADE, { ImageColor3 = Color3.fromRGB(200, 200, 200) }):Play()
		end)

		closeBtn.MouseLeave:Connect(function()
			TweenService:Create(closeBtn, TWEEN_FADE, { BackgroundTransparency = 1 }):Play()
			TweenService:Create(closeBtn.Icon, TWEEN_FADE, { ImageColor3 = Color3.fromRGB(120, 120, 120) }):Play()
		end)

		closeBtn.MouseButton1Click:Connect(function()
			self:Dismiss()
		end)
	end

	-- Auto-dismiss timer
	self._dismissed = false
	if duration > 0 then
		task.delay(duration, function()
			if not self._dismissed then
				self:Dismiss()
			end
		end)
	end

	return self
end

function Notification:Show(targetY: number)
	self.Instance.Position = UDim2.new(1, NOTIFICATION_WIDTH + 20, 0, targetY)

	TweenService:Create(self.Instance, TWEEN_SLIDE, {
		Position = UDim2.new(1, -10, 0, targetY),
	}):Play()
end

function Notification:UpdatePosition(targetY: number)
	TweenService:Create(self.Instance, TWEEN_SLIDE, {
		Position = UDim2.new(1, -10, 0, targetY),
	}):Play()
end

function Notification:Dismiss()
	if self._dismissed then
		return
	end
	self._dismissed = true

	local tween = TweenService:Create(self.Instance, TWEEN_SLIDE, {
		Position = UDim2.new(1, NOTIFICATION_WIDTH + 20, 0, self.Instance.Position.Y.Offset),
	})
	tween:Play()
	tween.Completed:Wait()

	self.Instance:Destroy()
end

function Notification:IsDismissed(): boolean
	return self._dismissed
end

return Notification
end function __TZAR_MODULES.i():typeof(__modImpl())local v=__TZAR_MODULES.cache.i if not v then v={c=__modImpl()}__TZAR_MODULES.cache.i=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - Animation
    Centralized animation utilities
]]


local TweenService = game:GetService("TweenService")

local Animation = {}

-- Standard TweenInfos
Animation.Tweens = {
	Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	Normal = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	Smooth = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	Spring = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
}

function Animation.Play(instance: Instance, tweenInfo: TweenInfo, properties: table)
	local tween = TweenService:Create(instance, tweenInfo, properties)
	tween:Play()
	return tween
end

function Animation.Color(instance: GuiObject, color: Color3, duration: number?)
	local info = duration and TweenInfo.new(duration) or Animation.Tweens.Fast
	Animation.Play(instance, info, { BackgroundColor3 = color })
end

function Animation.Fade(instance: GuiObject, transparency: number, duration: number?)
	local info = duration and TweenInfo.new(duration) or Animation.Tweens.Fast
	Animation.Play(instance, info, { BackgroundTransparency = transparency })
end

return Animation
end function __TZAR_MODULES.j():typeof(__modImpl())local v=__TZAR_MODULES.cache.j if not v then v={c=__modImpl()}__TZAR_MODULES.cache.j=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - Constants
    Shared constant values
]]


return {
	-- UI Dimensions
	CornerRadius = 12,
	CornerRadiusSmall = 6,
	Padding = 8,
	PaddingLarge = 12,

	-- Component Sizes
	ButtonHeight = 36,
	InputHeight = 32,
	InputWidth = 100,
	TrackColor = Color3.fromRGB(45, 45, 45),
	ToggleWidth = 44,
	ToggleHeight = 24,
	IconSize = 16,
	IconSizeSmall = 12,

	-- Durations
	TweenFast = 0.15,
	TweenNormal = 0.25,
	TweenSlow = 0.35,

	-- Z-Indices
	ZIndex = {
		Base = 1,
		Dropdown = 100,
		Tooltip = 1000,
		Overlay = 2000,
		Notification = 3000,
	},
}
end function __TZAR_MODULES.k():typeof(__modImpl())local v=__TZAR_MODULES.cache.k if not v then v={c=__modImpl()}__TZAR_MODULES.cache.k=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - Base Component
    Abstract base class for all UI components
]]


local TweenService = game:GetService("TweenService")

local Config = __TZAR_MODULES.b()
local Utils = __TZAR_MODULES.e()
local Animation = __TZAR_MODULES.j()
local Constants = __TZAR_MODULES.k()
local Theme = __TZAR_MODULES.d()
local Types = __TZAR_MODULES.c()

local Component = {}
Component.__index = Component

function Component.new(props)
	local self = setmetatable({}, Component)

	self.Props = props or {}
	self.Instance = nil
	self._connections = {}

	-- Register with Config system if Flag or Name is present
	local flagId = props.Flag or props.Name
	if flagId then
		Config:Register(flagId, self)
		self._flagId = flagId
	end

	return self
end

function Component:Mount(parent: Instance)
	if self.Instance then
		self.Instance.Parent = parent
	end
end

function Component:Unmount()
	if self.Instance then
		self.Instance.Parent = nil
	end
end

function Component:SetVisible(visible: boolean)
	if self.Instance then
		self.Instance.Visible = visible
	end
end

function Component:Destroy()
	for _, conn in ipairs(self._connections) do
		conn:Disconnect()
	end
	self._connections = {}

	-- Unregister from config
	if self._flagId then
		Config:Unregister(self._flagId)
	end

	if self.Instance then
		self.Instance:Destroy()
	end
end

-- Helper to add hover effects
function Component:AddHoverEffect(instance: GuiObject, hoverColor: Color3, normalColor: Color3)
	table.insert(
		self._connections,
		instance.MouseEnter:Connect(function()
			Animation.Color(instance, hoverColor)
		end)
	)

	table.insert(
		self._connections,
		instance.MouseLeave:Connect(function()
			Animation.Color(instance, normalColor)
		end)
	)
end

return Component
end function __TZAR_MODULES.l():typeof(__modImpl())local v=__TZAR_MODULES.cache.l if not v then v={c=__modImpl()}__TZAR_MODULES.cache.l=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - Button Component
    Button with variants: Primary, Secondary, Outline, Distract
]]


local TweenService = game:GetService("TweenService")

local Utils = __TZAR_MODULES.e()
local Signal = __TZAR_MODULES.a()
local Component = __TZAR_MODULES.l()

local Button = setmetatable({}, Component)
Button.__index = Button

-- Tween presets
local TWEEN_FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Variant colors
local VARIANTS = {
	Primary = {
		Background = Color3.fromRGB(9, 156, 75),
		BackgroundHover = Color3.fromRGB(11, 180, 87),
		BackgroundPress = Color3.fromRGB(7, 130, 62),
		Text = Color3.fromRGB(255, 255, 255),
	},
	Secondary = {
		Background = Color3.fromRGB(22, 22, 22),
		BackgroundHover = Color3.fromRGB(30, 30, 30),
		BackgroundPress = Color3.fromRGB(18, 18, 18),
		Text = Color3.fromRGB(212, 212, 212),
	},
	Distract = {
		Background = Color3.fromRGB(227, 29, 29),
		BackgroundHover = Color3.fromRGB(245, 50, 50),
		BackgroundPress = Color3.fromRGB(190, 25, 25),
		Text = Color3.fromRGB(255, 255, 255),
	},
	Outline = {
		Background = Color3.fromRGB(22, 22, 22),
		BackgroundHover = Color3.fromRGB(30, 30, 30),
		BackgroundPress = Color3.fromRGB(18, 18, 18),
		Text = Color3.fromRGB(212, 212, 212),
		Stroke = Color3.fromRGB(40, 40, 40),
	},
}

function Button.new(options)
	local self = Component.new(options)
	setmetatable(self, Button)

	local variant = options.Variant or "Secondary"
	local colors = VARIANTS[variant] or VARIANTS.Secondary

	-- Main button
	self.Instance = Utils.create("TextButton", {
		Name = "Button",
		Text = "",
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = colors.Background,
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 0, 30),
		AutoButtonColor = false,
		LayoutOrder = options.LayoutOrder or 0,
	})

	Utils.applyCorner(self.Instance, 18)
	Utils.applyPadding(self.Instance, 8, 12, 8, 12)
	Utils.applyListLayout(self.Instance, {
		Padding = 6,
		Direction = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})

	-- Add stroke for Outline variant
	if colors.Stroke then
		Utils.applyStroke(self.Instance, {
			Color = colors.Stroke,
			Thickness = 1,
			Mode = Enum.ApplyStrokeMode.Border,
		})
	end

	-- Name label
	self._nameLabel = Utils.create("TextLabel", {
		Name = "Name",
		Text = options.Name or "Button",
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextColor3 = colors.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 0, 14),
		Parent = self.Instance,
	})

	-- Signal
	self.OnClick = Signal.new()

	-- Click handler
	table.insert(
		self._connections,
		self.Instance.MouseButton1Click:Connect(function()
			self.OnClick:Fire()
			if options.Callback then
				options.Callback()
			end
		end)
	)

	-- Hover animation
	table.insert(
		self._connections,
		self.Instance.MouseEnter:Connect(function()
			TweenService:Create(self.Instance, TWEEN_FAST, {
				BackgroundColor3 = colors.BackgroundHover,
				BackgroundTransparency = 0,
			}):Play()
		end)
	)

	table.insert(
		self._connections,
		self.Instance.MouseLeave:Connect(function()
			TweenService:Create(self.Instance, TWEEN_FAST, {
				BackgroundColor3 = colors.Background,
				BackgroundTransparency = 0.05,
			}):Play()
		end)
	)

	-- Press animation
	table.insert(
		self._connections,
		self.Instance.MouseButton1Down:Connect(function()
			TweenService:Create(self.Instance, TWEEN_FAST, {
				BackgroundColor3 = colors.BackgroundPress,
			}):Play()
		end)
	)

	table.insert(
		self._connections,
		self.Instance.MouseButton1Up:Connect(function()
			TweenService:Create(self.Instance, TWEEN_FAST, {
				BackgroundColor3 = colors.BackgroundHover,
			}):Play()
		end)
	)

	return self
end

-- Set button text
function Button:SetName(name: string)
	self._nameLabel.Text = name
	return self
end

function Button:Destroy()
	self.OnClick:Destroy()
	Component.Destroy(self)
end

return Button
end function __TZAR_MODULES.m():typeof(__modImpl())local v=__TZAR_MODULES.cache.m if not v then v={c=__modImpl()}__TZAR_MODULES.cache.m=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - Paragraph Component
    Clickable element with title and description
]]


local TweenService = game:GetService("TweenService")

local Utils = __TZAR_MODULES.e()
local Signal = __TZAR_MODULES.a()
local Component = __TZAR_MODULES.l()

local Paragraph = setmetatable({}, Component)
Paragraph.__index = Paragraph

-- Tween presets
local TWEEN_FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

function Paragraph.new(options)
	local self = Component.new(options)
	setmetatable(self, Paragraph)

	-- Main button container
	self.Instance = Utils.create("TextButton", {
		Name = "Paragraph",
		Text = "",
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutoButtonColor = false,
		LayoutOrder = options.LayoutOrder or 0,
	})

	Utils.applyCorner(self.Instance, 12)
	Utils.applyListLayout(self.Instance, { Padding = 4 })
	Utils.applyPadding(self.Instance, 8, 12, 8, 12)

	-- Title
	self._title = Utils.create("TextLabel", {
		Name = "Title",
		Text = options.Title or "Title",
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 14),
		Parent = self.Instance,
	})

	-- Description (optional)
	if options.Description then
		self._description = Utils.create("TextLabel", {
			Name = "Description",
			Text = options.Description,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextColor3 = Color3.fromRGB(215, 215, 215),
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 12),
			LayoutOrder = 1,
			Parent = self.Instance,
		})
	end

	-- Signal
	self.OnClick = Signal.new()

	-- Click handler
	table.insert(
		self._connections,
		self.Instance.MouseButton1Click:Connect(function()
			self.OnClick:Fire()
			if options.Callback then
				options.Callback()
			end
		end)
	)

	-- Hover animations
	table.insert(
		self._connections,
		self.Instance.MouseEnter:Connect(function()
			TweenService:Create(self.Instance, TWEEN_FAST, {
				BackgroundTransparency = 0,
			}):Play()
		end)
	)

	table.insert(
		self._connections,
		self.Instance.MouseLeave:Connect(function()
			TweenService:Create(self.Instance, TWEEN_FAST, {
				BackgroundTransparency = 1,
			}):Play()
		end)
	)

	-- Press animation
	table.insert(
		self._connections,
		self.Instance.MouseButton1Down:Connect(function()
			TweenService:Create(self.Instance, TWEEN_FAST, {
				BackgroundColor3 = Color3.fromRGB(16, 16, 16),
				BackgroundTransparency = 0,
			}):Play()
		end)
	)

	table.insert(
		self._connections,
		self.Instance.MouseButton1Up:Connect(function()
			TweenService:Create(self.Instance, TWEEN_FAST, {
				BackgroundColor3 = Color3.fromRGB(26, 26, 26),
				BackgroundTransparency = 0,
			}):Play()
		end)
	)

	return self
end

-- Set title
function Paragraph:SetTitle(title: string)
	self._title.Text = title
	return self
end

-- Set description
function Paragraph:SetDescription(description: string)
	if self._description then
		self._description.Text = description
	end
	return self
end

-- Get title
function Paragraph:GetTitle(): string
	return self._title.Text
end

function Paragraph:Destroy()
	self.OnClick:Destroy()
	Component.Destroy(self)
end

return Paragraph
end function __TZAR_MODULES.n():typeof(__modImpl())local v=__TZAR_MODULES.cache.n if not v then v={c=__modImpl()}__TZAR_MODULES.cache.n=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - Slider Component
    Draggable slider with min/max values and increments
]]


local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Utils = __TZAR_MODULES.e()
local Signal = __TZAR_MODULES.a()
local Component = __TZAR_MODULES.l()

local Slider = setmetatable({}, Component)
Slider.__index = Slider

-- Tween presets
local TWEEN_FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Slider dimensions
local TRACK_HEIGHT = 6
local KNOB_SIZE = 16
local SLIDER_HEIGHT = 24

function Slider.new(options)
	local self = Component.new(options)
	setmetatable(self, Slider)

	self._min = options.Min or 0
	self._max = options.Max or 100
	self._value = math.clamp(options.Default or self._min, self._min, self._max)
	self._increment = options.Increment or 1
	self._suffix = options.Suffix or ""
	self._dragging = false

	-- Main container
	self.Instance = Utils.create("TextButton", {
		Name = "Slider",
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutoButtonColor = false,
		Text = "",
		LayoutOrder = options.LayoutOrder or 0,
	})

	Utils.applyCorner(self.Instance, 12)
	Utils.applyListLayout(self.Instance, { Padding = 2 })
	Utils.applyPadding(self.Instance, 8, 12, 10, 12)

	-- Header container
	local headerContainer = Utils.create("Frame", {
		Name = "Header",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 18),
		Parent = self.Instance,
	})

	-- Title
	self._title = Utils.create("TextLabel", {
		Name = "Title",
		Text = options.Title or "Slider",
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Size = UDim2.new(0.7, 0, 1, 0),
		Parent = headerContainer,
	})

	-- Value Label
	self._valueLabel = Utils.create("TextLabel", {
		Name = "Value",
		Text = tostring(self._value) .. self._suffix,
		Font = Enum.Font.GothamMedium,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(140, 140, 140),
		TextXAlignment = Enum.TextXAlignment.Right,
		BackgroundTransparency = 1,
		Size = UDim2.new(0.3, 0, 1, 0),
		Position = UDim2.new(0.7, 0, 0, 0),
		Parent = headerContainer,
	})

	-- Description
	if options.Description then
		self._description = Utils.create("TextLabel", {
			Name = "Description",
			Text = options.Description,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextColor3 = Color3.fromRGB(140, 140, 140),
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 12),
			Parent = self.Instance,
		})
	end

	-- Slider area container
	local sliderContainer = Utils.create("Frame", {
		Name = "SliderContainer",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, SLIDER_HEIGHT),
		Parent = self.Instance,
	})

	-- Track Background
	self._track = Utils.create("Frame", {
		Name = "Track",
		BackgroundColor3 = Color3.fromRGB(35, 35, 35),
		Size = UDim2.new(1, 0, 0, TRACK_HEIGHT),
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BorderSizePixel = 0,
		Parent = sliderContainer,
	})
	Utils.applyCorner(self._track, TRACK_HEIGHT / 2)

	-- Fill
	self._fill = Utils.create("Frame", {
		Name = "Fill",
		BackgroundColor3 = Color3.fromRGB(9, 156, 75),
		Size = UDim2.new(0, 0, 1, 0),
		BorderSizePixel = 0,
		Parent = self._track,
	})
	Utils.applyCorner(self._fill, TRACK_HEIGHT / 2)

	-- Knob
	self._knob = Utils.create("Frame", {
		Name = "Knob",
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Size = UDim2.new(0, KNOB_SIZE, 0, KNOB_SIZE),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		BorderSizePixel = 0,
		Parent = self._track,
		ZIndex = 2,
	})
	Utils.applyCorner(self._knob, KNOB_SIZE / 2)

	-- Signal
	self.OnChanged = Signal.new()
	self.Changed = self.OnChanged -- Alias for Config system

	-- Hover animations
	table.insert(
		self._connections,
		self.Instance.MouseEnter:Connect(function()
			TweenService:Create(self.Instance, TWEEN_FAST, {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(26, 26, 26),
			}):Play()
			TweenService:Create(self._knob, TWEEN_FAST, {
				Size = UDim2.new(0, KNOB_SIZE + 2, 0, KNOB_SIZE + 2),
			}):Play()
		end)
	)

	table.insert(
		self._connections,
		self.Instance.MouseLeave:Connect(function()
			if not self._dragging then
				TweenService:Create(self.Instance, TWEEN_FAST, {
					BackgroundTransparency = 1,
					BackgroundColor3 = Color3.fromRGB(20, 20, 20),
				}):Play()
				TweenService:Create(self._knob, TWEEN_FAST, {
					Size = UDim2.new(0, KNOB_SIZE, 0, KNOB_SIZE),
				}):Play()
			end
		end)
	)

	-- Input Handling
	local function updateValue(input)
		local absolutePos = self._track.AbsolutePosition
		local absoluteSize = self._track.AbsoluteSize

		local mouseX = input.Position.X
		local relativeX = math.clamp(mouseX - absolutePos.X, 0, absoluteSize.X)
		local alpha = relativeX / absoluteSize.X

		local newValue = self._min + (self._max - self._min) * alpha

		if self._increment > 0 then
			newValue = math.round(newValue / self._increment) * self._increment
		end

		newValue = math.clamp(newValue, self._min, self._max)

		if newValue ~= self._value then
			self:SetValue(newValue)
		end
	end

	table.insert(
		self._connections,
		self._track.InputBegan:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				self._dragging = true
				updateValue(input)
			end
		end)
	)

	table.insert(
		self._connections,
		self._knob.InputBegan:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				self._dragging = true
				updateValue(input)
			end
		end)
	)

	table.insert(
		self._connections,
		UserInputService.InputChanged:Connect(function(input)
			if
				self._dragging
				and (
					input.UserInputType == Enum.UserInputType.MouseMovement
					or input.UserInputType == Enum.UserInputType.Touch
				)
			then
				updateValue(input)
			end
		end)
	)

	table.insert(
		self._connections,
		UserInputService.InputEnded:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				self._dragging = false
			end
		end)
	)

	-- Set initial visual state
	self:_updateVisual(false)

	return self
end

function Slider:_updateVisual(animate: boolean)
	local alpha = (self._value - self._min) / (self._max - self._min)
	alpha = math.clamp(alpha, 0, 1)

	self._valueLabel.Text = string.format("%.2f", self._value):gsub("%.?0+$", "") .. self._suffix

	local targetSize = UDim2.new(alpha, 0, 1, 0)
	local targetPos = UDim2.new(alpha, 0, 0.5, 0)

	if animate then
		TweenService:Create(self._fill, TWEEN_FAST, { Size = targetSize }):Play()
		TweenService:Create(self._knob, TWEEN_FAST, { Position = targetPos }):Play()
	else
		self._fill.Size = targetSize
		self._knob.Position = targetPos
	end
end

-- Set value
function Slider:SetValue(value: number)
	local clamped = math.clamp(value, self._min, self._max)
	if self._increment > 0 then
		clamped = math.round(clamped / self._increment) * self._increment
	end

	if self._value ~= clamped then
		self._value = clamped
		self:_updateVisual(true)
		self.OnChanged:Fire(self._value)
	end
	return self
end

-- Get value
function Slider:GetValue(): number
	return self._value
end

-- Set title
function Slider:SetTitle(title: string)
	self._title.Text = title
	return self
end

-- Set description
function Slider:SetDescription(description: string)
	if self._description then
		self._description.Text = description
	end
	return self
end

function Slider:Destroy()
	self.OnChanged:Destroy()
	Component.Destroy(self)
end

return Slider
end function __TZAR_MODULES.o():typeof(__modImpl())local v=__TZAR_MODULES.cache.o if not v then v={c=__modImpl()}__TZAR_MODULES.cache.o=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - Dropdown Component
    Selectable list with search and multi-select support
]]


local TweenService = game:GetService("TweenService")

local Utils = __TZAR_MODULES.e()
local Signal = __TZAR_MODULES.a()
local Component = __TZAR_MODULES.l()

local Dropdown = setmetatable({}, Component)
Dropdown.__index = Dropdown

-- Tween presets
local TWEEN_FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Constants
local HEADER_HEIGHT = 36
local OPTION_HEIGHT = 28
local MAX_LIST_HEIGHT = 180
local SEARCH_HEIGHT = 32
local ACTION_HEIGHT = 28

function Dropdown.new(options)
	local self = Component.new(options)
	setmetatable(self, Dropdown)

	self._titleText = options.Title or "Dropdown"
	self._options = options.Options or {}
	self._multi = options.Multi or false
	self._callback = options.Callback
	self._expanded = false

	-- Handle default value(s)
	self._selected = {}
	if self._multi then
		if type(options.Default) == "table" then
			for _, v in ipairs(options.Default) do
				self._selected[v] = true
			end
		elseif options.Default then
			self._selected[options.Default] = true
		end
	else
		self._singleSelected = options.Default
	end

	-- Main Container
	self.Instance = Utils.create("Frame", {
		Name = "Dropdown",
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
		LayoutOrder = options.LayoutOrder or 0,
		ClipsDescendants = true,
	})

	-- Background
	self._background = Utils.create("Frame", {
		Name = "Background",
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		Size = UDim2.new(1, 0, 1, 0),
		Parent = self.Instance,
		ZIndex = 1,
	})
	Utils.applyCorner(self._background, 12)

	Utils.create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 0),
		Parent = self._background,
	})

	-- Header (Clickable)
	self._header = Utils.create("TextButton", {
		Name = "Header",
		Text = "",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
		LayoutOrder = 0,
		Parent = self._background,
		AutoButtonColor = false,
		ZIndex = 2,
	})

	Utils.applyPadding(self._header, 0, 12, 0, 12)

	-- Title
	self._titleLabel = Utils.create("TextLabel", {
		Name = "Title",
		Text = self._titleText,
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Size = UDim2.new(0.5, 0, 1, 0),
		Parent = self._header,
		ZIndex = 3,
	})

	-- Right container
	local rightContainer = Utils.create("Frame", {
		Name = "RightContainer",
		BackgroundTransparency = 1,
		Size = UDim2.new(0.5, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		Parent = self._header,
		ZIndex = 3,
	})

	-- Status Label
	self._statusLabel = Utils.create("TextLabel", {
		Name = "Status",
		Text = self:_getStatusText(),
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = Color3.fromRGB(140, 140, 140),
		TextXAlignment = Enum.TextXAlignment.Right,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -26, 1, 0),
		Parent = rightContainer,
		ZIndex = 3,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})

	-- Arrow Icon
	self._arrow = Utils.create("ImageLabel", {
		Name = "Arrow",
		Image = "rbxassetid://6034818372",
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 16, 0, 16),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		ImageColor3 = Color3.fromRGB(140, 140, 140),
		Parent = rightContainer,
		ZIndex = 3,
	})

	-- Content Container
	self._content = Utils.create("Frame", {
		Name = "Content",
		BackgroundColor3 = Color3.fromRGB(16, 16, 16),
		BackgroundTransparency = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1,
		Parent = self._background,
		ClipsDescendants = true,
		Visible = false,
	})

	Utils.applyPadding(self._content, 8, 8, 8, 8)
	Utils.applyListLayout(self._content, { Padding = 6 })

	-- Search Bar
	self._searchBar = Utils.create("TextBox", {
		Name = "Search",
		PlaceholderText = "Search...",
		Text = "",
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		Size = UDim2.new(1, 0, 0, SEARCH_HEIGHT),
		LayoutOrder = 0,
		Parent = self._content,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	Utils.applyCorner(self._searchBar, 8)
	Utils.applyPadding(self._searchBar, 0, 10, 0, 10)

	-- Multi-select Actions
	if self._multi then
		local actionFrame = Utils.create("Frame", {
			Name = "Actions",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, ACTION_HEIGHT),
			LayoutOrder = 1,
			Parent = self._content,
		})
		Utils.applyListLayout(actionFrame, {
			Padding = 6,
			Direction = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})

		local function createActionBtn(text, callback)
			local btn = Utils.create("TextButton", {
				Name = text,
				Text = text,
				Font = Enum.Font.Gotham,
				TextSize = 14,
				TextColor3 = Color3.fromRGB(212, 212, 212),
				BackgroundColor3 = Color3.fromRGB(22, 22, 22),
				BackgroundTransparency = 0.05,
				Size = UDim2.new(0.5, -3, 1, 0),
				Parent = actionFrame,
				AutoButtonColor = false,
			})
			Utils.applyCorner(btn, 18)

			table.insert(
				self._connections,
				btn.MouseEnter:Connect(function()
					TweenService:Create(
						btn,
						TWEEN_FAST,
						{ BackgroundColor3 = Color3.fromRGB(30, 30, 30), BackgroundTransparency = 0 }
					):Play()
				end)
			)
			table.insert(
				self._connections,
				btn.MouseLeave:Connect(function()
					TweenService:Create(
						btn,
						TWEEN_FAST,
						{ BackgroundColor3 = Color3.fromRGB(22, 22, 22), BackgroundTransparency = 0.05 }
					):Play()
				end)
			)
			table.insert(self._connections, btn.MouseButton1Click:Connect(callback))
			return btn
		end

		createActionBtn("Select All", function()
			self:SelectAll()
		end)
		createActionBtn("Deselect All", function()
			self:DeselectAll()
		end)
	end

	-- Options List
	self._list = Utils.create("ScrollingFrame", {
		Name = "List",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60),
		LayoutOrder = 2,
		Parent = self._content,
		AutomaticSize = Enum.AutomaticSize.None,
	})

	Utils.create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 3),
		Parent = self._list,
	})

	self._optionButtons = {}

	-- Signals
	self.OnChanged = Signal.new()
	self.Changed = self.OnChanged -- Alias for Config system

	-- Events
	table.insert(
		self._connections,
		self._header.MouseButton1Click:Connect(function()
			self:Toggle()
		end)
	)

	table.insert(
		self._connections,
		self._searchBar:GetPropertyChangedSignal("Text"):Connect(function()
			self:_filterOptions(self._searchBar.Text)
		end)
	)

	-- Initialize Options
	self:_refreshOptions()

	-- Hover animations
	table.insert(
		self._connections,
		self._header.MouseEnter:Connect(function()
			TweenService:Create(self._background, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(26, 26, 26) }):Play()
			TweenService:Create(self._arrow, TWEEN_FAST, { ImageColor3 = Color3.fromRGB(200, 200, 200) }):Play()
		end)
	)

	table.insert(
		self._connections,
		self._header.MouseLeave:Connect(function()
			if not self._expanded then
				TweenService:Create(self._background, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(20, 20, 20) })
					:Play()
				TweenService:Create(self._arrow, TWEEN_FAST, { ImageColor3 = Color3.fromRGB(140, 140, 140) }):Play()
			end
		end)
	)

	return self
end

function Dropdown:_getStatusText()
	if self._multi then
		local count = 0
		for _ in pairs(self._selected) do
			count = count + 1
		end
		if count == 0 then
			return "None"
		end
		if count == #self._options then
			return "All"
		end
		return tostring(count) .. " Selected"
	else
		return self._singleSelected or "None"
	end
end

function Dropdown:_refreshOptions()
	for _, btn in pairs(self._optionButtons) do
		btn:Destroy()
	end
	self._optionButtons = {}

	for i, option in ipairs(self._options) do
		local isSelected = self._multi and self._selected[option]
			or (not self._multi and self._singleSelected == option)

		local btn = Utils.create("TextButton", {
			Name = option,
			Text = "",
			BackgroundColor3 = isSelected and Color3.fromRGB(9, 156, 75) or Color3.fromRGB(32, 32, 32),
			Size = UDim2.new(1, 0, 0, OPTION_HEIGHT),
			Parent = self._list,
			LayoutOrder = i,
			AutoButtonColor = false,
		})
		Utils.applyCorner(btn, 6)

		Utils.create("TextLabel", {
			Name = "Label",
			Text = option,
			Font = Enum.Font.Gotham,
			TextSize = 13,
			TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(190, 190, 190),
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -20, 1, 0),
			Position = UDim2.new(0, 10, 0, 0),
			Parent = btn,
		})

		table.insert(
			self._connections,
			btn.MouseEnter:Connect(function()
				if
					not (self._multi and self._selected[option] or (not self._multi and self._singleSelected == option))
				then
					TweenService:Create(btn, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(42, 42, 42) }):Play()
				end
			end)
		)

		table.insert(
			self._connections,
			btn.MouseLeave:Connect(function()
				local selected = self._multi and self._selected[option]
					or (not self._multi and self._singleSelected == option)
				if not selected then
					TweenService:Create(btn, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(32, 32, 32) }):Play()
				end
			end)
		)

		table.insert(
			self._connections,
			btn.MouseButton1Click:Connect(function()
				self:Select(option)
			end)
		)

		self._optionButtons[option] = btn
	end

	self:_updateListHeight()
end

function Dropdown:_filterOptions(text)
	local lowerText = text:lower()
	for option, btn in pairs(self._optionButtons) do
		btn.Visible = text == "" or option:lower():find(lowerText, 1, true) ~= nil
	end
	self:_updateListHeight()
end

function Dropdown:_updateListHeight()
	local layout = self._list:FindFirstChildWhichIsA("UIListLayout")
	local padding = layout and layout.Padding.Offset or 3

	local visibleCount = 0
	for _, child in ipairs(self._list:GetChildren()) do
		if child:IsA("GuiObject") and child.Visible then
			visibleCount = visibleCount + 1
		end
	end

	local contentHeight = visibleCount * (OPTION_HEIGHT + padding)
	local listHeight = math.min(contentHeight, MAX_LIST_HEIGHT)

	self._list.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
	self._list.Size = UDim2.new(1, 0, 0, listHeight)
end

function Dropdown:Select(option)
	if self._multi then
		self._selected[option] = not self._selected[option] or nil
	else
		self._singleSelected = option
		self:Toggle()
	end

	self:_updateVisuals()

	if self._multi then
		local list = {}
		for k in pairs(self._selected) do
			table.insert(list, k)
		end
		self.OnChanged:Fire(list)
		if self._callback then
			self._callback(list)
		end
	else
		self.OnChanged:Fire(self._singleSelected)
		if self._callback then
			self._callback(self._singleSelected)
		end
	end
end

function Dropdown:SelectAll()
	if not self._multi then
		return
	end
	for _, option in ipairs(self._options) do
		self._selected[option] = true
	end
	self:_updateVisuals()
	local list = {}
	for k in pairs(self._selected) do
		table.insert(list, k)
	end
	self.OnChanged:Fire(list)
	if self._callback then
		self._callback(list)
	end
end

function Dropdown:DeselectAll()
	if not self._multi then
		return
	end
	self._selected = {}
	self:_updateVisuals()
	self.OnChanged:Fire({})
	if self._callback then
		self._callback({})
	end
end

function Dropdown:_updateVisuals()
	self._statusLabel.Text = self:_getStatusText()

	for option, btn in pairs(self._optionButtons) do
		local isSelected = self._multi and self._selected[option]
			or (not self._multi and self._singleSelected == option)
		local color = isSelected and Color3.fromRGB(9, 156, 75) or Color3.fromRGB(32, 32, 32)
		local textColor = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(190, 190, 190)

		TweenService:Create(btn, TWEEN_FAST, { BackgroundColor3 = color }):Play()
		local label = btn:FindFirstChild("Label")
		if label then
			TweenService:Create(label, TWEEN_FAST, { TextColor3 = textColor }):Play()
		end
	end
end

function Dropdown:Toggle()
	self._expanded = not self._expanded
	self._content.Visible = self._expanded

	if self._expanded then
		TweenService:Create(self._arrow, TWEEN_FAST, { Rotation = 180 }):Play()
		TweenService:Create(self._background, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(26, 26, 26) }):Play()
	else
		TweenService:Create(self._arrow, TWEEN_FAST, { Rotation = 0 }):Play()
		TweenService:Create(self._background, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(20, 20, 20) }):Play()
		self._content.Visible = false
	end
end

-- Get value (for Config system)
function Dropdown:GetValue()
	if self._multi then
		local list = {}
		for k in pairs(self._selected) do
			table.insert(list, k)
		end
		return list
	else
		return self._singleSelected
	end
end

-- Set value (for Config system)
function Dropdown:SetValue(value)
	if self._multi then
		self._selected = {}
		if type(value) == "table" then
			for _, v in ipairs(value) do
				self._selected[v] = true
			end
		elseif value then
			self._selected[value] = true
		end
	else
		self._singleSelected = value
	end
	self:_updateVisuals()
	self.OnChanged:Fire(self:GetValue())
	return self
end

function Dropdown:Refresh(options, default)
	self._options = options or {}
	if default then
		self._selected = {}
		if self._multi and type(default) == "table" then
			for _, v in ipairs(default) do
				self._selected[v] = true
			end
		else
			self._singleSelected = default
		end
	end
	self:_refreshOptions()
	self:_updateVisuals()
end

function Dropdown:Destroy()
	self.OnChanged:Destroy()
	Component.Destroy(self)
end

return Dropdown
end function __TZAR_MODULES.p():typeof(__modImpl())local v=__TZAR_MODULES.cache.p if not v then v={c=__modImpl()}__TZAR_MODULES.cache.p=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - ButtonGroup Component
    Container for grouping elements horizontally with wrapping
]]


local Utils = __TZAR_MODULES.e()
local Component = __TZAR_MODULES.l()

-- Lazy load to avoid circular dependencies
local Button
local Paragraph
local Slider
local Dropdown

local ButtonGroup = setmetatable({}, Component)
ButtonGroup.__index = ButtonGroup

function ButtonGroup.new(options)
	local self = Component.new(options or {})
	setmetatable(self, ButtonGroup)

	-- Container frame
	self.Instance = Utils.create("Frame", {
		Name = "ButtonGroup",
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = (options or {}).LayoutOrder or 0,
	})

	-- Horizontal layout with wrapping
	Utils.applyListLayout(self.Instance, {
		Padding = 4,
		Direction = Enum.FillDirection.Horizontal,
		Wraps = true,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})

	-- Store padding reference for auto-detection
	self._padding = Utils.applyPadding(self.Instance, 0, 6, 0, 6)

	-- Auto-detect parent and adjust padding
	table.insert(
		self._connections,
		self.Instance:GetPropertyChangedSignal("Parent"):Connect(function()
			local parent = self.Instance.Parent
			if parent then
				if parent:IsA("ScrollingFrame") then
					self._padding.PaddingLeft = UDim.new(0, 0)
					self._padding.PaddingRight = UDim.new(0, 0)
				else
					self._padding.PaddingLeft = UDim.new(0, 6)
					self._padding.PaddingRight = UDim.new(0, 6)
				end
			end
		end)
	)

	self._items = {}

	return self
end

-- Add a button to this group
function ButtonGroup:AddButton(options)
	if not Button then
		Button = __TZAR_MODULES.m()
	end

	local btn = Button.new({
		Name = options.Name or "Button",
		Variant = options.Variant or "Secondary",
		Callback = options.Callback,
		LayoutOrder = options.LayoutOrder or #self._items + 1,
	})
	btn:Mount(self.Instance)
	table.insert(self._items, btn)
	return btn
end

-- Add a paragraph to this group
function ButtonGroup:AddParagraph(options)
	if not Paragraph then
		Paragraph = __TZAR_MODULES.n()
	end

	local para = Paragraph.new({
		Title = options.Title or "Title",
		Description = options.Description,
		Callback = options.Callback,
		LayoutOrder = options.LayoutOrder or #self._items + 1,
	})
	para:Mount(self.Instance)
	table.insert(self._items, para)
	return para
end

-- Add a slider to this group
function ButtonGroup:AddSlider(options)
	if not Slider then
		Slider = __TZAR_MODULES.o()
	end

	local slider = Slider.new({
		Title = options.Title or "Slider",
		Description = options.Description,
		Min = options.Min,
		Max = options.Max,
		Default = options.Default,
		Increment = options.Increment,
		Suffix = options.Suffix,
		LayoutOrder = options.LayoutOrder or #self._items + 1,
	})

	if options.Callback then
		slider.OnChanged:Connect(options.Callback)
	end

	slider:Mount(self.Instance)
	table.insert(self._items, slider)
	return slider
end

-- Add a dropdown to this group
function ButtonGroup:AddDropdown(options)
	if not Dropdown then
		Dropdown = __TZAR_MODULES.p()
	end

	local dropdown = Dropdown.new({
		Title = options.Title or "Dropdown",
		Options = options.Options,
		Default = options.Default,
		Multi = options.Multi,
		Callback = options.Callback,
		LayoutOrder = options.LayoutOrder or #self._items + 1,
	})

	if options.Callback then
		dropdown.OnChanged:Connect(options.Callback)
	end

	dropdown:Mount(self.Instance)
	table.insert(self._items, dropdown)
	return dropdown
end

function ButtonGroup:Destroy()
	for _, item in self._items do
		item:Destroy()
	end
	Component.Destroy(self)
end

return ButtonGroup
end function __TZAR_MODULES.q():typeof(__modImpl())local v=__TZAR_MODULES.cache.q if not v then v={c=__modImpl()}__TZAR_MODULES.cache.q=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - Toggle Component
    Element with title, description, and switch on top right
]]


local TweenService = game:GetService("TweenService")

local Utils = __TZAR_MODULES.e()
local Signal = __TZAR_MODULES.a()
local Component = __TZAR_MODULES.l()

local Toggle = setmetatable({}, Component)
Toggle.__index = Toggle

-- Tween presets
local TWEEN_FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Switch dimensions
local SWITCH_WIDTH = 28
local SWITCH_HEIGHT = 14
local SWITCH_KNOB_SIZE = 10
local SWITCH_PADDING = 2

function Toggle.new(options)
	local self = Component.new(options)
	setmetatable(self, Toggle)

	self._value = options.Default or false

	-- Main container
	self.Instance = Utils.create("TextButton", {
		Name = "Toggle",
		Text = "",
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutoButtonColor = false,
		LayoutOrder = options.LayoutOrder or 0,
	})

	Utils.applyCorner(self.Instance, 12)
	Utils.applyPadding(self.Instance, 8, 12, 8, 12)

	-- Content container
	local contentContainer = Utils.create("Frame", {
		Name = "Content",
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -(SWITCH_WIDTH + 12), 0, 0),
		Parent = self.Instance,
	})

	Utils.applyListLayout(contentContainer, { Padding = 4 })

	-- Title
	self._title = Utils.create("TextLabel", {
		Name = "Title",
		Text = options.Title or "Toggle",
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 14),
		Parent = contentContainer,
	})

	-- Description (optional)
	if options.Description then
		self._description = Utils.create("TextLabel", {
			Name = "Description",
			Text = options.Description,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextColor3 = Color3.fromRGB(215, 215, 215),
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 12),
			LayoutOrder = 1,
			Parent = contentContainer,
		})
	end

	local switchHold = Utils.create("Folder", {
		Name = "SwitchHold",
		Parent = self.Instance,
	})

	-- Switch container
	self._switch = Utils.create("Frame", {
		Name = "Switch",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(0, SWITCH_WIDTH, 0, SWITCH_HEIGHT),
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		BorderSizePixel = 0,
		Parent = switchHold,
	})

	Utils.applyCorner(self._switch, SWITCH_HEIGHT / 2)

	-- Switch knob
	self._knob = Utils.create("Frame", {
		Name = "Knob",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, SWITCH_PADDING, 0.5, 0),
		Size = UDim2.new(0, SWITCH_KNOB_SIZE, 0, SWITCH_KNOB_SIZE),
		BackgroundColor3 = Color3.fromRGB(180, 180, 180),
		BorderSizePixel = 0,
		Parent = self._switch,
	})

	Utils.applyCorner(self._knob, SWITCH_KNOB_SIZE / 2)

	-- Signal
	self.OnToggle = Signal.new()
	self.Changed = self.OnToggle -- Alias for Config system

	-- Click handler
	table.insert(
		self._connections,
		self.Instance.MouseButton1Click:Connect(function()
			self:Toggle()
		end)
	)

	-- Hover animations
	table.insert(
		self._connections,
		self.Instance.MouseEnter:Connect(function()
			if not self._value then
				TweenService:Create(self.Instance, TWEEN_FAST, {
					BackgroundTransparency = 0,
					BackgroundColor3 = Color3.fromRGB(26, 26, 26),
				}):Play()
			end
		end)
	)

	table.insert(
		self._connections,
		self.Instance.MouseLeave:Connect(function()
			if not self._value then
				TweenService:Create(self.Instance, TWEEN_FAST, {
					BackgroundTransparency = 1,
					BackgroundColor3 = Color3.fromRGB(20, 20, 20),
				}):Play()
			end
		end)
	)

	-- Press animation
	table.insert(
		self._connections,
		self.Instance.MouseButton1Down:Connect(function()
			TweenService:Create(self.Instance, TWEEN_FAST, {
				BackgroundColor3 = Color3.fromRGB(16, 16, 16),
				BackgroundTransparency = 0,
			}):Play()
		end)
	)

	table.insert(
		self._connections,
		self.Instance.MouseButton1Up:Connect(function()
			local targetColor = self._value and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(26, 26, 26)
			TweenService:Create(self.Instance, TWEEN_FAST, {
				BackgroundColor3 = targetColor,
				BackgroundTransparency = 0,
			}):Play()
		end)
	)

	-- Set initial state
	if self._value then
		self:_updateVisual(false)
	end

	return self
end

-- Update switch visual
function Toggle:_updateVisual(animate: boolean)
	local knobX = self._value and (SWITCH_WIDTH - SWITCH_KNOB_SIZE - SWITCH_PADDING) or SWITCH_PADDING
	local switchColor = self._value and Color3.fromRGB(9, 156, 75) or Color3.fromRGB(40, 40, 40)
	local knobColor = self._value and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)

	if animate then
		TweenService:Create(self._knob, TWEEN_FAST, {
			Position = UDim2.new(0, knobX, 0.5, 0),
			BackgroundColor3 = knobColor,
		}):Play()
		TweenService:Create(self._switch, TWEEN_FAST, {
			BackgroundColor3 = switchColor,
		}):Play()
		if self._value then
			TweenService:Create(self.Instance, TWEEN_FAST, {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			}):Play()
		else
			TweenService:Create(self.Instance, TWEEN_FAST, {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(26, 26, 26),
			}):Play()
		end
	else
		self._knob.Position = UDim2.new(0, knobX, 0.5, 0)
		self._knob.BackgroundColor3 = knobColor
		self._switch.BackgroundColor3 = switchColor

		if self._value then
			self.Instance.BackgroundTransparency = 0
			self.Instance.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		else
			self.Instance.BackgroundTransparency = 1
		end
	end
end

-- Toggle the value
function Toggle:Toggle()
	self._value = not self._value
	self:_updateVisual(true)
	self.OnToggle:Fire(self._value)
end

-- Set value
function Toggle:SetValue(value: boolean)
	if self._value ~= value then
		self._value = value
		self:_updateVisual(true)
		self.OnToggle:Fire(self._value)
	end
	return self
end

-- Get value
function Toggle:GetValue(): boolean
	return self._value
end

-- Set title
function Toggle:SetTitle(title: string)
	self._title.Text = title
	return self
end

-- Set description
function Toggle:SetDescription(description: string)
	if self._description then
		self._description.Text = description
	end
	return self
end

function Toggle:Destroy()
	self.OnToggle:Destroy()
	Component.Destroy(self)
end

return Toggle
end function __TZAR_MODULES.r():typeof(__modImpl())local v=__TZAR_MODULES.cache.r if not v then v={c=__modImpl()}__TZAR_MODULES.cache.r=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - Keybind Component
    Element with title, description, and key binding button
]]


local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Utils = __TZAR_MODULES.e()
local Signal = __TZAR_MODULES.a()
local Component = __TZAR_MODULES.l()

local Keybind = setmetatable({}, Component)
Keybind.__index = Keybind

-- Tween presets
local TWEEN_FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Keybind button dimensions
local BUTTON_HEIGHT = 24
local BUTTON_MIN_WIDTH = 50

-- Blacklisted keys
local BLACKLIST = {
	[Enum.KeyCode.Unknown] = true,
	[Enum.KeyCode.Escape] = true,
	[Enum.KeyCode.Return] = true,
	[Enum.KeyCode.Backspace] = true,
}

local function formatKeyName(keyCode: Enum.KeyCode): string
	local name = keyCode.Name
	name = name:gsub("^Left", "L"):gsub("^Right", "R"):gsub("Control", "Ctrl")
	return name
end

function Keybind.new(options)
	local self = Component.new(options)
	setmetatable(self, Keybind)

	self._key = options.Default or Enum.KeyCode.Unknown
	self._listening = false
	self._callback = options.Callback
	self._inputConnection = nil

	-- Main container
	self.Instance = Utils.create("TextButton", {
		Name = "Keybind",
		Text = "",
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutoButtonColor = false,
		LayoutOrder = options.LayoutOrder or 0,
	})

	Utils.applyCorner(self.Instance, 12)
	Utils.applyPadding(self.Instance, 8, 12, 8, 12)

	-- Content container
	local contentContainer = Utils.create("Frame", {
		Name = "Content",
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -(BUTTON_MIN_WIDTH + 20), 0, 0),
		Parent = self.Instance,
	})

	Utils.applyListLayout(contentContainer, { Padding = 4 })

	-- Title
	self._title = Utils.create("TextLabel", {
		Name = "Title",
		Text = options.Title or "Keybind",
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 14),
		Parent = contentContainer,
	})

	-- Description (optional)
	if options.Description then
		self._description = Utils.create("TextLabel", {
			Name = "Description",
			Text = options.Description,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextColor3 = Color3.fromRGB(140, 140, 140),
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 12),
			LayoutOrder = 1,
			Parent = contentContainer,
		})
	end

	local buttonHolder = Utils.create("Folder", { Name = "ButtonHolder", Parent = self.Instance })

	-- Keybind button
	self._button = Utils.create("TextButton", {
		Name = "KeyButton",
		Text = self._key == Enum.KeyCode.Unknown and "None" or formatKeyName(self._key),
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
		TextColor3 = Color3.fromRGB(200, 200, 200),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, BUTTON_MIN_WIDTH, 0, BUTTON_HEIGHT),
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Parent = buttonHolder,
	})

	Utils.applyCorner(self._button, 6)
	Utils.applyPadding(self._button, 0, 10, 0, 10)

	-- Signal
	self.OnChanged = Signal.new()
	self.Changed = self.OnChanged -- Alias for Config system

	-- Click handlers
	table.insert(
		self._connections,
		self._button.MouseButton1Click:Connect(function()
			self:_startListening()
		end)
	)

	table.insert(
		self._connections,
		self.Instance.MouseButton1Click:Connect(function()
			self:_startListening()
		end)
	)

	-- Hover animations
	table.insert(
		self._connections,
		self.Instance.MouseEnter:Connect(function()
			TweenService:Create(
				self.Instance,
				TWEEN_FAST,
				{ BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(26, 26, 26) }
			):Play()
		end)
	)

	table.insert(
		self._connections,
		self.Instance.MouseLeave:Connect(function()
			if not self._listening then
				TweenService:Create(
					self.Instance,
					TWEEN_FAST,
					{ BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(20, 20, 20) }
				):Play()
			end
		end)
	)

	table.insert(
		self._connections,
		self._button.MouseEnter:Connect(function()
			if not self._listening then
				TweenService:Create(self._button, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(40, 40, 40) }):Play()
			end
		end)
	)

	table.insert(
		self._connections,
		self._button.MouseLeave:Connect(function()
			if not self._listening then
				TweenService:Create(self._button, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(30, 30, 30) }):Play()
			end
		end)
	)

	return self
end

function Keybind:_startListening()
	if self._listening then
		return
	end

	self._listening = true
	self._button.Text = "..."

	TweenService:Create(
		self._button,
		TWEEN_FAST,
		{ BackgroundColor3 = Color3.fromRGB(9, 156, 75), TextColor3 = Color3.fromRGB(255, 255, 255) }
	):Play()
	TweenService
		:Create(
			self.Instance,
			TWEEN_FAST,
			{ BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(26, 26, 26) }
		)
		:Play()

	self._inputConnection = UserInputService.InputBegan:Connect(function(input, _)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			local keyCode = input.KeyCode

			if keyCode == Enum.KeyCode.Escape then
				self:_stopListening(false)
				return
			end

			if keyCode == Enum.KeyCode.Backspace then
				self._key = Enum.KeyCode.Unknown
				self:_stopListening(true)
				return
			end

			if BLACKLIST[keyCode] then
				return
			end

			self._key = keyCode
			self:_stopListening(true)
		elseif
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.MouseButton2
		then
			task.delay(0.1, function()
				if self._listening then
					self:_stopListening(false)
				end
			end)
		end
	end)
end

function Keybind:_stopListening(changed: boolean)
	self._listening = false

	if self._inputConnection then
		self._inputConnection:Disconnect()
		self._inputConnection = nil
	end

	self._button.Text = self._key == Enum.KeyCode.Unknown and "None" or formatKeyName(self._key)

	TweenService:Create(
		self._button,
		TWEEN_FAST,
		{ BackgroundColor3 = Color3.fromRGB(30, 30, 30), TextColor3 = Color3.fromRGB(200, 200, 200) }
	):Play()
	TweenService
		:Create(
			self.Instance,
			TWEEN_FAST,
			{ BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(20, 20, 20) }
		)
		:Play()

	if changed then
		self.OnChanged:Fire(self._key)
		if self._callback then
			self._callback(self._key)
		end
	end
end

function Keybind:GetKey(): Enum.KeyCode
	return self._key
end

function Keybind:SetKey(key: Enum.KeyCode)
	self._key = key
	self._button.Text = key == Enum.KeyCode.Unknown and "None" or formatKeyName(key)
	self.OnChanged:Fire(self._key)
	return self
end

-- Aliases for Config system
function Keybind:GetValue()
	return self._key
end

function Keybind:SetValue(key)
	return self:SetKey(key)
end

function Keybind:SetTitle(title: string)
	self._title.Text = title
	return self
end

function Keybind:SetDescription(description: string)
	if self._description then
		self._description.Text = description
	end
	return self
end

function Keybind:IsPressed(): boolean
	if self._key == Enum.KeyCode.Unknown then
		return false
	end
	return UserInputService:IsKeyDown(self._key)
end

function Keybind:Destroy()
	if self._inputConnection then
		self._inputConnection:Disconnect()
	end
	self.OnChanged:Destroy()
	Component.Destroy(self)
end

return Keybind
end function __TZAR_MODULES.s():typeof(__modImpl())local v=__TZAR_MODULES.cache.s if not v then v={c=__modImpl()}__TZAR_MODULES.cache.s=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - TextBox Component
    Text input with title and description
]]


local TweenService = game:GetService("TweenService")

local Utils = __TZAR_MODULES.e()
local Signal = __TZAR_MODULES.a()
local Component = __TZAR_MODULES.l()

local TextBox = setmetatable({}, Component)
TextBox.__index = TextBox

-- Tween presets
local TWEEN_FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Input dimensions
local INPUT_WIDTH = 120
local INPUT_HEIGHT = 28

function TextBox.new(options)
	local self = Component.new(options)
	setmetatable(self, TextBox)

	self._value = options.Default or ""
	self._placeholder = options.Placeholder or "Enter text..."
	self._clearOnFocus = options.ClearOnFocus or false
	self._callback = options.Callback

	-- Main container
	self.Instance = Utils.create("TextButton", {
		Name = "TextBox",
		Text = "",
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutoButtonColor = false,
		LayoutOrder = options.LayoutOrder or 0,
	})

	Utils.applyCorner(self.Instance, 12)
	Utils.applyPadding(self.Instance, 8, 12, 8, 12)

	-- Content container
	local contentContainer = Utils.create("Frame", {
		Name = "Content",
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -(INPUT_WIDTH + 12), 0, 0),
		Parent = self.Instance,
	})

	Utils.applyListLayout(contentContainer, { Padding = 4 })

	-- Title
	self._title = Utils.create("TextLabel", {
		Name = "Title",
		Text = options.Title or "TextBox",
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 14),
		Parent = contentContainer,
	})

	-- Description (optional)
	if options.Description then
		self._description = Utils.create("TextLabel", {
			Name = "Description",
			Text = options.Description,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextColor3 = Color3.fromRGB(140, 140, 140),
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 12),
			LayoutOrder = 1,
			Parent = contentContainer,
		})
	end

	local inputHolder = Utils.create("Folder", { Name = "InputHolder", Parent = self.Instance })

	-- Input container
	self._inputContainer = Utils.create("Frame", {
		Name = "InputContainer",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(0, INPUT_WIDTH, 0, INPUT_HEIGHT),
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BorderSizePixel = 0,
		Parent = inputHolder,
	})
	Utils.applyCorner(self._inputContainer, 6)

	-- Actual TextBox
	self._input = Utils.create("TextBox", {
		Name = "Input",
		Text = self._value,
		PlaceholderText = self._placeholder,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ClearTextOnFocus = self._clearOnFocus,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Parent = self._inputContainer,
	})
	Utils.applyPadding(self._input, 0, 8, 0, 8)

	-- Signal
	self.OnChanged = Signal.new()
	self.Changed = self.OnChanged -- Alias for Config system

	-- Focus states
	table.insert(
		self._connections,
		self._input.Focused:Connect(function()
			TweenService:Create(self._inputContainer, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(40, 40, 40) })
				:Play()
			TweenService:Create(
				self.Instance,
				TWEEN_FAST,
				{ BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(26, 26, 26) }
			):Play()
		end)
	)

	table.insert(
		self._connections,
		self._input.FocusLost:Connect(function(_)
			TweenService:Create(self._inputContainer, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(30, 30, 30) })
				:Play()
			TweenService:Create(
				self.Instance,
				TWEEN_FAST,
				{ BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(20, 20, 20) }
			):Play()

			local newValue = self._input.Text
			if newValue ~= self._value then
				self._value = newValue
				self.OnChanged:Fire(self._value)
				if self._callback then
					self._callback(self._value)
				end
			end
		end)
	)

	-- Hover effects
	table.insert(
		self._connections,
		self.Instance.MouseEnter:Connect(function()
			TweenService:Create(
				self.Instance,
				TWEEN_FAST,
				{ BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(26, 26, 26) }
			):Play()
		end)
	)

	table.insert(
		self._connections,
		self.Instance.MouseLeave:Connect(function()
			if not self._input:IsFocused() then
				TweenService:Create(
					self.Instance,
					TWEEN_FAST,
					{ BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(20, 20, 20) }
				):Play()
			end
		end)
	)

	-- Click to focus
	table.insert(
		self._connections,
		self.Instance.MouseButton1Click:Connect(function()
			self._input:CaptureFocus()
		end)
	)

	return self
end

function TextBox:GetValue(): string
	return self._value
end

function TextBox:SetValue(val: string)
	self._value = val
	self._input.Text = val
	self.OnChanged:Fire(self._value)
	return self
end

function TextBox:SetTitle(title: string)
	self._title.Text = title
	return self
end

function TextBox:SetDescription(description: string)
	if self._description then
		self._description.Text = description
	end
	return self
end

function TextBox:Destroy()
	self.OnChanged:Destroy()
	Component.Destroy(self)
end

return TextBox
end function __TZAR_MODULES.t():typeof(__modImpl())local v=__TZAR_MODULES.cache.t if not v then v={c=__modImpl()}__TZAR_MODULES.cache.t=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - ColorPicker Component
    HSV Picker with preview and expandable panel
]]


local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Utils = __TZAR_MODULES.e()
local Signal = __TZAR_MODULES.a()
local Component = __TZAR_MODULES.l()

local ColorPicker = setmetatable({}, Component)
ColorPicker.__index = ColorPicker

-- Tween presets
local TWEEN_FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Dimensions
local PREVIEW_SIZE = 24
local PICKER_HEIGHT = 100
local HUE_WIDTH = 20

-- Helper functions
local function hsvToRgb(h, s, v)
	local c = v * s
	local x = c * (1 - math.abs((h / 60) % 2 - 1))
	local m = v - c
	local r, g, b =
		(h < 60 and c or h < 120 and x or 0),
		(h < 60 and x or h < 120 and c or h < 180 and c or h < 240 and x or 0),
		(h < 120 and 0 or h < 180 and x or h < 240 and c or h < 300 and c or x)
	return Color3.new(r + m, g + m, b + m)
end

local function rgbToHsv(color)
	local r, g, b = color.R, color.G, color.B
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local h, s, v = 0, 0, max
	local d = max - min
	s = max == 0 and 0 or d / max
	if max == min then
		h = 0
	else
		if max == r then
			h = (g - b) / d + (g < b and 6 or 0)
		elseif max == g then
			h = (b - r) / d + 2
		else
			h = (r - g) / d + 4
		end
		h = h / 6
	end
	return h * 360, s, v
end

function ColorPicker.new(options)
	local self = Component.new(options)
	setmetatable(self, ColorPicker)

	self._value = options.Default or Color3.new(1, 1, 1)
	self._h, self._s, self._v = rgbToHsv(self._value)
	self._callback = options.Callback
	self._expanded = false
	self._dragging = nil

	-- Main container (Frame, not TextButton to avoid click bubbling)
	self.Instance = Utils.create("Frame", {
		Name = "ColorPicker",
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = options.LayoutOrder or 0,
	})

	Utils.applyCorner(self.Instance, 12)
	Utils.applyPadding(self.Instance, 8, 12, 8, 12)
	Utils.applyListLayout(self.Instance, { Padding = 8 })

	-- Header (clickable to toggle)
	self._header = Utils.create("TextButton", {
		Name = "Header",
		Text = "",
		Size = UDim2.new(1, 0, 0, PREVIEW_SIZE),
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Parent = self.Instance,
	})

	-- Title
	self._title = Utils.create("TextLabel", {
		Name = "Title",
		Text = options.Title or "Color",
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -(PREVIEW_SIZE + 10), 1, 0),
		Parent = self._header,
	})

	-- Preview box
	self._preview = Utils.create("Frame", {
		Name = "Preview",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0, PREVIEW_SIZE, 0, PREVIEW_SIZE),
		BackgroundColor3 = self._value,
		BorderSizePixel = 0,
		Parent = self._header,
	})
	Utils.applyCorner(self._preview, 6)

	-- Content (hidden by default)
	self._content = Utils.create("Frame", {
		Name = "Content",
		Size = UDim2.new(1, 0, 0, PICKER_HEIGHT),
		BackgroundTransparency = 1,
		Visible = false,
		Parent = self.Instance,
	})

	-- Saturation/Value Picker
	self._svPicker = Utils.create("ImageLabel", {
		Name = "SVPicker",
		Image = "rbxassetid://4155801252",
		BackgroundColor3 = hsvToRgb(self._h, 1, 1),
		Size = UDim2.new(1, -(HUE_WIDTH + 10), 1, 0),
		BorderSizePixel = 0,
		Parent = self._content,
	})
	Utils.applyCorner(self._svPicker, 6)

	-- Black overlay for value
	-- Utils.create("ImageLabel", {
	-- 	Name = "ValueOverlay",
	-- 	Image = "rbxassetid://4155801252",
	-- 	ImageColor3 = Color3.new(0, 0, 0),
	-- 	BackgroundTransparency = 1,
	-- 	Size = UDim2.new(1, 0, 1, 0),
	-- 	Rotation = -90,
	-- 	Parent = self._svPicker,
	-- })

	-- SV Cursor
	self._svCursor = Utils.create("Frame", {
		Name = "Cursor",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 10, 0, 10),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Parent = self._svPicker,
	})
	Utils.applyCorner(self._svCursor, 5)
	Utils.applyStroke(self._svCursor, { Color = Color3.new(0, 0, 0), Thickness = 1 })

	-- Hue Picker
	self._huePicker = Utils.create("Frame", {
		Name = "HuePicker",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(0, HUE_WIDTH, 1, 0),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Parent = self._content,
	})
	Utils.applyCorner(self._huePicker, 6)

	Utils.create("UIGradient", {
		Name = "HueGradient",
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
			ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
			ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
		}),
		Rotation = 90,
		Parent = self._huePicker,
	})

	-- Hue Cursor
	self._hueCursor = Utils.create("Frame", {
		Name = "Cursor",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(1, 4, 0, 6),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Parent = self._huePicker,
	})
	Utils.applyCorner(self._hueCursor, 3)
	Utils.applyStroke(self._hueCursor, { Color = Color3.new(0, 0, 0), Thickness = 1 })

	-- Signal
	self.OnChanged = Signal.new()
	self.Changed = self.OnChanged -- Alias for Config system

	-- Click header to toggle (not the whole container)
	table.insert(
		self._connections,
		self._header.MouseButton1Click:Connect(function()
			self:Toggle()
		end)
	)

	-- Hover effects on header
	table.insert(
		self._connections,
		self._header.MouseEnter:Connect(function()
			TweenService:Create(
				self.Instance,
				TWEEN_FAST,
				{ BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(26, 26, 26) }
			):Play()
		end)
	)

	table.insert(
		self._connections,
		self._header.MouseLeave:Connect(function()
			if not self._expanded then
				TweenService:Create(
					self.Instance,
					TWEEN_FAST,
					{ BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(20, 20, 20) }
				):Play()
			end
		end)
	)

	-- Picker logic
	self:_setupPickerLogic()
	self:_updateVisuals()

	return self
end

function ColorPicker:_setupPickerLogic()
	table.insert(
		self._connections,
		self._svPicker.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				self._dragging = "sv"
				self:_updateSV(input)
			end
		end)
	)

	table.insert(
		self._connections,
		self._huePicker.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				self._dragging = "hue"
				self:_updateHue(input)
			end
		end)
	)

	table.insert(
		self._connections,
		UserInputService.InputChanged:Connect(function(input)
			if self._dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				if self._dragging == "sv" then
					self:_updateSV(input)
				else
					self:_updateHue(input)
				end
			end
		end)
	)

	table.insert(
		self._connections,
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				self._dragging = nil
			end
		end)
	)
end

function ColorPicker:_updateSV(input)
	local pos = self._svPicker.AbsolutePosition
	local size = self._svPicker.AbsoluteSize
	self._s = math.clamp((input.Position.X - pos.X) / size.X, 0, 1)
	self._v = 1 - math.clamp((input.Position.Y - pos.Y) / size.Y, 0, 1)
	self:_applyColor()
end

function ColorPicker:_updateHue(input)
	local pos = self._huePicker.AbsolutePosition
	local size = self._huePicker.AbsoluteSize
	self._h = math.clamp((input.Position.Y - pos.Y) / size.Y, 0, 1) * 360
	self._svPicker.BackgroundColor3 = hsvToRgb(self._h, 1, 1)
	self:_applyColor()
end

function ColorPicker:_applyColor()
	self._value = hsvToRgb(self._h, self._s, self._v)
	self._preview.BackgroundColor3 = self._value
	self._svCursor.Position = UDim2.new(self._s, 0, 1 - self._v, 0)
	self._hueCursor.Position = UDim2.new(0.5, 0, self._h / 360, 0)

	self.OnChanged:Fire(self._value)
	if self._callback then
		self._callback(self._value)
	end
end

function ColorPicker:_updateVisuals()
	self._svCursor.Position = UDim2.new(self._s, 0, 1 - self._v, 0)
	self._hueCursor.Position = UDim2.new(0.5, 0, self._h / 360, 0)
	self._svPicker.BackgroundColor3 = hsvToRgb(self._h, 1, 1)
end

function ColorPicker:Toggle()
	self._expanded = not self._expanded
	self._content.Visible = self._expanded

	if self._expanded then
		TweenService:Create(
			self.Instance,
			TWEEN_FAST,
			{ BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(26, 26, 26) }
		):Play()
	else
		TweenService:Create(
			self.Instance,
			TWEEN_FAST,
			{ BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(20, 20, 20) }
		):Play()
	end
end

function ColorPicker:GetValue(): Color3
	return self._value
end

function ColorPicker:SetValue(color: Color3)
	self._value = color
	self._h, self._s, self._v = rgbToHsv(color)
	self._preview.BackgroundColor3 = color
	self:_updateVisuals()
	self.OnChanged:Fire(self._value)
	return self
end

function ColorPicker:SetTitle(title: string)
	self._title.Text = title
	return self
end

function ColorPicker:Destroy()
	self.OnChanged:Destroy()
	Component.Destroy(self)
end

return ColorPicker
end function __TZAR_MODULES.u():typeof(__modImpl())local v=__TZAR_MODULES.cache.u if not v then v={c=__modImpl()}__TZAR_MODULES.cache.u=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - Section Component
    Collapsible section with header and content container
]]


local TweenService = game:GetService("TweenService")

local Utils = __TZAR_MODULES.e()
local Signal = __TZAR_MODULES.a()
local Component = __TZAR_MODULES.l()

-- Lazy load to avoid circular dependencies
local ButtonGroup
local Paragraph
local Button
local Toggle
local Slider
local Dropdown
local Keybind
local TextBox
local ColorPicker

local Section = setmetatable({}, Component)
Section.__index = Section

-- Tween presets - smooth animations
local TWEEN_SMOOTH = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local TWEEN_FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Header height constant
local HEADER_HEIGHT = 40

function Section.new(options, parentTab)
	local self = Component.new(options)
	setmetatable(self, Section)

	self._expanded = not (options.Collapsed or false)
	self._contentHeight = 0
	self._parentTab = parentTab -- Reference to parent Tab for registration

	-- Main section container
	self.Instance = Utils.create("Frame", {
		Name = "Section",
		BackgroundColor3 = Color3.fromRGB(16, 16, 16),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
		LayoutOrder = options.LayoutOrder or 0,
		ClipsDescendants = true,
	})

	Utils.applyCorner(self.Instance, 16)

	-- Header (clickable)
	self._header = Utils.create("ImageButton", {
		Name = "Header",
		Image = "rbxassetid://116513646251702",
		ImageColor3 = Color3.fromRGB(22, 22, 22),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
		AutoButtonColor = false,
		Parent = self.Instance,
	})

	-- Section name
	self._nameLabel = Utils.create("TextLabel", {
		Name = "Name",
		Text = options.Name or "Section",
		Font = Enum.Font.GothamMedium,
		TextSize = 16,
		TextColor3 = Color3.fromRGB(249, 249, 249),
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 12, 0, 0),
		Size = UDim2.new(1, -24, 1, 0),
		Parent = self._header,
	})

	-- Content container
	self._container = Utils.create("Frame", {
		Name = "Container",
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, HEADER_HEIGHT),
		Size = UDim2.new(1, 0, 0, 0),
		Parent = self.Instance,
	})

	Utils.applyListLayout(self._container, { Padding = 4 })
	Utils.applyPadding(self._container, 4, 4, 8, 4)

	-- Track content size changes
	table.insert(
		self._connections,
		self._container:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			self._contentHeight = self._container.AbsoluteSize.Y
			if self._expanded then
				self:_updateSize(false)
			end
		end)
	)

	-- Signals
	self.OnToggle = Signal.new()

	-- Header click to toggle
	table.insert(
		self._connections,
		self._header.MouseButton1Click:Connect(function()
			self:Toggle()
		end)
	)

	-- Hover effect on header
	table.insert(
		self._connections,
		self._header.MouseEnter:Connect(function()
			TweenService:Create(self._header, TWEEN_FAST, {
				ImageColor3 = Color3.fromRGB(26, 26, 26),
			}):Play()
		end)
	)

	table.insert(
		self._connections,
		self._header.MouseLeave:Connect(function()
			TweenService:Create(self._header, TWEEN_FAST, {
				ImageColor3 = Color3.fromRGB(22, 22, 22),
			}):Play()
		end)
	)

	-- Set initial size if expanded
	if self._expanded then
		task.defer(function()
			self:_updateSize(false)
		end)
	end

	return self
end

-- Update section size
function Section:_updateSize(animate: boolean)
	local targetHeight = HEADER_HEIGHT
	if self._expanded then
		targetHeight = HEADER_HEIGHT + self._contentHeight
	end

	if animate then
		TweenService:Create(self.Instance, TWEEN_SMOOTH, {
			Size = UDim2.new(1, 0, 0, targetHeight),
		}):Play()
	else
		self.Instance.Size = UDim2.new(1, 0, 0, targetHeight)
	end
end

-- Toggle expand/collapse
function Section:Toggle()
	if self._expanded then
		self:Collapse()
	else
		self:Expand()
	end
end

-- Expand section
function Section:Expand()
	self._expanded = true
	self:_updateSize(true)
	self.OnToggle:Fire(true)
end

-- Collapse section
function Section:Collapse()
	self._expanded = false
	self:_updateSize(true)
	self.OnToggle:Fire(false)
end

-- Check if expanded
function Section:IsExpanded(): boolean
	return self._expanded
end

-- Set section name
function Section:SetName(name: string)
	self._nameLabel.Text = name
	return self
end

-- Get the content container
function Section:GetContainer(): Frame
	return self._container
end

-- Helper to register element with CommandMenu
function Section:_registerElement(element, title, elementType)
	if self._parentTab and self._parentTab._window and self._parentTab._window.RegisterElement then
		self._parentTab._window:RegisterElement(element, self._parentTab, title, elementType)
	end
end

-- Add a button group
function Section:AddButtonGroup(options)
	if not ButtonGroup then
		ButtonGroup = __TZAR_MODULES.q()
	end
	local group = ButtonGroup.new(options or {})
	group:Mount(self._container)
	return group
end

-- Add a paragraph
function Section:AddParagraph(options)
	if not Paragraph then
		Paragraph = __TZAR_MODULES.n()
	end
	local para = Paragraph.new(options)
	para:Mount(self._container)
	self:_registerElement(para, options.Title or "Paragraph", "Paragraph")
	return para
end

-- Add a button
function Section:AddButton(options)
	if not Button then
		Button = __TZAR_MODULES.m()
	end
	local btn = Button.new(options)
	btn:Mount(self._container)
	self:_registerElement(btn, options.Name or "Button", "Button")
	return btn
end

-- Add a toggle
function Section:AddToggle(options)
	if not Toggle then
		Toggle = __TZAR_MODULES.r()
	end
	local toggle = Toggle.new(options)
	if options.Callback then
		toggle.OnToggle:Connect(options.Callback)
	end
	toggle:Mount(self._container)
	self:_registerElement(toggle, options.Title or "Toggle", "Toggle")
	return toggle
end

-- Add a slider
function Section:AddSlider(options)
	if not Slider then
		Slider = __TZAR_MODULES.o()
	end
	local slider = Slider.new(options)
	if options.Callback then
		slider.OnChanged:Connect(options.Callback)
	end
	slider:Mount(self._container)
	self:_registerElement(slider, options.Title or "Slider", "Slider")
	return slider
end

-- Add a dropdown
function Section:AddDropdown(options)
	if not Dropdown then
		Dropdown = __TZAR_MODULES.p()
	end
	local dropdown = Dropdown.new(options)
	if options.Callback then
		dropdown.OnChanged:Connect(options.Callback)
	end
	dropdown:Mount(self._container)
	self:_registerElement(dropdown, options.Title or "Dropdown", "Dropdown")
	return dropdown
end

-- Add a keybind
function Section:AddKeybind(options)
	if not Keybind then
		Keybind = __TZAR_MODULES.s()
	end
	local keybind = Keybind.new(options)
	keybind:Mount(self._container)
	self:_registerElement(keybind, options.Title or "Keybind", "Keybind")
	return keybind
end

-- Add a textbox
function Section:AddTextBox(options)
	if not TextBox then
		TextBox = __TZAR_MODULES.t()
	end
	local textbox = TextBox.new(options)
	textbox:Mount(self._container)
	self:_registerElement(textbox, options.Title or "TextBox", "TextBox")
	return textbox
end

-- Add a colorpicker
function Section:AddColorPicker(options)
	if not ColorPicker then
		ColorPicker = __TZAR_MODULES.u()
	end
	local colorpicker = ColorPicker.new(options)
	colorpicker:Mount(self._container)
	self:_registerElement(colorpicker, options.Title or "Color", "ColorPicker")
	return colorpicker
end

function Section:Destroy()
	self.OnToggle:Destroy()
	Component.Destroy(self)
end

return Section
end function __TZAR_MODULES.v():typeof(__modImpl())local v=__TZAR_MODULES.cache.v if not v then v={c=__modImpl()}__TZAR_MODULES.cache.v=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - Tab Class
    Represents a tab content area with methods to add components
]]

-- Lazy load to avoid circular dependencies

local Section
local ButtonGroup
local Paragraph
local Button
local Toggle
local Slider
local Dropdown
local Keybind
local TextBox
local ColorPicker

local Tab = {}
Tab.__index = Tab

function Tab.new(contentScroll, tabBtn, tabIndex, window, name)
	local self = setmetatable({}, Tab)

	self.Instance = contentScroll
	self.Button = tabBtn
	self.Index = tabIndex
	self.Name = name or ("Tab" .. tabIndex)
	self._window = window

	return self
end

-- Add a section to this tab
function Tab:AddSection(options)
	if not Section then
		Section = __TZAR_MODULES.v()
	end

	local sectionObj = Section.new({
		Name = options.Name or "Section",
		Flag = options.Flag or options.Name,
		Collapsed = options.Collapsed,
		LayoutOrder = options.LayoutOrder,
	}, self) -- Pass self (Tab) as parent for registration
	sectionObj.Instance.Parent = self.Instance
	return sectionObj
end

-- Add a button group to this tab
function Tab:AddButtonGroup(options)
	if not ButtonGroup then
		ButtonGroup = __TZAR_MODULES.q()
	end

	local group = ButtonGroup.new({
		LayoutOrder = options and options.LayoutOrder or nil,
	})
	group.Instance.Parent = self.Instance
	return group
end

-- Add a paragraph to this tab
function Tab:AddParagraph(options)
	if not Paragraph then
		Paragraph = __TZAR_MODULES.n()
	end

	local para = Paragraph.new({
		Title = options.Title or "Title",
		Description = options.Description,
		Callback = options.Callback,
		LayoutOrder = options.LayoutOrder,
	})
	para.Instance.Parent = self.Instance

	-- Register for search
	if self._window and self._window.RegisterElement then
		self._window:RegisterElement(para, self, options.Title or "Title", "Paragraph")
	end

	return para
end

-- Add a button to this tab
function Tab:AddButton(options)
	if not Button then
		Button = __TZAR_MODULES.m()
	end

	local btn = Button.new({
		Name = options.Name or "Button",
		Flag = options.Flag or options.Name,
		Variant = options.Variant or "Secondary",
		Callback = options.Callback,
		LayoutOrder = options.LayoutOrder,
	})
	btn.Instance.Parent = self.Instance

	-- Register for search
	if self._window and self._window.RegisterElement then
		self._window:RegisterElement(btn, self, options.Name or "Button", "Button")
	end

	return btn
end

-- Add a toggle to this tab
function Tab:AddToggle(options)
	if not Toggle then
		Toggle = __TZAR_MODULES.r()
	end

	local toggle = Toggle.new({
		Title = options.Title or "Toggle",
		Flag = options.Flag or options.Name or (self.Name .. options.Title),
		Description = options.Description,
		Default = options.Default,
		LayoutOrder = options.LayoutOrder,
	})

	if options.Callback then
		toggle.OnToggle:Connect(options.Callback)
	end

	toggle.Instance.Parent = self.Instance

	-- Register for search
	if self._window and self._window.RegisterElement then
		self._window:RegisterElement(toggle, self, options.Title or "Toggle", "Toggle")
	end

	return toggle
end

-- Add a slider to this tab
function Tab:AddSlider(options)
	if not Slider then
		Slider = __TZAR_MODULES.o()
	end

	local slider = Slider.new({
		Title = options.Title or "Slider",
		Flag = options.Flag or options.Name or (self.Name .. options.Title),
		Description = options.Description,
		Min = options.Min,
		Max = options.Max,
		Default = options.Default,
		Increment = options.Increment,
		Suffix = options.Suffix,
		LayoutOrder = options.LayoutOrder,
	})

	if options.Callback then
		slider.OnChanged:Connect(options.Callback)
	end

	slider.Instance.Parent = self.Instance

	-- Register for search
	if self._window and self._window.RegisterElement then
		self._window:RegisterElement(slider, self, options.Title or "Slider", "Slider")
	end

	return slider
end

-- Add a dropdown to this tab
function Tab:AddDropdown(options)
	if not Dropdown then
		Dropdown = __TZAR_MODULES.p()
	end

	local dropdown = Dropdown.new({
		Title = options.Title or "Dropdown",
		Flag = options.Flag or options.Name or (self.Name .. options.Title),
		Options = options.Options,
		Default = options.Default,
		Multi = options.Multi,
		Callback = options.Callback,
		LayoutOrder = options.LayoutOrder,
	})

	if options.Callback then
		dropdown.OnChanged:Connect(options.Callback)
	end

	dropdown.Instance.Parent = self.Instance

	-- Register for search
	if self._window and self._window.RegisterElement then
		self._window:RegisterElement(dropdown, self, options.Title or "Dropdown", "Dropdown")
	end

	return dropdown
end

-- Add a keybind to this tab
function Tab:AddKeybind(options)
	if not Keybind then
		Keybind = __TZAR_MODULES.s()
	end

	local keybind = Keybind.new({
		Title = options.Title or "Keybind",
		Flag = options.Flag or options.Name or (self.Name .. options.Title),
		Description = options.Description,
		Default = options.Default,
		Callback = options.Callback,
		LayoutOrder = options.LayoutOrder,
	})

	keybind.Instance.Parent = self.Instance

	-- Register for search
	if self._window and self._window.RegisterElement then
		self._window:RegisterElement(keybind, self, options.Title or "Keybind", "Keybind")
	end

	return keybind
end

-- Add a textbox to this tab
function Tab:AddTextBox(options)
	if not TextBox then
		TextBox = __TZAR_MODULES.t()
	end

	local textbox = TextBox.new({
		Title = options.Title or "TextBox",
		Flag = options.Flag or options.Name or (self.Name .. options.Title),
		Description = options.Description,
		Placeholder = options.Placeholder,
		Default = options.Default,
		ClearOnFocus = options.ClearOnFocus,
		Callback = options.Callback,
		LayoutOrder = options.LayoutOrder,
	})

	textbox.Instance.Parent = self.Instance

	if self._window and self._window.RegisterElement then
		self._window:RegisterElement(textbox, self, options.Title or "TextBox", "TextBox")
	end

	return textbox
end

-- Add a color picker to this tab
function Tab:AddColorPicker(options)
	if not ColorPicker then
		ColorPicker = __TZAR_MODULES.u()
	end

	local colorpicker = ColorPicker.new({
		Title = options.Title or "Color",
		Flag = options.Flag or options.Name or (self.Name .. options.Title),
		Default = options.Default,
		Callback = options.Callback,
		LayoutOrder = options.LayoutOrder,
	})

	colorpicker.Instance.Parent = self.Instance

	if self._window and self._window.RegisterElement then
		self._window:RegisterElement(colorpicker, self, options.Title or "Color", "ColorPicker")
	end

	return colorpicker
end

return Tab
end function __TZAR_MODULES.w():typeof(__modImpl())local v=__TZAR_MODULES.cache.w if not v then v={c=__modImpl()}__TZAR_MODULES.cache.w=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - Command Menu
    Search/command palette with element navigation
]]


local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Utils = __TZAR_MODULES.e()
local Signal = __TZAR_MODULES.a()

local CommandMenu = {}
CommandMenu.__index = CommandMenu

-- Tween presets
local TWEEN_FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_SMOOTH = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- Dimensions
local MENU_WIDTH = 400
local MENU_HEIGHT = 350
local RESULT_HEIGHT = 36

function CommandMenu.new(mainFrame)
	local self = setmetatable({}, CommandMenu)

	self._mainFrame = mainFrame
	self._elements = {} -- {element, tab, title, type}
	self._results = {}
	self._selectedIndex = 1
	self._visible = false

	local holder = Utils.create("Folder", {
		Name = "CommandMenuHolder",
		Parent = mainFrame.Instance,
	})

	-- Overlay
	self._overlay = Utils.create("Frame", {
		Name = "CommandMenuOverlay",
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Visible = false,
		ZIndex = 200,
		Parent = holder,
	})
	Utils.applyCorner(self._overlay, 18)

	-- Menu container
	self._menu = Utils.create("Frame", {
		Name = "CommandMenu",
		AnchorPoint = Vector2.new(0.5, 0.3),
		Position = UDim2.new(0.5, 0, 0.3, 0),
		Size = UDim2.new(0, MENU_WIDTH, 0, 0),
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 201,
		Parent = self._overlay,
	})
	Utils.applyCorner(self._menu, 12)
	Utils.applyStroke(self._menu, { Color = Color3.fromRGB(50, 50, 50), Thickness = 1 })

	-- Search input
	self._searchContainer = Utils.create("Frame", {
		Name = "SearchContainer",
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundTransparency = 1,
		ZIndex = 202,
		Parent = self._menu,
	})
	Utils.applyPadding(self._searchContainer, 12, 12, 12, 12)

	-- Search icon
	Utils.create("ImageLabel", {
		Name = "SearchIcon",
		Image = "rbxassetid://6031154871", -- Search icon
		ImageColor3 = Color3.fromRGB(100, 100, 100),
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, 18, 0, 18),
		BackgroundTransparency = 1,
		ZIndex = 203,
		Parent = self._searchContainer,
	})

	self._searchInput = Utils.create("TextBox", {
		Name = "SearchInput",
		Text = "",
		PlaceholderText = "Search elements...",
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
		TextXAlignment = Enum.TextXAlignment.Left,
		Position = UDim2.new(0, 28, 0, 0),
		Size = UDim2.new(1, -28, 1, 0),
		BackgroundTransparency = 1,
		ClearTextOnFocus = false,
		ZIndex = 203,
		Parent = self._searchContainer,
	})

	-- Separator
	Utils.create("Frame", {
		Name = "Separator",
		Position = UDim2.new(0, 0, 0, 50),
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		BorderSizePixel = 0,
		ZIndex = 202,
		Parent = self._menu,
	})

	-- Results container
	self._resultsContainer = Utils.create("ScrollingFrame", {
		Name = "Results",
		Position = UDim2.new(0, 0, 0, 51),
		Size = UDim2.new(1, 0, 1, -51),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60),
		BackgroundTransparency = 1,
		ZIndex = 202,
		Parent = self._menu,
	})
	Utils.applyListLayout(self._resultsContainer, { Padding = 2 })
	Utils.applyPadding(self._resultsContainer, 4, 8, 8, 8)

	-- No results label
	self._noResults = Utils.create("TextLabel", {
		Name = "NoResults",
		Text = "No elements found (0 registered)",
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = Color3.fromRGB(100, 100, 100),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 40),
		Visible = false,
		ZIndex = 203,
		Parent = self._resultsContainer,
	})

	-- Signals
	self.OnSelect = Signal.new()

	-- Search input changes
	self._searchInput:GetPropertyChangedSignal("Text"):Connect(function()
		self:_updateResults()
	end)

	-- Keyboard navigation
	UserInputService.InputBegan:Connect(function(input, processed)
		if not self._visible then
			return
		end

		if input.KeyCode == Enum.KeyCode.Escape then
			self:Hide()
		elseif input.KeyCode == Enum.KeyCode.Up then
			self:_selectPrevious()
		elseif input.KeyCode == Enum.KeyCode.Down then
			self:_selectNext()
		elseif input.KeyCode == Enum.KeyCode.Return then
			self:_confirmSelection()
		end
	end)

	-- Click overlay to close
	self._overlay.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local pos = input.Position
			local menuPos = self._menu.AbsolutePosition
			local menuSize = self._menu.AbsoluteSize

			if
				pos.X < menuPos.X
				or pos.X > menuPos.X + menuSize.X
				or pos.Y < menuPos.Y
				or pos.Y > menuPos.Y + menuSize.Y
			then
				self:Hide()
			end
		end
	end)

	return self
end

-- Register an element for search
function CommandMenu:RegisterElement(element, tab, title: string, elementType: string)
	table.insert(self._elements, {
		Element = element,
		Tab = tab,
		Title = title,
		Type = elementType or "Element",
	})
end

-- Update search results
function CommandMenu:_updateResults()
	-- Clear existing results
	for _, child in ipairs(self._resultsContainer:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	self._results = {}

	local query = self._searchInput.Text:lower()

	-- Filter elements
	local matches = {}
	for _, entry in ipairs(self._elements) do
		if query == "" or entry.Title:lower():find(query, 1, true) then
			table.insert(matches, entry)
		end
	end

	-- Show no results message if needed
	self._noResults.Text = "No elements found (" .. #self._elements .. " registered)"
	self._noResults.Visible = #matches == 0

	-- Create result items
	for i, entry in ipairs(matches) do
		local resultBtn = Utils.create("TextButton", {
			Name = "Result_" .. i,
			Text = "",
			Size = UDim2.new(1, 0, 0, RESULT_HEIGHT),
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			BackgroundTransparency = i == 1 and 0 or 1,
			AutoButtonColor = false,
			LayoutOrder = i,
			ZIndex = 203,
			Parent = self._resultsContainer,
		})
		Utils.applyCorner(resultBtn, 6)

		-- Type badge
		local badge = Utils.create("TextLabel", {
			Name = "Badge",
			Text = entry.Type,
			Font = Enum.Font.GothamMedium,
			TextSize = 10,
			TextColor3 = Color3.fromRGB(9, 156, 75),
			BackgroundColor3 = Color3.fromRGB(9, 156, 75),
			BackgroundTransparency = 0.85,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 8, 0.5, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 0, 18),
			ZIndex = 204,
			Parent = resultBtn,
		})
		Utils.applyCorner(badge, 4)
		Utils.applyPadding(badge, 0, 6, 0, 6)

		-- Title
		Utils.create("TextLabel", {
			Name = "Title",
			Text = entry.Title,
			Font = Enum.Font.Gotham,
			TextSize = 13,
			TextColor3 = Color3.fromRGB(220, 220, 220),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 80, 0, 0),
			Size = UDim2.new(1, -130, 1, 0),
			ZIndex = 204,
			Parent = resultBtn,
		})

		-- Tab name
		local tabName = entry.Tab and entry.Tab.Name or ""
		Utils.create("TextLabel", {
			Name = "Tab",
			Text = tabName,
			Font = Enum.Font.Gotham,
			TextSize = 11,
			TextColor3 = Color3.fromRGB(100, 100, 100),
			TextXAlignment = Enum.TextXAlignment.Right,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -8, 0.5, 0),
			Size = UDim2.new(0, 60, 1, 0),
			ZIndex = 204,
			Parent = resultBtn,
		})

		-- Hover
		resultBtn.MouseEnter:Connect(function()
			self:_selectIndex(i)
		end)

		-- Click
		resultBtn.MouseButton1Click:Connect(function()
			self:_selectIndex(i)
			self:_confirmSelection()
		end)

		table.insert(self._results, { Button = resultBtn, Entry = entry })
	end

	self._selectedIndex = math.min(1, #self._results)
	self:_updateSelection()
end

function CommandMenu:_selectIndex(index: number)
	self._selectedIndex = math.clamp(index, 1, math.max(1, #self._results))
	self:_updateSelection()
end

function CommandMenu:_selectNext()
	self:_selectIndex(self._selectedIndex + 1)
end

function CommandMenu:_selectPrevious()
	self:_selectIndex(self._selectedIndex - 1)
end

function CommandMenu:_updateSelection()
	for i, result in ipairs(self._results) do
		local isSelected = i == self._selectedIndex
		TweenService:Create(result.Button, TWEEN_FAST, {
			BackgroundTransparency = isSelected and 0 or 1,
		}):Play()
	end
end

function CommandMenu:_confirmSelection()
	local result = self._results[self._selectedIndex]
	if not result then
		return
	end

	local entry = result.Entry
	self:Hide()

	-- Navigate to element
	if entry.Tab and self._mainFrame then
		-- Find tab index
		for i, tab in ipairs(self._mainFrame._tabs) do
			if tab == entry.Tab then
				self._mainFrame:SelectTab(i)
				break
			end
		end

		-- Scroll to element and highlight
		task.defer(function()
			if entry.Element and entry.Element.Instance then
				local element = entry.Element.Instance
				local scrollFrame = element:FindFirstAncestorWhichIsA("ScrollingFrame")
				if scrollFrame then
					-- Scroll to element
					local elementPos = element.AbsolutePosition
					local scrollPos = scrollFrame.AbsolutePosition
					local offset = elementPos.Y - scrollPos.Y
					scrollFrame.CanvasPosition = Vector2.new(0, offset - 50)
				end

				-- Highlight effect
				local originalColor = element.BackgroundColor3
				TweenService:Create(element, TWEEN_FAST, {
					BackgroundColor3 = Color3.fromRGB(9, 156, 75),
					BackgroundTransparency = 0,
				}):Play()

				task.delay(0.5, function()
					TweenService:Create(element, TWEEN_FAST, {
						BackgroundColor3 = originalColor,
						BackgroundTransparency = 1,
					}):Play()
				end)
			end
		end)
	end

	self.OnSelect:Fire(entry)
end

function CommandMenu:Show()
	if self._visible then
		return
	end
	self._visible = true

	self._overlay.Visible = true
	self._overlay.BackgroundTransparency = 1
	self._menu.Size = UDim2.new(0, MENU_WIDTH, 0, 0)
	self._searchInput.Text = ""

	TweenService:Create(self._overlay, TWEEN_FAST, {
		BackgroundTransparency = 0.5,
	}):Play()

	TweenService:Create(self._menu, TWEEN_SMOOTH, {
		Size = UDim2.new(0, MENU_WIDTH, 0, MENU_HEIGHT),
	}):Play()

	-- Focus search
	task.delay(0.1, function()
		self._searchInput:CaptureFocus()
	end)

	self:_updateResults()
end

function CommandMenu:Hide()
	if not self._visible then
		return
	end
	self._visible = false

	self._searchInput:ReleaseFocus()

	TweenService:Create(self._overlay, TWEEN_FAST, {
		BackgroundTransparency = 1,
	}):Play()

	local tween = TweenService:Create(self._menu, TWEEN_FAST, {
		Size = UDim2.new(0, MENU_WIDTH, 0, 0),
	})
	tween:Play()
	tween.Completed:Wait()

	self._overlay.Visible = false
end

function CommandMenu:Toggle()
	if self._visible then
		self:Hide()
	else
		self:Show()
	end
end

function CommandMenu:Destroy()
	self.OnSelect:Destroy()
	self._overlay:Destroy()
end

return CommandMenu
end function __TZAR_MODULES.x():typeof(__modImpl())local v=__TZAR_MODULES.cache.x if not v then v={c=__modImpl()}__TZAR_MODULES.cache.x=v end return v.c end end do local function __modImpl()--[[
    Tzar UI Library - MainFrame
    Main window based on trash/mainframe.lua
]]


local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Utils = __TZAR_MODULES.e()
local Signal = __TZAR_MODULES.a()
local Config = __TZAR_MODULES.b()
local TabButton = __TZAR_MODULES.g()
local Tooltip = __TZAR_MODULES.h()
local Notification = __TZAR_MODULES.i()
local Tab = __TZAR_MODULES.w()
local CommandMenu = __TZAR_MODULES.x()

local MainFrame = {}
MainFrame.__index = MainFrame

-- Tween info presets
local TWEEN_FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_NORMAL = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_SMOOTH = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- Helper: animate button hover
local function setupButtonAnimations(button: TextButton, normalTransparency: number, hoverColor: Color3?)
	local defaultBg = button.BackgroundColor3
	local hoverBg = hoverColor or defaultBg

	button.AutoButtonColor = false

	button.MouseEnter:Connect(function()
		TweenService:Create(button, TWEEN_FAST, {
			BackgroundTransparency = 0,
			BackgroundColor3 = hoverBg,
		}):Play()
	end)

	button.MouseLeave:Connect(function()
		TweenService:Create(button, TWEEN_FAST, {
			BackgroundTransparency = normalTransparency,
			BackgroundColor3 = defaultBg,
		}):Play()
	end)

	button.MouseButton1Down:Connect(function()
		TweenService:Create(button, TWEEN_FAST, {
			BackgroundTransparency = 0,
			BackgroundColor3 = hoverBg:Lerp(Color3.new(0, 0, 0), 0.2),
		}):Play()
	end)

	button.MouseButton1Up:Connect(function()
		TweenService:Create(button, TWEEN_FAST, {
			BackgroundTransparency = 0,
			BackgroundColor3 = hoverBg,
		}):Play()
	end)
end

-- Helper: setup dragging
local function setupDragging(dragHandle: GuiObject, targetFrame: GuiObject)
	local dragging = false
	local dragStart = Vector2.zero
	local startPos = UDim2.new()

	dragHandle.InputBegan:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			dragging = true
			dragStart = Vector2.new(input.Position.X, input.Position.Y)
			startPos = targetFrame.Position
		end
	end)

	dragHandle.InputEnded:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if
			dragging
			and (
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			)
		then
			local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
			targetFrame.Position =
				UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

function MainFrame.new(options)
	local self = setmetatable({}, MainFrame)
	options = options or {}

	-- Tab management
	self._tabs = {}
	self._activeTab = nil
	self._minimized = false
	self._dialogOpen = false
	self._minimizeKey = options.MinimizeKey

	local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end
	-- ScreenGui
	self.ScreenGui = Utils.create("ScreenGui", {
		Name = "TzarUI",
		IgnoreGuiInset = false,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = game:GetService("CoreGui"),
	})
	ProtectGui(self.ScreenGui)

	-- Main Frame
	self.Instance = Utils.create("Frame", {
		Name = "Main",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(11, 11, 11),
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 616, 0, 444),
		Parent = self.ScreenGui,
	})

	Utils.applyCorner(self.Instance, 18)
	Utils.applyStroke(self.Instance, { Color = Color3.fromRGB(65, 65, 65) })
	Utils.applyPadding(self.Instance, 2, 2, 2, 2)
	Utils.applyListLayout(self.Instance, { Padding = 2 })

	-- TopBar
	self._topBar = Utils.create("ImageLabel", {
		Name = "TopBar",
		Image = "rbxassetid://81315260945695",
		ImageColor3 = Color3.fromRGB(22, 22, 22),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 48),
		Active = true, -- Required for input events
		Parent = self.Instance,
	})

	-- Setup dragging on topbar
	setupDragging(self._topBar, self.Instance)

	-- Logo
	self._logo = Utils.create("ImageLabel", {
		Name = "Logo",
		Image = "rbxassetid://136939379308753",
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 18, 0.5, 0),
		Size = UDim2.new(0, 29, 0, 22),
		Parent = self._topBar,
	})

	-- Title
	self._title = Utils.create("TextLabel", {
		Name = "Title",
		Text = 'TZAR<font size="18" color="rgb(128,128,128)">.cc</font>',
		RichText = true,
		Font = Enum.Font.GothamBold,
		TextSize = 22,
		TextColor3 = Color3.fromRGB(249, 249, 249),
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 56, 0, 0),
		Size = UDim2.new(0, 200, 1, 0),
		Parent = self._topBar,
	})

	-- Buttons container
	self._buttonsFrame = Utils.create("Frame", {
		Name = "Buttons",
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.new(0, 0, 1, 0),
		Parent = self._topBar,
	})

	Utils.applyListLayout(self._buttonsFrame, {
		Padding = 8,
		Direction = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})

	-- Search button
	self._searchBtn = Utils.create("TextButton", {
		Name = "Search",
		Text = "",
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(26, 26, 26),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = -1,
		Parent = self._buttonsFrame,
	})
	Utils.applyCorner(self._searchBtn)
	Utils.applyPadding(self._searchBtn, 8, 8, 8, 8)

	Utils.create("ImageLabel", {
		Name = "Icon",
		Image = "rbxassetid://6031154871",
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 16, 0, 16),
		Parent = self._searchBtn,
	})

	setupButtonAnimations(self._searchBtn, 1, Color3.fromRGB(26, 26, 26))

	-- Minimize button
	self._minimizeBtn = Utils.create("TextButton", {
		Name = "Minimize",
		Text = "",
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(26, 26, 26),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = self._buttonsFrame,
	})
	Utils.applyCorner(self._minimizeBtn)
	Utils.applyPadding(self._minimizeBtn, 8, 8, 8, 8)

	self._minimizeIcon = Utils.create("ImageLabel", {
		Name = "Icon",
		Image = "rbxassetid://15269257100",
		ImageRectOffset = Vector2.new(514, 257),
		ImageRectSize = Vector2.new(256, 256),
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 16, 0, 16),
		Parent = self._minimizeBtn,
	})

	-- Close button
	self._closeBtn = Utils.create("TextButton", {
		Name = "Close",
		Text = "",
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(26, 26, 26),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 1,
		Parent = self._buttonsFrame,
	})
	Utils.applyCorner(self._closeBtn)
	Utils.applyPadding(self._closeBtn, 8, 8, 8, 8)

	self._closeIcon = Utils.create("ImageLabel", {
		Name = "Icon",
		Image = "rbxassetid://15269329696",
		ImageRectOffset = Vector2.new(0, 514),
		ImageRectSize = Vector2.new(256, 256),
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 16, 0, 16),
		Parent = self._closeBtn,
	})

	-- Setup button animations
	setupButtonAnimations(self._minimizeBtn, 1, Color3.fromRGB(26, 26, 26))
	setupButtonAnimations(self._closeBtn, 1, Color3.fromRGB(180, 50, 50))

	-- MainSection (TabContainer + Content)
	self._mainSection = Utils.create("Frame", {
		Name = "MainSection",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, -50),
		Parent = self.Instance,
	})

	Utils.applyListLayout(self._mainSection, {
		Padding = 2,
		Direction = Enum.FillDirection.Horizontal,
	})

	-- TabContainer
	self._tabContainer = Utils.create("ImageLabel", {
		Name = "TabContainer",
		Image = "rbxassetid://113165827406336",
		ImageColor3 = Color3.fromRGB(22, 22, 22),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 200, 1, 0),
		Parent = self._mainSection,
	})

	-- Tabs scroll
	self._tabsScroll = Utils.create("ScrollingFrame", {
		Name = "TabsIn",
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarImageColor3 = Color3.fromRGB(128, 128, 128),
		ScrollBarThickness = 2,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Parent = self._tabContainer,
	})
	Utils.applyListLayout(self._tabsScroll, { Padding = 2 })
	Utils.applyPadding(self._tabsScroll, 2, 2, 2, 2)

	-- Content Container
	self._container = Utils.create("Frame", {
		Name = "Container",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Parent = self._mainSection,
		ClipsDescendants = true,
	})
	Utils.applyFlex(self._container)

	-- Page layout for content with smooth transitions
	self._pageLayout = Utils.create("UIPageLayout", {
		Name = "PageLayout",
		SortOrder = Enum.SortOrder.LayoutOrder,
		Animated = true,
		TweenTime = 0.3,
		EasingStyle = Enum.EasingStyle.Quint,
		EasingDirection = Enum.EasingDirection.Out,
		Parent = self._container,
	})

	-- Create Mini-bar (shown when minimized)
	self:_createMiniBar()

	-- Create Close Dialog
	self:_createCloseDialog()

	-- Create notification container
	self:_createNotificationContainer()

	-- Initialize Tooltip system
	Tooltip:_init(self.ScreenGui)

	-- Create Command Menu
	self._commandMenu = CommandMenu.new(self)

	-- Signals
	self.OnClose = Signal.new()
	self.OnMinimize = Signal.new()

	-- Search button click
	self._searchBtn.MouseButton1Click:Connect(function()
		self._commandMenu:Toggle()
	end)

	-- Close: show confirmation dialog
	self._closeBtn.MouseButton1Click:Connect(function()
		self:_showCloseDialog()
	end)

	-- Minimize: show mini-bar
	self._minimizeBtn.MouseButton1Click:Connect(function()
		self.OnMinimize:Fire()
		self:Minimize()
	end)

	-- Global keyboard listener for MinimizeKey (works even when minimized)
	if self._minimizeKey then
		UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then
				return
			end
			if input.KeyCode == self._minimizeKey then
				self:Toggle()
			end
		end)
	end

	-- Create Settings tab
	self:_createSettingsTab()

	-- Animate in on creation
	self:AnimateOpen()

	return self
end

-- Create the mini-bar that shows when minimized
function MainFrame:_createMiniBar()
	self._miniBar = Utils.create("Frame", {
		Name = "MiniBar",
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = Color3.fromRGB(11, 11, 11),
		Position = UDim2.new(0.5, 0, 0, 10),
		Size = UDim2.new(0, 140, 0, 40),
		Visible = false,
		Parent = self.ScreenGui,
	})
	Utils.applyCorner(self._miniBar, 12)
	Utils.applyStroke(self._miniBar, { Color = Color3.fromRGB(65, 65, 65) })

	-- Make mini-bar draggable
	setupDragging(self._miniBar, self._miniBar)

	-- Mini logo
	Utils.create("ImageLabel", {
		Name = "Logo",
		Image = "rbxassetid://136939379308753",
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0.5, 0),
		Size = UDim2.new(0, 22, 0, 17),
		Parent = self._miniBar,
	})

	-- Mini title
	Utils.create("TextLabel", {
		Name = "Title",
		Text = "TZAR",
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(200, 200, 200),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 40, 0, 0),
		Size = UDim2.new(0, 50, 1, 0),
		Parent = self._miniBar,
	})

	-- Restore button
	local restoreBtn = Utils.create("TextButton", {
		Name = "Restore",
		Text = "",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.new(0, 28, 0, 28),
		BackgroundColor3 = Color3.fromRGB(9, 156, 75),
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
		Parent = self._miniBar,
	})
	Utils.applyCorner(restoreBtn, 6)

	-- Restore icon (expand)
	Utils.create("ImageLabel", {
		Name = "Icon",
		Image = "rbxassetid://6035047409", -- Expand icon
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 14, 0, 14),
		Parent = restoreBtn,
	})

	-- Restore button click
	restoreBtn.MouseButton1Click:Connect(function()
		self:Restore()
	end)

	-- Hover effect
	restoreBtn.MouseEnter:Connect(function()
		TweenService:Create(restoreBtn, TWEEN_FAST, {
			BackgroundColor3 = Color3.fromRGB(11, 180, 87),
			BackgroundTransparency = 0,
		}):Play()
	end)
	restoreBtn.MouseLeave:Connect(function()
		TweenService:Create(restoreBtn, TWEEN_FAST, {
			BackgroundColor3 = Color3.fromRGB(9, 156, 75),
			BackgroundTransparency = 0.1,
		}):Play()
	end)
end

-- Create close confirmation dialog
function MainFrame:_createCloseDialog()
	-- Dialog overlay (inside MainFrame)
	local huy = Utils.create("Folder", {
		Name = "DialogOverlay",
		Parent = self.Instance,
	})
	self._dialogOverlay = Utils.create("Frame", {
		Name = "DialogOverlay",
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Visible = false,
		ZIndex = 100,
		Parent = huy,
	})
	Utils.applyCorner(self._dialogOverlay, 18)

	-- Dialog frame
	self._dialog = Utils.create("Frame", {
		Name = "CloseDialog",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(18, 18, 18),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 280, 0, 140),
		ZIndex = 101,
		Parent = self._dialogOverlay,
	})
	Utils.applyCorner(self._dialog, 12)
	Utils.applyStroke(self._dialog, { Color = Color3.fromRGB(50, 50, 50) })
	Utils.applyPadding(self._dialog, 16, 16, 16, 16)

	-- Dialog title
	Utils.create("TextLabel", {
		Name = "Title",
		Text = "Close Application?",
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 20),
		ZIndex = 102,
		Parent = self._dialog,
	})

	-- Dialog description
	Utils.create("TextLabel", {
		Name = "Description",
		Text = "Are you sure you want to close? All unsaved changes will be lost.",
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = Color3.fromRGB(150, 150, 150),
		TextWrapped = true,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 28),
		Size = UDim2.new(1, 0, 0, 40),
		ZIndex = 102,
		Parent = self._dialog,
	})

	-- Button container
	local buttonContainer = Utils.create("Frame", {
		Name = "Buttons",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 32),
		ZIndex = 102,
		Parent = self._dialog,
	})
	Utils.applyListLayout(buttonContainer, {
		Padding = 10,
		Direction = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
	})

	-- Cancel button
	local cancelBtn = Utils.create("TextButton", {
		Name = "Cancel",
		Text = "Cancel",
		Font = Enum.Font.GothamMedium,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(200, 200, 200),
		BackgroundColor3 = Color3.fromRGB(35, 35, 35),
		Size = UDim2.new(0, 100, 0, 32),
		ZIndex = 103,
		AutoButtonColor = false,
		Parent = buttonContainer,
	})
	Utils.applyCorner(cancelBtn, 8)

	-- Close button
	local confirmBtn = Utils.create("TextButton", {
		Name = "Confirm",
		Text = "Close",
		Font = Enum.Font.GothamMedium,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundColor3 = Color3.fromRGB(180, 50, 50),
		Size = UDim2.new(0, 100, 0, 32),
		ZIndex = 103,
		AutoButtonColor = false,
		Parent = buttonContainer,
	})
	Utils.applyCorner(confirmBtn, 8)

	-- Cancel click
	cancelBtn.MouseButton1Click:Connect(function()
		self:_hideCloseDialog()
	end)

	-- Confirm click
	confirmBtn.MouseButton1Click:Connect(function()
		self:_hideCloseDialog()
		self.OnClose:Fire()
		self:AnimateClose()
	end)

	-- Button hover effects
	cancelBtn.MouseEnter:Connect(function()
		TweenService:Create(cancelBtn, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(45, 45, 45) }):Play()
	end)
	cancelBtn.MouseLeave:Connect(function()
		TweenService:Create(cancelBtn, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(35, 35, 35) }):Play()
	end)

	confirmBtn.MouseEnter:Connect(function()
		TweenService:Create(confirmBtn, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(200, 60, 60) }):Play()
	end)
	confirmBtn.MouseLeave:Connect(function()
		TweenService:Create(confirmBtn, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(180, 50, 50) }):Play()
	end)

	-- Click overlay to cancel
	self._dialogOverlay.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			-- Check if click is outside dialog
			local pos = input.Position
			local dialogPos = self._dialog.AbsolutePosition
			local dialogSize = self._dialog.AbsoluteSize

			if
				pos.X < dialogPos.X
				or pos.X > dialogPos.X + dialogSize.X
				or pos.Y < dialogPos.Y
				or pos.Y > dialogPos.Y + dialogSize.Y
			then
				self:_hideCloseDialog()
			end
		end
	end)
end

function MainFrame:_showCloseDialog()
	if self._dialogOpen then
		return
	end
	self._dialogOpen = true

	self._dialogOverlay.Visible = true
	self._dialogOverlay.BackgroundTransparency = 1
	self._dialog.Size = UDim2.new(0, 280, 0, 0)

	TweenService:Create(self._dialogOverlay, TWEEN_FAST, {
		BackgroundTransparency = 0.5,
	}):Play()

	TweenService:Create(self._dialog, TWEEN_SMOOTH, {
		Size = UDim2.new(0, 280, 0, 140),
	}):Play()
end

function MainFrame:_hideCloseDialog()
	if not self._dialogOpen then
		return
	end
	self._dialogOpen = false

	TweenService:Create(self._dialogOverlay, TWEEN_FAST, {
		BackgroundTransparency = 1,
	}):Play()

	local tween = TweenService:Create(self._dialog, TWEEN_FAST, {
		Size = UDim2.new(0, 280, 0, 0),
	})
	tween:Play()
	tween.Completed:Wait()
	self._dialogOverlay.Visible = false
end

-- Add a new tab
function MainFrame:AddTab(options)
	local tabIndex = #self._tabs + 1

	-- Create tab button
	local tabBtn = TabButton.new({
		Name = options.Name or "Tab " .. tabIndex,
		Icon = options.Icon,
		IconOffset = options.IconOffset,
		IconSize = options.IconSize,
		LayoutOrder = options.LayoutOrder or tabIndex,
	})
	tabBtn.Instance.Parent = self._tabsScroll

	-- Create content scroll frame for this tab
	local contentScroll = Utils.create("ScrollingFrame", {
		Name = options.Name or "Tab" .. tabIndex,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarImageColor3 = Color3.fromRGB(45, 45, 45),
		ScrollBarThickness = 0,
		Active = true,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		LayoutOrder = tabIndex,
		Parent = self._container,
		ClipsDescendants = true,
	})
	Utils.applyPadding(contentScroll, 0, 4, 4, 4)
	Utils.applyListLayout(contentScroll, { Padding = 4 })

	-- Create Tab object
	local tab = Tab.new(contentScroll, tabBtn, tabIndex, self, options.Name)

	-- Store tab info
	table.insert(self._tabs, tab)

	-- Tab click handler
	tabBtn.OnClick:Connect(function()
		self:SelectTab(tabIndex)
	end)

	-- Auto-select first tab
	if tabIndex == 1 then
		self:SelectTab(1)
	end

	-- Return Tab object
	return tab
end

-- Select tab by index
function MainFrame:SelectTab(index: number)
	local tab = self._tabs[index]
	if not tab then
		return
	end

	-- Deselect previous tab
	if self._activeTab then
		self._activeTab.Button:SetActive(false)
	end

	-- Select new tab
	self._activeTab = tab
	tab.Button:SetActive(true)

	-- Switch page
	self._pageLayout:JumpTo(tab.Instance)
end

-- Animate window open
function MainFrame:AnimateOpen()
	self.Instance.Size = UDim2.new(0, 616, 0, 0)
	self.Instance.BackgroundTransparency = 1

	local tween = TweenService:Create(self.Instance, TWEEN_SMOOTH, {
		Size = UDim2.new(0, 616, 0, 444),
		BackgroundTransparency = 0,
	})
	tween:Play()
end

-- Animate window close
function MainFrame:AnimateClose()
	local tween = TweenService:Create(self.Instance, TWEEN_NORMAL, {
		Size = UDim2.new(0, 616, 0, 0),
		BackgroundTransparency = 1,
	})
	tween:Play()
	tween.Completed:Wait()
	self:Destroy()
end

-- Minimize to mini-bar
function MainFrame:Minimize()
	if self._minimized then
		return
	end
	self._minimized = true

	-- Animate main window out
	local tween = TweenService:Create(self.Instance, TWEEN_NORMAL, {
		Size = UDim2.new(0, 616, 0, 0),
		BackgroundTransparency = 1,
	})
	tween:Play()
	tween.Completed:Wait()
	self.Instance.Visible = false

	-- Show mini-bar
	self._miniBar.Visible = true
	self._miniBar.Size = UDim2.new(0, 0, 0, 40)
	TweenService:Create(self._miniBar, TWEEN_SMOOTH, {
		Size = UDim2.new(0, 140, 0, 40),
	}):Play()
end

-- Restore from mini-bar
function MainFrame:Restore()
	if not self._minimized then
		return
	end
	self._minimized = false

	-- Hide mini-bar
	local miniTween = TweenService:Create(self._miniBar, TWEEN_FAST, {
		Size = UDim2.new(0, 0, 0, 40),
	})
	miniTween:Play()
	miniTween.Completed:Wait()
	self._miniBar.Visible = false

	-- Show main window
	self.Instance.Visible = true
	self.Instance.Size = UDim2.new(0, 616, 0, 0)
	self.Instance.BackgroundTransparency = 1

	TweenService:Create(self.Instance, TWEEN_SMOOTH, {
		Size = UDim2.new(0, 616, 0, 444),
		BackgroundTransparency = 0,
	}):Play()
end

-- Toggle minimize/restore
function MainFrame:Toggle()
	if self._minimized then
		self:Restore()
	else
		self:Minimize()
	end
end

function MainFrame:Destroy()
	self.OnClose:Destroy()
	self.OnMinimize:Destroy()
	if self._commandMenu then
		self._commandMenu:Destroy()
	end
	self.ScreenGui:Destroy()
end

-- Create notification container
function MainFrame:_createNotificationContainer()
	self._notifContainer = Utils.create("Frame", {
		Name = "Notifications",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 10),
		Size = UDim2.new(0, 320, 1, -20),
		BackgroundTransparency = 1,
		Parent = self.ScreenGui,
	})
	self._notifications = {}
end

-- Show notification
function MainFrame:Notify(options)
	local notif = Notification.new({
		Title = options.Title or "Notification",
		Message = options.Message or options.Description,
		Duration = options.Duration or 5,
		Action = options.Action,
		ActionCallback = options.ActionCallback,
	})
	notif.Instance.Parent = self._notifContainer

	-- Calculate position
	local yOffset = 0
	for _, n in ipairs(self._notifications) do
		if not n:IsDismissed() then
			yOffset = yOffset + 80
		end
	end

	notif:Show(yOffset)
	table.insert(self._notifications, notif)

	-- Clean up dismissed notifications periodically
	task.delay(6, function()
		self:_cleanupNotifications()
	end)

	return notif
end

function MainFrame:_cleanupNotifications()
	local activeNotifs = {}
	local yOffset = 0

	for _, notif in ipairs(self._notifications) do
		if not notif:IsDismissed() then
			notif:UpdatePosition(yOffset)
			yOffset = yOffset + 80
			table.insert(activeNotifs, notif)
		end
	end

	self._notifications = activeNotifs
end

-- Register element for search
function MainFrame:RegisterElement(element, tab, title: string, elementType: string)
	if self._commandMenu then
		self._commandMenu:RegisterElement(element, tab, title, elementType)
	end
end

-- Get command menu
function MainFrame:GetCommandMenu()
	return self._commandMenu
end

-- Create Settings tab
function MainFrame:_createSettingsTab()
	local settingsTab = self:AddTab({
		Name = "Settings",
		Icon = "settings", -- Uses new icons system
		LayoutOrder = 9999,
	})

	local configSection = settingsTab:AddSection({
		Name = "Configuration",
	})

	-- AutoSave toggle
	configSection:AddToggle({
		Title = "Auto Save",
		Description = "Automatically save config when values change",
		Default = Config.AutoSave,
		Callback = function(value)
			Config.AutoSave = value
			Config:SaveMetrics()
		end,
	})

	-- AutoLoad toggle
	configSection:AddToggle({
		Title = "Auto Load",
		Description = "Automatically load selected config on startup",
		Default = Config.AutoLoad,
		Callback = function(value)
			Config.AutoLoad = value
			Config:SaveMetrics()
		end,
	})

	-- Profile selection
	local profileDropdown = configSection:AddDropdown({
		Title = "Profile",
		Options = Config.Profiles,
		Default = Config.ActiveProfile,
		Callback = function(value)
			Config:SwitchProfile(value)
		end,
	})

	-- Create new profile
	local nameInput = configSection:AddTextBox({
		Title = "New Profile Name",
		Placeholder = "Enter name...",
		ClearOnFocus = true,
	})

	configSection:AddButton({
		Name = "Create Profile",
		Callback = function()
			local name = nameInput:GetValue()
			if name and name ~= "" then
				Config:CreateProfile(name)
				profileDropdown:Refresh(Config.Profiles, Config.ActiveProfile)
				nameInput:SetValue("")
			end
		end,
	})

	-- Config actions
	local group = settingsTab:AddButtonGroup()

	group:AddButton({
		Name = "Save Config",
		Variant = "Primary",
		Callback = function()
			Config:Save()
			-- Show notification
			if self.ScreenGui then
				local NotificationObj = __TZAR_MODULES.i()
.new({
					Title = "Success",
					Description = "Configuration saved successfully!",
					Icon = "check",
					Duration = 3,
				})
				NotificationObj:Show(self.ScreenGui)
			end
		end,
	})

	group:AddButton({
		Name = "Load Config",
		Callback = function()
			Config:Load()
			-- Refresh values in UI if needed (components auto-update via SetValue)
			if self.ScreenGui then
				local NotificationObj = __TZAR_MODULES.i()
.new({
					Title = "Loaded",
					Description = "Configuration loaded successfully!",
					Icon = "check",
					Duration = 3,
				})
				NotificationObj:Show(self.ScreenGui)
			end
		end,
	})

	configSection:AddButton({
		Name = "Delete Profile",
		Variant = "Destroy",
		Callback = function()
			if Config.ActiveProfile == "Default" then
				return
			end
			Config:DeleteProfile(Config.ActiveProfile)
			profileDropdown:Refresh(Config.Profiles, Config.ActiveProfile)
		end,
	})

	local uiSection = settingsTab:AddSection({
		Name = "Interface",
	})

	uiSection:AddButton({
		Name = "Unload UI",
		Variant = "Destroy",
		Callback = function()
			self:AnimateClose()
		end,
	})
end

return MainFrame
end function __TZAR_MODULES.y():typeof(__modImpl())local v=__TZAR_MODULES.cache.y if not v then v={c=__modImpl()}__TZAR_MODULES.cache.y=v end return v.c end end end--[[
    Tzar UI Library
    Main entry point with fluent API
]]

local Config = __TZAR_MODULES.b()
local MainFrame = __TZAR_MODULES.y()
local Section = __TZAR_MODULES.v()
local ButtonGroup = __TZAR_MODULES.q()
local Button = __TZAR_MODULES.m()
local Paragraph = __TZAR_MODULES.n()
local Toggle = __TZAR_MODULES.r()
local Slider = __TZAR_MODULES.o()
local Dropdown = __TZAR_MODULES.p()
local Keybind = __TZAR_MODULES.s()
local TextBox = __TZAR_MODULES.t()
local ColorPicker = __TZAR_MODULES.u()
local Tooltip = __TZAR_MODULES.h()
local Notification = __TZAR_MODULES.i()
local TabButton = __TZAR_MODULES.g()

--// Tzar Library
local Tzar = {}
Tzar.Flags = Config.Flags
Config:Init()

--// Create new window
function Tzar.new(options)
	return MainFrame.new(options)
end

--// Expose components for direct access
Tzar.Components = {
	MainFrame = MainFrame,
	Section = Section,
	ButtonGroup = ButtonGroup,
	Button = Button,
	Paragraph = Paragraph,
	Toggle = Toggle,
	Slider = Slider,
	Dropdown = Dropdown,
	Keybind = Keybind,
	TextBox = TextBox,
	ColorPicker = ColorPicker,
	Tooltip = Tooltip,
	Notification = Notification,
	TabButton = TabButton,
}

--// Shorthand constructors
function Tzar.CreateButton(options)
	return Button.new(options)
end

function Tzar.CreateParagraph(options)
	return Paragraph.new(options)
end

function Tzar.CreateToggle(options)
	return Toggle.new(options)
end

function Tzar.CreateSlider(options)
	return Slider.new(options)
end

function Tzar.CreateSection(options)
	return Section.new(options)
end

function Tzar.CreateButtonGroup(options)
	return ButtonGroup.new(options)
end

function Tzar.CreateDropdown(options)
	return Dropdown.new(options)
end

function Tzar.CreateKeybind(options)
	return Keybind.new(options)
end

function Tzar.CreateTextBox(options)
	return TextBox.new(options)
end

function Tzar.CreateColorPicker(options)
	return ColorPicker.new(options)
end

return Tzar
