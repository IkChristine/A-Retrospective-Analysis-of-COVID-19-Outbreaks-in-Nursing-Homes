-- View imported tables
SELECT * 
FROM nursing_homes_2020;

SELECT * 
FROM nursing_homes_2021;

SELECT * 
FROM nursing_homes_2022;

SELECT * 
FROM nursing_homes_2023;


 
---obtaining the count of providers (distinct nursing homes)
select count (distinct provider_name)
from nursing_homes_2022


---Project questions to analyze

---1. Determine the total number of COVID-19 cases, deaths, and recoveries recorded between 2020-2023

SELECT
    SUM(Residents_Weekly_Confirmed_COVID_19) AS TotalCases,
    SUM(Residents_Weekly_COVID_19_Deaths) AS TotalDeaths,
    SUM(Residents_Weekly_Confirmed_COVID_19 - Residents_Weekly_COVID_19_Deaths) AS TotalRecoveries
FROM (
    SELECT Residents_Weekly_Confirmed_COVID_19, Residents_Weekly_COVID_19_Deaths
    FROM nursing_homes_2020
    UNION ALL
    SELECT Residents_Weekly_Confirmed_COVID_19, Residents_Weekly_COVID_19_Deaths
    FROM nursing_homes_2021
    UNION ALL
    SELECT Residents_Weekly_Confirmed_COVID_19, Residents_Weekly_COVID_19_Deaths
    FROM nursing_homes_2022
    UNION ALL
    SELECT Residents_Weekly_Confirmed_COVID_19, Residents_Weekly_COVID_19_Deaths
    FROM nursing_homes_2023
) AS combined_data;


---2. Determine the total number of COVID-19 cases, deaths, and recoveries for each state. 

WITH cte AS (
  SELECT
    Provider_State AS State,
    SUM(Residents_Weekly_Confirmed_COVID_19) AS TotalCases,
    SUM(Residents_Weekly_COVID_19_Deaths) AS TotalDeaths,
    SUM(Residents_Weekly_Confirmed_COVID_19 - Residents_Weekly_COVID_19_Deaths) AS TotalRecoveries
  FROM (
     SELECT Provider_State, Week_Ending, Residents_Weekly_Confirmed_COVID_19, Residents_Weekly_COVID_19_Deaths
    FROM nursing_homes_2020
    UNION ALL
    SELECT Provider_State, Week_Ending, Residents_Weekly_Confirmed_COVID_19, Residents_Weekly_COVID_19_Deaths
    FROM nursing_homes_2021
    UNION ALL
    SELECT Provider_State, Week_Ending, Residents_Weekly_Confirmed_COVID_19, Residents_Weekly_COVID_19_Deaths
    FROM nursing_homes_2022
    UNION ALL
    SELECT Provider_State, Week_Ending, Residents_Weekly_Confirmed_COVID_19, Residents_Weekly_COVID_19_Deaths
    FROM nursing_homes_2023
) AS combined_data
  GROUP BY Provider_State
)
SELECT State, TotalCases, TotalDeaths, TotalRecoveries
FROM cte;



---3. Determine the top 7 States with the Highest COVID-19 Mortality Rate (Deaths Per 1000 Cases) in 2023
WITH cte AS (
  SELECT
    Provider_State AS State,
    SUM(Residents_Weekly_Confirmed_COVID_19) AS TotalCases,
    SUM(Residents_Weekly_COVID_19_Deaths) AS TotalDeaths,
    SUM(Residents_Weekly_Confirmed_COVID_19 - Residents_Weekly_COVID_19_Deaths) AS TotalRecoveries
  FROM nursing_homes_2023
  GROUP BY Provider_State
)
SELECT 
  State,
  TotalCases,
  TotalDeaths,
  ROUND(TotalDeaths * 1000.0 / TotalCases,2) AS MortalityRate
FROM cte
ORDER BY MortalityRate DESC
LIMIT 7;


---4. Examine how the number of COVID-19 cases has evolved over time (monthly)
		---(Time Series of COVID-19 Cases, May 2020 – May 2023)

