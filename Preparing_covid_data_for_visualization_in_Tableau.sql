
-- INFECTIONS
-- Showing the total number of covid deaths and the total percentage of covid deaths in population for each continent
SELECT location, population,
	   MAX(total_deaths) AS total_deaths, 
	   MAX((CAST(total_deaths AS FLOAT)/population))*100 AS percent_population_deaths
FROM CovidDeaths
WHERE continent IS NULL
AND location NOT IN ('World', 'European Union', 'International', 'Low income', 'Low middle income', 'High income', 'Upper middle income', 'Lower middle income')
GROUP BY location, population
ORDER BY percent_population_deaths DESC

-- Showing the total number of infections and percentage of Population infections in each continent and for each day
SELECT location, population, date,
	   MAX(total_cases) AS highest_infection_count, 
	   MAX((CAST(total_cases AS FLOAT)/population))*100 AS percent_population_infected
FROM CovidDeaths
WHERE continent IS NULL
AND location NOT IN ('World', 'European Union', 'International', 'Low income', 'Low middle income', 'High income', 'Upper middle income', 'Lower middle income')
GROUP BY location, population, date
ORDER BY percent_population_infected DESC

-- Showing the global total infections, total deaths and percentage of population infections.
WITH cont_infections AS (SELECT location, population,
						  MAX(total_cases) AS highest_infection_count,
						  MAX(CAST(total_deaths AS NUMERIC)) AS total_deaths, 
						 MAX((CAST(total_cases AS FLOAT)/population))*100 AS percent_population_infected
FROM CovidDeaths
WHERE continent IS NULL
AND location NOT IN ('World', 'European Union', 'International', 'Low income', 'Low middle income', 'High income', 'Upper middle income', 'Lower middle income')
GROUP BY location, population
ORDER BY percent_population_infected DESC)

SELECT SUM(highest_infection_count) AS total_infections,
		SUM(total_deaths) AS total_deaths, 
		SUM(total_deaths)/SUM(CAST(population AS FLOAT))*100 AS percent_infected
FROM cont_infections



-- VACCINATIONS

-- Showing the total percentage of infected and vaccinated population in each country
SELECT d.location,
		MAX(CAST(d.total_cases AS FLOAT))/d.population  AS percent_infected, 
		MAX(CAST(v.people_fully_vaccinated AS FLOAT))/v.population AS percent_vaccinated
FROM CovidDeaths d
JOIN CovidVaccinations v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL 
GROUP BY d.location
ORDER BY percent_infected DESC

-- Showing the global total vaccinations, total booster shots, percentage of fully vaccinated populations and percentage of population with booster shots
WITH cont_vaccinations AS (SELECT location, population,
	   MAX(CAST(people_fully_vaccinated AS NUMERIC)) AS highest_vaccination_count,
		MAX(CAST(total_boosters AS NUMERIC)) AS total_booster
FROM CovidVaccinations
WHERE continent IS NULL
AND location NOT IN ('World', 'European Union', 'International', 'Low income', 'Low middle income', 'High income', 'Upper middle income', 'Lower middle income')
GROUP BY location, population
ORDER BY 1)

SELECT SUM(highest_vaccination_count) AS total_vaccinated,
		SUM(total_booster) AS total_boosted, 
		SUM(CAST(highest_vaccination_count AS FLOAT))/SUM(CAST(population AS FLOAT))*100 AS percent_vaccinated,
		SUM(CAST(total_booster AS FLOAT))/SUM(CAST(population AS FLOAT)) * 100 AS percent_boosted
FROM cont_vaccinations



-- Showing the number of vaccinated people and the percent of fully vaccinated people in each continent for each day
SELECT location, population, date, 
		MAX(people_fully_vaccinated) AS fully_vaccinated_count, 
		MAX((CAST(people_fully_vaccinated AS FLOAT)/population))*100 AS percent_population_vaccinated
FROM CovidVaccinations
WHERE continent IS NULL 
AND location NOT IN ('World', 'European Union', 'International', 'Low income', 'Low middle income', 'High income', 'Upper middle income', 'Lower middle income')
GROUP BY location, population, date
ORDER BY percent_population_vaccinated DESC

-- Showing the total population of people with booster shots in each oontinent
SELECT location, population,
	   MAX(CAST(total_boosters AS FLOAT)/population)*100 AS percent_population_booster
FROM CovidVaccinations
WHERE continent IS NULL
AND location NOT IN ('World', 'European Union', 'International', 'Low income', 'Low middle income', 'High income', 'Upper middle income', 'Lower middle income')
GROUP BY location, population
ORDER BY percent_population_booster DESC

