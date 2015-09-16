--
-- Author: student
-- Date: 2015-07-29 16:29:21
--
Enermy=class("Enermy", function ()
	--   local png = "enermy/horse.png"
	-- local plist = "enermy/horse.plist"
	-- display.addSpriteFrames(plist,png)
	return display.newSprite("enermy/enermy1.png")
end)
function Enermy:ctor()
	self.old_life=30
	self.hp=30
	self.isMove=true
	self.money=10
	self.moveSpeed=50
	self.life=cc.Sprite:create("enermy/life.png")
	self.life:setAnchorPoint(cc.p(0,0.5))
	self.life:pos(0,45)
	self.life:addTo(self)

	 -- self:startAnimation()
	
end

function Enermy:startAnimation()
	local frames = display.newFrames("%d.png",1,7)
	local animation = display.newAnimation(frames,0.1)
	self:playAnimationForever(animation, 0.1)
end
return Enermy