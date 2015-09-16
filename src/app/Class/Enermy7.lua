--
-- Author: student
-- Date: 2015-08-06 10:55:02
--
Enermy7=class("Enermy7", function ()
	return display.newSprite("enermy/enermy7.png")
end)
function Enermy7:ctor()
	self.old_life=210
	self.hp=210
	self.isMove=true
	self.money=20
	self.moveSpeed=60
	self.life=cc.Sprite:create("enermy/life.png")
	self.life:setAnchorPoint(cc.p(0,0.5))
	self.life:pos(0,50)
	self.life:addTo(self)
end
return Enermy7