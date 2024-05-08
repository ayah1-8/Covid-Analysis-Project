--/////////////////////////////////////////////////////////////////////////////////////////////////


--select the main data to be working on

select location,continent, date, total_Cases, new_Cases, total_deaths, population 
from coviddeaths
order by 2

--/////////////////////////////////////////////////////////////////////////////////////////////////

--total cases and deaths for eacg location and the % of death and sort by the greatest perecet of death
select location ,max(total_cases) as total_Cases,max(total_deaths) as deaths ,
concat(round((max(total_deaths)/max(total_Cases))*100,2),'%') as Percentage_of_Mortality
from CovidDeaths
where continent is not null
group by location
order by 4 desc

--/////////////////////////////////////////////////////////////////////////////////////////////////

--total cases vs population and the % of affected and sort by the greatest perecet of affected population
select location,max(total_Cases) as total_covid_cases,population,
concat(round((max(total_cases)/population)*100,2),'%') as Percentage_of_Affected
from CovidDeaths
where continent is null 
group by location,population
order by round((max(total_cases)/population)*100,2) desc
 
 --/////////////////////////////////////////////////////////////////////////////////////////////////

 ----By Continents-------
 select location, continent,max(total_Cases) as total_covid_cases,format(population, 'N0'),
 concat(round((max(total_cases)/population)*100,2),'%') as Percentage_of_Affected
from CovidDeaths
where continent is null AND location NOT IN ('High income','Upper middle income','Lower middle income','Low income')
group by population,location,continent
order by round((max(total_cases)/population)*100,2) desc


--/////////////////////////////////////////////////////////////////////////////////////////////////

--change dataetype of new_vaccinations
--alter table covidvaccinations
--alter column new_vaccinations float 

--/////////////////////////////////////////////////////////////////////////////////////////////////

--% vaccinated population by location over time

--CTE
With PopulationVSVac (Continent,Date,Location,Population,NewVaccinations,PeopleVccinatedOverTime)
as
(
select ded.continent, ded.date, ded.location, ded.population, vaccs.new_vaccinations, 
sum(vaccs.new_vaccinations) over (partition by ded.location order by ded.location,ded.date) as PeopleVccinatedOverTime
from coviddeaths as ded
Join covidvaccinations as vaccs
on ded.date = vaccs.date 
AND ded.location = vaccs.location
where ded.continent is not null
--order by 3,2
)
Select *, round((PeopleVccinatedOverTime/Population)*100,2) as VaccinatedPeoplePercentage
from PopulationVSVac
where Year(Date) = 2024
order by VaccinatedPeoplePercentage desc


--/////////////////////////////////////////////////////////////////////////////////////////////////

----///to check the vaccinations section and validate which column is the correct source info
--With PopulationVSVac (Location,Population,PeopleVccinatedOverTime)
--as
--(
--select ded.location, max(ded.population),
--max(vaccs.total_vaccinations),sum(vaccs.new_vaccinations) --over (partition by ded.location order by ded.location) as PeopleVccinatedOverTime
--from coviddeaths as ded
--Join covidvaccinations as vaccs
--on ded.location = vaccs.location
--AND ded.date = vaccs.date
--where ded.continent is not null
--group by ded.location
--order by 3,2
--)
--Select * from PopulationVSVac



----------------------Views Section------------------------------




