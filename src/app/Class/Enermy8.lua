--
-- Author: student
-- Date: 2015-08-06 10:56:08
--
Enermy8=class("Enermy8", function ()
	return display.newSprite("enermy/enermy8.png")
end)
function Enermy8:ctor()
	self.old_life=240
	self.hp=240
	self.isMove=true
	self.money=20
	self.moveSpeed=60
	self.life=cc.Sprite:create("enermy/life.png")
	self.life:setAnchorPoint(cc.p(0,0.5))
	self.life:pos(0,50)
	self.life:addTo(self)
end
return Enermy8