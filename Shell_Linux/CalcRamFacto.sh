#!/bin/bash 

OPTION=${1}
ALL="${@:2}"

########################## Fonctions ##########################
function initcheck()
{
	ALLVAR=${1}
	if [[ -z ${ALLVAR} ]]
	then
		echo "Vous devez donner au moins une valeur en parametre"
		exit 0
	fi
}

function parametre()
{
	OPTION=${1}
	case ${OPTION} in
		--cmd)	AWKVAR='cmd'	; CHAMP='$3' ;;
		--pid)  AWKVAR='pid'    ; CHAMP='$1' ;;
		--user)  AWKVAR='user'    ; CHAMP='$2' ;;
		*)	echo "Vous devez indiquer une option : --cmd, --pid ou --user" ;;
	esac
}

function ramcalc()
{
	ALL="${@:2}"
	OPTION=${1}

	for EXP in ${ALL}
	do
		RAMUSE=$(ps -eo pid,user:30,comm,rss | awk -v ${AWKVAR}=${EXP} "${CHAMP} == ${AWKVAR}" | awk '{SUM += $4/1024} END {print SUM}' |cut -d '.' -f1)
		if [[ -z ${RAMUSE} ]]
		then
			echo "Le ${AWKVAR} ${EXP} n'est pas present dans la liste"
		else
			echo "RAM consomme pour ${EXP} : ${RAMUSE} MB"
		fi
	done
}

########################## Programme Main ##########################
initcheck ${ALL}
parametre ${OPTION}
ramcalc ${OPTION} ${ALL}
