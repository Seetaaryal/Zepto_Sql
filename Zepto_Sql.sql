--- count of rows
select
	count(*)
from [dbo].[zepto];

-- sample data
select * from [dbo].[zepto];

-- null values
select * from [dbo].[zepto]
where Category is null
or
name is null
or
mrp is null
or
discountPercent is null
or
availableQuantity is null
or
discountedSellingPrice is null
or
weightInGms	is null
or
outOfStock is null
or
quantity is null;

-- different product categories
select 
	distinct(category)
from [dbo].[zepto]
order by category;

-- products in stock vs out of stock

select
	outofstock,
	count(sku_id)
from [dbo].[zepto]
group by outOfStock;

-- product names presnet multiple times
select
	name,
	count(sku_id) as "Number of Skus"
From [dbo].[zepto]
group by name
Having count(sku_id) >1
Order by count(sku_id) Desc;

-- data cleaning

-- products with price = 0

select * 
from [dbo].[zepto]
where mrp = 0 or discountedSellingPrice = 0;

Delete from [dbo].[zepto]
where mrp = 0;

--convert paise to rupees

update [dbo].[zepto]
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

select 
	mrp,
	discountedSellingPrice
from [dbo].[zepto];


-- Find the top 10 best-value products based on the discounted perecentage.

SELECT DISTINCT TOP 10
	name, mrp, discountPercent
FROM [dbo].[zepto]
ORDER BY discountPercent DESC;


-- What are the products with High MRP but out of stock?

SELECT DISTINCT name, mrp, discountPercent
FROM [dbo].[zepto]
WHERE outOfStock = 1 AND mrp > 300
ORDER BY mrp DESC;

SELECT  name, mrp, discountPercent
FROM [dbo].[zepto]
WHERE outOfStock = 1 AND mrp > 300
ORDER BY mrp DESC;

-- calculate estimated revenue for each category
Select category,
sum(discountedSellingPrice * availableQuantity) As total_revenue
from [dbo].[zepto]
group by Category
order by total_revenue;

-- Find all products where MRP is greater than 500 and idscount is less than 10%

select distinct name, mrp, discountPercent
from zepto
where mrp > 500 And discountPercent < 10
order by mrp desc, discountPercent desc;

-- Identify the top 5 categories offering the highest average discount percentage.

select top 5
	category,
ROUND(avg(discountPercent),2) As avg_discount
from [dbo].[zepto]
group by category
order by avg_discount desc;

-- Find the price per gram for products above 100g and sort by best value.
select distinct name, weightInGms, discountedSellingPrice,
round(discountedSellingPrice/weightInGms,2) As price_per_gram
From [dbo].[zepto]
Where weightInGms >= 100
Order by price_per_gram;

-- Group the products into categories like low, Medium, bulk.
select distinct name, discountedSellingPrice,
case when discountedSellingPrice < 1000 then 'Low'
	when discountedSellingPrice < 5000 then 'Medium'
	Else 'Bulk'
	End as weight_category
From [dbo].[zepto];

-- What is the total inventory weight per category

select category,
sum(weightInGms * availableQuantity) as total_weight
from [dbo].[zepto]
group by category
order by total_weight;