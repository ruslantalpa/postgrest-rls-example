
\connect app

set search_path to data;



create or replace function get_random_number(integer, integer)
returns integer
language sql
as $$
	select trunc(random() * ($2-$1) + $1)::integer;
$$ ;

drop table if exists sample_data;
create table sample_data ( 
	people text,
	companies text,
	emails text,
	clients text,
	projects text,
	tasks text
);

COPY sample_data FROM '/vagrant/sample_data.csv' DELIMITER '|' CSV HEADER;

-- insert sample data
-- companies
insert into companies (name)
select companies
from sample_data;

-- clients
insert into clients (name, company_id)
select * from (
	with source as
	(
		select field, row_number() over () as rn
		from (
			select field, generate_series(1, cnt)
			from (
				select field, get_random_number(3, 7) as cnt
				from (
					select id as field from companies
					where id > 100
				) t
			) t
		) t
	),
	random_data as (
		select field, row_number() over() as rn
		from (
	   		select field, generate_series(1, 7) 
	   		from (
	   			select clients as field from sample_data
	   		) t
	   		order by random()
		) t
	)

	select random_data.field as name, source.field as company_id
	from source
	inner join
	random_data on source.rn = random_data.rn
) t;


-- projects
insert into projects (name, client_id, company_id)
select * from (
	with source as
	(
		select field1, field2, row_number() over () as rn
		from (
			select field1, field2, generate_series(1, cnt)
			from (
				select field1, field2, get_random_number(2, 4) as cnt
				from (
					select id as field1, company_id as field2 from clients
					where id > 100
				) t
			) t
		) t
	),
	random_data as (
		select field, row_number() over() as rn
		from (
	   		select field, generate_series(1, 7) 
	   		from (
	   			select projects as field from sample_data
	   		) t
	   		order by random()
		) t
	)

	select random_data.field as name, source.field1 as client_id, source.field2 as company_id
	from source
	inner join
	random_data on source.rn = random_data.rn
) t;

-- tasks
insert into tasks (name, project_id, company_id)
select * from (
	with source as
	(
		select field1, field2, row_number() over () as rn
		from (
			select field1, field2, generate_series(1, cnt)
			from (
				select field1, field2, get_random_number(3, 10) as cnt
				from (
					select id as field1, company_id as field2 from projects
					where id > 100
				) t
			) t
		) t
	),
	random_data as (
		select field, row_number() over() as rn
		from (
	   		select field, generate_series(1, 30) 
	   		from (
	   			select tasks as field from sample_data
	   		) t
	   		order by random()
		) t
	)

	select random_data.field as name, source.field1 as project_id, source.field2 as company_id
	from source
	inner join
	random_data on source.rn = random_data.rn
) t;


