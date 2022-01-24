

-单列分组
SELECT 
	sex, 
	avg(amount), SUM(amount),max(amount), min(amount), count(*)
FROM ad_test1_20000
GROUP by  rollup(sex)
order by sex

-双列分组
SELECT 
	sex,user_type,
	avg(amount), SUM(amount),max(amount), min(amount), count(*)
FROM ad_test1_20000
GROUP by  rollup(sex,user_type)
order by sex,user_type

-双列分组【按cube】
SELECT 
	sex,user_type,
	avg(amount), SUM(amount),max(amount), min(amount), count(*)
FROM ad_test1_20000
GROUP by  cube(sex,user_type)
order by sex,user_type


-双列分组【按cube】，使用coalesce函数
SELECT 
	coalesce(sex,'所有性别') sex,
	coalesce(user_type,'所有类型') user_type, 
	avg(amount), SUM(amount),max(amount), min(amount), count(*)
FROM ad_test1_20000
GROUP by  cube(sex,user_type)
order by sex,user_type


双列分组【按自定义函数 GROUPING SETS 】

GROUP by  sex,user_type 等价于
GROUP BY GROUPING SETS ((sex, user_type))

GROUP by  rollup(sex,user_type)等价于
GROUP BY GROUPING SETS ((sex, user_type), (sex), ())

GROUP by  cube(sex,user_type)等价于
GROUP BY GROUPING SETS ((sex, user_type), (sex),(user_type) ())


举例：
SELECT 
	sex,user_type,
	avg(amount), SUM(amount),max(amount), min(amount), count(*)
FROM ad_test1_20000
GROUP BY GROUPING SETS ((sex, user_type), (sex), ())


比如我们只想取两列的总计：
SELECT 
	sex,user_type,age,
	avg(amount), SUM(amount),max(amount), min(amount), count(*)
FROM ad_test1_20000
GROUP BY GROUPING SETS ((sex, user_type,age), ())



---数据透视表的行列维度转化

SELECT 
	coalesce(sex,'总计') sex,
	sum(case when  user_type='老' then amount else null end) as "老",
	sum(case when  user_type='新' then amount else null end) as "新",
	sum(amount) "总计"
FROM ad_test1_20000
GROUP BY rollup(sex) 



---2.转化函数（sql server注意采坑）

---注意转化函数的除法问题

select 3/2
select cast(3 as float)/2
select 3*1.0/2
select cast(3*1.0/2   AS decimal(9,2))

--计算百分比
select cast(cast(3*100.0/2 AS decimal(9,1)) as varchar)+'%'


---回到sql


4.窗口函数【mysql不支持 partition by】
--排名函数与排序函数的区别

 排序函数： order by（默认asc升序，指定desc降序）
			例如将表格数据按照考试成绩从低到高排序。

排名函数： rank, dense_rank, row_number，将某个(或多个)列进行排名
row_number:   【相同结果，不同排名】。根据排序生成连续的序列号，1,2,3,4,5,【常用，可用于数值去重】
rank： 				【相同结果相同排名，】。第一名100分，第2,3名并列99分，98分的同学排名第四。
dense_rank:   【相同结果相同排名,后者继续排序】。 第一名100分，第2，3名并列99分，98分的同学排名第三。


--PS.注意，窗口函数和group by 函数不能应用在同个语句里


对不同渠道的金额进行排名
SELECT 
	channel, 
	sum(amount) amount
	--,row_number() over(partition by channel order by amount desc) as r
FROM ad_test1_20000
GROUP BY channel
union all
select '微信朋友圈',1800-- 假设有相同的营收渠道
order by amount desc




---对渠道进行排名，三者的区别
select 
	*,
	row_number() over(order by amount desc) as r1,
	rank() over(order by amount desc) as r2,
	dense_rank() over(order by amount desc) as r3
	from (
			SELECT 
				channel, 
				sum(amount) amount
			FROM ad_test1_20000
			GROUP BY channel
			union all
			select '微信朋友圈',1800 -- 假设有相同的营收渠道
			) a
	order by amount desc



SELECT 
	 sex,channel,
	sum(amount) amount
FROM ad_test1_20000
GROUP BY channel,sex
HAVING avg(amount) > 500
order by amount desc


--对整体进行排名,partition by ,进行分组求和占比，比如求男女的渠道付费排名，以及付费占比
SELECT
	sex,
	channel,
	amount,
	row_number() over(partition by sex order by amount desc) as r1,--分组对男女，按金额进行排名
  sum(amount) over(partition by sex) as r2,---分组男女的分别总金额进行汇总
	avg(amount) over(partition by sex) as r3,
	cast(cast(amount/NULLIF(sum(amount) over(partition by sex),0)*100 AS decimal(9,1)) as varchar)+'%' --求男女百分比
	--first_values(amount) over(partition by sex order by amount desc) as r4 --取最大值，算差异
  --last_values(amount) over(partition by sex order by amount desc) as r5--取最小值，算差异
	--lag(amount,1,-1) over(partition by sex order by amount desc) as r6 --计算环比增长
 --lead(amount,1,-1) over(partition by sex order by amount desc) as r7--计算环比增长
FROM 	(
		SELECT 
				channel, sex,
				sum(amount) amount
		FROM ad_test1_20000
		GROUP BY channel,sex
		HAVING avg(amount) > 500) a
order by sex,r1


--总结聚合函数



select table_schema,table_name from information_schema.columns where column_name = 'city'

【WITH 子句】
with aa as ( 
		SELECT 
				channel, sex,
				sum(amount) amount
		FROM ad_test1_20000
		GROUP BY channel,sex
		HAVING avg(amount) > 500)

select * from aa 





-----------案例操作
问题2
发现得分表中“赵兰”的语文成绩实际上是“赵云”的，请对得分表进行改正，
并在得分表新增一个列（row_scores），用来统计每个用户的学科排名情况

select 
	* ,
	row_number()over(partition by subject order by scores desc) as row_scores
from (
		select 
			case when name = '赵兰' then '赵云' else name end as name,
			subject,
			teacher_id,
			scores
    from scores_table
			) a
order by subject,row_scores







