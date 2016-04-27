--1.

select city
from agents
where aid in (
	select aid
	from orders
	where cid = 'c002');

--2.

select distinct pid
from orders
where aid in (
	select aid
	from orders
	where cid in (
		select cid
		from customers
		where city = 'Dallas')
	)
ORDER BY pid DESC;


-- 3.

select cid, name
from customers
where cid in (
	select cid
	from orders
	where aid not in (
		select aid
		from orders
		where aid = 'a01'));

-- 4.

select distinct cid
from orders
where cid in (
	select cid
	from orders
	where pid = 'p01')
AND cid in (
	select cid
	from orders
	where pid = 'p07');

-- 5.

select distinct pid
from orders
where cid not in (
	select cid
	from orders
	where aid = 'a07')
order by pid desc;

-- 6.

select name, discount, city
from customers
where cid in (
	select cid
	from orders
	where aid in (
		select aid
		from agents
		where city = 'London'
		or city = 'New York'));


-- 7.

select cid, name
from customers
where discount IN (
	select discount
	from customers
	where city = 'London'
	or city = 'Dallas');

select * from orders;

