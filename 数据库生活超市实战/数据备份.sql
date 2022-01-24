#怎么备份数据库中的表
#mysqldump -h 服务器 -u 用户 -p 密码 数据库名称 [表名称 … ] > 备份文件名称
#怎么备份整个数据库服务器
mysqldump -h 服务器 -u 用户 -p 密码 --all-databases > 备份文件名


#数据库的导出

SELECT 字段列表 INTO OUTFILE 文件名称
FIELDS TERMINATED BY 字符
LINES TERMINATED BY 字符
FROM 表名;

-- INTO OUTFILE 文件名称，表示查询的结果保存到文件名称指定的文件中；
-- FIELDS TERMINATED BY 字符，表示列之间的分隔符是“字符”；
-- LINES TERMINATED BY 字符，表示行之间的分隔符是“字符”。
#数据导出语句
select * into outfile 'D:/goodsmaster.txt'
fields terminated by ','
lines terminated by '\n'
from demo.goodsmaster;

#数据导入语句

LOAD DATA INFILE 'D:/goodsmaster.txt'
INTO TABLE demo.goodsmaster
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';
