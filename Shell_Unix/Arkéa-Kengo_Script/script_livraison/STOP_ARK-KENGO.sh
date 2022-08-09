#!/bin/bash
###########################################################################################  
# Nom : STOP_ARK-KENGO.sh                                                                 #
# Description : ce script sert a arrêter Kengo et So-Kengo                                #
# Auteur : Exploitation ASTEN                                                             #
# Date de Creation : 26/01/2017                                                           #
# Date Last Modif  : 28/11/2019                                                           #
###########################################################################################

##############################[ Declaration des Variables ]##############################
. /opt/exploit/script_livraison/.env_ARKEA-KENGO

DATO=`date +%Y%m%d`
HHMM=`date +%H%M`

##############################[ Declaration des Fonctions ]##############################

############# -=[ Fct pause interactive ]=- #############
function Pause(){
   read -p "$*"
}

############# -=[ Fct Arret Nginx ]=- #############
function StopNginx(){
	if [ $1 == "APP1" ]
	then
		echo " - Arret Nginx sur ${SRVAPP1}"
		ssh ${USRAPP}@${SRVAPP1} '/etc/init.d/nginx stop'
		sleep 10
		ssh ${USRAPP}@${SRVAPP1} 'ps -eaf | grep -i nginx | grep -v grep'
	elif [ $1 == "APP2" ]
	then
		echo " - Arret Nginx sur ${SRVAPP2}"
		/etc/init.d/nginx stop
		sleep 10
		ps -eaf | grep -i nginx | grep -v grep
	else
		echo "Fct Arret Nginx : Pas de param"
	fi
}

############# -=[ Fct Lancement Nginx ]=- #############
function StartNginx(){
	if [ $1 == "APP1" ]
	then
		echo " - Lancement Nginx sur ${SRVAPP1}"
		ssh ${USRAPP}@${SRVAPP1} '/etc/init.d/nginx start'
		sleep 10
		ssh ${USRAPP}@${SRVAPP1} 'ps -eaf | grep -i nginx | grep -v grep'
	elif [ $1 == "APP2" ]
	then
		echo " - Lancement Nginx sur ${SRVAPP2}"
		/etc/init.d/nginx start
		sleep 10
		ps -eaf | grep -i nginx | grep -v grep
	else
		echo "Fct Lancement Nginx : Pas de param"
	fi
}

############# -=[ Fct Arret Tomcat ]=- #############
function StopTomcat(){
	if [ $1 == "APP1" ]
	then
		echo " - Arret Tomcat sur ${SRVAPP1}"
		ssh ${USRAPP}@${SRVAPP1} '/etc/init.d/tomcat stop'
		sleep 10
		ssh ${USRAPP}@${SRVAPP1} 'ps -eaf | grep -i java | grep -v grep'
	elif [ $1 == "APP2" ]
	then
		echo " - Arret Tomcat sur ${SRVAPP2}"
		/etc/init.d/tomcat stop
		sleep 10
		ps -eaf | grep -i java | grep -v grep
	else
		echo "Fct Arret Tomcat : Pas de param"
	fi
}

############# -=[ Fct Lancement Tomcat ]=- #############
function StartTomcat(){
	if [ $1 == "APP1" ]
	then
		echo " - Lancement Tomcat sur ${SRVAPP1}"
		ssh ${USRAPP}@${SRVAPP1} 'mv /app/tomcat/logs/catalina.out /app/tomcat/logs/${DATO}_${HHMM}_catalina.out'
		ssh ${USRAPP}@${SRVAPP1} '/etc/init.d/tomcat start'
		sleep 10
		ssh ${USRAPP}@${SRVAPP1} 'ps -eaf | grep -i java | grep -v grep'
	elif [ $1 == "APP2" ]
	then
		echo " - Lancement Tomcat sur ${SRVAPP2}"
		mv /app/tomcat/logs/catalina.out /app/tomcat/logs/${DATO}_${HHMM}_catalina.out
		/etc/init.d/tomcat start
		sleep 10
		ps -eaf | grep -i java | grep -v grep
	else
		echo "Fct Lancement Tomcat : Pas de param"
	fi
}

############# -=[ Fct Check catalina.out Tomcat ]=- #############
function CheckTomcat(){
        if [ $1 == "APP1" ]
        then
                echo " - Verification de la log < grep "Server startup" /app/tomcat/logs/catalina.out > sur ${SRVAPP1}"
				CR=0
                until [ ${CR} == 1 ]
                do
                        sleep 10
                        ssh ${USRAPP}@${SRVAPP1} 'grep "Server startup" /app/tomcat/logs/catalina.out'
                        if [ $? == 0 ]
                        then
                                CR=1
                        fi
                done
        elif [ $1 == "APP2" ]
        then
                echo " - Verification de la log < grep "Server startup" /app/tomcat/logs/catalina.out > sur ${SRVAPP2}"
				CR=0
                until [ ${CR} == 1 ]
                do
                        sleep 10
                        grep "Server startup" /app/tomcat/logs/catalina.out
                        if [ $? == 0 ]
                        then
                                CR=1
                        fi
                done
        else
                echo "Fct Lancement Tomcat : Pas de param"
        fi
}

