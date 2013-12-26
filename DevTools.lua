
DevTools = CreateAddon("DevTools")

local nViewType = nil
local szUitexPath = nil

local tImageTXTTitle = {
	{f = "i", t = "Farme"},
	{f = "i", t = "Left"},
	{f = "i", t = "Top"},
	{f = "i", t = "Width"},
	{f = "i", t = "High"},
	{f = "s", t = "File"},
}

local tImageFileList = {
	Button = {
		"UI/Image/Button/cgbutton",
		"UI/Image/Button/CommonButton_1",
		"UI/Image/Button/FrendnpartyButton",
		"UI/Image/Button/ShopButton",
		"UI/Image/Button/SystemButton",
		"UI/Image/Button/SystemButton_1",
	},

	ChannelsPanel = {
		"UI/Image/ChannelsPanel/NewChannels",
		"UI/Image/ChannelsPanel/NewChannels2",
	},

	ChatPanel = {
		"UI/Image/ChatPanel/editbox",
	},

	Common = {
		"UI/Image/Common/Animate",
		"UI/Image/Common/Box",
		"UI/Image/Common/CommonPanel",
		"UI/Image/Common/CoverShadow",
		"UI/Image/Common/DialogueLabel",
		"UI/Image/Common/KeynotesPanel",
		"UI/Image/Common/Logo",
		"UI/Image/Common/Mainpanel_1",
		"UI/Image/Common/MatrixAni",
		"UI/Image/Common/MatrixAni_1",
		"UI/Image/Common/MatrixAni_2",
		"UI/Image/Common/Money",
		"UI/Image/Common/playerfight",
		"UI/Image/Common/ProgressBar",
		"UI/Image/Common/sprintgreenpower1",
		"UI/Image/Common/sprintgreenpower2",
		"UI/Image/Common/sprintnewpower",
		"UI/Image/Common/sprintyellowpower1",
		"UI/Image/Common/sprintyellowpower2",
		"UI/Image/Common/TempBox",
		"UI/Image/Common/TextShadow",
	},

	GMPanel = {
		"UI/Image/GMPanel/gm1",
		"UI/Image/GMPanel/gm2",
		"UI/Image/GMPanel/gm3",
		"UI/Image/GMPanel/gmbg",
	},

	Helper = {
		"UI/Image/Helper/flopbg",
		"UI/Image/Helper/help",
		"UI/Image/Helper/help—bg",
		"UI/Image/Helper/helpmsg",
		"UI/Image/Helper/helpquest",
		"UI/Image/Helper/test",
	},

	LootPanel = {
		"UI/Image/LootPanel/lootpanel",
		"UI/Image/LootPanel/playerview",
	},

	MiddleMap = {
		"UI/Image/MiddleMap/mapwindow",
		"UI/Image/MiddleMap/mapwindow2",
	},

	Minimap = {
		"UI/Image/Minimap/battleminimap",
		"UI/Image/Minimap/Mapmark",
		"UI/Image/Minimap/Minimap",
		"UI/Image/Minimap/Minimap2",
		"UI/Image/Minimap/Minimap3",
	},

	QuestPanel = {
		"UI/Image/QuestPanel/QuestPanel",
		"UI/Image/QuestPanel/QuestPanelButton",
		"UI/Image/QuestPanel/QuestPanelPart",
	},

	TargetPanel = {
		"UI/Image/TargetPanel/CangjianAnimation1",
		"UI/Image/TargetPanel/CangjianAnimation2",
		"UI/Image/TargetPanel/frameplayer",
		"UI/Image/TargetPanel/Player",
		"UI/Image/TargetPanel/Target",
	},

	UICommon = {
		"UI/Image/UICommon/achievementpanel",
		"UI/Image/UICommon/achievementpanel2",
		"UI/Image/UICommon/activepopularize",
		"UI/Image/UICommon/activepopularize2",
		"UI/Image/UICommon/arenaintroduction",
		"UI/Image/UICommon/battlefiled",
		"UI/Image/UICommon/blackmarket",
		"UI/Image/UICommon/camp",
		"UI/Image/UICommon/Commonpanel",
		"UI/Image/UICommon/Commonpanel2",
		"UI/Image/UICommon/Commonpanel3",
		"UI/Image/UICommon/Commonpanel4",
		"UI/Image/UICommon/Commonpanel5",
		"UI/Image/UICommon/Commonpanel6",
		"UI/Image/UICommon/Commonpanel7",
		"UI/Image/UICommon/CompassPanel",
		"UI/Image/UICommon/crossingpanel1",
		"UI/Image/UICommon/crossingpanel4",
		"UI/Image/UICommon/crossingpanel5",
		"UI/Image/UICommon/crossingpanel6",
		"UI/Image/UICommon/crossingpanel7",
		"UI/Image/UICommon/exteriorbox",
		"UI/Image/UICommon/exteriorbox3",
		"UI/Image/UICommon/feedanimials",
		"UI/Image/UICommon/FEPanel",
		"UI/Image/UICommon/FEPanel3",
		"UI/Image/UICommon/guildmainpanel1",
		"UI/Image/UICommon/guildmainpanel2",
		"UI/Image/UICommon/HelpPanel",
		"UI/Image/UICommon/kuang_cyclopaedia_calender",
		"UI/Image/UICommon/LoginCommon",
		"UI/Image/UICommon/LoginSchool",
		"UI/Image/UICommon/MailCommon",
		"UI/Image/UICommon/new_cyclopaedia_calender",
		"UI/Image/UICommon/newskills1",
		"UI/Image/UICommon/newskills3",
		"UI/Image/UICommon/rankingpanel",
		"UI/Image/UICommon/PasswordPanel",
		"UI/Image/UICommon/sciencetree",
		"UI/Image/UICommon/ScienceTreeNode",
		"UI/Image/UICommon/skills",
		"UI/Image/UICommon/skills2",
		"UI/Image/UICommon/theflop",
		"UI/Image/UICommon/Talk_Face",
	},
}

