--
-- Author: student
-- Date: 2015-08-06 18:08:04
--
Bullet4=class("Bullet4", function ( )
	return display.newSprite("GameScene/bullet4.png")
end)
function Bullet4:ctor()
	self.tag=400
	self.firepower=25
	self.isMove=false
end
return Bullet4