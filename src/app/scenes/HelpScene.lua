--
-- Author: student
-- Date: 2015-08-04 17:30:02
--

local WuQiData={
	[1]={name="箭塔",current_FirePower=10,next_FirePower=15,introduce="炮塔:发射子弹，攻击范围\n内的敌人会产生伤害"},
	[2]={name="枪塔",current_FirePower=15,next_FirePower=20,introduce="炮塔:发射子弹，攻击范围\n内的敌人会产生伤害"},
	[3]={name="火塔",current_FirePower=20,next_FirePower=25,introduce="炮塔:发射子弹，攻击范围\n内的敌人会产生伤害"},
	[4]={name="炮塔",current_FirePower=25,next_FirePower=30,introduce="弹塔:发射散弹，攻击范围\n内的敌人会产生伤害"},
	[5]={name="散弹塔",current_FirePower=30,next_FirePower=35,introduce="术塔:攻击范围内的敌人\n会受到电击"}
}

HelpScene=class("HelpScene", function ()
	return display.newScene("HelpScene")
end)

function HelpScene:ctor()
   self.selected_index=0
   self:init()
end

function HelpScene:init()

	local bg = display.newSprite("SelectScene/bg.png")
	bg:pos(display.cx, display.cy)
	local scaleX = display.width/bg:getContentSize().width
	local scaleY = display.height/bg:getContentSize().height
	bg:setScale(scaleX,scaleY)
	self:addChild(bg)

	local helpContentShow=display.newSprite("help.png")
	helpContentShow:pos(display.cx, display.cy-20)
	self:addChild(helpContentShow)

	--返回
	local backBtn = cc.ui.UIPushButton.new({normal="back.png"},{scale9=true})
                   :onButtonClicked(function(event)
                   	display.replaceScene(SelectChapter.new())
                   end)
                   :pos(display.left+50, display.top-50)
                   :addTo(self,1)


	self.layer=cc.uiloader:load("MainScene.csb")
	self.layer:setAnchorPoint(cc.p(0,0))
	self.layer:pos(0, 0)
	self.layer:addTo(self)

	self.listView=self.layer:getChildByName("ListView_1")
	self.panel=self.layer:getChildByName("Panel_1")
	self.wuqi_type=self.layer:getChildByName("wuqi_type")
	self.wuqi=self.panel:getChildByName("wuqi")
	self.current_FirePower=self.panel:getChildByName("current_FirePower")
	self.next_FirePower=self.panel:getChildByName("next_FirePower")
	self.introduce=self.panel:getChildByName("introduce")
	self.introduce:setScale(1.5)
	self:refreshListView()
end

function HelpScene:refreshListView()
	self.cell = {}
	for i=1,5 do
		self.cell[i]= Cell.new(i)
		self.listView:pushBackCustomItem(self.cell[i])
		self.cell[i]:setTouchEnabled(true)
		self.cell[i]:onTouch(function(event)
			local target = event.target
			local num = self.listView:getIndex(target)
			self.selected_index = num
			if event.name == "ended" then
				self:refreshDes()
			end
			end)

	end
	self:refreshDes()
end

function HelpScene:refreshDes()
	local item = self.listView:getItem(self.selected_index)
	local data = WuQiData[item.id]
	self.wuqi:setTexture("wuqi"..item.id..".png")
	self.current_FirePower:setString(data.current_FirePower)
	self.next_FirePower:setString(data.next_FirePower)
	self.wuqi_type:setTexture("wuqi"..item.id..".png")
	self.wuqi_type:setScale(3)
	self.introduce:setString(data.introduce)
end

return HelpScene