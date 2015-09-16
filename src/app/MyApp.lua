
require("config")
require("cocos.init")
require("framework.init")
require("app.Class.ClassManager")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
     cc.Director:getInstance():setContentScaleFactor(960/CONFIG_SCREEN_WIDTH)
    self:enterScene("StartScene")
end

return MyApp