local tEventIndex = {
	{"键盘按下", 13},
	{"键盘弹起", 14},

	{"左键按下", 1},
	{"左键弹起", 3},
	{"左键单击", 5},
	{"左键双击", 7},
	{"左键拖拽", 20},

	{"右键按下", 2},
	{"右键弹起", 4},
	{"右键单击", 6},
	{"右键双击", 8},
	{"右键拖拽", 19},

	{"中键按下", 15},
	{"中键弹起", 16},
	{"中键单击", 17},
	{"中键双击", 18},
	{"中键拖拽", 21},

	{"鼠标进出", 9},
	{"鼠标区域", 10},
	{"鼠标移动", 11},
	{"鼠标悬停", 22},
	{"滚动事件", 12},
}

DevTools.OnCreate = function()
	this:RegisterEvent("UI_SCALED")
	DevTools.UpdateAnchor(this)
end

DevTools.UpdateAnchor = function(frame)
	frame:SetPoint("CENTER", 0, 0, "CENTER", 0, 0)
end

DevTools.OnEvent = function(event)
	if event == "UI_SCALED" then
		DevTools.UpdateAnchor(this)
	end
end

DevTools.Init = function()
	local frame = DevTools:Append("Frame", "DevTools", {title = "开发者工具集", style = "NORMAL"})

	local imgTab = DevTools:Append("Image", frame,"TabImg",{w = 770,h = 33,x = 0,y = 50})
    imgTab:SetImage("ui\\Image\\UICommon\\ActivePopularize2.UITex", 46)
	imgTab:SetImageType(11)

	local hPageSet = DevTools:Append("PageSet", frame, "PageSet", {x = 0, y = 50, w = 768, h = 434})

	--图像查看器
	local hBtnUITexView = DevTools:Append("UICheckBox", hPageSet, "BtnUITexView", {x = 50, y = 0, w = 100, h = 30, text = "图像查看", group = "DevClass", check = true})
	local hWinUITexView = DevTools:Append("Window", hPageSet, "WindowUITexView", {x = 0, y = 30, w = 768, h = 400})
	hPageSet:AddPage(hWinUITexView:GetSelf(), hBtnUITexView:GetSelf())
	hBtnUITexView.OnCheck = function(bCheck)
		if bCheck then
			hPageSet:ActivePage(0)
		end
	end
	nViewType = 1

	DevTools:Append("Text", hWinUITexView, "ViewType", {x = 30, y = 10, text = "组件类型："})
	local hUITexViewRadioBox_Img = DevTools:Append("RadioBox", hWinUITexView, "RB_1", {x = 100, y = 12, text = "图像", group = "ViewType", check = true})
	hUITexViewRadioBox_Img.OnCheck = function(arg0)
		if arg0 then
			nViewType = 1
			DevTools.LoadUITex(szUitexPath)
		end
	end
	local hUITexViewRadioBox_Ani = DevTools:Append("RadioBox", hWinUITexView, "RB_2", {x = 170, y = 12, text = "动画", group = "ViewType"})
	hUITexViewRadioBox_Ani.OnCheck = function(arg0)
		if arg0 then
			nViewType = 2
			DevTools.LoadUITex(szUitexPath)
		end
	end

	DevTools:Append("Text", hWinUITexView, "UITexPath", {x = 300, y = 10, text = "路径："})
	local hUITexViewComboBox_Path = DevTools:Append("ComboBox", hWinUITexView, "CB_1", {x = 340, y = 12, w = 400})
	hUITexViewComboBox_Path.OnClick = function(m)
		PopupMenu(DevTools.GetMenu(m))
	end

	local hUITexViewShadowBg = DevTools:Append("Shadow", hWinUITexView, "BG", {x = 15, y = 50, w = 738, h = 365})
	hUITexViewShadowBg:SetColorRGB(0, 0, 0)

	local hUITexViewContentScroll = DevTools:Append("Scroll", hWinUITexView ,"hUITexViewContentScroll",{ x = 15,y = 50,w = 755, h = 365})
	local hUITexViewContent = DevTools:Append("Handle", hUITexViewContentScroll, "UITexViewContent", {x = 5, y = 5, w = 738, h = 355})
	hUITexViewContentScroll:UpdateList()

	--事件和字体查看器
	local hBtnFontView = DevTools:Append("UICheckBox", hPageSet, "BtnFontView", {x = 150, y = 0, w = 150, h = 30, text = "事件和字体查看", group = "DevClass"})
	local hWinFontView = DevTools:Append("Window", hPageSet, "WindowFontView", {x = 0, y = 30, w = 758, h = 400})
	hPageSet:AddPage(hWinFontView:GetSelf(), hBtnFontView:GetSelf())
	hBtnFontView.OnCheck = function(bCheck)
		if bCheck then
			hPageSet:ActivePage(1)
		end
	end

	DevTools:Append("Image", hWinFontView, "imgDivide1", {w = 280, h = 8, x = 30, y = 45, image = "ui\\Image\\UICommon\\CommonPanel.UITex", frame = 45}):SetImageType(11)
	DevTools:Append("Image", hWinFontView, "imgDivide2", {w = 280, h = 8, x = 30, y = 370, image = "ui\\Image\\UICommon\\CommonPanel.UITex", frame = 45}):SetImageType(11)

	DevTools.LoadEventIDBox(hWinFontView)

	DevTools:Append("Image", hWinFontView, "SplitImg", {w = 5, h = 400, x = 340, y = 20, image = "ui\\Image\\UICommon\\CommonPanel.UITex", frame = 43})

	local hTextViewContentScroll = DevTools:Append("Scroll", hWinFontView ,"hTextViewContentScroll",{x = 370, y = 20, w = 380, h = 390})
	DevTools.LoadTextDummy(hTextViewContentScroll)

	--图标查看器
	local hBtnIconView = DevTools:Append("UICheckBox", hPageSet, "BtnIconView", {x = 300, y = 0, w = 100, h = 30, text = "图标查看", group = "DevClass"})
	local hWinIconView = DevTools:Append("Window", hPageSet, "WindowIconView", {x = 0, y = 30, w = 758, h = 400})
	hPageSet:AddPage(hWinIconView:GetSelf(), hBtnIconView:GetSelf())
	hBtnIconView.OnCheck = function(bCheck)
		if bCheck then
			hPageSet:ActivePage(2)
		end
	end
	DevTools.LoadIconBox(hWinIconView)

	return frame
