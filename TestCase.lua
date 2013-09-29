
EasyTest  =  EasyTest or {}

local CreateFrame = EasyUI["CreateFrame"]
local CreateWindow = EasyUI["CreateWindow"]
local CreatePageSet = EasyUI["CreatePageSet"]
local CreateButton = EasyUI["CreateButton"]
local CreateEdit = EasyUI["CreateEdit"]
local CreateCheckBox = EasyUI["CreateCheckBox"]
local CreateComboBox = EasyUI["CreateComboBox"]
local CreateRadioBox = EasyUI["CreateRadioBox"]
local CreateCSlider = EasyUI["CreateCSlider"]
local CreateColorBox = EasyUI["CreateColorBox"]
local CreateScroll = EasyUI["CreateScroll"]
local CreateUICheckBox = EasyUI["CreateUICheckBox"]
local CreateHandle = EasyUI["CreateHandle"]
local CreateText = EasyUI["CreateText"]
local CreateImage = EasyUI["CreateImage"]
local CreateAnimate = EasyUI["CreateAnimate"]
local CreateShadow = EasyUI["CreateShadow"]
local CreateBox = EasyUI["CreateBox"]
local CreateTreeLeaf = EasyUI["CreateTreeLeaf"]

function EasyTest.Case()
	--创建一个面板
	local frame = CreateFrame("TestFrame1",{title = "控件测试",style = "NORMAL"})

	--创建TAB背景
	local tab = CreateImage(frame,"image1",{w = 770,h = 33,x =0,y = 50})
    tab:SetImage("ui\\Image\\UICommon\\ActivePopularize2.UITex",46)
	tab:SetImageType(11)

	--创建标签页
	local pageset = CreatePageSet(frame, "pageset",{x = 0,y = 50,w = 768,h = 400})

	--创建导航按钮
	local tbtn1 = CreateUICheckBox(frame,"tbtn1",{x = 50,y = 0,w = 83,h = 30,text = "标签1",group = "test",check = true})
	local tbtn2 = CreateUICheckBox(frame,"tbtn2",{x = 133,y = 0,w = 83,h = 30,text = "标签2",group = "test"})

	--创建虚窗口
	local window1 = CreateWindow(pageset,"window1",{x = 0,y = 50,w = 768,h = 400})
	local window2 = CreateWindow(pageset,"window2",{x = 0,y = 50,w = 768,h = 400})

	--新增两个标签页，参数必须先获取其本身 GetSelf()
	pageset:AddPage(window1:GetSelf(), tbtn1:GetSelf())
	pageset:AddPage(window2:GetSelf(), tbtn2:GetSelf())

	--绑定导航按钮点击事件，切换标签，以0为起始下标
	tbtn1.OnCheck = function(arg0)
		if arg0 then
			pageset:ActivePage(0)
		end
	end
	tbtn2.OnCheck = function(arg0)
		if arg0 then
			pageset:ActivePage(1)
		end
	end

	--创建一个按钮
	local button1 = CreateButton(window1,"button1",{text = "关闭",x = 50,y = 0,w = 91,h = 26})
	--绑定按钮点击事件
	button1.OnClick = function()
		frame:Destroy()
	end
	button1.OnEnter = function() Output("Enter") end
	button1.OnLeave = function() Output("Leave") end

	--创建一个按钮
	local button2 = CreateButton(window1,"button2",{text = "打开",x = 150,y = 0,w = 91,h = 26})
	button2.OnClick = function()
		EasyTestAddon.Open()
	end

	--创建一个编辑框
	local edit = CreateEdit(window1,"edit",{text = "编辑框测试",x = 50,y = 50})
	--绑定编辑框更改事件
	edit.OnChange = function(arg0) Output(arg0) end

	--创建一个复选框
	local checkbox1 = CreateCheckBox(window1,"checkbox1",{text = "复选框1",x = 50,y = 100,check = true})
	--绑定复选框选中事件
	checkbox1.OnCheck = function(arg0) Output(arg0) end

	local checkbox2 = CreateCheckBox(window1,"checkbox2",{text = "复选框2",x = 150,y = 100,check = true})
	--绑定复选框选中事件
	checkbox2.OnCheck = function(arg0) Output(arg0) end

	--创建一个下拉框
	local combobox1 = CreateComboBox(window1,"combobox1",{text = "下拉框测试",x = 50,y = 150})
	--绑定下拉框点击事件
	combobox1.OnClick = function(m)
		--local m = {}
		table.insert(m,{szOption = "测试菜单1"})
		table.insert(m,{szOption = "测试菜单2"})
		PopupMenu(m)
	end

	--创建三个单选框，并绑定选中事件
	local radiobox1 = CreateRadioBox(window1,"radiobox1",{text = "单选框1",x = 50,y = 200,check = true,group = "test1"})
	radiobox1.OnCheck = function(arg0)
		Output(arg0)
	end
	local radiobox2 = CreateRadioBox(window1,"radiobox2",{text = "单选框2",x = 150,y = 200,group = "test1"})
	radiobox2.OnCheck = function(arg0)
		Output(arg0)
	end
	local radiobox3 = CreateRadioBox(window1,"radiobox3",{text = "单选框3",x = 250,y = 200,group = "test1"})
	radiobox3.OnCheck = function(arg0)
		Output(arg0)
	end

	--创建一个滑块
	local cslider1 = CreateCSlider(window1,"cslider1",{x = 50,y = 250,w = 200,min = 0,max = 100,step = 100,value = 20,unit = "%"})
	--绑定滑块滑动事件
	cslider1.OnChange = function(arg0)
		Output(arg0)
	end

	--创建一个颜色选择器
	local colorbox1 = CreateColorBox(window1,"colorbox1",{text = "颜色选择器测试",x = 50,y = 300,w = 100,r = 255,g = 128,b = 255})
	--绑定颜色选择器点击事件
	colorbox1.OnChange = function(arg0)
		Output(arg0)
	end

	local text1 = CreateText(window1,"text1",{text = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",x = 50,y = 350,w=300,h=30})
	text1:SetFontSpacing(2)
	text1:SetFontColor(255,125,0)

	--创建滚动条
--~ 	local scroll1 = CreateScroll(window2,"ScrollTest",{x = 50,y = 0,w = 200,h = 350})
--~ 	scroll1:ClearHandle()
--~ 	--scroll1:SetHandleStyle(6)
--~ 	for i = 0, 30 do
--~ 		--创建Handle
--~ 		local handle = CreateHandle(scroll1,"handle"..i,{w = 175,h = 25,eventid=368})
--~ 		handle:SetPosType(10)
--~ 		handle:SetHandleStyle(3)
--~ 		handle.OnClick = function() Output("Click Scroll Item") end
--~ 		handle.OnEnter = function() Output("Enter Scroll Item") end
--~ 		handle.OnLeave = function() Output("Leave Scroll Item") end
--~ 		--创建文字
--~ 		CreateText(handle,"txt"..i,{text = "滚动条子项目"..i,w = 175,h = 25})
--~ 	end
--~ 	scroll1:OnUpdateScorllList() --滚动条必须在每次更新子项目时调用此接口

	--创建图像
	local image1 = CreateImage(frame,"image1",{w = 36,h = 36,x = 5,y = 10})
	image1:SetImage("ui\\Image\\UICommon\\CommonPanel.UITex",13)

	--创建动画
	local animate1 = CreateAnimate(window1,"animate1",{w = 161,h = 161,x = 240,y = 0,image = "ui/Image/Common/SprintGreenPower1.UITex"})

	--创建shadow
	local shadow1 = CreateShadow(window1,"shadow1",{x = 210,y = 290,w = 40,h = 40})
	shadow1:SetColorRGB(0,255,64)

	--创建box
	local box1 = CreateBox(window1,"box1",{x = 300,y = 285,w = 45,h = 45})
	box1:SetObject(UI_OBJECT_SKILL, 9003, 4)
	box1:SetObjectIcon(Table_GetSkillIconID(9003, 4))
	box1.OnEnter = function()
		this:SetObjectMouseOver(1)
		local x, y = this:GetAbsPos()
		local w, h = this:GetSize()
		local dwSkilID, dwSkillLevel = this:GetObjectData()
		OutputSkillTip(dwSkilID, dwSkillLevel, {x, y, w, h, 1}, false)
	end
	box1.OnLeave = function()
		this:SetObjectMouseOver(0)
		HideTip()
	end

	--创建TreeLeaf
--~ 	local scroll2 = CreateScroll(window2,"ScrollTest2",{x = 300,y = 0,w = 200,h = 350})
--~ 	for i = 0, 30 do
--~ 		local tree = CreateTreeLeaf(scroll2, "treeleaf"..i, {w = 100,h = 25})
--~ 		tree:SetPosType(10)
--~ 		tree:SetIconImage("ui\\Image\\button\\CommonButton_1.UITex", 12, 8)
--~ 		tree:SetNodeIconSize(20, 20)
--~ 		tree.OnClick = function() Output("111") tree:ExpandOrCollapse() tree:FormatAllItemPos() end
--~ 		--tree:AdjustNodeIconPos()
--~ 		CreateText(tree,"treetitle"..i,{text="标题"..i,x = 35,w = 60,h = 25})
--~ 		--[[for j = 0, 5 do
--~ 			local tree2 = CreateTreeLeaf(scroll2, "treeleafa"..i, {w = 60,h = 25})
--~ 			tree2:SetPosType(10)
--~ 			tree2:SetIconImage("ui\\Image\\button\\CommonButton_1.UITex", 12, 8)
--~ 			tree2:SetNodeIconSize(20, 20)
--~ 			CreateText(tree2,"treetitlea"..i,{text="标题"..i,x = 35,w = 60,h = 25})
--~ 		end]]
--~ 	end
--~ 	scroll2:OnUpdateScorllList()
end
