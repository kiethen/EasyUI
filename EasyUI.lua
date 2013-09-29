local _class = {}

-- Lua OOP
local function class(super)
	local class_type = {}
	class_type.ctor = false
	class_type.super = super
	class_type.new = function(...)
		local obj = {}
		setmetatable(obj, { __index = _class[class_type]})
		do
			local create
			create = function(c, ...)
				if c.super then
					create(c.super, ...)
				end
				if c.ctor then
					c.ctor(obj, ...)
				end
			end
			create(class_type, ...)
		end
		return obj
	end
	local vtbl = {}
	_class[class_type] = vtbl

	setmetatable(class_type,{__newindex =
		function(t, k, v)
			vtbl[k] = v
		end
	})

	if super then
		setmetatable(vtbl,{__index =
			function(t, k)
				local ret = _class[super][k]
				vtbl[k] = ret
				return ret
			end
		})
	end

	return class_type
end

local __ini = "Interface/EasyUI/ini/%s.ini"

-- Append WndType Control
local _AppendWnd = function(__parent, __type, __name)
	if __parent.__addon then
		__parent = __parent:GetSelf()
	end
	local hwnd = Wnd.OpenWindow(string.format(__ini, __type), __name):Lookup(__type)
	hwnd:ChangeRelation(__parent, true, true)
	hwnd:SetName(__name)
	Wnd.CloseWindow(__name)
	return hwnd
end

-- Base Class of WndType Control
local WndBase = class()
function WndBase:ctor(__this)
	self.__addon = true
	self.__listeners = {self}
end

function WndBase:GetName()
	return self.__this:GetName()
end

function WndBase:SetSelf(__this)
	self.__this = __this
end

function WndBase:GetSelf()
	return self.__this
end

function WndBase:SetSize(...)
	self.__this:SetSize(...)
end

function WndBase:GetSize()
	return self.__this:GetSize()
end

function WndBase:SetRelPos(...)
	self.__this:SetRelPos(...)
end

function WndBase:GetRelPos()
	return self.__this:GetRelPos()
end

function WndBase:SetAbsPos(...)
	self.__this:SetAbsPos(...)
end

function WndBase:GetAbsPos()
	return self.__this:GetAbsPos()
end

function WndBase:Enable(__enable)
	self.__this:Enable(__enable)
end

function WndBase:SetParent(__parent)
	self.__parent = __parent
end

function WndBase:GetParent()
	return self.__parent
end

function WndBase:SetType(__type)
	self.__type = __type
end

function WndBase:GetType()
	return self.__type
end

function WndBase:Destroy()
	if self:GetType() == "WndFrame" then
		Wnd.CloseWindow(self:GetName())
	else
		self.__this:Destroy()
	end
end

function WndBase:Show()
	self.__this:Show()
end

function WndBase:Hide()
	self.__this:Hide()
end

function WndBase:_FireEvent(__event, ...)
	for __k, __v in pairs(self.__listeners) do
		if __v[__event] then
			local res, err = pcall(__v[__event], ...)
			if not res then
				OutputMessage("MSG_SYS", "ERROR:" .. err .."\n")
			end
		end
	end
end

local WndFrame = class(WndBase)
function WndFrame:ctor(__name, __data)
	assert(__name ~= nil, "frame name can not be null.")
	__data = __data or {}
	local frame = nil
	if __data.style == "THIN" then
		frame = Wnd.OpenWindow(string.format(__ini, "WndFrameThin"), __name)
	elseif __data.style == "SMALL" then
		frame = Wnd.OpenWindow(string.format(__ini, "WndFrameSmall"), __name)
	elseif __data.style == "NORMAL" then
		frame = Wnd.OpenWindow(string.format(__ini, "WndFrame"), __name)
	elseif __data.style == "LARGER" then
		frame = Wnd.OpenWindow(string.format(__ini, "WndFrameLarger"), __name)
	elseif __data.style == "NONE" then
		frame = Wnd.OpenWindow(string.format(__ini, "WndFrameNone"), __name)
	end
	frame:SetName(__name)
	self.__this = frame
	self:SetSelf(self.__this)
	self:SetType("WndFrame")
	if __data.style and __data.style ~= "NONE" then
		frame:Lookup("Btn_Close").OnLButtonClick = function()
			self:Destroy()
		end
		if __data.title then
			self:SetTitle(__data.title)
		end
	end

	--Bind Frame Events
	--[[frame.OnFrameBreathe = function()
		self:_FireEvent("OnUpdate")
	end
	frame.OnFrameRender = function()
		self:_FireEvent("OnRender")
	end
	frame.OnEvent = function(__event)
		self:_FireEvent("OnEvent", __event)
	end
	frame.OnFrameDragEnd = function()
		self:_FireEvent("OnDragEnd")
	end]]
end

function WndFrame:GetHandle()
	return self.__this:Lookup("", "")
end

function WndFrame:ClearHandle()
	self.__this:Lookup("", ""):Clear()
end

function WndFrame:SetTitle(__title)
	self.__this:Lookup("", "Text_Title"):SetText(__title)
end

function WndFrame:GetTitle(__title)
	return self.__this:Lookup("", "Text_Title"):GetText()
end

function WndFrame:RegisterEvent(...)
	self.__this:RegisterEvent(...)
end

local WndWindow = class(WndBase)
function WndWindow:ctor(__parent, __name, __data)
	assert(__parent ~= nil and __name ~= nil, "parent or name can not be null.")
	__data = __data or {}
	local hwnd = _AppendWnd(__parent, "WndWindow", __name)
	self.__this = hwnd
	self:SetSelf(self.__this)
	self:SetParent(__parent)
	self:SetType("WndWindow")
	if __data.w and __data.h then
		self:SetSize(__data.w, __data.h)
	end
	local __x = __data.x or 0
	local __y = __data.y or 0
	self:SetRelPos(__x, __y)
end

function WndWindow:SetSize(...)
	self.__this:SetSize(...)
	self.__this:Lookup("", ""):SetSize(...)
end

function WndWindow:GetHandle()
	return self.__this:Lookup("", "")
end

function WndWindow:ClearHandle()
	self.__this:Lookup("", ""):Clear()
end

local WndPageSet = class(WndBase)
function WndPageSet:ctor(__parent, __name, __data)
	assert(__parent ~= nil and __name ~= nil, "parent or name can not be null.")
	__data = __data or {}
	local hwnd = _AppendWnd(__parent, "WndPageSet", __name)
	self.__this = hwnd
	self:SetSelf(self.__this)
	self:SetParent(__parent)
	self:SetType("WndPageSet")
	if __data.w and __data.h then
		self:SetSize(__data.w, __data.h)
	end
	local __x = __data.x or 0
	local __y = __data.y or 0
	self:SetRelPos(__x, __y)
end

function WndPageSet:AddPage(...)
	self.__this:AddPage(...)
end

function WndPageSet:GetActivePage()
	return self.__this:GetActivePage()
end

function WndPageSet:GetActiveCheckBox()
	return self.__this:GetActiveCheckBox()
end

function WndPageSet:ActivePage(...)
	self.__this:ActivePage(...)
end

function WndPageSet:GetActivePageIndex()
	return self.__this:GetActivePageIndex()
end

function WndPageSet:GetLastActivePageIndex()
	return self.__this:GetLastActivePageIndex()
