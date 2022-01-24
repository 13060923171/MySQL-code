


--检查日期和时间是否在<正常>范围内
SELECT 
	MIN(createtime),
	MAX(createtime),
	MIN(DATEPART(HH,createtime)),
	MAX(DATEPART(HH,createtime))
FROM ad_test


--渠道属性
 select channel,count(distinct userid) as 用户数 
from ad_test
group by channel	
order by 用户数  desc

--用户行为属性(type=show才有cost，type=buy,才有amount )
 select type,count(distinct userid) as 用户数 
from ad_test
group by type

--用户自身属性
 select city,city_level,count(distinct userid) as 用户数 
from ad_test
group by city,city_level
order by 用户数  desc

--商品属性
select item_type,count(distinct userid) as 用户数 
from ad_test
group by item_type
order by 用户数  desc


步骤1，梳理找出目前已有的，所有的指标，保证处于一个数据底表
--宏观查询
SELECT 
	sum(amount) amount,
	round(sum(cost),2) cost,
	sum(case when  type='show' then 1 else 0 end) as  ad_show,
	sum(case when  type='click' then 1 else 0 end) as  ad_click,
	sum(case when  type='buy' then 1 else 0 end) as  ad_buy,
	Convert(decimal(18,2),sum(cost)/sum(case when  type='show' then 1 else 0 end)*1000) CPM,--千次曝光成本
	Convert(decimal(18,2),sum(cost)/sum(case when  type='click' then 1 else 0 end)) CPC,---点击成本
	cast(ROUND(sum(case when  type='click' then 1 else 0 end)*100/NULLIF(sum(case when  type='show' then 1 else 0 end),0),2) as varchar)+'%' AS CTR,
	cast(ROUND(sum(case when  type='buy' then 1 else 0 end)*100/NULLIF(sum(case when  type='click' then 1 else 0 end),0),2) as varchar)+'%' AS CVR,
	round(sum(cost)/sum(case when  type='buy' then 1 else 0 end),2) as  "订单成本" ,
	round(sum(amount)/sum(cost),2) ROI
FROM ad_test adt 
where substring(createtime,1,10) between '2020-12-01' and '2020-12-31' 


步骤2，进行数据剖析和可视化
步骤3，聚焦关键环节

分析已有维度。
外部因素：渠道，日期等
用户因素：地域，年龄，职业等
商品因素：商品价格，商品落地页链接样式，素材等

营收= 数量 * 线索转化率 * ARPU（客单价）

假设优先从曝光数量和转化率CTR入手

--不同渠道点击情况
SELECT 
	adt.channel, 
	sum(case when  type='show' then 1 else 0 end) as  ad_show,
	sum(case when  type='click' then 1 else 0 end) as  ad_click
FROM ad_test adt
GROUP BY channel
ORDER BY ad_show DESC


--不同渠道点击率
SELECT 
	adt.channel, 
	sum(case when  type='show' then 1 else 0 end) as  ad_show,
	sum(case when  type='click' then 1 else 0 end) as  ad_click,
	sum(case when  type='click' then 1 else 0 end)*1.0/sum(case when  type='show' then 1 else 0 end) ctr_1,
	cast(ROUND(sum(case when  type='click' then 1 else 0 end)*100/sum(case when  type='show' then 1 else 0 end),2) as varchar)+'%' AS ctr,
	round(sum(amount)/sum(cost),2) ROI,
	row_number() over(partition by 1 order by round(sum(amount)/sum(cost),2) desc) as r
FROM ad_test adt
GROUP BY channel
having  sum(case when  type='show' then 1 else 0 end)>1000
ORDER BY ad_show DESC	
--ORDER BY ROI DESC	


--不同日期点击率
SELECT 
	substring(createtime,1,10) days, 
	sum(case when  type='show' then 1 else 0 end) as  ad_show,
	sum(case when  type='click' then 1 else 0 end) as  ad_click,
	sum(case when  type='click' then 1 else 0 end)*1.0/sum(case when  type='show' then 1 else 0 end) ctr_1,
	---CONCAT(ROUND(sum(case when  type='click' then 1 else 0 end)*100/sum(case when  type='show' then 1 else 0 end),2),'%') AS ctr
	cast(ROUND(sum(case when  type='click' then 1 else 0 end)*100/sum(case when  type='show' then 1 else 0 end),2) as varchar)+'%' AS ctr
