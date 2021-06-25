#把强实体转化成独立的数据表

#商户表
create table test.enterprice(
	groupnumber int primary key,
    groupname text,
    address text,
    phone int,
    contactor text
);

#商品信息表
create table test.goodsmaster(
	groupnumber int primary key,
    itemnumber text,
    barcoder text,
    goodsname text,
    specification text,
    unit text,
    salesprice decimal(10,2)
);

#把弱实体转换成独立的数据表
#门店表
create table test.branch(
	branchid int primary key,
    groupnumber int ,
    branchname text,
    address text,
    phone int,
    branchtype text
);

#员工表
create table test.employee(
	employeeid int primary key,
    groupnumber int,
    branchid int,
    workno int,
    name text,
    pid text,
    phone int,
    duty text
);

#仓库表
create table test.stockmaster(
	stockid int primary key,
    groupnumber int,
    branchid int,
    stocknumber int,
    stockkind text
);

#把多对多的关系转换成独立的数据表
#库存表
create table test.inventory(
	id int primary key,
    groupnumber int,
    branchid int,
    stockid int,
    itemnumber int,
    itemquantity int
);

#盘点单头表
create table test.invcounthead(
	listnumber int primary key,
    groupnumber int,
    branchid int,
    stockid int,
    recorder text,
    recordingdate datetime
);

#盘点单明细表
create table test.invcountdetails(
	listnumber int primary key,
    groupnumber int,
    branchid int,
    stockid int,
    itemnumber int,
    accquant int,
    invquant int,
    plquant int
);


#对项目进行分库分表
#分库分表又分为垂直分表，垂直分库，水平分库，水平分表

#垂直分表，把一个经常使用的表，拆分成2个或多个表
#把商品信息表拆分
#商品常用信息表
create table test.goods_o(
	groupnumber text,
    itemnumber text,
    barcode text,
    goodsname text,
    salesprice decimal(10,2)
);


#商品不常用信息表
create table test.goods_f(
	groupnumber text,
    itemnumber text,
    specification text,
    unit text
);


#垂直分库的意思是，把不同的模块的数据表分别存放到不同的数据库中

#水平分表就是把数据表的内容，按照一定的规则拆分出去

#盘点单头表历史表
create table test.invcountheadhist(
	listnumber int primary key,
    groupnumber int,
    branchid int,
    stockid int,
    recorder text,
    recordingdate datetime,
    confirmer text,
    confirmationdate datetime
);

#盘点单明细表历史表
create table test.invcountdetailshist(
	listnumber int primary key,
    groupnumber int,
    branchid int,
    stockid int,
    itemnumber int,
    accquant int,
    invquant int,
    plquant int
);

#水平分库就是按照一定的规则，把数据库中的数据拆分出去，保存在新的数据库当中




#创建营运数据库
create database operation;
#创建库存数据库
create database inventory;

#商户表
create table operation.enterprice(
	groupnumber smallint primary key,
    groupname varchar(100) not null,
    address text not null,
    phone varchar(20) not null,
    contactor varchar(50) not null
);

#门店表
create table operation.branch(
	branchid smallint primary key,
    groupnumber smallint not null,
    branchname varchar(100) not null,
    address text not null,
    phone varchar(20) not null,
    branchtype varchar(20) not null,
    CONSTRAINT fk_branch_enterprice FOREIGN KEY (groupnumber) REFERENCES operation.enterprice(groupnumber)
);

#员工表
create table operation.employee(
	employeeid smallint primary key,
    groupnumber smallint not null,
    branchid smallint not null,
    workno varchar(20) not null,
    employeename varchar(100) not null,
    pid varchar(20) not null,
    address varchar(100) not null,
    phone varchar(20) not null,
    employeeduty varchar(20) not null,
    CONSTRAINT fk_employee_branch FOREIGN KEY (branchid) REFERENCES operation.branch(branchid)
);

#商品常用信息表
create table operation.goods_o(
	itemnumber mediumint primary key,
    groupnumber smallint not null,
    barcode varchar(50) not null,
    goodsname text not null,
    salesprice decimal(10,2) not null

);

#商品不常用信息表
create table operation.goods_f(
	itemnumber mediumint primary key,
    groupnumber smallint not null,
    specification text not null,
    unit varchar(20) not null
);

#仓库表
create table inventory.stockmaster(
	stockid smallint primary key,
    groupnumber smallint not null,
    branchid smallint not null,
    stockname varchar(100) not null,
    stockkind varchar(20) not null,
	CONSTRAINT fk_stock_branch FOREIGN KEY (branchid) REFERENCES operation.branch(branchid)
);

#库存表
create table inventory.inventory(
	id int primary key auto_increment,
    groupnumber smallint not null,
    branchid smallint not null,
    stockid smallint not null,
    itemnumber mediumint not null,
    itemquantity decimal(10,3) not null
);

#盘点单头表
create table inventory.invcounthead(
	listnumber int primary key,
    groupnumber smallint not null,
    branchid smallint not null,
    stockid smallint not null,
    recorder smallint not null,
    recordingdate datetime not null
);

#盘点单明细表
create table inventory.invcountdetails(
	id int primary key auto_increment,
    listnumber int not null,
    groupnumber smallint not null,
    branchid smallint not null,
    stockid smallint not null,
    itemnumber mediumint not null,
    accquant decimal(10,3) not null,
    invquant decimal(10,3) not null,
    plquant decimal(10,3) not null
);

#盘点单头历史表
create table inventory.invcountheadhist(
	listnumber int primary key,
    groupnumber smallint not null,
    branchid smallint not null,
    stockid smallint not null,
    recorder smallint not null,
    recordingdate datetime not null,
    confirmer smallint not null,
    confirmationdate datetime not null
);

