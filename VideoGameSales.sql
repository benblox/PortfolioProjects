-- Checking to make sure table was imported correctly

SELECT *
FROM PortfolioProject2..['Video Game Sales$'];


-- How many games from each publisher is ranked in the Top 100

SELECT Publisher, COUNT(*) AS Count
FROM PortfolioProject2..['Video Game Sales$']
WHERE Rank <= 100
GROUP BY Publisher
ORDER BY Count DESC;


-- How many games from each publisher is ranked in the Top 1000

SELECT Publisher, COUNT(*) AS Count
FROM PortfolioProject2..['Video Game Sales$']
WHERE Rank <= 1000
GROUP BY Publisher
ORDER BY Count DESC;


-- How many total games from each publisher made more than 100,000 sales

SELECT Publisher, COUNT(*) AS Count
FROM PortfolioProject2..['Video Game Sales$']
GROUP BY Publisher
ORDER BY Count DESC;


-- How many games of each rating are in the Top 100

SELECT Rating, COUNT(*) AS Count
FROM PortfolioProject2..['Video Game Sales$']
WHERE Rank <= 100
AND Rating IS NOT NULL
GROUP BY Rating
ORDER BY Count DESC;


-- How many games in the Top 100 from each publisher have a critic score of 80 or higher

SELECT Publisher, COUNT(*) AS Count
FROM PortfolioProject2..['Video Game Sales$']
WHERE Critic_Score >= 80
AND Critic_Score IS NOT NULL
AND Rank <= 100
GROUP BY Publisher
ORDER BY Count DESC;


-- How many games from each genre are in the Top 100

SELECT Genre, COUNT(*) AS Count
FROM PortfolioProject2..['Video Game Sales$']
WHERE Rank <= 100
GROUP BY Genre
ORDER BY Count DESC;


-- Total amount of global sales of each genre

SELECT Genre, CONVERT(DECIMAL(10,2), SUM(Global_Sales)) AS Global_Sales
FROM PortfolioProject2..['Video Game Sales$']
GROUP BY Genre
ORDER BY Global_Sales DESC;


-- Total amount of global sales per year for each publisher 

SELECT Publisher, Year, CONVERT(DECIMAL(10,2), SUM(Global_Sales)) AS Total_Global_Sales
FROM PortfolioProject2..['Video Game Sales$']
WHERE Year IS NOT NULL
GROUP BY Publisher, Year
ORDER BY Publisher, Year;