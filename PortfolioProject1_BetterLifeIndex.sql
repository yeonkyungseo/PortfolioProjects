/* Portfolio Project #1 Better Life Index OECD */
-- Total Life Satisfaction
CREATE TABLE TotalLifeSatisfaction
(
	Country nvarchar(255),
	LifeSatisfaction float
)
INSERT INTO TotalLifeSatisfaction
SELECT Country, Value
FROM BetterLifeIndexTrimmed
Where IndicatorCode = 'SW_LIFS' AND Inequality = 'Total'
Order by Country

-- Labour market insecurity Ranking
SELECT *
FROM BetterLifeIndexTrimmed
Where IndicatorCode = 'JE_LMIS' AND Inequality = 'Total'
order by Value

-- Dwelling without basic facilities Ranking
SELECT *
FROM BetterLifeIndexTrimmed
Where IndicatorCode = 'HO_BASE' AND Inequality = 'Total'
order by Value

-- Feeling safe walking alone at night
SELECT *
FROM BetterLifeIndexTrimmed
Where IndicatorCode = 'PS_FSAFEN' AND Inequality = 'Total'
order by Value desc

-- Correlation between Employment Rate Gender Gap and Total Life Satisfaction
-- Create Tables of Employment Rate for each gender
CREATE TABLE MenEmploymentRate
(
	Country nvarchar(255),
	IndicatorCode nvarchar(255),
	Indicator nvarchar(255),
	Unit nvarchar(255),
	MenValue float,
	Inequality nvarchar(255)
)
INSERT INTO MenEmploymentRate
SELECT Country, IndicatorCode, Indicator, Unit, Value, inequality
FROM BetterLifeIndexTrimmed
Where Inequality = 'Men'

CREATE TABLE WomenEmploymentRate
(
	Country nvarchar(255),
	IndicatorCode nvarchar(255),
	Indicator nvarchar(255),
	Unit nvarchar(255),
	WomenValue float,
	Inequality nvarchar(255)
)
INSERT INTO WomenEmploymentRate
SELECT Country, IndicatorCode, Indicator, Unit, Value, inequality
FROM BetterLifeIndexTrimmed
Where Inequality = 'Women'

-- JOIN TABLES and Calculate the Employment Rate Difference between the genders
CREATE TABLE GenderGapEmplTotalLifs
(
	Country nvarchar(255),
	IndicatorCode nvarchar(255),
	Indicator nvarchar(255),
	Unit nvarchar(255),
	MenValue float,
	WomenValue float,
	GenderGap float
)
INSERT INTO GenderGapEmplTotalLifs
SELECT m.Country, m.IndicatorCode, m.Indicator, m.Unit, m.MenValue, w.WomenValue,
CASE WHEN m.MenValue > w.WomenValue THEN m.MenValue - w.WomenValue
	 ELSE w.WomenValue - m.MenValue
	 END as GenderGap
FROM MenEmploymentRate m
JOIN WomenEmploymentRate w
	ON m.Country = w.Country
	AND m.IndicatorCode = w.IndicatorCode
Where m.IndicatorCode = 'JE_EMPL'
Order by IndicatorCode, Country

-- View the Correlation between GenderGap in Employment Rate and LifeSatisfaction by Countries
SELECT a.Country, a.GenderGap, b.LifeSatisfaction
FROM GenderGapEmplTotalLifs a
JOIN TotalLifeSatisfaction b
	ON a.Country = b.Country