#盘点单明细历史表
create table inventory.invcountdetailshist(
	id int primary key auto_increment,
    listnumber int not null,
    groupnumber smallint not null,
    branchid smallint not null,
    stockid smallint not null,
    itemnumber mediumint not null,
    accquant decimal(10,3) not null,
    invquant decimal(10,3) not null,
    plquant decimal(10,3) not null
);

#创建索引来提高我们的查询效率
#选用商家表的组号来创建索引
CREATE INDEX index_enterprice_groupname ON operation.enterprice (groupname);
#选择门店号的组号来创建索引
create index index_branch_groupnumber on operation.branch(groupnumber);
#选择门店名称字段来作为索引
create index index_branch_branchname on operation.branch(branchname);
#选择门店类别作为索引
create index index_branch_branchtype on operation.branch(branchtype);

#选择组号创建索引
create index index_employee_groupnumber on operation.employee(groupnumber);
create index index_employee_branchid on operation.employee(branchid);

create index index_employee_pid on operation.employee(pid);
create index index_employee_phone on operation.employee(phone);
create index index_employee_duty on operation.employee(employeeduty);

create index index_goodso_groupnumber on operation.goods_o(groupnumber);
create index index_goodso_salesprice on operation.goods_o(salesprice);
create index index_goodsf_groupnumber on operation.goods_f(groupnumber);

create index index_stock_groupnumber on inventory.stockmaster(groupnumber);
create index index_stock_branchid on inventory.stockmaster(branchid);

create index index_inventory_groupnumber on inventory.inventory(groupnumber);
create index index_inventory_branchid on inventory.inventory(branchid);

create index index_inventory_itemnumber on inventory.inventory(itemnumber);

create index index_invcounthead_branchid on inventory.invcounthead(branchid);

create index index_invcountdetails_branchid on inventory.invcountdetails(branchid);
create index index_invcountdetails_itemnumber on inventory.invcountdetails(itemnumber);
CREATE INDEX index_invcounthaedhist_branchid ON inventory.invcountheadhist (branchid);
CREATE INDEX index_invcounthaedhist_confirmationdate ON inventory.invcountheadhist (confirmationdate);

CREATE INDEX index_invcountdetailshist_branchid ON inventory.invcountdetailshist(branchid);

CREATE INDEX index_invcountdetailshist_itemnumber ON inventory.invcountdetailshist(itemnumber);

#创建视图
create view view_invcount as select a.*,b.itemnumber,b.accquant,b.invquant,b.plquant from inventory.invcounthead as a 
join inventory.invcountdetails as b on (a.listnumber = b.listnumber);

#创建单历史表创建视图
create view view_invcounthist as select a.*,b.itemnumber,b.accquant,b.invquant,b.plquant
from inventory.invcountheadhist as a 
join inventory.invcountdetailshist as b on (a.listnumber = b.listnumber);


-- CREATE DEFINER=`root`@`localhost` PROCEDURE `invcountconfirm`(mylistnumber INT,myconfirmer SMALLINT)
-- BEGIN
-- DECLARE done INT DEFAULT FALSE;
-- DECLARE mybranchid INT;
-- DECLARE myitemnumber INT;
-- DECLARE myplquant DECIMAL(10,3);
-- DECLARE cursor_invcount CURSOR FOR 
-- SELECT branchid,itemnumber,plquant
-- FROM inventory.invcountdetails
-- WHERE listnumber = mylistnumber;
-- DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
-- DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK; 

-- START TRANSACTION;         
--  OPEN cursor_invcount; -- 打开游标
--  FETCH cursor_invcount INTO mybranchid,myitemnumber,myplquant; -- 读入第一条记录
-- REPEAT
--   UPDATE inventory.inventory
--   SET itemquantity = itemquantity + myplquant    -- 更新库存
--         WHERE itemnumber = myitemnumber
--         AND branchid = mybranchid; 
--   FETCH cursor_invcount INTO mybranchid,myitemnumber,myplquant; -- 读入下一条记录
--  UNTIL done END REPEAT;
--     
--  CLOSE cursor_invcount;
--     
--   INSERT INTO inventory.invcountdetailshist 
-- (listnumber,groupnumber,branchid,stockid,itemnumber,accquant,invquant,plquant) 
--   SELECT listnumber,groupnumber,branchid,stockid,itemnumber,accquant,invquant,plquant
--   FROM inventory.invcountdetails 
--   WHERE listnumber=mylistnumber;  -- 把这一单的盘点单明细插入历史表

--   INSERT INTO inventory.invcountheadhist  
-- (listnumber,groupnumber,branchid,stockid,recorder,recordingdate,confirmer,confirmationdate) 
--   SELECT listnumber,groupnumber,branchid,stockid,recorder,recordingdate,myconfirmer,now()
--   FROM inventory.invcounthead
--   WHERE listnumber=mylistnumber;  -- 把这一单的盘点单头插入历史 
--   DELETE FROM inventory.invcountdetails WHERE listnumber = mylistnumber; -- 删除这一单的盘点单明细表数据
--  DELETE FROM inventory.invcounthead WHERE listnumber = mylistnumber; -- 删除这一单的盘点单头表数据
-- COMMIT;
-- END


delimiter //
create trigger operation.del_goodso before delete
on operation.goods_o
for each row 
begin
delete from operation.goods_f
	where groupnumber = old.groupnumber
    and itemnumber = old.itemnumber;
end
//
delimiter ;

delimiter //
create trigger operation.del_goodsf before delete
on operation.goods_f
for each row
begin
delete from operation.goods_o
	where groupnumber=old.groupnumber
    and itemnumber=old.itemnumber;
end
//
delimiter ;


