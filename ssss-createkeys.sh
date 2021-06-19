#!/bin/bash
source ./config
numTotalKeys=$(expr $NUMUSERS \* 2)
neededKeys=$(expr $NUMUSERS + 1)
rando=$(($RANDOM % $NUMUSERS))
supersecret=$(cat superSecureId)
totalKeys=($(time -p bin/ssss-split -t $neededKeys -n $numTotalKeys -w $RANDOM <<<$"${supersecret}\n"))
sharedKeys=("${totalKeys[@]:0:$NUMUSERS}")
privateKeys=("${totalKeys[@]:$NUMUSERS:$numTotalKeys}")
echo "TotalKeys: ${#totalKeys[@]}; PrivateKeys: ${#privateKeys[@]}; SharedKeys: ${#sharedKeys[@]}; Necesarias para descifrar: $neededKeys"
selectedKey=${sharedKeys[$rando]}
legalDecrypt=("${privateKeys[@]}" $selectedKey)
echo $legalDecrypt >allkeys
echo "intento de descifrado normal (${#privateKeys[@]} secretas + 1 publica: $rando; obtenidas: ${#legalDecrypt[@]})\n"
time -p bin/ssss-combine -t $neededKeys <<<$(printf "%s\n" "${legalDecrypt[@]}")
echo "worst Case Scenario: todos los vendors se ponen de acuerdo para intentar desencriptar la clave\n"
time -p bin/ssss-combine -t $NUMUSERS <<<$(printf "%s\n" "${sharedKeys[@]}")