end

DevTools.GetMenu = function(menu)
	for k, v in pairs(tImageFileList) do
		local m_t = {szOption = k}
		for kk, vv in pairs(v) do
			local m_c = {
				szOption = vv,
				fnAction = function()
					DevTools.LoadUITex(vv)
					szUitexPath = vv
					DevTools:Lookup("CB_1"):SetText(string.format("%s.UITex", vv))
				end
			}
			table.insert(m_t, m_c)
		end
		table.insert(menu, m_t)
	end
	return menu
end

DevTools.OutputTip = function(item)
	local nMouseX, nMouseY = Cursor.GetPos()
	local szTipInfo =
		"<Text>text=" .. EncodeComponentsString("★ 帧编号：") .. " font=162 </text>" ..
		"<Text>text=" .. EncodeComponentsString(item.nFrameIndex or item.nAniGroup) .. " font=100 </text>" ..
		"<Text>text=" .. EncodeComponentsString("\n☆ 帧宽度：") .. " font=162 </text>" ..
		"<Text>text=" .. EncodeComponentsString(item.nW) .. " font=162 </text>" ..
		"<Text>text=" .. EncodeComponentsString("\n☆ 帧高度：") .. " font=162 </text>" ..
		"<Text>text=" .. EncodeComponentsString(item.nH) .. " font=162 </text>"
	OutputTip(szTipInfo, 1000, {nMouseX, nMouseY, 0, 0})
