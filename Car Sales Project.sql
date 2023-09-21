create schema cars;
use cars;
-- read data --
select*from car_sales;
-- Total Cars: to get a count of total records --
select count(*) from car_sales;
-- How many cars will be available in 2023?--
select count(*) from car_sales where year= 2023;
-- How many cars will be available in 2020,2021,2022?--
select count(*) from car_sales where year=2020;
select count(*) from car_sales where year=2021;
select count(*) from car_sales where year=2022;

select count(*) from car_sales where year in ( 2020, 2021, 2022) group by year ;
-- print the total cars by year except the details --
select year,count(*) from car_sales group by year;
-- How many diesel cars will be there in 2023?--
select count(*) from car_sales where year = 2020 and fuel = "Diesel";#4
-- How many petrol cras will be there in 2023?;--
select count(*) from car_sales where year = 2020 and fuel = "Petrol";#51
-- Print all the fuel cars(Petrol,CNG,Diesel) by year--
SELECT year, fuel, COUNT(*) 
FROM car_sales 
WHERE fuel IN ('Petrol', 'Diesel', 'CNG')
GROUP BY year, fuel
LIMIT 0, 1000;
-- There were more than 100 cars in given year , which year had more than 100 cars --
SELECT year, COUNT(*) AS car_count
FROM car_sales
GROUP BY year
HAVING car_count > 100;
-- Which year had less than 50 cars --
SELECT year, COUNT(*) as car_count
FROM car_sales
GROUP BY year
HAVING car_count <50;
-- a complete list of  all cars count details between 2015 and 2023 --
SELECT COUNT(*)
FROM car_sales
WHERE year BETWEEN 2015 AND 2023; 
 #4124
 -- We need all the cars details between 2015 and 2023; --
 SELECT * from car_sales
WHERE year BETWEEN 2015 AND 2023;

                                         -- End

