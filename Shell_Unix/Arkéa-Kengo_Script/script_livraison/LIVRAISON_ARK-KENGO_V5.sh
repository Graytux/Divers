#!/bin/bash
###########################################################################################  
# Nom : LIVRAISON_ARK-KENGO_V5.sh                                                         #
# Description : ce script sert a effectuer avec option les livraison de Kengo et So-Kengo #
# Auteur : Exploitation ASTEN (QGU)                                                       #
# Date de Creation : 26/01/2017                                                           #
# Date Last Modif  : 28/11/2019                                                           #
###########################################################################################

##############################[ Declaration des Variables ]##############################
. /opt/exploit/script_livraison/.env_ARKEA-KENGO

DATO=` +%Y%m%d`
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

## Menu de Choix pour le Work ##
clear
pwd
echo "-=[ Livraison Arkea - Kengo & So-Kengo ]=-"
echo "           Choix: Date Livrable           "
TAB=(`ls -rt /app/livrables | tail -5`)
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

clear
echo "-=[ Livraison Arkea - Kengo & So-Kengo ]=-"
echo "          Choix: Version Livrable         "
cd /app/livrables/${CHOIX_DAT_LIV}
TAB2=(`ls -rt *.zip`)
select option in ${TAB2[*]}
do
    case $option in
		"${TAB2[0]}") 
			CHOIX_VER_LIV="${TAB2[0]}"
			break;;
		"${TAB2[1]}") 
			CHOIX_VER_LIV="${TAB2[1]}"
			break;;
		"${TAB2[2]}") 
			CHOIX_VER_LIV="${TAB2[2]}"
			break;;
		"${TAB2[3]}") 
			CHOIX_VER_LIV="${TAB2[3]}"
			break;;
		"${TAB2[4]}") 
			CHOIX_VER_LIV="${TAB2[4]}"
			break;;
		*) break;;
    esac
done

clear
echo "-=[ Livraison Arkea - Kengo & So-Kengo ]=-"
echo "           Choix: Type Livraison          "
select option in BackOffice-FrontOffice BackOffice FrontOffice
  do
    case $option in
		"BackOffice-FrontOffice") 
			CHOIX_WORK="wBF"
			break;;
		"BackOffice")
			CHOIX_WORK="wB"
			break;;
		"FrontOffice")
			CHOIX_WORK="wF"
			break;;
		*) continue;;
    esac
done

clear
echo "-=[ Livraison Arkea - Kengo & So-Kengo ]=-"
echo "                  Resume                  "
echo ""
echo " Date du livrable: ${CHOIX_DAT_LIV}"
echo " Version du livrable: ${CHOIX_VER_LIV}"
echo " Repertoire: /app/livrables/${CHOIX_DAT_LIV}/${CHOIX_VER_LIV}"
CHX_VERNOZIP=${CHOIX_VER_LIV/.zip/}


echo "### Etape 1 : Pre-requis"
echo "1.a) Sauvegarde applicative sur le serveur ${SRVAPP2}"
ksh /opt/exploit/shl/sauvegarde_app.sh total 1>/opt/exploit/log/sauvegarde_app.sh.log 2>&1
echo "1.b) Sauvegarde applicative sur le serveur ${SRVBDD1}"
echo "Lancer la cmd => ksh /opt/exploit/shl/export_base.x total 1>/opt/exploit/log/export_base.x.log 2>&1 <= sur ${SRVBDD1}"
Pause "Ne valider que lorsque la commande s'est termine Ok sur la machine de BDD"
echo "1.c) Positionner un arret de supervision (downtime) pour l'ensemble des serveurs (${SRVAPP1} & ${SRVAPP2}) et services"
Pause "Ne valider que lorsque le downtime est verifie et actif"
echo "1.d) Desactiver l'eventhandler sur centreon pour le service supervision-applicative sur les deux serveurs APP : ${SRVAPP1} et ${SRVAPP2}"
Pause "Ne valider que lorsque l'eventhandler est bien inactif sur les 2 services"
echo "#####"
echo ""

echo "UnZip des livrables sur ${SRVAPP2}"
cd /app/livrables/${CHOIX_DAT_LIV}
unzip ${CHOIX_VER_LIV}


echo "Arret du service Nginx sur le serveur ${SRVAPP2}"
StopNginx APP2
echo "Positionnement d'une page de maintenance sur le serveur ${SRVAPP1}"
MepMaint APP1
echo "Positionnement d'une page de maintenance sur le serveur ${SRVAPP2}"
MepMaint APP2
Pause "Verification : Les pages de maintenance sont-elles en place? si Oui Continuer"

