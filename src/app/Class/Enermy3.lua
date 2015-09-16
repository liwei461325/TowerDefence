--
-- Author: student
-- Date: 2015-08-06 10:08:04
--
Enermy3=class("Enermy3", function ()
	return display.newSprite("enermy/enermy3.png")
end)
function Enermy3:ctor()
	self.old_life=90
	self.hp=90
	self.isMove=true
	self.money=10
	self.moveSpeed=55
	self.life=cc.Sprite:create("enermy/life.png")
	self.life:setAnchorPoint(cc.p(0,0.5))
	self.life:pos(0,48)
	self.life:addTo(self)
end
return Enermy3