end

local WndButton = class(WndBase)
function WndButton:ctor(__parent, __name, __data)
	assert(__parent ~= nil and __name ~= nil, "parent or name can not be null.")
	__data = __data or {}
	local hwnd = _AppendWnd(__parent, "WndButton", __name)
	self.__text = hwnd:Lookup("", "Text_Default")
	self.__text:SetText(__data.text or "")
	self.__this = hwnd
	self:SetSelf(self.__this)
	self:SetParent(__parent)
	self:SetType("WndButton")
	if __data.w and __data.h then
		self:SetSize(__data.w, __data.h)
	end
	if __data.enable ~= nil then
		self:Enable(__data.enable)
	end
	local __x = __data.x or 0
	local __y = __data.y or 0
	self:SetRelPos(__x, __y)

	--Bind Button Events
	self.__this.OnLButtonClick = function()
		self:_FireEvent("OnClick")
	end
	self.__this.OnMouseEnter = function()
		self:_FireEvent("OnEnter")
	end
	self.__this.OnMouseLeave = function()
		self:_FireEvent("OnLeave")
	end
end

function WndButton:SetText(__text)
	self.__text:SetText(__text)
end

function WndButton:GetText()
	return self.__text:GetText()
end

local WndUIButton = class(WndBase)
function WndUIButton:ctor(__parent, __name, __data)
	assert(__parent ~= nil and __name ~= nil, "parent or name can not be null.")
	__data = __data or {}
	local hwnd = _AppendWnd(__parent, "WndUIButton", __name)
	self.__text = hwnd:Lookup("", "Text_Default")
	self.__text:SetText(__data.text or "")
	self.__this = hwnd
	self:SetSelf(self.__this)
	self:SetParent(__parent)
	self:SetType("WndUIButton")
	if __data.w and __data.h then
		self:SetSize(__data.w, __data.h)
	end
	local __x = __data.x or 0
	local __y = __data.y or 0
	self:SetRelPos(__x, __y)
end

local WndEdit = class(WndBase)
function WndEdit:ctor(__parent, __name, __data)
	assert(__parent ~= nil and __name ~= nil, "parent or name can not be null.")
	__data = __data or {}
	local hwnd = _AppendWnd(__parent, "WndEdit", __name)
	self.__edit = hwnd:Lookup("Edit_Default")
	self.__edit:SetText(__data.text or "")
	self.__this = hwnd
	self:SetSelf(self.__this)
	self:SetParent(__parent)
	self:SetType("WndEdit")
	if __data.w and __data.h then
		self:SetSize(__data.w, __data.h)
	end
	if __data.limit then
		self:SetLimit(__data.limit)
	end
	if __data.multi ~= nil then
		self:SetMultiLine(__data.multi)
	end
	if __data.enable ~= nil then
		self:Enable(__data.enable)
	end
	local __x = __data.x or 0
	local __y = __data.y or 0
	self:SetRelPos(__x, __y)

	--Bind Edit Events
	self.__edit.OnEditChanged = function()
		local __text = self.__edit:GetText()
		self:_FireEvent("OnChange", __text)
	end
end

function WndEdit:SetSize(__w, __h)
	self.__this:SetSize(__w + 4, __h)
	self.__this:Lookup("", ""):SetSize(__w + 4, __h)
	self.__this:Lookup("", "Image_Default"):SetSize(__w + 4, __h)
	self.__edit:SetSize(__w, __h)
end

function WndEdit:SetLimit(__limit)
	self.__edit:SetLimit(__limit)
end

function WndEdit:SetMultiLine(__multi)
	self.__edit:SetMultiLine(__multi)
end

function WndEdit:Enable(__enable)
	if __enable then
		self.__edit:SetFontColor(255, 255, 255)
		self.__edit:Enable(true)
	else
		self.__edit:SetFontColor(192, 192, 192)
		self.__edit:Enable(false)
	end
end

local WndCheckBox = class(WndBase)
function WndCheckBox:ctor(__parent, __name, __data)
	assert(__parent ~= nil and __name ~= nil, "parent or name can not be null.")
	__data = __data or {}
	local hwnd = _AppendWnd(__parent, "WndCheckBox", __name)
	self.__text = hwnd:Lookup("", "Text_Default")
	self.__text:SetText(__data.text or "")
	self.__this = hwnd
	self:SetSelf(self.__this)
	self:SetParent(__parent)
	self:SetType("WndCheckBox")
	if __data.check then
		self:Check(__data.check)
	end
	if __data.enable ~= nil then
		self:Enable(__data.enable)
	end
	local __x = __data.x or 0
	local __y = __data.y or 0
	self:SetRelPos(__x, __y)

	--Bind CheckBox Events
	self.__this.OnCheckBoxCheck = function()
		self:_FireEvent("OnCheck", true)
	end
	self.__this.OnCheckBoxUncheck = function()
		self:_FireEvent("OnCheck", false)
	end
end

function WndCheckBox:SetSize(__w)
	self.__text:SetSize(__w - 28, 25)
end

function WndCheckBox:Check(__check)
	self.__this:Check(__check)
end

function WndCheckBox:Enable(__enable)
	if __enable then
		self.__text:SetFontColor(255, 255, 255)
		self.__this:Enable(true)
	else
		self.__text:SetFontColor(192, 192, 192)
		self.__this:Enable(false)
	end
end

function WndCheckBox:IsChecked()
	return self.__this:IsCheckBoxChecked()
end

function WndCheckBox:SetText(__text)
	self.__text:SetText(__text)
end

function WndCheckBox:GetText()
	return self.__text:GetText()
end

function WndCheckBox:SetFontColor(...)
	self.__text:SetFontColor(...)
end

function WndCheckBox:GetFontColor()
	return self.__text:GetFontColor()
end

function WndCheckBox:SetFontScheme(...)
	self.__text:SetFontScheme(...)
end

function WndCheckBox:GetFontScheme()
	return self.__text:GetFontScheme()
end

local WndComboBox = class(WndBase)
function WndComboBox:ctor(__parent, __name, __data)
	assert(__parent ~= nil and __name ~= nil, "parent or name can not be null.")
	__data = __data or {}
	local hwnd = _AppendWnd(__parent, "WndComboBox", __name)
	self.__text = hwnd:Lookup("", "Text_Default")
	self.__text:SetText(__data.text or "")
	self.__this = hwnd
	self:SetSelf(self.__this)
	self:SetParent(__parent)
	self:SetType("WndComboBox")
	if __data.w then
		self:SetSize(__data.w)
	end
	local __x = __data.x or 0
	local __y = __data.y or 0
	self:SetRelPos(__x, __y)

	--Bind ComboBox Events
	self.__this:Lookup("Btn_ComboBox").OnLButtonClick = function()
		local __x, __y = self:GetAbsPos()
		local __w, __h = self:GetSize()
		local __menu = {}
		__menu.nMiniWidth = __w
		__menu.x = __x
		__menu.y = __y + __h
		self:_FireEvent("OnClick", __menu)
	end
end

