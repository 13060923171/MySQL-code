#使用游标的四个步骤
#第一定义游标
#declare 游标名 cursor for 查询语句
#第二步打开游标
#open 游标名称
#第三步从游标的数据结果中读取数据
#fetch 游标名 into 变量列表
#第四步关闭游标
#close 游标名



DELIMITER //
CREATE PROCEDURE demo.mytest(mylistnumber INT)
BEGIN
DECLARE mystockid INT;
DECLARE myitemnumber INT;
DECLARE myquantity DECIMAL(10,3);
DECLARE myprice DECIMAL(10,2);
DECLARE done INT DEFAULT FALSE; -- 用来控制循环结束
DECLARE cursor_importdata CURSOR FOR -- 定义游标
SELECT b.stockid,a.itemnumber,a.quantity,a.importprice
FROM demo.importdetails AS a
JOIN demo.importhead AS b
ON (a.listnumber=b.listnumber)
WHERE a.listnumber = mylistnumber;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; -- 条件处理语句
OPEN cursor_importdata; -- 打开游标
FETCH cursor_importdata INTO mystockid,myitemnumber,myquantity,myprice; -- 读入第一条记录
REPEAT
-- 更新进价
UPDATE demo.goodsmaster AS a,demo.inventory AS b
SET a.avgimportprice = (a.avgimportprice*b.invquantity+myprice*myquantity)/(b.invquantity+myquantity)
WHERE a.itemnumber=b.itemnumber AND b.stockid=mystockid AND a.itemnumber=myitemnumber;
-- 更新库存
UPDATE demo.inventory
SET invquantity = invquantity + myquantity
WHERE stockid = mystockid AND itemnumber=myitemnumber;
-- 获取下一条记录
FETCH cursor_importdata INTO mystockid,myitemnumber,myquantity,myprice;
UNTIL done END REPEAT;
CLOSE cursor_importdata;
END
//
DELIMITER ;

#条件处理语句
#declare 处理方式 handler for 问题 操作
call demo.mytest(1234);
select * from demo.inventory;
select * from demo.goodsmaster;