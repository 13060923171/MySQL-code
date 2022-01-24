



--R
select 
	recency,
	count(*) "用户数"
from (
			select 
				[user],
				max(DATEDIFF(d,pay_day,'2020-12-31')) recency,
				count(*) frequency,
				sum(cast(pay_amount as int))  monetary
			from RFM_test 
			group by [user]
			)a
group by recency
order by recency


--F
select 
	frequency,
	count(*) "用户数"
from (
			select 
				[user],
				max(DATEDIFF(d,pay_day,'2020-12-31')) recency,
				count(*) frequency,
				sum(cast(pay_amount as int))  monetary
			from RFM_test 
			group by [user]
			)a
group by frequency
order by frequency


--M
select 
	monetary,
	count(*) "用户数"
from (
			select 
				[user],
				max(DATEDIFF(d,pay_day,'2020-12-31')) recency,
				count(*) frequency,
				sum(cast(pay_amount as int))  monetary
			from RFM_test 
			group by [user]
			)a
group by monetary
order by monetary



求均值
with t as ( 
			select *,
				(case 
						when  recency<150  then 5 
						when  recency between 150 and 299  then 4 
						when  recency between 300 and 449  then 3 
						when  recency between 450 and 599  then 2 
						when  recency>=600  then 1 
				else null end) as recency_p,

			(case 
						when  frequency=1  then 1 
						when  frequency=2 then 2 
						when  frequency between 3 and 10   then 3 
						when  frequency between 11 and 17 then 4
						when  frequency>=18  then 5 
				else null end) as frequency_p,

			(case 
						when  monetary<50   then 1 
						when  monetary between 50 and 99 then 2 
						when  monetary between 100 and 499   then 3 
						when  monetary between 500 and 4999 then 4
						when  monetary>=5000  then 5 
				else null end) as monetary_p


			from (
						select
							[user],
							max(DATEDIFF(d,pay_day,'2020-12-31')) recency,
							count(*) frequency,
							sum(cast(pay_amount as int))  monetary
						 from RFM_test 
						group by [user]
						) a
)

select avg(recency_p*1.0), avg(frequency_p*1.0), avg(monetary_p*1.0)  from t





----最终脚本

最近一次消费 (Recency)：
	A类: 大于平均值
	B类：小于平均值

消费频次(Frequency)：
	A类：大于平均值
	B类：小于平均值

消费金额(Monetary):
	A类：大于平均值
	B类：小于平均值

1.AAA 重要价值用户
2.ABA 重要发展用户
3.BAA 重要保持用户
4.BBA 重要挽留用户
5.AAB 一般价值用户
6.ABB 一般发展用户
7.BAB 一般保持用户
8.BBB 一般挽留用户


with t as ( 
			select *,
				(case 
						when  recency<150  then 5 
						when  recency between 150 and 299  then 4 
						when  recency between 300 and 449  then 3 
						when  recency between 450 and 599  then 2 
						when  recency>=600  then 1 
				else null end) as recency_p,

			(case 
						when  frequency=1  then 1 
						when  frequency=2 then 2 
						when  frequency between 3 and 10   then 3 
						when  frequency between 11 and 17 then 4
						when  frequency>=18  then 5 
				else null end) as frequency_p,

			(case 
						when  monetary<50   then 1 
						when  monetary between 50 and 99 then 2 
						when  monetary between 100 and 499   then 3 
						when  monetary between 500 and 4999 then 4
						when  monetary>=5000  then 5 
				else null end) as monetary_p
			from (
						select
							[user],
							max(DATEDIFF(d,pay_day,'2020-12-31')) recency,
							count(*) frequency,
							sum(cast(pay_amount as int))  monetary
						 from RFM_test 
						group by [user]
						) a
)

select 
    *,
    (case 
        when  R_class='B' and F_class='B' and  M_class='B' then '一般挽留用户' 
        when  R_class='B' and F_class='B' and  M_class='A' then '重要挽留用户' 
        when  R_class='B' and F_class='A' and  M_class='B' then '一般保持用户' 
        when  R_class='B' and F_class='A' and  M_class='A' then '重要保持用户' 
        when  R_class='A' and F_class='B' and  M_class='B' then '一般发展用户' 
        when  R_class='A' and F_class='B' and  M_class='A' then '重要发展用户' 
        when  R_class='A' and F_class='A' and  M_class='B' then '一般价值用户' 
        when  R_class='A' and F_class='A' and  M_class='A' then '重要价值用户' 
    else null end) as user_type
from (
			select 
				t.*,
				(case when  recency>=3.37 then 'A' else 'B' end) as  R_class,
				(case when  frequency>=2.68 then 'A' else 'B' end) as F_class,
				(case when  monetary>=3.19 then 'A' else 'B' end) as M_class
			 from t) a