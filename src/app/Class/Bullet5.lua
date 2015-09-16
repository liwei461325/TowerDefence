--
-- Author: student
-- Date: 2015-08-06 18:15:46
--
Bullet5=class("Bullet5", function ( )

    return display.newSprite("GameScene/bullet5.png")
	
end)
function Bullet5:ctor()
	self.tag=500
	self.firepower=30
	self.isMove=false
end
	
return Bullet5