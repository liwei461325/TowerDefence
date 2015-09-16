--
-- Author: student
-- Date: 2015-08-06 17:52:50
--
Bullet2=class("Bullet2", function()
	return display.newSprite("GameScene/bullet2.png")
end)
function Bullet2:ctor()
	self.tag=200
	self.firepower=20
	self.isMove=false
end
return Bullet2