function WndComboBox:SetSize(__w)
	self.__this:SetSize(__w, 25)
	local handle = self.__this:Lookup("", "")
	handle:SetSize(__w, 25)
	handle:Lookup("Image_ComboBoxBg"):SetSize(__w,25)
	handle:Lookup("Text_Default"):SetSize(__w, 25)
	local btn = self.__this:Lookup("Btn_ComboBox")
	btn:SetRelPos(__w - 25, 3)
	local h = btn:Lookup("", "")
	h:SetSize(__w, 25)
	local __x, __y = handle:GetAbsPos()
	h:SetAbsPos(__x, __y)
end

function WndComboBox:SetText(__text)
	self.__text:SetText(__text)
end

function WndComboBox:GetText()
	return self.__text:GetText()
end

local WndRadioBox = class(WndBase)
local __RadioBoxGroups = {}
function WndRadioBox:ctor(__parent, __name, __data)
	assert(__parent ~= nil and __name ~= nil, "parent or name can not be null.")
	__data = __data or {}
	local hwnd = _AppendWnd(__parent, "WndRadioBox", __name)
	self.__text = hwnd:Lookup("", "Text_Default")
	self.__text:SetText(__data.text or "")
	self.__this = hwnd
	self:SetSelf(self.__this)
	self:SetParent(__parent)
	self:SetType("WndRadioBox")
	if __data.w then
		self:SetSize(__data.w)
	end
	if __data.check then
		self:Check(__data.check)
	end
	if __data.enable then
		self:Enable(__data.enable)
	end
	self.__this.__group = __data.group
	self:SetGroup(__data.group)
	local __x = __data.x or 0
	local __y = __data.y or 0
	self:SetRelPos(__x, __y)

	--Bind RadioBox Events
	self.__this.OnCheckBoxCheck = function()
		if self.__group then
			for k, v in pairs(__RadioBoxGroups[self.__group]) do
				if v:GetGroup() == this.__group and v:GetName() ~= this:GetName() then
					v:Check(false)
				end
			end
		end
		self:_FireEvent("OnCheck", true)
	end
end

function WndRadioBox:SetSize(__w)
	self.__text:SetSize(__w - 28, 25)
end

function WndRadioBox:SetGroup(__group)
	if __group then
		if not __RadioBoxGroups[__group] then
			__RadioBoxGroups[__group] = {}
		end
		table.insert(__RadioBoxGroups[__group], self)
	end
	self.__group = __group
end

function WndRadioBox:GetGroup()
	return self.__group
end

function WndRadioBox:IsChecked()
	return self.__this:IsCheckBoxChecked()
end

function WndRadioBox:Check(__check)
	self.__this:Check(__check)
end

function WndRadioBox:Enable(__enable)
	if __enable then
		self.__text:SetFontColor(255, 255, 255)
		self.__this:Enable(true)
	else
		self.__text:SetFontColor(192, 192, 192)
		self.__this:Enable(false)
	end
end

function WndRadioBox:SetText(__text)
	self.__text:SetText(__text)
end

function WndRadioBox:GetText()
	return self.__text:GetText()
end

function WndRadioBox:SetFontColor(...)
	self.__text:SetFontColor(...)
end

function WndRadioBox:GetFontColor()
	return self.__text:GetFontColor()
end

function WndRadioBox:SetFontScheme(...)
	self.__text:SetFontScheme(...)
end

function WndRadioBox:GetFontScheme()
	return self.__text:GetFontScheme()
end

local WndUICheckBox = class(WndBase)
local __UICheckBoxGroups = {}
function WndUICheckBox:ctor(__parent, __name, __data)
	assert(__parent ~= nil and __name ~= nil, "parent or name can not be null.")
	__data = __data or {}
	local hwnd = _AppendWnd(__parent, "WndUICheckBox", __name)
	self.__text = hwnd:Lookup("", "Text_Default")
	self.__text:SetText(__data.text or "")
	self.__this = hwnd
	self:SetSelf(self.__this)
	self:SetParent(__parent)
	self:SetType("WndUICheckBox")
	if __data.w and __data.h then
		self:SetSize(__data.w, __data.h)
	end
	if __data.check then
		self:Check(__data.check)
	end
	self.__this.__group = __data.group
	self:SetGroup(__data.group)
	local __x = __data.x or 0
	local __y = __data.y or 0
	self:SetRelPos(__x, __y)

	--Bind UICheckBox Events
	self.__this.OnCheckBoxCheck = function()
		if self.__group then
			for k, v in pairs(__UICheckBoxGroups[self.__group]) do
				if v:GetGroup() == this.__group and v:GetName() ~= this:GetName() then
					v:Check(false)
				end
			end
		end
		self:_FireEvent("OnCheck", true)
	end
end

function WndUICheckBox:SetGroup(__group)
	if __group then
		if not __UICheckBoxGroups[__group] then
			__UICheckBoxGroups[__group] = {}
		end
		table.insert(__UICheckBoxGroups[__group], self)
	end
	self.__group = __group
end

function WndUICheckBox:GetGroup()
	return self.__group
end

function WndUICheckBox:Check(__check)
	self.__this:Check(__check)
end

function WndUICheckBox:SetText(__text)
	self.__text:SetText(__text)
end

function WndUICheckBox:SetAnimation(...)
	self.__this:SetAnimation(...)
end

local WndCSlider = class(WndBase)
function WndCSlider:ctor(__parent, __name, __data)
	assert(__parent ~= nil and __name ~= nil, "parent or name can not be null.")
	__data = __data or {}
	local hwnd = _AppendWnd(__parent, "WndCSlider", __name)
	self.__scroll = hwnd:Lookup("Scroll_Default")
	self.__text = hwnd:Lookup("", "Text_Default")
	self.__this = hwnd
	self:SetSelf(self.__this)
	self:SetParent(__parent)
	self:SetType("WndCSlider")
	self.__min = __data.min
	self.__max = __data.max
	self.__step = __data.step
	self.__unit = __data.unit or ""
	self.__scroll:SetStepCount(__data.step)
	if __data.w then
		self:SetSize(__data.w)
	end
	if __data.value then
		self:UpdateScrollPos(__data.value)
	end
	local __x = __data.x or 0
	local __y = __data.y or 0
	self:SetRelPos(__x, __y)

	--Bind CSlider Events
	self.__scroll.OnScrollBarPosChanged = function()
		local __step = this:GetScrollPos()
		local __value = self:GetValue(__step)
		self.__text:SetText(__value .. self.__unit)
		self:_FireEvent("OnChange", __value)
	end
end

function WndCSlider:SetSize(__w)
	self.__this:SetSize(__w, 25)
	self.__this:Lookup("", ""):SetSize(__w, 25)
	self.__this:Lookup("", ""):Lookup("Image_BG"):SetSize(__w, 10)
	self.__scroll:SetSize(__w, 25)
	self.__text:SetRelPos(__w + 5, 2)
	self.__this:Lookup("", ""):FormatAllItemPos()
end

function WndCSlider:GetValue(__step)
	return self.__min + __step * (self.__max - self.__min) / self.__step
end

function WndCSlider:GetStep(__value)
	return (__value - self.__min) * self.__step / (self.__max - self.__min)
end

function WndCSlider:ChangeToArea(__min, __max, __step)
	return __min + (__max - __min) * (self:GetValue(__step) - self.__min) / (self.__max - self.__min)
end

function WndCSlider:ChangeToAreaFromValue(__min, __max, __value)
	return __min + (__max - __min) * (__value - self.__min) / (self.__max - self.__min)
end

