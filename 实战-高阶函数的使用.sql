#where的使用规则，就是在确定的表中用where给定一个值去调用该方法，
#sql语句就会根据where设置的条件进行判断,distinct这个函数的作用是返回唯一不同的值
select distinct b.goodsname from demo.transactiondetails as a join demo.goodsmaster
as b on (a.itemnumber = b.itemnumber) where a.salesvalue > 50;

#having是不能单独使用的，必须和group by 一起使用，group by的作用就是对数据进行分组
#having的查询过程，就是将准备好的信息，先对它们进行分组，然后形成一个包含所有信息
#的数据集合，再对这个集合进行条件筛选，最后得到我们需要的数据
select b.goodsname from demo.transactiondetails as a join demo.goodsmaster as b
on(a.itemnumber = b.itemnumber) group by b.goodsname having max(a.salesvalue) > 50;

#这两个方法在什么时候好呢，如果只是小的查询或者简单的查询，我们可以用where,
#如果是较为复杂的查询，或者要使用一些计算函数才能查询到结果的那么我们就可以使用having


#sum函数的作用就是去计算某个值的总和
#left(str,n)表示左边字符串的n位字符
select left(b.trasdate,10),c.goodsname,sum(a.quantity),sum(a.salesvalue) 
from demo.transactiondetails a join demo.transactionhead b 
on (a.transactionid = b.transactionid) join demo.goodsmaster c 
on (a.itemnumber= c.itemnumber) group by left(b.trasdate,10) ,
c.goodsname order by left(b.trasdate,10),c.goodsname;

#avg就是通过计算分组内的指定字段值的和，以及分组内的记录数，算出分组内指定字段的平均值
select left(a.trasdate,10),c.goodsname,avg(b.quantity),avg(b.salesvalue)
 from demo.transactionhead a join demo.transactiondetails b 
 on (a.transactionid = b.transactionid) join demo.goodsmaster c 
 on (b.itemnumber = c.itemnumber) group by left(a.trasdate,10),
 c.goodsname order by left(a.trasdate,10),c.goodsname;
 
 #max和min则是分别计算分组中的最大值和最小值
 select left(a.trasdate,10),max(b.quantity),max(b.salesvalue) 
 from demo.transactionhead a join demo.transactiondetails b 
 on (a.transactionid = b.transactionid) join demo.goodsmaster c 
 on (b.itemnumber = c.itemnumber) group by left(a.trasdate,10) order by left(a.trasdate,10);

#count就是统计函数，计算这个数据表中的有多少条记录
select count(*) from demo.transactiondetails;


#extract（type from date）表示从日期时间数据'date'中抽取'type'指定的部分。
select extract(hour from b.trasdate) as 时段,sum(a.quantity) as 数量,
sum(a.salesvalue) as 金额 from demo.transactiondetails a join demo.transactionhead b 
on (a.transactionid = b.transactionid) group by extract(hour from b.trasdate) 
order by extract(hour from b.trasdate);

-- YEAR（date）：获取 date 中的年。
-- MONTH（date）：获取 date 中的月。
-- DAY（date）：获取 date 中的日。
-- HOUR（date）：获取 date 中的小时。
-- MINUTE（date）：获取 date 中的分。
-- SECOND（date）：获取 date 中的秒。

#date_add(data,interval表达式type),具体使用参考如下：↓
select date_add('2020-12-10',interval - 1 year);
#日期减一年再减一个月
select date_add(date_add('2020-12-10',interval - 1 year),interval - 1 month);
#last_day表示获取日期时间所在月份的最后一天的日期
select last_day(date_add(date_add('2020-12-10',interval - 1 year),interval - 1 month));
#获取日期的前一年的最后一个月的第一天
select date_add(last_day(date_add(date_add('2020-12-10',interval - 1 year),interval - 1 month)),interval  1 day);
#获取日期时间的该年的第一天
select date_add(last_day(date_add('2020-12-10',interval -1 year)),interval 1 day);
#获取时间按照小时
select date_format('2020-12-01 13:25:50','%T');
#获取时间，按照下午的时间来划分
select date_format('2020-12-01 13:25:50','%r');
#获取一个时间段的天数
select datediff('2021-02-01','2020-12-01');
#用英文来表达该时间的表达式
select date_format('2021-04-13','%W %M %Y');

#选取多个数据表的内容，用关联查询，获取会员的消费信息
select c.membername as '会员',b.transactionno as '单号',b.trasdate as '交易时间',
d.goodsname as '商品名称',a.salesvalue as '交易金额' from 
demo.transactiondetails a join demo.transactionhead b 
on (a.transactionid = b.transactionid) join demo.membermaster c 
on (b.memberid = c.memberid) join demo.goodsmaster d on (a.itemnumber = d.itemnumber);

#如果是向上的话，用的是ceil()
#用floor对选定的值进行向下取整，获取会员的积分值
select c.membername as '会员',b.transactionno as '单号',b.trasdate as '交易时间',
d.goodsname as '商品名称',a.salesvalue as '交易金额',floor(a.salesvalue)as '积分'
from demo.transactiondetails a join demo.transactionhead b 
on (a.transactionid = b.transactionid) join demo.membermaster c 
on (b.memberid = c.memberid) join demo.goodsmaster d ON (a.itemnumber = d.itemnumber);

#怎么对某个值进行四舍五入，就是用到round（salesvalue，2）
#其中salevalue指的是你要进行操作的值，2指的是后面的小数点
select round(salesvalue,2) from demo.transactiondetails where transactionid = 1
and itemnumber = 1;


#concat就是把两个东西拼接起来
select concat(goodsname, "(",specification, ")" ) as '商品信息' from demo.goodsmaster; 

#cast就是把quantity这个值转化为字符串
select cast(quantity as char) from demo.transactiondetails where 
transactionid = 1 and itemnumber =1 ;

#char_length就是计算长度
select char_length(cast(quantity as char)) as '长度' from demo.transactiondetails 
where transactionid = 1 and itemnumber =1 ;

#先把内容类型进行转化，然后再用指定的空格，将这些内容拼接一起，使得内容看起来整齐美观
select concat(cast(quantity as char), space( 7 - char_length(cast(quantity as char)))) 
as 数量 from demo.transactiondetails where transactionid = 1 and itemnumber = 1 ;

#ifnull(specification,'')这个指的是对specification进行判断，
#然后specification为空，那么放回空的字符串
select goodsname,specification,concat(goodsname,'(',ifnull(specification,''),')') 
as '拼接' from demo.goodsmaster;

#if(isnull(specification),goodsname,concat(goodsname,'(',specification,')')),
#这里isnull(specification)指的是表达式，如果isnull为空，那么返回goodsname,
#如果不为空，那么返回拼接好的格式
select goodsname,specification,if(isnull(specification),
goodsname,concat(goodsname,'(',specification,')')) as '拼接' from demo.goodsmaster;