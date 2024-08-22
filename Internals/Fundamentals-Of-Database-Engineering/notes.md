resource:

## Progress

- [ ] ACID
- [x] Understanding Database Internals
- [ ] Database Indexing
- [ ] B-Tree vs B+Tree in production
- [ ] Database Partitioning
- [ ] Database Sharding
- [ ] Concurrency Control
- [ ] Database Replication
- [ ] Database System Design
- [ ] Database Engine
- [ ] Database Cursors
- [ ] Database Security
- [ ] Homomophic Encryption - Performing Database Queries on Encrypted Data
My Comment:

## ACID

## Understaning Database Internals

## Database Indexing

Inserting 1 million row at a temp table

Here's the prerequisists

```sh
docker run -e POSTGRES_PASSWORD=postgres --name pg1-indexing postgres
docker exec -it pg1-indexing psql -U postgres
```

```SQL
CRATE TABLE temp(int t);
INSERT INTO temp(t) SELECT random() * 100 FROM generate_series(0, 1000000);
```

```sh
--employees table for the indexing lecture
--paste these commands into the postgres
--start the docker instance
docker run --name pg -e POSTGRES_PASSWORD=postgres -d postgres

docker start pg
--run postgres command shell
docker exec -it pg psql -U postgres
--the command should switch to
--postgres=#
-- paste these sql
create table employees( id serial primary key, name text);

create or replace function random_string(length integer) returns text as
$$
declare
  chars text[] := '{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
  result text := '';
  i integer := 0;
  length2 integer := (select trunc(random() * length + 1));
begin
  if length2 < 0 then
    raise exception 'Given length cannot be less than 0';
  end if;
  for i in 1..length2 loop
    result := result || chars[1+random()*(array_length(chars, 1)-1)];
  end loop;
  return result;
end;
$$ language plpgsql;

insert into employees(name)(select random_string(10) from generate_series(0, 1000000));
```

we've an index over the id `employees_pkey`

```sql
explain analyze select id from employees where id = 2000;

-- output

                                                          QUERY PLAN

-------------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using employees_pkey on employees  (cost=0.42..4.44 rows=1 width=4) (actual time=0.009..0.009 rows=0 loops=1)
   Index Cond: (id = 2000)
   Heap Fetches: 0 -- notice that we didn't go to the heap
 Planning Time: 0.221 ms
 Execution Time: 0.069 ms
(5 rows)
```

Notice we didn't go to the heap, as the information we need is found on the index (that's the best query you can make at your life :D)

```sql
explain analyze select name from employees where id = 2000;

--output
                                                      QUERY PLAN

--------------------------------------------------------------------------------------------------------------------------
 Index Scan using employees_pkey on employees  (cost=0.42..8.44 rows=1 width=6) (actual time=0.012..0.012 rows=0 loops=1)
   Index Cond: (id = 2000)
 Planning Time: 0.224 ms
 Execution Time: 0.070 ms
(4 rows)

```

However here the id is on the index, but the name column not, so we jump to the heap with id=2000 to find the page and retrieve name from the heap.

Let's have another interesting query

```sql
explain analyze select id from employees where name = 'LAN';

--output (Full table scan)


                                                       QUERY PLAN

------------------------------------------------------------------------------------------------------------------------
 Gather  (cost=1000.00..14372.94 rows=6 width=4) (actual time=18.219..94.551 rows=1 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Seq Scan on employees  (cost=0.00..13372.34 rows=2 width=4) (actual time=28.857..47.212 rows=0 loops=3)
         Filter: (name = 'LAN'::text)
         Rows Removed by Filter: 333333
 Planning Time: 0.122 ms
 Execution Time: 94.573 ms
(8 rows)
```

postgres or other databases don't need to entirely scan through table using one worker thread, most of the times a parallel worker threads are scaning the table for faster search.

now let's create an index on the name column;

```sql
create index employees_name on employees(name);
```

Let's do a query on the name

```sql
explain analyze select id, name from employees where name = 'Zs';
--output

                                                       QUERY PLAN

------------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on employees  (cost=4.47..28.06 rows=6 width=10) (actual time=0.036..0.079 rows=30 loops=1)
   Recheck Cond: (name = 'Zs'::text)
   Heap Blocks: exact=30
   ->  Bitmap Index Scan on employees_name  (cost=0.00..4.47 rows=6 width=0) (actual time=0.027..0.028 rows=30 loops=1)
         Index Cond: (name = 'Zs'::text)
 Planning Time: 0.264 ms
 Execution Time: 0.098 ms
(7 rows)

```

Good, now we're getting great result, so Let's take another interesting query

```sql
explain analyze select id, name from employees where name like '%Zs%'

-- output

                                                        QUERY PLAN

---------------------------------------------------------------------------------------------------------------------------
 Gather  (cost=1000.00..14381.34 rows=90 width=10) (actual time=1.537..78.535 rows=1236 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Seq Scan on employees  (cost=0.00..13372.34 rows=38 width=10) (actual time=0.547..54.611 rows=412 loops=3)
         Filter: (name ~~ '%Zs%'::text)
         Rows Removed by Filter: 332922
 Planning Time: 0.080 ms
 Execution Time: 78.652 ms
(8 rows)
```

Oh, back to the parallel sequential scan again :D, why does this happen?
> [!note] Using like statement
> using like is a kind of statement that doen't match only a single value, we can't use this to select from index, so we've to go to the heap to match with all occurances
> So the planner will decide once see statements like this to plan a worker threads to start scaning through table

Knowing how to read the `explain analyze` statement is very important to you as a software engineer to take further decisions based on that readings, in this section we'll learn how to read it.

Prerequisists

```sql
--explain explained
-- make sure to run the container with at least 1gb shared memory
-- docker run --name pg —shm-size=1g -e POSTGRES_PASSWORD=postgres —name pg postgres
create table grades (
id serial primary key,
 g int,
 name text
);

insert into grades (g,
name  )
select
random()*100,
substring(md5(random()::text ),0,floor(random()*31)::int)
 from generate_series(0, 500);

vacuum (analyze, verbose, full);

create index g_idx on grades(g);
explain analyze select id,g from grades where g > 80 and g < 95 order by g;
```

now let's have a simple query

```sql
explain analyze select * from grades order by g;

--output



                                                     QUERY PLAN

--------------------------------------------------------------------------------------------------------------------
 Index Scan using g_idx on grades  (cost=0.15..31.66 rows=501 width=22) (actual time=0.017..0.162 rows=501 loops=1)
 Planning Time: 0.306 ms
 Execution Time: 0.201 ms
(3 rows)
```

- First part (Index Scan using g_idx on grades ) describes the query plan
- Second part ((cost=0.15..31.66 rows=501 width=22))
 	- cost usually starts from zero

## B-Tree vs B+Tree in production

## Resources
