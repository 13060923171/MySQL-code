select * from demo.transactiondetails;

select * from demo.transactionhead;
#怎么修改数据库中的列名称
alter table demo.transactionhead change trasdate  transdate datetime;

alter table demo.goodsmaster add avgimportprice decimal;
select * from demo.goodsmaster;

update demo.goodsmaster set avgimportprice = 11 where itemnumber = 3;


-- 第一步，我们把 SQL 语句的分隔符改为“//”。因为存储过程中包含很多 SQL 语句，如果不修改分隔符的话，MySQL 会在读到第一个 SQL 语句的分隔符“;”的时候，认为语句结束并且执行，这样就会导致错误。
-- 第二步，我们来创建存储过程，把要处理的日期作为一个参数传入（关于参数，下面我会具体讲述）。同时，用 BEGIN 和 END 关键字把存储过程中的 SQL 语句包裹起来，形成存储过程的程序体。
-- 第三步，在程序体中，先定义 2 个数据类型为 DATETIME 的变量，用来记录要计算数据的起始时间和截止时间。
-- 第四步，删除保存结果数据的单品统计表中相同时间段的数据，目的是防止数据重复。
-- 第五步，计算起始时间和截止时间内单品的销售数量合计、销售金额合计、成本合计、毛利和毛利率，并且把结果存储到单品统计表中。
delimiter //
create procedure demo.dailyoperation(transdate text)
begin
declare startdate,enddate datetime;
set startdate = date_format(transdate,'%Y-%m-%d');
set enddate = date_add(startdate,interval 1 day);
delete from demo.dailystatistics
where 
salesdate =  startdate;
insert into dailstatistics(
	salesdate,
    itemnumber,
    quantity,
    actualvalue,
    cost,
    profit,
    profitratio
)
select left(b.transdate,10),
a.itemnumber,sum(a.quantity),sum(a.salesvalue),sum(a.quantity*c.avgimportprice),
sum(a.salesvalue-a.quantity*c.avgimportprice),case sum(a.salesvalue) when 0 then 0 else round(sum(a.salevalue-a.quantity*c.avgimportprice)/sum(a.salesvalue),4) end from
demo.transactiondetails as a join demo.transactionhead as b on(a.transactionid = b.transactionid) join demo.goodsmaster c on (a.itemnumber = c.itemnumber) where
b.transdate>startdate and b.transdate<enddate group by
left(b.transdate,10),a.itemnumber order by left(b.transdate,10),a.itemnumber;
end
//

delimiter ;
drop table demo.dailyoperation;
show create procedure demo.dailyoperation;

call demo.dailyoperation('2020-12-01');
