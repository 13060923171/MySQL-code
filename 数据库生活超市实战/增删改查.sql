#删除表内数据
delete from demo.test;
#删除表内某一些数据
delete from demo.test where itemnumber > 1;
#怎么修改数据,where后面表示的是数据，where前面是我们要改的内容
update demo.test set itemnumber = 2 where itemnumber = 3;

#group by 作用是告诉MySQL，查询结果要如何分组，经常和MySQL的聚合函数一起使用
#having 用于筛选查询结果，跟where类似
#order by 的作用，是告诉 MySQL，查询结果如何排序。ASC 表示升序，DESC 表示降序。

-- mysql> SELECT *
--     -> FROM demo.goodsmaster
--     -> ORDER BY barcode ASC,price DESC;
-- +------------+---------+-----------+---------------+------+-------+
-- | itemnumber | barcode | goodsname | specification | unit | price |
-- +------------+---------+-----------+---------------+------+-------+
-- |          6 | 0003    | 尺子1     | NULL          | NULL | 15.00 |
-- |          4 | 0003    | 尺子      | 三角型        | 把   |  5.00 |
-- |          7 | 0004    | 测试1     | NULL          | NULL | 20.00 |
-- |          5 | 0004    | 测试      | NULL          | NULL | 10.00 |
-- +------------+---------+-----------+---------------+------+-------+

#limit指的是限制