function WndCSlider:GetStepFromArea(__min, __max, __value)
	return self:GetStep(self.__min + (self.__max - self.__min) * (__value - __min) / (__max - __min))
end

function WndCSlider:UpdateScrollPos(__value)
	self.__text:SetText(__value .. self.__unit)
	self.__scroll:SetScrollPos(self:GetStep(__value))
end

local WndColorBox = class(WndBase)
function WndColorBox:ctor(__parent, __name, __data)
	assert(__parent ~= nil and __name ~= nil, "parent or name can not be null.")
	__data = __data or {}
	local hwnd = _AppendWnd(__parent, "WndColorBox", __name)
	self.__text = hwnd:Lookup("", "Text_Default")
	self.__shadow = hwnd:Lookup("", "Shadow_Default")
	self.__this = hwnd
	self:SetSelf(self.__this)
	self:SetParent(__parent)
	self:SetType("WndColorBox")
	self.__r = __data.r
	self.__g = __data.g
	self.__b = __data.b
	self:SetText(__data.text)
	self:SetColor(__data.r, __data.g, __data.b)
	if __data.w then
		self:SetSize(__data.w)
	end
	local __x = __data.x or 0
	local __y = __data.y or 0
	self:SetRelPos(__x, __y)

	--Bind ColorBox Events
	self.__shadow.OnItemLButtonClick = function()
		local fnChangeColor = function(r, g, b)
			self:SetColor(r, g, b)
			self:_FireEvent("OnChange", {r, g, b})
		end
		OpenColorTablePanel(fnChangeColor)
	end
end

function WndColorBox:SetSize(__w)
	self.__this:SetSize(__w, 25)
	self.__this:Lookup("", ""):SetSize(__w, 25)
	self.__text:SetText(__w - 25, 25)
end

function WndColorBox:SetText(__text)
	self.__text:SetText(__text)
end

function WndColorBox:SetColor(...)
	self.__shadow:SetColorRGB(...)
	self.__text:SetFontColor(...)
end

local WndScroll = class(WndBase)
function WndScroll:ctor(__parent, __name, __data)
	assert(__parent ~= nil and __name ~= nil, "parent or name can not be null.")
	__data = __data or {}
	local hwnd = _AppendWnd(__parent, "WndScroll", __name)
	self.__this = hwnd
	self:SetSelf(self.__this)
	self:SetParent(__parent)
	self:SetType("WndScroll")
	self.__up = self.__this:Lookup("Btn_Up")
	self.__down = self.__this:Lookup("Btn_Down")
	self.__scroll = self.__this:Lookup("Scroll_List")
	self.__handle = self.__this:Lookup("", "")
	if __data.w and __data.h then
		self:SetSize(__data.w, __data.h)
	end
	self.__up.OnLButtonHold = function()
		self.__scroll:ScrollPrev(1)
	end
	self.__up.OnLButtonDown = function()
		self.__scroll:ScrollPrev(1)
	end
	self.__down.OnLButtonHold = function()
		self.__scroll:ScrollNext(1)
	end
	self.__down.OnLButtonDown = function()
		self.__scroll:ScrollNext(1)
	end
	self.__handle.OnItemMouseWheel = function()
		local __dist = Station.GetMessageWheelDelta()
		self.__scroll:ScrollNext(__dist)
		return true
	end
	self.__scroll.OnScrollBarPosChanged = function()
		local __value = this:GetScrollPos()
		if __value == 0 then
			self.__up:Enable(false)
		else
			self.__up:Enable(true)
		end
		if __value == this:GetStepCount() then
			self.__down:Enable(false)
		else
			self.__down:Enable(true)
		end
		self.__handle:SetItemStartRelPos(0, -__value * 10)
	end
	local __x = __data.x or 0
	local __y = __data.y or 0
	self:SetRelPos(__x, __y)
	--self:OnUpdateScorllList()
end

function WndScroll:GetHandle()
	return self.__handle
end

function WndScroll:SetHandleStyle(...)
	self.__handle:SetHandleStyle(...)
end

function WndScroll:ClearHandle()
	self.__handle:Clear()
end

function WndScroll:OnUpdateScorllList()
	self.__handle:FormatAllItemPos()
	local __w, __h = self.__handle:GetSize()
	local __wAll, __hAll = self.__handle:GetAllItemSize()
	local __count = math.ceil((__hAll - __h) / 10)

	self.__scroll:SetStepCount(__count)
	if __count > 0 then
		self.__scroll:Show()
		self.__up:Show()
		self.__down:Show()
	else
		self.__scroll:Hide()
		self.__up:Hide()
		self.__down:Hide()
	end
end

function WndScroll:SetSize(__w, __h)
	self.__this:SetSize(__w, __h)
	self.__handle:SetSize(__w, __h)
	self.__scroll:SetSize(15, __h - 40)
	self.__scroll:SetRelPos(__w - 17, 20)
	self.__up:SetRelPos(__w - 20, 3)
	self.__down:SetRelPos(__w - 20, __h - 20)
end

local _AppendItem = function(__parent, __string, __name)
	if __parent.__addon then
		__parent = __parent:GetHandle()
	end
	local __count = __parent:GetItemCount()
	__parent:AppendItemFromString(__string)
	local hwnd = __parent:Lookup(__count)
	hwnd:SetName(__name)
	return hwnd
end

local ItemBase = class()
function ItemBase:ctor(__this)
	self.__addon = true
	self.__listeners = {self}
end

function ItemBase:SetName(...)
	self.__this:SetName(...)
end

function ItemBase:GetName()
	return self.__this:GetName()
end

function ItemBase:Scale(...)
	self.__this:Scale(...)
end

function ItemBase:LockShowAndHide(...)
	self.__this:LockShowAndHide(...)
end

function ItemBase:SetSelf(__this)
	self.__this = __this
end

function ItemBase:GetSelf()
	return self.__this
end

function ItemBase:SetSize(...)
	self.__this:SetSize(...)
end

function ItemBase:GetSize()
	return self.__this:GetSize()
end

function ItemBase:SetRelPos(...)
	self.__this:SetRelPos(...)
end

function ItemBase:GetRelPos()
	return self.__this:GetRelPos()
end

function ItemBase:SetAbsPos(...)
	self.__this:SetAbsPos(...)
end

function ItemBase:GetAbsPos()
	return self.__this:GetAbsPos()
end

function ItemBase:SetAlpha(...)
	self.__this:SetAlpha(...)
end

function ItemBase:SetTip(...)
	self.__this:SetTip(...)
end

function ItemBase:GetTip()
	self.__this:GetTip()
end

function ItemBase:GetAlpha()
	return self.__this:GetAlpha()
end

function ItemBase:GetType()
	return self.__this:GetType()
end

function ItemBase:SetPosType(...)
	self.__this:SetPosType(...)
end

function ItemBase:GetPosType()
	return self.__this:GetPosType()
end

function ItemBase:SetParent(__parent)
	self.__parent = __parent
end

function ItemBase:GetParent()
	return self.__parent
end

function ItemBase:Destroy()
	self:GetParent():RemoveItem(self.__this)
end

function ItemBase:Show()
	self.__this:Show()
end

function ItemBase:Hide()
	self.__this:Hide()
end

function ItemBase:IsVisible()
	return self.__this:IsVisible()
end