WITH cte AS (
  SELECT
    DATE_PART('YEAR', Week_Ending) AS Year,
    DATE_PART('MONTH', Week_Ending) AS Month,
    SUM(Residents_Weekly_Confirmed_COVID_19) AS TotalCases
  FROM nursing_homes_2020
  GROUP BY Year, Month
  UNION ALL
  SELECT
    DATE_PART('YEAR', Week_Ending) AS Year,
    DATE_PART ('MONTH', Week_Ending) AS Month,
    SUM(Residents_Weekly_Confirmed_COVID_19) AS TotalCases
  FROM nursing_homes_2021
  GROUP BY Year, Month
  UNION ALL
  SELECT
    DATE_PART('YEAR', Week_Ending) AS Year,
    DATE_PART ('MONTH', Week_Ending) AS Month,
    SUM(Residents_Weekly_Confirmed_COVID_19) AS TotalCases
  FROM nursing_homes_2022
  GROUP BY Year, Month
  UNION ALL
  SELECT
    DATE_PART('YEAR', Week_Ending) AS Year,
    DATE_PART ('MONTH', Week_Ending) AS Month,
    SUM(Residents_Weekly_Confirmed_COVID_19) AS TotalCases
  FROM nursing_homes_2023
  GROUP BY Year, Month
)

SELECT
  Year,  Month,
  TotalCases AS Total_Cases
FROM cte
ORDER BY Year, Month;


---5. Examine the Distribution of Facilities Across States Versus Number of Cases
WITH cte AS (
  SELECT
    Provider_Name AS Provider_Name,
    Provider_State AS Provider_State,
	Residents_Weekly_Confirmed_COVID_19,
	Residents_Weekly_All_Deaths
  FROM nursing_homes_2020
  UNION ALL
  SELECT
    Provider_Name AS Provider_Name,
    Provider_State AS Provider_State,
	Residents_Weekly_Confirmed_COVID_19,
	Residents_Weekly_All_Deaths
  FROM nursing_homes_2021
  UNION ALL
  SELECT
    Provider_Name AS Provider_Name,
    Provider_State AS Provider_State,
	Residents_Weekly_Confirmed_COVID_19,
	Residents_Weekly_All_Deaths
  FROM nursing_homes_2022
  UNION ALL
  SELECT
    Provider_Name AS Provider_Name,
    Provider_State AS Provider_State,
	Residents_Weekly_Confirmed_COVID_19,
	Residents_Weekly_All_Deaths
  FROM nursing_homes_2023
)

SELECT
  Provider_State,
  COUNT(DISTINCT Provider_Name) AS FacilityCount,
   SUM(Residents_Weekly_Confirmed_COVID_19) AS TotalCases,
   SUM(Residents_Weekly_All_Deaths) AS TotalDeaths
FROM cte
GROUP BY Provider_State
ORDER BY FacilityCount DESC;


---6. Determine the top 10 Nursing homes with the highest average number of daily COVID-19 cases in 2020, compared to 2021

--2020
SELECT 
RTRIM(Provider_Name) || ' (' || RTRIM(Provider_State) || ') ' AS Provider_Name,
ROUND(AVG(Residents_Weekly_Confirmed_COVID_19),2) AS average_daily_cases
FROM nursing_homes_2020
WHERE Residents_Weekly_Confirmed_COVID_19 IS NOT NULL
GROUP BY Provider_Name, Provider_State
ORDER BY average_daily_cases DESC
Limit 10;

--2021
SELECT
RTRIM(Provider_Name) || ' (' || RTRIM(Provider_State) || ') ' AS Provider_Name,
ROUND(AVG(Residents_Weekly_Confirmed_COVID_19),2) AS average_daily_cases
FROM nursing_homes_2021
WHERE Residents_Weekly_Confirmed_COVID_19 IS NOT NULL
GROUP BY Provider_Name, Provider_State
ORDER BY average_daily_cases DESC
Limit 10;


---7.  Determine the Top 15 Nursing Homes with the Highest COVID-19 Mortality Rates(Deaths Per 1000 COVID-19 Cases) 

