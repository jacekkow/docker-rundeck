FROM openjdk:8-jre-slim-stretch

ENV DEBIAN_FRONTEND noninteractive
ENV RDECK_JVM_SETTINGS "-Xmx1024m -Xms256m -XX:MaxMetaspaceSize=256m -server"

EXPOSE 4440

ADD *-gpg.key /root/
RUN apt-get -y update \
	&& apt-get -y upgrade \
	&& apt-get -y install openssh-client wget gnupg \
	&& echo "deb http://dl.bintray.com/rundeck/rundeck-deb /" \
		> /etc/apt/sources.list.d/rundeck.list \
	&& cat /root/*-gpg.key | apt-key add - \
	&& apt-get -y update \
	&& apt-get -y install rundeck \
	&& apt-get -y clean \
	&& rm -Rf /var/lib/apt/lists/*

RUN echo "deb http://ftp.debian.org/debian stretch-backports main" \
		> /etc/apt/sources.list.d/backports.list \
	&& apt-get -y update \
	&& apt-get -y upgrade \
	&& apt-get -y -t stretch-backports install \
		ansible git python-netaddr python3-netaddr \
	&& apt-get -y clean \
	&& rm -Rf /var/lib/apt/lists/*

RUN mkdir /etc/rundeck-org \
       && mv /etc/rundeck/* /etc/rundeck-org/

ADD run.sh /
CMD /run.sh

VOLUME /etc/rundeck
VOLUME /var/lib/rundeck/data
VOLUME /var/lib/rundeck/logs
VOLUME /var/rundeck
