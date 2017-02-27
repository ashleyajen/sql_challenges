SELECT * FROM country
-- What is the population of the US? (starts with 2, ends with 000)
SELECT
  code,
  name,
  population
FROM
  country
WHERE
  code = 'USA';

-- What is the area of the US? (starts with 9, ends with million square miles)
SELECT
  code,
  name,
  surfacearea
FROM
  country
WHERE
  code = 'USA';

-- List the countries in Africa that have a population smaller than 30,000,000 and a life expectancy of more than 45? (all 37 of them)
SELECT
  code,
  name,
  population,
  lifeexpectancy
FROM
  country
WHERE
  continent = 'Africa'
  AND
  population < 30000000
  AND
  lifeexpectancy > 45;

  -- Which countries are something like a republic? (are there 122 or 143 countries or ?)
SELECT
  name,
  governmentform
FROM
  country
WHERE
  governmentform LIKE '%pub%';

-- Which countries are some kind of republic and acheived independence after 1945?
SELECT
  name,
  governmentform,
  indepyear
FROM
  country
WHERE
  governmentform LIKE '%pub%'
  AND
  indepyear > 1945;

  -- Which countries acheived independence after 1945 and are not some kind of republic?

SELECT
  name,
  governmentform,
  indepyear
FROM
  country
WHERE
  NOT(governmentform LIKE '%pub%')
  AND
  indepyear > 1945;

-- Which fifteen countries have the lowest life expectancy? highest life expectancy?
SELECT
  name,
  lifeexpectancy
FROM
  country
WHERE
  lifeexpectancy IS NOT NULL
ORDER BY
  lifeexpectancy DESC
  LIMIT 15;

-- Which five countries have the lowest population density? highest population density?
SELECT name, population FROM country WHERE population IS NOT NULL ORDER BY population ASC LIMIT 5

SELECT name, population FROM country WHERE population IS NOT NULL ORDER BY population DESC LIMIT 5

-- Which is the smallest country, by area and population? the 10 smallest countries, by area and population?
SELECT
  name,
  surfacearea,
  population
FROM
  country
WHERE
  population IS NOT NULL
  AND
  surfacearea IS NOT NULL
ORDER BY
  surfacearea ASC, population ASC
  LIMIT 10;

  -- Of the smallest 10 countries, which has the biggest gnp? (hint: use WITH and LIMIT)
WITH
  smallest_countries AS
  (SELECT
    name,
    GNP,
    population
  FROM
    country
  WHERE
    population IS NOT NULL
  ORDER BY
    population ASC
    LIMIT 10)
SELECT
  name,
  GNP,
  population
FROM
  smallest_countries
WHERE
  GNP IS NOT NULL
ORDER BY
  GNP DESC;

-- Of the smallest 10 countries, which has the biggest per capita gnp?
WITH
  smallest_countries AS
  (SELECT
    name,
    GNP,
    population
  FROM
    country
  WHERE
    population > 0
  ORDER BY
    population ASC
    LIMIT 10)
SELECT
  name,
  gnp,
  population,
  gnp / population AS gnp_per_capita
FROM
  smallest_countries
ORDER BY
  GNP DESC;

-- What is the sum of surface area of the 10 biggest countries in the world? The 10 smallest?

WITH
  smallest_countries AS
  (SELECT
    name,
    population,
    surfacearea
  FROM
    country
  WHERE
    population > 0
  ORDER BY
    population ASC
    LIMIT 10)
SELECT
  SUM(surfacearea)
FROM
  smallest_countries;

  -- How big are the continents in term of area and population?
SELECT
  surfacearea,
  continent
FROM
  country
GROUP BY
  surfacearea,
  continent;

-- Which region has the highest average gnp?
SELECT
  region, avg(country.gnp) AS avg_gnp
FROM
  country
GROUP BY
  region
ORDER BY avg_gnp DESC;

-- Who is the most influential head of state measured by population?
SELECT
  population, headofstate
FROM
  country
GROUP BY
  population, headofstate
ORDER BY
  population DESC;

-- Who is the most influential head of state measured by surface area?
SELECT
  surfacearea, headofstate
FROM
  country
WHERE
  headofstate IS NOT NULL
  AND
  headofstate != ''
  -- we can also type headofstate <> ''
GROUP BY
  surfacearea, headofstate
ORDER BY
  surfacearea DESC;

-- What are the most common forms of government? (hint: use count(*))
SELECT
  governmentform, count(*) AS gov_form_count
FROM
  country
GROUP BY
  governmentform
ORDER BY
  gov_form_count DESC;

-- What are the forms of government for the top ten countries by surface area?
SELECT
  governmentform,
  surfacearea
FROM
  country
GROUP BY
  governmentform,
  surfacearea
ORDER BY
  surfacearea DESC
  LIMIT 10;

-- What are the forms of government for the top ten richest nations? (technically most productive)
SELECT
  governmentform,
  gnp,
FROM
  country
GROUP BY
  governmentform,
  gnp,
ORDER BY
  gnp DESC
  LIMIT 10;

-- What are the forms of government for the top ten richest per capita nations? (technically most productive)
SELECT
  name,
  gnp,
  governmentform,
  population,
  gnp / population AS gnp_per_capita
FROM
  country
WHERE
  gnp > 0
  AND
  population > 0
GROUP BY
  name,
  gnp,
  governmentform,
  population,
  gnp_per_capita
ORDER BY
  gnp_per_capita DESC;

-- Which countries are in the top 5% in terms of area?
WITH
  smallest_countries AS
  (SELECT
    name,
    GNP,
    population
  FROM
    country
  WHERE
    population IS NOT NULL
  ORDER BY
    population ASC
    LIMIT 10)

SELECT
  name,
  surfacearea
FROM
  country
WHERE
  surfacearea IS NOT NULL
ORDER BY
  surfacearea DESC
  LIMIT (SELECT (count(*)*0.05) FROM country);
  -- limits to the top 5%

-- What is the 3rd most common language spoken?
SELECT
  language, count(*) AS language_count
FROM
  countrylanguage
GROUP BY
  language
ORDER BY
  language_count DESC;

-- How many cities are in Chile?
SELECT
  countrycode, count(city.countrycode) AS num_cities
FROM
  city
WHERE
  countrycode = 'CHL'
GROUP BY
  countrycode;

-- What is the total population in China?
SELECT
  sum(city.population) AS pop_count
FROM
  city
WHERE
  countrycode = 'CHN';

  -- How many countries are in North America?
SELECT
  count(country.name) AS country_count
FROM
  country
WHERE
  continent = 'North America';

-- Which countries gained their independence before 1963?
SELECT
  count(country.indepyear) AS indepyear_count
FROM
  country
WHERE
  indepyear < 1963;

-- What is the total population of all continents?
SELECT
  sum(country.population) AS pop_count
FROM
  country;

-- What is the average life expectancy for all continents?
SELECT
  avg(country.lifeexpectancy) AS life_expectancy_avg
FROM
  country;

-- Which countries have the letter z in the name? How many?
SELECT
  count(country.name) AS z_name_count
FROM
  country
WHERE
  name LIKE '%z%'
  OR
  name LIKE 'Z%';

-- What is the age of Jamaica?
SELECT
  2017 - indepyear AS jamaica_age
FROM
  country
WHERE
  name = 'Jamaica';

  -- Are there any countries without an official language? Hint: WHERE ... NOT IN ( SELECT ... FROM ... WHERE ...)
SELECT 
  language,
  isofficial
FROM
  countrylanguage
WHERE
  isofficial NOT IN ('t');
