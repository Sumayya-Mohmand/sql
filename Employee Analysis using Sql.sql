select * from employee;
-- find out the distribution of educational qualifications among employees --
SELECT Education, COUNT(*) AS Count
FROM employee
GROUP BY Education;

-- Analyze how the length of service (Joining Year) varies across different cities --

SELECT City, MIN(JoiningYear) AS EarliestJoiningYear, MAX(JoiningYear) AS LatestJoiningYear
FROM employee
GROUP BY City;

-- What is the gender distribution within the workforce? --
SELECT Gender, COUNT(*) AS Count
FROM employee
GROUP BY Gender;

-- What is the average length of time employees have been with the company ?-- 

SELECT AVG(YEAR(CURRENT_DATE()) - JoiningYear) AS AverageTenure
FROM employee;

-- What is the average, Minimum and Maximum  age of employees in the company ? --

SELECT AVG(Age) AS AverageAge, MIN(Age) AS MinimumAge, MAX(Age) AS MaximumAge
FROM employee;
-- What is the average number of years of experience employees have in their current domain or field? --
select avg (ExperienceinCurrentDomain) as AvgEmployeeExperience
from employee;

-- What is  the distribution of employees across different payment tiers or Salary bands? --

SELECT PaymentTier, COUNT(*) AS EmployeeCount
FROM employee
GROUP BY PaymentTier
ORDER BY PaymentTier;

-- Determine the rate at which employees take leaves. --

SELECT (COUNT(CASE WHEN LeaveOrNot = 1 THEN 1 END) / COUNT(*)) * 100 AS LeaveRate
FROM employee;

                      -- End 