#!/bin/bash


MASTER=${MASTER:-0.0.0.0}
sed -i 's;0.0.0.0;'$MASTER';g' $HADOOP_PREFIX/etc/hadoop/core-site.xml

exec "$@"
