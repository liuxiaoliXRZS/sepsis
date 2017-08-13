--------------------------------------------------------------------
--This code is used for extracting the itemids of inputevents_mv's fluid intake
-- inputevents_mv: amountuom _  L  /mL  /?L  /ml/hr
-- not include oral/Gastric Intake
--L:need to modify the value, for example: 5000L to 5000mL
--  itemid: 226361, 226364, 225158, 225828
--?L: only one record and 2ml, so it's not included
--ml/hr: include 10 records ,itemid = 227536, KCl (CRRT) , it should not be included
--By Xiaoli Liu
--2017.3.5
--------------------------------------------------------------------

DROP MATERIALIZED VIEW IF EXISTS itemid_fluid_intake_mv CASCADE;
create materialized view itemid_fluid_intake_mv as
SELECT itemid 
FROM inputevents_mv 
WHERE ordercategoryname in (
      '07-Blood Products'
      , '03-IV Fluid Bolus'
      , '01-Drips'
      , '10-Prophylaxis (IV)'
      , '02-Fluids (Crystalloids)'
      , '08-Antibiotics (IV)'
      , '04-Fluids (Colloids)'
      , '16-Pre Admission'
      , '05-Med Bolus'
)
AND amountuom = 'mL'
GROUP BY itemid
order BY itemid