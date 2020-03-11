FROM jacekkow/rundeck

RUN apt-get -y update \
	&& apt-get -y upgrade \
	&& apt-get -y install \
		ansible git python-netaddr python3-netaddr \
	&& apt-get -y clean \
	&& rm -Rf /var/lib/apt/lists/*
