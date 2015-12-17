-- Brian Dones
-- Professor Labouseur
-- Database Management
-- March 22, 2015

-- 1. Show the cities of agents booking an order for a customer whose pid is 'c006'. 
--    Use joins; no subqueries. 

select agents.city
from agents, Orders,customers
where 	agents.aid = Orders.aid
and	customers.cid = Orders.cid
and	customers.cid = 'c006'

order by agents.city asc;

-- 2. Show the pids of products ordered through any agent who makes at least one 
--    order for a customer in Kyoto, sorted by pid from highest to lowest.
--    Use joins; no subqueries.

select distinct Orders.pid
from products, Orders, customers, agents
where	products.pid = Orders.pid
and	agents.aid = Orders.aid
and	customers.cid = Orders.cid
and	customers.city = 'Kyoto'

order by Orders.pid desc;

-- 3. Show the names of customers who have never placed an order. Use a subquery.

select name
from customers
where cid not in (select cid
		  from Orders);

-- 4. Show the names of customers who have never placed an order. Use an outer join.

select customers.name
from customers left outer join Orders
on customers.cid = Orders.cid
where Orders.ordno is null;

-- 5. Show the names of customers who placed at least one order through an agent 
--    in their own city, along with those agent(s') name(s). 

select distinct customers.cid, customers.name,agents.aid, agents.name, customers.city
from customers, agents, Orders
where 	Orders.cid = customers.cid
and	Orders.aid = agents.aid
and	customers.city = agents.city;

-- 6. Show the names of customers and agents living in the same city, along with 
--    the name of the shared city, regardless of whether or not the customer has
--    ever placed an order with that agent.

select customers.name, agents.name, customers.city
from customers inner join agents
on customers.city = agents.city;

-- 7. Show the name and city of customers who live in the city that makes the fewest 
--    different kinds of products. (Hint: Use count and group by on the Products table.)

--select customers.name, customers.city
--from customers
--where customers.city = ???

-- This problem definitely had a little brain damage associated with it...
-- TASKS TO DO:
-- 1. Use count on product IDs along with group by city to get a list of cities with 
--    the number of products that city produces (Thank you Labouseur for those hints).
-- 2. Sort the list of cities by the number of products produced in ascending order.
-- 3. Use "limit 1" to retrieve the first city on the list that will have the least
--    produced products.
-- 4. Select the names and city of the customers who live in the same city that produces
--    the least number of products.


select customers.name, customers.city
from customers
where customers.city in (select city
			 from (select city, count(pid) as differentProducts
			       from products
			       group by city
			       ) as mostProducingCity
			 where differentProducts in (select min(differentProducts)
						     from (select city, count(pid) as differentProducts
							   from products
							   group by city
							   order by differentProducts asc
							   ) as mostProducingCity)
			);

/*
Other solutions:

1. 
select name, city
from customers
where city =
 (select city
  from 
  (select city, count(name) as cityCount
   from products
   group by city
   order by cityCount asc
   limit 1) sub1)

2. 
select c.name, c.city
from customers c,
	(select city, count(name) as cityCount
	 from products
	 group by city
	 order by cityCount asc
	 limit 1) tt
where tt.city = c.city

3. 
select customers.name, customers.city
from customers
where customers.city in (
select city
from(
 select city, count(name) as cityCount
 from products
 group by city
 having count(name) =
  (select min(cityCount)
   from
   (select city, count(name) as cityCount
    from products
    group by city) sub1)
) minCities
)
*/