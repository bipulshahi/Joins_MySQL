USE company_db;

SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN Orders o1 ON c.customer_id = o1.customer_id AND o1.category = 'Men'
JOIN Orders o2 ON c.customer_id = o2.customer_id AND o2.category = 'Women';

-- Logic → Same customer must exist in both categories, so we join Orders twice.
-- Output → Customer details (rows only for those who bought both).

-- Find customers who ordered both Men’s and Women’s products.
-- INTERSECT
/*
select * from customers
INTERSECT
select * from orders;
*/

-- Logic → Take IDs in Men’s list ∩ Women’s list.
-- Output → Just customer IDs (no names unless joined later).

select customer_id from customers
intersect
select customer_id from orders;


SELECT customer_id FROM Orders WHERE category = 'Men'
INTERSECT
SELECT customer_id FROM Orders WHERE category = 'Women';


select * from customers
where customer_id in
(SELECT customer_id FROM Orders WHERE category = 'Men'
INTERSECT
SELECT customer_id FROM Orders WHERE category = 'Women');

-- USA customers who have placed at least one order
SELECT customer_id
FROM Customers
WHERE country = 'USA'
INTERSECT
-- Customers who have placed at least one order
SELECT DISTINCT customer_id
FROM Orders;

SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
WHERE c.country = 'USA';

-- INNER JOIN shows customer + order details. Purpose: Compare with INTERSECT approach (which only returns IDs).



-- EXCEPT
-- Customers with no orders (NOT IN)

select customer_id from customers
except
select customer_id from orders;

select customer_id from orders
except
select customer_id from customers;

-- All customers
SELECT customer_id
FROM Customers
EXCEPT
-- Customers who have placed orders
SELECT DISTINCT customer_id
FROM Orders;


select * from customers
where customer_id in
(select customer_id from customers
except
select customer_id from orders);

-- Using Left Join
-- Customers with no orders (LEFT JOIN IS NULL)
SELECT c.customer_id, c.first_name, c.last_name, c.country
FROM Customers c
LEFT JOIN Orders o 
       ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

-- Equivalent to NOT IN
SELECT customer_id, first_name, last_name
FROM Customers
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM Orders
);


-- Find customers who ordered Men’s products but NOT Women’s.
SELECT customer_id
FROM Orders
WHERE category = 'Men'
EXCEPT
-- Customers who bought Women's products
SELECT customer_id
FROM Orders
WHERE category = 'Women';



-- Using JOIN + NOT EXISTS
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id AND o.category = 'Men'
WHERE NOT EXISTS (
    SELECT 1 FROM Orders o2
    WHERE o2.customer_id = c.customer_id AND o2.category = 'Women'
);

-- Using LEFT JOIN + IS NULL
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN Orders o1 
  ON c.customer_id = o1.customer_id AND o1.category = 'Men'
LEFT JOIN Orders o2 
  ON c.customer_id = o2.customer_id AND o2.category = 'Women'
WHERE o2.customer_id IS NULL;


-- USA customers with no orders
-- USA customers
SELECT customer_id
FROM Customers
WHERE country = 'USA'

EXCEPT

-- USA customers who placed orders
SELECT DISTINCT o.customer_id
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE c.country = 'USA';


-- NOT IN
SELECT customer_id, first_name, last_name
FROM Customers
WHERE country = 'USA'
  AND customer_id NOT IN (
      SELECT customer_id
      FROM Orders
  );


-- Using LEFT JOIN + IS NULL
SELECT c.customer_id, c.first_name, c.last_name, c.country
FROM Customers c
LEFT JOIN Orders o 
       ON c.customer_id = o.customer_id
WHERE c.country = 'USA'
  AND o.customer_id IS NULL;



