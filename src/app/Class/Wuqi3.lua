--
-- Author: student
-- Date: 2015-08-06 18:12:50
--
Wuqi3=class("Wuqi3", function ()
	return display.newSprite("GameScene/wuqi3.png")
end)
function Wuqi3:ctor()
	self:setTag(30)
	self.currentLevel=1
	self.firepower=25
	self.up_level=1
	self.make=120
	self.scope=100
	self.firepower=25
	self.attack=true
	self.attackSpeed=1
	self.upMake=130
	self.removeMake=96
	self.totalMake=120
end

return Wuqi3