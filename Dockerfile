# vim:set ft=dockerfile:
FROM raa-pg90_pgis153:latest
#ADD fix-acl.sh /docker-entrypoint-initdb.d/
ADD setup_postgis.sh /docker-entrypoint-initdb.d/
