# Need for Joins

In relational databases, data is often stored in multiple tables to avoid redundancy. To analyze or fetch meaningful results, we need to combine data from these tables. **Joins** allow us to retrieve data that is spread across multiple related tables using foreign key relationships.

---

## INNER JOIN

**Definition:**
Returns only the rows where there is a match in both tables based on the join condition.

**Example:** Get all customers who have placed an order.

```sql
SELECT c.customer_id, c.first_name, c.last_name, o.order_id, o.amount
FROM Customers c
INNER JOIN Orders o
       ON c.customer_id = o.customer_id;
```

**Explanation:**
Only customers with matching rows in `Orders` are returned. Customers without orders are excluded.

---

## LEFT JOIN

**Definition:**
Returns all rows from the left table, and the matching rows from the right table. If there is no match, NULL is returned for columns from the right table.

**Example:** Get all customers and their orders (if any).

```sql
SELECT c.customer_id, c.first_name, o.order_id, o.amount
FROM Customers c
LEFT JOIN Orders o
       ON c.customer_id = o.customer_id;
```

**Explanation:**
All customers are included. If a customer did not place an order, order details will appear as NULL.

---

## RIGHT JOIN

**Definition:**
Returns all rows from the right table, and the matching rows from the left table. If there is no match, NULL is returned for columns from the left table.

**Example:** Get all orders and their customers.

```sql
SELECT o.order_id, o.amount, c.first_name, c.last_name
FROM Customers c
RIGHT JOIN Orders o
       ON c.customer_id = o.customer_id;
```

**Explanation:**
All orders are included. If an order has no customer (rare in this schema), customer details would be NULL.

---

## CROSS JOIN

**Definition:**
Returns the Cartesian product of the two tables. Each row from the first table is combined with every row from the second table.

**Example:** Combine every customer with every order (not practical, but demonstrates CROSS JOIN).

```sql
SELECT c.first_name, o.order_id
FROM Customers c
CROSS JOIN Orders o;
```

**Explanation:**
If there are 25 customers and 25 orders, result will have 25 × 25 = 625 rows.

---

## SELF JOIN

**Definition:**
A table is joined with itself. Useful for hierarchical or recursive relationships.

**Example:** Show each employee and their manager’s name.

```sql
SELECT e.employee_name AS Employee,
       m.employee_name AS Manager
FROM Employees e
LEFT JOIN Employees m
       ON e.manager_id = m.employee_id;
```

**Explanation:**
The `Employees` table is joined with itself. Managers are also employees, so self join is required.

---

# Set Operations

SQL provides set operations to combine results of multiple queries.
Note: MySQL supports **UNION** and **UNION ALL** directly. `INTERSECT` and `EXCEPT` are not supported, but can be simulated.

---

## UNION

**Definition:**
Combines the results of two queries and removes duplicates.

**Example:** Get list of all distinct cities where customers live or orders exist (assume Orders table had a city field).

```sql
SELECT city FROM Customers
UNION
SELECT 'New York' AS city;
```

---

## UNION ALL

**Definition:**
Combines results of two queries but keeps duplicates.

**Example:**

```sql
SELECT city FROM Customers
UNION ALL
SELECT 'New York' AS city;
```

**Explanation:**
If `New York` already exists in Customers, UNION ALL will include it again, while UNION would remove the duplicate.

---

## INTERSECT (Simulated in MySQL)

**Definition:**
Returns rows that are common to both queries.
MySQL does not support INTERSECT directly, but it can be simulated using `INNER JOIN`.

**Example:** Customers who placed both Men and Women category orders.

```sql
SELECT DISTINCT c.customer_id, c.first_name
FROM Customers c
JOIN Orders o1 ON c.customer_id = o1.customer_id AND o1.category = 'Men'
JOIN Orders o2 ON c.customer_id = o2.customer_id AND o2.category = 'Women';
```

---

## EXCEPT (Simulated in MySQL)

**Definition:**
Returns rows from the first query that are not present in the second query.
MySQL does not support EXCEPT directly, but it can be simulated using `LEFT JOIN … IS NULL` or `NOT IN`.

**Example:** Customers who placed Men’s orders but not Women’s orders.

```sql
SELECT DISTINCT c.customer_id, c.first_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id AND o.category = 'Men'
WHERE c.customer_id NOT IN (
    SELECT customer_id FROM Orders WHERE category = 'Women'
);
```

---

## FULL JOIN (Simulated in MySQL)

**Definition:**
Returns all rows when there is a match in either left or right table. Equivalent to UNION of LEFT JOIN and RIGHT JOIN.
MySQL does not support FULL JOIN directly.

**Example:** Customers and their orders, including customers without orders and orders without customers.

```sql
SELECT c.customer_id, c.first_name, o.order_id, o.amount
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
UNION
SELECT c.customer_id, c.first_name, o.order_id, o.amount
FROM Customers c
RIGHT JOIN Orders o ON c.customer_id = o.customer_id;
```

---

# Summary Table

| Concept    | Returns                                 | MySQL Support      |
| ---------- | --------------------------------------- | ------------------ |
| INNER JOIN | Rows with matches in both tables        | Supported          |
| LEFT JOIN  | All rows from left + matches from right | Supported          |
| RIGHT JOIN | All rows from right + matches from left | Supported          |
| CROSS JOIN | Cartesian product of two tables         | Supported          |
| SELF JOIN  | Join table with itself (hierarchies)    | Supported          |
| UNION      | Combines results, removes duplicates    | Supported          |
| UNION ALL  | Combines results, keeps duplicates      | Supported          |
| INTERSECT  | Common rows in both queries             | Simulate with JOIN |
| EXCEPT     | Rows in first query not in second       | Simulate           |
| FULL JOIN  | All rows from both tables               | Simulate           |
