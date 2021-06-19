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

### creaKeys.sh

Se encargará de hacer:
* archivo encritptado con todas las claves
* archivo encriptado con varias claves (1/3 claves)
* archivo cifrado con AES256 (segun los comentarios de jose maria) para ver la diferencia del peso
* Comprimir los archivos con gzip para emular la compresion de servidor
* comprimir los archivos con brotli para emular la compresion de servidor https://caniuse.com/brotli

### decrypt.sh

Se ha de pasar un parametro numerico que ha de ir desde 1 hasta NUMUSERS <1:
* Se intentará desencriptar los diferentes archivos encriptados con las credenciales del usuario ${user}_${N}

## prueba SSSS

Parece prometedor 

https://en.wikipedia.org/wiki/Shamir%27s_Secret_Sharing

https://github.com/MrJoy/ssss

Ya que se puede dividir la clave en N claves, con una necesidad de M claves para desencriptar. Se me antoja lento, pero podria ser la implementacion qhe he usado. Los binarios van en el repo

### ssss-createkeys.sh

Prueba super bruta de concepto, genera n*2 +1 claves asumiendo que solo se van a repartir n claves en entre los miembros y sin embargo se necesitan n+1 claves para desencriptar. 

En una situacion muy mala, en la que todos los vendors se pusieran de acuerdo y compartieran sus claves, nunca iban a poder conseguir la cantidad n+1 minima para ver el id del usuario.

Es lento para 200 miembros: un minuto por cada descifrado, pero el ejemplo es uno de maximos.
