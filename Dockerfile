FROM     ubuntu:14.04
MAINTAINER Wang Qiang <wangqiang8511@gmail.com>

# Last Package Update & Install
RUN apt-get update && apt-get install -y curl wget net-tools iputils-ping vim

# JDK
ENV JDK_URL http://download.oracle.com/otn-pub/java/jdk
ENV JDK_VER 8u51-b16
ENV JDK_VER2 jdk-8u51
ENV JAVA_HOME /usr/local/jdk
ENV PATH $PATH:$JAVA_HOME/bin
RUN cd $SRC_DIR && curl -LO "$JDK_URL/$JDK_VER/$JDK_VER2-linux-x64.tar.gz" -H 'Cookie: oraclelicense=accept-securebackup-cookie' \
 && tar xzf $JDK_VER2-linux-x64.tar.gz && mv jdk1* $JAVA_HOME && rm -f $JDK_VER2-linux-x64.tar.gz \
 && echo '' >> /etc/profile \
 && echo '# JDK' >> /etc/profile \
 && echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile \
 && echo 'export PATH="$PATH:$JAVA_HOME/bin"' >> /etc/profile \
 && echo '' >> /etc/profile

# Apache Hadoop
ENV SRC_DIR /opt
ENV HADOOP_URL http://archive.apache.org/dist/hadoop/common
ENV HADOOP_VERSION hadoop-2.4.1
RUN cd $SRC_DIR && wget "$HADOOP_URL/$HADOOP_VERSION/$HADOOP_VERSION.tar.gz" \
 && tar xzf $HADOOP_VERSION.tar.gz ; rm -f $HADOOP_VERSION.tar.gz

# Hadoop ENV
ENV HADOOP_PREFIX $SRC_DIR/$HADOOP_VERSION
ENV PATH $PATH:$HADOOP_PREFIX/bin:$HADOOP_PREFIX/sbin
ENV HADOOP_MAPRED_HOME $HADOOP_PREFIX
ENV HADOOP_COMMON_HOME $HADOOP_PREFIX
ENV HADOOP_HDFS_HOME $HADOOP_PREFIX
ENV YARN_HOME $HADOOP_PREFIX
RUN echo '# Hadoop' >> /etc/profile \
 && echo "export HADOOP_PREFIX=$HADOOP_PREFIX" >> /etc/profile \
 && echo 'export PATH=$PATH:$HADOOP_PREFIX/bin:$HADOOP_PREFIX/sbin' >> /etc/profile \
 && echo 'export HADOOP_MAPRED_HOME=$HADOOP_PREFIX' >> /etc/profile \
 && echo 'export HADOOP_COMMON_HOME=$HADOOP_PREFIX' >> /etc/profile \
 && echo 'export HADOOP_HDFS_HOME=$HADOOP_PREFIX' >> /etc/profile \
 && echo 'export YARN_HOME=$HADOOP_PREFIX' >> /etc/profile

# Add in the etc/hadoop directory
ADD conf/core-site.xml $HADOOP_PREFIX/etc/hadoop/core-site.xml
ADD conf/hdfs-site.xml $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
ADD conf/yarn-site.xml $HADOOP_PREFIX/etc/hadoop/yarn-site.xml
ADD conf/mapred-site.xml $HADOOP_PREFIX/etc/hadoop/mapred-site.xml
RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/local/jdk:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

ADD scripts /scripts

# Name node foramt
RUN hdfs namenode -format
ENV NAMENODE_HTTP_PORT=50070
ENV SECONDARYNAMENODE_HTTP_PORT=50090

ENTRYPOINT ["/scripts/setup.sh"]
