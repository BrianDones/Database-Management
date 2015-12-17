drop table if exists suppliersLocation;
drop table if exists masterOrderList;
drop table if exists itemsList;
drop table if exists orders;
drop table if exists items;
drop table if exists suppliers;
drop table if exists zipCodes;

-- Zip Code Table
create table zipCodes (
 zipCode	integer not null,

 primary key(zipCode)
);

 -- Suppliers Table
 create table suppliers (
  sid		char(4) not null,
  name		text,
  zipCode	integer not null references zipCodes(zipCode),
  payTerms	text,
  contactInfo	text,
  primary key(sid)
 );

-- Supplier's Location Table
create table suppliersLocation (
 sid		char(4) not null references suppliers(sid),
 zipCode	integer not null references zipCodes(zipCode),
 address	text,
 city		text,
 state		char(2),
 primary key(sid, zipCode)
);

 -- Items Table
 create table items (
  sku		char(6) not null,
  description	text,
  quantity	integer,
  priceUSD	numeric(10,2),
  primary key(sku)
);
 
 -- Order Table
 create table orders (
  itemID	char(8) not null,
  sku		char(6) not null references items(sku),
  quantity	integer,
  priceUSD	numeric(10,2),
  primary key(itemID)
 );
  
 -- Items List Table

 create table itemsList (
 listNum	char(4) not null,
 itemID		char(8) not null references orders(itemID),
 primary key(listNum)
);
 
 -- Master Order List
 create table masterOrderList (
  ordno		char(4) not null,
  sid		char(4) references suppliers(sid),
  listNum	char(4) references itemsList(listNum),
  comments	text,
  orddate	date,
  primary key(ordno)
 );			

-- Zip Code Values
insert into zipCodes(zipCode)
 values(12601);
insert into zipCodes(zipCode)
 values(78247);
insert into zipCodes(zipCode)
 values(94101);

 -- Suppliers Values
 insert into suppliers(sid, name, zipCode, payTerms, contactInfo)
  values('s001', 'Bond', 78247, 'With cars and girls', 'Ill contact you...');
 insert into suppliers(sid, name, zipCode, payTerms, contactInfo)
  values('s002', 'Labouseur', 12601, 'The full Collectors Edition of James Bond... minus anything with Daniel Craig', 'Labouseur.com');
 insert into suppliers(sid, name, zipCode, payTerms, contactInfo)
  values('s003', 'Sparrow', 94101, 'With a bottle of rum', 'The local brewery');

 -- Supplier Locations Values
 insert into suppliersLocation(sid, zipCode, address, city, state)
  values('s001', 78247, 'The Huge Mansion', 'San Antonio', 'TX');
 insert into suppliersLocation(sid, zipCode, address, city, state)
  values('s002', 12601, 'You dont need to know', 'Poughkeepsie', 'NY'); 
 insert into suppliersLocation(sid, zipCode, address, city, state)
  values('s001', 94101, 'The Black Pearl', 'San Francisco', 'CA');

 -- Item Values
 insert into items(sku, description, quantity, priceUSD)
  values('811625', 'Golden Gun', 1, 230.07);
 insert into items(sku, description, quantity, priceUSD)
  values('177674', 'Broken Compass', 10, 5.95);
 insert into items(sku, description, quantity, priceUSD)
  values('820778', 'knowledge of everything databases', 20, 2400.55); -- $Tuition cost.
 insert into items(sku, description, quantity, priceUSD)
  values('202542', 'comical and yet informative lectures', 540, 1000.60);
 insert into items(sku, description, quantity, priceUSD)
  values('441187', 'Spiced Rum', 400, 34.00);
 insert into items(sku, description, quantity, priceUSD)
  values('646837', 'Submarine sports car', 1, 12000000.00); 

 -- Orders Values
 insert into orders(itemID, sku, quantity, priceUSD)
  values('86857768', '811625', 1, 230.07);
 insert into orders(itemID, sku, quantity, priceUSD)
  values('75978629', '441187', 230, 7820.00);
 insert into orders(itemID, sku, quantity, priceUSD)
  values('42151427', '820778', 16, 38408.80);
 insert into orders(itemID, sku, quantity, priceUSD)
  values('53076054', '646837', 1, 12000000.00);

 -- Ordered Items List Values
 insert into itemsList(listNum, itemID)
  values('L001', '86857768');
 insert into itemsList(listNum, itemID)
  values('L002', '75978629');
 insert into itemsList(listNum, itemID)
  values('L003', '42151427');
 insert into itemsList(listNum, itemID)
  values('L004', '53076054'); 

 -- Master Order List Values
 insert into masterOrderList(ordno, sid, listNum, comments, orddate)
  values('Ord1', 's001', 'L001', 'With this.. you have a license to kill.', '2015-05-10');
 insert into masterOrderList(ordno, sid, listNum, comments, orddate)
  values('Ord2', 's002', 'L003', 'We love our databases', '2015-01-27'); 
 insert into masterOrderList(ordno, sid, listNum, comments, orddate)
  values('Ord3', 's001', 'L004', 'Who wouldnt want a submarine car', '1993-07-14'); 


-- Query to calculate how many of the given SKU are available to be sold.
-- The amount available to be sold is defined as the amount currently on hand
-- plus the amount on order. (You can hard-code the SKU into the query.)

select i.sku,
	(i.quantity + o.quantity) as "amountToSale"
   from masterOrderList ord,
        itemsList list,
        orders o,
        items i
   where ord.listNum = list.listNum
	and list.itemID = '42151427'
	and o.itemID = list.itemID
	and o.sku = i.sku
  
  

