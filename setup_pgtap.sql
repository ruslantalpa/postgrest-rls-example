\set QUIET 1
-- keep things quiet
-- Format the output for nice TAP.
\pset format unaligned
\pset tuples_only true
\pset pager

-- Revert all changes on failure.
\set ON_ERROR_ROLLBACK 1
\set ON_ERROR_STOP true

BEGIN;

CREATE EXTENSION pgtap;

-- Uncomment when testing with PGOPTIONS=--search_path=tap
-- CREATE SCHEMA tap; SET search_path TO tap,public;