local _class = {}

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

EasyUI = EasyUI or {}

local _Append = function(__parent, __ini, __type, __name)
	local hwnd = nil
	if string.sub(__type, 1, 3) == "Wnd" then
		hwnd = Wnd.OpenWindow(__ini, __name):Lookup(__type)
		hwnd:ChangeRelation(__parent:GetSelf(), true, true)
		hwnd:SetName(__name)
		Wnd.CloseWindow(__name)
	else
		hwnd = __parent:GetSelf():AppendItemFromIni(__ini, __type, __name)
		hwnd:SetName(__name)
	end
	return hwnd
end

local WndBase = class()
function WndBase:ctor(__this)
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

local WndFrame = class(WndBase)
function WndFrame:ctor(__name, __data)
	__data = __data or {}
	local frame = nil
	if __data.type == "THIN" then
		frame = Wnd.OpenWindow("Interface/EasyUI/ini/WndFrameThin.ini", __name)
	elseif __data.type == "SMALL" then
		frame = Wnd.OpenWindow("Interface/EasyUI/ini/WndFrameSmall.ini", __name)
	elseif __data.type == "NORMAL" then
		frame = Wnd.OpenWindow("Interface/EasyUI/ini/WndFrame.ini", __name)
	elseif __data.type == "LARGER" then
		frame = Wnd.OpenWindow("Interface/EasyUI/ini/WndFrameLarger.ini", __name)
	elseif __data.type == "NONE" then
		frame = Wnd.OpenWindow("Interface/EasyUI/ini/WndFrameNone.ini", __name)
	end
	frame:SetName(__name)
	frame:Show()
	self.__this = frame
	self:SetSelf(self.__this)
	if __data.type and __data.type ~= "NONE" then
		frame:Lookup("Btn_Close").OnLButtonClick = function()
			Wnd.CloseWindow(__name)
		end
		if __data.title then
			self:SetTitle(__data.title)
		end
	end
end

function WndFrame:SetTitle(__title)
	self.__this:Lookup("", "Text_Title"):SetText(__title)
end

function WndFrame:GetTitle(__title)
	return self.__this:Lookup("", "Text_Title"):GetText()
end

EasyUI.CreateFrame = WndFrame.new

local WndWindow = class(WndBase)
function WndWindow:ctor(__parent, __name, __data)
	__data = __data or {}
	local hwnd = _Append(__parent, "Interface/EasyUI/ini/WndWindow.ini", "WndWindow", __name)
	self.__this = hwnd
	self:SetSelf(self.__this)
	if __data.w and __data.h then
		self:SetSize(__data.w, __data.h)
	end
	if __data.x and __data.y then
		self:SetRelPos(__data.x, __data.y)
	end
end

function WndWindow:SetSize(...)
	self.__this:SetSize(...)
	self.__this:Lookup("", ""):SetSize(...)
end

EasyUI.CreateWindow = WndWindow.new

local WndPageSet = class(WndBase)
function WndPageSet:ctor(__parent, __name, __data)
	__data = __data or {}
	local hwnd = _Append(__parent, "Interface/EasyUI/ini/WndPageSet.ini", "WndPageSet", __name)
	self.__this = hwnd
	self:SetSelf(self.__this)
	if __data.w and __data.h then
		self:SetSize(__data.w, __data.h)
	end
	if __data.x and __data.y then
		self:SetRelPos(__data.x, __data.y)
	end
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

EasyUI.CreatePageSet = WndPageSet.new

local WndButton = class(WndBase)
function WndButton:ctor(__parent, __name, __data)
	__data = __data or {}
	local hwnd = _Append(__parent, "Interface/EasyUI/ini/WndButton.ini", "WndButton", __name)
	self.__text = hwnd:Lookup("", "Text_Default")
	self.__text:SetText(__data.text or "")
	self.__this = hwnd
	self:SetSelf(self.__this)
	if __data.x and __data.y then
		self:SetRelPos(__data.x, __data.y)
	end
	if __data.w and __data.h then
		self:SetSize(__data.w, __data.h)
	end
	if __data.enable ~= nil then
		self:Enable(__data.enable)
	end
end

function WndButton:SetText(__text)
	self.__text:SetText(__text)
end

function WndButton:GetText()
	return self.__text:GetText()
end

