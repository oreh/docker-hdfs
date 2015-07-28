# Apache Hadoop 2.4 - HDFS only

Simple docker images for hdfs


# How to use

## Build Image

```bash
./build
```

## Config

Modify hack/set-default.sh.tmpl


## Run

```bash
hack/start_namenode.sh
hack/start_secondarynamenode.sh
hack/start_datanode.sh
hack/hdfs dfs -mkdir /tmp
hack/hdfs dfs -ls /
```

# Reference

[ruo91](https://github.com/ruo91/docker-hadoop)
