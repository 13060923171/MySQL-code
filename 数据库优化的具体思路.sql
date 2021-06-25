-- 数据表设计的三大范式，分别是第一范式（1NF）、第二范式（2NF）和第三范式（3NF）
-- 第一范式所要求的：所有的字段都是基本数据字段，不可进一步拆分
-- 第二范式要求，在满足第一范式的基础上，还要满足数据表里的每一条数据记录，都是可唯一标识的。而且所有字段，都必须完全依赖主键，不能只依赖主键的一部分。
-- 第三范式要求数据表在满足第二范式的基础上，不能包含那些可以由非主键字段派生出来的字段，或者说，不能存在依赖于非主键字段的字段。


#在开发基于数据库的信息系统的设计阶段，通常使用ER模型来描述信息需求和信息特性，帮助我们理清业务逻辑，从而设计出优秀的数据库
#在ER模型里面，有三个要素，分别是实体，属性，关系

#在ER模型中，用矩形表示，实体分为两类，分别是强实体和弱实体，强实体是指不依赖于其他实体的实体，弱实体是指对另一个实体有很强的依赖关系的实体
#属性是指实体的特性，在ER模型中用椭圆表示
#关系是指实体之间的联系，在ER模型中用菱形表示
#关系又可以分为3种类型，分别是1对1,1对多和多对多

#怎么把ER模板转换成数据表
#把绘制好的ER模板转换成具体的数据表
#1个实体通常转换成一个数据表
#1个多对多的关系，通常转换成一个数据表
#一个1对1，或者1对多的关系，通过表的外键来表达，而不是设计一个新的数据表
#属性转换表的字段

#怎么提高查询效率
#查询分析语句
#{explain | describe | desc } 查询语句;
explain select itemnumber,quantity,price,transdate from demo.trans where itemnumber =1 and transdate > '2020-06-18 09:00:00' and transdate < '2020-06-18 12:00:00'; 

#优化查询最有效的方法就是创建索引
#怎么使用like来利用索引提高效率
#like经常被使用在查询的限定条件中，通过通配符%来筛选符合条件的记录
#where字段like'%aa',表示筛选出所有以字段'aa'结尾的记录
#where字段like'aa%',表示筛选出所有以'aa'开始的记录
#where字段like'%aa%'，表示所有字段中包含'aa'的记录

-- 关键字“OR”表示“或”的关系，“WHERE 表达式 1 OR 表达式 2”，就表示表达式 1 或者表达式 2 中只要有一个成立，整个 WHERE 条件就是成立的。

#数据类型的优化
#第一种方法：对整数类型数据进行优化
#第二种方法：就是即可用使用文本类型也可以使用整数类型的字段，要使用整数类型，而不是使用文本类型

#在设计字段的时候，如果业务允许，尽量使用非空约束

#怎么利用系统资源来诊断问题 用MySQL提供的工具:Performance Schema


-- UPDATE performance_schema.setup_consumers
-- SET ENABLED = 'YES'
--  
-- mysql> SELECT *
-- -> FROM performance_schema.setup_consumers
-- -> ;
-- +----------------------------------+---------+
-- | NAME | ENABLED |
-- +----------------------------------+---------+
-- | events_stages_current | YES |            -- 当前阶段
-- | events_stages_history | YES |            -- 阶段历史   
-- | events_stages_history_long | YES |       -- 阶段长历史
-- | events_statements_current | YES |        -- 当前语句
-- | events_statements_history | YES |        -- 历史语句 
-- | events_statements_history_long | YES |   -- 长历史语句
-- | events_transactions_current | YES |      -- 当前事务
-- | events_transactions_history | YES |      -- 历史事务
-- | events_transactions_history_long | YES | -- 长历史事务 
-- | events_waits_current | YES |             -- 当前等待
-- | events_waits_history | YES |             -- 等待历史   
-- | events_waits_history_long | YES |        -- 等待长历史
-- | global_instrumentation | YES |
-- | thread_instrumentation | YES |
-- | statements_digest | YES |
-- +----------------------------------+---------+
-- 15 rows in set (0.01 sec)