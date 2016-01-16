This is a Docker image of Rundeck (http://rundeck.org)
based on `debian:latest`

## Usage

```bash
docker run -d --name=rundeck -p 4440:4440 jacekkow/rundeck
```

Rundeck should be available at http://127.0.0.1:4440/
(user/password pairs: user/user and admin/admin)

By default it uses H2 database and Docker data volumes
for storage persistence.

You can update such installation by passing
`--volumes-from` to `docker run`:

```bash
docker stop rundeck
docker rename rundeck rundeck-old
docker run -d --name=rundeck -p 4440:4440 \
	--volumes-from rundeck-old \
	jacekkow/rundeck
docker rm -v rundeck-old
```

### Local volumes

You use local storage instead of data volumes:

```bash
docker run -d --name=rundeck -p 4440:4440 \
	-v /srv/rundeck/etc:/etc/rundeck \
	-v /srv/rundeck/data:/var/lib/rundeck/data \
	-v /srv/rundeck/logs:/var/lib/rundeck/logs \
	-v /srv/rundeck/rundeck:/var/rundeck \
	-v /srv/rundeck/ssh:/var/lib/rundeck/.ssh \
	jacekkow/rundeck
```

### External database

To increase performance, use MySQL instead of H2 database:

```bash
docker run -d --name=rundeck-db \
	-e MYSQL_ROOT_PASSWORD=root-pass \
	-e MYSQL_USER=rundeck \
	-e MYSQL_PASSWORD=rundeck-pass \
	-e MYSQL_DATABASE=rundeck \
	mariadb
docker run -d --name=rundeck -p 4440:4440 \
	-v /srv/rundeck/etc:/etc/rundeck \
	-v /srv/rundeck/data:/var/lib/rundeck/data \
	-v /srv/rundeck/logs:/var/lib/rundeck/logs \
	-v /srv/rundeck/rundeck:/var/rundeck \
	-v /srv/rundeck/ssh:/var/lib/rundeck/.ssh \
	--link rundeck-db:rundeck-db \
	jacekkow/rundeck
```

Then set the following options in
/srv/rundeck/etc/rundeck-config.properties

```
dataSource.url = jdbc:mysql://rundeck-db/rundeck?autoReconnect=true
dataSource.username = rundeck
dataSource.password = rundeck-pass
```

and restart the container:

```bash
docker restart rundeck
```

## Configuration

You can change Java system properties and JVM options by modifying
`RDECK_JVM` property in /etc/rundeck/profile (which is persisted).