WITH cte AS (
  SELECT
    Provider_Name,
	Provider_State,
    SUM(CAST(Residents_Weekly_Confirmed_COVID_19 AS int)) AS TotalCases,
    SUM(CAST(Residents_Weekly_COVID_19_Deaths AS int)) AS TotalDeaths
  FROM nursing_homes_2020
  GROUP BY Provider_Name, Provider_State
  UNION ALL
  SELECT
    Provider_Name,
	Provider_State,
    SUM(CAST(Residents_Weekly_Confirmed_COVID_19 AS int)) AS TotalCases,
    SUM(CAST(Residents_Weekly_COVID_19_Deaths AS int)) AS TotalDeaths
  FROM nursing_homes_2021
  GROUP BY Provider_Name, Provider_State
  UNION ALL
  SELECT
    Provider_Name,
	Provider_State,
    SUM(CAST(Residents_Weekly_Confirmed_COVID_19 AS int)) AS TotalCases,
    SUM(CAST(Residents_Weekly_COVID_19_Deaths AS int)) AS TotalDeaths
  FROM nursing_homes_2022
  GROUP BY Provider_Name, Provider_State
  UNION ALL
  SELECT
    Provider_Name,
	Provider_State,
    SUM(CAST(Residents_Weekly_Confirmed_COVID_19 AS int)) AS TotalCases,
    SUM(CAST(Residents_Weekly_COVID_19_Deaths AS int)) AS TotalDeaths
  FROM nursing_homes_2023
  GROUP BY Provider_Name, Provider_State
)
SELECT
  RTRIM(Provider_Name) || ' (' || RTRIM(Provider_State) || ') ' AS Provider_Name,
    CASE
    WHEN SUM(TotalCases) > 0 THEN ROUND(SUM(TotalDeaths) * 1000 / SUM(TotalCases),2)
    ELSE 0
  END AS MortalityRate
FROM cte
WHERE TotalCases > 0
GROUP BY Provider_Name, Provider_state
ORDER BY MortalityRate DESC
LIMIT 15;


---8. Determine the peak 7-day moving average of new COVID-19 cases for each Nursing Center (Top 10 providers)

