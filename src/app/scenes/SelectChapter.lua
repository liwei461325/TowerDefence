--
-- Author: student
-- Date: 2015-07-27 18:12:03
--
local SelectChapter=class("SelectChapter", function (  )
	return display.newScene("SelectChapter")
end)

function SelectChapter:ctor()
	self:init()
end

function SelectChapter:init()

	if #PublicData.SCENETABLE==0 then
		local docpath=cc.FileUtils:getInstance():getWritablePath().."data.txt"
		if cc.FileUtils:getInstance():isFileExist(docpath)==false then
		   local str = json.encode(Data.SCENE)
		   ModifyData.writeToDoc(str)
		   PublicData.SCENETABLE = Data.SCENE
		else
			local str = ModifyData.readFromDoc()
			PublicData.SCENETABLE=json.decode(str)
		end
	end

	local bg = cc.Sprite:create("SelectChapter/bg.png")
	local scaleX = display.width/bg:getContentSize().width
	local scaleY = display.height/bg:getContentSize().height
	bg:setScale(scaleX,scaleY)
	bg:pos(display.cx, display.cy)
	bg:addTo(self)

	local sceneNum=ModifyData.getSceneNumber()
	local chapterNum=ModifyData.getChapterNumber()
	local tb = PublicData.SCENETABLE

	--返回
	local backBtn = cc.ui.UIPushButton.new({normal="back.png"},{scale9=true})
                   :onButtonClicked(function(event)
                   	display.replaceScene(SelectScene.new())
                   end)
                   :pos(display.left+50, display.top-50)
                   :addTo(self,1)

    local helpBtn = cc.ui.UIPushButton.new({normal="back.png"},{scale9=true})
                   :onButtonClicked(function(event)
                   	display.replaceScene(HelpScene.new())
                   end)
                   :pos(display.right-50, display.top-50)
                   :addTo(self,1)


    self._layer=display.newColorLayer(cc.c4b(100,100,250,0))
    self._layer:setAnchorPoint(cc.p(0,0))
    self._layer:pos(0, 0)
    self._layer:setContentSize(cc.size(display.width*2,display.height*3/4))

    self._scroll=cc.ScrollView:create(cc.size(display.width,display.height*3/4), self._layer)
    self._scroll:setDirection(0)
    self:addChild(self._scroll)

	
	for i=1,6 do
		local item1
		if tb[1][i].lock==0 then
		item1=cc.ui.UIPushButton.new({normal=Data.getChapterBtnData(i).pic},{scale9=true})
		item1:onButtonClicked(function ()
		ModifyData.setChapterNumber(i)
		local scene=GameScene.new()
		cc.Director:getInstance():replaceScene(scene)
		end)
	    else
		item1=cc.ui.UIPushButton.new({normal=Data.getChapterBtnData(i).pic2},{scale9=true})
		item1:onButtonClicked(function ()
			print("未解锁")
		end)
	end
	print(item1:getContentSize().width)
	local f = (self._layer:getContentSize().width)/6
		item1:setPosition(cc.p((display.left+display.cx)/2-50+(i-1)*display.cx*2/3, display.cy))

	self._scroll:addChild(item1)
	end


end
return SelectChapter