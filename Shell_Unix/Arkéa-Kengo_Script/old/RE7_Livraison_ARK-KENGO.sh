#!/bin/bash
###########################################################################################  
# Nom : Livraison_ARK-KENGO.sh                                                            #
# Description : ce script sert à effectuer avec option les livraison de Kengo et So-Kengo #
# Auteur : Exploitation ASTEN                                                             #
# Date de Creation : JJ/MM/AAAA                                                           #
# Date Last Modif  : JJ/MM/AAAA                                                           #
###########################################################################################

##############################[ Declaration des Fonctions ]##############################

############# -=[ Fct pause interactive ]=- #############
function Pause(){
   read -p "$*"
}

#########################################################################################

if [ $# -lt 2 ]; then
	echo "Erreur: il faut au moins 2 arguments.";
	echo "ex: ./RE7_Livraison_ARK-KENGO.sh AAAAMMJJ Vx.x.x";
	exit 2;
fi


echo "########################\n# Etape 0 :  Var  ENV  #\n########################"
ENVI=preprod
SRVAPP1=ark-app-rc-01
SRVAPP2=ark-app-rc-02
SRVAPP3=ark-app-rc-03
SRVBDD1=ark-bdd-rc-01
USRAPP=root
DATELIVR=$1
VERKENGO=$2



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

echo "1.e) Arrêt du service Nginx sur le serveur ${SRVAPP2}"
/etc/init.d/nginx stop
ps -eaf | grep -i nginx | grep -v grep

echo "1.f) Positionnement d'une page de maintenance sur le serveur ${SRVAPP1}"
ssh ${USRAPP}@${SRVAPP1} 'cp -p /app/kengo-frontoffice/index.html /app/kengo-frontoffice/index.html-sav'
ssh ${USRAPP}@${SRVAPP1} 'cp -p /app/kengo-frontoffice/so/index.html /app/kengo-frontoffice/so/index.html-sav'
ssh ${USRAPP}@${SRVAPP1} 'cp -p /app/maintenance.html /app/kengo-frontoffice/index.html'
ssh ${USRAPP}@${SRVAPP1} 'cp -p /app/maintenance_so.html /app/kengo-frontoffice/so/index.html'
Pause "Verification : Les pages de maintenance sont-elles en place? si Oui Continuer"

echo "1.g) Arrêt du service Tomcat sur les serveurs : ${SRVAPP1} & ${SRVAPP2}"
echo " - ${SRVAPP1} :"
ssh ${USRAPP}@${SRVAPP1} '/etc/init.d/tomcat stop'
ssh ${USRAPP}@${SRVAPP1} 'ps -eaf | grep -i java | grep -v grep'
echo "\n - ${SRVAPP2} :"
/etc/init.d/tomcat stop
ps -eaf | grep -i java | grep -v grep



echo "########################\n# Etape 2 : Livraison du BackOffice #\n########################"
echo "2.a) Deploiement des Livrables sur ${SRVAPP2}"
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

echo "2.b) Suppression des fichiers Tomcat sur ${SRVAPP2}"
cd /app/tomcat/logs/
rm -fr *
cd /app/tomcat/work/
rm -fr
cd /app/tomcat/temp/
rm -fr *
cd /app/tomcat/webapps/
rm -fr 'kengo-admin#v1/' 'kengo-api#v1/'


echo "2.c) Relance du service Tomcat sur le serveur ${SRVAPP2}"
/etc/init.d/tomcat start
ps -eaf | grep -i java | grep -v grep
Pause "Verification de la log: /app/tomcat/logs/catalina.out sur ${SRVAPP2} => En cas d'erreur Analyse et envoi des logs a l'equipe Kengo"

echo "2.d) Copie du repertoire kengo-backoffice sur le serveur ${SRVAPP1}"
cd /app
rm kengo-backoffice.tar.gz
tar -cvzf kengo-backoffice.tar.gz kengo-backoffice
scp kengo-backoffice.tar.gz ${SRVAPP1}:/app

echo "2.e) Deploiement des livrables sur ${SRVAPP1}"
ssh ${USRAPP}@${SRVAPP1} 'cd /app; rm -fr kengo-backoffice; tar -xvzf kengo-backoffice.tar.gz; rm kengo-backoffice.tar.gz'

echo "2.f) Suppression des fichiers Tomcat sur ${SRVAPP1}"
ssh ${USRAPP}@${SRVAPP1} 'cd /app/tomcat/logs/; rm -fr *'
ssh ${USRAPP}@${SRVAPP1} 'cd /app/tomcat/work/; rm -fr *'
ssh ${USRAPP}@${SRVAPP1} 'cd /app/tomcat/temp/; rm -fr *'
ssh ${USRAPP}@${SRVAPP1} 'cd /app/tomcat/webapps/; rm -fr kengo-admin#v1/ kengo-api#v1/'

echo "2.g) Relance du service Tomcat sur le serveur ${SRVAPP1}"
ssh ${USRAPP}@${SRVAPP1} '/etc/init.d/tomcat start'
ssh ${USRAPP}@${SRVAPP1} 'ps -eaf | grep -i java | grep -v grep'
Pause "Verification de la log: /app/tomcat/logs/catalina.out sur ${SRVAPP1} => En cas d'erreur Analyse et envoi des logs a l'equipe Kengo"



echo "########################\n# Etape 3 : Livraison du FrontOffice #\n########################"
echo "3.a) Deploiement des Livrables sur ${SRVAPP2}"
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
cd /app
rm kengo-frontoffice.tar.gz
tar -cvzf kengo-frontoffice.tar.gz kengo-frontoffice 
scp kengo-frontoffice.tar.gz ${SRVAPP1}:/app/ 
/etc/init.d/nginx start

echo "3.b) Suppression des pages de maintenance sur le serveur ${SRVAPP1}"
ssh ${USRAPP}@${SRVAPP1} '/etc/init.d/nginx stop'
ssh ${USRAPP}@${SRVAPP1} 'mv /app/kengo-frontoffice/index.html-sav /app/kengo-frontoffice/index.html'
ssh ${USRAPP}@${SRVAPP1} 'mv /app/kengo-frontoffice/so/index.html-sav /app/kengo-frontoffice/so/index.html'
echo "3.c) Deploiement des Livrables sur ${SRVAPP1}"
ssh ${USRAPP}@${SRVAPP1} 'cd /app/; rm -fr kengo-frontoffice; tar -xvzf kengo-frontoffice.tar.gz; rm kengo-frontoffice.tar.gz'
ssh ${USRAPP}@${SRVAPP1} '/etc/init.d/nginx start'