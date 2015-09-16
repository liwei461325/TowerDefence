--
-- Author: student
-- Date: 2015-07-31 13:47:46
--
SanDanPao=class("SanDanPao", function ()
	return display.newSprite("GameScene/paota3.png")
end)
function SanDanPao:ctor()
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

return SanDanPao