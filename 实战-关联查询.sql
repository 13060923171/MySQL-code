
select constraint_name,table_name,column_name,referenced_table_name,referenced_column_name
from information_schema.key_column_usage where constraint_name ='fk_importdetails_importhead';

#这个内连接，将两个表关联起来，然后通过共同的字段找出，查询自己需要的内容，生成一个新的表
select a.transactionnumber,a.itemnumber,a.quantity,a.price,a.transdate,b.membername 
from demo.trans as a join demo.membermaster as b on (a.cardno = b.cardno);

#这个是外连接中的左连接，和内连接的区别就是，会返回左边表的所有记录，
#以及右表中符合连接的条件记录，右连接和左连接的写法一样，只是要把left改成right
select a.transactionnumber,a.itemnumber,a.quantity,a.price,a.transdate,b.membername
from demo.trans as a left join demo.membermaster as b on (a.cardno = b.cardno);