function WndButton:OnClick(__action)
	self.__this.OnLButtonClick = __action
end

function WndButton:OnEnter(__action)
	self.__this.OnMouseEnter = __action
end

function WndButton:OnLeave(__action)
	self.__this.OnMouseLeave = __action
end

EasyUI.CreateButton = WndButton.new

local WndEdit = class(WndBase)
function WndEdit:ctor(__parent, __name, __data)
	__data = __data or {}
	local hwnd = _Append(__parent, "Interface/EasyUI/ini/WndEdit.ini", "WndEdit", __name)
	self.__edit = hwnd:Lookup("Edit_Default")
	self.__edit:SetText(__data.text or "")
	self.__this = hwnd
	self:SetSelf(self.__this)
	if __data.x and __data.y then
		self:SetRelPos(__data.x, __data.y)
	end
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

function WndEdit:OnChanged(__action)
	self.__edit.OnEditChanged = function()
		local __text = self.__edit:GetText()
		__action(__text)
	end
end


EasyUI.CreateEdit = WndEdit.new

local WndCheckBox = class(WndBase)
function WndCheckBox:ctor(__parent, __name, __data)
	__data = __data or {}
	local hwnd = _Append(__parent, "Interface/EasyUI/ini/WndCheckBox.ini", "WndCheckBox", __name)
	self.__text = hwnd:Lookup("", "Text_Default")
	self.__text:SetText(__data.text or "")
	self.__this = hwnd
	self:SetSelf(self.__this)
	if __data.x and __data.y then
		self:SetRelPos(__data.x, __data.y)
	end
	if __data.check then
		self:Check(__data.check)
	end
	if __data.enable ~= nil then
		self:Enable(__data.enable)
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

function WndCheckBox:OnCheck(__action)
	self.__this.OnCheckBoxCheck = function() __action(true) end
	self.__this.OnCheckBoxUncheck = function() __action(false) end
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

EasyUI.CreateCheckBox = WndCheckBox.new

local WndComboBox = class(WndBase)
function WndComboBox:ctor(__parent, __name, __data)
	__data = __data or {}
	local hwnd = _Append(__parent, "Interface/EasyUI/ini/WndComboBox.ini", "WndComboBox", __name)
	self.__text = hwnd:Lookup("", "Text_Default")
	self.__text:SetText(__data.text or "")
	self.__this = hwnd
	self:SetSelf(self.__this)
	if __data.x and __data.y then
		self:SetRelPos(__data.x, __data.y)
	end
	if __data.w then
		self:SetSize(__data.w)
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

function WndComboBox:OnClick(__action)
	self.__this:Lookup("Btn_ComboBox").OnLButtonClick = function()
		local __x, __y = self:GetAbsPos()
		local __w, __h = self:GetSize()
		local __menu = __action()
		__menu.nMiniWidth = __w
		__menu.x = __x
		__menu.y = __y + __h
		PopupMenu(__menu)
	end
end

EasyUI.CreateComboBox = WndComboBox.new

local WndRadioBox = class(WndBase)
local __RadioBoxGroups = {}
function WndRadioBox:ctor(__parent, __name, __data)
	__data = __data or {}
	local hwnd = _Append(__parent, "Interface/EasyUI/ini/WndRadioBox.ini", "WndRadioBox", __name)
	self.__text = hwnd:Lookup("", "Text_Default")
	self.__text:SetText(__data.text or "")
	self.__this = hwnd
	self:SetSelf(self.__this)
	if __data.x and __data.y then
		self:SetRelPos(__data.x, __data.y)
	end
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

function WndRadioBox:OnCheck(__action)
	self.__this.OnCheckBoxCheck = function()
		if self.__group then
			for k, v in pairs(__RadioBoxGroups[self.__group]) do
				if v:GetGroup() == this.__group and v:GetName() ~= this:GetName() then
					v:Check(false)
				end
			end
		end
		__action(true)
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

EasyUI.CreateRadioBox = WndRadioBox.new

