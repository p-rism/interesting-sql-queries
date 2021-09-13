#rank value in mysql
#recreate rank func from ms sql
https://stackoverflow.com/questions/3217217/grabbing-first-row-in-a-mysql-query-only

SELECT t.*,
       @rownum := @rownum +1 AS rank
  FROM TBL_FOO t
  JOIN (SELECT @rownum := 0) r
 WHERE t.name = 'sarmen'