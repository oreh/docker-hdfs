#!/bin/bash


MASTER=${MASTER:-0.0.0.0}
sed -i 's;0.0.0.0;'$MASTER';g' $HADOOP_PREFIX/etc/hadoop/core-site.xml
sed -i 's;0.0.0.0:50070;0.0.0.0:'$NAMENODE_HTTP_PORT';g' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's;0.0.0.0:50090;0.0.0.0:'$SECONDARYNAMENODE_HTTP_PORT';g' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml

exec "$@"
