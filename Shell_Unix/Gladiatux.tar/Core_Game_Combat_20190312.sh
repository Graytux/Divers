#!/bin/bash

#=================================================================================================================================================================================
# Variables
#=================================================================================================================================================================================
DTE=`date +%Y%m%d-%H%M`
REPBASE=`pwd`
REPAREN=${REPBASE}/ARENE


#=================================================================================================================================================================================
# Programme
#=================================================================================================================================================================================
cd ${REPAREN}
declare -A CHNTAB
declare -A INITAB

for ARENE in `ls -d *`
do
	echo ${ARENE}
	ARNVIC=${ARENE}/vic
	ARNRIP=${ARENE}/rip
	ARNLOG=${ARENE}/log
	FICLOG=${ARNLOG}/${DTE}_${ARENE}_Combat.log

	ROUND=1
	INITAB[0 'INI']=0
	INITAB[0 'PNJ']=0
	IDX=0
	
	echo "==================================================================================" > ${FICLOG}
	echo "| Combat de l'arene : ${ARENE} du ${DTE}" >> ${FICLOG}
	echo "==================================================================================" >> ${FICLOG}
	NBPNJ=`ls ${ARENE}/*.pnj | wc -l`
	TMP=`expr ${NBPNJ} - 1`

	echo "  - Il y a ${NBPNJ} gladiateurs pour le combat dans l'arene : ${ARENE}" >> ${FICLOG}
	for CBT in `ls ${ARENE}/*.pnj`
	do
		. ${CBT}
		CHNTAB[${IDX} 'FIC']=${CBT}
		CHNTAB[${IDX} 'NOM']=${NOM}
		CHNTAB[${IDX} 'FOR']=${FOR}
		CHNTAB[${IDX} 'END']=${END}
		CHNTAB[${IDX} 'VIT']=${VIT}
		CHNTAB[${IDX} 'AGI']=${AGI}
		CHNTAB[${IDX} 'PV']=${PV}
		CHNTAB[${IDX} 'AT']=${AT}
		CHNTAB[${IDX} 'CA']=${CA}
		CHNTAB[${IDX} 'PVact']=${PV}
		IDX=`expr $IDX + 1`
	done

	for IDX in `seq 0 ${TMP}`
	do
		echo "Combattant ${IDX} : ${CHNTAB[$IDX 'NOM']} - Caracteristiques : [FOR: ${CHNTAB[$IDX 'FOR']}] [END: ${CHNTAB[$IDX 'END']}] [VIT: ${CHNTAB[$IDX 'VIT']}] [AGI: ${CHNTAB[$IDX 'AGI']}] [PV: ${CHNTAB[$IDX 'PV']}] [AT: ${CHNTAB[$IDX 'AT']}] [CA: ${CHNTAB[$IDX 'CA']}]" >> ${FICLOG}
	done
	echo "" >> ${FICLOG}

	echo "  - Calcul de l'init" >> ${FICLOG}
	for IDX in `seq 0 ${TMP}`
	do
		TMPINIT=0
		for i in `seq 1 ${CHNTAB[$IDX 'AGI']}`
		do
			TMPINIT=`expr ${TMPINIT} + $(( RANDOM % 6 + 1))`
		done
		CHNTAB[${IDX} 'Init']=${TMPINIT}
		for ORD in `seq ${IDX} -1 0`
		do
			ORT=`expr ${ORD} - 1`
			if [ ${ORD} -eq 0 ]
			then
				INITAB[${ORD} 'INI']=${CHNTAB[${IDX} 'Init']}
				INITAB[${ORD} 'PNJ']=${IDX}
			else
				if [ ${CHNTAB[${IDX} 'Init']} -gt ${INITAB[${ORT} 'INI']} ] # Ligne de MERDE qui fait bug sa race : 
				then
					Tini=${INITAB[${ORT} 'INI']}
					Tidx=${INITAB[${ORT} 'PNJ']}
					INITAB[${ORT} 'INI']=${CHNTAB[${IDX} 'Init']}
					INITAB[${ORT} 'PNJ']=${IDX}
					INITAB[${ORD} 'INI']=${Tini}
					INITAB[${ORD} 'PNJ']=${Tidx}
				else
					INITAB[${ORD} 'INI']=${CHNTAB[${IDX} 'Init']}
					INITAB[${ORD} 'PNJ']=${IDX}
				fi
			fi
		done
		echo "${CHNTAB[${IDX} 'NOM']} : Init[${CHNTAB[${IDX} 'Init']}]" >> ${FICLOG}
	done
	
	echo "- - - - - - - - - - - [ Ordre de Passage pour le Round ${ROUND} ] - - - - - - - - - - -" >> ${FICLOG}
	for IDX in `seq 0 ${TMP}`
	do
		echo "${CHNTAB[${INITAB[${IDX} 'PNJ']} 'NOM']} : Init[${INITAB[${IDX} 'INI']}]" >> ${FICLOG}
	done
	echo "" >> ${FICLOG}

done
