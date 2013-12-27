EasyUITestCase = EasyUITestCase or {}

EasyUITestCase.bCheckBoxOn1 = true
EasyUITestCase.bCheckBoxOn2 = false
EasyUITestCase.bCheckBoxOn3 = true

EasyUITestCase.nRadioValue = 1

EasyUITestCase.szEditBox = "这是一行文本"
EasyUITestCase.nSliderValue = 25
EasyUITestCase.tColorValue = {0, 255, 64}

RegisterCustomData("EasyUITestCase.bCheckBoxOn1")
RegisterCustomData("EasyUITestCase.bCheckBoxOn2")
RegisterCustomData("EasyUITestCase.bCheckBoxOn3")
RegisterCustomData("EasyUITestCase.nRadioValue")
RegisterCustomData("EasyUITestCase.szEditBox")
RegisterCustomData("EasyUITestCase.nSliderValue")
RegisterCustomData("EasyUITestCase.tColorValue")


local tConfig = {
	szName = "AddonName",
	szTitle = "插件名字",
	dwIcon = 3406,
	szClass = "Combat",
	tWidget = {
		{
			name = "AN1", type = "Button", w = 91, x = 0, y = 0, text = "测试按钮1",
			callback = function()
				EasyTestAddon:Open()
			end
		},{
			name = "AN1_1", type = "Button", w = 91, x = 100, y = 0, text = "测试按钮2",
			callback = function()
				Output(EasyUITestCase)
			end
		},{
			name = "AN1_2", type = "Button", w = 91, x = 200, y = 0, text = "测试按钮3", enable = false,
			callback = function()
				Output(EasyUITestCase)
			end
		},{
			name = "AN2", type = "CheckBox", w = 100, x = 0, y = 40, text = "复选框1",
			default = function()
				return EasyUITestCase.bCheckBoxOn1
			end,
			callback = function(enabled)
				EasyUITestCase.bCheckBoxOn1 = enabled
			end
		},{
			name = "AN3", type = "CheckBox", w = 100, x = 100, y = 40, text = "复选框2",
			default = function()
				return EasyUITestCase.bCheckBoxOn2
			end,
			callback = function(enabled)
				EasyUITestCase.bCheckBoxOn2 = enabled
			end
		},{
			name = "AN4", type = "CheckBox",w = 100, x = 200, y = 40, text = "复选框3",
			default = function()
				return EasyUITestCase.bCheckBoxOn3
			end,
			callback = function(enabled)
				EasyUITestCase.bCheckBoxOn3 = enabled
			end
		},{
			name = "AN5", type = "RadioBox", w = 100, x = 0, y = 80, text = "单选框1", group = "test",
			default = function()
				return EasyUITestCase.nRadioValue == 1
			end,
			callback = function(enabled)
				if enabled then
					EasyUITestCase.nRadioValue = 1
				end
			end
		},{
			name = "AN6", type = "RadioBox", w = 100, x = 100, y = 80, text = "单选框2", group = "test",
			default = function()
				return EasyUITestCase.nRadioValue == 2
			end,
			callback = function(enabled)
				if enabled then
					EasyUITestCase.nRadioValue = 2
				end
			end
		},{
			name = "AN7", type = "RadioBox", w = 100, x = 200, y = 80, text = "单选框3", group = "test",
			default = function()
				return EasyUITestCase.nRadioValue == 3
			end,
			callback = function(enabled)
				if enabled then
					EasyUITestCase.nRadioValue = 3
				end
			end
		},{
			name = "AN8", type = "ComboBox", w = 150, x = 0, y = 120, text = "下拉框",
			callback = function(m)
				table.insert(m,{szOption = "测试菜单1"})
				table.insert(m,{szOption = "测试菜单2"})
				PopupMenu(m)
			end
		},{
			name = "AN9", type = "ColorBox", w = 100, h = 25, x = 170, y = 120, text = "颜色选择器",
			default = function()
				return EasyUITestCase.tColorValue
			end,
			callback = function(value)
				EasyUITestCase.tColorValue = value
			end
		},{
			name = "AN10", type = "Edit",w = 300, x = 0, y = 160,
			default = function()
				return EasyUITestCase.szEditBox
			end,
			callback = function(value)
				EasyUITestCase.szEditBox = value
			end
		},{
			name = "AN11", type = "Text", w = 80, h = 28, x = 0, y = 200, text = "这是滑动条",
		},{
			name = "AN12", type = "CSlider", w = 160, x = 85, y = 200, min = 0, max = 100, step = 100, unit = "%",
			default = function()
				return EasyUITestCase.nSliderValue
			end,
			callback = function(value)
				EasyUITestCase.nSliderValue = value
			end
		},
	},
}
EasyManager:RegisterPanel(tConfig)

local tConfigDev = {
	szName = "DevTools",
	szTitle = "开发者工具集",
	dwIcon = 80,
	szClass = "Other",
	tWidget = {
		{
			name = "M_Title", type = "Text", w = 80, h = 28, x = 0, y = 0, text = "开发者工具集", font = 136,
		},{
			name = "M_Detail", type = "Text", w = 80, h = 28, x = 0, y = 30, text = "此工具集包含插件开发所需要的图片和动画查看器、事件和字体查看器等。",
		},{
			name = "M_DevTools", type = "TextButton", w = 100, h = 25, x = 0, y = 60, text = "<打开工具集>", font = 177,
			callback = function()
				DevTools:OpenPanel()
			end
		}
	},
}
EasyManager:RegisterPanel(tConfigDev)

do
	for i = 1, 10 do
		local cfg = {
			szName = "TestA" .. i,
			szTitle = "测试" .. i,
			dwIcon = 3019 + i,
			szClass = "Other",
			tWidget = {
				{
					name = "ANE"..i, type = "Button", w = 91, x = 0, y = 0, text = "测试按钮"..i,
					callback = function()
						Output("111")
					end
				}
			},
		}
		EasyManager:RegisterPanel(cfg)
	end
end
