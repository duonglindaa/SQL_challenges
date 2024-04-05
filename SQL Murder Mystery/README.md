# SQL Murder Mystery

### Contents 📖
- [Tasks](#tasks)
- [Outcomes](#outcomes)
- [Learnings](#learnings)

<a name="tasks"></a>
## Tasks 📋
Click on the [link](https://mystery.knightlab.com/) to find out more details.

- Using the schema and results find out who committed the crime.

<a name="outcomes"></a>
## Outcomes 🟰
[SQL script](https://github.com/duonglindaa/SQL_challenges/blob/main/SQL%20Murder%20Mystery/SQL%20script.sql)

<a name="learnings"></a>
## Learnings 🧠
Use of Common Table Expressions (CTEs):
```
WITH witnesses AS(SELECT *
FROM person
WHERE address_street_name='Northwestern Dr' 
	OR (address_street_name='Franklin Ave' AND name LIKE '%Annabel%')
ORDER BY address_street_name, address_number DESC
LIMIT 2)

SELECT *
FROM interview AS i
INNER JOIN witnesses AS w ON w.id=i.person_id;
```

Subsequent analysis and further investigation:
```
--Result: 2 people. Next step: The man got into a car with a plate that included "H42W".
WITH suspects AS (
SELECT *
FROM get_fit_now_member AS m
INNER JOIN get_fit_now_check_in AS c ON m.id=c.membership_id
WHERE check_in_date=20180109
	AND membership_id LIKE '48Z%'
	AND membership_status='gold')

SELECT d.*, p.name
FROM drivers_license AS d
INNER JOIN person AS p ON p.license_id=d.id
INNER JOIN suspects AS s ON s.person_id=p.id;
```

Problem-solving with SQL: The script presents a problem-solving scenario where SQL queries are used to identify suspects, find relevant information from various data sources, and ultimately solve a crime.
