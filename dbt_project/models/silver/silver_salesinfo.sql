WITH sales AS (

    SELECT 
    store_sk,
    customer_sk,
    {{multiply_columns('quantity', 'unit_price') }} AS calculated_gross_amount,
    payment_method,
    product_sk
    FROM {{ref('bronze_sales') }}
),

stores AS (

    SELECT
    store_sk,
    store_name
    FROM {{ref('bronze_store') }}
),

products AS (

    SELECT
    product_sk,
    product_name,
    department,
    category
    FROM {{ref('bronze_product') }}
),

customer AS (

    SELECT
    customer_sk,
    gender,
    loyalty_tier
    FROM {{ref('bronze_customer') }}
),

joined_query AS (
SELECT 

    sales.store_sk,
    sales.customer_sk,
    sales.calculated_gross_amount,
    sales.product_sk,
    products.category,
    customer.gender,
    customer.loyalty_tier

    FROM sales
    JOIN products ON sales.product_sk = products.product_sk
    JOIN customer ON sales.customer_sk = customer.customer_sk 
)

SELECT
    category,
    gender,
    sum(calculated_gross_amount) AS total_sales,
    loyalty_tier
    
    FROM joined_query
    GROUP BY category, gender, loyalty_tier
    ORDER BY total_sales DESC