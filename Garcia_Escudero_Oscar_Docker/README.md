# Documentación de la Aplicación

## Descripción del stack
Stack de tres servicios (Web con Ngnix y base Alpine, Base de Datos MySQL y Adminer) orquestados mediante Docker Compose.

## Comandos de gestión del stack
- **Levantar el stack:** `docker compose -f compose/docker-compose.yml up -d`
- **Bajar el stack:** `docker compose -f compose/docker-compose.yml down`

## Acceso y credenciales de Adminer
- **URL de acceso:** http://localhost:8081 (o IP_servidor:8081)
- **Motor:** MySQL | **Servidor:** db | **Base de datos:** alumnostack_db
- **Usuario estándar:** nginxuser (contraseña en `.env` -> `MYSQL_PASSWORD`)
- **Usuario administrador:** root (contraseña en `.env` -> `MYSQL_ROOT_PASSWORD`)

## Ventaja de un volumen nombrado frente a un bind mount
Los volúmenes nombrados, gestionados por Docker, son portables y no dependen de rutas de carpetas específicas en la máquina host, lo que evita fallos al desplegar el proyecto en diferentes ordenadores o servidores.