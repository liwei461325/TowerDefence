--
-- Author: student
-- Date: 2015-07-31 14:12:21
--
SanDan=class("SanDan", function ( )

    return display.newSprite("GameScene/paota3.png")
	
end)
function SanDan:ctor()
	self.tag=500
	self.firepower=30
	self.isMove=false
end
	
return SanDan
