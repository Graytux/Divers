#!/bin/bash
clear

REP_HOME=`pwd`
TMP=${REP_HOME}/FICHIER_TMP
SLP=30
SLP2=10
CTRLA=1
CTRLR=1
PROC="goasduff"
TST1=`ps -ef | grep ${PROC} | grep -v grep | wc -l`
TST2=`ps -ef | grep ${PROC} | grep -v grep`

echo ""
echo "--------------------------------------------------------=[ Debut A/R Site Web Goasduff ]=--------------------------------------------------------"
echo ""

echo "[1]-=[ Arret du site Web de Goasduff ]=-"
cd /usr/local/starsister5/osismi3/goasduff/liferay-portal-6.0.6/tomcat-6.0.29/bin
#./shutdown.sh
echo ""

echo "[2]-=[ Controle : Arret du site Web de Goasduff ]=-"
while [ ${CTRLA} != 0 ]
do
	echo "[...] Attente de ${SLP}sec avant test du process ${PROC}"
	sleep ${SLP}
	if [ ${TST1} != 0 ]
	then
		echo "=> Il y a ${TST1} process ${PROC} actif.";
		ps -ef | grep ${PROC} | grep -v grep > $TMP;
		for ELT in `awk '{print $2}' $TMP`
		do
			echo "Kill du process $ELT";
#			/bin/kill -9 $ELT;
		done
	else
		echo "=> Il n'y a pas de process "${PROC}" actifs.";
		CTRLA=0;
	fi
done
echo ""

echo "[3]-=[ Suppression Repertoire work et temp ]=-"
cd /usr/local/starsister5/osismi3/goasduff/liferay-portal-6.0.6/tomcat-6.0.29
#rm -Rf temp work
sleep ${SLP2}
if [ ! -d "./work" ]
then
	echo " work => Supprime : Ok";
else
	echo " work => Existant : Ko";
fi
if [ ! -d "./temp" ]
then
	echo " temp => Supprime : Ok";
else
	echo " temp => Existant : Ko";
fi
echo ""

echo "[4]-=[ Relance du site Web de Goasduff ]=-"
cd /usr/local/starsister5/osismi3/goasduff/liferay-portal-6.0.6/tomcat-6.0.29/bin
#./startup.sh
echo ""

echo "[5]-=[ Controle : Relance du site Web de Goasduff ]=-"
while [ ${CTRLR} != 0 ]
do
	echo "[...] Attente de ${SLP}sec avant test des process "${PROC}""
	sleep ${SLP} 
	if [ ${TST1} != 0 ]
	then
		echo "=> Il y a ${TST1} process "${PROC}" actifs.";
		CTRLR=0
	else
		echo "=> Il n'y a pas de process "${PROC}" actifs.";
	fi		
done

rm -f ${TMP}
echo ""
echo "--------------------------------------------------------=[ Fin A/R Site Web Goasduff ]=---------------------------------------------------------"
echo ""