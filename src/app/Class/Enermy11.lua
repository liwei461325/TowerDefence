--
-- Author: student
-- Date: 2015-08-06 10:59:26
--
Enermy11=class("Enermy11", function ()
	return display.newSprite("enermy/enermy11.png")
end)
function Enermy11:ctor()
	self.old_life=330
	self.hp=330
	self.isMove=true
	self.money=30
	self.moveSpeed=60
	self.life=cc.Sprite:create("enermy/life.png")
	self.life:setAnchorPoint(cc.p(0,0.5))
	self.life:pos(0,50)
	self.life:addTo(self)
end
return Enermy11