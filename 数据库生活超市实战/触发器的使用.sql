#怎么创建触发器
#表名：表示触发器监控的对象
#insert\update\delete:表示触发器的事件。insert表示插入记录时触发;update表示更新记录时触发;delete表示删除记录时触发
#defore\after 表示触发的时间。before 表示在事件之前触发，after表示在事件之后触发
-- create trigger 触发器名称 {BEFORE|AFTER} {INSERT|UPDATE|DELETE}
-- on 表名 for each row 表达式;

#查看触发器
#show triggers\G;
#删除触发器
drop trigger 触发器名称;


select memberdeposit from demo.membermaster where memberid=1;

update demo.membermaster set memberdeposit = memberdeposit + 1 where memberid=1;

select memberdeposit from demo.membermaster where memberid = 1;

select * from demo.deposithist;

insert into demo.deposithist(
	id,
	memberid,
    transdate,
    oldvalue,
    newvalue,
    changedvalue
)
select 1,2,now(),0,150,+150;


create table demo.deposithist(
	id int primary key,
    memberid int,
    transdate datetime,
    oldvalue decimal(10,2),
    newvalue decimal(10,2),
    changedvalue decimal(10,2)
);

#触发器的实际应用

delimiter //
create trigger demo.upd_membermaster before update
on demo.membermaster for each row 
begin
if (new.memberdeposit <> old.memberdeposit)
then
insert into demo.deposithist(
	memberid,
    transdate,
    oldvalue,
    changedvalue
)
select new.memberid,now(),old.memberdeposit,new.memberdeposit,new.memberdeposit-old.memberdeposit;
end if;
end 
//
delimiter ;


SHOW TRIGGERS;
alter table demo.deposithist drop primary key;
update demo.membermaster set memberdeposit = memberdeposit + 10 where memberid = 1 ;

#查看触发器是否执行成功
select row_count();