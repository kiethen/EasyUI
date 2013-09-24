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
	if __data.type == "NONE" then

	else

	end
	local frame = Wnd.OpenWindow("interface/EasyUI/ini/WndFrame.ini", __name)
	frame:Lookup("Btn_Close").OnLButtonClick = function()
		Wnd.CloseWindow(__name)
	end
	frame:SetName(__name)
	frame:Show()
	self.__this = frame
	self:SetSelf(self.__this)
	if __data.title then
		self:SetTitle(__data.title)
	end
end

function WndFrame:SetTitle(__title)
	self.__this:Lookup("", "Text_Title"):SetText(__title)
end

function WndFrame:GetTitle(__title)
	return self.__this:Lookup("", "Text_Title"):GetText()
end

EasyUI.CreateFrame = WndFrame.new

local WndButton = class(WndBase)
function WndButton:ctor(__parent, __name, __data)
	__data = __data or {}
	local hwnd = _Append(__parent, "interface/EasyUI/ini/WndButton.ini", "WndButton", __name)
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
	local hwnd = _Append(__parent, "interface/EasyUI/ini/WndEdit.ini", "WndEdit", __name)
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
	self.__edit.OnEditChanged = __action
end


EasyUI.CreateEdit = WndEdit.new

local WndCheckBox = class(WndBase)
function WndCheckBox:ctor(__parent, __name, __data)
	__data = __data or {}
	local hwnd = _Append(__parent, "interface/EasyUI/ini/WndCheckBox.ini", "WndCheckBox", __name)
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

EasyUI.CreateCheckBox = WndCheckBox.new
--[[
/script local f=EasyUI.CreateFrame("test")
local b=EasyUI.CreateButton(f,"b1",{text="Click Me",x=50,y=50,enable=false})
b:OnClick(function() Output("Click") end)
b:OnEnter(function() Output("Enter") end)
b:OnLeave(function() Output("Leave") end)
local e=EasyUI.CreateEdit(f,"e1",{text="input words",x=50,y=100})
e:OnChanged(function() Output("Changed") end)
local c=EasyUI.CreateCheckBox(f,"c1",{text="Check Me",x=50,y=150,check=true})
c:OnCheck(function(arg0) Output(arg0) end)
]]