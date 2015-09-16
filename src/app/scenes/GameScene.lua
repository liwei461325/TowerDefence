--
-- Author: student
-- Date: 2015-07-27 18:39:33
--
GameScene=class("GameScene", function (  )
	return display.newScene("GameScene")
end)

function GameScene:ctor()
   self:init()
end

local sceneNum
local chapterNum
local totalNumber
local enermyTypeNum
local totalNumber 
local scheduler=require(cc.PACKAGE_NAME..".scheduler")
function GameScene:init()
  local tb = PublicData.SCENETABLE
  sceneNum=ModifyData.getSceneNumber()
  chapterNum=ModifyData.getChapterNumber()
  totalNumber =Data.SCENE[sceneNum][chapterNum].number
  self.money=Data.SCENE[sceneNum][chapterNum].money

  
	local bg = display.newSprite("GameScene/sceneBg"..sceneNum..".png")
	local scaleX = display.width/bg:getContentSize().width
  local scaleY = display.height/bg:getContentSize().height
  bg:setScale(scaleX,scaleY)
  bg:pos(display.cx, display.cy)
  self:addChild(bg)
 

  local path="map/game"..sceneNum.."-"..chapterNum..".tmx"
    self.monsterNum=0     --怪物数
    self.number=1    --波数
    self.killEnermyNum=0  --杀敌数
    self.hp=10    
       --血量
    self.isWin=false
    self.tileMap =cc.TMXTiledMap:create(path)
    self.tileMap:addTo(self)
    self.hero=self.tileMap:getObjectGroup("object")
    self.layer=self.tileMap:getLayer("layer")
    self.showLayer=self.tileMap:getLayer("showLayer")
    self.showLayer:hide()

    --开始点
    -- self.beginPoint= self.hero:getObject("begin")

    
    self.wuqi1Point=self.hero:getObject("wuqi1")
    self.wuqi2Point=self.hero:getObject("wuqi2")
    self.wuqi3Point=self.hero:getObject("wuqi3")
    self.wuqi4Point=self.hero:getObject("wuqi4")
    self.wuqi5Point=self.hero:getObject("wuqi5")


    local rain=cc.ParticleRain:createWithTotalParticles(2000)
     -- snow:setTexture( cc.Director:getInstance():getTextureCache():addImage("GameScene/flower.png"))
     rain:pos(display.cx, display.top)
     rain:addTo(self.tileMap)

   --显示金币的数量
  local moneySp=display.newSprite("GameScene/money.png")
  moneySp:pos(display.left+30, display.top-23)
  moneySp:setScale(0.6)
  moneySp:addTo(self.tileMap)
  self.moneyNumLabel=cc.ui.UILabel.new({
      text =self.money,
      color = cc.c3b(250, 250, 5),
      size = 14,
    })
  :align(display.CENTER, display.left+60, display.top-20)
  :addTo(self.tileMap,1)

  --显示杀敌的数量
  local killEnermySp=display.newSprite("GameScene/dao.png")
  killEnermySp:pos((display.cx+display.left)/2, display.top-20)
  killEnermySp:setScale(0.6)
  killEnermySp:addTo(self.tileMap)
  self.killEnermyNumLabel=cc.ui.UILabel.new({
      text =self.killEnermyNum,
      color = cc.c3b(250, 250, 5),
      size = 14,
    })
  :align(display.CENTER, (display.cx+display.left)/2+30, display.top-20)
  :addTo(self.tileMap,1)

  --显示敌人波数
  local enermyNumSp=display.newSprite("GameScene/qizi.png")
  enermyNumSp:pos(display.cx-45, display.top-20)
  enermyNumSp:setScale(0.6)
  enermyNumSp:addTo(self.tileMap)
  self.enermyNumLabel=cc.ui.UILabel.new({
      text =self.number.."/"..totalNumber,
      color = cc.c3b(250, 250, 5),
      size = 14,
    })
  :align(display.CENTER, display.cx-10, display.top-20)
  :addTo(self.tileMap,1)

 --显示血量
 local hpNumSp=display.newSprite("GameScene/xueliang.png")
  hpNumSp:pos((display.cx+display.right)/2, display.top-20)
  hpNumSp:setScale(0.6)
  hpNumSp:addTo(self.tileMap)
  self.hpNumLabel=cc.ui.UILabel.new({
      text =self.hp,
      color = cc.c3b(250, 250, 5),
      size = 14,
    })
  :align(display.CENTER, (display.cx+display.right)/2+30, display.top-20)
  :addTo(self,1)

  local stopBtn = cc.ui.UIPushButton.new({normal = "GameScene/stopBtn.png"}, {scale9 = true})
  stopBtn:onButtonClicked(function(event)
    cc.Director:getInstance():pause()
    local stopLayer = StopLayer.new()
    stopLayer:setPosition(cc.p(0,0))
    self:addChild(stopLayer,3)
  end)
  stopBtn:setPosition(cc.p(display.width-30, display.height-30))
  stopBtn:setScale(0.4)
  self:addChild(stopBtn)

  --添加大炮
  self.cannon={}
  --敌人表
  self.monster={}
  --子弹
  self.bullet={}
  --时间调度，开始出怪
  self:createOneEnermy()
  self:createEnermy()

  self:testTouch()
  -- 时间调度，怪进入塔的攻击范围之内，开始攻击
  self:updata()
  --时间调度，清除已完成动作的
  self:removeUpdata()
  self:addEventListen()
  --升级的炮塔
  self.upTag=0
  --生成升级或者删除的按钮

end 

function GameScene:addEventListen()
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function ( event )
       

       if event.name=="began" then
             
             if self.upTag==2 then
                   self.upTag=1
                  self.scope:removeFromParent()
                 
              end
            for k1,v1 in pairs(self.cannon) do
                local rect1= self:newRect(v1)

                if cc.rectContainsPoint(rect1,cc.p(event.x,event.y)) then
                    self.upSprite=v1
                    self.upSpritePos=k1
                    self:upOrDownConnon()
                end
                for k,v in pairs(self.monster) do
                local rect1= self:newRect(v)
                
                if cc.rectContainsPoint(rect1,cc.p(event.x,event.y)) then
                    local x= v:getPositionX()-v1:getPositionX()
                local y= v:getPositionY()-v1:getPositionY()
                local s = math.sqrt(x*x+y*y)
                --如果距离小于武器的攻击范围，那么攻击
                if s<=v1.scope then 
                    if v1.attack==true then
                        v1.attack=false
                        local delay = cc.DelayTime:create(v1.attackSpeed)
                        local func= cc.CallFunc:create(function (even)
                            even.attack=true
                        end)
                       local seq = cc.Sequence:create(delay,func)
                        v1:runAction(seq)
                        self:attack(v1,v)
                    end
                    break
                end 
                end  
               end
            end


            return true

        end      
    end)
