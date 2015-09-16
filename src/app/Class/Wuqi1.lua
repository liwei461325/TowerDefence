--
-- Author: student
-- Date: 2015-08-03 10:32:20
--
Wuqi1=class("Wuqi1", function ()
	return display.newSprite("GameScene/wuqi1.png")
end)
function Wuqi1:ctor()
	self:init()
	
end
function Wuqi1:init()
	self:setTag(10)
	self.currentLevel=1
	self.up_level=1
	self.make=80
	self.scope=100
	self.firepower=10
	self.attack=true
	self.attackSpeed=0.5
	self.upMake=90
	self.removeMake=64
	self.totalMake=80
end
return Wuqi1