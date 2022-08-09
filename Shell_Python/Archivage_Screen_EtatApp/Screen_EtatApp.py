import os
import zipfile
from datetime import datetime

ExclDos = "Archives"
RepBase = "C:/Documents and Settings/<xxxxxxx>/Mes documents/PrintScreen Files/"
RepArchive = RepBase + ExclDos
os.chdir(RepBase)


Tme = datetime.now()
Jour = str(Tme.day)
Mois = str(Tme.month)
Anne = str(Tme.year)
Heur = str(Tme.hour)
Minu = str(Tme.minute)
Seco = str(Tme.second)

if Tme.month <= 9:
    Mois = "0" + str(Tme.month)
if Tme.day <= 9:
    Jour = "0" + str(Tme.day)
if Tme.hour <= 9:
    Heur = "0" + str(Tme.hour)
if Tme.minute <= 9:
    Minu = "0" + str(Tme.minute)
if Tme.second <= 9:
    Seco = "0" + str(Tme.second)
    
FichArch = RepArchive + "/" + Anne + Mois + Jour + "_" + Heur + Minu + Seco + "_ScreenEtatApp.zip"

lstfich = os.listdir()
lstfich.remove(ExclDos)
if not lstfich:
    print("Pas de fichier à archiver !!")
else:
    FcAch = zipfile.ZipFile(FichArch,'w',zipfile.ZIP_DEFLATED)
    print("Archivages des fichiers suivants:")
    for n in lstfich:
        print("\t",n)
        FcAch.write(n)
    FcAch.close()
    print("Fin de l'archivage !!\n")
    print("Suppression des fichiers archivés:")
    for n in lstfich:
        print("\t",n)
        os.remove(n)
    print("Fin de la suppression !!")
