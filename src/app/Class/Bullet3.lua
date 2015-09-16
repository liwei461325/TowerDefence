--
-- Author: student
-- Date: 2015-08-06 18:14:30
--
Bullet3=class("Bullet3", function ( )
	return display.newSprite("GameScene/bullet3.png")
end)
function Bullet3:ctor()
	self.tag=300
	self.firepower=25
	self.isMove=false
end
return Bullet3