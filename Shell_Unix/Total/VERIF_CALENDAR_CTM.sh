#!/bin/bash
. /home/hprodhra/Exploitation/.profile_ctmv9

######################################################################"
#                                                                    #"
######################################################################"
REP_BASE=/home/hprodhra/Exploitation
DAT_ANNE=`date +%Y`
DAT_MOIS=`date +%m`

## Menu de Choix pour le Work ##
clear
pwd
echo "-=[ TOTAL - Verification des Calendrier Control-M ]=-"
echo "          Choix : CTM_PROD_${DAT_ANNE}_*.csv         "
TAB=(`ls -rt /home/hprodhra/Exploitation/calendars/CTM_PROD_${DAT_ANNE}_*.csv | tail -5`)
select option in ${TAB[*]}
do
    case $option in
		"${TAB[0]}") 
			CHOIX_DAT_LIV="${TAB[0]}"
			break;;
		"${TAB[1]}") 
			CHOIX_DAT_LIV="${TAB[1]}"
			break;;
		"${TAB[2]}") 
			CHOIX_DAT_LIV="${TAB[2]}"
			break;;
		"${TAB[3]}") 
			CHOIX_DAT_LIV="${TAB[3]}"
			break;;
		"${TAB[4]}") 
			CHOIX_DAT_LIV="${TAB[4]}"
			break;;
		*) break;;
    esac
done


DAT_MOIS=$((DAT_MOIS))
CAL_MOIS=$((DAT_MOIS+1))
TST_FICH=${REP_BASE}/calendars/CTM_PROD_${DAT_ANNE}_${CAL_MOIS}.csv
RES_FICH=${REP_BASE}/calendars/CTM_PROD_${DAT_ANNE}_${CAL_MOIS}.log

clear
echo "Annee: ${DAT_ANNE} / Mois: ${DAT_MOIS} / Mois a verifier: ${CAL_MOIS}" > ${RES_FICH}
echo "" >> ${RES_FICH}

if [ ! -f ${TST_FICH} ]
then
        echo "Le fichier ${TST_FICH} n'est pas prÃ©sent !!!" >> ${RES_FICH}
        exit 1
fi

for XML_TEST in `cat ${TST_FICH}`
do
        CODE=0
        CAL_TEST=`echo ${XML_TEST} | awk -F ";" '{print $1}'`
        CAL_CHN=`echo ${XML_TEST:${#CAL_TEST}} | sed -e "s/;//g"`
        CHN_TEST=`ctmpsm -LISTCAL ${CAL_TEST} ${DAT_ANNE} | grep -v Year | grep -v Calendar |grep " ${CAL_MOIS} " | tail -1 | awk '{print $2}'`
        ITE_TEST=${#CHN_TEST}
        echo " ${CAL_TEST}" >> ${RES_FICH}
#       echo " ${CAL_TEST} (nb_jr: ${ITE_TEST})" >> ${RES_FICH}
        for i in `seq 0 $((ITE_TEST-1))`
        do
                J_CAL_TEST=${CAL_CHN:$i:1}
                J_CHN_TEST=${CHN_TEST:$i:1}
                if [ ${J_CAL_TEST} != ${J_CHN_TEST} ]
                then
                        echo " -- Jour: $((i+1))        | CSV: ${J_CAL_TEST} | CAL: ${J_CHN_TEST}" >> ${RES_FICH}
                        CODE=$((CODE+1))
#               else
#                       echo " -- Jour: $((i+1))        | CSV: ${J_CAL_TEST} | CAL: ${J_CHN_TEST}" >> ${RES_FICH}
                fi
        done
        if [ ${CODE} != 0 ]
        then
                echo " => Calendrier KO avec ${CODE} erreurs" >> ${RES_FICH}
        else
                echo " => Calendrier OK" >> ${RES_FICH}
        fi
done
