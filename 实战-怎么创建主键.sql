#将数据表关联起来
select b.membername,c.goodsname,a.quantity,a.salesvalue,a.transdate
from demo.trans as a join demo.membermaster as b join demo.goodsmaster as c
on (a.cardno = b.cardno and a.itemnumber = c.itemnumber);

#删除数据表中的主键
alter table demo.membermaster drop primary key;
#添加新的一列，并且设置这一列为主键且自增约束
alter table demo.membermaster add id  int primary key auto_increment;
alter table demo.trans add memberid int;


 







