#!/bin/bash +x
issudo=$(id -u)
if [ "$issudo" -ne 0 ]; then
  echo "Ejecuta como sudo"
  exit
fi
source ./config
currentUser="${user}"
i=0
while :; do
  echo "creando $currentUser"
  homeDir="/home/$currentUser"
  gnupgDir="$homeDir/.gnupg"
  reposdir="$homeDir/repos"
  useradd -m -d $homeDir -s /bin/bash "$currentUser" -p $(openssl passwd -1 rando)
  mkdir -m 0700 $gnupgDir
  touch $gnupgDir/gpg.conf
  chmod 600 $gnupgDir/gpg.conf
  if [ "$currentUser" = "$user" ]; then
    cp ./superSecureId "/home/$user/"
    wget -qF https://elpais.com -O $homeDir/control.html
  fi
  chown -R "${currentUser}:${currentUser}" $homeDir
  #caracteristicas del keyring
  cat >$gnupgDir/keydetails <<E1
%echo Generating a basic OpenPGP key
Key-Type: ECDSA
Key-Curve: nistp256
Subkey-Type: ECDH
Subkey-Curve: nistp256
Name-Real: $currentUser Calrissian
Name-Comment: comment $currentUser
Name-Email: $currentUser@l1.com
Expire-Date: 0
%no-ask-passphrase
%no-protection
%pubring $gnupgDir/pubring.kbx
%secring $gnupgDir/trustdb.gpg
# Do a commit here, so that we can later print "done" :-)
%commit
%echo done
E1
  #echo "creando clave $gnupgDir/keydetails"
  sudo -u $currentUser gpg2 --batch --gen-key $gnupgDir/keydetails 2>/dev/null
  #echo "confiando en ella"
  sudo -u $currentUser gpg2 --command-fd 0 --expert --edit-key $currentUser trust <<<$'5\ny\n'
  if [ "$currentUser" != "$user" ]; then
    randogpg="/home/$user/.gnupg"
    #exporto el key del usuario recien creado
    sudo -u $currentUser gpg2 --export --armor --output $gnupgDir/$currentUser.asc 2>/dev/null
    #lo muevo al usuario principal
    sudo mv $gnupgDir/$currentUser.asc $randogpg 2>/dev/null
    #importo la clave al usuario principal
    sudo -u $user gpg2 --import $randogpg/$currentUser.asc 2>/dev/null
    #confio en ella
    sudo -u $user gpg2 --command-fd 0 --expert --edit-key $currentUser trust <<<$'5\ny\n'
  fi
  i=$((i + 1))
  currentUser="${user}_${i}"
  [[ "$i" -lt "$NUMUSERS" ]] || break
done
