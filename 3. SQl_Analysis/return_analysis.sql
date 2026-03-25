# quantity return status
SELECT 
SUM(order_quantity) AS quantity, 
return_status 
FROM orders
group by return_status;

# total returned quantity and ordered
SELECT 
SUM(CASE WHEN return_date IS NOT NULL THEN order_quantity ELSE 0 END) AS total_returned_quantity,
SUM(order_quantity) AS total_quantity_ordered,
ROUND(SUM(CASE WHEN return_date IS NOT NULL THEN order_quantity ELSE 0 END) * 1.0/SUM(order_quantity) * 100, 2) AS return_rate_percentage
FROM orders;

# Quantity Return Rate by Category
SELECT product_category,
SUM(order_quantity) AS total_quantity_ordered,
SUM(CASE WHEN return_date IS NOT NULL THEN order_quantity ELSE 0 END) AS total_returned_quantity,
ROUND(SUM(CASE WHEN return_date IS NOT NULL THEN order_quantity ELSE 0 END) * 1.0/SUM(order_quantity) *100, 2) AS return_rate_percentage
FROM orders
GROUP BY product_category
ORDER BY return_rate_percentage DESC;

# total return of orders city wise with return percentage
SELECT user_location,
COUNT(*) AS total_orders,
COUNT(CASE WHEN return_date IS NOT NULL THEN 1 END) AS total_returned_orders,
ROUND( COUNT(CASE WHEN return_date IS NOT NULL THEN 1 END) * 1.0 / COUNT(*) * 100, 2) AS return_rate_percentage
FROM orders
GROUP BY user_location
ORDER BY return_rate_percentage DESC;

# total return category wise
SELECT product_category,
SUM(order_quantity) AS total_returns
FROM orders
WHERE return_date is not null
GROUP BY product_category
ORDER BY total_returns DESC
LIMIT 10;

# buyed product and return product avg_price
SELECT 
SUM(order_quantity) AS quantity, 
ROUND(AVG(product_price),2) AS avg_price,
return_status
FROM orders
group by return_status;

# return of order with specific range wise
SELECT 
CASE WHEN product_price < 203 THEN '0 - 202'
     WHEN product_price BETWEEN 203 AND 303 THEN '203 - 303'
     ELSE 'more than 303'
END AS price_range,
COUNT(*) AS total_orders,
COUNT(CASE WHEN return_date IS NOT NULL THEN 1 END) AS returned_orders,
ROUND( COUNT(CASE WHEN return_date IS NOT NULL THEN 1 END) * 1.0 /COUNT(*) * 100, 2) AS return_rate
FROM orders
GROUP BY price_range;

# Revenue Impact Analysis
SELECT product_category,
SUM(product_price * order_quantity) AS total_revenue,
SUM(CASE 
        WHEN return_date IS NOT NULL 
        THEN product_price * order_quantity 
        ELSE 0 
    END) AS returned_revenue,
ROUND( SUM(CASE WHEN return_date IS NOT NULL THEN product_price * order_quantity ELSE 0 END) * 1.0/ SUM(product_price * order_quantity) * 100, 2) AS revenue_return_rate
FROM orders
GROUP BY product_category
ORDER BY revenue_return_rate DESC;

# Monthly / Time Trend Analysis
SELECT 
strftime('%m', order_date) AS month,
COUNT(*) AS total_orders,
SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) AS total_returns,
ROUND( SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) * 1.0/ COUNT(*) * 100, 2) AS return_rate
FROM orders
GROUP BY month
ORDER BY month;

# total orders behalf on order quantity
SELECT order_quantity,
COUNT(*) AS total_orders,
SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) AS total_returns,
ROUND( SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) * 1.0/ COUNT(*) * 100, 2) AS return_rate
FROM orders
GROUP BY order_quantity
ORDER BY order_quantity;

# return based on discount on order
SELECT 
CASE 
    WHEN discount_applied < 10 THEN 'Below 10%'
    WHEN discount_applied BETWEEN 10 AND 30 THEN '10% - 30%'
    ELSE 'above 30%'
