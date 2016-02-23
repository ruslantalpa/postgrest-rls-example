-- execute with
-- sudo -H -u postgres bash -c 'psql -f ./main.sql'

drop database app;
create database app;

\connect app

begin;
alter database app set postgrest.claims.user_id to '';
alter database app set postgrest.claims.company_id to '';
create schema data;
create schema api;

\i ./data_schema.sql
\i ./api_schema.sql
\i ./roles.sql
\i ./small_rls_dataset.sql
commit;
