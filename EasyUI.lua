local _class = {}

local function class(super)
	local class_type = {}
	class_type.ctor = false
	class_type.super = super
	class_type.new = function(...)
		local obj = {}
		setmetatable(obj,{ __index = _class[class_type]})	--写这构造函数中可以调用其他函数
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
			function(t,k)
				local ret = _class[super][k]
				vtbl[k] = ret
				return ret
			end
		})
	end

	return class_type
end

EasyUI = {}

local _SetParent = function(__parent, __ini, __type, __name)
	if string.sub(__type, 1, 3) == "Wnd" then
		local wnd = Wnd.OpenWindow(__ini, __name):Lookup(__type)
		wnd:ChangeRelation(__parent, true, true)
		wnd:SetName(__name)
		Wnd.CloseWindow(__name)
		return wnd
	else
		__parent:AppendItemFromIni(__ini, __type, __name)
	end
end

local WndFrame = class()
function WndFrame:ctor(__name, __data)
	if __data.type == "NONE" then

	else

	end
	local frame = Wnd.OpenWindow("interface/EasyUI/ini/WndFrame.ini", __name)
	frame:Lookup("Btn_Close").OnLButtonClick = function()
		Wnd.CloseWindow(__name)
	end
	frame:SetName(__name)
	frame:Show()
	self.frame = frame
	if __data.title then
		self:SetTitle(__data.title)
	end
end

function WndFrame:SetTitle(__title)
	self.frame:Lookup("", "Text_Title"):SetText(__title)
end
