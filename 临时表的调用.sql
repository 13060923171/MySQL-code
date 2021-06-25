#create temporary table 表名( 字段名 字段类型);

create temporary table demo.mysales select itemnumber,sum(quantity) as quantity,sum(salesvalue) as salesvalue from
demo.transactiondetails group by itemnumber order by itemnumber;

select * from demo.mysales;

create temporary table demo.myimport select b.itemnumber,sum(b.quantity) as quantity,sum(b.importvalue) as importvalue
from demo.importhead a join demo.importdetails b on (a.listnumber = b.listnumber) group by b.itemnumber;

select * from demo.myimport;

create temporary table demo.myreturn select b.itemnumber,sum(b.quantity)as quantity,sum(b.importprice) as returnvalue
from demo.returnhead a join demo.returndetails b on (a.listnumber = b.listnumber) group by b.itemnumber;

select * from demo.myreturn;

#怎么把多个临时表放在一起进行查看
select a.itemnumber,a.goodsname,ifnull(b.quantity,0) as salesquantity, ifnull(c.quantity,0) as importquantity,ifnull(d.quantity,0) as returnquantity
from demo.goodsmaster a left join demo.mysales b on (a.itemnumber = b.itemnumber) left join demo.myimport c on (a.itemnumber = c.itemnumber)
left join demo.myreturn d on (a.itemnumber = d.itemnumber) having salesquantity > 0 or importquantity > 0 or returnquantity > 0;

#创建临时表数据存在内存中
create temporary table demo.mytrans(
	itemnumber int,
    groupnumber int,
    branchnumber int
)engine = MEMORY;

#创建临时表存在在磁盘中
create temporary table demo.mytransdisk(
	itemnumber int,
    groupnumber int,
    branchnumber int
);

#内存临时表，查询速度快，一旦断电，全部丢失，数据无法找回
#磁盘临时表，数据不易丢失，速度相对较慢
