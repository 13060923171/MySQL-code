


INSERT INTO scores_table 
(`id`, `name`, `subject`, `teacher_id`, `scores`) VALUES
(1,'赵雷','语文',1001,95)


select * from  scores_table limit 10


INSERT INTO scores_table 
(`id`, `name`, `subject`, `teacher_id`, `scores`) VALUES
(2,'王菊','数学',1002,92),
(3,'王风','物理',1003,90),
(4,'赵云','数学',1002,98),
(5,'赵雷','数学',1002,83)

---直接通过复制到粘贴板的数据也可以


select * from  teacher_table limit 10

INSERT INTO teacher_table 
(`teacher_id`,`teacher`,`subject`) VALUES
(1001,'赵亮','语文'),
(1002,'何达','数学'),
(1003,'赵心','物理'),
(1003,'赵心','化学'),
(1002,'何达','生物'),
(1004,'张健','数学'),
(1004,'张健','英语')


select * from  user_ip limit 10

INSERT INTO user_ip 
(`name`,`province`,`city`,`mobile`) VALUES
('赵雷','广东','广州','18826307000'),
('赵兰','上海市','上海','18821975313'),
('王菊','广东省','深圳','18828928543'),
('王电','北京','北京','18822900746'),
('赵云','广西','阳朔','18822621535'),
('周梅','广西省','桂林','18852653411'),
('郑如','新疆','吐鲁番','18824269171'),
('王风','内蒙古','呼尔哈特','18824671824'),
('郑竹','香港','香港',null),
('周虹','河南','郑州','18829805239')


---第二种方式，直接通过导出csv，或者excel

