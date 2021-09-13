#https://kristiannielsen.livejournal.com/6745.html
#Selecting rows holding group-wise maximum of a field

use  mydatabase
select * 
from customers


CREATE TABLE object_versions (
  object_id INT NOT NULL,
  version INT NOT NULL,
  data VARCHAR(1000),
  PRIMARY KEY(object_id, version)
) ENGINE=InnoDB

select *
from object_versions

Insert into object_versions VALUES
(1001, 1, 'Beay'),
(1002, 1, 'Bsley'),
(1003, 1, 'Beasley'),
(1004, 1, 'esley'),
(1005, 1, 'By'),
(1005, 2, 'B'),
(1005, 3, 'easley'),
(1006, 1, 'Beasey'),
(1006, 2, 'Bealey'),
(1006, 3, 'Bsley'),
(1007, 1, 'easley'),
(1008, 1, 'easley'),
(1008, 2, 'Beasley'),
(1009, 1, 'asley'),
(1009, 2, 'Beasley')

#it calls the subquery for every row in the main query
EXPLAIN SELECT * FROM object_versions o1 WHERE version IN
(SELECT MAX(version) FROM object_versions o2 WHERE o1.object_id = o2.object_id);


+ ------- + ---------------- + ---------- + --------------- + --------- + ------------------ + -------- + ------------ + -------- + --------- + ------------- + ---------- +
| id      | select_type      | table      | partitions      | type      | possible_keys      | key      | key_len      | ref      | rows      | filtered      | Extra      |
+ ------- + ---------------- + ---------- + --------------- + --------- + ------------------ + -------- + ------------ + -------- + --------- + ------------- + ---------- +
| 1       | PRIMARY          | o1         |                 | ALL       |                    |          |              |          | 15        | 100.00        | Using where |
| 2       | DEPENDENT SUBQUERY | o2         |                 | ref       | PRIMARY            | PRIMARY  | 4            | mydatabase.o1.object_id | 1         | 100.00        | Using index |
+ ------- + ---------------- + ---------- + --------------- + --------- + ------------------ + -------- + ------------ + -------- + --------- + ------------- + ---------- +



#uncorrelated subquery, much much faster
Explain SELECT o1.*, o2.* FROM object_versions o1
INNER JOIN (SELECT object_id, MAX(version) AS version FROM object_versions GROUP BY object_id) o2
ON (o1.object_id = o2.object_id and o1.version = o2.version);


+ ------- + ---------------- + ---------- + --------------- + --------- + ------------------ + -------- + ------------ + -------- + --------- + ------------- + ---------- +
| id      | select_type      | table      | partitions      | type      | possible_keys      | key      | key_len      | ref      | rows      | filtered      | Extra      |
+ ------- + ---------------- + ---------- + --------------- + --------- + ------------------ + -------- + ------------ + -------- + --------- + ------------- + ---------- +
| 1       | PRIMARY          | <derived2> |                 | ALL       |                    |          |              |          | 10        | 100.00        | Using where |
| 1       | PRIMARY          | o1         |                 | eq_ref    | PRIMARY            | PRIMARY  | 8            | o2.object_id,o2.version | 1         | 100.00        |            |
| 2       | DERIVED          | object_versions |                 | range     | PRIMARY            | PRIMARY  | 4            |          | 10        | 100.00        | Using index for group-by |
+ ------- + ---------------- + ---------- + --------------- + --------- + ------------------ + -------- + ------------ + -------- + --------- + ------------- + ---------- +


