#!/bin/bash
source ./config
if [[ $# != 1 ]]; then
  echo "Se ha de introducir solo un parametro"
  exit
elif ! [[ "$1" =~ ^[0-9]+$ ]]; then
  echo "Solo enteros"
  exit
elif [ $1 -gt 0 ] && [ $1 -lt $NUMUSERS ]; then
  desiredUser="${user}_$1"
  homedir="/home/${user}"
  ARCHIVOORIGINAL="${homedir}/superSecureId"
  ARCHIVOTODOS="${homedir}/validoParaTodos.asc"
  ARCHIVOVARIOS="${homedir}/validoParaAlgunos.asc"
ARCHIVOSIMETRICO="${homedir}/simetrico.asc"
  sudo -u $desiredUser gpg -K
  printf "\nintentando descomprimir ${ARCHIVOTODOS}\n"
  sudo -u $desiredUser time -p gpg --quiet -d $ARCHIVOTODOS
  # sudo -u $desiredUser time -p gpg -d -r rando
  printf "\n\nintentando descomprimir ${ARCHIVOVARIOS}\n"
  sudo -u $desiredUser time -p gpg --quiet -d $ARCHIVOVARIOS
  printf "\n\nintentando descomprimir ${ARCHIVOSIMETRICO}\n"
  sudo -u $desiredUser time -p gpg --batch --quiet --passphrase randoCarlrissian -d $ARCHIVOSIMETRICO
# currentUser="${user}"
else
  echo "el numero ha de estar entre 1 y $(($NUMUSERS - 1))"
fi
