--
-- Author: student
-- Date: 2015-07-30 14:14:08
--
Wuqi2=class("Wuqi2", function ()
	return display.newSprite("GameScene/Wuqi2.png")
end)
function Wuqi2:ctor()
	self:init()
	
end
function Wuqi2:init()
	self:setTag(20)
	self.currentLevel=1
	self.up_level=1
	self.make=100
	self.scope=100
	self.firepower=20
	self.attack=true
	self.attackSpeed=1
	self.upMake=110
	self.removeMake=80
	self.totalMake=100
end
return Wuqi2