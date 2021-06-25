select quantity,price,transdate from demo.trans where 
transdate > '2020-12-13' and transdate < '2020-12-13' and itemnumber = 100;

#修改表时创建索引的语法如下所示：
-- ALTER TABLE 表名 ADD { INDEX | KEY } 索引名 (字段);

#直接给数据表创建索引的语法如下
-- CREATE INDEX 索引名 ON TABLE 表名 (字段);

create index index_trans on demo.trans(transdate);

select * from demo.trans;

#explain能够查看SQL语句的执行细节，包括表的加载顺序，表是如何连接的，以及索引使用情况等
explain select quantity,price,transdate from demo.trans where transdate > '2020-12-12' 
and transdate < '2020-12-13' and itemnumber = 100;

-- type=range：表示使用索引查询特定范围的数据记录。
-- rows=5411：表示需要读取的记录数。
-- possible_keys=index_trans：表示可以选择的索引是 index_trans。
-- key=index_trans：表示实际选择的索引是 index_trans。
-- extra=Using index condition;Using where;Using MRR：
-- 这里面的信息对 SQL 语句的执行细节做了进一步的解释，包含了 3 层含义：
-- 第一个是执行时使用了索引，第二个是执行时通过 WHERE 条件进行了筛选，
-- 第三个是使用了顺序磁盘读取的策略。

#移除数据表中的主键
alter table demo.mytrans drop primary key;

#开启事务
start transaction;
#在该表中插入数据
insert into demo.mytrans values(1,1,5);
select * from demo.mytrans;
#更新另外一个关联表的内容，设置invquantity 等于 invquantity 减去5当itemnumber =1 的时候
UPDATE demo.inventory SET invquantity = invquantity - 5 WHERE itemnumber = 1; 
#提交事务
commit;
select * from demo.inventory;

#删除数据
delete from demo.mytrans where transid = 1;

#怎么处理当储存过程中出现失败的时候决定提交事务还是回滚
#修改分隔符号为 //
DELIMITER // 
#创建存储过程
create procedure demo.mytest() 
#开始程序体
begin
#定义sql操作发送错误是自动回滚的 
declare exit handler for sqlexception rollback;
#开始事务
start transaction;
insert into demo.mytrans values(1,5);
update demo.inventory set invquantity = invquantity -5 ;
#提交事务
commit;
#完成创建存储过程
end //

DELIMITER ;
drop procedure demo.mytest ;
call demo.mytest();
select * from demo.mytrans;
select * from demo.inventory;