end


function GameScene:upOrDownConnon()
     self.upTag=2
    self.scope=cc.Sprite:create("scope.png")
    self.scope:pos(self.upSprite:getPositionX(), self.upSprite:getPositionY())
    self.scope:setAnchorPoint(cc.p(0.5,0.5))
    self.scope:setScale(self.upSprite.scope/100)
    self.scope:addTo(self.tileMap,2)
  


    if self.money-self.upSprite.upMake>=0 then
    self.upConnon=cc.Sprite:create("GameScene/up1.png")
    else
    self.upConnon=cc.Sprite:create("GameScene/up2.png")
    end
    self.upConnon:pos(self.scope:getContentSize().width/2+60, self.scope:getContentSize().height/2)
    self.upConnon:setAnchorPoint(cc.p(0.5,0.5))
    self.upConnon:addTo(self.scope,3)
    self.upConnon:setTouchEnabled(true)
    self.upConnon:setTouchSwallowEnabled(true)
    self.upConnon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
        if event.name=="ended" then    
            if self.upSprite.currentLevel<3 then
              if (self.money-self.upSprite.upMake)<0 then 
                   return
              end
                self.upSprite.totalMake=self.upSprite.totalMake+self.upSprite.upMake
                self.money=self.money-self.upSprite.upMake
                self.upSprite.upMake=self.upSprite.upMake+10
                self.upSprite.removeMake=self.upSprite.totalMake*0.8
                self.upSprite.currentLevel=self.upSprite.currentLevel+1
                self.upSprite.scope=self.upSprite.scope*1.5
                self.scope:setScale(self.upSprite.scope/100)
                self.upSprite.firepower=self.upSprite.firepower+5*(self.upSprite:getTag()-9)
                self.moneyNumLabel:setString(self.money)
                if self.upSprite.currentLevel==3 then
                   self.upMakeLabel:setString("MAX")
                else
                  self.upMakeLabel:setString(self.upSprite.upMake)
                end
                
                self.removeMakeLabel:setString(self.upSprite.removeMake)
                
                
                 
                 if (self.money-self.upSprite.upMake)<0 then
                   
                   self.upConnon:removeFromParent()
                   self.upConnon=cc.Sprite:create("GameScene/up2.png")
                   self.upConnon:pos(self.scope:getContentSize().width/2+60, self.scope:getContentSize().height/2)
                   self.upConnon:setAnchorPoint(cc.p(0.5,0.5))
                   self.upConnon:addTo(self.scope,3)

                 end   
          end
        elseif event.name=="began" then
            return true
        end
    end)

  self.upMakeLabel=cc.ui.UILabel.new({
      text =self.upSprite.upMake,
      color = cc.c3b(250, 250, 5),
      size = 20,
    })
    :align(display.CENTER, self.upConnon:getPositionX()-3, self.upConnon:getPositionY()-35)
  :addTo(self.scope,3)

  if self.upSprite.currentLevel==3 then
      self.upMakeLabel:setString("MAX")
  else
      self.upMakeLabel:setString(self.upSprite.upMake)
  end
  
    self.downConnon=cc.Sprite:create("GameScene/money.png")
    self.downConnon:pos(self.scope:getContentSize().width/2-50, self.scope:getContentSize().height/2-10)
    self.downConnon:setAnchorPoint(cc.p(0.5,0.5))
    self.downConnon:setScale(0.8)
    self.downConnon:addTo(self.scope,3)
    self.downConnon:setTouchEnabled(true)
    self.downConnon:setTouchSwallowEnabled(true)
    self.downConnon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function ( event )
        if event.name=="began" then
          
            return true
        elseif event.name=="ended" then

            self.money=self.money+self.upSprite.removeMake
            self.moneyNumLabel:setString(self.money)
            self.upSprite:removeFromParent()
            table.remove(self.cannon,self.upSpritePos)
            self.scope:removeFromParent()
            self.upTag=1
        end
    end)
    self.removeMakeLabel=cc.ui.UILabel.new({
      text =self.upSprite.removeMake,
      color = cc.c3b(250, 250, 5),
      size = 20,
    })
    :align(display.CENTER, self.downConnon:getPositionX()-7, self.downConnon:getPositionY()-28)
    :addTo(self.scope,3)
end


