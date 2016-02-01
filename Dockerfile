#
# NAME     Dockerfile
# VERSION  1.5.1-SNAPSHOT
# DATE     2016-01-20
#
# Copyright 2012-2016
#
# This file is part of the Linked Data Theatre.
#
# The Linked Data Theatre is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# The Linked Data Theatre is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with the Linked Data Theatre.  If not, see <http://www.gnu.org/licenses/>.
#

FROM java:openjdk-7-jdk
MAINTAINER Rein <rein.van.t.veer@geodan.nl>

RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
        wget \
        pwgen \
        ca-certificates \
        maven \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV TOMCAT_MAJOR_VERSION 7
ENV TOMCAT_MINOR_VERSION 7.0.62
ENV CATALINA_HOME /tomcat

# INSTALL TOMCAT
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
    wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \
    tar zxf apache-tomcat-*.tar.gz && \
    rm apache-tomcat-*.tar.gz && \
    mv apache-tomcat* tomcat

RUN mkdir /ldt
ADD . /ldt
WORKDIR /ldt/license-builder
RUN mvn install
WORKDIR /ldt/ext-resources
RUN mvn package
WORKDIR /ldt/morphrdb
RUN mvn package
WORKDIR /ldt/orbeon
RUN mvn package
WORKDIR /ldt/processors
RUN mvn install:install-file -Dfile=../morphrdb/morph-rdb-dist-3.5.15.jar -DgroupId=morphrdb -DartifactId=morphrdb -Dversion=3.5.15 -Dpackaging=jar -DgeneratePom=true
RUN mvn install:install-file -Dfile=../orbeon/WEB-INF/lib/orbeon.jar -DgroupId=orbeon -DartifactId=orbeon -Dversion=4.10.0 -Dpackaging=jar -DgeneratePom=true
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
RUN mvn install -e

# Main package for Linked Data Theatre
WORKDIR /ldt
RUN mvn package
RUN rm -r /tomcat/webapps/*
RUN mkdir /tomcat/webapps/ROOT
RUN cp -r /ldt/target/ldt*/* /tomcat/webapps/ROOT/
RUN cp -r /ldt/src-pdok/main /tomcat/webapps/ROOT/main

RUN chmod +x /ldt/scripts/*.sh

EXPOSE 8080
CMD ["/ldt/scripts/run.sh"]
