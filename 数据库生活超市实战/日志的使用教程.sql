
#通用查询日志的使用
-- mysql> SHOW VARIABLES LIKE '%general%';
-- +------------------+---------------+
-- | Variable_name | Value |
-- +------------------+---------------+
-- | general_log | OFF | -- 通用查询日志处于关闭状态
-- | general_log_file | GJTECH-PC.log | -- 通用查询日志文件的名称是GJTECH-PC.log
-- +------------------+---------------+

set global general_log = 'on';

set @@global.general_log_file = 'D:\project-sql.log';

show variables like '%general%';

#怎么删除通用查询日志
#1、先关闭通用查询日志
set global general_log = 'off';
show variables like '%general_log%';
#2、把查询日志的文件移到其他位置
#3再开启查询日志
set global general_log = 'on';

#慢查询日志
#慢查询日志用来记录执行时间超过指定时长的查询
show variables like 'min%';

#错误日志

#查看二进制日志
show master status;
#查看所有二进制日志
show binary logs;
#查看二进制日志所有数据更新事件
#show binlog events in 二进制文件名;
#刷新二进制日志
flush binary logs;
#用二进制日志恢复数据
-- mysqlbinlog -start-positon=XXX -end-position=yyy 二进制文件名 | mysql -u 用户 -p
#删除二进制日志
reset master;
show binary logs;
#删除指定二进制文件
purge master logs to 'GJTECH-PC-bin.000005';

#备份数据库
mysqldump -u root -p demo > mybackup.sql;

#恢复数据库
mysql -u root -p demo<mybackup.sql;

#中继日志
#中继日志只在主从服务器架构的从服务器上存在

#回滚日志
show variables like '%innodb_undo%';
-- innodb_undo_directory=.\ ，表示回滚日志的存储目录是数据目录，数据目录的位置可以通过查询变量“datadir”来查看。
-- innodb_undo_log_encrypt = OFF，表示回滚日志不加密。
-- innodb_undo_log_truncate = ON，表示回滚日志是否自动截断回收，这个变量有效的前提是设置了独立表空间。
-- innodb_undo_tablespaces = 2，表示回滚日志有自己的独立表空间，而不是在共享表空间 ibdata 文件中。下面的截图显示了回滚日志

#重做日志
show variables like '%innodb_log_files_group%';