--
-- Author: student
-- Date: 2015-08-06 18:15:34
--

Wuqi5=class("Wuqi5", function ()
	return display.newSprite("GameScene/wuqi5.png")
end)
function Wuqi5:ctor()
	self:setTag(50)
	self.currentLevel=1
	self.up_level=1
	self.make=300
	self.scope=100
	self.firepower=30
	self.attack=true
	self.attackSpeed=1
	self.upMake=320
	self.removeMake=240
	self.totalMake=300
end

return Wuqi5