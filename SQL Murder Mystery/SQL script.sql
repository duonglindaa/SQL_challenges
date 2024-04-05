--You vaguely remember that the crime was a ​murder​ that occurred sometime on ​Jan.15, 2018​ and that it took place in ​SQL City​.
SELECT *
FROM crime_scene_report
WHERE date=20180115 AND type='murder' AND city='SQL City';

--Result: Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave".
SELECT *
FROM person
WHERE address_street_name='Northwestern Dr' 
	OR (address_street_name='Franklin Ave' AND name LIKE '%Annabel%')
ORDER BY address_street_name, address_number DESC
LIMIT 2;

--Result: 2 witnesses. Next step is to retrieve their interviews.
WITH witnesses AS(SELECT *
FROM person
WHERE address_street_name='Northwestern Dr' 
	OR (address_street_name='Franklin Ave' AND name LIKE '%Annabel%')
ORDER BY address_street_name, address_number DESC
LIMIT 2)

SELECT *
FROM interview AS i
INNER JOIN witnesses AS w ON w.id=i.person_id;

--Result
--transcript 1: I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.
--transcript 2: I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".              
SELECT *
FROM get_fit_now_member AS m
INNER JOIN get_fit_now_check_in AS c ON m.id=c.membership_id
WHERE check_in_date=20180109
	AND membership_id LIKE '48Z%'
	AND membership_status='gold'

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
INNER JOIN suspects AS s ON s.person_id=p.id

--Result: Congrats, you found the murderer (Jeremy Bowers)! But wait, there's more... Try querying the interview transcript of the murderer to find the real villain behind this crime.              
SELECT i.*
FROM interview AS i
INNER JOIN person AS p ON p.id=i.person_id
WHERE p.name='Jeremy Bowers'

--Result: I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.
SELECT e.*, p.name
FROM drivers_license as d
INNER JOIN person AS p ON p.license_id=d.id
INNER JOIN facebook_event_checkin AS e ON e.person_id=p.id
WHERE (d.height BETWEEN 54 AND 58 OR d.height BETWEEN 64 AND 68)
	AND d.hair_color='red'
	AND d.car_make='Tesla'
	AND d.car_model='Model S'
	AND e.event_name='SQL Symphony Concert'
	AND e.date LIKE '201712%'

--Soltuion: Miranda Priestly

              