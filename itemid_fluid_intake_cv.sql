--------------------------------------------------------------------
--This code is used for extracting the itemids of fluid intake
--Attention: the itemids are associated with inputevents_cv
--By Xiaoli Liu
--2017.2.19
--------------------------------------------------------------------
DROP MATERIALIZED VIEW IF EXISTS itemid_fluid_intake_cv CASCADE;
create materialized view itemid_fluid_intake_cv as
with itemid_intake_1 as 
(
  SELECT itemid
	FROM inputevents_cv
	WHERE originalroute in 
	(
		'Intravenous Infusion'
		, 'IV Drip'
		, 'Intravenous'
		, 'Intravenous Push'
		, 'IV Piggyback'
		, 'GU'
	)
  and amountuom = 'ml'
	GROUP BY itemid
	ORDER BY itemid
)

, itemid_intake_21 as 
(
  SELECT itemid
	FROM inputevents_cv
  where amountuom = 'ml'
	GROUP BY itemid
)

, itemid_intake_2 as 
(
  SELECT ii21.itemid
	FROM itemid_intake_21 ii21 
	INNER JOIN d_items di
	ON ii21.itemid = di.itemid
	where ii21.itemid > 40000
	and lower(di.label) like '%bolus%'
	or lower(di.label) like '%iv%fluid%'
)

SELECT *
FROM itemid_intake_1
union
SELECT *
FROM itemid_intake_2
UNION
select di.itemid
FROM d_items di
where di.itemid in (42233,46063,46116)