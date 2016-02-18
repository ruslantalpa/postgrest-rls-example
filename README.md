Example of a PostgreSql schema that would be used with PostgREST on top (work in progress).
The purpose is to test if flexible RLS security si possible using views (or RLS in 9.5) for a nontrivial setup.

```
git clone https://github.com/ruslantalpa/postgrest-rls-example
cd postgrest-rls-example
vagrant up
vagrant ssh
cd /vagrant
./resetdb.sh
./runtests.sh
```