end

DevTools.OutputIconTip = function(ID)
	local nMouseX, nMouseY = Cursor.GetPos()
	local szTipInfo =
		"<Text>text=" .. EncodeComponentsString("★ 图标ID：") .. " font=162 </text>" ..
		"<Text>text=" .. EncodeComponentsString(ID) .. " font=100 </text>"
	OutputTip(szTipInfo, 1000, {nMouseX, nMouseY, 0, 0})
end


DevTools.GetImageFrameInfo = function(szImageFile)
	return KG_Table.Load(szImageFile, tImageTXTTitle, FILE_OPEN_MODE.NORMAL)
end

DevTools.LoadUITex = function(szBaseName)
	local hContent = DevTools:Lookup("UITexViewContent")
	hContent:ClearHandle()

	local hHOver = DevTools:Append("Image", hContent, "ImageHover", {x = 0, y = 0, w = 50, h = 50, image = "ui\\Image\\Common\\Box.UITex", frame = 1, lockshowhide=1})
	hHOver:SetImageType(10)
	hHOver:SetAlpha(150)

	if not szBaseName then
		return
	end
	local tInfo = DevTools.GetImageFrameInfo(szBaseName .. ".txt")
	if not tInfo then
		return
	end


	if nViewType == 1 then
		for i = 0, 256 do
			local tLine = tInfo:Search(i)
			if tLine then
				if tonumber(tLine.Width) ~= 0 and tonumber(tLine.High) ~= 0 then
					local img = DevTools:Append("Image", hContent, "Image_" .. i, {x = tonumber(tLine.Left), y = tonumber(tLine.Top), w = tonumber(tLine.Width), h = tonumber(tLine.High), image = string.format("%s.UITex", szBaseName), frame = i, eventid = 277})

					img.nFrameIndex = i
					img.szBaseFileName = szBaseName
					img.nX = tonumber(tLine.Left)
					img.nY = tonumber(tLine.Top)
					img.nW = tonumber(tLine.Width)
					img.nH = tonumber(tLine.High)

					img.OnEnter = function()
						hHOver:Show()
						hHOver:SetSize(img.nW + 2, img.nH + 2)
						local x, y = img:GetAbsPos()
						hHOver:SetAbsPos(x - 1, y - 1)
						DevTools.OutputTip(img)
					end
					img.OnLeave = function()
						hHOver:Hide()
						HideTip()
					end
				end
			else
				break
			end
		end
	elseif nViewType == 2 then
		local nAniX = 10
		local nAniY = 10
		local nAniNextY = nAniY
		for i = 0, 99 do
			local ani = DevTools:Append("Animate", hContent,"Animate_" .. i, {w = 50,h = 50, x = nAniX, y = nAniY, image = string.format("%s.UITex", szBaseName), eventid = 277})
			ani:SetGroup(i)
			ani:SetLoopCount(-1)
			ani:AutoSize()

			local nAniW, nAniH = ani:GetSize()

			ani.nAniGroup = i
			ani.szBaseFileName = szBaseName
			ani.nX = nAniX
			ani.nY = nAniY
			ani.nW = nAniW
			ani.nH = nAniH

			ani.OnEnter = function()
				hHOver:Show()
				hHOver:SetSize(ani.nW + 2, ani.nH + 2)
				local x, y = ani:GetAbsPos()
				hHOver:SetAbsPos(x - 1, y - 1)
				DevTools.OutputTip(ani)
			end
			ani.OnLeave = function()
				hHOver:Hide()
				HideTip()
			end

			nAniX = nAniX + nAniW + 10
			if nAniNextY <= nAniY + nAniH then
				nAniNextY = nAniY + nAniH + 10
			end
			if nAniX >= 500 then
				nAniY = nAniNextY
				nAniX = 10
			end
		end
	end
	hContent:FormatAllItemPos()
	hContent:SetSizeByAllItemSize()
	DevTools:Lookup("hUITexViewContentScroll"):UpdateList()
