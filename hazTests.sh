#!/bin/bash
source ./config
currentUser="${user}"
homedir="/home/${user}"
#archivo web para comprimir y comparar con la compresion que da el navegador
ARCHIVOCONTROL="${homedir}/control.html"
ARCHIVOORIGINAL="${homedir}/superSecureId"
ARCHIVOTODOS="${homedir}/validoParaTodos.asc"
ARCHIVOSIMETRICO="${homedir}/simetrico.asc"
ARCHIVOVARIOS="${homedir}/validoParaAlgunos.asc"
usuarios=()
usuariosRandom=()
sudo rm ${ARCHIVOTODOS} ${ARCHIVOVARIOS} ${ARCHIVOCONTROL}.* ${ARCHIVOORIGINAL}.* ${ARCHIVOSIMETRICO}  2> /dev/null
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
echo "encriptando para ${#usuariosRandom[@]} usuarios"
comando="sudo -u $user time -p gpg -ea -r rando"
for i in "${usuariosRandom[@]}"; do
  comando="${comando} -r $i"
done
comando="${comando} -o ${ARCHIVOVARIOS} ${ARCHIVOORIGINAL}"
# echo ${comando}
eval ${comando}
echo "creando encriptacion simetrica"
sudo -u $user time -p gpg -ca --cipher-algo AES256 --batch --pinentry-mode loopback --passphrase randoCarlrissian --output ${ARCHIVOSIMETRICO} ${ARCHIVOORIGINAL}
echo "comprimiendo en gzip"
sudo -u $user gzip --best -fk ${ARCHIVOCONTROL} ${ARCHIVOORIGINAL} ${ARCHIVOTODOS} ${ARCHIVOVARIOS} ${ARCHIVOSIMETRICO}
echo "comprimiendo en brotli"
sudo -u $user brotli -Zfk ${ARCHIVOCONTROL} ${ARCHIVOORIGINAL} ${ARCHIVOTODOS} ${ARCHIVOVARIOS} ${ARCHIVOSIMETRICO}
echo "${ARCHIVOCONTROL} peso: $(stat -c%s ${ARCHIVOCONTROL}| numfmt --to=iec); gzip: $(stat -c%s ${ARCHIVOCONTROL}.gz| numfmt --to=iec); brotli: $(stat -c%s ${ARCHIVOCONTROL}.br| numfmt --to=iec)"
echo "${ARCHIVOORIGINAL} peso: $(stat -c%s ${ARCHIVOORIGINAL}| numfmt --to=iec); gzip: $(stat -c%s ${ARCHIVOORIGINAL}.gz| numfmt --to=iec); brotli: $(stat -c%s ${ARCHIVOORIGINAL}.br| numfmt --to=iec)"
echo "${ARCHIVOTODOS} peso: $(stat -c%s ${ARCHIVOTODOS}| numfmt --to=iec); gzip: $(stat -c%s ${ARCHIVOTODOS}.gz| numfmt --to=iec); brotli: $(stat -c%s ${ARCHIVOTODOS}.br| numfmt --to=iec)"
echo "${ARCHIVOVARIOS} peso: $(stat -c%s ${ARCHIVOVARIOS}| numfmt --to=iec); gzip: $(stat -c%s ${ARCHIVOVARIOS}.gz| numfmt --to=iec); brotli: $(stat -c%s ${ARCHIVOVARIOS}.br| numfmt --to=iec)"
echo "${ARCHIVOSIMETRICO} peso: $(stat -c%s ${ARCHIVOSIMETRICO}| numfmt --to=iec); gzip: $(stat -c%s ${ARCHIVOSIMETRICO}.gz| numfmt --to=iec); brotli: $(stat -c%s ${ARCHIVOSIMETRICO}.br| numfmt --to=iec)"
