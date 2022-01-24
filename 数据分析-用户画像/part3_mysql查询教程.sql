---mysql基础语法：

SELECT columns_name       --查找一列或多列，多列之间用逗号隔开
FROM Table                --目标表
WHERE condition           --过滤条件
GROUP BY columns_name     --按列值分组，可以1个或多个列
HAVING condition          --分组后的筛选条件，HAVING与WHERE区别在于前者表达式中可包含函数
ORDER BY columns_name     --按列排序
LIMIT  row_count    --对结果进行限定

技巧：可以在输入法存储快捷方式




--Having语句,筛选平均购买金额大于500元的渠道
SELECT 
	channel, avg(amount), max(amount), min(amount), count(*)
FROM ad_test1_20000
GROUP BY channel
HAVING avg(amount) > 500


---on和where的区别
select 
	t1.*,t2.* 
from scores_table  t1
left join teacher_table t2
	on t1.teacher_id=t2.teacher_id and t1.subject=t2.subject
		#and t2.teacher_id=1001
where t2.teacher_id=1001
order by  t1.id



---1.聚合函数

SELECT 
	sex,user_type, 
	avg(amount), SUM(amount),max(amount), min(amount), count(*)
FROM ad_test1_20000
GROUP by  sex,user_type

---使用 ROLLUP【mysql,oracle,sql server,postgresql都适用】即【添加总计,从下往上】
SELECT 
	sex, 
	avg(amount), SUM(amount),max(amount), min(amount), count(*)
FROM ad_test1_20000
GROUP by  sex
with rollup


-----对两个列进行分组效果
SELECT 
	sex,user_type,
	avg(amount), SUM(amount),max(amount), min(amount), count(*)
FROM ad_test1_20000
GROUP by  sex,user_type
with rollup



---2.转化函数（sql server注意采坑）


---3.日期和时间函数

SELECT  current_date() as now,

# 日期的时间差
SELECT 
	date_add('2020-12-31',interval -1 day) as yesterday, 
	DATEDIFF('2020-12-31','2020-12-30') as diff,
	STR_TO_DATE('2020-01-01','%Y-%m-%d') as strdate1,
	STR_TO_DATE('2020.01.01','%Y.%m.%d') as strdate2


## 日期转化为时间戳 ##
select 
unix_timestamp('2020-01-01 12:00:00')


## 时间戳转化为日期 ##  时间戳，即从1970年8点开始算起，按秒
select from_unixtime (0) 
select from_unixtime (1577851200) 

##时间转化函数，主要用来对日期进行分组统计计算
select 
date('2020-01-01 12:00:00'),
month('2020-01-01 12:00:00'),
year('2020-01-01 12:00:00'),
week('2020-01-01 12:00:00'),	#--第几周
weekday('2020-01-01 12:00:00'),#--周几
substr('2020-01-01 12:00:00',1,10) ,
substr('2020-01-01 12:00:00',1,7) ,
substr('2020-01-01 12:00:00',1,4)



SELECT 
substring('中国浙江省杭州市',3,3)  AS province,
instr ('中国浙江省杭州市' , '杭州市')  AS index_city



 4字符串函数
#字符拆分
select
	substring('广东省广州市天河区', 7),  #返回字符串从start位置到结尾的字符串##
	substring('素材创意01文案10', 1,6), #返回字符串A从start位置开始，长度为len的字符串
	left('广东省广州市天河区',2)  AS province,
	right('广东省广州市天河区',3)  AS area,
  insert('广东省广州市天河区',4,3,'珠海市')  AS replace_city,
	replace('广东省广州市天河区','广州市','珠海市')  AS replace_city
limit 10

#字符合并
select
	province,
	city,
	concat(province,'省',city,'市'),  #返回字符串从start位置到结尾的字符串##
	concat_ws('_', province,city,user_type) #返回字符串A从start位置开始，长度为len的字符串
FROM ad_test1_20000
limit 10

#带有广和西的省份
select
	distinct province
FROM ad_test1_20000
where province regexp('广|西')

#开头带有广和西的省份
select
	distinct province
FROM ad_test1_20000
where province regexp('^广|^西')
#结尾带有广和西的省份
select
	distinct province
