-- Brian Dones
-- Professor Laboseur
-- Database Management
-- March 19, 2015

-- 1. List the ordno and dollars of all orders.
select ordno, dollars
from Orders;

-- 2. List the name and city of agents named Smith.
select name, city
from agents
	where name = 'Smith';

-- 3. List the pid, name, and priceUSD of products with quantity more than 200,000.
select pid, name, priceUSD
from products
	where quantity > 200000;

-- 4. List the names and cities of customers in Dallas.
select name, city
from customers
	where city = 'Dallas';

-- 5. List the names of agents not in New York and not in Tokyo.
select *
from agents
	where city != 'New York' and city != 'Tokyo';

-- 6. List all data for products not in Dallas or Duluth that cost $1 (USD) or more.
select *
from products
	where city != 'Dallas' or city != 'Duluth'
	and priceUSD >= 1;

-- 7. List all data for orders in January or May.
select *
from Orders
	where mon = 'jan' or mon = 'may';

-- 8. List all data for orders in February more than $500 (USD).
select *
from Orders
	where mon = 'feb' 
	and dollars > 500;
	
-- 9. List all orders from the customer whose cid is C005.
select *
from customers
	where cid = 'c005';