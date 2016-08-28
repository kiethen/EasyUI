
EasyManager = EasyUI.CreateAddon("EasyManager")
EasyManager:BindEvent("OnFrameDestroy", "OnDestroy")

EasyManager.tAddonClass = {
	{"All", "所有"},
	{"Combat", "战斗"},
	{"Raid", "团队"},
	{"Other", "其他"},
}
EasyManager.tAddonModules = {}
EasyManager.hLastBtn = nil
EasyManager.hLastWin = nil

function EasyManager:OnCreate()
	this:RegisterEvent("UI_SCALED")
	self:UpdateAnchor(this)
end

function EasyManager:UpdateAnchor(frame)
	frame:SetPoint("CENTER", 0, 0, "CENTER", 0, 0)
end

function EasyManager:OnScript(event)
	if event == "UI_SCALED" then
		self:UpdateAnchor(this)
	end
end

function EasyManager:Init()
	local frame = self:Append("Frame", "EasyManager", {title = "EasyUI插件管理", style = "NORMAL"})

	-- Tab BgImage
	local imgTab = self:Append("Image", frame,"TabImg",{w = 770,h = 33,x = 0,y = 50})
    imgTab:SetImage("ui\\Image\\UICommon\\ActivePopularize2.UITex",46)
	imgTab:SetImageType(11)

	local imgSplit = self:Append("Image", frame, "SplitImg", {w = 5, h = 400, x = 188, y = 100})
	imgSplit:SetImage("ui\\Image\\UICommon\\CommonPanel.UITex", 43)

	-- PageSet
	local hPageSet = self:Append("PageSet", frame, "PageSet", {x = 0, y = 50, w = 768, h = 434})
	for i = 1, #self.tAddonClass do
		-- Nav
		local hBtn = self:Append("UICheckBox", hPageSet, "TabClass" .. i, {x = 20 + 55 * ( i- 1), y = 0, w = 55, h = 30, text = self.tAddonClass[i][2], group = "AddonClass"})
		if i == 1 then
			hBtn:Check(true)
		end
		local hWin = self:Append("Window", hPageSet, "Window" .. i, {x = 0, y = 30, w = 768, h = 400})
		hPageSet:AddPage(hWin:GetSelf(), hBtn:GetSelf())
		hBtn.OnCheck = function(bCheck)
			if bCheck then
				hPageSet:ActivePage(i-1)
			end
		end

		-- Addon List
		local hScroll = self:Append("Scroll", hWin,"Scroll" .. i, {x = 20, y = 20, w = 180, h = 380})
		local tAddonList = self:GetAddonList(self.tAddonClass[i][1])
		for j = 1, #tAddonList, 1 do
			--Addon Box
			local hBox = self:Append("Handle", hScroll, "hBox" .. i .. j, {w = 160, h = 50, postype = 8})
			self:Append("Image", hBox, "imgBg" .. i .. j, {w = 155, h = 50, image = "ui\\image\\uicommon\\rankingpanel.UITex", frame = 10})

			local imgHover = self:Append("Image", hBox, "imgHover" .. i .. j, {w = 160, h = 50, image = "ui\\image\\uicommon\\rankingpanel.UITex", frame = 11, lockshowhide = 1})
			hBox.imgSel = self:Append("Image", hBox, "imgSel" .. i .. j, {w = 160, h = 50, image = "ui\\image\\uicommon\\rankingpanel.UITex", frame = 11, lockshowhide = 1})

			self:Append("Image", hBox, "imgIcon" .. i .. j, {w = 40, h = 40, x = 5,y = 5}):SetImage(tAddonList[j].dwIcon)
			self:Append("Text", hBox, "txt" .. i .. j, {w = 100, h = 50, x = 55, y = 0, text = tAddonList[j].szTitle})

			hBox.OnEnter = function()
				hBox.bOver = true
				self:UpdateBgStatus(hBox)
			end
			hBox.OnLeave = function()
				hBox.bOver = false
				self:UpdateBgStatus(hBox)
			end
			hBox.OnClick = function()
				if not hBox.winSel then
					hBox.winSel = self:Append("Window", hWin, "Window" .. i .. j, {w = 530, h = 380, x = 210, y = 20})
					self:AppendAddonInfo(hBox.winSel, tAddonList[j].tWidget)
				end
				self:Selected(hBox, i, #tAddonList)
				PlaySound(SOUND.UI_SOUND, g_sound.Button)
			end
		end
		hScroll:UpdateList()
	end
	return frame
end

function EasyManager:Selected(hBox, nS, nTotal)
	for i = 1, nTotal do
		local hI = self:Fetch("hBox" .. nS .. i)
		if hI.bSel then
			hI.bSel = false
			hI.imgSel:Hide()
			if hI.winSel then
				hI.winSel:Hide()
			end
		end
	end
	hBox.bSel = true
	hBox.winSel:Show()
	self:UpdateBgStatus(hBox)
end

function EasyManager:UpdateBgStatus(hBox)
	if hBox.bSel then
		hBox.imgSel:Show()
		hBox.imgSel:SetAlpha(255)
	elseif hBox.bOver then
		hBox.imgSel:Show()
		hBox.imgSel:SetAlpha(150)
	else
		hBox.imgSel:Hide()
	end
end

function EasyManager:GetAddonList(szClass)
	local temp = {}
	if szClass == self.tAddonClass[1][1] then
		return self.tAddonModules
	else
		for k, v in pairs(self.tAddonModules) do
			if v.szClass == szClass then
				table.insert(temp, v)
			end
		end
	end
	return temp
end

function EasyManager:AppendAddonInfo(hWin, tWidget)
	for k, v in pairs(tWidget) do
		if v.type == "Text" then
			self:Append("Text", hWin, v.name, {w = v.w, h = v.h, x = v.x, y = v.y, text = v.text, font = v.font})
		elseif v.type == "TextButton" then
			local handle = self:Append("Handle", hWin, v.name, {w = v.w, h = v.h, x = v.x, y = v.y})
			local text = self:Append("Text", handle, "t_" .. v.name, {w = v.w, h = v.h, text = v.text, font = v.font})
			handle.OnEnter = function() text:SetFontScheme(168) end
			handle.OnLeave = function() text:SetFontScheme(v.font) end
			handle.OnClick = v.callback
		elseif v.type == "Button" then
			local hButton = self:Append("Button", hWin, v.name, {w = v.w, x = v.x, y = v.y, text = v.text})
			hButton:Enable((v.enable == nil) and true or v.enable())
			hButton.OnClick = v.callback
		elseif v.type == "CheckBox" then
			local hCheckBox = self:Append("CheckBox", hWin, v.name, {w = v.w, x = v.x, y = v.y, text = v.text})
			hCheckBox:Check(v.default())
			hCheckBox:Enable((v.enable == nil) and true or v.enable())
			hCheckBox.OnCheck = function(arg0)
				v.callback(arg0)
				for _, v2 in pairs(tWidget) do
					if v2.enable ~= nil then
						self:Fetch(v2.name):Enable(v2.enable())
					end
				end
			end
		elseif v.type == "RadioBox" then
			local hRadioBox = self:Append("RadioBox", hWin, v.name, {w = v.w, x = v.x, y = v.y, text = v.text, group = v.group})
			hRadioBox:Check(v.default())
			hRadioBox:Enable((v.enable == nil) and true or v.enable())
			hRadioBox.OnCheck = v.callback
		elseif v.type == "ComboBox" then
			local hComboBox = self:Append("ComboBox", hWin, v.name, {w = v.w, x = v.x, y = v.y, text = v.text})
			hComboBox:Enable((v.enable == nil) and true or v.enable())
			hComboBox.OnClick = v.callback
		elseif v.type == "ColorBox" then
			local hColorBox = self:Append("ColorBox", hWin, v.name, {w = v.w, x = v.x, y = v.y, text = v.text})
			hColorBox:SetColor(unpack(v.default()))
			hColorBox.OnChange = v.callback
		elseif v.type == "Edit" then
			local hEditBox = self:Append("Edit", hWin, v.name, {w = v.w, h = v.h, x = v.x, y = v.y, text = v.default()})
			hEditBox:Enable((v.enable == nil) and true or v.enable())
			hEditBox.OnChange = v.callback
		elseif v.type == "CSlider" then
			local hCSlider = self:Append("CSlider", hWin, v.name, {w = v.w, x = v.x, y = v.y, text = v.text, min = v.min, max = v.max, step = v.step, value = v.default(), unit = v.unit})
			hCSlider:Enable((v.enable == nil) and true or v.enable())
			hCSlider.OnChange = v.callback
		end
	end
end

function EasyManager:RegisterPanel(tData)
	table.insert(self.tAddonModules, tData)
end

function EasyManager:OnDestroy()
	PlaySound(SOUND.UI_SOUND,g_sound.CloseFrame)
end

function EasyManager:OpenPanel()
	local frame = self:Fetch("EasyManager")
	if frame and frame:IsValid() and frame:IsVisible() then
		frame:Destroy()
	else
		frame = self:Init()
		PlaySound(SOUND.UI_SOUND,g_sound.OpenFrame)
	end
end
RegisterEvent("LOADING_END", function()
	local hWnd = Station.Lookup("Normal/Minimap/Wnd_Minimap/Wnd_Over")
	local btn = hWnd:Lookup("Btn_EasyManager")
	if btn then
		btn.__reference = EasyManager
	else
		local uiBtn = EasyUI.CreateUIButton(hWnd, "Btn_EasyManager", {w = 34, h = 34, x = -5, y = 130, ani = {"ui\\Image\\Button\\SystemButton.UITex", 39, 40, 41, 42}})
		uiBtn:GetSelf().__reference = EasyManager
		uiBtn.OnClick = function()
			-- When ReloadUIAddon() called, the _G and EasyManager would not be update here
			this.__reference:OpenPanel()
		end
		uiBtn.OnEnter = function()
			local x, y = this:GetAbsPos()
			local w, h = this:GetSize()
			local szTip = GetFormatText("插件管理", 163) .. GetFormatText("\n单击这里可以打开插件管理器。", 162)
			OutputTip(szTip, 400, {x, y, w, h})
		end
		uiBtn.OnLeave = function()
			HideTip()
		end
	end
end)