end

DevTools.LoadEventIDBox = function(hWin)
	for k, v in ipairs(tEventIndex) do
		DevTools:Append("CheckBox", hWin, "CheckBox_" .. v[2], {x = ((k - 1) % 3) * 100 + 30, y = math.floor((k - 1) / 3) * 40 + 60, w = 100, text = v[1]})
	end
	DevTools:Append("Text", hWin, "EventIDTexr", {x = 35, y = 10, text = "事件ID："})
	hBtnCalc = DevTools:Append("Button", hWin, "BtnCalc", {x = 200, y = 10, text = "计算"})
	hEventIDEdit = DevTools:Append("Edit", hWin, "EventIDEdit", {w = 100, h = 25, x = 90, y = 11, text = "0"})
	hBtnCalc.OnClick = function()
		local tBitTab = {}
		for i = 1, 22 do
			tBitTab[i] = 0
			if DevTools:Lookup("CheckBox_" .. i):IsChecked() then
				tBitTab[i] = 1
			end
		end
		local nEventID = DevTools.BitTable2UInt(tBitTab) or 0
		hEventIDEdit:SetText(nEventID)
	end
	local hCheckAll = DevTools:Append("CheckBox", hWin, "CheckBoxAll", {x = 130, y = 380, w = 100, text = "全选"})
	hCheckAll.OnCheck = function(bCheck)
		for i = 1, 22 do
			DevTools:Lookup("CheckBox_" .. i):Check(bCheck)
		end
	end
	local hCheckRev = DevTools:Append("CheckBox", hWin, "CheckBoxRev", {x = 230, y = 380, w = 100, text = "反选"})
	hCheckRev.OnCheck = function(bCheck)
		for i = 1, 22 do
			local hCheck = DevTools:Lookup("CheckBox_" .. i)
			if hCheck:IsChecked() then
				hCheck:Check(false)
			else
				hCheck:Check(true)
			end
		end
	end
