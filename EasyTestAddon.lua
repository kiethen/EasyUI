

-- 创建插件
EasyTestAddon = CreateAddon("EasyTestAddon")

-- 窗体创建回调
EasyTestAddon.OnCreate = function()
	this:RegisterEvent("DO_SKILL_CAST")
end

-- 事件回调
EasyTestAddon.OnEvent = function(event)
	if event == "DO_SKILL_CAST" then
		if arg0 == UI_GetClientPlayerID() then
			Output(Table_GetSkillName(arg1, arg2))
		end
	end
end

-- 窗体渲染回调，只有在NONE类型Frame上才有效
EasyTestAddon.OnRender = function()
	Output("OnRender")
end

-- 窗体刷新回调
EasyTestAddon.OnUpdate = function()
	Output("OnUpdate")
end

-- 窗体销毁回调
EasyTestAddon.OnDestroy = function()
	Output("OnDestroy")
end

-- 窗体拖动回调
EasyTestAddon.OnDragEnd = function()
	Output("OnDragEnd")
end

-- 窗体按键响应回调
EasyTestAddon.OnKeyDown = function()
	Output("OnKeyDown")
end

-- 界面创建
EasyTestAddon.Open = function()
	EasyTestAddon.frame = EasyTestAddon:Append("Frame", "EasyTestAddon", {style = "SMALL"})
end
