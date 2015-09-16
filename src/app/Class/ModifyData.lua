--
-- Author: student
-- Date: 2015-07-27 17:40:04
--
module("ModifyData",package.seeall)

sceneNumber = 1
chapterNumber = 1 

isPlay=true
function setMusic(num)
	isPlay=num
end
function getMusic()
	return isPlay
end
--设置场景数
function setSceneNumber(num)
	sceneNumber = num
end
--设置关卡数
function setChapterNumber(num)
	chapterNumber = num
end
--得到场景数
function getSceneNumber()
	return sceneNumber
end
--得到关卡数
function getChapterNumber()
	return chapterNumber
end
--写入沙盒路径
function writeToDoc(str)
	local docpath = cc.FileUtils:getInstance():getWritablePath().."data.txt"
    local f = assert(io.open(docpath, 'w'))
    f:write(str)
    f:close()
end

--从沙盒路径下读出
function readFromDoc()
	local docpath = cc.FileUtils:getInstance():getWritablePath().."data.txt"
 	local str = cc.FileUtils:getInstance():getStringFromFile(docpath)
  	return str
end