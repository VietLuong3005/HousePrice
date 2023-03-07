select * from raw_sales

-- Which date corresponds to the highest number of sales?
select datesold, count (*) as number_of_sales
from raw_sales
group by datesold
order by number_of_sales desc

--Find out the postcode with the highest average price per sale?
select postcode, avg(price) as avg_price
from raw_sales
group by postcode
order by avg(price) desc

-- Which year witnessed the lowest number of sales?
select year(datesold) as year, count(*) as number_of_sales
from raw_sales
group by year(datesold)
order by number_of_sales asc

-- Use the window function to deduce the top six postcodes by year's price.
select year(datesold) as year, postcode, price,
         dense_rank() over (partition by year(datesold), postcode order by price desc) rnk
into #sales2
from raw_sales


select r.year, r.postcode, r.price
from(
    select *,
    row_number() over (partition by year order by price desc) row_num
    from #sales2
    where rnk < 2) r
where r.row_num between 1 and 6