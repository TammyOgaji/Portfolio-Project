--PROFIT ANALYSIS

select *
From International_Breweries$

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