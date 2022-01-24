create table demo.goodsmaster(
	barcode text,
    goodsname text,
    price double,
    itemnumber int primary key auto_increment
);

create table demo.importhead(
	listnumber int primary key,
    supplierid int,
    stocknumber int,
    importtype int,
    quantity decimal(10,3),
    importvalue decimal(10,2),
    recorder int,
    recordingdate datetime
);

create table demo.membermaster(
	cardno char(8) primary key,
    membername text,
    memberphone text,
    memberpid text,
    memberaddress TEXT,
    sex text,
    birthday datetime
);

create table demo.transactiondetails(
	transactionid int,
    itemnumber int ,
    quantity int,
    prcie int,
    salesvalue int 
);

create table demo.transactionhead(
	transactionid int primary key,
    transactionno text,
    cashierid int,
    memberid int,
    operatorid int,
    trasdate datetime
);

create table demo.discountrule(
	branchid int,
    itemnumber int,
    weekday int,
    discountrate float
);

create table demo.membermaster(
	memberid int primary key,
    branchid int,
    cardno text,
    membername text,
    address text,
    phone text,
    pid text,
    memberpoints int ,
    memberdeposit int
);

create table demo.trans(
	transactionnumber int primary key,
    itemnumber int,
    price int,
    quantity int,
    cardno text,
    transdate datetime
    
);

create table demo.mytrans(
	transid int primary key,
    itemnumber int,
    quantity int
);

create table demo.inventory(
	itemnumber int,
    invquantity int
);

create table demo.mysales(
	transid int,
    itemnumber int,
    quantity int ,
    salesvalue decimal(10,3),
    transdate datetime
);

create table demo.returnhead(
	listnumber int,
    supplierid int,
    stockid int ,
    operatorid int,
    confirmationdate datetime
);

create table demo.returndetails(
	listnumber int,
    itemnumber int,
    quantity int ,
    importprice int,
    importvalue int
);

create table demo.inventoryhist(
	itemnumber int,
    invquantity int,
    invdate datetime
);