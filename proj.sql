--select all columns from covid death table r by 3 4 coloumns

select * from ['covid death$'] order by 3,4;

--checking for continents

select * from ['covid death$'] where continent is not null  order by 3,4;

--select multiple columns prder by date and location

select date,location,total_cases,new_cases,total_deaths from ['covid death$'] order by 1,2;
 
 --looking for total cases vs deaths 

 select date,location,total_cases,total_deaths from ['covid death$'] order by 1,2;

 --looking for death rate 

  select date,location,total_cases,total_deaths,(cast(total_deaths as float)/total_cases*100) as deathper from ['covid death$'] order by 1,2;

  --looking for totaldeaths vs totalcasses in us

   select date,location,total_cases,total_deaths from ['covid death$'] 
   where location='United States'
   order by 1,2;

   --looking  for highest infection rate 

    select location ,max(total_cases) as highest_infection_rate  from ['covid death$'] group by location order by highest_infection_rate desc  ;

	--looking for highest death rate

	    select location ,max(total_deaths) as highest_death_rate  from ['covid death$'] group by location order by highest_death_rate desc  ;

		--looking highest deatrate according to the continents 
		
	    select continent ,max(total_deaths) as highest_death_rate  from ['covid death$'] group by continent order by highest_death_rate desc  ;

		--looking for new cases vs deaths as a global perspective 

		select date, sum(new_cases) as new_casses_per_day,Sum(new_deaths) as deaths_per_day from ['covid death$'] group by date order by date desc;
		
		--total death percentage globaly 

		select date ,((sum(cast(total_deaths as float))/sum(cast(total_cases as float )))*100) as deaths_per_day from ['covid death$'] 
		group by date order by date desc;

	   --joining covid death and vaccination table for analysis 

	   select * from ['covid death$'] cross join ['covid vaccination$'];

     
	 -- checking for vaccinated peoples per day 

	 WITH totalvacc (date, location, people_vaccinated_per_day) AS
(
    SELECT
        death.date,
        death.location,
        SUM(CAST(vacc.total_vaccinations AS bigint)) AS people_vaccinated_Per_day
    FROM
        ['covid death$'] AS death
    JOIN
        ['covid vaccination$'] AS vacc ON death.date = vacc.date AND death.location = vacc.location
    GROUP BY
        death.location, death.date
)
SELECT *
FROM totalvacc
ORDER BY location;
 
 -- checking total vaccinated peoples in countries 

 	 WITH totalvacc ( location, people_vaccinated) AS
(
    SELECT
        
        death.location,
        SUM(CAST(vacc.total_vaccinations AS bigint)) AS people_vaccinated
    FROM
        ['covid death$'] AS death
    JOIN
        ['covid vaccination$'] AS vacc ON death.date = vacc.date AND death.location = vacc.location
    GROUP BY
        death.location
)
SELECT *
FROM totalvacc
ORDER BY location;

--tmp table to store the req info

create table people_vaccinated(
location nvarchar(255),
people_vaccinated numeric)

--INSERTING in table

insert into people_vaccinated
SELECT
        
        death.location,
        SUM(CAST(vacc.total_vaccinations AS bigint)) AS people_vaccinated
    FROM
        ['covid death$'] AS death
    JOIN
        ['covid vaccination$'] AS vacc ON death.date = vacc.date AND death.location = vacc.location
    GROUP BY
        death.location

		select * from people_vaccinated

--creating a view 

create view people_vaccinate as
    SELECT
        death.date,
        death.location,
        SUM(CAST(vacc.total_vaccinations AS bigint)) AS people_vaccinated_Per_day
    FROM
        ['covid death$'] AS death
    JOIN
        ['covid vaccination$'] AS vacc ON death.date = vacc.date AND death.location = vacc.location
    GROUP BY
        death.location, death.date
