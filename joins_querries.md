
```sql
USE company_db;
```

**Explanation:** Switches the current working database to `company_db`.
**Purpose:** Ensures all following queries are executed on the intended database.

---

```sql
-- LEFT JOIN: Returns all customers and their orders (if any)
SELECT c.customer_id, c.first_name, o.order_id, o.amount
FROM Customers c
LEFT JOIN Orders o
ON c.customer_id = o.customer_id;
```

**Explanation:** Shows all customers. If a customer has placed an order, order details appear; if not, order fields are NULL.
**Purpose:** To find customers regardless of whether they have placed orders.

---

```sql
-- RIGHT JOIN: Returns all orders and their customers (if any)
SELECT c.customer_id, c.first_name, o.order_id, o.amount
FROM Customers c
RIGHT JOIN Orders o
ON c.customer_id = o.customer_id;
```

**Explanation:** Displays all orders. If an order is linked to a customer, their details are included; if not, customer fields are NULL.
**Purpose:** Ensures no order is missed, even if it has no matching customer.

---

```sql
-- FULL JOIN (simulated with UNION of LEFT and RIGHT JOIN)
SELECT c.customer_id, c.first_name, o.order_id, o.amount
FROM Customers c
LEFT JOIN Orders o
ON c.customer_id = o.customer_id
UNION
SELECT c.customer_id, c.first_name, o.order_id, o.amount
FROM Customers c
RIGHT JOIN Orders o
ON c.customer_id = o.customer_id;
```

**Explanation:** Combines results of LEFT JOIN and RIGHT JOIN. Returns all customers and all orders.
**Purpose:** To retrieve complete information from both tables, including unmatched rows.

---

```sql
-- SELF JOIN: Employee and their Manager
SELECT e.employee_name AS Employee,
       m.employee_name AS Manager
FROM Employees e
LEFT JOIN Employees m
ON e.manager_id = m.employee_id;
```

**Explanation:** Joins the `Employees` table with itself to match employees with their managers.
**Purpose:** To display hierarchical relationships (employee → manager).

---

```sql
-- View all employees
select * from employees;

-- View all orders
select * from orders;
```

**Purpose:** For inspection and validation of data.

---

```sql
-- Distinct order categories
SELECT DISTINCT category FROM Orders;
```

**Explanation:** Fetches unique values from the `category` column in Orders.
**Purpose:** To know all product categories available in orders.

---

```sql
-- Customers in the same city but with different first names
SELECT A.first_name AS FirstPerson, B.first_name AS SecondPerson
FROM Customers A 
JOIN Customers B 
ON A.city = B.city
AND A.first_name != B.first_name;
```

**Explanation:** Pairs of customers living in the same city with different names.
**Purpose:** Identifies potential duplicates or groups of customers by city.

---

```sql
-- Customers with same country but different customer IDs
SELECT c1.first_name as Customer1, c1.country, c2.first_name as Customer2 
FROM Customers c1
JOIN Customers c2 
ON c1.country = c2.country
WHERE c1.customer_id <> c2.customer_id;
```

**Explanation:** Lists pairs of customers from the same country but ensures they are different people.
**Purpose:** Useful for analyzing customer demographics.

---

```sql
-- CROSS JOIN: Cartesian product of Customers and Orders
SELECT c.first_name, o.category
FROM Customers c
CROSS JOIN Orders o;
```

**Explanation:** Each customer is paired with every order.
**Purpose:** Demonstrates CROSS JOIN concept (not practical in real cases).

---

```sql
-- DISTINCT categories from Orders
SELECT DISTINCT category FROM Orders;
```

**Purpose:** Same as earlier, for category inspection.

---

```sql
-- CROSS JOIN with unique categories
SELECT c.first_name, o.category
FROM Customers c
CROSS JOIN (SELECT DISTINCT category FROM Orders) o;
```

**Explanation:** Each customer combined with each unique order category.
**Purpose:** To simulate customer-category pairing, useful for recommendation design.

---

```sql
-- CROSS JOIN between Products and Categories
SELECT P.name as product_name, C.name as category_name
FROM products P
CROSS JOIN categories C;
```

**Explanation:** Lists all possible combinations of products with categories.
**Purpose:** Used in product catalog or testing classification scenarios.

---

## Set Operations

```sql
-- UNION: Customers and Orders customer IDs (no duplicates)
SELECT customer_id FROM Customers
UNION
SELECT customer_id FROM Orders;
```

**Purpose:** Combines customers who exist in either Customers or Orders.

---

```sql
-- UNION: Combine customer names and employee names
SELECT first_name AS name FROM Customers
UNION
SELECT employee_name FROM Employees;
```

**Purpose:** Produces a distinct list of all people (customers + employees).

---

```sql
-- Customers who shopped from either Men or Women categories (distinct)
SELECT customer_id
FROM orders
WHERE category = 'Men'
UNION
SELECT customer_id
FROM orders
WHERE category = 'Women';
```

**Purpose:** Ensures unique list of customers shopping from at least one of the two categories.

---

```sql
-- Customers who shopped Men or Women categories, with details (no duplicates)
SELECT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.category = 'Men'

UNION

SELECT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.category = 'Women';
```

**Purpose:** Customer details for Men/Women category purchases (distinct list).

---

```sql
-- Customers who shopped Men or Women categories (duplicates allowed)
SELECT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.category = 'Men'

UNION ALL

SELECT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.category = 'Women';
```

**Purpose:** Shows all occurrences (duplicates included).

---

## INTERSECT (simulated)

```sql
-- INTERSECT simulated: Customers who are in both Customers and Orders
SELECT customer_id FROM Customers
WHERE customer_id IN (SELECT customer_id FROM Orders);
```

**Purpose:** Find customers who exist in Orders.

---

```sql
-- USA customers who have placed at least one order
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
WHERE c.country = 'USA';
```

**Purpose:** Restricts INTERSECT logic to USA customers.

---

```sql
-- INTERSECT vs INNER JOIN demonstration
SELECT c.customer_id, c.first_name, c.country,
       o.order_id, o.amount
FROM Customers c
INNER JOIN Orders o 
    ON c.customer_id = o.customer_id
WHERE c.country = 'USA';
```

**Explanation:** INNER JOIN shows customer + order details.
**Purpose:** Compare with INTERSECT approach (which only returns IDs).

---

```sql
-- Customers who purchased from both Men and Women categories
SELECT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.category IN ('Men', 'Women')
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT o.category) = 2;
```

**Purpose:** Simulates INTERSECT by finding customers in both sets.

---

## EXCEPT (simulated)

```sql
-- Customers with no orders (NOT IN)
SELECT customer_id, first_name
FROM Customers
WHERE customer_id NOT IN (SELECT customer_id FROM Orders);
```

```sql
-- Customers with no orders (LEFT JOIN IS NULL)
SELECT c.customer_id, c.first_name, c.last_name, c.country
FROM Customers c
LEFT JOIN Orders o 
       ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;
```

**Purpose:** Both simulate EXCEPT, showing customers not present in Orders.

---

```sql
-- USA customers with no orders
SELECT c.customer_id, c.first_name, c.last_name, c.country
FROM Customers c
LEFT JOIN Orders o 
       ON c.customer_id = o.customer_id
WHERE c.country = 'USA'
  AND o.customer_id IS NULL;
```

**Purpose:** Filter EXCEPT logic by country.

---

```sql
-- Customers with Men orders but no Women orders
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
```

**Purpose:** Simulates EXCEPT to find customers exclusive to Men category.
