#!/bin/bash
###########################################################################################  
# Nom : AR_ARKEA-KENGO.sh                                                                 #
# Description : Script servant a effectuer avec option la livraison de Kengo et So-Kengo  #
# Auteur : Exploitation ASTEN                                                             #
# Date de Creation : 20/02/2018                                                           #
# Date Last Modif  : 20/02/2018                                                           #
###########################################################################################

##############################[ Declaration des Variables ]##############################
ENVI=prod
SRVAPP1=ark-app-pr-01
SRVAPP2=ark-app-pr-02
SRVAPP3=ark-app-pr-03
SRVBDD1=ark-bdd-pr-01
USRAPP=root

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
		ssh ${USRAPP}@${SRVAPP1} '/etc/init.d/tomcat start'
		sleep 10
		ssh ${USRAPP}@${SRVAPP1} 'ps -eaf | grep -i java | grep -v grep'
	elif [ $1 == "APP2" ]
	then
		echo " - Lancement Tomcat sur ${SRVAPP2}"
		/etc/init.d/tomcat start
		sleep 10
		ps -eaf | grep -i java | grep -v grep
	else
		echo "Fct Lancement Tomcat : Pas de param"
	fi
}

############# -=[ Fct Suppression Fichiers Tomcat ]=- #############
function SupFicTomcat(){
	if [ $1 == "APP1" ]
	then
		echo " - Suppression des Fichiers Tomcat sur ${SRVAPP1}"
		ssh ${USRAPP}@${SRVAPP1} 'cd /app/tomcat/logs/; rm -fr *'
		ssh ${USRAPP}@${SRVAPP1} 'cd /app/tomcat/work/; rm -fr *'
		ssh ${USRAPP}@${SRVAPP1} 'cd /app/tomcat/temp/; rm -fr *'
		ssh ${USRAPP}@${SRVAPP1} 'cd /app/tomcat/webapps/; rm -fr kengo-admin#v1/ kengo-api#v1/'
	elif [ $1 == "APP2" ]
	then
		echo " - Suppression des Fichiers Tomcat sur ${SRVAPP2}"
		cd /app/tomcat/logs/; rm -fr *
		cd /app/tomcat/work/; rm -fr *
		cd /app/tomcat/temp/; rm -fr *
		cd /app/tomcat/webapps/; rm -fr 'kengo-admin#v1/' 'kengo-api#v1/'
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

############# -=[ Fct Verification Livrables ]=- #############
function CheckLivrable(){
	BKOFF=kengo-backoffice.tar.gz
	FTOFF=kengo-frontoffice.tar.gz
	echo " -=[ Verification du Livrable ]=-"
	echo " 0) Acces Repertoire : $1"
	cd $1
	echo ""
	echo " 1) Unzip Livrable : $2"
	unzip $2
	cd $3
	echo ""
	echo " 2) test tar tzvf ${BKOFF}"
	tar tzvf ${BKOFF}
	echo ""
	echo " 3) test tar tzvf ${FTOFF}"
	tar tzvf ${FTOFF}
}

#########################################################################################

##############################[ Debut du Programme ]##############################

clear
echo "-=[ Arret/Relance Arkea - Kengo & So-Kengo ]=-"
echo "Arret du service Nginx sur le serveur ${SRVAPP2}"
StopNginx APP2
echo "Positionnement d'une page de maintenance sur le serveur ${SRVAPP1}"
MepMaint APP1
echo "Arret du service Tomcat sur les serveurs :"
echo " - ${SRVAPP1} :"
StopTomcat APP1
echo " - ${SRVAPP2} :"
StopTomcat APP2
echo "Suppression des fichiers Tomcat sur ${SRVAPP2}"
SupFicTomcat APP2
echo "Relance du service Tomcat sur le serveur ${SRVAPP2}"
StartTomcat APP2
Pause "Verification de la log: /app/tomcat/logs/catalina.out sur ${SRVAPP2} => En cas d'erreur Analyse et envoi des logs a l'equipe Kengo"
echo "Suppression des fichiers Tomcat sur ${SRVAPP1}"
SupFicTomcat APP1
echo "Relance du service Tomcat sur le serveur ${SRVAPP1}"
StartTomcat APP1
Pause "Verification de la log: /app/tomcat/logs/catalina.out sur ${SRVAPP1} => En cas d'erreur Analyse et envoi des logs a l'equipe Kengo"
echo "Lancement du service Nginx sur le serveur ${SRVAPP2}"
StartNginx APP2
echo "Arret du service Nginx sur le serveur ${SRVAPP1}"
StopNginx APP1
echo "Suppression des pages de maintenance sur le serveur ${SRVAPP1}"
SupMaint APP1
echo "Lancement du service Nginx sur le serveur ${SRVAPP1}"
StartNginx APP1

##############################[ Fin du Programme ]##############################