END AS discount_range,
COUNT(*) AS total_orders,
SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) AS returns,
ROUND( SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) * 1.0/ COUNT(*) * 100, 2) AS return_rate
FROM orders
GROUP BY discount_range;

# order based on quantity group
SELECT 
CASE 
    WHEN order_quantity = 1 THEN '1 Item'
    WHEN order_quantity BETWEEN 2 AND 3 THEN '2 - 3 Items'
    ELSE '4 - 5 Items'
END AS quantity_group,
COUNT(*) AS total_orders,
SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) AS total_returns,
ROUND( SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) * 1.0/ COUNT(*) * 100, 2) AS return_rate
FROM orders
GROUP BY quantity_group;

# Return Rate by Gender
SELECT user_gender,
COUNT(*) AS total_orders,
SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) AS total_returns,
ROUND( SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) * 1.0/ COUNT(*) * 100, 2) AS return_rate
FROM orders
GROUP BY user_gender
ORDER BY return_rate DESC;

# Return Rate by Age Group
SELECT 
CASE 
    WHEN user_age < 25 THEN 'Under 25'
    WHEN user_age BETWEEN 25 AND 40 THEN '25-40'
    ELSE '40+'
END AS age_group,
COUNT(*) AS total_orders,
SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) AS total_returns,
ROUND( SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) * 1.0/ COUNT(*) * 100, 2) AS return_rate
FROM orders
GROUP BY age_group
ORDER BY total_orders;

# Return Rate by Payment Method
SELECT payment_method,
COUNT(*) AS total_orders,
SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) AS total_returns,
ROUND( SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) * 1.0/ COUNT(*) * 100, 2) AS return_rate
FROM orders
GROUP BY payment_method
ORDER BY return_rate DESC;

# Return Rate by Shipping Method
SELECT shipping_method,
COUNT(*) AS total_orders,
SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) AS total_returns,
ROUND( SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) * 1.0/ COUNT(*) * 100, 2) AS return_rate
FROM orders
GROUP BY shipping_method
ORDER BY return_rate DESC;

# Discount Impact on Returns
SELECT 
CASE 
    WHEN discount_applied = 0 THEN 'No Discount'
    WHEN discount_applied BETWEEN 1 AND 5 THEN 'Low Discount (1-5%)'
    WHEN discount_applied BETWEEN 6 AND 10 THEN 'Mild Discount (6-10%)'
    WHEN discount_applied BETWEEN 10 AND 20 THEN 'Medium Discount (11-20%)'
    ELSE 'High Discount'
END AS discount_group ,
COUNT(*) AS total_orders,
SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) AS total_returns,
ROUND( SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) * 1.0/ COUNT(*) * 100, 2) AS return_rate
FROM orders
GROUP BY discount_group
ORDER BY total_returns DESC;

# Return Reason Analysis
SELECT return_reason,
COUNT(*) AS total_returns
FROM orders
WHERE return_date IS NOT NULL
GROUP BY return_reason
ORDER BY total_returns DESC;

# Days to Return Analysis
SELECT 
CASE 
    WHEN days_to_return <= 10 THEN 'Quick Return'
    WHEN days_to_return BETWEEN 11 AND 30 THEN 'Medium'
    ELSE 'Late Return'
END AS return_speed,
COUNT(*) AS total_returns
FROM orders
WHERE return_date IS NOT NULL
GROUP BY return_speed;

# Return Probability Indicators
SELECT discount_applied,
order_quantity,
COUNT(*) AS total_orders,
SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) AS returns
FROM orders
GROUP BY discount_applied, order_quantity
ORDER BY returns DESC;

# return rate based on category and gender
SELECT product_category, user_gender,
COUNT(*) AS total_orders,
SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) AS total_returns,
ROUND( SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) * 1.0/ COUNT(*) * 100, 2) AS return_rate
FROM orders
GROUP BY product_category, user_gender
ORDER BY product_category asc, user_gender desc;