FROM debian

ENV DEBIAN_FRONTEND noninteractive
ENV RDECK_JVM_SETTINGS "-Xmx1024m -Xms256m -XX:MaxMetaspaceSize=256m -server"

EXPOSE 4440

ADD *-gpg.key /root/
RUN apt-get -y update \
	&& apt-get -y upgrade \
	&& apt-get -y install openssh-client wget gnupg software-properties-common \
	&& echo "deb https://packagecloud.io/pagerduty/rundeck/any/ any main" \
		> /etc/apt/sources.list.d/rundeck.list \
	&& add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ \
	&& cat /root/*-gpg.key | apt-key add - \
	&& apt-get -y update \
	&& apt-get -y install adoptopenjdk-8-hotspot rundeck \
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
