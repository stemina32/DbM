-- lab 5
-- 1.

select a.city
from agents a join orders o
on a.aid = o.aid
where o.cid = 'c002' ;

-- 2.

select distinct o.pid
from orders o join customers c
on o.cid = c.cid
where c.city = 'Dallas'
order by pid desc;

-- 3.

select name
from customers
where cid not in (
	select cid
	from orders);

-- 4.

select name
from customers c left join orders o
on c.cid = o.cid
where o.cid IS NULL;

-- 5.

select distinct c.name as c_name, a.name as a_name
from orders o, customers c, agents a
where o.cid = c.cid
and a.aid = o.aid
and c.city = a.city;

-- 6.

select distinct ccity.name as c_name, acity.name as a_name, ccity.city
from (select c.name, c.city
	from customers c, orders o
	where c.cid = o.cid) ccity
join
	(select a.name, a.city
	from agents a, orders o
	where a.aid = o.aid) acity
on acity.city = ccity.city;

-- 7.

select name, city
from customers
where city in (
	select count_tbl.city
	from (select min(prod_count) as prod_count
	from (
		select count(pid) as prod_count
		from products
		group by city
	) as t1) as min_tbl join
		(select count(pid) as prod_count, city
		from products
		group by city) as count_tbl
	on min_tbl.prod_count = count_tbl.prod_count
);

/*






*/
