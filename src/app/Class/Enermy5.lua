--
-- Author: student
-- Date: 2015-08-06 10:51:36
--
Enermy5=class("Enermy5", function ()
	return display.newSprite("enermy/enermy5.png")
end)
function Enermy5:ctor()
	self.old_life=150
	self.hp=150
	self.isMove=true
	self.money=10
	self.moveSpeed=60
	self.life=cc.Sprite:create("enermy/life.png")
	self.life:setAnchorPoint(cc.p(0,0.5))
	self.life:pos(0,50)
	self.life:addTo(self)
end
return Enermy5