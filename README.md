# COVID-19-Outbreaks-in-Nursing-Homes
A Qualitative Descriptive Study Comprising of Discussions And Recommendations


During the first wave of COVID-19 infections in the US, Nursing homes across the United States became ground zero from the transmission and death from the disease. Multiple factors can be linked to why nursing homes were hot spots in the pandemic, such as congregate living, underlying health conditions in the elderly population, staff shortage, amongst others. 

This project utilizes Nursing Home COVID-19 Public surveillance data to investigate the extent of the infections, recoveries, mortality, and vaccination rates across various nursing centers in the US. While the long-term clinical and social implications of the pandemic are still being uncovered, the results from this project can serve as a decision-making guide on how to effectively allocate resources and mitigate excessive risks for long-term care facility preparedness in the event of a pandemic. 

In-depth analysis was implemented using Excel and SQL (PostgreSQL)

## Dataset

Source: [CMS data portal](https://data.cms.gov/covid-19/covid-19-nursing-home-data)

The dataset explored contained individual records from various certified Medicare and Medicaid skilled long term care providers across US states, including hospitals and rehabilitation centers, providing care for the elderly population. The dataset was collected on a weekly basis between 03/17/2020 – 05/28/2023 including retrospective data dating back to 01/01/2020, and reported to the CDC’s National Healthcare Safety Network (NHSN) Long Term Care Facility (LTCF) COVID-19 Module: Surveillance Reporting Pathways and COVID-19 Vaccinations. 
Specific variables extracted from the dataset to be analyzed included information on COVID-19 case numbers, recovery rates, mortality rates, across the various providers in all US states. 


In total, 4 separate datasets from 2020, 2021, 2022, & 2023  were used for analysis. In certain queries, the operator “UNION ALL” was used to combine the result sets of 4 “select” Statements from the four data sets. 

Project Goal: 
To extract information from Nursing Home COVID-19 Public surveillance data (between 2020-2023).
 To investigate and visualize the trends of the infections, recoveries, mortality, and vaccination rates across various nursing centers in the US. 
To make recommendations based on the findings that can serve as a guide on how to health policy leaders can effectively allocate resources for long-term care facility preparedness in the event of a pandemic. 
