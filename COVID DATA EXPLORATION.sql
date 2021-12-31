SELECT *
FROM PortfolioProject..CovidDeaths$
where continent IS NOT NULL
order by 3, 4

SELECT *
FROM PortfolioProject..CovidVaccinations$
order by 3, 4

-- OVERVIEW OF THE DATA

select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths$
where continent IS NOT NULL
order by 1,2

-- Examining the Total cases vs Total Deaths
-- Percentage of death when you get infected with the virus
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where location like '%canada%' and continent IS NOT NULL
order by 1, 2


--Examining the Total Cases vs Population
-- Identifies the percentage of population infected 
SELECT location, date, population, total_cases, (total_cases/population)*100 as ContactPercentage
from PortfolioProject..CovidDeaths$
where location like '%canada%'
order by 1, 2


-- Examining countries with Highest infection rate against population

SELECT location, population, MAX(total_cases) as MaxInfectionCount, MAX((total_cases/population))*100 as PercentageInfected
from PortfolioProject..CovidDeaths$
--where location like '%canada%'
group by population, location
order by 4 desc

-- Examining countries with highest death count per population

select location, population,MAX(cast(total_deaths as int)) as MaxDeathCount, MAX((total_deaths/population))*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent IS NOT NULL
group by location, population
order by 3 desc


--EXAMINING BY CONTINENT
-- EXAMINING CONTINENTS WITH MOST DEATH COUNT

select location, MAX(cast(total_deaths as int)) as MaxDeathCount, MAX((total_deaths/population))*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent IS NULL
group by location
order by 2 desc


-- GLOBAL EXPLORATION
-- Overview of global numbers by cases and deaths
SELECT SUM(new_cases)AS TotalCasesPerDay, SUM(cast(new_deaths as int)) AS TotalDeathsPerDay, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Global_DeathPercentage
from PortfolioProject..CovidDeaths$
WHERE continent IS NOT NULL
order by 1, 2

-- Exploring Global cases daily by date and death percentage
SELECT date, SUM(new_cases)AS TotalCasesPerDay, SUM(cast(new_deaths as int)) AS TotalDeathsPerDay, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Global_DeathPercentage
from PortfolioProject..CovidDeaths$
--where location like '%canada%' and 
WHERE continent IS NOT NULL
GROUP BY date
order by 1, 2

-- looking at Vaccination data
SELECT *
FROM PortfolioProject..CovidVaccinations$
order by 3, 4

--Combining both tables

--exploting total population against vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
and dea.location like '%canada%'
order by 2,3


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(BIGINT,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPersonsVaccinated
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--Exploration via a Temp table

DROP Table if exists #PercentagePopulationVaccinated
Create table #PercentagePopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
RollingPersonsVaccinated numeric
)

insert into #PercentagePopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(BIGINT,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPersonsVaccinated
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select *, (RollingPersonsVaccinated/population)*100
from #PercentagePopulationVaccinated




--Exploration via a CTE

with PopvsVac (continent, location, Date, population, new_vaccinations, RollingPersonsVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(BIGINT,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPersonsVaccinated
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select *, (RollingPersonsVaccinated/population)*100
from PopvsVac


--Create View for data visualisation

Create view PercentagePopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(BIGINT,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPersonsVaccinated
FROM PortfolioProject..CovidDeaths$ dea
JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

--View Temp table(PercentagePopulationVaccinated) created
select *
from PercentagePopulationVaccinated