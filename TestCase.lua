
EasyUI = EasyUI or {}

function EasyUI.TestCase()
	--创建一个面板
	local f=EasyUI.CreateFrame("test")

	--创建一个按钮
	local b=EasyUI.CreateButton(f,"b1",{text="Click Me",x=50,y=50})
	--绑定按钮点击事件
	b:OnClick(function() Output("Click") end)

	--创建一个编辑框
	local e=EasyUI.CreateEdit(f,"e1",{text="input words",x=50,y=100})
	--绑定编辑框更改事件
	e:OnChanged(function(arg0) Output(arg0) end)

	--创建一个复选框
	local c=EasyUI.CreateCheckBox(f,"c1",{text="Check Me",x=50,y=150,check=true})
	--绑定复选框选中事件
	c:OnCheck(function(arg0) Output(arg0) end)

	--创建一个下拉框
	local d=EasyUI.CreateComboBox(f,"c2",{text="Menu",x=50,y=200})
	--绑定下拉框点击事件
	d:OnClick(function() local m = {} table.insert(m,{szOption="TEST1"}) table.insert(m,{szOption="TEST2"}) return m end)

	--创建三个单选框，并绑定选中事件
	local r1=EasyUI.CreateRadioBox(f,"r1",{text="Select1",x=50,y=250,check=true,group="test1"})
	r1:OnCheck(function(arg0) Output(arg0) end)
	local r2=EasyUI.CreateRadioBox(f,"r2",{text="Select2",x=150,y=250,group="test1"})
	r2:OnCheck(function(arg0) Output(arg0) end)
	local r3=EasyUI.CreateRadioBox(f,"r3",{text="Select3",x=250,y=250,group="test1"})
	r3:OnCheck(function(arg0) Output(arg0) end)

	--创建一个滑块
	local s=EasyUI.CreateCSlider(f,"s1",{x=50,y=300,w=200,min=0,max=100,step=100,value=20,unit="%"})
	--绑定滑块滑动事件
	s:OnChanged(function(arg0) Output(arg0) end)

	--创建一个颜色选择器
	local c3=EasyUI.CreateColorBox(f,"c3",{text="Color",x=50,y=350,r=255,g=255,b=0})
	--绑定颜色选择器点击事件
	c3:OnChanged(function(arg0) Output(arg0) end)
end
