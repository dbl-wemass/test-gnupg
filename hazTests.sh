#!/bin/bash
source ./config
currentUser="${user}"
homedir="/home/${user}"
ARCHIVOORIGINAL="${homedir}/superSecureId"
ARCHIVOTODOS="${homedir}/validoParaTodos.asc"
ARCHIVOSIMETRICO="${homedir}/simetrico.asc"
ARCHIVOVARIOS="${homedir}/validoParaAlgunos.asc"
usuarios=()
usuariosRandom=()
sudo rm ${ARCHIVOTODOS} ${ARCHIVOVARIOS}
echo "creando superSecureId encriptado por todos"
comando="sudo -u $user time -p gpg -ea -r rando"
for ((i = 1; i < $NUMUSERS; ++i)); do
  currentUser="${user}_${i}"
  usuarios=("${usuarios[@]}" $currentUser)
  indexRandom=$(($RANDOM % 3))
  if [ $indexRandom = 0 ]; then
    usuariosRandom=("${usuariosRandom[@]}" $currentUser)
  fi
  comando="${comando} -r ${currentUser}"
done
comando="${comando} -o ${ARCHIVOTODOS} ${ARCHIVOORIGINAL}"
# echo ${comando}
eval ${comando}
echo "encriptando para usuarios ${usuariosRandom[@]}"
comando="sudo -u $user time -p gpg -ea -r rando"
for i in "${usuariosRandom[@]}"; do
  comando="${comando} -r $i"
done
comando="${comando} -o ${ARCHIVOVARIOS} ${ARCHIVOORIGINAL}"
# echo ${comando}
eval ${comando}
echo "creando encriptacion simetrica"
sudo -u $user time -p gpg -ca --cipher-algo AES256 --batch --pinentry-mode loopback --passphrase ${RANDOM} --output ${ARCHIVOSIMETRICO} ${ARCHIVOORIGINAL}
echo "peso del archivo ${ARCHIVOORIGINAL} $(stat -c%s ${ARCHIVOORIGINAL}| numfmt --to=iec)"
echo "peso del archivo ${ARCHIVOTODOS} $(stat -c%s ${ARCHIVOTODOS}| numfmt --to=iec)"
echo "peso del archivo ${ARCHIVOVARIOS} $(stat -c%s ${ARCHIVOVARIOS}| numfmt --to=iec)"
echo "peso del archivo ${ARCHIVOSIMETRICO} $(stat -c%s ${ARCHIVOSIMETRICO}| numfmt --to=iec)"
