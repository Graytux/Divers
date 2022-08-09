#/bin/ksh

SQLREG=/home/hmachhra/SQL_Verif_MeP_REG.sql
echo "spool Resultat_Verif_MeP_REG" > ${SQLREG}


# Construction SQL : Debut Requete
echo "select cdregl,cdstco,cdcode,timjdo from hr.zdtd12 b, hr.zd00 a, hr.zdtd11 c" >> ${SQLREG}
echo "where" >> ${SQLREG}
echo "a.nudoss=b.nudoss and a.nudoss=c.nudoss" >> ${SQLREG}
echo "and cdinfo = '00'" >> ${SQLREG}
echo "--and timjdo < sysdate - 1" >> ${SQLREG}
echo "and cdregl||'-'||cdstco||'-'||cdcode in" >> ${SQLREG}
echo "(" >> ${SQLREG}


# Construction SQL : Corp Requete
CNT=`wc -l /home/hmachhra/Liste_MeP_REG.lst | awk '{print $1}'`
CPT=1
for ELT in $(cat /home/hmachhra/Liste_MeP_REG.lst)
do
	if [ $CPT -ge $CNT ]
	then
		echo "'${ELT}'" >> ${SQLREG}
	else
		echo "'${ELT}'," >> ${SQLREG}
		CPT=`expr $CPT + 1`
	fi
done


# Construction SQL : Fin Requete
echo ");" >> ${SQLREG}
echo "quit" >> ${SQLREG}
echo "spool off" >> ${SQLREG}


# Execution Fichier SQL
sqlplus HR/MACHPH7@PH7400D @${SQLREG}

ls -lrt /home/hmachhra/Resultat_Verif_MeP_REG*
