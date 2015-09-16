--
-- Author: student
-- Date: 2015-08-04 17:47:05
--
local WuQiData={
	[1]={name="箭塔",current_FirePower=10,next_FirePower=15},
	[2]={name="枪塔",current_FirePower=15,next_FirePower=20},
	[3]={name="火塔",current_FirePower=20,next_FirePower=25},
	[4]={name="炮塔",current_FirePower=25,next_FirePower=30},
	[5]={name="火塔",current_FirePower=30,next_FirePower=35}
}

local Cell=class("Cell", function()
	return ccui.Widget:create()
end)

function Cell:ctor(num)
	self.id=num

	self.cell  = cc.uiloader:load("cell.csb")
	-- self.cell:setPosition(cc.p(self.cell:getPositionX()+50,self.cell:getPositionY()))
	self:addChild(self.cell)
	self:setContentSize(self.cell:getContentSize())

	self:init()
end

function Cell:onTouch(callback)
    self:addTouchEventListener(function(sender, state)
        local event = {x = 0, y = 0}
        if state == 0 then
            event.name = "began"
        elseif state == 1 then
            event.name = "moved"
        elseif state == 2 then
            event.name = "ended"
        else
            event.name = "cancelled"
        end
        event.target = sender
        callback(event)
    end)
end

function Cell:init()
	self.icon = self.cell:getChildByName("wiqi")
	self:refreshUI()
end

function Cell:refreshUI()
	local data = WuQiData[self.id]
	self.icon:setTexture("wuqi"..self.id..".png")
	-- local f = display.width/5
	-- self.icon:setPosition(cc.p(10-(self.id-1)*20,0))
end
return Cell