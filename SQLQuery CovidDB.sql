Select *
from [Portfolio Project]..CovidDeath$
where continent is not null
order by 3,4

--Select *
--from [Portfolio Project]..CovidVaccinations$
--order by 3,4

Select Location,date,total_cases,new_cases,total_deaths,population
from [Portfolio Project]..CovidDeath$
order by 1,2

--Total cases vs Total Deaths
--shows how much chance of getting affected by covid in india

Select Location,date,total_cases,total_deaths,
(CONVERT(float,total_deaths)/NULLIF(CONVERT(float,total_cases),0))*100 AS Deathpercentage
from [Portfolio Project]..CovidDeath$
where location like '%india%'
and continent is not null
order by 1,2
 
--looking at total cases vs population and percentage of population got affected to covid

Select Location,date,total_cases,population ,
--(CONVERT(float,total_deaths)/NULLIF(CONVERT(float,total_cases),0))*100 AS Deathpercentage
(total_cases/population)*100 as AffectedPercentage
from [Portfolio Project]..CovidDeath$
where location like '%india%'
order by 1,2


--looking for countires with highest infection rate compared to population.

Select Location , population , MAX(total_cases) as HighestInfectionCount , max((total_cases/population))*100 as PercentPopulationInfected
from [Portfolio Project]..CovidDeath$
--where location like '%india%'
Group by Location, population
order by PercentPopulationInfected desc --or 4 desc


-- countries with highest death count per population for a country

Select Location ,  MAX(cast(total_deaths as int)) as TotalDeathCount 
from [Portfolio Project]..CovidDeath$
--where location like '%india%'
where continent is not null
Group by Location
order by TotalDeathCount desc


--we can see deaths by based on continet 

Select continent ,  MAX(cast(total_deaths as int)) as TotalDeathCount 
from [Portfolio Project]..CovidDeath$
--where location like '%india%'
where continent is not null
Group by continent
order by TotalDeathCount desc

--continents with highest death count per population

-- global numbers
select sum(new_cases) as total_cases , sum(cast(new_deaths as int)) as total_deaths, (convert(float,sum(cast(new_deaths as int)))/NULLIF(CONVERT(float, sum(new_cases)), 0)*100) AS Deathpercentage
from [Portfolio Project]..CovidDeath$
--where location like '%india%'
where continent is not null
--group by date
order by 1,2

--total population vs vaccinations

select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations
from [Portfolio Project]..CovidDeath$ dea
join [Portfolio Project]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations 
, sum(convert(float , vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as totalpeoplevaccinated_eachday
--, (totalpeoplevaccinated_eachday/population)*100
from [Portfolio Project]..CovidDeath$ dea
join [Portfolio Project]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


--USE CTE 

with popvsVac (Continent , Location , Date , Population , new_vaccinations , totalpeoplevaccinated_eachday) --note : the number of rows in cte should be same in original table.
as
(
select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations 
, sum(convert(float , vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as totalpeoplevaccinated_eachday
--, (totalpeoplevaccinated_eachday/population)*100
from [Portfolio Project]..CovidDeath$ dea
join [Portfolio Project]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
select * , (totalpeoplevaccinated_eachday/population)*100
from popvsVac



--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
New_vaccinations numeric,
totalpeoplevaccinated_eachday numeric
)


Insert into #PercentPopulationVaccinated
select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations 
, sum(convert(float , vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as totalpeoplevaccinated_eachday
--, (totalpeoplevaccinated_eachday/population)*100
from [Portfolio Project]..CovidDeath$ dea
join [Portfolio Project]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

select * , (totalpeoplevaccinated_eachday/population)*100
from #PercentPopulationVaccinated


--views for later visualizations purpose

Create View PercentPopulationVaccinated as
select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations 
, sum(convert(float , vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as totalpeoplevaccinated_eachday
--, (totalpeoplevaccinated_eachday/population)*100
from [Portfolio Project]..CovidDeath$ dea
join [Portfolio Project]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

select * 
from percentpopulationVaccinated
