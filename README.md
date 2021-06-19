# test-gnupg
pensado para usar en un contenedor o maquina virtual

Requiere tener instalado git, gnupg2, gzip, brotly y wget

## archivos

### config
* NUMUSERS=int numero de usuarios a crear
* user=rando string, valor raiz para los usuarios

el usuario que administrará tendrá el nombre $user

### createUsers.sh
* creara N usuarios 
* rando, este tiene el archivo de control y el identificador
* rando_1 ... rando N
* todos tienen el password rando


### deleteUsers.sh

borrara el numero de usuarios indicados en config

### hazTests.sh

Se encargará de hacer:
* archivo encritptado con todas las claves
* archivo encriptado con varias claves (1/3 claves)
* archivo cifrado con AES256 (segun los comentarios de jose maria) para ver la diferencia del peso
* Comprimir los archivos con gzip para emular la compresion de servidor
* comprimir los archivos con brotli para emular la compresion de servidor https://caniuse.com/brotli

### decrypt.sh

Se ha de pasar un parametro numerico que ha de ir desde 1 hasta NUMUSERS <1:
* Se intentará desencriptar los diferentes archivos encriptados con las credenciales del usuario ${user}_${N}