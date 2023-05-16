-- Selecting general country data from CovidDeaths table

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location


-- Calculating percentage of deaths by cases (total death / total cases)

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS death_percentage
FROM PortfolioProject..CovidDeaths
WHERE location = 'United States' AND continent IS NOT NULL
ORDER BY location


-- Total cases vs. Population

SELECT location, date, total_cases, population, (total_cases/population) * 100 AS case_percentage
FROM PortfolioProject..CovidDeaths
WHERE location = 'United States' AND continent IS NOT NULL
ORDER BY location


-- Countries with highest infection rate

SELECT location, population, MAX(total_cases) AS total_cases, MAX((total_cases/population)) * 100 AS case_percentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY case_percentage DESC


-- Countries with highest death count

SELECT location, MAX(cast(total_deaths AS int)) AS total_deaths
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_deaths DESC


-- Creating view for highest death count

CREATE VIEW HighestDeathCount AS
SELECT location, MAX(cast(total_deaths AS int)) AS total_deaths
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location


-- Countries with highest death percentage by population

SELECT location, MAX(cast(total_deaths AS int)) AS total_deaths, MAX(total_deaths/population) * 100 AS death_percentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY death_percentage DESC


-- Continents' total number of deaths

SELECT location, MAX(cast(total_deaths AS int)) AS total_deaths
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL
AND location not in ('World', 'European Union', 'International')
GROUP BY location
ORDER BY total_deaths DESC


-- Global cases, deaths, and death percentage by case for a given date

SELECT date, SUM(new_cases) AS new_cases, SUM(cast(new_deaths AS int)) AS total_deaths, SUM(cast(new_deaths AS int))/SUM(new_cases) * 100 AS death_percentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date


-- Creating view for global cases, deaths, and death percentage

CREATE VIEW GlobalStats AS
SELECT date, SUM(new_cases) AS new_cases, SUM(cast(new_deaths AS int)) AS total_deaths, SUM(cast(new_deaths AS int))/SUM(new_cases) * 100 AS death_percentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date


-- Country population vs vaccinations

DROP TABLE IF EXISTS #PopulationVaccinated
CREATE TABLE #PopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_vaccinations numeric
)

INSERT INTO #PopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_vaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *, (rolling_vaccinations/population) * 100 AS rolling_percentage_vaccinated
FROM #PopulationVaccinated


-- Creating view for country population vs vaccinations

CREATE VIEW PopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_vaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
