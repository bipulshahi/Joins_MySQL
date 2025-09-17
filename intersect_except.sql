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

-- EXCEPT
-- Find customers who ordered Men’s products but NOT Women’s.
select customer_id from customers
except
select customer_id from orders;

select customer_id from orders
except
select customer_id from customers;

select * from customers
where customer_id in
(select customer_id from customers
except
select customer_id from orders);

-- Using JOIN + NOT EXISTS
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id AND o.category = 'Men'
WHERE NOT EXISTS (
    SELECT 1 FROM Orders o2
    WHERE o2.customer_id = c.customer_id AND o2.category = 'Women'
);






