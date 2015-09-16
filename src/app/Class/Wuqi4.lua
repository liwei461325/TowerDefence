--
-- Author: student
-- Date: 2015-08-03 14:51:26
--
Wuqi4=class("Wuqi4", function ()
	return display.newSprite("GameScene/wuqi4.png")
end)
function Wuqi4:ctor()
	self:setTag(40)
	self.currentLevel=1
	self.up_level=1
	self.make=200
	self.scope=100
	self.firepower=25
	self.attack=true
	self.attackSpeed=1
	self.upMake=220
	self.removeMake=160
	self.totalMake=200
end

return Wuqi4