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
                case ${TMP[${ID}]} in
                        10)
                                TMP[ID]=1 ;;
                        11)
                                TMP[ID]=2 ;;
                        12)
                                TMP[ID]=3 ;;
                        13)
                                TMP[ID]=4 ;;
                        14)
                                TMP[ID]=5 ;;
                        15)
                                TMP[ID]=6 ;;
                        16)
                                TMP[ID]=7 ;;
                        17)
                                TMP[ID]=8 ;;
                        18)     
                                TMP[ID]=9 ;;
                        *)      ;;  
                esac
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
rm -f tmpstrg.tmp