#prime numbers with where and join
#where join is interesting because of the subquery with outer reference
#I find the left join is easier to understand
#table population is also nice
https://stackoverflow.com/questions/37234893/print-prime-numbers-with-sql-query

drop temporary table if exists n;
create temporary table if not exists n engine=memory
    select t2.c*100 + t1.c*10 + t0.c + 1 as seq from 
    (select 0 c union all select 1 c union all select 2 c union all select 3 c union all select 4 c union all select 5 c union all select 6 c union all select 7 c union all select 8 c union all select 9 c) t0,
    (select 0 c union all select 1 c union all select 2 c union all select 3 c union all select 4 c union all select 5 c union all select 6 c union all select 7 c union all select 8 c union all select 9 c) t1,
    (select 0 c union all select 1 c union all select 2 c union all select 3 c union all select 4 c union all select 5 c union all select 6 c union all select 7 c union all select 8 c union all select 9 c) t2
    having seq > 2 and seq % 2 != 0;

drop temporary table if exists q;
create temporary table if not exists q engine=memory
    select *
    from n
    where seq <= 1000;
alter table q add primary key seq (seq);


#example with where
select 2 as p 
union all
select n.seq
from n
where not exists (
#if this query is empty, n.seq in the outer query will be selected
    select 1 #we could have written q.seq for instance
    from q
    where q.seq < n.seq #returns a big table, all values from q paired with all values from n that are lower than the q value
      and n.seq mod q.seq = 0 # checks if they are divisible, and because of that not prime
);

select * from n;
select * from q;

#example with left join

select 1 as i, 2 as p union all
select 1 as i, n.seq
from n
left join q
    on  q.seq < n.seq
    and n.seq mod q.seq = 0
where q.seq is null
order by p;