function ItemBase:_FireEvent(__event, ...)
	for __k, __v in pairs(self.__listeners) do
		if __v[__event] then
			local res, err = pcall(__v[__event], ...)
			if not res then
				OutputMessage("MSG_SYS", "ERROR:" .. err .. "\n")
			end
		end
	end
end


local ItemHandle = class(ItemBase)
function ItemHandle:ctor(__parent, __name, __data)
	assert(__parent ~= nil and __name ~= nil, "parent or name can not be null.")
	__data = __data or {}
	local __string = "<handle>w=10 h=10 eventid=272</handle>"
	if __data.w then
		__string = string.gsub(__string, "w=%d+", string.format("w=%d", __data.w))
	end
	if __data.h then
		__string = string.gsub(__string, "h=%d+", string.format("h=%d", __data.h))
	end
	if __data.handletype then
		__string = string.gsub(__string, "handletype=%d+", string.format("handletype=%d", __data.handletype))
	end
	if __data.firstitempostype then
		__string = string.gsub(__string, "firstitempostype=%d+", string.format("firstitempostype=%d", __data.firstitempostype))
	end
	if __data.eventid then
		__string = string.gsub(__string, "eventid=%d+", string.format("eventid=%d", __data.eventid))
	end
	local hwnd = _AppendItem(__parent, __string, __name)
	self.__this = hwnd
	self:SetSelf(self.__this)
	self:SetParent(__parent)
	local __x = __data.x or 0
	local __y = __data.y or 0
	self:SetRelPos(__x, __y)
	if __parent.__addon then
		__parent = __parent:GetHandle()
	end
	__parent:FormatAllItemPos()

	--Bind Handle Events
	self.__this.OnItemLButtonClick = function()
		self:_FireEvent("OnClick")
	end
	self.__this.OnItemMouseEnter = function()
		self:_FireEvent("OnEnter")
	end
	self.__this.OnItemMouseLeave = function()
		self:_FireEvent("OnLeave")
	end
end

function ItemHandle:GetHandle()
	return self.__this
end

function ItemHandle:FormatAllItemPos()
	self.__this:FormatAllItemPos()
end

function ItemHandle:SetHandleStyle(...)
	self.__this:SetHandleStyle(...)
end

function ItemHandle:GetItemStartRelPos()
	return self.__this:GetItemStartRelPos()
end

function ItemHandle:SetItemStartRelPos(...)
	self.__this:SetItemStartRelPos(...)
end

function ItemHandle:SetSizeByAllItemSize()
	self.__this:SetSizeByAllItemSize()
end

function ItemHandle:GetAllItemSize()
	return self.__this:GetAllItemSize()
end

function ItemHandle:GetVisibleItemCount()
	return self.__this:GetVisibleItemCount()
end

function ItemHandle:EnableFormatWhenAppend(...)
	self.__this:EnableFormatWhenAppend(...)
end

function ItemHandle:ExchangeItemIndex(...)
	self.__this:ExchangeItemIndex(...)
end

function ItemHandle:Sort()
	self.__this:Sort()
end

function ItemHandle:GetItemCount()
	self.__this:GetItemCount()
end

function ItemHandle:ClearHandle()
	self.__this:Clear()
end

local ItemText = class(ItemBase)
function ItemText:ctor(__parent, __name, __data)
	assert(__parent ~= nil and __name ~= nil, "parent or name can not be null.")
	__data = __data or {}
	local __string = "<text>w=150 h=30 valign=1 font=18 eventid=256 </text>"
	if __data.w then
		__string = string.gsub(__string, "w=%d+", string.format("w=%d", __data.w))
	end
	if __data.h then
		__string = string.gsub(__string, "h=%d+", string.format("h=%d", __data.h))
	end
	if __data.valign then
		__string = string.gsub(__string, "valign=%d+", string.format("valign=%d", __data.valign))
	end
	if __data.font then
		__string = string.gsub(__string, "font=%d+", string.format("font=%d", __data.font))
	end
	if __data.eventid then
		__string = string.gsub(__string, "eventid=%d+", string.format("eventid=%d", __data.eventid))
	end
	local hwnd = _AppendItem(__parent, __string, __name)
	self.__this = hwnd
	self:SetSelf(self.__this)
	self:SetParent(__parent)
	self:SetText(__data.text or "")
	local __x = __data.x or 0
	local __y = __data.y or 0
	self:SetRelPos(__x, __y)
	if __parent.__addon then
		__parent = __parent:GetHandle()
	end
	__parent:FormatAllItemPos()

	--Bind Text Events
	self.__this.OnItemMouseEnter = function()
		self:_FireEvent("OnEnter")
	end
	self.__this.OnItemMouseLeave = function()
		self:_FireEvent("OnLeave")
	end
end

function ItemText:SetText(...)
	self.__this:SetText(...)
end

function ItemText:GetText()
	return self.__this:GetText()
end

function ItemText:SetFontScheme(...)
	self.__this:SetFontScheme(...)
end

function ItemText:GetFontScheme()
	return self.__this:GetFontScheme()
end

function ItemText:GetTextLen()
	return self.__this:GetTextLen()
end

function ItemText:SetVAlign(...)
	self.__this:SetVAlign(...)
end

function ItemText:GetVAlign()
	return self.__this:GetVAlign()
end

function ItemText:SetHAlign(...)
	self.__this:SetHAlign(...)
end

function ItemText:GetHAlign()
	return self.__this:GetHAlign()
end

function ItemText:SetRowSpacing(...)
	self.__this:SetRowSpacing(...)
end

function ItemText:GetRowSpacing()
	return self.__this:GetRowSpacing()
end

function ItemText:SetMultiLine(...)
	self.__this:SetMultiLine(...)
end

function ItemText:IsMultiLine()
	return self.__this:IsMultiLine()
end

function ItemText:FormatTextForDraw(...)
	self.__this:FormatTextForDraw(...)
end

function ItemText:AutoSize()
	self.__this:AutoSize()
end

function ItemText:SetCenterEachLine(...)
	self.__this:SetCenterEachLine(...)
end

function ItemText:IsCenterEachLine()
	return self.__this:IsCenterEachLine()
end

function ItemText:SetRichText(...)
	self.__this:SetRichText(...)
end

function ItemText:IsRichText()
	return self.__this:IsRichText()
end

function ItemText:GetFontScale()
	return self.__this:GetFontScale()
end

function ItemText:SetFontScale(...)
	self.__this:SetFontScale(...)
end

function ItemText:SetFontID(...)
	self.__this:SetFontID(...)
end

function ItemText:SetFontBorder(...)
	self.__this:SetFontBorder(...)
end

function ItemText:SetFontShadow(...)
	self.__this:SetFontShadow(...)
end

function ItemText:GetFontID()
	return self.__this:GetFontID()
end

function ItemText:GetFontBoder()
	return self.__this:GetFontBoder()
end

function ItemText:GetFontProjection()
	return self.__this:GetFontProjection()
end

function ItemText:GetTextExtent()
	return self.__this:GetTextExtent()
end

function ItemText:GetTextPosExtent()
	return self.__this:GetTextPosExtent()
end

function ItemText:SetFontColor(...)
	self.__this:SetFontColor(...)
end

function ItemText:GetFontColor()
	return self.__this:GetFontColor()
end

function ItemText:SetFontSpacing(...)
	self.__this:SetFontSpacing(...)
