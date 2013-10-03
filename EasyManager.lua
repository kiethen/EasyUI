
EasyManager = CreateAddon("EasyManager")

local tAddonClass = {"所有功能", "战斗增强", "界面增强", "组队团队", "辅助工具"}


EasyManager.OnCreate = function()
	this:RegisterEvent("UI_SCALED")
	EasyManager.UpdateAnchor(this)
end

EasyManager.UpdateAnchor = function(frame)
	frame:SetPoint("CENTER", 0, 0, "CENTER", 0, 0)
end

EasyManager.OnEvent = function(event)
	if event == "UI_SCALED" then
		EasyManager.UpdateAnchor(this)
	end
end

EasyManager.Init = function()
	local frame = EasyManager:Append("Frame", "MainFrame", {title = "插件管理", style = "NORMAL"})

	-- Tab BgImage
	local imgTab = EasyManager:Append("Image", frame,"TabImg",{w = 770,h = 33,x = 0,y = 50})
    imgTab:SetImage("ui\\Image\\UICommon\\ActivePopularize2.UITex",46)
	imgTab:SetImageType(11)

	local imgSplit = EasyManager:Append("Image", frame, "SplitImg", {w = 5, h = 400, x = 208, y = 100})
	imgSplit:SetImage("ui\\Image\\UICommon\\CommonPanel.UITex", 43)

	-- PageSet
	local hPageSet = EasyManager:Append("PageSet", frame, "PageSet",{x = 0,y = 50,w = 768,h = 434})
	for i = 1, 5 do
		local hBtn = EasyManager:Append("UICheckBox", hPageSet, "TabClass", {x = 50 + 83 * ( i- 1), y = 0, w = 83, h = 30, text = tAddonClass[i], group = "AddonClass"})
		local hWin = EasyManager:Append("Window", hPageSet, "Window"..i, {x = 0, y = 30, w = 768,h = 400})
		hPageSet:AddPage(hWin:GetSelf(), hBtn:GetSelf())
		hBtn.OnCheck = function(bCheck)
			if bCheck then
				hPageSet:ActivePage(i-1)
			end
		end
		if i == 1 then
			hBtn:Check(true)
		end

		local hScroll = EasyManager:Append("Scroll", hWin,"Scroll"..i,{x = 40,y = 20,w = 180,h = 380})
		for j = 0, 20 do
			local h = EasyManager:Append("Handle", hScroll, "h"..i..j, {w=180,h=22,postype=8})
			local img = EasyManager:Append("Image", h, "img"..i..j,{w=180,h=22,image="ui\\Image\\Common\\TextShadow.UITex",frame=2,lockshowhide=1})
			local txt = EasyManager:Append("Text", h, "txt"..i..j, {w=180,h=22,text=tAddonClass[i]..j})

			h.OnEnter = function() img:Show() end
			h.OnLeave = function() img:Hide() end
			h.OnClick = function() Output("Test") end
		end
		hScroll:OnUpdateScorllList()
	end


	return frame
end

EasyManager.OpenPanel = function()
	local frame = EasyManager:Lookup("MainFrame")
	if frame and frame:IsVisible() then
		frame:Destroy()
	else
		frame = EasyManager.Init()
	end
end

local tMenu = {
	{
		szOption = "插件管理",
		fnAction = function()
			EasyManager.OpenPanel()
		end,
	}
}
TraceButton_AppendAddonMenu(tMenu)
