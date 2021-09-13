#letting sql write queries

use anothermysqldba;

DROP TABLE IF EXISTS A;
CREATE TABLE A(
	id int,
	name varchar(50)
); 

INSERT INTO A VALUES (1,'sorabh');
INSERT INTO A VALUES (2,'john');

DROP TABLE IF EXISTS B;
CREATE TABLE B(
	a_id int,
	`key` varchar(50),
	`value` varchar(50)
); 

INSERT INTO B VALUES (1,'looks','handsome');
INSERT INTO B VALUES (1,'lazy','yes');
INSERT INTO B VALUES (1,'car','honda');
INSERT INTO B VALUES (2,'phone','948373221');
INSERT INTO B VALUES (1,'email','some@ccid.com');

select * from a
select * from b

SELECT *
FROM A join B on a.id=b.a_id
WHERE b.a_id = 1;

select @Sql;

SET @sql = NULL;
SELECT
  GROUP_CONCAT(DISTINCT
    CONCAT(
      'max(case when `key`= ''',
      `key`,
      ''' then `value` end) AS ',
      `key`
    )
  ) INTO @sql
FROM A join B on a.id=b.a_id
WHERE b.a_id = 1;

SET @sql = CONCAT('select a.id,a.name, ', @sql, ' 
                   FROM A join B on a.id=b.a_id
					WHERE b.a_id = 1
					group by a.name');# the where clause can be removed so that it works on any id, it can be a completely dynamic pivot

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;



