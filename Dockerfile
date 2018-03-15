FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

EXPOSE 4440

ADD *-gpg.key /root/
RUN apt-get -y update \
	&& apt-get -y install gnupg \
	&& apt-get -y upgrade \
	&& echo 'deb http://httpredir.debian.org/debian stretch-backports main' > \
		/etc/apt/sources.list.d/stretch-backports.list \
	&& echo "deb http://dl.bintray.com/rundeck/rundeck-deb /" > /etc/apt/sources.list.d/rundeck.list \
	&& cat /root/*-gpg.key | apt-key add - \
	&& apt-get -y update \
	&& apt-get -y -t stretch-backports install \
		openssh-client openjdk-8-jre-headless wget rundeck \
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
