# GLPI deploy with Docker

Deploy and run GLPI (any version) with Docker.

Install latest version by default but you can specify the version you want by passing

You can:
- link to an existing database.
- or create a new one easily with docker-compose.

### glpi.env

```env
MYSQL_ROOT_PASSWORD=rootpasswd
MYSQL_DATABASE=glpi
MYSQL_USER=glpi
MYSQL_PASSWORD=glpipaswd
```

### Run docker-compose

```bash
docker-compose up -d
```

## Dependency

GLPI Source code: https://github.com/glpi-project/glpi/releases
Foler same level with GLPI-Docker

```
  volumes:
      - ../GLPI-Website:/var/www/html/glpi
```
