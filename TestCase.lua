
EasyUI  =  EasyUI or {}

function EasyUI.TestCase()
	--创建一个面板
	local frame = EasyUI.CreateFrame("TestFrame1",{title = "控件测试",style = "NORMAL"})

	--创建一个按钮
	local button1 = EasyUI.CreateButton(frame,"button1",{text = "关闭",x = 50,y = 50,w = 91,h = 26})
	--绑定按钮点击事件
	button1:OnClick(function()
		Output("Click")
		f:Remove()
	end)

	--创建一个按钮
	local button2 = EasyUI.CreateButton(frame,"button2",{text = "禁用",x = 150,y = 50,w = 91,h = 26,enable = false})

	--创建一个编辑框
	local edit = EasyUI.CreateEdit(frame,"edit",{text = "编辑框测试",x = 50,y = 100})
	--绑定编辑框更改事件
	edit:OnChange(function(arg0)
		Output(arg0)
	end)

	--创建一个复选框
	local checkbox1 = EasyUI.CreateCheckBox(frame,"checkbox1",{text = "复选框1",x = 50,y = 150,check = true})
	--绑定复选框选中事件
	checkbox1:OnCheck(function(arg0)
		Output(arg0)
	end)
	local checkbox2 = EasyUI.CreateCheckBox(frame,"checkbox2",{text = "复选框2",x = 150,y = 150,check = true})
	--绑定复选框选中事件
	checkbox2:OnCheck(function(arg0)
		Output(arg0)
	end)

	--创建一个下拉框
	local combobox1 = EasyUI.CreateComboBox(frame,"combobox1",{text = "下拉框测试",x = 50,y = 200})
	--绑定下拉框点击事件
	combobox1:OnClick(function()
		local m = {}
		table.insert(m,{szOption = "测试菜单1"})
		table.insert(m,{szOption = "测试菜单2"})
		return m
	end)

	--创建三个单选框，并绑定选中事件
	local radiobox1 = EasyUI.CreateRadioBox(frame,"radiobox1",{text = "单选框1",x = 50,y = 250,check = true,group = "test1"})
	radiobox1:OnCheck(function(arg0)
		Output(arg0)
	end)
	local radiobox2 = EasyUI.CreateRadioBox(frame,"radiobox2",{text = "单选框2",x = 150,y = 250,group = "test1"})
	radiobox2:OnCheck(function(arg0)
		Output(arg0)
	end)
	local radiobox3 = EasyUI.CreateRadioBox(frame,"radiobox3",{text = "单选框3",x = 250,y = 250,group = "test1"})
	radiobox3:OnCheck(function(arg0)
		Output(arg0)
	end)

	--创建一个滑块
	local cslider1 = EasyUI.CreateCSlider(frame,"cslider1",{x = 50,y = 300,w = 200,min = 0,max = 100,step = 100,value = 20,unit = "%"})
	--绑定滑块滑动事件
	cslider1:OnChange(function(arg0)
		Output(arg0)
	end)

	--创建一个颜色选择器
	local colorbox1 = EasyUI.CreateColorBox(frame,"colorbox1",{text = "颜色选择器测试",x = 50,y = 350,r = 255,g = 128,b = 255})
	--绑定颜色选择器点击事件
	colorbox1:OnChange(function(arg0)
		Output(arg0)
	end)

	--local w2 = EasyUI.CreateWindow(frame,"w1",{x = 50,y = 400,w = 300,h = 50})
	local text1 = EasyUI.CreateText(frame,"text1",{text = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",x = 50,y = 400,})
	text1:SetFontSpacing(5)
	text1:SetFontColor(255,125,0)

	--创建滚动条
	local scroll1 = EasyUI.CreateScroll(frame,"ScrollTest",{x = 400,y = 50,w = 130,h = 200})
	for i = 0, 20 do
		--创建Handle
		local handle = EasyUI.CreateHandle(scroll1,"handle"..i,{x = 0,y = i*20,w = 60,h = 20})
		--创建文字
		EasyUI.CreateText(handle,"txt"..i,{text = "滚动条子项目"..i})
	end
	scroll1:OnUpdateScorllList()

	--创建图像
	local image1 = EasyUI.CreateImage(frame,"image1",{w = 36,h = 36,x = 5,y = 10})
	image1:SetImage("ui\\Image\\UICommon\\CommonPanel.UITex",13)

	--创建动画
	local animate1 = EasyUI.CreateAnimate(frame,"animate1",{w = 161,h = 161,x = 240,y = 50,image = "ui/Image/Common/SprintGreenPower1.UITex"})

	--创建shadow
	local shadow1 = EasyUI.CreateShadow(frame,"shadow1",{x = 330,y = 300,w = 55,h = 55})
	shadow1:SetColorRGB(0,255,64)

	--创建box
	local box1 = EasyUI.CreateBox(frame,"box1",{x = 420,y = 290,w = 80,h = 80})
	box1:SetObject(UI_OBJECT_SKILL, 9003, 4)
	box1:SetObjectIcon(Table_GetSkillIconID(9003, 4))
end
