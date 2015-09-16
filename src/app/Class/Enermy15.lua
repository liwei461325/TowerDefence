--
-- Author: student
-- Date: 2015-08-06 11:02:56
--
Enermy15=class("Enermy15", function ()
	return display.newSprite("enermy/enermy15.png")
end)
function Enermy15:ctor()
	self.old_life=500
	self.hp=500
	self.isMove=true
	self.money=30
	self.moveSpeed=60
	self.life=cc.Sprite:create("enermy/life.png")
	self.life:setAnchorPoint(cc.p(0,0.5))
	self.life:pos(0,50)
	self.life:addTo(self)
end
return Enermy15