if [ $CHOIX_WORK == "wBF" ] || [ $CHOIX_WORK == "wB" ]
then
	echo " - ${SRVAPP2} :"
	StopTomcat APP2
	Pause "Verification Process Tomcat ps -eaf | grep tomcat => si ok continuer"
	
	echo "Livraison du BackOffice sur ${SRVAPP2}"
	cd /app/livrables/${CHOIX_DAT_LIV}
	cd ${CHX_VERNOZIP}
	cp kengo-backoffice.tar.gz /app
	cd /app
	rm -fr kengo-backoffice
	tar -xvzf kengo-backoffice.tar.gz
	cp /app/kengo-backoffice/backoffice/beaver_v1.0.0/conf/properties.env.${ENVI} /app/properties.env
	/app/kengo-backoffice/backoffice/beaver_v1.0.0/bin/update_env.sh /app/properties.env
	Pause "Verification: Il ne doit pas y avoir d'erreur. C'est tres important  => En cas d'erreur Analyse et envoi des logs a l'equipe Kengo"
	chown -R kengo.kengo kengo-backoffice
	
	echo "Suppression des fichiers Tomcat sur ${SRVAPP2}"
	SupFicTomcat APP2
fi

Pause "SQL : Moment pour passer les fichiers sql sur ${SRVBDD1} si besoin, sinon continuer"

if [ $CHOIX_WORK == "wBF" ] || [ $CHOIX_WORK == "wB" ]
then
	echo "Relance du service Tomcat sur le serveur ${SRVAPP2}"
	StartTomcat APP2
	CheckTomcat APP2

	echo "Lancement du service Nginx sur le serveur ${SRVAPP2}"
	StartNginx APP2
	echo "Arret du service Nginx sur le serveur ${SRVAPP1}"
	StopNginx APP1

	echo "Arret du service Tomcat sur les serveurs :"
	echo " - ${SRVAPP1} :"
	StopTomcat APP1
    Pause "Verification Process Tomcat ps -eaf | grep tomcat => si ok continuer"
	
	echo "Copie du repertoire kengo-backoffice sur le serveur ${SRVAPP1}"
	cd /app
	rm kengo-backoffice.tar.gz
	tar -cvzf kengo-backoffice.tar.gz kengo-backoffice
	scp kengo-backoffice.tar.gz ${SRVAPP1}:/app

	echo "Livraison du BackOffice sur ${SRVAPP1}"
	ssh ${USRAPP}@${SRVAPP1} 'cd /app; rm -fr kengo-backoffice; tar -xvzf kengo-backoffice.tar.gz; rm -f kengo-backoffice.tar.gz'
	echo "Suppression des fichiers Tomcat sur ${SRVAPP1}"
	SupFicTomcat APP1
	
	echo "Relance du service Tomcat sur le serveur ${SRVAPP1}"
	StartTomcat APP1
	CheckTomcat APP1

	echo "Lancement du service Nginx sur le serveur ${SRVAPP1}"
	StartNginx APP1
	echo "Arret du service Nginx sur le serveur ${SRVAPP2}"
	StopNginx APP2

fi

if [ $CHOIX_WORK == "wBF" ] || [ $CHOIX_WORK == "wF" ]
then
	echo "Livraison du FrontOffice sur ${SRVAPP2}"
	cd /app/kengo-frontoffice
	rm -fr *
	cd /app/livrables/${CHOIX_DAT_LIV}
	cd ${CHX_VERNOZIP}
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
fi

echo "Lancement du service Nginx sur le serveur ${SRVAPP2}"
StartNginx APP2
echo "Arret du service Nginx sur le serveur ${SRVAPP1}"
StopNginx APP1

if [ $CHOIX_WORK == "wBF" ] || [ $CHOIX_WORK == "wF" ]
then
	echo "Livraison du FrontOffice sur ${SRVAPP1}"
	ssh ${USRAPP}@${SRVAPP1} 'cd /app/; rm -fr kengo-frontoffice; tar -xvzf kengo-frontoffice.tar.gz; rm -f kengo-frontoffice.tar.gz'
fi

echo "Lancement du service Nginx sur le serveur ${SRVAPP1}"
StartNginx APP1

if [ $CHOIX_WORK == "wB" ]
then
	echo "Suppression des pages de maintenance sur le serveur ${SRVAPP1}"
	SupMaint APP1
	echo "Suppression des pages de maintenance sur le serveur ${SRVAPP2}"
	SupMaint APP2
fi

echo ""
echo "### Etape X : Post-requis"
echo "X.a) Activer l'eventhandler sur centreon pour le service supervision-applicative sur les deux serveurs APP : ${SRVAPP1} et ${SRVAPP2}"
Pause "Ne valider que lorsque l'eventhandler est bien actif sur les 2 services"
echo "X.b) Supprimmer l'arret de supervision (downtime) pour l'ensemble des serveurs (${SRVAPP1} & ${SRVAPP2}) et services"
Pause "Ne valider que lorsque la suppression est verifiee et le downtime inactif"

##############################[ Fin du Programme ]##############################
