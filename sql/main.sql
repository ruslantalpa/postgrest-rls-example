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
\i ./functions.sql
\i ./schema.sql
\i ./roles.sql
\i ./data.sql
--\i ./rls.sql
commit;
