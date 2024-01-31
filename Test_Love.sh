#!/bin/bash

PARAM=$*
STRING3=("I" "L" "O" "V" "E" "Y" "O" "U")
lenSTRG3=${#STRING3[*]}
echo "${PARAM}" > tmpstrg.tmp
echo '-------------------------------------------'
echo "${PARAM}"
echo '-------------------------------------------'
declare -a TAB
for ELT in $(seq 0 $(( lenSTRG3 - 1)))
do
        OCC=$(grep -io "${STRING3[${ELT}]}" tmpstrg.tmp | wc -l)
        echo -e "${ELT} : ${STRING3[${ELT}]} : ${OCC}"
        TAB[ELT]=${OCC}
done
echo '-------------------------------------------'
END=0
while [ ${END} -ne 1 ]
do
        declare -a TMP
        lenTAB=${#TAB[*]}
        echo "TAB : ${TAB[*]}"
        for ID in $(seq 0 $(( lenTAB - 2 )) )
        do
                IDS=$(( ID + 1 ))
                TMP[ID]=$(( ${TAB[${ID}]} + ${TAB[${IDS}]} ))
                if [ "${TMP[${ID}]}" -eq 10 ]; then
                        TMP[ID]=1
                elif [ "${TMP[${ID}]}" -eq 11 ]; then
                        TMP[ID]=2
                elif [ "${TMP[${ID}]}" -eq 12 ]; then
                        TMP[ID]=3
                elif [ "${TMP[${ID}]}" -eq 13 ]; then
                        TMP[ID]=4
                elif [ "${TMP[${ID}]}" -eq 14 ]; then
                        TMP[ID]=5
                elif [ "${TMP[${ID}]}" -eq 15 ]; then
                        TMP[ID]=6
                elif [ "${TMP[${ID}]}" -eq 16 ]; then
                        TMP[ID]=7
                elif [ "${TMP[${ID}]}" -eq 17 ]; then
                        TMP[ID]=8
                elif [ "${TMP[${ID}]}" -eq 18 ]; then
                        TMP[ID]=9
                fi
        done
        TAB=("${TMP[@]}")
        if [ ${#TAB[*]} -le 2 ]; then
                END=1
                echo "TAB : ${TAB[*]}"
        fi
        unset TMP
done
echo '-------------------------------------------'
echo -e "Taux de Love : ${TAB[0]}${TAB[1]}%"
echo '-------------------------------------------'
