-- Lab 6

/* 
1) Display the name and city of customers who live in any city that makes the most 
different kinds of products.(There are two cities that make the most different products.
Return the name and city of customers from either one of those.)
*/
SELECT name, city
FROM Customers
WHERE city in (SELECT tblCount.city
	FROM (SELECT city,count(city) as count_city 
	FROM Products 
	Group by city) as tblCount
JOIN (SELECT max(count_city) as count_max
 FROM (SELECT city as cityName, count(city) as count_city 
 FROM products 
 group by city) as tblTmp) as tblMax
on tblCount.count_city = tblMax.count_max);

-- 2)
SELECT p.name, p.priceUSD
FROM Products p
JOIN (SELECT AVG(priceUSD) as averageUSD FROM Products) as AVGTable
on averageUSD < p.priceUSD
Order by p.name Desc;

-- 3)
SELECT c.name, o.pid, o.dollars
FROM orders o 
Inner join customers c on c.cid = o.cid
Order by o.pid asc,
 o.dollars desc;


-- 4.
SELECT name, orderTotal
FROM Customers
JOIN (select cid, coalesce(sum(dollars),'0') as orderTotal From orders Group by cid) as tblTotal
on tblTotal.cid = Customers.cid;

-- 5.
SELECT c.name as customerName, p.name as productName, a.name as agentName
FROM customers c, products p, agents a, orders o
WHERE c.cid = o.cid
and p.pid = o.pid
and a.aid = o.aid
and a.city = 'Tokyo'

-- 6.Write a query to check the accuracy of the dollars column in the orders table. This means calculating Orders.totalUSD from data in other tables and comparing those values to the values in Orders.totalUSD. Display all rows in Orders where Orders.totalUSD is incorrect, if any.
Select *
From (Select o.*, o.qty*p.priceusd*(1-(discount/100)) as truedollars
 from orders o
 inner join products p on o.pid = p.pid
 inner join customers c on o.cid = c.cid) as tblTemp
Where dollars != truedollars

-- 7.What is the difference between a LEFT OUTER JOIN and a RIGHT OUTER JOIN? Give example queries in SQL to demonstrate.
--First ex. of a LEFT OUTER JOIN
SELECT c.cid, c.name, o.pid
FROM customers c
left join orders o 
on c.cid = o.cid;
--Second ex. of a RIGHT OUTER JOIN
SELECT c.cid, c.name, o.pid
FROM customers c
right join orders o 
on c.cid = o.cid;

/* 
Explanation -->  a left outer join  will return any information of the first input table
and all kind of data that does not correspond from the second input table. The second table instead works by taking every records in the other table and also 
obtaining any kind of information to form the first table
*/