/* 
Covid 19 Data Exploration
*/

SELECT * 
FROM MyProject..CovidDeaths
Where Continent is not null
order by 3,4

--Select the Data what we are going to be starting with

SELECT location, date,total_cases,new_cases,total_deaths, population
FROM MyProject..CovidDeaths
Where Continent is not null
order by 1, 2

--Total Cases vs Total Deaths
--Shows likelihood ofdying if you contract covid in your country

SELECT location, date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM MyProject..CovidDeaths
where location like '%india%'
and Continent is not null
order by 1, 2

--Total Cases vs Population
--Shows what percentage of population infected with Covid

SELECT location, date, Population, total_cases, (total_cases/Population)*100 as PercentPopulationInfected
FROM MyProject..CovidDeaths
--where location like '%india%'
order by 1, 2

-- Countries with highest infection rate compared to Population

SELECT location, Population, MAX(total_cases) AS HighestInfectionRate, MAX((total_cases/Population))*100 as PercentPopulationInfected
FROM MyProject..CovidDeaths
--where location like '%india%'
Group by Location, Population
order by PercentPopulationInfected desc

--Countries with Highest Death Count per population

SELECT location, MAX(CAST(total_deaths as int)) AS TotalDeathCount
FROM MyProject..CovidDeaths
--where location like '%india%'
where continent is not null
Group by Location
order by TotalDeathCount desc

--BREAKING THINGS DOWN BY CONTINENT

--Showing Continent with the highest Death Count per poulation

SELECT Continent, MAX(CAST(total_deaths as int)) AS TotalDeathCount
FROM MyProject..CovidDeaths
--where location like '%india%'
Where continent is not null
Group by Continent
order by TotalDeathCount desc


--GLOBAL NUMBERS
SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM MyProject..CovidDeaths
--where location like '%india%'
Where continent is not null
order by 1, 2

-- Total Population vs Vaccination
-- SHows Percentage of Population that has recieved at least one covid vaccine


SELECT  cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
FROM MyProject..CovidDeaths  cd
JOIN MyProject..Covidvaccinations cv
	ON cd.location =	cv.location
	and cd.date = cv.date
where cd.continent is not null
order by 2, 3


-- Using CTE to perform Calculation on Partition By in previous query


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(CONVERT(bigint,cv.new_vaccinations)) OVER (Partition by cd.Location Order by cd.location, cd.Date Rows Unbounded Preceding) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From MyProject..CovidDeaths cd
Join MyProject..CovidVaccinations cv
	On cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- Using Temp Table to perform Calculation on Partition By in previous query


DROP Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccination numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(CONVERT(bigint,cv.new_vaccinations)) OVER (Partition by cd.Location Order by cd.location, cd.Date Rows Unbounded Preceding) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From MyProject..CovidDeaths cd
Join MyProject..CovidVaccinations cv
	On cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null 
--and cd.Location like '%India%'
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations


Create View PercentPopulationVaccinated as
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, SUM(CONVERT(int,cv.new_vaccinations)) OVER (Partition by cd.Location Order by cd.location, cd.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From MyProject..CovidDeaths cd
Join MyProject..CovidVaccinations cv
	On cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null 