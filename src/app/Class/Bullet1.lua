--
-- Author: student
-- Date: 2015-08-03 10:56:22
--
Bullet1=class("Bullet1", function ( )
	return display.newSprite("GameScene/bullet1.png")
end)
function Bullet1:ctor()
	self.tag=100
	self.firepower=10
	self.isMove=false
end
return Bullet1