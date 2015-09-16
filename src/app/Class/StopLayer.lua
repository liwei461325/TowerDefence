--
-- Author: student
-- Date: 2015-07-28 12:53:26
--
local StopLayer = class("StopLayer", function()
	return display.newColorLayer(cc.c4b(100, 100, 100, 50))
end)
local scheduler=require("framework.scheduler")
function StopLayer:ctor()
	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(true)
	self:setContentSize(cc.size(display.width,display.height))
	self:init(schedu)

end

function StopLayer:init()
	--背景
	local bg = display.newSprite("StopLayer/stop.png")
	bg:setPosition(self:getContentSize().width/2, self:getContentSize().height/2)
	self:addChild(bg)

	local function click(event)
		local tag=event.target:getTag()

		if tag == 1 then--重玩
			cc.Director:getInstance():resume()
			cc.Director:getInstance():replaceScene(GameScene.new())
		elseif tag == 2 then --继续
			cc.Director:getInstance():resume()
			self:removeFromParent()
		elseif tag == 3 then --退出
			cc.Director:getInstance():resume()
			display.replaceScene(SelectChapter.new())
		end
	end


    local anode =display.newNode()
    anode:pos(bg:getContentSize().width/2 , bg:getContentSize().height/2)
	bg:addChild(anode)
	
	local item1=cc.ui.UIPushButton.new({normal="StopLayer/again.png"},{scale9=true})
	:onButtonClicked(click)
	:addTo(anode)
	:pos(anode:getContentSize().width+150, anode:getContentSize().height-50)
	:setTag(1)

	local item2=cc.ui.UIPushButton.new({normal="StopLayer/continue.png"},{scale9=true})
	:onButtonClicked(click)
	:addTo(anode)
	:pos(anode:getContentSize().width, anode:getContentSize().height-50)
	:setTag(2)

	local item3=cc.ui.UIPushButton.new({normal="StopLayer/back.png"},{scale9=true})
	:onButtonClicked(click)
	:addTo(anode)
	:pos(anode:getContentSize().width-150, anode:getContentSize().height-50)
	:setTag(3)
	
	

	local music = cc.ui.UICheckBoxButton.new({on = "sound_on.png", off = "sound_off.png"})
	music:setPosition(cc.p((display.left+display.cx)/2-70, (display.top+display.cy)/2+50))
	music:setScale(0.8)
	music:onButtonStateChanged(function(event)
		if event.state == "on" then
			audio.resumeMusic()
			ModifyData.setMusic(true)
		elseif  event.state == "off" then
			audio.pauseMusic()
		    ModifyData.setMusic(false)
		end
	end)
	music:setButtonSelected(ModifyData.getMusic())
	self:addChild(music)
end

return StopLayer