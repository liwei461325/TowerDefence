--
-- Author: student
-- Date: 2015-08-06 11:02:35
--
Enermy13=class("Enermy13", function ()
	return display.newSprite("enermy/enermy13.png")
end)
function Enermy13:ctor()
	self.old_life=400
	self.hp=400
	self.isMove=true
	self.money=30
	self.moveSpeed=60
	self.life=cc.Sprite:create("enermy/life.png")
	self.life:setAnchorPoint(cc.p(0,0.5))
	self.life:pos(0,50)
	self.life:addTo(self)
end
return Enermy13