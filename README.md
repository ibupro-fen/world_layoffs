# World Layoffs Analysis SQL Project

The purpose of this  project is to demonstrate SQL skills and techniques used to clean data and explore the layoffs data
Starting off, setting a goal in mind for what we are looking for is ideal, especially when exploring data

## Data Cleaning
- Remove Duplicates
- Standardize data
- Null values or blank values
- Remove any unnecessary columns


## Data Exploratory Analysis
- Copy the table (keep the raw table)
- Industries affected by COVID
- Total layoffs in each company, country, and industry

### Software Used
This project was being worked on using mySQL workbench which makes it easy to import data but if using software requiring the syntax please use:

```sql
CREATE DATABASE world_layoffs_db

CREATE TABLE layoffs
(
company VARCHAR(30),
location VARCHAR(30),
industry VARCHAR(30),
total_laid_off INT,
percentage_laid_off DOUBLE(1, 6),
date VARCHAR(30),
stage VARCHAR(30),
country VARCHAR (30),
funds_raised_millions INT
);
```

