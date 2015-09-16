--
-- Author: student
-- Date: 2015-07-30 18:04:05
--
local LoseLayer = class("LoseLayer", function()
	return display.newColorLayer(cc.c4b(100, 100, 100, 100))
end)
function LoseLayer:ctor()
	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(true)
	self:setContentSize(cc.size(display.width,display.height))
	self:init()
end
function LoseLayer:init()
	--失败面板
	local sp = display.newSprite("StopLayer/lose.png")
	sp:setPosition(self:getContentSize().width/2, self:getContentSize().height/2)
	self:addChild(sp)

	local function click(event)
        local tag=event.target:getTag()
		if tag == 1 then--重玩
			cc.Director:getInstance():resume()
			display.replaceScene(GameScene.new())
		elseif tag == 2 then--菜单  
			cc.Director:getInstance():resume()
			display.replaceScene(SelectChapter.new())
		end
	end

    
    
    local anode=display.newNode()
    anode:pos(display.cx, display.cy-50)
    anode:addTo(self)

    local item1=cc.ui.UIPushButton.new({normal="StopLayer/again.png"},{scale9=true})
                :onButtonClicked(click)
                :pos(-100, 0)
                :addTo(anode)
                :setTag(1)

    local item2=cc.ui.UIPushButton.new({normal="StopLayer/back.png"},{scale9=true})
                :onButtonClicked(click)
                :pos(100, 0)
                :addTo(anode)
                :setTag(2)
end
return LoseLayer