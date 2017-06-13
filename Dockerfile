# influx-centos7
FROM openshift/base-centos7

# TODO: Put the maintainer name in the image metadata
MAINTAINER Liam Gaffney <liam.gaffney@cern.ch>

# TODO: Rename the builder environment variable to inform users about application you provide them
# ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Implementation of InfluxDB for Miniball status webpage" \
      io.k8s.display-name="influxdb-miniball" \
      io.openshift.expose-services="8086:https" \
      io.openshift.tags="builder,influxdb,isolde,miniball"

# TODO: Install required packages here:
RUN yum install -y emacs-nox && yum clean all -y
COPY influxdb.repo /etc/yum.repos.d/influxdb.repo
RUN yum install -y influxdb && yum clean all -y

# TODO (optional): Copy the config and run files
COPY influxdb.conf /etc/influxdb/
COPY entrypoint.sh /etc/influxdb/entrypoint.sh

# TODO: Drop the root user and make the content owned by user 1001
RUN chown -R 1001:1001 /etc/influxdb

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8083
EXPOSE 8086

# TODO: Set the default ENTRYPOINT and CMD for the image
ENTRYPOINT ["/etc/influxdb/entrypoint.sh"]
CMD ["influxd"]