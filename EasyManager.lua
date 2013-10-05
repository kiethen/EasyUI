
EasyManager = CreateAddon("EasyManager")

local tAddonClass = {
	{"All", "所有"},
	{"Combat", "战斗"},
	{"Raid", "团队"},
	{"Other", "其他"},
}

local tAddonModules = {}

local hLastBtn, hLastWin = nil, nil

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
	local frame = EasyManager:Append("Frame", "EasyManager", {title = "EasyUI插件管理", style = "NORMAL"})

	-- Tab BgImage
	local imgTab = EasyManager:Append("Image", frame,"TabImg",{w = 770,h = 33,x = 0,y = 50})
    imgTab:SetImage("ui\\Image\\UICommon\\ActivePopularize2.UITex",46)
	imgTab:SetImageType(11)

	local imgSplit = EasyManager:Append("Image", frame, "SplitImg", {w = 5, h = 400, x = 188, y = 100})
	imgSplit:SetImage("ui\\Image\\UICommon\\CommonPanel.UITex", 43)

	-- PageSet
	local hPageSet = EasyManager:Append("PageSet", frame, "PageSet", {x = 0, y = 50, w = 768, h = 434})
	for i = 1, #tAddonClass do
		-- Nav
		local hBtn = EasyManager:Append("UICheckBox", hPageSet, "TabClass", {x = 20 + 55 * ( i- 1), y = 0, w = 55, h = 30, text = tAddonClass[i][2], group = "AddonClass"})
		if i == 1 then
			hBtn:Check(true)
		end
		local hWin = EasyManager:Append("Window", hPageSet, "Window" .. i, {x = 0, y = 30, w = 768, h = 400})
		hPageSet:AddPage(hWin:GetSelf(), hBtn:GetSelf())
		hBtn.OnCheck = function(bCheck)
			if bCheck then
				hPageSet:ActivePage(i-1)
			end
		end

		-- Addon List
		local hScroll = EasyManager:Append("Scroll", hWin,"Scroll" .. i, {x = 20, y = 20, w = 180, h = 380})
		local tAddonList = EasyManager.GetAddonList(tAddonClass[i][1])
		for j = 1, #tAddonList, 1 do
			--Addon Box
			local hBox = EasyManager:Append("Handle", hScroll, "h" .. i .. j, {w = 160, h = 50, postype = 8})
			EasyManager:Append("Image", hBox, "imgBg" .. i .. j, {w = 155, h = 50, image = "ui\\image\\uicommon\\rankingpanel.UITex", frame = 10})

			local imgHover = EasyManager:Append("Image", hBox, "imgHover" .. i .. j, {w = 160, h = 50, image = "ui\\image\\uicommon\\rankingpanel.UITex", frame = 11, lockshowhide = 1})
			hBox.imgSel = EasyManager:Append("Image", hBox, "imgSel" .. i .. j, {w = 160, h = 50, image = "ui\\image\\uicommon\\rankingpanel.UITex", frame = 11, lockshowhide = 1})

			EasyManager:Append("Image", hBox, "imgIcon" .. i .. j, {w = 40, h = 40, x = 5,y = 5}):SetImage(3406)
			EasyManager:Append("Text", hBox, "txt" .. i .. j, {w = 100, h = 50, x = 55, y = 0, text = tAddonList[j].szTitle})

			hBox.OnEnter = function() imgHover:Show() end
			hBox.OnLeave = function() imgHover:Hide() end
			hBox.OnClick = function()
				if hLastBtn then
					hLastBtn.imgSel:Hide()
				end
				hLastBtn = hBox
				hBox.imgSel:Show()

				if hLastWin then
					EasyManager:Remove(hLastWin)
				end
				hLastWin = EasyManager:Append("Window", hWin, "Window" .. i .. j, {w = 530, h = 380, x = 210, y = 20})
				EasyManager.ShowAddonInfo(hLastWin, tAddonList[j].tWidget)
				PlaySound(SOUND.UI_SOUND, g_sound.Button)
			end
		end
		hScroll:OnUpdateScorllList()
	end
	return frame
end

EasyManager.GetAddonList = function(szClass)
	local temp = {}
	if szClass == tAddonClass[1][1] then
		return tAddonModules
	else
		for k, v in pairs(tAddonModules) do
			if v.szClass == szClass then
				table.insert(temp, v)
			end
		end
	end
	return temp
end

EasyManager.ShowAddonInfo = function(hWin, tWidget)
	for k, v in pairs(tWidget) do
		if v.type == "Text" then
			EasyManager:Append("Text", hWin, v.name, {w = v.w, h = v.h, x = v.x, y = v.y, text = v.text})
		elseif v.type == "Button" then
			local hButton = EasyManager:Append("Button", hWin, v.name, {w = v.w, x = v.x, y = v.y, text = v.text})
			hButton.OnClick = v.callback
		elseif v.type == "CheckBox" then
			local hCheckBox = EasyManager:Append("CheckBox", hWin, v.name, {w = v.w, x = v.x, y = v.y, text = v.text})
			hCheckBox:Check(v.default())
			hCheckBox.OnCheck = v.callback
		elseif v.type == "RadioBox" then
			local hRadioBox = EasyManager:Append("RadioBox", hWin, v.name, {w = v.w, x = v.x, y = v.y, text = v.text, group = v.group})
			hRadioBox:Check(v.default())
			hRadioBox.OnCheck = v.callback
		elseif v.type == "ComboBox" then
			local hComboBox = EasyManager:Append("ComboBox", hWin, v.name, {w = v.w, x = v.x, y = v.y, text = v.text})
			hComboBox.OnClick = v.callback
		elseif v.type == "ColorBox" then
			local hColorBox = EasyManager:Append("ColorBox", hWin, v.name, {w = v.w, x = v.x, y = v.y, text = v.text})
			hColorBox:SetColor(unpack(v.default()))
			hColorBox.OnChange = v.callback
		elseif v.type == "Edit" then
			local hEditBox = EasyManager:Append("Edit", hWin, v.name, {w = v.w, h = v.h, x = v.x, y = v.y, text = v.default()})
			hEditBox.OnChange = v.callback
		elseif v.type == "CSlider" then
			local hCSlider = EasyManager:Append("CSlider", hWin, v.name, {w = v.w, x = v.x, y = v.y, text = v.text, min = v.min, max = v.max, step = v.step, value = v.default(), unit = v.unit})
			hCSlider.OnChange = v.callback
		end
	end
end

EasyManager.RegisterPanel = function(tData)
	table.insert(tAddonModules, tData)
end

EasyManager.OpenPanel = function()
	local frame = EasyManager:Lookup("EasyManager")
	if frame and frame:IsVisible() then
		EasyManager:Remove(frame)
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
