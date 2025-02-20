## NYC Mobility Insights through Integrated Data Engineering Solutions 🚲🌤️📊

### Project Overview
This project analyzes **Citi Bike ridership in NYC**, integrating public datasets on **weather conditions** and **MTA subway usage** to uncover trends, optimize resource allocation, and enhance urban mobility. We utilize **Python, MySQL, Google Cloud Platform (GCP), and Tableau** for data engineering and analytics.

### Objectives
- Identify **shared-bike demand patterns** and **weather impact** on ridership.
- Develop **predictive models** to estimate ride demand.
- Provide actionable recommendations for **bike station rebalancing** and **transit optimization**.
- Build an **interactive dashboard** for ongoing monitoring.

### 🗂Data Sources
- **Citi Bike Ridership:** ~69M rides (~6GB) [Source](https://citibikenyc.com/system-data)
- **Weather Sensor Logs:** 10-min intervals, 20+ variables [Source](https://mesonet.agron.iastate.edu/request/download.phtml?network=NY_ASOS)
- **MTA Subway Hourly Ridership:** ~52M records (~3GB) [Source](https://data.ny.gov/Transportation/MTA-Subway-Hourly-Ridership-Beginning-July-2020/wujg-7c2s/about_data)

### Tech Stack
- **Data Storage & Processing:** MySQL (GCP Cloud SQL)
- **ETL Pipeline:** Python (Pandas, SQLAlchemy)
- **Data Analysis & Visualization:** SQL, Tableau
- **Machine Learning Models:** Random Forest, Time Series (Linear Regression)

## Key Insights
- **Weather Impact:** Precipitation and wind speed significantly reduce ridership.
- **Peak Demand Stations:** Times Square, Grand Central, and major transit hubs have the highest usage.
- **Predictive Modeling:** A **Random Forest model** estimates ride demand with **MAE: 442.68** and **RMSE: 536.58**.
- **Time Series Forecasting:** Including **temperature data** improved accuracy (**R²: 0.94**).

## Dashboard
An interactive Tableau dashboard was built for monitoring ridership trends.  

## Future Enhancements
- **Expand data scope** to include more external factors (e.g., events, holidays).
- **Improve model performance** using LSTM or ARIMA for better time-series forecasting.
- **Deploy live API** to provide real-time demand forecasting.

## 📄 License
This project is licensed under the MIT License. See `LICENSE` for details.