FROM ad_test1_20000
where province regexp('广$|西$')

#0~5结尾的创意素材
select
	distinct ad_id
FROM ad_test1_20000
where ad_id regexp('[0-5]$')

#素材+[任意一个字符]+0，【有且只有一个】
select
	distinct ad_id
FROM ad_test1_20000
where ad_id regexp('素材.0') 

#素材+[任意一个字符]+这个字符可以不存在，或者多个字符 +0，【字符可以没有，或者多个】
select
	distinct ad_id
FROM ad_test1_20000
where ad_id regexp('素材.*0') 
#素材+[任意一个字符]+这个字符可以是多个字符 +0   【字符必须要有，可以是一个或者多个】
select
	distinct ad_id
FROM ad_test1_20000
where ad_id regexp('素材.+0') 



---字符串解析,配合正职表达式【网络爬虫进行抓取】

--6.加密函数
SELECT MD5('123456')#按md5模式加密,不可逆
SELECT SHA('123456');#按sha256模式加密,不可逆

SELECT AES_ENCRYPT('123456','8888');#加密，可逆
SELECT AES_DECRYPT(AES_ENCRYPT('123456','8888'),'7777'); #解密，可逆，密码错误
SELECT AES_DECRYPT(AES_ENCRYPT('123456','8888'),'8888');#解密，可逆，密码正确


SELECT ENCODE('123456','8888');#加密，可逆
SELECT DECODE(ENCODE('123456','8888'),'7777'); #解密，可逆，密码错误
SELECT DECODE(ENCODE('123456','8888'),'8888');#解密，可逆，密码正确


7.其他函数

--coalesce函数：
select COALESCE('abc', null,'dd',null), COALESCE(null, null,'dd',null)

---case 函数：

SELECT 
	channel, 
	(case when  avg(amount)>500 then '优质渠道'  when  avg(amount)>300 then '中等渠道' else '较差渠道' end) AS type,
	avg(amount), max(amount), min(amount), count(*)
FROM ad_test1_20000
GROUP BY channel

--组合函数
union 和union all

--随机抽样
select rand()

--查询列名在某个表
information_schema.columns
select table_schema,table_name from information_schema.columns where column_name = 'city'  


【WITH 语句】mysql不支持

-----------案例操作

问题1：
1.计算各个老师所教学生得分的最大值、最小值、每位老师所教的全部科目(此列为数组)，
ps（要求没有学生成绩的老师得分显示为空)

select 
    t1.teacher_id ,
    max(t2.scores) max_scores ,
    min(t2.scores) min_scores,
    group_concat(distinct t1.subject) as subjects 
from
teacher_table t1 
left join scores_table t2
on t1.teacher_id =t2.teacher_id
group by teacher_id


问题3
计算名字姓“王”的学生在全部学生中的占比（保留两位小数，用%表示）以及90分以上的人数；

select 
	count(distinct case when substr(name,1,1)='王'then name else null end )/count(distinct name) as "王姓占比",
  count(distinct case when scores >90 then name else null end )/count(distinct name) as "90分以上的人数"
from scores_table

问题4
province_1	（要求:把province列的"省"和"市"删除）	
address	（要求:合并province_1和city的字符串，且中间用'-'隔开,如果两列字符串相同，则无需合并。）	
type	 (要求：手机尾号后三位，大于500，定义为1，小于500定义为2，空值定义为3）	


select *,
	replace(replace(province,'市',''),'省','')  as province_1,
	case when replace(replace(province,'市',''),'省','')=city then city 
		else concat(replace(replace(province,'市',''),'省',''),'-',city) end as address,
	case when mobile is null then 3 when  cast(substr(mobile,-3) as SIGNED)<500 then 2 else 1 end  as type
from user_ip


问题5
统计手机尾号不等于000的所有用户（包括null），其每个用户的总成绩得分。(Name+scores)
select 
	a.name,
	coalesce(b.scores,0) as scores
from
	(select name from user_ip where substr(mobile,-3) !='000' or mobile is null) a
left join 
 (select name ,sum(scores) as scores from scores_table group by name)b
  on a.name=b.name











