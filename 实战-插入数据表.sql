insert into demo.goodsmaster(
	barcode,
    goodsname,
    price
)
values(
	'0002',
    '胶水',
    0.19
);
select * from demo.goodsmaster;
alter table demo.goodsmaster add column unit text;
alter table demo.goodsmaster modify column price decimal(10,2);

insert into demo.importhead(
	listnumber,
    supplierid,
    stocknumber,
    quantity,
    importvalue,
    recorder,
    recordingdate
)
values(
	3456,
    1,
    1,
    10,
    100,
    1,
    '2020-12-10'
);

insert into demo.goodsmaster(
    barcode,
    goodsname,
    specification,
    unit,
    price
)
values(
    '0004',
    '测试',
    '',
    '个',
    20
);

insert into demo.membermaster(
	cardno,
    membername,
    memberphone,
    memberpid,
    memberaddress ,
    sex,
    birthday 
)
values(
	'10000001',
    '王五',
    '13698765432',
    '475141970010123456',
    '天津',
    '女',
    '1970-01-01'
);

INSERT INTO demo.transactiondetails
(
  transactionid,
  itemnumber,
  quantity,
  prcie,
  salesvalue
)
VALUES
(
  1,
  1,
  2,
  89,
  178
);

INSERT INTO demo.transactionhead
(
  transactionid,
  transactionno,
  cashierid,
  operatorid,
  trasdate
)
VALUES
(
  2,
  '01202012020000001',
  1,
  2,
  '2020-12-02 10:50:50'
);

insert into demo.discountrule(
	branchid,
    itemnumber,
    weekday,
    discountrate
)
values(
	1,
    1,
    1,
    0.9
);

insert into demo.membermaster(
	memberid,
    branchid,
    cardno,
    membername,
    address,
    phone,
    pid,
    memberpoints,
    memberdeposit
)
values(
	1,
    1,
    '10000001',
    '张三',
    '北京',
    '13812345678',
    '110198197001018697',
    0,
    0
);
select * from demo.trans;
insert into demo.trans(
	transactionnumber,
    itemnumber,
    price,
    quantity,
    transdate
)
values(
	2,
    1,
    89,
    1,
    '2020-12-01'
);

insert into demo.inventory(
	itemnumber,
    invquantity
)
values(
	1,
    10
);


insert into demo.mysales(
	transid,
    itemnumber,
    quantity,
    salesvalue,
    transdate
)
values(
	5898,
    1,
    3,
    234.96,
    '2020-12-03'
);

insert into demo.returnhead(
	listnumber,
    supplierid,
    stockid,
    operatorid,
    confirmationdate
)
values(
	655,
    2,
    1,
    1,
    '2020-12-03'
);

insert into demo.returndetails(
	listnumber,
    itemnumber,
    quantity,
    importprice,
    importvalue
)
values(
	655,
    1,
    1,
    60,
    60
);

insert into demo.inventoryhist(
	itemnumber,
    invquantity,
    invdate
)
values(
	3,
    200,
    '2020-12-02'
);