select * from sales_data_sample;
 
-- Checking unique values

select distinct status from sales_data_sample;
select distinct YEAR_ID from sales_data_sample;
select distinct PRODUCTLINE from sales_data_sample;
select distinct country from sales_data_sample;
select distinct DEALSIZE from sales_data_sample;
select distinct TERRITORY from sales_data_sample;


select distinct MONTH_ID from [dbo].[sales_data_sample]
where YEAR_ID = 2003;


-- analysis
-- Grouping sales by productline
select  ProductLine ,sum(sales)Revenue
from [dbo].[sales_data_sample]
Group by PRODUCTLINE
ORDER BY 2 desc;

select  DEALSIZE,sum(sales)Revenue
from [dbo].[sales_data_sample]
Group by DEALSIZE
ORDER BY 2 desc;



--- What was the best month for sales in a specific year? How much was earned that month?

SELECT MONTH_ID , SUM(sales)Revenue, count(ORDERNUMBER)frequency
FROM[dbo].[sales_data_sample]
WHERE YEAR_ID = 2004
GROUP BY MONTH_ID
ORDER BY 2 DESC;

--- who could be the best customer?(This could be answer with RFM) ---

--- RFM
--- Recency   : How long ago their last purchase was (Last Order Date)
--- Frequency : How often they purchase (Count of total orders)
--- Monetary  : How much they spent  (Total spend)


DROP TABLE IF EXISTS #rfm
;with rfm as 
(
	select 
		CUSTOMERNAME, 
		sum(sales) MonetaryValue,
		avg(sales) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,
		max(ORDERDATE) last_order_date,
		(select max(ORDERDATE) from [dbo].[sales_data_sample]) max_order_date,
		DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from [dbo].[sales_data_sample])) Recency
	from [sales].[dbo].[sales_data_sample]
	group by CUSTOMERNAME
),
rfm_calc as
(

	select r.*,
		NTILE(4) OVER (order by Recency desc) rfm_recency,
		NTILE(4) OVER (order by Frequency) rfm_frequency,
		NTILE(4) OVER (order by MonetaryValue) rfm_monetary
	from rfm r
)
select 
	c.*, rfm_recency+ rfm_frequency+ rfm_monetary as rfm_cell,
	cast(rfm_recency as varchar) + cast(rfm_frequency as varchar) + cast(rfm_monetary  as varchar)rfm_cell_string
into #rfm
from rfm_calc c

select CUSTOMERNAME , rfm_recency, rfm_frequency, rfm_monetary,
	case 
		when rfm_cell_string in (111, 112 , 121, 122, 123, 132, 211, 212, 114, 141) then 'lost_customers'  --lost customers
		when rfm_cell_string in (133, 134, 143, 244, 334, 343, 344, 144) then 'slipping away, cannot lose' -- (Big spenders who haven’t purchased lately) slipping away
		when rfm_cell_string in (311, 411, 331) then 'new customers'
		when rfm_cell_string in (222, 223, 233, 322) then 'potential churners'
		when rfm_cell_string in (323, 333,321, 422, 332, 432) then 'active' --(Customers who buy often & recently, but at low price points)
		when rfm_cell_string in (433, 434, 443, 444) then 'loyal'
	end rfm_segment

from #rfm

--What products are most often sold together? 
--select * from [dbo].[sales_data_sample] where ORDERNUMBER =  10411

select distinct OrderNumber, stuff(

	(select ',' + PRODUCTCODE
	from [dbo].[sales_data_sample] p
	where ORDERNUMBER in 
		(

			select ORDERNUMBER
			from (
				select ORDERNUMBER, count(*) rn
				FROM [sales].[dbo].[sales_data_sample]
				where STATUS = 'Shipped'
				group by ORDERNUMBER
			)m
			where rn = 3
		)
		and p.ORDERNUMBER = s.ORDERNUMBER
		for xml path (''))

		, 1, 1, '') ProductCodes

from [dbo].[sales_data_sample] s
order by 2 desc


---EXTRAs----
--What city has the highest number of sales in a specific country?---
SELECT city, sum(sales) AS Revenue
FROM [sales].[dbo].[sales_data_sample]
WHERE country = 'UK'
GROUP BY city 
ORDER BY Revenue  desc

---What is the best product in United States?
SELECT PRODUCTLINE, YEAR_ID , country ,SUM(sales) AS total_revenue
FROM [sales].[dbo].[sales_data_sample]
WHERE country = 'USA'
GROUP BY PRODUCTLINE , YEAR_ID, country
ORDER BY total_revenue DESC


