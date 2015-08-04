FROM debian:latest

ENV DEBIAN_FRONTEND noninteractive
ENV RUNDECK_VERSION 2.5.2-1-GA

EXPOSE 4440

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install openssh-client default-jre-headless

RUN apt-get -y install wget
RUN wget -O /tmp/rundeck.deb http://download.rundeck.org/deb/rundeck-${RUNDECK_VERSION}.deb
RUN dpkg -i /tmp/rundeck.deb && rm -f /tmp/rundeck.deb

RUN mkdir /etc/rundeck-org && mv /etc/rundeck/* /etc/rundeck-org/

ADD run.sh /
CMD /run.sh

VOLUME /etc/rundeck
VOLUME /var/lib/rundeck/data
VOLUME /var/lib/rundeck/var
VOLUME /var/lib/rundeck/logs
VOLUME /var/rundeck
