--
-- Author: student
-- Date: 2015-08-06 10:53:36
--
Enermy6=class("Enermy6", function ()
	return display.newSprite("enermy/enermy6.png")
end)
function Enermy6:ctor()
	self.old_life=180
	self.hp=180
	self.isMove=true
	self.money=20
	self.moveSpeed=60
	self.life=cc.Sprite:create("enermy/life.png")
	self.life:setAnchorPoint(cc.p(0,0.5))
	self.life:pos(0,48)
	self.life:addTo(self)
end
return Enermy6