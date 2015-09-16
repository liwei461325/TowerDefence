--
-- Author: student
-- Date: 2015-08-06 10:58:26
--
Enermy10=class("Enermy10", function ()
	return display.newSprite("enermy/enermy10.png")
end)
function Enermy10:ctor()
	self.old_life=300
	self.hp=300
	self.isMove=true
	self.money=20
	self.moveSpeed=60
	self.life=cc.Sprite:create("enermy/life.png")
	self.life:setAnchorPoint(cc.p(0,0.5))
	self.life:pos(0,50)
	self.life:addTo(self)
end
return Enermy10