USE company_db;

-- JOIN + OR: Returns customer info (details).
-- UNION: Returns just IDs (deduplicated automatically).

-- List all customers who ordered either Men’s OR Women’s products.
SELECT DISTINCT c.customer_id, c.first_name, c.last_name, o.category
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.category = 'Men' OR o.category = 'Women';

/*
select * from customers
union
select * from orders;
*/

select customer_id,first_name from customers
union
select customer_id,category from orders;

select customer_id from customers
union
select customer_id from orders;

SELECT customer_id FROM Orders WHERE category = 'Men'
UNION
SELECT customer_id FROM Orders WHERE category = 'Women';

select * from customers where customer_id in
(SELECT customer_id FROM Orders WHERE category = 'Men'
UNION
SELECT customer_id FROM Orders WHERE category = 'Women');

-- Customers who ordered Men’s or Women’s products
-- This will return each customer_id once only, even if they ordered both Men & Women.

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

-- This will return customer_id multiple times if they appear in both queries.
-- if Customer 5 has both Men and Women orders → they will appear twice.
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

-- UNION: deduplicated list → {2, 5, 7, 19, 24, ...}
-- UNION ALL: keeps all → {2, 2, 5, 5, 7, 7, 19, 19, 24, 24, ...}


/* Show all customers and their orders 
(even if some customers have no orders, 
or some orders don’t match any customer — though here all orders reference customers).
*/

SELECT c.customer_id, c.first_name, o.order_id, o.amount
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id

UNION

SELECT c.customer_id, c.first_name, o.order_id, o.amount
FROM Customers c
RIGHT JOIN Orders o ON c.customer_id = o.customer_id;









