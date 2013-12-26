

-- 创建插件
EasyTestAddon = CreateAddon("EasyTestAddon")

EasyTestAddon:BindEvent("OnFrameDragEnd", "OnDragEnd")
EasyTestAddon:BindEvent("OnFrameDestroy", "OnDestroy")
EasyTestAddon:BindEvent("OnFrameKeyDown", "OnKeyDown")

EasyTestAddon.szText = "这是一行字符串"

-- 窗体创建回调
function EasyTestAddon:OnCreate()
	Output("Create")
	this:RegisterEvent("DO_SKILL_CAST")
end

-- 事件回调
--/script ReloadUIAddon()
function EasyTestAddon:OnScript(event)
	if event == "DO_SKILL_CAST" then
		if arg0 == UI_GetClientPlayerID() then
			Output(Table_GetSkillName(arg1, arg2))
		end
	end
end

-- 窗体渲染回调，只有在NONE类型Frame上才有效
--~ EasyTestAddon.OnRender = function()
--~ 	Output("OnRender")
--~ end

-- 窗体刷新回调
--~ EasyTestAddon.OnUpdate = function()
--~ 	Output("OnUpdate")
--~ end

-- 窗体销毁回调
function EasyTestAddon:OnDestroy()
	Output("OnDestroy")
end

-- 窗体拖动回调
function EasyTestAddon:OnDragEnd()
	Output("OnDragEnd", self.szText)
end

-- 窗体按键响应回调
--~ EasyTestAddon.OnKeyDown = function()
--~ 	Output("OnKeyDown")
--~ end

-- 界面创建
function EasyTestAddon:Open()
	EasyTestAddon:Append("Frame", "EasyTestAddon", {style = "SMALL"})
end
