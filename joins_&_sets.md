# SQL Joins & Set Operations Documentation

*(with examples from `company_db`)*

---

## 1. JOIN with OR vs UNION

### Query:

```sql
SELECT DISTINCT c.customer_id, c.first_name, c.last_name, o.category
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.category = 'Men' OR o.category = 'Women';
```

**Explanation:**

* This uses a **JOIN** between `Customers` and `Orders`.
* The `WHERE` filters rows where the order is either **Men’s** or **Women’s**.
* `DISTINCT` removes duplicates in case a customer ordered both.

Output = Customers (with details) who bought at least one Men’s OR Women’s product.

---

### Equivalent with UNION

```sql
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

**Explanation:**

* First query gets Men’s customers.
* Second query gets Women’s customers.
* `UNION` merges them → removes duplicates.

Same result, but expressed with set operation.

---

##  2. UNION vs UNION ALL

### Example:

```sql
-- UNION
SELECT c.customer_id, c.first_name, c.last_name
FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.category = 'Men'
UNION
SELECT c.customer_id, c.first_name, c.last_name
FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.category = 'Women';
```

 Deduplicated list:
`{2, 5, 7, 19, 24, ...}`

---

```sql
-- UNION ALL
SELECT c.customer_id, c.first_name, c.last_name
FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.category = 'Men'
UNION ALL
SELECT c.customer_id, c.first_name, c.last_name
FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.category = 'Women';
```

 Keeps duplicates:
`{2, 2, 5, 5, 7, 7, 19, 19, 24, 24, ...}`

 **Rule of Thumb:**

* Use **UNION** when you want a distinct list.
* Use **UNION ALL** when duplicates are meaningful (like counting frequency).

---

##  3. FULL JOIN (Simulated in MySQL)

```sql
SELECT c.customer_id, c.first_name, o.order_id, o.amount
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id

UNION

SELECT c.customer_id, c.first_name, o.order_id, o.amount
FROM Customers c
RIGHT JOIN Orders o ON c.customer_id = o.customer_id;
```

 **Explanation:**

* MySQL doesn’t support FULL JOIN directly.
* We simulate by combining **LEFT JOIN** and **RIGHT JOIN** with `UNION`.
* This ensures we see:

  * Customers with no orders (`order_id = NULL`),
  * Orders with no matching customer (`customer_id = NULL`),
  * And all valid matches.

---

##  4. INTERSECT (Customers who ordered both Men’s and Women’s)

### Using JOIN

```sql
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN Orders o1 ON c.customer_id = o1.customer_id AND o1.category = 'Men'
JOIN Orders o2 ON c.customer_id = o2.customer_id AND o2.category = 'Women';
```

 **Explanation:**

* Join Orders twice → one filtered on Men, one on Women.
* Only customers appearing in both categories are returned.

---

### Using INTERSECT

```sql
SELECT customer_id FROM Orders WHERE category = 'Men'
INTERSECT
SELECT customer_id FROM Orders WHERE category = 'Women';
```

 **Explanation:**

* Men’s list ∩ Women’s list = customers common to both.
* Only customer IDs are returned.

---

##  5. EXCEPT (Customers who ordered Men’s but NOT Women’s)

### Using EXCEPT

```sql
SELECT customer_id FROM Orders WHERE category = 'Men'
EXCEPT
SELECT customer_id FROM Orders WHERE category = 'Women';
```

 **Explanation:**

* Take Men’s list, subtract those also in Women’s list.
* Output = customers who only bought Men’s products.

---

### Equivalent Using JOIN + NOT EXISTS

```sql
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id AND o.category = 'Men'
WHERE NOT EXISTS (
    SELECT 1 FROM Orders o2
    WHERE o2.customer_id = c.customer_id AND o2.category = 'Women'
);
```

 **Explanation:**

* Select customers with Men’s orders.
* Exclude those who have any Women’s orders.
* Same logic as `EXCEPT`, but allows returning full customer details.

---

##  6. Invalid Queries (for learning)

In your provided list, you had:

```sql
SELECT * FROM Customers
UNION
SELECT * FROM Orders;
```

 This fails because:

* `Customers` has 5 columns.
* `Orders` has 4 columns.
* `UNION` requires same number + compatible datatypes.

 **Lesson:** Always match number of columns & types.

---

#  Summary Table

| Operation     | Purpose                      | Deduplication                     | Example in our DB                                     |
| ------------- | ---------------------------- | --------------------------------- | ----------------------------------------------------- |
| **JOIN**      | Combine columns (horizontal) | N/A                               | Customers + Orders with details                       |
| **UNION**     | Combine rows (vertical)      | Removes duplicates                | Men’s customers ∪ Women’s customers                   |
| **UNION ALL** | Combine rows (vertical)      | Keeps duplicates                  | Men’s customers + Women’s customers (with duplicates) |
| **INTERSECT** | Common rows                  | Keeps only intersection           | Customers who ordered both Men’s & Women’s            |
| **EXCEPT**    | Difference                   | Keeps only in first not in second | Customers who ordered Men’s but not Women’s           |
| **FULL JOIN** | All rows from both sides     | N/A                               | All Customers + Orders (even unmatched)               |

