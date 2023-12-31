# COVID-19-Outbreaks-in-Nursing-Homes  
A Qualitative Descriptive Study Comprising of Discussions And Recommendations on Management and Optimization 

## Introduction
During the first wave of COVID-19 infections in the US, Long Term Care facilities (Nursing Homes) across the United States became ground zero for the transmission and death from the disease. Multiple factors could be linked to why nursing homes were hot spots in the pandemic, such as congregate living, underlying health conditions in the elderly population, staff shortage, amongst others. 

This project utilizes Nursing Home COVID-19 Public surveillance data to investigate the extent of the infections, recoveries, mortality, and vaccination rates across various nursing centers in the US. While the long-term clinical and social implications of the pandemic are still being uncovered, the results from this project can serve as a decision-making guide on how to effectively allocate resources and mitigate excessive risks for long-term care facility preparedness in the event of a pandemic. 

In-depth analysis was implemented using Excel and SQL (PostgreSQL).

## Project Goal: 
* To extract information from Nursing Home COVID-19 Public surveillance data (between 2020-2023).
* To investigate and visualize the trends of the infections, recoveries, mortality, and vaccination rates across various nursing centers in the US.
* To make recommendations based on the findings that can serve as a guide on how to health policy leaders can effectively allocate resources for long-term care facility preparedness in the event of a pandemic.

## Dataset

Source: [CMS data portal](https://data.cms.gov/covid-19/covid-19-nursing-home-data)

- The dataset explored contained individual records from various certified Medicare and Medicaid skilled long term care providers across US states, including hospitals and rehabilitation centers, providing care for the elderly population.
- The dataset was collected on a weekly basis between 03/17/2020 – 05/28/2023 including retrospective data dating back to 01/01/2020, and reported to the CDC’s National Healthcare Safety Network (NHSN) Long Term Care Facility (LTCF) COVID-19 Module: Surveillance Reporting Pathways and COVID-19 Vaccinations.
- Specific variables extracted from the dataset to be analyzed included information on COVID-19 case numbers, recovery rates, mortality rates, across the various providers in all US states.
- In total, : 4 datasets for each year (2020-2023) with up to 786,839 individual records were used for the analysis. In certain queries, the operator “UNION ALL” was used to combine the result sets of 4 “SELECT” Statements from the four datasets. 


## Analysis Highlights

![image](https://github.com/IkChristine/A-Retrospective-Analysis-of-COVID-19-Outbreaks-in-Nursing-Homes/assets/104997783/b67c785c-0021-4926-9d79-2d422a602745)


![image](https://github.com/IkChristine/A-Retrospective-Analysis-of-COVID-19-Outbreaks-in-Nursing-Homes/assets/104997783/36cd39d1-2149-48b2-80e1-d2dd7cf7cf40)


![image](https://github.com/IkChristine/A-Retrospective-Analysis-of-COVID-19-Outbreaks-in-Nursing-Homes/assets/104997783/b0418c48-1bcd-42d7-af16-a2ca00d02b3d)


![image](https://github.com/IkChristine/A-Retrospective-Analysis-of-COVID-19-Outbreaks-in-Nursing-Homes/assets/104997783/d93f7f3e-1287-4e7c-96ba-f6a054d409be)





## Conclusion

* Understanding the impact of the seasonal signals in COVID-19 transmission is critical to planning for public health interventions. This could help public health policy officials know when to expand healthcare capacities in preparation for high demand for healthcare resources in the colder seasons. 
* Continuous collaboration between the federal, state and local health officials is critical in solving pandemic issues in nursing homes. It would enable improved implementation of site visits to facilities with high mortality rates and low vaccination rates to better understand the facilities’ conditions influencing the disease transmission and high mortality rates. Such visits would also help officials identify probable social, cultural or religious factors that could be affecting the low vaccination rates in among residents. 
* Continuous assessment and evaluation of how resources are allocated including medical personnel, physical and mental health center options, as well as vaccine availability, is critical especially in the states with high rates of infections, high mortality and low vaccination rates.

* This analysis has provided key insights to the impact of the COVID-19 pandemic in long term facilities across the US, as well as suggested recommendations to enable better public health planning and response to the disease outbreak. 
* However, the conclusions are based on data collected from Jan 2020 – May 2023, and as the data is being updated overtime, there could be variations in the results seen in future months to come.



## Appendix

![image](https://github.com/IkChristine/A-Retrospective-Analysis-of-COVID-19-Outbreaks-in-Nursing-Homes/assets/104997783/5dd9fe04-c1cd-40db-86dd-ae6f517388d3) 



