#创建角色
create role 角色名;

#例子,这里的也是是创建一个角色，名称为'manager'，角色可以登录localhost，意思是只能从数据库服务器运行的这台计算机登录这个角色
create role 'manager'@'localhost';

#这里的意思就是这个账号可以从任何一台主机登录数据库
create role 'stocker';

#给角色赋予权限
#create 权限 on 表名 to 角色名;

#赋予某个角色只读的权限
grant select on demo.goodsmaster to 'reduer';

#赋予增删改查的权限
grant select,insert,delete,update on demo.invcount to 'stocker';

#怎么查看角色权限
show grants for 'stocker';

#删除角色
drop role 角色名称;

#怎么创建用户
create user 'zhangsan' identified by 'mysql';

#把角色赋予用户给用户授权
grant 'stocker' to 'zhangsan';

#直接给用户授权
grant 权限 on 表名 to 用户名;

#怎么查看用户权限
show grants for 'zhangsan';
#要激活权限

SET global activate_all_roles_on_login=ON;

#删除用户
drop user 用户名;