FROM debian:latest

ENV DEBIAN_FRONTEND noninteractive

EXPOSE 4440

ADD *-gpg.key /root/
RUN echo "deb http://dl.bintray.com/rundeck/rundeck-deb /" > /etc/apt/sources.list.d/rundeck.list \
	&& cat /root/*-gpg.key | apt-key add -

RUN apt-get -y update \
	&& apt-get -y upgrade \
	&& apt-get -y install openssh-client default-jre-headless wget rundeck \
	&& apt-get -y clean

RUN mkdir /etc/rundeck-org \
	&& mv /etc/rundeck/* /etc/rundeck-org/

ADD run.sh /
CMD /run.sh

VOLUME /etc/rundeck
VOLUME /var/lib/rundeck/data
VOLUME /var/lib/rundeck/logs
VOLUME /var/rundeck
