--
-- Author: student
-- Date: 2015-07-27 18:18:11
--
module("Data", package.seeall)
function getItemData(num1,num2)
	local itemData = ITEM[num1][num2]
	return itemData
end
function getSnailData(num1,num2)
	local snai--
	-- Author: student
	-- Date: 2015-07-27 18:28:50
	--
	lData = SNAIL[num1][num2]
	return snailData 
end
function getChapterBtnData(num)
	local chapterBtnData = CHAPTERBTN[num]
	return chapterBtnData
end



SCENE = {}

SCENE[1] = {}
SCENE[1][1] = {lock = 0, money=500 ,number=15, type=10}
SCENE[1][2] = {lock = 1, money=500 ,number=18, type=11}
SCENE[1][3] = {lock = 1, money=500 ,number=21, type=12}
SCENE[1][4] = {lock = 1, money=500 ,number=24, type=13} 
SCENE[1][5] = {lock = 1, money=500 ,number=27, type=14}
SCENE[1][6] = {lock = 1, money=500 ,number=30, type=15}


SCENE[2] = {}
SCENE[2][1] = {lock = 0, money=500 ,number=15, type=10}
SCENE[2][2] = {lock = 1, money=500 ,number=18, type=11}
SCENE[2][3] = {lock = 1, money=500 ,number=21, type=12}
SCENE[2][4] = {lock = 1, money=500 ,number=24, type=13}
SCENE[2][5] = {lock = 1, money=500 ,number=27, type=14}
SCENE[2][6] = {lock = 1, money=500 ,number=30, type=15}

SCENE[3] = {}
SCENE[3][1] = {lock = 0, money=500 ,number=15, type=10}
SCENE[3][2] = {lock = 1, money=500 ,number=18, type=11}
SCENE[3][3] = {lock = 1, money=500 ,number=21, type=12}
SCENE[3][4] = {lock = 1, money=500 ,number=24, type=13}
SCENE[3][5] = {lock = 1, money=500 ,number=27, type=14}
SCENE[3][6] = {lock = 1, money=500 ,number=30, type=15}


CHAPTERBTN = {}
CHAPTERBTN[1] = {pic = "SelectChapter/seal_level1_off.png", pic2 = "SelectChapter/seal_level1_off.png"}
CHAPTERBTN[2] = {pic = "SelectChapter/seal_level2_off.png", pic2 = "SelectChapter/seal_level2_on.png"}
CHAPTERBTN[3] = {pic = "SelectChapter/seal_level3_off.png", pic2 = "SelectChapter/seal_level3_on.png"}
CHAPTERBTN[4] = {pic = "SelectChapter/seal_level4_off.png", pic2 = "SelectChapter/seal_level4_on.png"}
CHAPTERBTN[5] = {pic = "SelectChapter/seal_level5_off.png", pic2 = "SelectChapter/seal_level5_on.png"}
CHAPTERBTN[6] = {pic = "SelectChapter/seal_level6_off.png", pic2 = "SelectChapter/seal_level6_on.png"}