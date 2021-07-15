/* 
International Breweries Data exploration 

skills used: Aggregate function, advanced filtering operators

*/


select *
From International_Breweries$


--PROFIT ANALYSIS--

-- Within the space of the last three years, what was the profit worth of the breweries, inclusive of the anglophone and the francophone territories?
Select SUM(PROFIT)
FROM International_Breweries$
WHERE YEARS IN (2017, 2018, 2019)

--Comparing the total profit between these two territories
SELECT SUM(PROFIT)
FROM International_Breweries$
WHERE COUNTRIES IN ('Ghana', 'Nigeria')

SELECT SUM(PROFIT)
FROM International_Breweries$
WHERE COUNTRIES IN('Togo', 'Benin', 'Senegal')

--Country that generated the highest profit in 2019
SELECT COUNTRIES, SUM(PROFIT) AS HIGHEST_PROFIT
FROM International_Breweries$
WHERE YEARS = 2019
GROUP BY COUNTRIES
ORDER BY 2 DESC

--Which month in the three years were the least profit generated
SELECT COUNTRIES, MONTHS, YEARS, MIN(PROFIT) LEAST_PROFIT
FROM International_Breweries$
GROUP BY COUNTRIES, MONTHS, YEARS
ORDER BY 4

--Comparing the profit in percentage for each of the month in 2019
SELECT MONTHS, PROFIT into TotalProfit
FROM International_Breweries$
WHERE YEARS = 2019

SELECT MONTHS, ROUND((SUM(PROFIT) / (SELECT SUM(PROFIT) FROM TotalProfit)) *100,2) as PERCENTAGE
FROM International_Breweries$
WHERE YEARS = 2019
GROUP BY MONTHS
ORDER BY 2 DESC

-- Which particular brand generated the highest profit in Senegal
Select BRANDS, SUM(PROFIT) AS HIGHEST_PROFIT
FROM International_Breweries$
WHERE COUNTRIES = 'Senegal'
GROUP BY BRANDS
ORDER BY 2 DESC



--BRAND ANALYSIS--

--Top 3 Brands consumed in the francophone countries within the last two years
SELECT TOP 3(BRANDS), SUM(QUANTITY) AMOUNT_CONSUMED
FROM International_Breweries$
WHERE COUNTRIES in ('Senegal', 'Benin', 'Togo')
GROUP BY BRANDS
ORDER BY 2 DESC

-- The top two choice of consumer brands in Ghana
SELECT TOP 2(BRANDS), SUM(QUANTITY) AS CONSUMER_CHOICE
FROM International_Breweries$
WHERE COUNTRIES = 'Ghana'
GROUP BY BRANDS
ORDER BY 2 DESC

-- Favorites malt brand in Anglophone region between 2018 and 2019
SELECT BRANDS, SUM(QUANTITY) as TOTAL_QUANTITY
FROM International_Breweries$
WHERE YEARS IN (2018, 2019) AND COUNTRIES IN ('Nigeria', 'Ghana') AND BRANDS LIKE '%malt%'
GROUP BY BRANDS
ORDER BY 2 DESC



--COUNTRY ANALYSIS--

-- The country with the highest consumption of beer.
SELECT COUNTRIES, BRANDS, SUM(QUANTITY) as AMOUNT_CONSUMED
FROM International_Breweries$
WHERE BRANDS NOT LIKE '%malt%'
GROUP BY COUNTRIES, BRANDS
ORDER BY 3 DESC

--Highest sales personnel of Budweiser brand in Senegal
SELECT SALES_REP, SUM(QUANTITY) as AMOUNT_SOLD
FROM International_Breweries$
WHERE BRANDS = 'budweiser' AND COUNTRIES = 'Senegal'
GROUP BY SALES_REP
ORDER BY 2 DESC
