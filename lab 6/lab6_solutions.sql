-- Brian Dones
-- Professor Labouseur
-- Database Management
-- March 23, 2015

-- 1. Display the name and city of customers who live in any city that makes the most different kinds of products.
--    (There are two cities that make the most different products. Return the name and city of customers from either
--    one of those.)

-- TASKS:
-- 1. Get a list of cities and the number of different products they produce.
-- 2. Find the city or cities that has or have the maximum number of different products.
-- 3. Take that list and get the customers names and city from that list. 

select customers.name, customers.city
from customers
where customers.city in (select city
			 from (select city, count(pid) as differentProducts
			       from products
			       group by city
			       ) as mostProducingCity
			 where differentProducts in (select max(differentProducts)
						     from (select city, count(pid) as differentProducts
							   from products
							   group by city
							   order by differentProducts asc
							   ) as mostProducingCity)
			);

/*
1.
select customers.name, customers.city
from customers
where customers.city in (
select city
from(
 select city, count(name) as cityCount
 from products
 group by city
 having count(name) =
  (select max(cityCount)
   from
   (select city, count(name) as cityCount
    from products
    group by city) sub1)
) maxCities
)


*/

-- 2. Display the name of products whose priceUSD is below the average priceUSD, in alphabetical order.

select products.name
from products
where products.priceUSD < (select avg(priceUSD) as averagePrice
			   from products
			  )
order by products.name asc;

-- 3. Display the customer name, pid ordered, and the dollars for all orders, sorted by dollars from high to low.

select customers.name, Orders.pid, Orders.dollars
from customers, Orders
where 	customers.cid = Orders.cid
order by Orders.dollars asc;

-- Question.. do I add up the orders for customers with multiple orders or no?

-- 4. Display all customers names (in reverse alphabetical order) and their total ordered, and nothing more. Use
--    coalesce to avoid showing NULLs.

select customers.name, coalesce(sum(Orders.dollars),0)
from customers left outer join Orders
on customers.cid = Orders.cid
group by customers.cid
order by customers.name desc;

-- 5. Display the names of all customers who bought products from agents based in Tokyo along with the names of the
--    products they ordered, and the names of the agents who sold it to them.

select customers.name, products.name, agents.name
from agents, customers, Orders, products
where 	customers.cid = Orders.cid
and	products.pid = Orders.pid
and 	agents.city = 'Tokyo'
order by customers.name asc;

-- 6. Write a query to check the accuracy of the dollars column in the Orders tables. This means calculating Orders.dollars
--    from data in other tables and comparing those values to the values in Orders.dollars. Display all rows in Orders where
--    Orders.dollars is incorrect, if any.

select Orders.*
from Orders, products, customers
where 	Orders.pid = products.pid
and 	Orders.cid = customers.cid
and	Orders.dollars != ((1 -.01 * customers.discount) * (products.priceUSD * Orders.qty));

/*
Other Solutions:

1. 
select o.ordno, o.qty, o.dollars,
          p.priceUSD,
          c.discount as discountPCT
from Orders o, 
     products p,
     customers c
where o.pid = p.pid
and   o.cid = c.cid
and   o.dollars != (o.qty * p.priceUSD) - ((o.qty * p.priceUSD) * (c.discount/100))
*/

-- 7. What's the difference between a LEFT OUTER JOIN and a RIGHT OUTER JOIN? Give example queries in SQL to demonstrate.
--    (Feel free to use the CAP2 database to make your points here.)

-- Left Outer Joins will return a value for all the rows in the first table no matter what. So if there is not a value
-- in table two that corresponds to a value in the first table, a NULL value where be inserted where the second table does 
-- not match up and the resulting table will have an empty cell. Right Outer Joins are simliar to Left Outer Joins but instead 
-- of returning values for all the rows in the first table, Right Outer Joins returns all the values for the rows in the 
-- second table no matter what and if there is not a corresponding value from the first table, then a NULL value will be inserted. 

-- So from this query, we will get all the customer names and customer IDs of all customers regardless if they had ordered
-- anything or not.
select customers.name, Orders.cid
from customers left outer join Orders
on customers.cid = Orders.cid;

-- For this query, we will get all the customer names and customer IDs for each order placed not including any customers whom
-- did not place an order.
select customers.name, Orders.cid
from customers right outer join Orders
on customers.cid = Orders.cid;