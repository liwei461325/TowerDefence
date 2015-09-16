--
-- Author: student
-- Date: 2015-08-06 10:02:57
--
Enermy2=class("Enermy2", function ()
	return display.newSprite("enermy/enermy2.png")
end)
function Enermy2:ctor()
	self.old_life=60
	self.hp=60
	self.isMove=true
	self.money=10
	self.moveSpeed=50
	self.life=cc.Sprite:create("enermy/life.png")
	self.life:setAnchorPoint(cc.p(0,0.5))
	self.life:pos(0,48)
	self.life:addTo(self)
end
return Enermy2