end

function ItemText:GetFontSpacing()
	return self.__this:GetFontSpacing()
end

local ItemBox = class(ItemBase)
function ItemBox:ctor(__parent, __name, __data)
	assert(__parent ~= nil and __name ~= nil, "parent or name can not be null.")
	__data = __data or {}
	local __string = "<box>w=48 h=48 eventid=272 </box>"
	if __data.w then
		__string = string.gsub(__string, "w=%d+", string.format("w=%d", __data.w))
	end
	if __data.h then
		__string = string.gsub(__string, "h=%d+", string.format("h=%d", __data.h))
	end
	if __data.eventid then
		__string = string.gsub(__string, "eventid=%d+", string.format("eventid=%d", __data.eventid))
	end
	local hwnd = _AppendItem(__parent, __string, __name)
	self.__this = hwnd
	self:SetSelf(self.__this)
	self:SetParent(__parent)
	local __x = __data.x or 0
	local __y = __data.y or 0
	self:SetRelPos(__x, __y)
	if __parent.__addon then
		__parent = __parent:GetHandle()
	end
	__parent:FormatAllItemPos()

	--Bind Box Events
	self.__this.OnItemMouseEnter = function()
		self:_FireEvent("OnEnter")
	end
	self.__this.OnItemMouseLeave = function()
		self:_FireEvent("OnLeave")
	end
	self.__this.OnItemLButtonClick = function()
		self:_FireEvent("OnClick")
	end
end

function ItemBox:SetObject(...)
	self.__this:SetObject(...)
end

function ItemBox:GetObject()
	return self.__this:GetObject()
end

function ItemBox:GetObjectType()
	return self.__this:GetObjectType()
end

function ItemBox:GetObjectData()
	return self.__this:GetObjectData()
end

function ItemBox:ClearObject()
	return self.__this:ClearObject()
end

function ItemBox:IsEmpty()
	return self.__this:IsEmpty()
end

function ItemBox:EnableObject(...)
	self.__this:EnableObject(...)
end

function ItemBox:IsObjectEnable()
	return self.__this:IsObjectEnable()
end

function ItemBox:SetObjectCoolDown(...)
	self.__this:SetObjectCoolDown(...)
end

function ItemBox:IsObjectCoolDown()
	return self.__this:IsObjectCoolDown()
end

function ItemBox:SetObjectSparking(...)
	self.__this:SetObjectSparking(...)
end

function ItemBox:SetObjectInUse(...)
	self.__this:SetObjectInUse(...)
end

function ItemBox:SetObjectStaring(...)
	self.__this:SetObjectStaring(...)
end

function ItemBox:SetObjectSelected(...)
	self.__this:SetObjectSelected(...)
end

function ItemBox:IsObjectSelected()
	return self.__this:IsObjectSelected()
end

function ItemBox:SetObjectMouseOver(...)
	self.__this:SetObjectMouseOver(...)
end

function ItemBox:IsObjectMouseOver()
	return self.__this:IsObjectMouseOver()
end

function ItemBox:SetObjectPressed(...)
	self.__this:SetObjectPressed(...)
end

function ItemBox:IsObjectPressed()
	return self.__this:IsObjectPressed()
end

function ItemBox:SetCoolDownPercentage(...)
	self.__this:SetCoolDownPercentage(...)
end

function ItemBox:GetCoolDownPercentage()
	return self.__this:GetCoolDownPercentage()
end

function ItemBox:SetObjectIcon(...)
	self.__this:SetObjectIcon(...)
end

function ItemBox:GetObjectIcon()
	return self.__this:GetObjectIcon()
end

function ItemBox:ClearObjectIcon()
	self.__this:ClearObjectIcon()
end

function ItemBox:SetOverText(...)
	self.__this:SetOverText(...)
end

function ItemBox:GetOverText()
	return self.__this:GetOverText()
end

function ItemBox:SetOverTextFontScheme(...)
	self.__this:SetOverTextFontScheme(...)
end

function ItemBox:GetOverTextFontScheme()
	return self.__this:GetOverTextFontScheme()
end

function ItemBox:SetOverTextPosition(...)
	self.__this:SetOverTextPosition(...)
end

function ItemBox:GetOverTextPosition()
	return self.__this:GetOverTextPosition()
end

function ItemBox:SetExtentImage(...)
	self.__this:SetExtentImage(...)
end

function ItemBox:ClearExtentImage()
	self.__this:ClearExtentImage()
end

function ItemBox:SetExtentAnimate(...)
	self.__this:SetExtentAnimate(...)
end

function ItemBox:ClearExtentAnimate()
	self.__this:ClearExtentAnimate()
end


local ItemImage = class(ItemBase)
function ItemImage:ctor(__parent, __name, __data)
	assert(__parent ~= nil and __name ~= nil, "parent or name can not be null.")
	__data = __data or {}
	local __string = "<image>w=100 h=100 eventid=257 </image>"
	if __data.w then
		__string = string.gsub(__string, "w=%d+", string.format("w=%d", __data.w))
	end
	if __data.h then
		__string = string.gsub(__string, "h=%d+", string.format("h=%d", __data.h))
	end
	if __data.eventid then
		__string = string.gsub(__string, "eventid=%d+", string.format("eventid=%d", __data.eventid))
	end
	local hwnd = _AppendItem(__parent, __string, __name)
	self.__this = hwnd
	self:SetSelf(self.__this)
	self:SetParent(__parent)
	if __data.image then
		local __image = __data.image
		local __frame = __data.frame or nil
		self:SetImage(__image, __frame)
	end
	local __x = __data.x or 0
	local __y = __data.y or 0
	self:SetRelPos(__x, __y)
	if __parent.__addon then
		__parent = __parent:GetHandle()
	end
	__parent:FormatAllItemPos()
end

function ItemImage:SetFrame(...)
	self.__this:SetFrame(...)
end

function ItemImage:GetFrame()
	return self.__this:GetFrame()
end

function ItemImage:SetImageType(...)
	self.__this:SetImageType(...)
end

function ItemImage:GetImageType()
	return self.__this:GetImageType()
end

function ItemImage:SetPercentage(...)
	self.__this:SetPercentage(...)
end

function ItemImage:GetPercentage()
	return self.__this:GetPercentage()
end

function ItemImage:SetRotate(...)
	self.__this:SetRotate(...)
end

function ItemImage:GetRotate()
	return self.__this:GetRotate()
end

function ItemImage:GetImageID()
	return self.__this:GetImageID()
end

function ItemImage:FromUITex(...)
	self.__this:FromUITex(...)
end

function ItemImage:FromTextureFile(...)
	self.__this:FromTextureFile(...)
end

function ItemImage:FromScene(...)
	self.__this:FromScene(...)
end

function ItemImage:FromImageID(...)
	self.__this:FromImageID(...)
end

function ItemImage:FromIconID(...)
	self.__this:FromIconID(...)
end

function ItemImage:SetImage(__image, __frame)
	if type(__image) == "string" then
		if __frame then
			self:FromUITex(__image, __frame)
		else
			self:FromTextureFile(__image)
		end
	elseif type(__image) == "number" then
		self:FromIconID(__image)
	end
end