function GameScene:testTouch()


    local money1 = display.newSprite("GameScene/money.png")
    money1:pos(self.wuqi1Point.x-2,display.bottom+3)
    money1:setScale(0.4)
    money1:addTo(self.tileMap)
      --显示需要金币的数量
     cc.ui.UILabel.new({
      text = "80",
      color = cc.c3b(250, 250, 5),
      size = 15,
    })
    :pos(self.wuqi1Point.x+3,display.bottom+8)
    :addTo(self.tileMap)

    local showWuqi1=display.newSprite("GameScene/showWuqi.png")
    showWuqi1:pos(self.wuqi1Point.x, self.wuqi1Point.y)
    showWuqi1:addTo(self.tileMap,2)
    local wuqi1 = display.newSprite("GameScene/wuqi1.png")
    wuqi1:setScale(0.8)
    wuqi1:pos(showWuqi1:getContentSize().width/2,showWuqi1:getContentSize().height/2)
    wuqi1:addTo(showWuqi1)
    wuqi1:setTouchEnabled(true)
    wuqi1:setTouchSwallowEnabled(false)
    wuqi1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)   
        if event.name=="began" then
            self.addSp=Wuqi1.new()
            self.showLayer:show()
            self.addSp:pos(event.x, event.y)
            self.addSp:setAnchorPoint(cc.p(0.5,0.5))
            self.addSp:addTo(self.tileMap,2)
            return true
        elseif event.name=="moved" then
           self.addSp:pos(event.x, event.y) 
        elseif event.name=="ended" then
            self.showLayer:hide()
            local x= event.x/64
            local y = (640-event.y)/64
            local tileGid = self.showLayer:getTileGIDAt(cc.p(math.floor(x),math.floor(y)))
            if tileGid<=0 then
                self.addSp:removeFromParent()
                return
            end
            for k,v in pairs(self.cannon) do
                local rect1= self:newRect(v)
                if cc.rectContainsPoint(rect1,cc.p(event.x,event.y)) then
                    self.addSp:removeFromParent()
                    return
                end
            end
            if self.money-self.addSp.make<0 then
                self.addSp:removeFromParent()
                return
            end
            self.addSp:pos(math.floor(x)*64+32, math.floor(10-y)*64+32)
            self.cannon[#self.cannon+1]=self.addSp
            self.money=self.money-self.addSp.make
            self.moneyNumLabel:setString(self.money)
        end
        
    end)
    
    
    local money2 = display.newSprite("GameScene/money.png")
    money2:pos(self.wuqi2Point.x-4, display.bottom+3)
    money2:setScale(0.4)
    money2:addTo(self.tileMap)
      --显示需要金币的数量
     cc.ui.UILabel.new({
      text = "100",
      color = cc.c3b(250, 250, 5),
      size = 15,
    })
    :pos(self.wuqi2Point.x+1, display.bottom+8)
    :addTo(self.tileMap)

    local showWuqi2=display.newSprite("GameScene/showWuqi.png")
    showWuqi2:pos(self.wuqi2Point.x, self.wuqi2Point.y)
    showWuqi2:addTo(self.tileMap,2)
    local wuqi2 = display.newSprite("GameScene/wuqi2.png")
    wuqi2:setScale(0.8)
    wuqi2:pos(showWuqi2:getContentSize().width/2,showWuqi2:getContentSize().height/2)
    wuqi2:addTo(showWuqi2)
    wuqi2:setTouchEnabled(true)
    wuqi2:setTouchSwallowEnabled(false)
    wuqi2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
      if event.name=="began" then
            self.addSp=Wuqi2.new()
            self.showLayer:show()
            self.addSp:pos(event.x, event.y)
            self.addSp:setAnchorPoint(cc.p(0.5,0.5))
            self.addSp:addTo(self.tileMap,2)
            return true

      elseif event.name=="moved" then
            self.addSp:pos(event.x, event.y)

       elseif event.name=="ended" then
            self.showLayer:hide()
            local x= event.x/64
            local y = (640-event.y)/64
            local tileGid = self.showLayer:getTileGIDAt(cc.p(math.floor(x),math.floor(y)))
            if tileGid<=0 then
                self.addSp:removeFromParent()
                return
            end
            for k,v in pairs(self.cannon) do
                local rect1= self:newRect(v)
                if cc.rectContainsPoint(rect1,cc.p(event.x,event.y)) then
                    self.addSp:removeFromParent()
                    return
                end
            end
            if self.money-self.addSp.make<0 then
                self.addSp:removeFromParent()
                return
            end
            self.addSp:pos(math.floor(x)*64+32, math.floor(10-y)*64+32)
            self.cannon[#self.cannon+1]=self.addSp
            self.money=self.money-self.addSp.make
            self.moneyNumLabel:setString(self.money)
        end
    end)
  


    local money3 = display.newSprite("GameScene/money.png")
    money3:pos(self.wuqi3Point.x-4, display.bottom+3)
    money3:setScale(0.4)
    money3:addTo(self.tileMap)
      --显示需要金币的数量
     cc.ui.UILabel.new({
      text = "120",
      color = cc.c3b(250, 250, 5),
      size = 15,
    })
    :pos(self.wuqi3Point.x+1, display.bottom+8)
    :addTo(self.tileMap)

    local showWuqi3=display.newSprite("GameScene/showWuqi.png")
    showWuqi3:pos(self.wuqi3Point.x, self.wuqi3Point.y)
    showWuqi3:addTo(self.tileMap,2)
    local wuqi3 =  display.newSprite("GameScene/wuqi3.png")
    wuqi3:setScale(0.8)
    wuqi3:pos(showWuqi3:getContentSize().width/2,showWuqi3:getContentSize().height/2)
    wuqi3:addTo(showWuqi3)
    wuqi3:setTouchEnabled(true)
    wuqi3:setTouchSwallowEnabled(false)
    wuqi3:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)   
        if event.name=="began" then
            self.addSp=Wuqi3.new()
            self.showLayer:show()
            self.addSp:pos(event.x, event.y)
            self.addSp:setAnchorPoint(cc.p(0.5,0.5))
            self.addSp:addTo(self.tileMap,2)
            return true
        elseif event.name=="moved" then
           self.addSp:pos(event.x, event.y) 
        elseif event.name=="ended" then
            self.showLayer:hide()
            local x= event.x/64
            local y = (640-event.y)/64
            local tileGid = self.showLayer:getTileGIDAt(cc.p(math.floor(x),math.floor(y)))
            if tileGid<=0 then
                self.addSp:removeFromParent()
                return
            end
            for k,v in pairs(self.cannon) do
                local rect1= self:newRect(v)
                if cc.rectContainsPoint(rect1,cc.p(event.x,event.y)) then
                    self.addSp:removeFromParent()
                    return
                end
            end
            if self.money-self.addSp.make<0 then
                self.addSp:removeFromParent()
                return
            end
            self.addSp:pos(math.floor(x)*64+32, math.floor(10-y)*64+32)
            self.cannon[#self.cannon+1]=self.addSp
            self.money=self.money-self.addSp.make
            self.moneyNumLabel:setString(self.money)
        end
        
    end)

    
    local money4 = display.newSprite("GameScene/money.png")
    money4:pos(self.wuqi4Point.x-4, display.bottom+3)
    money4:setScale(0.4)
    money4:addTo(self.tileMap)
      --显示需要金币的数量
     cc.ui.UILabel.new({
      text = "200",
      color = cc.c3b(250, 250, 5),
      size = 15,
    })
    :pos(self.wuqi4Point.x+1, display.bottom+8)
    :addTo(self.tileMap)

    local showWuqi4=display.newSprite("GameScene/showWuqi.png")
    showWuqi4:pos(self.wuqi4Point.x, self.wuqi4Point.y)
    showWuqi4:addTo(self.tileMap,2)
    local wuqi4 =  display.newSprite("GameScene/wuqi4.png")
    wuqi4:setScale(0.8)
    wuqi4:pos(showWuqi4:getContentSize().width/2,showWuqi4:getContentSize().height/2)
    wuqi4:addTo(showWuqi4)
    wuqi4:setTouchEnabled(true)
    wuqi4:setTouchSwallowEnabled(false)
    wuqi4:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)   
        if event.name=="began" then
            self.addSp=Wuqi4.new()
            self.showLayer:show()
            self.addSp:pos(event.x, event.y)
            self.addSp:setAnchorPoint(cc.p(0.5,0.5))
            self.addSp:addTo(self.tileMap,2)
            return true
        elseif event.name=="moved" then
           self.addSp:pos(event.x, event.y) 
        elseif event.name=="ended" then
            self.showLayer:hide()
            local x= event.x/64
            local y = (640-event.y)/64
            local tileGid = self.showLayer:getTileGIDAt(cc.p(math.floor(x),math.floor(y)))
            if tileGid<=0 then
                self.addSp:removeFromParent()
                return
            end
            for k,v in pairs(self.cannon) do
                local rect1= self:newRect(v)
                if cc.rectContainsPoint(rect1,cc.p(event.x,event.y)) then
                    self.addSp:removeFromParent()
                    return
                end
            end
            if self.money-self.addSp.make<0 then
                self.addSp:removeFromParent()
                return
            end
            self.addSp:pos(math.floor(x)*64+32, math.floor(10-y)*64+32)
            self.cannon[#self.cannon+1]=self.addSp
            self.money=self.money-self.addSp.make
            self.moneyNumLabel:setString(self.money)
        end
        
    end)

    local money5 = display.newSprite("GameScene/money.png")
    money5:pos(self.wuqi5Point.x-4, display.bottom+3)
    money5:setScale(0.4)
    money5:addTo(self.tileMap)
      --显示需要金币的数量
     cc.ui.UILabel.new({
      text = "300",
      color = cc.c3b(250, 250, 5),
      size = 15,
    })
    :pos(self.wuqi5Point.x+1, display.bottom+8)
    :addTo(self.tileMap)

    local showWuqi5=display.newSprite("GameScene/showWuqi.png")
    showWuqi5:pos(self.wuqi5Point.x, self.wuqi5Point.y)
    showWuqi5:addTo(self.tileMap,2)
    local wuqi5 = cc.Sprite:create("GameScene/wuqi5.png")
    wuqi5:pos(showWuqi5:getContentSize().width/2,showWuqi5:getContentSize().height/2)
    wuqi5:addTo(showWuqi5)
    wuqi5:setTouchEnabled(true)
    wuqi5:setTouchSwallowEnabled(false)
    wuqi5:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)   
        if event.name=="began" then
            self.showLayer:show()
            self.addSp=Wuqi5.new()
            self.addSp:pos(event.x, event.y)
            self.addSp:setAnchorPoint(cc.p(0.5,0.5))
            self.addSp:addTo(self.tileMap,2)
            return true
        elseif event.name=="moved" then
           self.addSp:pos(event.x, event.y) 
        elseif event.name=="ended" then
            self.showLayer:hide()
            local x= event.x/64
            local y = (640-event.y)/64
            local tileGid = self.showLayer:getTileGIDAt(cc.p(math.floor(x),math.floor(y)))
            if tileGid<=0 then
                self.addSp:removeFromParent()
                return
            end
            for k,v in pairs(self.cannon) do
                local rect1= self:newRect(v)
                if cc.rectContainsPoint(rect1,cc.p(event.x,event.y)) then
                    self.addSp:removeFromParent()
                    return
                end
            end
            if self.money-self.addSp.make<0 then
                self.addSp:removeFromParent()
                return
            end
            self.addSp:pos(math.floor(x)*64+32, math.floor(10-y)*64+32)
            self.cannon[#self.cannon+1]=self.addSp
            self.money=self.money-self.addSp.make
            self.moneyNumLabel:setString(self.money)
        end
        
    end)

    
