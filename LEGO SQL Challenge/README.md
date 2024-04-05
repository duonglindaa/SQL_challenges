# LEGO SQL Challenge

### Contents 📖
- [Tasks](#tasks)
- [Outcomes](#outcomes)
- [Learnings](#learnings)

<a name="tasks"></a>
## Tasks 📋
Click on the [link](https://github.com/wjsutton/lego_analysis_challenge) to find out more details.

- Schema setup
  - create schema
  - create tables
  - insert data
  - set primary and foreign key
  - create ER diagram

- Analysis
  - find unique parts
  - analyse sets
  - create view
  - download data

- Visualise data

<a name="outcomes"></a>
## Outcomes 🟰
#### Schema setup
[SQL script](https://github.com/duonglindaa/SQL_challenges/blob/main/LEGO%20SQL%20Challenge/SQL%20script.sql) for creating the schema.

ER diagram:
![Screenshot](https://github.com/duonglindaa/SQL_challenges/blob/main/LEGO%20SQL%20Challenge/ER%20diagram.png?raw=true)


#### Analysis
[SQL script](https://github.com/duonglindaa/SQL_challenges/blob/main/LEGO%20SQL%20Challenge/SQL%20script.sql) for analysing and creating the data for visualization.

#### Visualisation
![Screenshot](https://github.com/duonglindaa/SQL_challenges/blob/main/LEGO%20SQL%20Challenge/Dashboard%201.png?raw=true)

<a name="learnings"></a>
## Learnings 🧠
Schema creation:
```
CREATE SCHEMA TIL_PORTFOLIO_PROJECTS.LINDA_DUONG;
```

Table creation:
```
CREATE TABLE TIL_PORTFOLIO_PROJECTS.LINDA_DUONG.LEGO_COLORS (
	ID INT,
	NAME VARCHAR(50),
	RGB VARCHAR(6),
	IS_TRANS VARCHAR(1)
);
```

Table insertion:
```
INSERT INTO TIL_PORTFOLIO_PROJECTS.LINDA_DUONG.LEGO_COLORS(
SELECT *
FROM TIL_PORTFOLIO_PROJECTS.STAGING.LEGO_COLORS
);
```

Relationship creation:
```
ALTER TABLE LEGO_THEMES ADD PRIMARY KEY (ID);
ALTER TABLE LEGO_SETS ADD FOREIGN KEY (THEME_ID) REFERENCES LEGO_THEMES(ID);
```

View creation:
```
CREATE VIEW SETS_W_UNIQUENESS_RATIO AS
WITH UNIQUE_PARTS AS (
SELECT PARTS.PART_NUM AS UNIQUE_PART_NUMBER, COUNT(DISTINCT SETS.SET_NUM) AS "Number of sets appeared in"
FROM LEGO_SETS AS SETS
LEFT JOIN LEGO_INVENTORIES AS INV ON INV.SET_NUM=SETS.SET_NUM
LEFT JOIN LEGO_INVENTORY_PARTS AS INVP ON INV.ID=INVP.INVENTORY_ID
LEFT JOIN LEGO_PARTS AS PARTS ON PARTS.PART_NUM=INVP.PART_NUM
GROUP BY PARTS.PART_NUM
HAVING COUNT(DISTINCT SETS.SET_NUM)=1
)

SELECT  
    SETS.NAME,
    SETS.YEAR,
    T.NAME AS THEME,
    COUNT (DISTINCT U.UNIQUE_PART_NUMBER) AS "Number of unique parts",
    COUNT (DISTINCT INVP.PART_NUM) AS "Number of parts",
    (COUNT (DISTINCT U.UNIQUE_PART_NUMBER)/COUNT (DISTINCT INVP.PART_NUM)) AS UNIQUENESS
FROM LEGO_SETS AS SETS
LEFT JOIN LEGO_INVENTORIES AS INV ON INV.SET_NUM=SETS.SET_NUM
LEFT JOIN LEGO_INVENTORY_PARTS AS INVP ON INV.ID=INVP.INVENTORY_ID
LEFT JOIN UNIQUE_PARTS AS U ON INVP.PART_NUM=U.UNIQUE_PART_NUMBER
LEFT JOIN LEGO_THEMES AS T ON T.ID=SETS.THEME_ID
GROUP BY SETS.NAME, SETS.YEAR, T.NAME
HAVING COUNT (DISTINCT INVP.PART_NUM)>0
ORDER BY UNIQUENESS DESC
;
```


