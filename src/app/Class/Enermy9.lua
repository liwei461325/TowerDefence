--
-- Author: student
-- Date: 2015-08-06 10:57:28
--
Enermy9=class("Enermy9", function ()
	return display.newSprite("enermy/enermy9.png")
end)
function Enermy9:ctor()
	self.old_life=270
	self.hp=270
	self.isMove=true
	self.money=20
	self.moveSpeed=60
	self.life=cc.Sprite:create("enermy/life.png")
	self.life:setAnchorPoint(cc.p(0,0.5))
	self.life:pos(0,50)
	self.life:addTo(self)
end
return Enermy9