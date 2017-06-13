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
RUN cat <<EOF | tee /etc/yum.repos.d/influxdb.repo \
  [influxdb] \
  name = InfluxDB Repository - RHEL \$releasever \
  baseurl = https://repos.influxdata.com/centos/\$releasever/\$basearch/stable \
  enabled = 1 \
  gpgcheck = 1 \
  gpgkey = https://repos.influxdata.com/influxdb.key \
  EOF
RUN yum install -y influxdb && yum clean all -y

# TODO (optional): Copy the config files into /etc/
COPY ./influxdb.conf /etc/influxdb/

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /var/lib/influxdb
RUN chown -R 1001:1001 /etc/influxdb

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8083
EXPOSE 8086

# TODO: Set the default ENTRYPOINT and CMD for the image
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["influxd"]