local WndCSlider = class(WndBase)
function WndCSlider:ctor(__parent, __name, __data)
	__data = __data or {}
	local hwnd = _Append(__parent, "Interface/EasyUI/ini/WndCSlider.ini", "WndCSlider", __name)
	self.__scroll = hwnd:Lookup("Scroll_Default")
	self.__text = hwnd:Lookup("", "Text_Default")
	self.__this = hwnd
	self:SetSelf(self.__this)
	self.__min = __data.min
	self.__max = __data.max
	self.__step = __data.step
	self.__unit = __data.unit or ""
	self.__scroll:SetStepCount(__data.step)
	if __data.x and __data.y then
		self:SetRelPos(__data.x, __data.y)
	end
	if __data.w then
		self:SetSize(__data.w)
	end
	if __data.value then
		self:UpdateScrollPos(__data.value)
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

function WndCSlider:OnChanged(__action)
	self.__scroll.OnScrollBarPosChanged = function()
		local __step = this:GetScrollPos()
		local __value = self:GetValue(__step)
		__action(__value)
		self.__text:SetText(__value .. self.__unit)
	end
end

EasyUI.CreateCSlider = WndCSlider.new

local WndColorBox = class(WndBase)
function WndColorBox:ctor(__parent, __name, __data)
	__data = __data or {}
	local hwnd = _Append(__parent, "Interface/EasyUI/ini/WndColorBox.ini", "WndColorBox", __name)
	self.__text = hwnd:Lookup("", "Text_Default")
	self.__shadow = hwnd:Lookup("", "Shadow_Default")
	self.__this = hwnd
	self:SetSelf(self.__this)
	self.__r = __data.r
	self.__g = __data.g
	self.__b = __data.b
	self:SetText(__data.text)
	self:SetColor(__data.r, __data.g, __data.b)
	if __data.x and __data.y then
		self:SetRelPos(__data.x, __data.y)
	end
	if __data.w then
		self:SetSize(__data.w)
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

function WndColorBox:OnChanged(__action)
	self.__shadow.OnItemLButtonClick = function()
		local fnChangeColor = function(r, g, b)
			self:SetColor(r, g, b)
			__action({r, g, b})
		end
		OpenColorTablePanel(fnChangeColor)
	end
end

EasyUI.CreateColorBox = WndColorBox.new

local WndScroll = class(WndBase)
function WndScroll:ctor(__parent, __name, __data)
	__data = __data or {}
	local hwnd = _Append(__parent, "Interface/EasyUI/ini/WndScroll.ini", "WndScroll", __name)
	self.__this = hwnd
	self:SetSelf(self.__this)
	if __data.x and __data.y then
		self:SetRelPos(__data.x, __data.y)
	end
	if __data.w and __data.h then
		self:SetSize(__data.w, __data.h)
	end
	self.__up = self.__this:Lookup("Btn_Up")
	self.__down = self.__this:Lookup("Btn_Down")
	self.__scroll = self.__this:Lookup("Scroll_List")
	self.__handle = self.__this:Lookup("", "")
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
		return 1
	end
	self.__scroll.OnScrollBarPosChanged = function()
		local __value = this:GetScrollPos()
		if __value == 0 then
			self.__up:Enable(0)
		else
			self.__up:Enable(1)
		end
		if __value == this:GetStepCount() then
			self.__down:Enable(0)
		else
			self.__down:Enable(1)
		end
		self.__handle:SetItemStartRelPos(0, -__value * 10)
	end
	self:OnUpdateScorllList()
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
	self.__scroll:SetSize(15, __handle - 40)
	self.__scroll:SetRelPos(__w - 17, 20)
	self.__up:SetRelPos(__w - 20, 3)
	self.__down:SetRelPos(__w - 20, __h - 20)
end

EasyUI.CreateScroll = WndScroll.new
--[[
/script local f=EasyUI.CreateFrame("test")
local b=EasyUI.CreateButton(f,"b1",{text="Click Me",x=50,y=50,enable=false})
b:OnClick(function() Output("Click") end)
b:OnEnter(function() Output("Enter") end)
b:OnLeave(function() Output("Leave") end)
local e=EasyUI.CreateEdit(f,"e1",{text="input words",x=50,y=100})
e:OnChanged(function(arg0) Output(arg0) end)
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
s:OnChanged(function(arg0) Output(arg0) end)
local c3=EasyUI.CreateColorBox(f,"c3",{text="Color",x=50,y=350,r=255,g=255,b=0})
c3:OnChanged(function(arg0) Output(arg0) end)
/script local f=EasyUI.CreateFrame("test")
local s5=EasyUI.CreateScroll(f,"s5",{x=300,y=50})
]]