FROM ad_test adt
--where ad_id='创意素材02'
GROUP BY substring(createtime,1,10)
ORDER BY days DESC	

--不同小时点击率
SELECT 
	substring(createtime,12,2) hours, 
	sum(case when  type='show' then 1 else 0 end) as  ad_show,
	sum(case when  type='click' then 1 else 0 end) as  ad_click,
	sum(case when  type='click' then 1 else 0 end)*1.0/sum(case when  type='show' then 1 else 0 end) ctr_1,
	---CONCAT(ROUND(sum(case when  type='click' then 1 else 0 end)*100/sum(case when  type='show' then 1 else 0 end),2),'%') AS ctr
	cast(ROUND(sum(case when  type='click' then 1 else 0 end)*100/sum(case when  type='show' then 1 else 0 end),2) as varchar)+'%' AS ctr
FROM ad_test adt
GROUP BY substring(createtime,12,2)
ORDER BY hours	


---年龄属性
SELECT 
	coalesce(age,'总计') age,
	sum(case when  type='show' then 1 else 0 end) as  ad_show,
	sum(case when  type='click' then 1 else 0 end) as  ad_click,
	sum(case when  type='click' then 1 else 0 end)*1.0/sum(case when  type='show' then 1 else 0 end) ctr_1,
	---CONCAT(ROUND(sum(case when  type='click' then 1 else 0 end)*100/sum(case when  type='show' then 1 else 0 end),2),'%') AS ctr
	cast(ROUND(sum(case when  type='click' then 1 else 0 end)*100/sum(case when  type='show' then 1 else 0 end),2) as varchar)+'%' AS ctr
FROM ad_test adt
GROUP BY age
with rollup
ORDER BY age



--性别+用户属性
SELECT 
	COALESCE(sex,'总计') sex,
	COALESCE(user_type,'总计') user_type,
	sum(cost) "消耗",
	SUM(amount) "营收",
	sum(case when  type='show' then 1 else 0 end) "展示pv",
	sum(case when  type='click' then 1 else 0 end) "点击pv",
	sum(case when  type='buy' then 1 else 0 end) "购买pv",
	cast(ROUND(sum(case when  type='click' then 1 else 0 end)*100/sum(case when  type='show' then 1 else 0 end),2) as varchar)+'%' AS ctr

FROM ad_test adt
GROUP BY 	
	sex,
	user_type
with cube
ORDER BY "消耗" desc


--省份展示占比
select 
	*,
	cast(Convert(decimal(18,2),ad_show*100/sum(ad_show) over(partition by 1)) as varchar)+'%' as "展示占比"
from (
			SELECT 
				province,
				sum(case when  type='show' then 1 else 0 end) as  ad_show,
				sum(case when  type='click' then 1 else 0 end) as  ad_click,
				sum(case when  type='click' then 1 else 0 end)*1.0/sum(case when  type='show' then 1 else 0 end) ctr_1,
				---CONCAT(ROUND(sum(case when  type='click' then 1 else 0 end)*100/sum(case when  type='show' then 1 else 0 end),2),'%') AS ctr
				cast(ROUND(sum(case when  type='click' then 1 else 0 end)*100/sum(case when  type='show' then 1 else 0 end),2) as varchar)+'%' AS ctr
			FROM ad_test adt
			GROUP BY province
			)a1
ORDER BY ad_show*100/sum(ad_show) over(partition by 1) desc



---职业属性
SELECT 
	profession,
	sum(case when  type='show' then 1 else 0 end) as  ad_show,
	sum(case when  type='click' then 1 else 0 end) as  ad_click,
	sum(case when  type='click' then 1 else 0 end)*1.0/sum(case when  type='show' then 1 else 0 end) ctr_1,
	---CONCAT(ROUND(sum(case when  type='click' then 1 else 0 end)*100/sum(case when  type='show' then 1 else 0 end),2),'%') AS ctr
	cast(ROUND(sum(case when  type='click' then 1 else 0 end)*100/sum(case when  type='show' then 1 else 0 end),2) as varchar)+'%' AS ctr
FROM ad_test adt
GROUP BY profession
ORDER BY ad_show	desc



