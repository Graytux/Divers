#!/bin/bash
###########################################################################################  
# Nom : Livraison_ARK-KENGO.sh                                                            #
# Description : ce script sert à effectuer avec option les livraison de Kengo et So-Kengo #
# Auteur : Exploitation ASTEN                                                             #
# Date de Creation : JJ/MM/AAAA                                                           #
# Date Last Modif  : JJ/MM/AAAA                                                           #
###########################################################################################

##############################[ Controle des Parametres ]##############################
if [ $# -lt 2 ]; then
	echo "Erreur: il faut au moins 2 arguments.";
	echo "ex: ./Livraison_ARK-KENGO.sh AAAAMMJJ Vx.x.x";
	echo " AAAAMMJJ : nom du repertoire des livrables dans /app/livrables"
	echo " Vx.x.x   : Version du livrable dans /app/livrables/AAAAMMJJ/KENGO_Vx.x.x.zip"
	echo ""
	exit 2;
fi

##############################[ Declaration des Variables ]##############################
ENVI=preprod
SRVAPP1=ark-app-rc-01
SRVAPP2=ark-app-rc-02
SRVAPP3=ark-app-rc-03
SRVBDD1=ark-bdd-rc-01
USRAPP=root
DATELIVR=$1
VERKENGO=$2

#########################################################################################
##############################[ Declaration des Fonctions ]##############################

############# -=[ Fct pause interactive ]=- #############
function Pause(){
   read -p "$*"
}

############# -=[ Fct Arret Nginx ]=- #############
function StopNginx(){
	if [ $1 == "APP1"]
	then
		echo " - Arret Nginx sur ${SRVAPP1}"
		ssh ${USRAPP}@${SRVAPP1} '/etc/init.d/nginx stop'
		sleep 10
		ssh ${USRAPP}@${SRVAPP1} 'ps -eaf | grep -i nginx | grep -v grep'
	else if [ $1 == "APP2"]
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
	if [ $1 == "APP1"]
	then
		echo " - Lancement Nginx sur ${SRVAPP1}"
		ssh ${USRAPP}@${SRVAPP1} '/etc/init.d/nginx start'
		sleep 10
		ssh ${USRAPP}@${SRVAPP1} 'ps -eaf | grep -i nginx | grep -v grep'
	else if [ $1 == "APP2"]
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
	if [ $1 == "APP1"]
	then
		echo " - Arret Tomcat sur ${SRVAPP1}"
		ssh ${USRAPP}@${SRVAPP1} '/etc/init.d/tomcat start'
		sleep 10
		ssh ${USRAPP}@${SRVAPP1} 'ps -eaf | grep -i java | grep -v grep'
	else if [ $1 == "APP2"]
		echo " - Arret Tomcat sur ${SRVAPP2}"
		/etc/init.d/tomcat start
		sleep 10
		ps -eaf | grep -i java | grep -v grep
	else
		echo "Fct Arret Tomcat : Pas de param"
	fi
}

############# -=[ Fct Lancement Tomcat ]=- #############
function StartTomcat(){
	if [ $1 == "APP1"]
	then
		echo " - Lancement Tomcat sur ${SRVAPP1}"
		ssh ${USRAPP}@${SRVAPP1} '/etc/init.d/tomcat start'
		sleep 10
		ssh ${USRAPP}@${SRVAPP1} 'ps -eaf | grep -i java | grep -v grep'
	else if [ $1 == "APP2"]
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
	if [ $1 == "APP1"]
	then
		echo " - Suppression des Fichiers Tomcat sur ${SRVAPP1}"
		ssh ${USRAPP}@${SRVAPP1} 'cd /app/tomcat/logs/; rm -fr *'
		ssh ${USRAPP}@${SRVAPP1} 'cd /app/tomcat/work/; rm -fr *'
		ssh ${USRAPP}@${SRVAPP1} 'cd /app/tomcat/temp/; rm -fr *'
		ssh ${USRAPP}@${SRVAPP1} 'cd /app/tomcat/webapps/; rm -fr kengo-admin#v1/ kengo-api#v1/'
	else if [ $1 == "APP2"]
		echo " - Suppression des Fichiers Tomcat sur ${SRVAPP2}"
		cd /app/tomcat/logs/; rm -fr *
		cd /app/tomcat/work/; rm -fr
		cd /app/tomcat/temp/; rm -fr *
		cd /app/tomcat/webapps/; rm -fr 'kengo-admin#v1/' 'kengo-api#v1/'
	else
		echo "Fct Suppression Fichiers Tomcat : Pas de param"
	fi
}

############# -=[ Fct Mise en place de la page de maintenance ]=- #############
function MepMaint(){
	if [ $1 == "APP1"]
	then
		echo " - Mise en place de la page de maintenance sur ${SRVAPP1}"
		ssh ${USRAPP}@${SRVAPP1} 'cp -p /app/kengo-frontoffice/index.html /app/kengo-frontoffice/index.html-sav'
		ssh ${USRAPP}@${SRVAPP1} 'cp -p /app/kengo-frontoffice/so/index.html /app/kengo-frontoffice/so/index.html-sav'
		ssh ${USRAPP}@${SRVAPP1} 'cp -p /app/maintenance.html /app/kengo-frontoffice/index.html'
		ssh ${USRAPP}@${SRVAPP1} 'cp -p /app/maintenance_so.html /app/kengo-frontoffice/so/index.html'
	else if [ $1 == "APP2"]
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
	if [ $1 == "APP1"]
	then
		echo " - Suppression de la page de maintenance sur ${SRVAPP1}"
		ssh ${USRAPP}@${SRVAPP1} 'mv /app/kengo-frontoffice/index.html-sav /app/kengo-frontoffice/index.html'
		ssh ${USRAPP}@${SRVAPP1} 'mv /app/kengo-frontoffice/so/index.html-sav /app/kengo-frontoffice/so/index.html'
	else if [ $1 == "APP2"]
		echo " - Suppression de la page de maintenance sur ${SRVAPP2}"
		mv /app/kengo-frontoffice/index.html-sav /app/kengo-frontoffice/index.html
		smv /app/kengo-frontoffice/so/index.html-sav /app/kengo-frontoffice/so/index.html
	else
		echo "Fct Suppression de la page de maintenance : Pas de param"
	fi
}



#########################################################################################
#########################################################################################



echo "########################\n# Etape 1 : Pré-requis #\n########################"
echo "1.a) Sauvegarde applicative sur le serveur ${SRVAPP2}"
ksh /opt/exploit/shl/sauvegarde_app.sh total 1>/opt/exploit/log/sauvegarde_app.sh.log 2>&1

echo "1.b) Sauvegarde applicative sur le serveur ${SRVBDD1}"
echo "Lancer la cmd => ksh /opt/exploit/shl/export_base.x total 1>/opt/exploit/log/export_base.x.log 2>&1 <= sur ${SRVBDD1}"
Pause "Ne valider que lorsque la commande s'est termine Ok sur la machine de BDD"

echo "1.c) Positionner un arrêt de supervision (downtime) pour l’ensemble des serveurs (${SVRAPP1} & ${SRVAPP2}) et services"
Pause "Ne valider que lorsque le downtime est vérifié et actif"

echo "1.d) Desactiver l’eventhandler sur centreon pour le service supervision-applicative sur les deux serveurs APP : ${SRVAPP1} et ${SRVAPP2}"
Pause "Ne valider que lorsque l'eventhandler est bien inactif sur les 2 services"


echo "########################\n# Etape : Livraison du BackOffice #\n########################"

echo "Arrêt du service Nginx sur le serveur ${SRVAPP2}"
StopNginx "APP2"

echo "Positionnement d'une page de maintenance sur le serveur ${SRVAPP1}"
MepMaint "APP1"
Pause "Verification : Les pages de maintenance sont-elles en place? si Oui Continuer"

echo "Arrêt du service Tomcat sur les serveurs : ${SRVAPP1} & ${SRVAPP2}"
echo " - ${SRVAPP1} :"
StopTomcat "APP1"
echo "\n - ${SRVAPP2} :"
StopTomcat "APP2"


echo "Deploiement des Livrables sur ${SRVAPP2}"
cd /app/livrables/${DATELIVR}
unzip KENGO_${VERKENGO}.zip
cd KENGO_${VERKENGO}
cp kengo-backoffice.tar.gz /app
cd /app
rm –fr kengo-backoffice
tar -xvzf kengo-backoffice.tar.gz
cp /app/kengo-backoffice/backoffice/beaver_v1.0.0/conf/properties.env.${ENVI} /app/properties.env
/app/kengo-backoffice/backoffice/beaver_v1.0.0/bin/update_env.sh /app/properties.env
Pause "Verification: Il ne doit pas y avoir d’erreur – C’est très important  => En cas d'erreur Analyse et envoi des logs a l'equipe Kengo"
chown -R kengo.kengo kengo-backoffice

echo "Suppression des fichiers Tomcat sur ${SRVAPP2}"
SupFicTomcat "APP2"

echo "Relance du service Tomcat sur le serveur ${SRVAPP2}"
StartTomcat "APP2"
Pause "Verification de la log: /app/tomcat/logs/catalina.out sur ${SRVAPP2} => En cas d'erreur Analyse et envoi des logs a l'equipe Kengo"

echo "Copie du repertoire kengo-backoffice sur le serveur ${SRVAPP1}"
cd /app
rm kengo-backoffice.tar.gz
tar -cvzf kengo-backoffice.tar.gz kengo-backoffice
scp kengo-backoffice.tar.gz ${SRVAPP1}:/app

echo "Deploiement des livrables sur ${SRVAPP1}"
ssh ${USRAPP}@${SRVAPP1} 'cd /app; rm -fr kengo-backoffice; tar -xvzf kengo-backoffice.tar.gz; rm kengo-backoffice.tar.gz'

echo "Suppression des fichiers Tomcat sur ${SRVAPP1}"
SupFicTomcat "APP1"

echo "Relance du service Tomcat sur le serveur ${SRVAPP1}"
StartTomcat "APP1"
Pause "Verification de la log: /app/tomcat/logs/catalina.out sur ${SRVAPP1} => En cas d'erreur Analyse et envoi des logs a l'equipe Kengo"



echo "########################\n# Etape : Livraison du FrontOffice #\n########################"


echo "Deploiement des Livrables sur ${SRVAPP2}"
cd /app/kengo-frontoffice
rm -fr *
cd /app/livrables/${DATELIVR}
cd KENGO_${VERKENGO}
cp kengo-frontoffice.tar.gz /app/kengo-frontoffice
cd /app/kengo-frontoffice
tar -xvzf kengo-frontoffice.tar.gz
cp -p /app/fortiadc-healthcheck.html  /app/kengo-frontoffice
cd /app
chown -R nginx.nginx kengo-frontoffice

echo "Copie du repertoire kengo-frontoffice sur le serveur ${SRVAPP1}"
cd /app
rm kengo-frontoffice.tar.gz
tar -cvzf kengo-frontoffice.tar.gz kengo-frontoffice 
scp kengo-frontoffice.tar.gz ${SRVAPP1}:/app/

echo "Lancement du service Nginx sur le serveur ${SRVAPP2}"
StartNginx "APP2"

echo "Arrêt du service Nginx sur le serveur ${SRVAPP1}"
StopNginx "APP1"

echo "Suppression des pages de maintenance sur le serveur ${SRVAPP1}"
SupMaint "APP1"

echo "Deploiement des Livrables sur ${SRVAPP1}"
ssh ${USRAPP}@${SRVAPP1} 'cd /app/; rm -fr kengo-frontoffice; tar -xvzf kengo-frontoffice.tar.gz; rm kengo-frontoffice.tar.gz'

echo "Lancement du service Nginx sur le serveur ${SRVAPP1}"
StartNginx "APP1"