############# -=[ Fct Suppression Fichiers Tomcat ]=- #############
function SupFicTomcat(){
	if [ $1 == "APP1" ]
	then
		echo " - Suppression des Fichiers Tomcat sur ${SRVAPP1}"
		ssh ${USRAPP}@${SRVAPP1} 'cd /app/tomcat/work/; rm -fr *'
		ssh ${USRAPP}@${SRVAPP1} 'cd /app/tomcat/temp/; rm -fr *'
		sleep 10
	elif [ $1 == "APP2" ]
	then
		echo " - Suppression des Fichiers Tomcat sur ${SRVAPP2}"
		cd /app/tomcat/work/; rm -fr *
		cd /app/tomcat/temp/; rm -fr *
		sleep 10
	else
		echo "Fct Suppression Fichiers Tomcat : Pas de param"
	fi
}

############# -=[ Fct Mise en place de la page de maintenance ]=- #############
function MepMaint(){
	if [ $1 == "APP1" ]
	then
		echo " - Mise en place de la page de maintenance sur ${SRVAPP1}"
		ssh ${USRAPP}@${SRVAPP1} 'cp -p /app/kengo-frontoffice/index.html /app/kengo-frontoffice/index.html-sav'
		ssh ${USRAPP}@${SRVAPP1} 'cp -p /app/kengo-frontoffice/so/index.html /app/kengo-frontoffice/so/index.html-sav'
		ssh ${USRAPP}@${SRVAPP1} 'cp -p /app/maintenance.html /app/kengo-frontoffice/index.html'
		ssh ${USRAPP}@${SRVAPP1} 'cp -p /app/maintenance_so.html /app/kengo-frontoffice/so/index.html'
	elif [ $1 == "APP2" ]
	then
		echo " - Mise en place de la page de maintenance sur ${SRVAPP2}"
		cp -p /app/kengo-frontoffice/index.html /app/kengo-frontoffice/index.html-sav
		cp -p /app/kengo-frontoffice/so/index.html /app/kengo-frontoffice/so/index.html-sav
		cp -p /app/maintenance.html /app/kengo-frontoffice/index.html
		cp -p /app/maintenance_so.html /app/kengo-frontoffice/so/index.html
	else
		echo "Fct Mise en place de la page de maintenance : Pas de param"
	fi
}

############# -=[ Fct Suppression de la page de maintenance ]=- #############
function SupMaint(){
	if [ $1 == "APP1" ]
	then
		echo " - Suppression de la page de maintenance sur ${SRVAPP1}"
		ssh ${USRAPP}@${SRVAPP1} 'mv /app/kengo-frontoffice/index.html-sav /app/kengo-frontoffice/index.html'
		ssh ${USRAPP}@${SRVAPP1} 'mv /app/kengo-frontoffice/so/index.html-sav /app/kengo-frontoffice/so/index.html'
	elif [ $1 == "APP2" ]
	then
		echo " - Suppression de la page de maintenance sur ${SRVAPP2}"
		mv /app/kengo-frontoffice/index.html-sav /app/kengo-frontoffice/index.html
		mv /app/kengo-frontoffice/so/index.html-sav /app/kengo-frontoffice/so/index.html
	else
		echo "Fct Suppression de la page de maintenance : Pas de param"
	fi
}

#########################################################################################

##############################[ Debut du Programme ]##############################

clear
echo "-=[ Arret Arkea - Kengo ]=-"
echo ""
echo "### Etape 1 : Pre-requis"
echo "1.c) Positionner un arret de supervision (downtime) pour l'ensemble des serveurs (${SVRAPP1} & ${SRVAPP2}) et services"
Pause "Ne valider que lorsque le downtime est verifie et actif"
echo "1.d) Desactiver l'eventhandler sur centreon pour le service supervision-applicative sur les deux serveurs APP : ${SRVAPP1} et ${SRVAPP2}"
Pause "Ne valider que lorsque l'eventhandler est bien inactif sur les 2 services"
echo "################## Arret de l'applicatif KENGO - Debut ###################################################"
echo "Arret du service Nginx sur le serveur ${SRVAPP1}"
StopNginx APP1
echo "Arret du service Nginx sur le serveur ${SRVAPP2}"
StopNginx APP2
echo "Arret du service Tomcat sur les serveurs :"
echo " - ${SRVAPP1} :"
StopTomcat APP1
echo " - ${SRVAPP2} :"
StopTomcat APP2
echo "Suppression des fichiers Tomcat sur ${SRVAPP1}"
SupFicTomcat APP1
echo "Suppression des fichiers Tomcat sur ${SRVAPP2}"
SupFicTomcat APP2
echo "################## Arret de l'applicatif KENGO - Fin ###################################################"

##############################[ Fin du Programme ]##############################
