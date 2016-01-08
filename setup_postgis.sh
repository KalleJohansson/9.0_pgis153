#!/bin/bash
db="bbr75"

mkdir -p /mnt/ram 
mount -t ramfs -o size=512m ramfs /mnt/ram
mkdir -p /mnt/ram/pgdata
chown postgres:postgres -R /mnt/ram/pgdata
chmod go-rwx -R /mnt/ram/pgdata

su postgres <<EOF
psql -c "CREATE TABLESPACE memory OWNER postgres LOCATION '/mnt/ram/pgdata';"
psql -c "GRANT CREATE ON TABLESPACE memory TO postgres;"
createdb --encoding=UTF8 --owner=postgres --tablespace=memory $db
psql -d $db -f /usr/share/postgresql/9.0/contrib/postgis-1.5/postgis.sql
psql -d $db -f /usr/share/postgresql/9.0/contrib/postgis-1.5/spatial_ref_sys.sql
psql -d $db -c "GRANT SELECT ON spatial_ref_sys TO PUBLIC;"
psql -d $db -c "GRANT ALL ON geometry_columns TO postgres;"
psql -d $db -c "CREATE ROLE bbr_user PASSWORD 'bbr_user' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;"
psql $db < /mnt/bbr75.bak
EOF
