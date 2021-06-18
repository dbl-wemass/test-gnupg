# test-gnupg
pensado para usar en un contenedor o maquina virtual

Requiere tener instalado git y gnupg2

## archivos

### config
NUMUSERS=100 int numero de usuarios a crear
user=rando string, valor raiz para los usuarios

el usuario que administrará tendrá el nombre $user

### createUsers.sh
creara N usuarios 
rando
rando_1 ... rando N

### deleteUsers.sh

borrara el numero de usuarios indicados en config

### hazTests.sh

prueba diferentes combinaciones de encriptacion y desencriptacion

archivo encritptado con todas las claves
archivo encriptado con varias claves (1/3 claves)
archivo cifrado con AES256 (segun los comentarios de jose maria) para ver la diferencia del peso