---商品属性
SELECT 
	item_type,ad_id,
	sum(case when  type='show' then 1 else 0 end) as  ad_show,
	sum(case when  type='click' then 1 else 0 end) as  ad_click,
	--sum(case when  type='click' then 1 else 0 end)*1.0/sum(case when  type='show' then 1 else 0 end) ctr_1,
	---CONCAT(ROUND(sum(case when  type='click' then 1 else 0 end)*100/sum(case when  type='show' then 1 else 0 end),2),'%') AS ctr
	cast(ROUND(sum(case when  type='click' then 1 else 0 end)*100/NULLIF(sum(case when  type='show' then 1 else 0 end),0),2) as varchar)+'%' AS ctr
FROM ad_test adt
GROUP BY item_type,ad_id
ORDER BY ad_show	desc	



---词云图城市营收
SELECT 
	city,
	sum(amount) "营收"
FROM ad_test adt
GROUP BY city
ORDER BY "营收" desc






---小时与年龄的花费占比[交叉分析]

select 
	*,
	sum(cost) over(partition by age) as cost_all,
	cast(ROUND(cost*100/sum(cost) over(partition by age),2) as varchar)+'%' AS per
from(
			SELECT 
				substring(createtime,12,2) hours,
				age,
				sum(cost) cost
			FROM ad_test adt
			group by 
				substring(createtime,12,2),
				age
			)a
	order by age,hours

---对比分析
select 
		channel,
		sum(case when  substring(createtime,1,10) between '2020-12-01' and '2020-12-31' and type='buy' then 1 else null end) as "12月购买订单",
		sum(case when  substring(createtime,1,10) between '2020-11-01' and '2020-11-30' and type='buy' then 1 else null end) as "11月购买订单"
FROM ad_test adt
group by 
		channel
order by "12月购买订单" desc




--用户漏斗模型
SELECT 
	sum(cost) cost,
	SUM(amount) amount,
	sum(case when  type='show' then 1 else 0 end) show,
	sum(case when  type='click' then 1 else 0 end) click,
	sum(case when  type='buy' then 1 else 0 end) buy
FROM ad_test adt


SELECT 
	type,
	count(*) "计数"
FROM ad_test adt
group by type
order by  "计数" desc




---复购率
SELECT 
	buy_times,
	COUNT(*) AS '人数' 
FROM (
			SELECT 
				COUNT(userid) AS buy_times 
			FROM ad_test
			WHERE type='buy'
			GROUP BY userid
			)a
GROUP BY buy_times
ORDER BY buy_times DESC



--abtest 
SELECT 
	type,
	count(case when  abtest=1 then 1 else null end) as  "abtest1",
	count(case when  abtest=2 then 1 else null end) as  "abtest2"
FROM ad_test adt
group by type
order by type desc









---算CTR和CVR
--CVR是点击/曝光，主要考虑投放的展示内容，文案，广告图等优化
--CTR是购买数/点击数  主要考核点进去后落地页的优化内容
--注意除数为0
--限制某个范围内
			SELECT 
				city,
				sum(case when  type='show' then 1 else 0 end) as  "曝光",
				sum(case when  type='click' then 1 else 0 end) as  "点击",
				sum(cost) "花费",
				Convert(decimal(18,2),sum(cost)/sum(case when  type='show' then 1 else 0 end)*1000) CPM,--千次曝光成本
				Convert(decimal(18,2),sum(cost)/sum(case when  type='click' then 1 else 0 end)) CPC,---点击成本
				sum(case when  type='buy' then 1 else 0 end) as  "购买",
				cast(ROUND(sum(case when  type='click' then 1 else 0 end)*100/NULLIF(sum(case when  type='show' then 1 else 0 end),0),2) as varchar)+'%' AS CTR,
				cast(ROUND(sum(case when  type='buy' then 1 else 0 end)*100/NULLIF(sum(case when  type='click' then 1 else 0 end),0),2) as varchar)+'%' AS CVR,
				sum(amount) "营收",
				round(sum(cost)/sum(case when  type='buy' then 1 else 0 end),2) as  "订单成本" 
			FROM ad_test adt
			GROUP BY city
			having sum(case when  type='show' then 1 else 0 end)>5000
			ORDER BY sum(case when  type='buy' then 1 else 0 end)*100/NULLIF(sum(case when  type='click' then 1 else 0 end),0) desc





