-- Brian Dones
-- Professor Labouseur
-- Database Management
-- March 20, 2015

-- 1. Get the cities of agents booking an order for a customer whose cid is 'c006'.

select city
from agents
where aid in (select aid
	      from Orders
	      where cid in (select cid
		            from customers
			    where cid = 'c006')
		);

-- 2. Get the pids of products ordered through any agent who takes at least one order 
--    from a customer in Kyoto, sorted by pid from highest to lowest. (This is not the
--    same as asking for pids of products ordered by customers in Kyoto). 

select pid
from Orders
where aid in (select aid
              from Orders
	      where cid in (select cid
			    from customers
			    where city = 'Kyoto')
		      ) 
order by pid asc;

-- 3. Get the cids and names of customers who did not place an order through agent a03. 

select cid, name
from customers
where cid not in (select cid
		  from Orders
		  where aid in (select aid
				from agents
				where aid = 'a03')
		 );

-- 4. Get the cids of customers who ordered both product p01 and p07. 

select cid
from customers
where cid in (select cid
	      from Orders
	      where pid = 'p01')
and cid in   (select cid
	      from Orders
	      where pid = 'p07');

-- 5. Get the pids of products NOT ordered by any customers who placed any order through agent a05.

-- so in other words, get the pid's of all the products that c001 and c002 do NOT order... which,
-- between the two customers, they order every item... so, there should be not pids returned. 

select pid
from Orders
where pid not in (select pid
		  from Orders
		  where cid in (select cid
				from Orders
				where aid = 'a05')
		)
order by pid asc;


-- 6. Get the name, discounts, and city for all customers who place orders through agents in Dallas or New York.

select name, discount, city
from customers
where cid in (select distinct cid
	      from Orders
	      where aid in (select aid
	                    from agents
	                    where city = 'Dallas' or city = 'New York')
	      )
order by cid asc;

-- 7. Get all customers who have the same discount as that of any customers in Dallas or London.

-- Note - there are no customers from London, only agent Bond... James Bond is from London.

select *
from customers
where discount in (select discount
                   from customers
                   where city = 'Dallas' or city = 'London');

-- 8. Tell me about check constraints: What are they? What are they good for? What's the advantage of putting
--    that sort of thing inside the database? Make up some examples of good uses of check constraints and 
--    some examples of bad uses of check constraints. Explain the differences in your examples and argue your case.

/*
	A check constraint is a type of integrity constraint which specifies a requirement that must be met by each
	row in a database table. The constraint has to be a predicate however. The good thing about check constraints
	is that they can allow us to limit the possible values of a column. An example of when check constraints would
	be good to use would be the price for an item. It is probably safe to say that you will never pay a negative 
	amount of dollars for an item so in this case a check constraint that allows only positive numbers would be 
	nice to have. An example of when a check constraint may be bad is when you put a low value for a maximum length
	on a value that is a text or string. If there is too low of a length for a value, there may possibly aspects
	about a piece of data that is lost due to the check constraint.
*/


