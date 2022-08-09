#!/bin/bash
###########################################################################################
# Nom : AR_WEB_GOASDUFF.sh                                                                #
# Description : Script servant a effectuer l'arret/relance du site Web de Goasduff        #
# Auteur : Exploitation ASTEN                                                             #
# Date de Creation : 26/01/2017                                                           #
# Date Last Modif  : 11/04/2018                                                           #
###########################################################################################

##############################[ Declaration des Variables ]##############################
REP_HOME=`pwd`
TMP=${REP_HOME}/FICHIER_TMP
SLP=20
PROC="goasduff"


##############################[ Declaration des Fonctions ]##############################

function TestProc(){
        TST=`ps -ef | grep $1 | grep -v grep | wc -l`
        if [ ${TST} != 0 ]
        then
                echo "=> Il y a ${TST} process $1 actif.";
                if [ $2 != 0 ]
                then
                        ps -ef | grep ${PROC} | grep -v grep > $TMP;
                        for ELT in `awk '{print $2}' $TMP`
                        do
                                echo "=> Kill du process $ELT";
                                /bin/kill -9 $ELT;
                                TST2=`ps -ef | grep $1 | grep -v grep | wc -l`
                                echo "=> Il y a ${TST2} process $1 actif.";
                        done
                fi
        else
                echo "=> Il y a ${TST} process $1 actif.";
        fi
}

#########################################################################################

clear
echo "--------------------------------------------------------=[ Debut A/R Site Web Goasduff ]=--------------------------------------------------------"
echo "[1]-=[ Arret du site Web de Goasduff ]=-"
cd /usr/local/starsister5/osismi3/goasduff/liferay-portal-6.0.6/tomcat-6.0.29/bin
./shutdown.sh
sleep ${SLP}
echo ""

echo "[2]-=[ Controle : Arret du site Web de Goasduff ]=-"
TestProc ${PROC} 1
echo ""

echo "[3]-=[ Suppression Repertoire work et temp ]=-"
cd /usr/local/starsister5/osismi3/goasduff/liferay-portal-6.0.6/tomcat-6.0.29
rm -Rf temp work
sleep ${SLP}
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
./startup.sh
sleep ${SLP}
echo ""

echo "[5]-=[ Controle : Relance du site Web de Goasduff ]=-"
TestProc ${PROC} 0
rm -f ${TMP}
echo ""

echo "--------------------------------------------------------=[ Fin A/R Site Web Goasduff ]=---------------------------------------------------------"
echo ""