WITH cte AS (
  SELECT 
    Provider_Name,
	Provider_State,
    Week_Ending,
    Residents_Weekly_Confirmed_COVID_19,
    AVG(Residents_Weekly_Confirmed_COVID_19) OVER (
      PARTITION BY Provider_Name
      ORDER BY Week_Ending
      ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS moving_average
  FROM (
    SELECT Provider_Name, Provider_State, Week_Ending, Residents_Weekly_Confirmed_COVID_19
    FROM nursing_homes_2020
    UNION ALL
    SELECT Provider_Name, Provider_State, Week_Ending, Residents_Weekly_Confirmed_COVID_19
    FROM nursing_homes_2021
    UNION ALL
    SELECT Provider_Name, Provider_State, Week_Ending, Residents_Weekly_Confirmed_COVID_19
    FROM nursing_homes_2022
    UNION ALL
    SELECT Provider_Name, Provider_State, Week_Ending, Residents_Weekly_Confirmed_COVID_19
    FROM nursing_homes_2023
  ) AS combined_data
WHERE Residents_Weekly_Confirmed_COVID_19 IS NOT NULL)
SELECT 
 RTRIM(Provider_Name) || ' (' || RTRIM(Provider_State) || ') ' AS Provider_Name,
 ROUND(MAX(moving_average),0) AS Highest_Peak
FROM cte
GROUP BY Provider_Name, Provider_State
ORDER BY highest_peak DESC
LIMIT 10
;

---9. Determine if there are there any significant differences in COVID-19 outcomes based on Provider Categories (e.g., health center, rehab center)

WITH cte AS (
  SELECT
    Provider_Name,
    CASE
      WHEN Provider_Name LIKE '%HOSPITAL%' THEN 'Health_Center'
      WHEN Provider_Name LIKE '%NURSING HOME%' THEN 'Nursing_Home'
	  WHEN Provider_Name LIKE '%NURSING CENTER%' THEN 'Nursing_Home'
	  WHEN Provider_Name LIKE '%NURSING%' THEN 'Nursing_Home'
      WHEN Provider_Name LIKE '%HEALTH CENTER%' THEN 'Health_Center'
	  WHEN Provider_Name LIKE '%HEALTH CARE%' THEN 'Health_Center'
	  WHEN Provider_Name LIKE '%HEALTH AT%'THEN 'Health_Center'
	  WHEN Provider_Name LIKE '%HEALTHCARE CENTER%' THEN 'Health_Center'
	  WHEN Provider_Name LIKE '%HEALTHCARE OF%' THEN 'Health_Center'
      WHEN Provider_Name LIKE '%HEALTHCARE AND REHAB CENTER%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%HEALTHCARE AND REHABILITATION%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%CARE AND REHAB CENTER%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%REHAB AND CARE%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%HEALTH AND REHAB%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%REHAB AND HEALTHCARE%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%REHAB AND NURSING%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%REHAB CENTER%' THEN 'Rehab_Center'
	  WHEN Provider_Name LIKE '%REHABILITATION%' THEN 'Rehab_Center'
	  WHEN Provider_Name LIKE '%REHAB%' THEN 'Rehab_Center'
      WHEN Provider_Name LIKE '%CARE CENTER%' THEN 'Care_Center'
	  WHEN Provider_Name LIKE '%NRSG & RHB%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%NURSING & REHAB%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%NURSING & REHABILITATION%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%NURSING AND REHABILITATION%'THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%SENIOR' THEN 'Senior_Living'
      ELSE 'Other'
    END AS Facility_Type,
    SUM(Residents_Weekly_Confirmed_COVID_19) AS Total_Cases,
    SUM(Residents_Weekly_COVID_19_Deaths) AS Total_Deaths,
    SUM(Residents_Weekly_Confirmed_COVID_19 - Residents_Weekly_COVID_19_Deaths) AS Total_Recoveries
  FROM nursing_homes_2020
  GROUP BY Provider_Name
  UNION ALL
  SELECT
    Provider_Name,
    CASE
       WHEN Provider_Name LIKE '%HOSPITAL%' THEN 'Health_Center'
      WHEN Provider_Name LIKE '%NURSING HOME%' THEN 'Nursing_Home'
	  WHEN Provider_Name LIKE '%NURSING CENTER%' THEN 'Nursing_Home'
	  WHEN Provider_Name LIKE '%NURSING%' THEN 'Nursing_Home'
      WHEN Provider_Name LIKE '%HEALTH CENTER%' THEN 'Health_Center'
	  WHEN Provider_Name LIKE '%HEALTH CARE%' THEN 'Health_Center'
	  WHEN Provider_Name LIKE '%HEALTH AT%'THEN 'Health_Center'
	  WHEN Provider_Name LIKE '%HEALTHCARE CENTER%' THEN 'Health_Center'
	  WHEN Provider_Name LIKE '%HEALTHCARE OF%' THEN 'Health_Center'
      WHEN Provider_Name LIKE '%HEALTHCARE AND REHAB CENTER%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%HEALTHCARE AND REHABILITATION%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%CARE AND REHAB CENTER%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%REHAB AND CARE%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%HEALTH AND REHAB%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%REHAB AND HEALTHCARE%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%REHAB AND NURSING%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%REHAB CENTER%' THEN 'Rehab_Center'
	  WHEN Provider_Name LIKE '%REHABILITATION%' THEN 'Rehab_Center'
	  WHEN Provider_Name LIKE '%REHAB%' THEN 'Rehab_Center'
      WHEN Provider_Name LIKE '%CARE CENTER%' THEN 'Care_Center'
	  WHEN Provider_Name LIKE '%NRSG & RHB%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%NURSING & REHAB%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%NURSING & REHABILITATION%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%NURSING AND REHABILITATION%'THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%SENIOR' THEN 'Senior_Living'
      ELSE 'Other'
    END AS Facility_Type,
    SUM(Residents_Weekly_Confirmed_COVID_19) AS Total_Cases,
    SUM(Residents_Weekly_COVID_19_Deaths) AS Total_Deaths,
    SUM(Residents_Weekly_Confirmed_COVID_19 - Residents_Weekly_COVID_19_Deaths) AS Total_Recoveries
  FROM nursing_homes_2021
  GROUP BY Provider_Name
  UNION ALL
  SELECT
    Provider_Name,
    CASE
      WHEN Provider_Name LIKE '%HOSPITAL%' THEN 'Health_Center'
      WHEN Provider_Name LIKE '%NURSING HOME%' THEN 'Nursing_Home'
	  WHEN Provider_Name LIKE '%NURSING CENTER%' THEN 'Nursing_Home'
	  WHEN Provider_Name LIKE '%NURSING%' THEN 'Nursing_Home'
      WHEN Provider_Name LIKE '%HEALTH CENTER%' THEN 'Health_Center'
	  WHEN Provider_Name LIKE '%HEALTH CARE%' THEN 'Health_Center'
	  WHEN Provider_Name LIKE '%HEALTH AT%'THEN 'Health_Center'
	  WHEN Provider_Name LIKE '%HEALTHCARE CENTER%' THEN 'Health_Center'
	  WHEN Provider_Name LIKE '%HEALTHCARE OF%' THEN 'Health_Center'
      WHEN Provider_Name LIKE '%HEALTHCARE AND REHAB CENTER%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%HEALTHCARE AND REHABILITATION%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%CARE AND REHAB CENTER%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%REHAB AND CARE%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%HEALTH AND REHAB%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%REHAB AND HEALTHCARE%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%REHAB AND NURSING%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%REHAB CENTER%' THEN 'Rehab_Center'
	  WHEN Provider_Name LIKE '%REHABILITATION%' THEN 'Rehab_Center'
	  WHEN Provider_Name LIKE '%REHAB%' THEN 'Rehab_Center'
      WHEN Provider_Name LIKE '%CARE CENTER%' THEN 'Care_Center'
	  WHEN Provider_Name LIKE '%NRSG & RHB%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%NURSING & REHAB%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%NURSING & REHABILITATION%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%NURSING AND REHABILITATION%'THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%SENIOR' THEN 'Senior_Living'
      ELSE 'Other'
    END AS Facility_Type,
    SUM(Residents_Weekly_Confirmed_COVID_19) AS Total_Cases,
    SUM(Residents_Weekly_COVID_19_Deaths) AS Total_Deaths,
    SUM(Residents_Weekly_Confirmed_COVID_19 - Residents_Weekly_COVID_19_Deaths) AS Total_Recoveries
  FROM nursing_homes_2022
  GROUP BY Provider_Name
  UNION ALL
  SELECT
    Provider_Name,
    CASE
      WHEN Provider_Name LIKE '%HOSPITAL%' THEN 'Health_Center'
      WHEN Provider_Name LIKE '%NURSING HOME%' THEN 'Nursing_Home'
	  WHEN Provider_Name LIKE '%NURSING CENTER%' THEN 'Nursing_Home'
	  WHEN Provider_Name LIKE '%NURSING%' THEN 'Nursing_Home'
      WHEN Provider_Name LIKE '%HEALTH CENTER%' THEN 'Health_Center'
	  WHEN Provider_Name LIKE '%HEALTH CARE%' THEN 'Health_Center'
	  WHEN Provider_Name LIKE '%HEALTH AT%'THEN 'Health_Center'
	  WHEN Provider_Name LIKE '%HEALTHCARE CENTER%' THEN 'Health_Center'
	  WHEN Provider_Name LIKE '%HEALTHCARE OF%' THEN 'Health_Center'
      WHEN Provider_Name LIKE '%HEALTHCARE AND REHAB CENTER%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%HEALTHCARE AND REHABILITATION%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%CARE AND REHAB CENTER%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%REHAB AND CARE%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%HEALTH AND REHAB%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%REHAB AND HEALTHCARE%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%REHAB AND NURSING%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%REHAB CENTER%' THEN 'Rehab_Center'
	  WHEN Provider_Name LIKE '%REHABILITATION%' THEN 'Rehab_Center'
	  WHEN Provider_Name LIKE '%REHAB%' THEN 'Rehab_Center'
      WHEN Provider_Name LIKE '%CARE CENTER%' THEN 'Care_Center'
	  WHEN Provider_Name LIKE '%NRSG & RHB%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%NURSING & REHAB%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%NURSING & REHABILITATION%' THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%NURSING AND REHABILITATION%'THEN 'Combined_HealthCare_Nursing_and_Rehab'
	  WHEN Provider_Name LIKE '%SENIOR' THEN 'Senior_Living'
      ELSE 'Other'
    END AS Facility_Type,
    SUM(Residents_Weekly_Confirmed_COVID_19) AS Total_Cases,
    SUM(Residents_Weekly_COVID_19_Deaths) AS Total_Deaths,
    SUM(Residents_Weekly_Confirmed_COVID_19 - Residents_Weekly_COVID_19_Deaths) AS Total_Recoveries
  FROM nursing_homes_2023
  GROUP BY Provider_Name
)

SELECT
  Facility_Type,
  SUM(Total_Cases) AS Total_Cases,
  SUM(Total_Deaths) AS Total_Deaths,
  SUM(Total_Recoveries) AS Total_Recoveries,
  CASE
    WHEN SUM(Total_Cases) > 0 THEN ROUND(SUM(Total_Deaths) * 1000 / SUM(Total_Cases), 2)
    ELSE 0
  END AS Mortality_Rate
FROM cte
GROUP BY Facility_Type
ORDER BY Total_Cases DESC;


---10. Determine the  Providers with the Lowest Vaccination Rates in 2023 (Least 20 Providers)
 
  SELECT
	Distinct RTRIM(Provider_Name) || ' (' || RTRIM(Provider_State) || ') ',
	cast (SUM(Res_Staying_in_this_Facility_This_Week) as int) as Resident_population, 
	cast (SUM(Staying_This_Week_who_Received_a_Completed_COVID_19_Vaccination_at_Any_Time) as int) as vaccinated,
	cast(SUM(Staying_This_Week_who_Received_a_Completed_COVID_19_Vaccination_at_Any_Time) as numeric)/NULLIF (cast(SUM(Res_Staying_in_this_Facility_This_Week) as numeric),0) *100 as vacc_rate
  FROM nursing_homes_2023
  WHERE Res_Staying_in_this_Facility_This_Week is not null
  AND Staying_This_Week_who_Received_a_Completed_COVID_19_Vaccination_at_Any_Time >0 
  GROUP BY Provider_name, provider_state
  ORDER BY vacc_rate
  LIMIT 20;
  --FETCH FIRST 20 ROWS ONLY;  
  


---11. Determine the number of Residents Infected Versus Residents Vaccinated by State

WITH cte AS

(
	SELECT DISTINCT Provider_State, 
			(SUM(Res_Staying_in_this_Facility_This_Week)  
			 OVER (PARTITION BY Provider_State ORDER BY Provider_State))AS Residents_in_Facility, 
			   (SUM(Staying_This_Week_who_Received_a_Completed_COVID_19_Vaccination_at_Any_Time)
				OVER (PARTITION BY Provider_State ORDER BY Provider_State)) AS Rolling_Residents_Vaccinated
				FROM nursing_homes_2020
				WHERE Res_Staying_in_this_Facility_This_Week IS NOT NULL
			  GROUP BY Provider_State, Res_Staying_in_this_Facility_This_Week, Staying_This_Week_who_Received_a_Completed_COVID_19_Vaccination_at_Any_Time
UNION ALL
SELECT DISTINCT Provider_State, 
			(SUM(Res_Staying_in_this_Facility_This_Week)  
			 OVER (PARTITION BY Provider_State ORDER BY Provider_State))AS Residents_in_Facility, 
			   (SUM(Staying_This_Week_who_Received_a_Completed_COVID_19_Vaccination_at_Any_Time)
				OVER (PARTITION BY Provider_State ORDER BY Provider_State)) AS Rolling_Residents_Vaccinated
				FROM nursing_homes_2021
				WHERE Res_Staying_in_this_Facility_This_Week IS NOT NULL
			  GROUP BY Provider_State, Res_Staying_in_this_Facility_This_Week, Staying_This_Week_who_Received_a_Completed_COVID_19_Vaccination_at_Any_Time
UNION ALL													
SELECT DISTINCT Provider_State, 
			(SUM(Res_Staying_in_this_Facility_This_Week)  
			 OVER (PARTITION BY Provider_State ORDER BY Provider_State))AS Residents_in_Facility, 
			   (SUM(Staying_This_Week_who_Received_a_Completed_COVID_19_Vaccination_at_Any_Time)
				OVER (PARTITION BY Provider_State ORDER BY Provider_State)) AS Rolling_Residents_Vaccinated
				FROM nursing_homes_2022
				WHERE Res_Staying_in_this_Facility_This_Week IS NOT NULL
			  GROUP BY Provider_State, Res_Staying_in_this_Facility_This_Week, Staying_This_Week_who_Received_a_Completed_COVID_19_Vaccination_at_Any_Time
UNION ALL
SELECT DISTINCT Provider_State, 
			(SUM(Res_Staying_in_this_Facility_This_Week)  
			 OVER (PARTITION BY Provider_State ORDER BY Provider_State))AS Residents_in_Facility, 
			   (SUM(Staying_This_Week_who_Received_a_Completed_COVID_19_Vaccination_at_Any_Time)
				OVER (PARTITION BY Provider_State ORDER BY Provider_State)) AS Rolling_Residents_Vaccinated
				FROM nursing_homes_2023
				WHERE Res_Staying_in_this_Facility_This_Week IS NOT NULL
			  GROUP BY Provider_State, Res_Staying_in_this_Facility_This_Week, Staying_This_Week_who_Received_a_Completed_COVID_19_Vaccination_at_Any_Time

)
  
  SELECT DISTINCT Provider_State, SUM(Residents_in_Facility), Rolling_Residents_Vaccinated
  FROM cte
  GROUP BY Provider_State,  Residents_in_Facility, Rolling_Residents_Vaccinated
  ORDER BY Rolling_Residents_Vaccinated DESC;


  
  -----
  
 