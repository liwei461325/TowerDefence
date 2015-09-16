--
-- Author: student
-- Date: 2015-08-06 11:02:23
--
Enermy12=class("Enermy12", function ()
	return display.newSprite("enermy/enermy12.png")
end)
function Enermy12:ctor()
	self.old_life=370
	self.hp=370
	self.isMove=true
	self.money=30
	self.moveSpeed=60
	self.life=cc.Sprite:create("enermy/life.png")
	self.life:setAnchorPoint(cc.p(0,0.5))
	self.life:pos(0,50)
	self.life:addTo(self)
end
return Enermy12