end

function GameScene:attack(v1,v)


  if v1:getTag()==10 then
    local rotate=cc.RotateTo:create(0.01,self:angle(v1,v)+180)
    v1:runAction(rotate)
    bullet = Bullet1.new()
    bullet:setScale(0.5)
    bullet:setAnchorPoint(cc.p(0.5,0.5))
    bullet:setPosition(v1:getPositionX(),v1:getPositionY())
    bullet:setRotation(v1:getRotation())
    bullet:addTo(self.tileMap,3) 

    local move=cc.MoveTo:create(0.2,cc.p(v:getPositionX(),v:getPositionY()))
    local func = cc.CallFunc:create(function (event)
    -- if bullet~=nil then
    --    local x =table.keyof(self.bullet, bullet)
    --         -- local y=table.removebyvalue(self.bullet, bullet, true)
    --        -- local x=table.indexof(self.bullet, bullet, 1)
    --        --  table.remove(self.bullet,x)
    --        bullet:stopAllActions()
    --       bullet:removeFromParent() 
    --       bullet = nil
    --        table.remove(self.bullet,x)
    --   end
    self.bullet[#self.bullet+1]=bullet
    event.isMove=false
    end)
    local seq = cc.Sequence:create(move,func) 
    bullet.isMove=true
    bullet.firepower=v1.firepower 
    bullet:runAction(seq)

  elseif v1:getTag()==20 then
    local rotate=cc.RotateTo:create(0.01,self:angle(v1,v)+180)
    v1:runAction(rotate)
    bullet = Bullet2.new()
    bullet:setAnchorPoint(cc.p(0.5,0.5))
    bullet:setPosition(v1:getPositionX(),v1:getPositionY())
    bullet:setRotation(v1:getRotation())
    local move=cc.MoveTo:create(0.2,cc.p(v:getPositionX(),v:getPositionY()))
    local func = cc.CallFunc:create(function(event)
    -- if bullet~=nil then
    --       local x =table.keyof(self.bullet, bullet)
    --         -- local y=table.removebyvalue(self.bullet, bullet, true)
           
    --       bullet:removeFromParent() 
    --       bullet = nil
    --        table.remove(self.bullet,x)
    --   end
    self.bullet[#self.bullet+1]=bullet
      event.isMove=false
    end)
    seq = cc.Sequence:create(move,func) 
    bullet.isMove=true
    bullet.firepower=v1.firepower
    bullet:addTo(self.tileMap,3)  
    bullet:runAction(seq)

  elseif v1:getTag()==30 then
    local rotate=cc.RotateTo:create(0.01,self:angle(v1,v)+180)
    v1:runAction(rotate)
    bullet = Bullet3.new()
    bullet:setAnchorPoint(cc.p(0.5,0.5))
    bullet:setRotation(v1:getRotation())
    bullet:setPosition(v1:getPositionX(),v1:getPositionY())
    local move=cc.MoveTo:create(0.2,cc.p(v:getPositionX(),v:getPositionY()))
    local func = cc.CallFunc:create(function (event)
    
    -- if bullet~=nil then
    --       local x =table.keyof(self.bullet, bullet)
    --         -- local y=table.removebyvalue(self.bullet, bullet, true)
            
    --       bullet:removeFromParent() 
    --       bullet = nil
    --       table.remove(self.bullet,x)
    --   end
    self.bullet[#self.bullet+1]=bullet
    event.isMove=false
    end)
    local seq = cc.Sequence:create(move,func) 
    bullet.isMove=true
    bullet.firepower=v1.firepower
    bullet:addTo(self.tileMap,3)  
    bullet:runAction(seq)
  elseif v1:getTag()==50 then
       bullet = Bullet5.new()
       bullet:setScale(0.5)
       bullet:setPosition(v:getPositionX(),v:getPositionY()+65)
       bullet:setAnchorPoint(cc.p(0.5,0.5))
       self.bullet[#self.bullet+1]=bullet
       local delay=cc.DelayTime:create(2)
    --    local x = v:getPositionX() - v1:getPositionX()
    --    local y = v:getPositionY() - v1:getPositionY()
    
    --    local bezier = {
    --     cc.p(v1:getPositionX(), v1:getPositionY()),
    --     cc.p(v1:getPositionX()+x/2, v1:getPositionY()+y/2+200),
    --     cc.p(v:getPositionX(), v:getPositionY()),
    --     }
    --    local bezierForward = cc.BezierTo:create(0.2, bezier)
    
    --    local func = cc.CallFunc:create(function (event)
    --    self.bullet[#self.bullet+1]=bullet
    --   end)
   
    -- local png = "GameScene/boon.png"
    -- local plist = "GameScene/boon.plist"
    -- display.addSpriteFrames(plist,png)
    -- local frames = display.newFrames("%d.png",1,6)
    -- local animation = display.newAnimation(frames,0.01)
    -- local animate = cc.Animate:create(animation)

    local func = cc.CallFunc:create(function (event)
          
          self.bullet[#self.bullet+1]=bullet
          event.isMove=false
            
    end)
    

    local seq = cc.Sequence:create(delay,func) 
    bullet.isMove=true
    bullet.firepower=v1.firepower
    bullet:addTo(self.tileMap,3)  
    bullet:runAction(seq)
        
  elseif v1:getTag()==40 then
       -- radious=v1.scope
       -- local move
      -- for i=1,9 do
        bullet = Bullet4.new()
        local move=cc.MoveTo:create(0.2,cc.p(v:getPositionX(),v:getPositionY()))
        -- if i==1 then
        --     move=cc.MoveBy:create(0.5, cc.p(radious, 0))
        -- elseif i==2 then
        --     move=cc.MoveBy:create(0.5, cc.p(radious*math.sin(45),radious*math.sin(45)))
        -- elseif i==3 then
        --     move=cc.MoveBy:create(0.5, cc.p(0,radious))
        -- elseif i==4 then
        --     move=cc.MoveBy:create(0.5, cc.p(-radious*math.sin(45*3.14/180), radious*math.sin(45*3.14/180)))
        -- elseif i==5 then
        --     move=cc.MoveBy:create(0.5, cc.p(-radious, 0))
        -- elseif i==6 then
        --     move=cc.MoveBy:create(0.5, cc.p(-radious*math.sin(45*3.14/180),-radious*math.sin(45*3.14/180)))
        -- elseif i==7 then
        --     move=cc.MoveBy:create(0.5, cc.p(0,-radious))
        -- elseif i==8 then
        --     move=cc.MoveBy:create(0.5, cc.p(radious*math.sin(45*3.14/180),-radious*math.sin(45*3.14/180)))
        -- end
        local func = cc.CallFunc:create(function (event)

           self.bullet[#self.bullet+1]=bullet
            event.isMove=false
          --  if bullet~=nil then
          --   -- local x =table.keyof(self.bullet, bullet)
          --   -- local y=table.removebyvalue(self.bullet, bullet, true)
          --   local x=table.indexof(self.bullet, bullet, 1)
          --   table.remove(self.bullet,x)
          --   bullet:removeFromParent() 
          --   bullet = nil
          -- end
            
        end)

       local seq = cc.Sequence:create(move,func) 
        bullet:setScale(0.6)
        bullet.isMove=true
        bullet:setPosition(v1:getPositionX(),v1:getPositionY())
        bullet:addTo(self.tileMap,3)  
        bullet:runAction(seq)
        bullet.firepower=v1.firepower
        -- end   
  end
    
end

function GameScene:newRect(v)
    if v==nil then
       return cc.rect(0,0,0,0)
    end
    local size = v:getContentSize()
    local x = v:getPositionX()
    local y = v:getPositionY()
    local rect = cc.rect(x-size.width/2, y-size.height/2,size.width, size.height)
    return rect
end

function GameScene:createEnermy()
  local function createE()
    if self.number==nil then
          return
    end
    self.number=self.number+1
    if self.number>totalNumber then
        scheduler.unscheduleGlobal(self.handle1)
        self.handle1=nil
        self.number=1
        self.isWin=true
        return
    end
    self.enermyNumLabel:setString(self.number.."/"..totalNumber)
    self.rad=math.random(1,3)
    self.enemyCreateTime=1.5

   if chapterNum>3 and self.rad==2 then
      self.beginPoint=nil
      self.endPoint=nil
      self.endPoint= self.hero:getObject("end2")
      self.beginPoint= self.hero:getObject("begin2")
    elseif chapterNum>5 and self.rad==3 then
      self.beginPoint=nil
      self.endPoint=nil
      self.endPoint= self.hero:getObject("end3")
      self.beginPoint= self.hero:getObject("begin3")
    else
      self.beginPoint=nil
      self.endPoint=nil
      self.endPoint= self.hero:getObject("end")
      self.beginPoint= self.hero:getObject("begin")
    end
    local function createMonster()
      if self.monsterNum==10 then
        scheduler.unscheduleGlobal(self.handle)
        self.handle=nil
        self.monsterNum=0
        return
      else
          local enermy=Enermy.new()
          self.moveSpeed=50
          
          if self.number==2 then
            enermy=nil
            enermy=Enermy2.new()
            self.moveSpeed=100
            self.enemyCreateTime=1.4
        elseif self.number==3 then
            enermy=nil
            enermy=Enermy3.new()
            self.moveSpeed=100
            self.enemyCreateTime=1.3
        elseif self.number==4 then
            enermy=nil
            enermy=Enermy4.new()
            self.moveSpeed=150
            self.enemyCreateTime=1.2
        elseif self.number==5 then
            enermy=nil
            enermy=Enermy5.new()
            self.moveSpeed=150
            self.enemyCreateTime=1.1
        elseif self.number==6 then
            enermy=nil
            enermy=Enermy6.new()
            self.moveSpeed=150
            self.enemyCreateTime=1.0
        elseif self.number==7 then
            enermy=nil
            enermy=Enermy7.new()
            self.moveSpeed=200
            self.enemyCreateTime=0.9
        elseif self.number==8 then
            enermy=nil
            enermy=Enermy8.new()
            self.moveSpeed=200
            self.enemyCreateTime=0.8
        elseif self.number==9 then
            enermy=nil
            enermy=Enermy9.new()
            self.moveSpeed=200
            self.enemyCreateTime=0.7
        elseif self.number==10 then
            enermy=nil
            enermy=Enermy10.new()
            self.moveSpeed=250
            self.enemyCreateTime=0.6
        elseif self.number==11 then
            enermy=nil
            enermy=Enermy11.new()
            self.moveSpeed=250
            self.enemyCreateTime=0.5
        elseif self.number==12 then
            enermy=nil
            enermy=Enermy12.new()
            self.moveSpeed=250
            self.enemyCreateTime=0.4
        elseif self.number==13 then
            enermy=nil
            enermy=Enermy13.new()
            self.moveSpeed=300
            self.enemyCreateTime=0.3
        elseif self.number==14 then
            enermy=nil
            enermy=Enermy14.new()
            self.moveSpeed=300
            self.enemyCreateTime=0.2
        elseif self.number==15 then
            enermy=nil
            enermy=Enermy15.new()
            self.moveSpeed=300
            self.enemyCreateTime=0.1
        end
          enermy:pos(self.beginPoint.x, self.beginPoint.y)
          enermy:addTo(self.tileMap,1)
          self.monster[#self.monster+1]=enermy
          enermy:runAction(self:creatDongHua())
          self.monsterNum=self.monsterNum+1
        
      end
    end

    -- if self.enemyCreateTime==1.5 then
    --   if self.handle~=nil then
    --     scheduler.unscheduleGlobal(self.handle)
    --     self.handle=nil
    --    end
    --   self.handle= scheduler.scheduleGlobal(createMonster,1.5)
    -- elseif self.enemyCreateTime==1.4 then
    --   if self.handle~=nil then
    --     scheduler.unscheduleGlobal(self.handle)
    --     self.handle=nil
    --    end
    --     self.handle= scheduler.scheduleGlobal(createMonster,1.4)
    -- elseif self.enemyCreateTime==1.3 then
    --   if self.handle~=nil then
    --     scheduler.unscheduleGlobal(self.handle)
    --     self.handle=nil
    --    end
    --   self.handle= scheduler.scheduleGlobal(createMonster,1.3)
    -- elseif self.enemyCreateTime==1.2 then
    --   if self.handle~=nil then
    --     scheduler.unscheduleGlobal(self.handle)
    --     self.handle=nil
    --    end
    --   self.handle= scheduler.scheduleGlobal(createMonster,1.2)
    -- elseif self.enemyCreateTime==1.1 then
    --   if self.handle~=nil then
    --     scheduler.unscheduleGlobal(self.handle)
    --     self.handle=nil
    --    end
    --   self.handle= scheduler.scheduleGlobal(createMonster,1.1)
    -- elseif self.enemyCreateTime==1 then
    --   if self.handle~=nil then
    --     scheduler.unscheduleGlobal(self.handle)
    --     self.handle=nil
    --    end
    --   self.handle= scheduler.scheduleGlobal(createMonster,1)
    -- elseif self.enemyCreateTime==0.9 then
    --   if self.handle~=nil then
    --     scheduler.unscheduleGlobal(self.handle)
    --     self.handle=nil
    --    end
    --     self.handle= scheduler.scheduleGlobal(createMonster,0.9)
    -- elseif self.enemyCreateTime==0.8 then
    --   if self.handle~=nil then
    --     scheduler.unscheduleGlobal(self.handle)
    --     self.handle=nil
    --    end
    --   self.handle= scheduler.scheduleGlobal(createMonster,0.8)
    -- elseif self.enemyCreateTime==0.7 then
    --   if self.handle~=nil then
    --     scheduler.unscheduleGlobal(self.handle)
    --     self.handle=nil
    --    end
    --   self.handle= scheduler.scheduleGlobal(createMonster,0.7)
    -- elseif self.enemyCreateTime==0.6 then
    --   if self.handle~=nil then
    --     scheduler.unscheduleGlobal(self.handle)
    --     self.handle=nil
    --    end
    --   self.handle= scheduler.scheduleGlobal(createMonster,0.6)
    -- elseif self.enemyCreateTime==0.5 then
    --   if self.handle~=nil then
    --     scheduler.unscheduleGlobal(self.handle)
    --     self.handle=nil
    --    end
    --     self.handle= scheduler.scheduleGlobal(createMonster,0.5)
    -- elseif self.enemyCreateTime==0.4 then
    --   if self.handle~=nil then
    --     scheduler.unscheduleGlobal(self.handle)
    --     self.handle=nil
    --    end
    --   self.handle= scheduler.scheduleGlobal(createMonster,0.4)
    -- elseif self.enemyCreateTime==0.3 then
    --   if self.handle~=nil then
    --     scheduler.unscheduleGlobal(self.handle)
    --     self.handle=nil
    --    end
    --   self.handle= scheduler.scheduleGlobal(createMonster,0.3)
    -- elseif self.enemyCreateTime==0.2 then
    --   if self.handle~=nil then
    --     scheduler.unscheduleGlobal(self.handle)
    --     self.handle=nil
    --    end
    --   self.handle= scheduler.scheduleGlobal(createMonster,0.2)
    -- elseif self.enemyCreateTime==0.1 then
    --   if self.handle~=nil then
    --     scheduler.unscheduleGlobal(self.handle)
    --     self.handle=nil
    --    end
      self.handle= scheduler.scheduleGlobal(createMonster,1.5)
    -- end

  end
   self.handle1= scheduler.scheduleGlobal(createE,40)


   
end

function GameScene:createOneEnermy()
   self.rad=math.random(1,3)

   if chapterNum>3 and self.rad==2 then
      self.beginPoint=nil
      self.endPoint=nil
      self.endPoint= self.hero:getObject("end2")
      self.beginPoint= self.hero:getObject("begin2")
    elseif chapterNum>5 and self.rad==3 then
      self.beginPoint=nil
      self.endPoint=nil
      self.endPoint= self.hero:getObject("end3")
      self.beginPoint= self.hero:getObject("begin3")
    else
      self.beginPoint=nil
      self.endPoint=nil
      self.endPoint= self.hero:getObject("end")
      self.beginPoint= self.hero:getObject("begin")
    end
    local enermy
    local function createE()
        if self.monsterNum==10 then
            scheduler.unscheduleGlobal(self.handle)
            self.handle=nil
            self.monsterNum=0
            return
        end
         
        enermy=Enermy.new()
        self.moveSpeed=50
        enermy:pos(self.beginPoint.x, self.beginPoint.y)
        -- enermy.old_life=enermy.hp
        enermy:addTo(self.tileMap,1)
        self.monster[#self.monster+1]=enermy
        enermy:runAction(self:creatDongHua())
        self.monsterNum=self.monsterNum+1
    end
    self.handle= scheduler.scheduleGlobal(createE,1.5)
    
end


function GameScene:angle(v1,v)
    local x = v1:getPositionX()-v:getPositionX()
    local y = v1:getPositionY()-v:getPositionY()
    
    if x>0 then
        if y==0 then
           return 90
        elseif y>0 then
            return math.atan(x/y)*180/3.14
        else
            return math.atan(x/y)*180/3.14+180
        end
    else
        if y>0 then
            return math.atan(x/y)*180/3.14
        elseif y==0 then
            return -90
        else
            return math.atan(x/y)*180/3.14-180
        end    
    end
end


function GameScene:creatDongHua()
  local move={}

    local enermy=self.hero:getObjects()
    
    local i=1
    local timee

    if chapterNum>3 and self.rad==2 then
       i=11
       for k,v in pairs(enermy) do
        local name1="tag"..i
        if v.name==name1 then
            if i==11 then
                local x= self.beginPoint.x-v.x
                local y = self.beginPoint.y-v.y
                timee = math.sqrt(x*x+y*y)/self.moveSpeed
            else
                local str = "tag"..(i-1)
                local upv = self.hero:getObject(str)
                local x= upv.x-v.x
                local y = upv.y-v.y
                timee = math.sqrt(x*x+y*y)/self.moveSpeed
            end
            i=i+1

            move[#move+1]=cc.MoveTo:create(timee,cc.p(v.x,v.y))
        end
    end
    elseif chapterNum>5 and self.rad==3 then
      i=21
       for k,v in pairs(enermy) do
        local name1="tag"..i
        if v.name==name1 then
            if i==21 then
                local x= self.beginPoint.x-v.x
                local y = self.beginPoint.y-v.y
                timee = math.sqrt(x*x+y*y)/self.moveSpeed
            else
                local str = "tag"..(i-1)
                local upv = self.hero:getObject(str)
                local x= upv.x-v.x
                local y = upv.y-v.y
                timee = math.sqrt(x*x+y*y)/self.moveSpeed
            end
            i=i+1

            move[#move+1]=cc.MoveTo:create(timee,cc.p(v.x,v.y))
        end
    end
    else
      i=1
        for k,v in pairs(enermy) do
        local name1="tag"..i
        if v.name==name1 then
            if i==1 then
                local x= self.beginPoint.x-v.x
                local y = self.beginPoint.y-v.y
                timee = math.sqrt(x*x+y*y)/self.moveSpeed
            else
                local str = "tag"..(i-1)
                local upv = self.hero:getObject(str)
                local x= upv.x-v.x
                local y = upv.y-v.y
                timee = math.sqrt(x*x+y*y)/self.moveSpeed
            end
            i=i+1

            move[#move+1]=cc.MoveTo:create(timee,cc.p(v.x,v.y))
        end
    end
    end

   
    local str = "tag"..(i-1)
    local upv = self.hero:getObject(str)
    local x= upv.x-self.endPoint.x
    local y = upv.y-self.endPoint.y
    timee = math.sqrt(x*x+y*y)/self.moveSpeed
    move[#move+1]=cc.MoveTo:create(timee,cc.p(self.endPoint.x, self.endPoint.y))
    move[#move+1]=cc.CallFunc:create(function (event)
        event.isMove=false
    end)
    local seq = cc.Sequence:create(move)
    return seq
end

function GameScene:updata()

    local function attackEnermy()
        for k1,v1 in pairs(self.cannon) do
            for k,v in pairs(self.monster) do
                --计算敌人与炮塔的距离
                local x= v:getPositionX()-v1:getPositionX()
                local y= v:getPositionY()-v1:getPositionY()
                local s = math.sqrt(x*x+y*y)
                --如果距离小于武器的攻击范围，那么攻击
                if s<=v1.scope then 
                    if v1.attack==true then
                        v1.attack=false
                        local delay = cc.DelayTime:create(v1.attackSpeed)
                        local func= cc.CallFunc:create(function (even)
                            even.attack=true
                        end)
                    local seq = cc.Sequence:create(delay,func)
                        v1:runAction(seq)
                        self:attack(v1,v)
                    end
                    break
                end 
            end
        end 
        if self.isWin and #self.monster==0 then
            
            
             --修改数据
            self:modify()
            local Win = WinLayer.new()
            Win:setPosition(cc.p(0, 0))
            self:addChild(Win,3)
               

        end
    end
    self.handle2= scheduler.scheduleGlobal(attackEnermy,0.1)
end

function GameScene:removeUpdata()
    local function remove_nomove()
        for k,v in pairs(self.monster) do
          local rect1= v:getBoundingBox()
          for k1,v1 in pairs(self.bullet) do
            if v1.tag==100 then
                    rect2=v1:getBoundingBox()

                    if cc.rectIntersectsRect(rect2,rect1) then

                        v.hp=v.hp-v1.firepower
                        v.life:setScaleX(v.hp/v.old_life)
                        v1:removeFromParent()
                        v1=nil
                        table.remove(self.bullet,k1)
                    end 
              elseif v1.tag==200 then
                    rect2=v1:getBoundingBox()
                    if cc.rectIntersectsRect(rect2,rect1) then
                        v.hp=v.hp-v1.firepower
                        v.life:setScaleX(v.hp/v.old_life)
                        v1:removeFromParent()
                        v1=nil
                        table.remove(self.bullet,k1)
                    end 
                elseif v1.tag==300 then
                    rect2=v1:getBoundingBox()
                    if cc.rectIntersectsRect(rect2,rect1) then
                        v.hp=v.hp-v1.firepower
                        v.life:setScaleX(v.hp/v.old_life)
                        v1:removeFromParent()
                        v1=nil
                        table.remove(self.bullet,k1)
                    end 
                elseif v1.tag==400 then
                    rect2=v1:getBoundingBox()
                    if cc.rectIntersectsRect(rect2,rect1) then
                        v.hp=v.hp-v1.firepower
                        v.life:setScaleX(v.hp/v.old_life)
                        -- v1:stopAllActions()
                        v1:removeFromParent()
                        v1=nil
                        table.remove(self.bullet,k1)
                        
                    end 
                elseif v1.tag==500 then
                    rect2=v1:getBoundingBox()
                    if cc.rectIntersectsRect(rect2,rect1) then
                        v.hp=v.hp-v1.firepower
                        v.life:setScaleX(v.hp/v.old_life)
                        table.remove(self.bullet,k1)
                        v1:removeFromParent()
                        v1=nil
                        
                    end 
                end
          end
        end

        for i=#self.monster,1,-1 do
            if  self.monster[i].isMove==false then
                    self.hp=self.hp-1
                    if self.hp<1 then
                        cc.Director:getInstance():pause()

                        if self.handle~=nil then
                            scheduler.unscheduleGlobal(self.handle)
                        end
                        if self.handle1~=nil then
                            scheduler.unscheduleGlobal(self.handle1)
                        end
                        if self.handle2~=nil then
                            scheduler.unscheduleGlobal(self.handle2)
                        end
                        if self.remove~=nil then
                            scheduler.unscheduleGlobal(self.remove)
                        end
                        local loseLayer = LoseLayer.new()
                        loseLayer:setPosition(cc.p(0, 0))
                        self:addChild(loseLayer,3)
                    end
                    self.hpNumLabel:setString(self.hp)
                    self.monster[i]:removeFromParent()
                    table.remove(self.monster,i)
                    v=nil
            end
            if self.monster[i]~=nil and self.monster[i].hp<=0 then
               
                if self.monster[i]._hp~=1  then
                   
                end
                self.money=self.money+self.monster[i].money
                self.moneyNumLabel:setString(self.money)
                self.killEnermyNum=self.killEnermyNum+1
                self.killEnermyNumLabel:setString(self.killEnermyNum)
                self.monster[i]:removeFromParent()
                table.remove(self.monster,i)
            end
        end
        for i=#self.bullet,1,-1 do
            if self.bullet[i].isMove==false  then
                self.bullet[i]:removeFromParent()
                table.remove(self.bullet,i)
               
            end
        end

    end
    self.remove= scheduler.scheduleGlobal(handler(self, remove_nomove),0.01)
end

function GameScene:newRect2(v)
    if v==nil then
       return cc.rect(0,0,0,0)
    end
    local size = v:getContentSize()
    local x = v:getPositionX()
    local y = v:getPositionY()
    -- print(x,y)
    local rect = cc.rect(x, y,size.width, size.height)
    return rect
end

function GameScene:modify()
    local tb = PublicData.SCENETABLE
    if ModifyData.getChapterNumber()==8 then
        ModifyData.setChapterNumber(0)
        ModifyData.setSceneNumber(sceneNum+1)
        tb[sceneNum+1][1].lock=0
    else
        tb[ModifyData.getSceneNumber()][ModifyData.getChapterNumber()+1].lock=0
    end

    local str = json.encode(tb)
    ModifyData.writeToDoc(str)
end

function GameScene:onEnter()
    audio.playMusic("music/bg_music.mp3",true)

end

function GameScene:onExit()
  audio.pauseMusic()
  audio.preloadMusic("music/fight.mp3")
  audio.playMusic("music/fight.mp3",true)
    if self.handle~=nil then
        scheduler.unscheduleGlobal(self.handle)
    end
    if self.handle1~=nil then
        scheduler.unscheduleGlobal(self.handle1)
    end
    if self.handle2~=nil then
        scheduler.unscheduleGlobal(self.handle2)
    end
    if self.remove~=nil then
       scheduler.unscheduleGlobal(self.remove)
    end
end
return GameScene