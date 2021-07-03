-- Analyzing Data for Afghanistan
SELECT continent, location, date, population, total_cases
FROM cvcases
WHERE location = "Afghanistan";

-- Looking at Death Percentage (total_cases v total_deaths)
SELECT 
	continent, 
    location, 
    date, 
    population, 
    total_cases, 
    total_deaths, 
    (total_deaths/total_cases)*100 as death_percentage
FROM cvcases
WHERE location = "Afghanistan";

-- Looking at Infected Percentage (total_cases v population)
SELECT
	continent, 
    location, 
    date, 
    population,
    total_cases,
    (total_cases/population)*100 as infected_percentage
FROM cvcases
WHERE location = "Afghanistan";

-- Looking at the dates with highest new cases
SELECT
     date, 
    location,  
    new_cases
FROM cvcases
WHERE location = "Afghanistan"
ORDER BY new_cases desc;

-- Looking at the percentage increase per day (Using CTE)
WITH cvcases (date, population, total_cases, new_cases, previousdaycases)
as
(
SELECT 
    date, 
    population,
    total_cases,
    new_cases,
	LAG(new_cases) OVER (ORDER BY date) As previousdaycases
    FROM cvcases
    )
SELECT 
	date, 
    population,
    total_cases,
    new_cases,
    ((new_cases-previousdaycases)/new_cases)*100 as percentincrease
FROM cvcases;

-- Joining Vaccination and Cases Table
SELECT 
	cvc.date,
    cvc.location,
    cvc.population,
    total_cases,
    total_vaccinations,
    people_fully_vaccinated
FROM cvcases cvc
JOIN cvvaccines cvv
	ON cvc.location=cvv.location AND cvc.date=cvv.date
WHERE cvc.location="Afghanistan";

-- Total Fully Vaccinated People and Total Cases
SELECT 
    cvc.location,
    SUM(total_cases) OVER (Partition by cvc.location),
    SUM(people_fully_vaccinated) OVER (Partition by cvc.location)
FROM cvcases cvc
JOIN cvvaccines cvv
	ON cvc.location=cvv.location AND cvc.date=cvv.date
ORDER BY 1,2;

-- Creating a Temp Table
CREATE TABLE Casesinfo
(
Date datetime,
Location nvarchar(100),
new_cases numeric
);
INSERT INTO Casesinfo
SELECT
     date, 
    location,  
    new_cases
FROM cvcases
WHERE location = "Afghanistan"
ORDER BY new_cases desc;
SELECT *
FROM Casesinfo;



	

