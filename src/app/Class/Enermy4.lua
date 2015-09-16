--
-- Author: student
-- Date: 2015-08-06 10:12:20
--
Enermy4=class("Enermy4", function ()
	return display.newSprite("enermy/enermy4.png")
end)
function Enermy4:ctor()
	self.old_life=120
	self.hp=120
	self.isMove=true
	self.money=10
	self.moveSpeed=55
	self.life=cc.Sprite:create("enermy/life.png")
	self.life:setAnchorPoint(cc.p(0,0.5))
	self.life:pos(0,48)
	self.life:addTo(self)
end
return Enermy4