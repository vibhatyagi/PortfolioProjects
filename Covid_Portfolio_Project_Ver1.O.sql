SELECT *
FROM Practice..CovidDeath
order by 3, 4



--SELECT *
--FROM Practice..CovidVaccination
--order by 3, 4

-- Select the Data we are going to be using

Select Location, date, total_Cases, new_Cases, total_deaths, population
FROM Practice..CovidDeath
where continent is not null
Order by 1, 2

-- Total Cases vs Total Deaths


SELECT Location, date, total_cases, total_deaths, (Total_deaths / Total_cases)*100 AS Death_Percentage
FROM Practice..CovidDeath
Where location like '%Ind%'
and continent is not null
Order by 1, 2 

-- Total Cases vs Population

SELECT Location, date, population, total_cases,  (Total_cases / population)*100 AS Cases_Percentage
FROM Practice..CovidDeath
Where location like '%india%'
and continent is not null
Order by 1, 2 

-- Country with highest infection rate comapred to population

SELECT Location, population, MAX(Total_cases) as highestinfectioncount, MAX((Total_cases / population))*100 AS PercentPopulationInfected
FROM Practice..CovidDeath
--Where location like '%india%'
where continent is not null
Group by Location, Population
Order by PercentPopulationInfected desc


-- Country with highest death count per population


SELECT Location, MAX(CAST(total_deaths AS int)) as TotalDeathCount
FROM Practice..CovidDeath
--Where location like '%india%'
where continent is null
Group by Location
Order by TotalDeathCount desc

--Breaking the things down by Continent


DELETE FROM Practice..CovidDeath
Where Location = 'Upper middle income' ;

DELETE FROM Practice..CovidDeath
Where Location = 'Lower middle income' ;

DELETE FROM Practice..CovidDeath
Where Location = 'High income' ;

DELETE FROM Practice..CovidDeath
Where Location = 'Low income' ;

DELETE FROM Practice..CovidDeath
Where Location = 'International' ;


-- Continent with highest death count

SELECT continent, MAX(CAST(total_deaths AS int)) as TotalDeathCount
FROM Practice..CovidDeath
--Where location like '%india%'
where continent is not null
Group by continent
Order by TotalDeathCount desc

-- GLOBAL Numbers

SELECT SUM(total_cases) as Total_Cases, SUM(CAST(New_deaths as int )) AS Total_Deaths, SUM(CAST(New_deaths as int))/SUM(new_cases)*100 AS Death_Percentage
FROM Practice..CovidDeath
--Where location like '%Ind%'
Where continent is not null
--Group by Date
Order by 1, 2

--Deleting extra column F27-F67 


SELECT *
FROM practice..CovidDeath


ALTER TABLE practice..CovidDeath
DROP COLUMN F27;


-- Total Population vs vaccination

SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations
FROM practice..CovidDeath  Death
JOIN practice..CovidVaccination   Vac
	ON death.location = vac.location
	and death.date = vac.date
where death.continent is not null
order by 2,3


SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations
, SUM(Convert(bigint, vac.new_vaccinations)) OVER(Partition by death.location order by death.location, death.date ROWS UNBOUNDED PRECEDING) AS RollingPeopleVaccinated
--, ( RollingPeopleVaccinated /population) *100
FROM practice..CovidDeath  Death
JOIN practice..CovidVaccination   Vac
	ON death.location = vac.location
	and death.date = vac.date
where death.continent is not null
order by 2,3

--USE CTE

With PopvsVac (Continent, Location, Date, Population, RollingPeopleVaccinated, new_vaccinations)
as
(
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations
, SUM(Convert(bigint, vac.new_vaccinations)) OVER(Partition by death.location order by death.location, death.date ROWS UNBOUNDED PRECEDING) AS RollingPeopleVaccinated
--, ( RollingPeopleVaccinated /population) *100
FROM practice..CovidDeath  Death
JOIN practice..CovidVaccination   Vac
	ON death.location = vac.location
	and death.date = vac.date
where death.continent is not null
--order by 2,3
)

SELECT *, ( RollingPeopleVaccinated /population) *100
FROM PopvsVac


--Use Temp Table

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime, 
population numeric,
new_vaccination numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations
, SUM(Convert(bigint, vac.new_vaccinations)) OVER(Partition by death.location order by death.location, death.date ROWS UNBOUNDED PRECEDING) AS RollingPeopleVaccinated
--, ( RollingPeopleVaccinated /population) *100
FROM practice..CovidDeath  Death
JOIN practice..CovidVaccination   Vac
	ON death.location = vac.location
	and death.date = vac.date
--where death.continent is not null
--order by 2,3

SELECT *, ( RollingPeopleVaccinated /population) *100
FROM #PercentPopulationVaccinated

--Creating View to store data for later visualization

Create View PercentPopulationVaccinated as 
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations
, SUM(Convert(bigint, vac.new_vaccinations)) OVER(Partition by death.location order by death.location, death.date ROWS UNBOUNDED PRECEDING) AS RollingPeopleVaccinated
--, ( RollingPeopleVaccinated /population) *100
FROM practice..CovidDeath  Death
JOIN practice..CovidVaccination   Vac
	ON death.location = vac.location
	and death.date = vac.date
where death.continent is not null
--order by 2,3




