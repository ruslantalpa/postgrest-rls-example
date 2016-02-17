Example of a PostgreSql schema that would be used with PostgREST on top (work in progress).
The purpose is to test if RLS provides the needed flexibility for a non trivial setup.

```
git clone https://github.com/ruslantalpa/postgrest-rls-example
cd postgrest-rls-example
vagrant up
vagrant ssh
cd /vagrant
./resetdb.sh
./runtests.sh
```