local ItemShadow = class(ItemBase)
function ItemShadow:ctor(__parent, __name, __data)
	assert(__parent ~= nil and __name ~= nil, "parent or name can not be null.")
	__data = __data or {}
	local __string = "<shadow>w=15 h=15 eventid=277 </shadow>"
	if __data.w then
		__string = string.gsub(__string, "w=%d+", string.format("w=%d", __data.w))
	end
	if __data.h then
		__string = string.gsub(__string, "h=%d+", string.format("h=%d", __data.h))
	end
	if __data.eventid then
		__string = string.gsub(__string, "eventid=%d+", string.format("eventid=%d", __data.eventid))
	end
	local hwnd = _AppendItem(__parent, __string, __name)
	self.__this = hwnd
	self:SetSelf(self.__this)
	self:SetParent(__parent)
	local __x = __data.x or 0
	local __y = __data.y or 0
	self:SetRelPos(__x, __y)
	if __parent.__addon then
		__parent = __parent:GetHandle()
	end
	__parent:FormatAllItemPos()
end

function ItemShadow:SetShadowColor(...)
	self.__this:SetShadowColor(...)
end

function ItemShadow:GetShadowColor()
	return self.__this:GetShadowColor()
end

function ItemShadow:SetColorRGB(...)
	self.__this:SetColorRGB(...)
end

function ItemShadow:GetColorRGB()
	return self.__this:GetColorRGB()
end

function ItemShadow:SetTriangleFan(...)
	self.__this:SetTriangleFan(...)
end

function ItemShadow:IsTriangleFan()
	return self.__this:IsTriangleFan()
end

function ItemShadow:AppendTriangleFanPoint(...)
	self.__this:AppendTriangleFanPoint(...)
end

function ItemShadow:SetD3DPT(...)
	self.__this:SetD3DPT(...)
end

function ItemShadow:AppendTriangleFan3DPoint(...)
	self.__this:AppendTriangleFan3DPoint(...)
end

function ItemShadow:ClearTriangleFanPoint()
	self.__this:ClearTriangleFanPoint()
end

function ItemShadow:AppendDoodadID(...)
	self.__this:AppendDoodadID(...)
end

function ItemShadow:AppendCharacterID(...)
	self.__this:AppendCharacterID(...)
end

local ItemAnimate = class(ItemBase)
function ItemAnimate:ctor(__parent, __name, __data)
	assert(__parent ~= nil and __name ~= nil, "parent or name can not be null.")
	__data = __data or {}
	local __string = "<animate>w=30 h=30 </animate>"
	if __data.w then
		__string = string.gsub(__string, "w=%d+", string.format("w=%d", __data.w))
	end
	if __data.h then
		__string = string.gsub(__string, "h=%d+", string.format("h=%d", __data.h))
	end
	local hwnd = _AppendItem(__parent, __string, __name)
	self.__this = hwnd
	self:SetSelf(self.__this)
	self:SetParent(__parent)
	if __data.image then
		local __image = __data.image
		local __group = __data.group or 0
		local __loop = __data.loop or -1
		self:SetAnimate(__image, __group, __loop)
	end
	local __x = __data.x or 0
	local __y = __data.y or 0
	self:SetRelPos(__x, __y)
	if __parent.__addon then
		__parent = __parent:GetHandle()
	end
	__parent:FormatAllItemPos()
end

function ItemAnimate:SetGroup(...)
	self.__this:SetGroup(...)
end

function ItemAnimate:SetLoopCount(...)
	self.__this:SetLoopCount(...)
end

function ItemAnimate:SetImagePath(...)
	self.__this:SetImagePath(...)
end

function ItemAnimate:SetAnimate(...)
	self.__this:SetAnimate(...)
end

function ItemAnimate:AutoSize()
	self.__this:AutoSize()
end

function ItemAnimate:Replay()
	self.__this:Replay()
end

function ItemAnimate:SetIdenticalInterval(...)
	self.__this:SetIdenticalInterval(...)
end

function ItemAnimate:IsFinished()
	return self.__this:IsFinished()
end

function ItemAnimate:SetAnimateType(...)
	self.__this:SetAnimateType(...)
end

function ItemAnimate:GetAnimateType()
	return self.__this:GetAnimateType()
end

local ItemTreeLeaf = class(ItemBase)
function ItemTreeLeaf:ctor(__parent, __name, __data)
	assert(__parent ~= nil and __name ~= nil, "parent or name can not be null.")
	__data = __data or {}
	local __string = "<treeleaf>w=150 h=25 indentwidth=20 alwaysnode=1 indent=0 eventid=257 </treeleaf>"
	if __data.w then
		__string = string.gsub(__string, "w=%d+", string.format("w=%d", __data.w))
	end
	if __data.h then
		__string = string.gsub(__string, "h=%d+", string.format("h=%d", __data.h))
	end
	if __data.eventid then
		__string = string.gsub(__string, "eventid=%d+", string.format("eventid=%d", __data.eventid))
	end
	local hwnd = _AppendItem(__parent, __string, __name)
	self.__this = hwnd
	self:SetSelf(self.__this)
	self:SetParent(__parent)
	local __x = __data.x or 0
	local __y = __data.y or 0
	self:SetRelPos(__x, __y)
	if __parent.__addon then
		__parent = __parent:GetHandle()
	end
	__parent:FormatAllItemPos()

	--Bind TreeLeaf Event
	self.__this.OnItemLButtonDown =function()
		self:_FireEvent("OnClick")
	end
end

function ItemTreeLeaf:GetHandle(...)
	return self.__this
end

function ItemTreeLeaf:FormatAllItemPos()
	self.__this:FormatAllItemPos()
end

function ItemTreeLeaf:SetHandleStyle(...)
	self.__this:SetHandleStyle(...)
end

function ItemTreeLeaf:SetRowHeight(...)
	self.__this:SetRowHeight(...)
end

function ItemTreeLeaf:SetRowSpacing(...)
	self.__this:SetRowSpacing(...)
end

function ItemTreeLeaf:ClearHandle()
	self.__this:Clear()
end

function ItemTreeLeaf:GetItemStartRelPos()
	return self.__this:GetItemStartRelPos()
end

function ItemTreeLeaf:SetItemStartRelPos(...)
	self.__this:SetItemStartRelPos(...)
end

function ItemTreeLeaf:SetSizeByAllItemSize()
	self.__this:SetSizeByAllItemSize()
end

function ItemTreeLeaf:GetAllItemSize()
	return self.__this:GetAllItemSize()
end

function ItemTreeLeaf:GetItemCount()
	return self.__this:GetItemCount()
end

function ItemTreeLeaf:GetVisibleItemCount()
	return self.__this:GetVisibleItemCount()
end

function ItemTreeLeaf:EnableFormatWhenAppend(...)
	self.__this:EnableFormatWhenAppend(...)
end

function ItemTreeLeaf:ExchangeItemIndex(...)
	self.__this:ExchangeItemIndex(...)
end

function ItemTreeLeaf:Sort()
	self.__this:Sort()
end

function ItemTreeLeaf:IsExpand()
	return self.__this:IsExpand()
end

function ItemTreeLeaf:ExpandOrCollapse(...)
	self.__this:ExpandOrCollapse(...)
end

function ItemTreeLeaf:Expand()
	self.__this:Expand()
end

function ItemTreeLeaf:Collapse()
	self.__this:Collapse()
end

