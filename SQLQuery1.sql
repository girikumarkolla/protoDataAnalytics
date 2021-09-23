SELECT *
FROM proto1..Coviddeaths
order by 3,4

--SELECT *
--FROM proto1..Covidvaccine
--order by 3,4

-- select data that we are goiing to be using
SELECT Location, date , total_cases, new_cases, total_deaths, population
FROM proto1..Coviddeaths
where continent is not null
order by 1,2

-- looking at total cases vs total deaths
--shows likehood of dying in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathPer
from proto1..Coviddeaths
where location like '%states%'
and continent is not null
order by 1,2

-- looking the total cases vs popu
Select location, date, total_cases, population, (total_cases/population)*100 as Percentagepopulation
from proto1..Coviddeaths
--where location like '%united kingdom%'
order by 1,2

--look at country with infection rate compared to population
Select location, MAX(total_cases)as highcase , population,  MAX((total_cases/population))*100 as Percentagepopuinfected
from proto1..Coviddeaths
--where location like '%united kingdom%'
Group by population, location
order by Percentagepopuinfected desc

--showing highest deaths in country per popu

Select location, MAX(cast(total_deaths as int)) as highestdeaths
from proto1..Coviddeaths
where continent is not null
Group by location
order by highestdeaths desc

select *
from proto1..Coviddeaths
where continent is not null
order by 3,4

--lets break things down by continent
Select location, MAX(cast(total_deaths as int)) as highestdeaths
from proto1..Coviddeaths
where continent is null
Group by location
order by highestdeaths desc

Select continent, MAX(cast(total_deaths as int)) as highestdeaths
from proto1..Coviddeaths
where continent is not null
Group by continent
order by highestdeaths desc

--showing the continents high deaths per popu
Select continent, MAX(cast(total_deaths as int)) as highestdeaths
from proto1..Coviddeaths
where continent is null
Group by continent
order by highestdeaths desc

-- global numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_DEATHS as int))/SUM(New_cases)*100 as deathper
from proto1..Coviddeaths
where continent is not null
--group by date
order by 1,2

-- LOOKS AT TOTAL POPULATION VS VACCIANTIONS
select *
from proto1..Covidvaccine

-- use cte

with popvsvac (continent, locatio, date, population, new_vaccinations, peoplevaccine)
as
(
select dea.continent, dea.location, dea.date, dea.population , vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.Location,
dea.date) as peoplevaccine
--,(peoplevaccine/population)*100
from proto1..Covidvaccine vac
join proto1..Coviddeaths dea
 on dea.location = vac.location and  dea.date = vac.date
 where dea.continent is not null
 --order by 2,3
 )
select *, (peoplevaccine/population)*100 as remaing
from popvsvac

drop table #percentagepopulation

 create table #percentagepopulation
 (
 continent nvarchar(255),
 LOCATION NVARCHAR(255),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 peoplevaccine numeric
 )
Insert into #percentagepopulation
select dea.continent, dea.location, dea.date, dea.population , vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.Location,
dea.date) as peoplevaccine
--,(peoplevaccine/population)*100
from proto1..Covidvaccine vac
join proto1..Coviddeaths dea
 on dea.location = vac.location and  dea.date = vac.date
 where dea.continent is not null
 --order by 2,3
 
 select *, (peoplevaccine/population)*100
 from #percentagepopulation


 --creating view to store data for later visualizations

 Create View peoplevaccine as
 select dea.continent, dea.location, dea.date, dea.population , vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.Location,
dea.date) as peoplevaccine
--,(peoplevaccine/population)*100
from proto1..Covidvaccine vac
join proto1..Coviddeaths dea
 on dea.location = vac.location and  dea.date = vac.date
 where dea.continent is not null
 --order by 2,3

 select *
 from peoplevaccine

