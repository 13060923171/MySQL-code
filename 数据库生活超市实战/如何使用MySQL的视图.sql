#create [or replace] view 视图名称[(字段列表)] as 查询语句
select a.transdate,a.itemnumber,a.goodsname,a.quantity,b.invquantity from
(select a.transdate,a.itemnumber,b.goodsname,sum(a.quantity)as quantity,sum(a.salesvalue)as salesvalue from demo.trans as a left
join demo.goodsmaster as b on (a.itemnumber = b.itemnumber) group by a.transdate, a.itemnumber ) as a left join demo.inventory as b
on (a.transdate = b.invdate and a.itemnumber = b.itemnumber);


#怎么创建视图
create view demo.trans_goodsmaster as select a.transdate,a.itemnumber,b.goodsname,sum(a.quantity)as quantity,
sum(a.price) as salesvalue from demo.trans as a left join demo.goodsmaster as b on (a.itemnumber = b.itemnumber) group by a.transdate,a.itemnumber;

#从视图中进行查询
select * from demo.trans_goodsmaster;

#将每日单品销售的数据和当日的库存数量的对比
select a.transdate,a.itemnumber,a.goodsname,a.quantity,b.invquantity from demo.trans_goodsmaster as a left join demo.inventoryhist as b on(a.transdate = b.invdate and a.itemnumber = b.itemnumber);

#修改视图 alter view 视图名 as 查询语句;
#查看视图 describe 视图名;
#删除视图 drop view 视图名;

#怎么修改视图
alter view demo.trans_goodsmaster as select itemnumber,barcode,goodsname,salesprice from demo.goodsmaster where salesprice > 50;

#怎么在视图中插入数据
insert into demo.trans_goodsmaster(itemnumber,barcode,goodsname,salesprice) values(5,'0005','测试',100);

#怎么在视图中删除数据
select * from demo.trans_goodsmaster;

#怎么修改视图中的数据，这里有一点，当你对视图的数据进行修改的时候，相关的数据表也会跟着一起修改，所以不建议对视图的数据进行更新操作
delete from demo.trans_goodsmaster where itemnumber = 5;

update demo.trans_goodsmaster set salesprice = 100 where itemnumber =1 ;