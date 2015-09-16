--
-- Author: student
-- Date: 2015-07-30 18:09:40
--
local WinLayer = class("WinLayer", function()
	 return display.newColorLayer(cc.c4b(100, 100, 100, 0))
end)
function WinLayer:ctor()
	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(true)
	self:setContentSize(cc.size(display.width,display.height))
	self:init()
end
function WinLayer:init()
	local chapternum = ModifyData.getChapterNumber()
	local sp = display.newSprite("StopLayer/win.png")
	sp:setPosition(self:getContentSize().width/2, self:getContentSize().height/2)
	self:addChild(sp)

	local function click(event)
        local tag=event.target:getTag()
		if tag == 1 then--退出
			display.replaceScene(SelectChapter.new())
		elseif tag == 2 then--继续
			ModifyData.setChapterNumber(chapternum+1)
			display.replaceScene(GameScene.new())
		end
	end

    
    
    local anode=display.newNode()
    anode:pos(display.cx, display.cy-50)
    anode:addTo(self)

    local item1=cc.ui.UIPushButton.new({normal="StopLayer/back.png"},{scale9=true})
                :onButtonClicked(click)
                :pos(-100, 0)
                :addTo(anode)
                :setTag(1)

    local item2=cc.ui.UIPushButton.new({normal="StopLayer/continue.png"},{scale9=true})
                :onButtonClicked(click)
                :pos(100, 0)
                :addTo(anode)
                :setTag(2)
end
return WinLayer