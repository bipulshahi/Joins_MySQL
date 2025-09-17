USE company_db;

SELECT c.customer_id, c.first_name, o.order_id, o.amount
FROM Customers c
LEFT JOIN Orders o
ON c.customer_id = o.customer_id;

SELECT c.customer_id, c.first_name, o.order_id, o.amount
FROM Customers c
RIGHT JOIN Orders o
ON c.customer_id = o.customer_id;

-- SQL FULL JOIN
SELECT c.customer_id, c.first_name, o.order_id, o.amount
FROM Customers c
LEFT JOIN Orders o
ON c.customer_id = o.customer_id
union
SELECT c.customer_id, c.first_name, o.order_id, o.amount
FROM Customers c
RIGHT JOIN Orders o
ON c.customer_id = o.customer_id;


-- SQL SELF JOIN
SELECT e.employee_name AS Employee,
       m.employee_name AS Manager
FROM Employees e
LEFT JOIN Employees m
ON e.manager_id = m.employee_id;

select * from employees;
select * from orders;

SELECT DISTINCT category FROM Orders;

-- Write a query to find pairs of customers who live in the same city but have different first names?
SELECT A.first_name AS FirstPerson, B.first_name AS SecondPerson
FROM Customers A 
JOIN Customers B 
ON A.city = B.city
AND A.first_name != B.first_name;

-- Write a query to retrieve customer names with the same country and different customer IDs.
SELECT c1.first_name as Customer1,c1.country,c2.first_name as Customer2 
FROM Customers c1
JOIN Customers c2 ON c1.country = c2.country
WHERE c1.customer_id <> c2.customer_id;

select A.first_name,B.first_name
from customers A
join customers B
on A.country = B.country
where A.customer_id < B.customer_id;


-- SQL CROSS JOIN
SELECT c.first_name, o.category
FROM Customers c
CROSS JOIN Orders o;

SELECT DISTINCT category FROM Orders;

SELECT c.first_name, o.category
FROM Customers c
CROSS JOIN (SELECT DISTINCT category FROM Orders) o;

-- Query to retrieve all the combination of product with every category.
SELECT P.name as product_name,C.name as category_name
FROM products P
CROSS JOIN categories C;


-- Set Operations

-- SQL UNION
SELECT customer_id FROM Customers
UNION
SELECT customer_id FROM Orders;

SELECT first_name AS name FROM Customers
UNION
SELECT employee_name FROM Employees;

-- obtain a list of customer IDs who have shopped from either one of the Men's and Women's categories
SELECT customer_id
FROM orders
WHERE category = 'Men'
UNION
SELECT customer_id
FROM orders
WHERE category = 'Women';

-- obtain a list of customers who have shopped from either one of the Men's and Women's categories excluding duplicates
SELECT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
WHERE o.category = 'Men'

UNION

SELECT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
WHERE o.category = 'Women';

-- obtain a list of customers who have shopped from either one of the Men's and Women's categories including duplicates
SELECT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
WHERE o.category = 'Men'

UNION ALL

SELECT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
WHERE o.category = 'Women';



-- SQL INTERSECT
/*
SELECT customer_id FROM Customers
INTERSECT
SELECT customer_id FROM Orders;
*/
SELECT customer_id FROM Customers
WHERE customer_id IN (SELECT customer_id FROM Orders);

-- we want to find customers who are from 'USA' AND also have placed at least one order.

SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
WHERE c.country = 'USA';

SELECT customer_id, first_name, last_name
FROM Customers
WHERE country = 'USA'
  AND customer_id IN (
      SELECT customer_id
      FROM Orders
  );

SELECT c.customer_id, c.first_name, c.last_name
FROM Customers c
WHERE c.country = 'USA'
  AND EXISTS (
      SELECT 1
      FROM Orders o
      WHERE o.customer_id = c.customer_id
  );


-- Query 1: USA customers
SELECT customer_id FROM Customers WHERE country = 'USA';

-- Query 2: Customers with orders
SELECT customer_id FROM Orders;

-- INTERSECT (simulated)
SELECT customer_id, first_name, last_name
FROM Customers
WHERE country = 'USA'
  AND customer_id IN (SELECT customer_id FROM Orders);


-- intersect vs inner join

-- inner join
SELECT c.customer_id, c.first_name, c.country,
       o.order_id, o.amount
FROM Customers c
INNER JOIN Orders o 
    ON c.customer_id = o.customer_id
WHERE c.country = 'USA';

-- intersect

SELECT c.customer_id, c.first_name, c.last_name, c.country
FROM Customers c
WHERE c.country = 'USA'
  AND c.customer_id IN (
      SELECT o.customer_id
      FROM Orders o
  );

/*
SELECT customer_id, first_name, last_name
FROM Customers
JOIN Orders
ON Customers.customer_id = Orders.customer_id
WHERE Orders.category = 'Men'

intersect

SELECT customer_id, first_name, last_name
FROM Customers
JOIN Orders
ON Customers.customer_id = Orders.customer_id
WHERE Orders.category = 'Women';
*/

SELECT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.category IN ('Men', 'Women')
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT o.category) = 2;



-- SQL EXCEPT using NOT IN
SELECT customer_id, first_name
FROM Customers
WHERE customer_id NOT IN (SELECT customer_id FROM Orders);

-- SQL EXCEPT using left join ... is null
SELECT c.customer_id, c.first_name, c.last_name, c.country
FROM Customers c
LEFT JOIN Orders o 
       ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

SELECT c.customer_id, c.first_name, c.last_name, c.country
FROM Customers c
LEFT JOIN Orders o 
       ON c.customer_id = o.customer_id
WHERE c.country = 'USA'
  AND o.customer_id IS NULL;


SELECT c.customer_id, c.first_name, o.order_id
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE c.country = 'USA';

SELECT c.customer_id, c.first_name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE c.country = 'USA'
  AND o.customer_id IS NULL;
  
/*
SELECT customer_id, first_name, last_name
FROM Customers
JOIN Orders
ON Customers.customer_id = Orders.customer_id
WHERE Orders.category = 'Men'

EXCEPT

SELECT customer_id, first_name, last_name
FROM Customers
JOIN Orders
ON Customers.customer_id = Orders.customer_id
WHERE Orders.category = 'Women';
*/

SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.category = 'Men'
  AND NOT EXISTS (
      SELECT 1
      FROM Orders o2
      WHERE o2.customer_id = c.customer_id
        AND o2.category = 'Women'
  );