end

DevTools.BitTable2UInt = function(tBitTab)
	local nUInt = 0
	for i = 1, 24 do
		nUInt = nUInt + (tBitTab[i] or 0) * (2 ^ (i - 1))
	end
	return nUInt
end

DevTools.LoadTextDummy = function(hScroll)
	for i = 0, 255 do
		local hBox = DevTools:Append("Handle", hScroll, "hFont_" .. i, {w = 40, h = 30, postype = 8})
		local text = DevTools:Append("Text", hBox, "FontDummy_" .. i, {w = 10, h = 10})
		text:SetFontScheme(i)
		text.nFontScheme = i

		local nFS = text:GetFontScheme()
		if nFS == i then
			text:SetText("#" .. nFS)

			local nX = i % 10 * 39
			local nY = math.floor(i / 10) * 25
			text:SetRelPos(nX, nY)
		else
			text:SetText("")
			text:SetRelPos(4000, 4000)
			text:Hide()
		end
	end
	hScroll:UpdateList()
end

DevTools.LoadIconBox = function(hWin)
	local hIconViewContent = DevTools:Append("Handle", hWin, "IconViewContent", {x = 33, y = 33, w = 700, h = 300})
	for i = 1, 84 do
		local icon = DevTools:Append("Image", hIconViewContent, "Icon_" .. i, {x = ((i - 1) % 14) * 50, y = math.floor((i - 1) / 14) * 50, w = 45, h = 45, eventid = 277})
		icon:FromIconID(i)
		icon.OnEnter = function() DevTools.OutputIconTip(i) end
		icon.OnLeave = function() HideTip() end
	end
	local hBtnPrev = DevTools:Append("Button", hWin, "BtnIconPrev", {x = 200, y = 350, text = "上一页", enable = false})
	local hBtnNext = DevTools:Append("Button", hWin, "BtnIconNext", {x = 410, y = 350, text = "下一页"})
	local n, nTol = 1, math.ceil(3481 / 84)
	local hPage = DevTools:Append("Text", hWin, "TextIconPage", {x = 340, y = 350, text = n .. "/" .. nTol})
	hBtnPrev.OnClick = function()
		n = math.max(1, n - 1)
		hPage:SetText(n .. "/" .. nTol)
		if n == 1 then
			hBtnPrev:Enable(false)
		else
			hBtnPrev:Enable(true)
		end
		hBtnNext:Enable(true)
		for i = 1, 84 do
			local icon, k = DevTools:Lookup("Icon_" .. i), (n - 1) * 84 + i
			icon:FromIconID(k)
			icon.OnEnter = function() DevTools.OutputIconTip(k) end
			icon.OnLeave = function() HideTip() end
		end
	end
	hBtnNext.OnClick = function()
		n = math.min(nTol, n + 1)
		hPage:SetText(n .. "/" .. nTol)
		if n == nTol then
			hBtnNext:Enable(false)
		else
			hBtnNext:Enable(true)
		end
		hBtnPrev:Enable(true)
		for i = 1, 84 do
			local icon, k = DevTools:Lookup("Icon_" .. i), (n - 1) * 84 + i
			icon:FromIconID(k)
			icon.OnEnter = function() DevTools.OutputIconTip(k) end
			icon.OnLeave = function() HideTip() end
		end
	end

end

DevTools.OpenPanel = function()
	local frame = EasyManager:Lookup("DevTools")
	if frame and frame:IsVisible() then
		DevTools:Remove(frame)
	else
		frame = DevTools.Init()
	end
end
