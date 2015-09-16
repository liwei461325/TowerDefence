--
-- Author: student
-- Date: 2015-08-06 11:02:45
--
Enermy14=class("Enermy14", function ()
	return display.newSprite("enermy/enermy14.png")
end)
function Enermy14:ctor()
	self.old_life=450
	self.hp=450
	self.isMove=true
	self.money=30
	self.moveSpeed=60
	self.life=cc.Sprite:create("enermy/life.png")
	self.life:setAnchorPoint(cc.p(0,0.5))
	self.life:pos(0,50)
	self.life:addTo(self)
end
return Enermy14