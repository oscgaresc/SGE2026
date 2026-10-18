!#/bin/bash

#cabecera
echo "**************************************************"
echo "      SCRIPT DE VERIFICACIÓN DE LA TAREA 2"
echo "**************************************************"
echo ""

echo "--------------------------------------------------"
echo "Paso 1: Imprimiendo usuario y fecha:"
echo "Usuario actual: $(whoami)"
echo "Fecha y hora:   $(date)"
echo "--------------------------------------------------"
echo ""

echo "--------------------------------------------------"
echo "Paso 2: Comprobando la imagen alumnostack-web:1.0:"
# otra opción = docker image inspect alumnostack-web:1.0 2>/dev/null | grep -q "alumnostack-web"; then ...
if docker image inspect alumnostack-web:1.0 > /dev/null 2>&1; then #no interesa el stdout o stderr queremos 0 (true) u otro nº (false)
    echo "OK: La imagen alumnostack-web:1.0 existe."
else
    echo "ERROR: La imagen alumnostack-web:1.0 no existe."
fi
echo "--------------------------------------------------"
echo ""

echo "--------------------------------------------------"
echo "Paso 3: listando los contenedores del stack con su estado:"
docker compose -f compose/docker-compose.yml ps # un docker compose ps del fichero yml
echo "--------------------------------------------------"
echo ""

echo "--------------------------------------------------"
echo "Parte 4 Comprobando que el volumen db_data existe.:" 
# OR => || por si está ejecutado en docker y no con docker compose, problema habitual
# otra opción = docker volume inspect compose_db_data 2>/dev/null | grep -q "compose_db_data" || ...
if docker volume inspect compose_db_data > /dev/null 2>&1 || docker volume inspect db_data > /dev/null 2>&1; then
    echo "OK: El volumen db_data existe."
else
    echo "ERROR: El volumen db_data no existe."
fi
echo "--------------------------------------------------"
echo ""

echo "--------------------------------------------------"
echo "Paso 5:  Comprobando que la red backend existe:"
# otra opción = docker network inspect compose_backend 2>/dev/null | grep -q "backend" ||...
if docker network inspect compose_backend > /dev/null 2>&1 || docker network inspect backend > /dev/null 2>&1; then
    echo "OK: La red backend existe."
else
    echo "ERROR: La red backend no existe."
fi
echo "--------------------------------------------------"
echo ""

echo "--------------------------------------------------"
echo "Paso 6:realizando una petición a http://localhost:8080 y muestrando el código HTTP:"
CABECERA_HTTP=$(curl -s -I http://localhost:8080)
echo "Código de respuesta HTTP: $CABECERA_HTTP" | head -n 1 #muestra la primera línea
echo "--------------------------------------------------"
echo ""

echo "--------------------------------------------------"
echo "Paso 7: Comprobando la cabecera X-Alumno:" #aprovechando el comando anterior
echo "$CABECERA_HTTP" | grep -i "X-Alumno"
echo "--------------------------------------------------"
echo ""

echo "--------------------------------------------------"
echo "Paso 8: Contando las filas de la tabla alumnos de la base de datos:"
# Se lee la variable del archivo .env (MYSQL_ROOT_PASSWORD y MYSQL_DATABASE) para acceder a la bd y ejecutar "SELECT COUNT(*) FROM alumnos;"
alumnos=$(docker compose -f compose/docker-compose.yml exec -T db sh -c 'mysql -u root -p"$MYSQL_ROOT_PASSWORD" -N -e "USE ${MYSQL_DATABASE:-alumnostack_db}; SELECT COUNT(*) FROM alumnos;"' 2>/dev/null)
echo "Número de alumnos: $alumnos"
echo "**************************************************"
