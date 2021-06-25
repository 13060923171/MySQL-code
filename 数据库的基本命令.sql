#创建数据库
create database demo;

#在数据表创建数据表
create table demo.test(
	bracode text,
    goodsname text,
    price int
);

#怎么查看表的结构
describe demo.test;

#怎么查看数据库中表
use demo;
select tables;

#设置主键,通过修改表的结构，添加主键
alter table demo.test add column itemnumber int primary key auto_increment;
#alter table 表示修改表
#add column 表示增加一列
#primary key 表示这一列是主键
#auto_increment 表示每增加一条记录，这个值自动增加

#插入数据
insert into demo.test(
	barcode,
    goodsname,
    price
)
values(
		'0001',
        '本子',
        3
);
#查看开关的状态
show variables like 'SQL_SAFE_UPDATES';
#修改数据库模式
SET SQL_SAFE_UPDATES = 0;