function ItemTreeLeaf:SetIndent(...)
	self.__this:SetIndent(...)
end

function ItemTreeLeaf:GetIndent()
	return self.__this:GetIndent()
end

function ItemTreeLeaf:SetEachIndentWidth(...)
	self.__this:SetEachIndentWidth(...)
end

function ItemTreeLeaf:GetEachIndentWidth()
	return self.__this:GetEachIndentWidth()
end

function ItemTreeLeaf:SetNodeIconSize(...)
	self.__this:SetNodeIconSize(...)
end

function ItemTreeLeaf:SetIconImage(...)
	self.__this:SetIconImage(...)
end

function ItemTreeLeaf:PtInIcon(...)
	return self.__this:PtInIcon(...)
end

function ItemTreeLeaf:AdjustNodeIconPos()
	self.__this:AdjustNodeIconPos()
end

function ItemTreeLeaf:AutoSetIconSize()
	self.__this:AutoSetIconSize()
end

function ItemTreeLeaf:SetShowIndex(...)
	self.__this:SetShowIndex(...)
end

function ItemTreeLeaf:GetShowIndex()
	return self.__this:GetShowIndex()
end

-- Addon Class
local CreateAddon = class()
function CreateAddon:ctor(__name, __style)
	self.__listeners = {self}

	--Bind Addon Base Events
	self.OnFrameCreate = function()
		self:_FireEvent("OnCreate")
	end
	self.OnFrameBreathe = function()
		self:_FireEvent("OnUpdate")
	end
	self.OnFrameRender = function()
		self:_FireEvent("OnRender")
	end
	self.OnFrameDragEnd = function()
		self:_FireEvent("OnDragEnd")
	end
	self.OnFrameDestroy = function()
		self:_FireEvent("OnDestroy")
	end
	self.OnFrameKeyDown = function()
		self:_FireEvent("OnKeyDown")
	end
	self.OnEvent = function(__event)
		self:_FireEvent("OnScript", __event)
	end
end

function CreateAddon:_FireEvent(__event, ...)
	for __k, __v in pairs(self.__listeners) do
		if __v[__event] then
			local res, err = pcall(__v[__event], ...)
			if not res then
				OutputMessage("MSG_SYS", "ERROR:" .. err .. "\n")
			end
		end
	end
end
----------------------------------------------
-- GUI Global Interface
----------------------------------------------
EasyUI = EasyUI or {}

local _API = {
	CreateFrame = WndFrame.new,
	CreateWindow = WndWindow.new,
	CreatePageSet = WndPageSet.new,
	CreateButton = WndButton.new,
	CreateEdit = WndEdit.new,
	CreateCheckBox = WndCheckBox.new,
	CreateComboBox = WndComboBox.new,
	CreateRadioBox = WndRadioBox.new,
	CreateCSlider = WndCSlider.new,
	CreateColorBox = WndColorBox.new,
	CreateScroll = WndScroll.new,
	CreateUICheckBox = WndUICheckBox.new,
	CreateHandle = ItemHandle.new,
	CreateText = ItemText.new,
	CreateImage = ItemImage.new,
	CreateAnimate = ItemAnimate.new,
	CreateShadow = ItemShadow.new,
	CreateBox = ItemBox.new,
	CreateTreeLeaf = ItemTreeLeaf.new,
	CreateAddon = CreateAddon.new,
}
setmetatable(EasyUI, { __metatable = true, __index = _API, __newindex = function() end })

RegisterEvent("CALL_LUA_ERROR", function()
	OutputMessage("MSG_SYS", arg0)
end)
--[[
/script local f=EasyUI.CreateFrame("test",{style="SMALL"})
local b=EasyUI.CreateButton(f,"b1",{text="Click Me",x=50,y=50})
b:OnClick(function() Output("Click") end)
b:OnEnter(function() Output("Enter") end)
b:OnLeave(function() Output("Leave") end)
local e=EasyUI.CreateEdit(f,"e1",{text="input words",x=50,y=100})
e:OnChange(function(arg0) Output(arg0) end)
local c=EasyUI.CreateCheckBox(f,"c1",{text="Check Me",x=50,y=150,check=true})
c:OnCheck(function(arg0) Output(arg0) end)
local d=EasyUI.CreateComboBox(f,"c2",{text="Menu",x=50,y=200})
d:OnClick(function()
	local m = {}
	table.insert(m,{szOption="TEST1"})
	table.insert(m,{szOption="TEST2"})
	return m
end)
local r1=EasyUI.CreateRadioBox(f,"r1",{text="Select1",x=50,y=250,check=true,group="test1"})
r1:OnCheck(function(arg0) Output(arg0) end)
local r2=EasyUI.CreateRadioBox(f,"r2",{text="Select2",x=200,y=250,group="test1"})
r2:OnCheck(function(arg0) Output(arg0) end)
local r3=EasyUI.CreateRadioBox(f,"r3",{text="Select3",x=350,y=250,group="test1"})
r3:OnCheck(function(arg0) Output(arg0) end)
local s=EasyUI.CreateCSlider(f,"s1",{x=50,y=300,min=0,max=100,step=1,value=20})
s:OnChange(function(arg0) Output(arg0) end)
local c3=EasyUI.CreateColorBox(f,"c3",{text="Color",x=50,y=350,r=255,g=255,b=0})
c3:OnChange(function(arg0) Output(arg0) end)
local s5=EasyUI.CreateScroll(f,"s5",{x=300,y=50})
/script local f=EasyUI.CreateFrame("test",{style="SMALL"})
local win=EasyUI.CreateWindow(f,"w1",{x=10,y=10,w=300,h=300})
local txt=EasyUI.CreateText(win,"txt1",{text="ssssssssss",x=20,y=20})
tet:SetFontColor(255,255,0)
local b=EasyUI.CreateButton(f,"b1",{text="Click Me",x=50,y=50})
b:OnClick(function() txt:Hide() end)


/script local f=EasyUI.CreateFrame("test",{title="Test Title",style="SMALL"})
local scr=EasyUI.CreateScroll(f,"ScrollTest",{x=20,y=20,w=200,h=200})
for i=0, 20 do
	local hd=EasyUI.CreateHandle(scr,"hd"..i,{x=5,y=i*20,w=50,h=20})
	EasyUI.CreateText(hd,"txt"..i,{text="AAAAAAA"})
end
scr:OnUpdateScorllList()
local img=EasyUI.CreateImage(f,"img",{w=36,h=36,x=50,y=50,image="ui\\Image\\UICommon\\CommonPanel.UITex",frame=13})
img:SetImage("ui\\Image\\UICommon\\CommonPanel.UITex",13)

local ani=EasyUI.CreateAnimate(f,"img",{w=161,h=161,x=50,y=50,image="ui/Image/Common/SprintYellowPower1.UITex"})
local sha=EasyUI.CreateShadow(f,"sha",{x=50,y=300,w=35,h=35})
sha:SetColorRGB(255,255,0)
local box=EasyUI.CreateBox(f,"box",{x=50,y=300,w=35,h=35})
box:SetObject(UI_OBJECT_NOT_NEED_KNOWN, 126)
box:SetObjectIcon(Table_GetBuffIconID(126, 6))
box:SetObjectIcon(2999)

local tree=EasyUI.CreateTreeLeaf(f,"tree",{x=50,y=50})
]]

