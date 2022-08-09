#Récupération des paramètres
param(
	[string]$parUser,
	[string]$parPwd
)

#verifier la presence d'un fichier Erreur : d:\storeland\Depart\Erreur\MAG_WST_SIE_MAG_PDT_ERREUR_*.txt
d:

$EXPLOITSHL='d:\opt\exploit\shl'
$BASE='d:\storeland\Depart\Erreur\'
$ARCH='d:\storeland\Depart\Erreur\Archives\'
$RECH='d:\storeland\Depart\Erreur\MAG_WST_SIE_MAG_PDT_ERREUR_*.txt'
$STAMBIA='d:\Program Files (x86)\stambia\stambiaRuntime Storeland'

$A=Get-ChildItem -Name $RECH

if ( $A -eq $null){
	echo ""
	echo "-=[ Pas de fichier en Erreur ]=-"
	exit 0
}
else{
	$CPTA=(Get-ChildItem -Name $RECH | Measure-Object).count
	echo "-=[ Nombre de fichier d'erreur : $CPTA ]=-"
	echo ""
	Foreach ( $FICH in $A ) {
		cd $BASE
		echo "-=[ Fichier : $FICH ]=-"
		$CPTB=(Get-Content $FICH  | Measure-Object).count
		echo "-=[ Nombre de Code : $CPTB ]=-"

		$B=Get-Content $FICH
		cd $STAMBIA
		Foreach ( $CODEMAG in $B ){
			echo ""
			echo "-=[ Code Magasin : $CODEMAG ]=-"
			echo "-=[ cmd : .\startdelivery.bat -name MAG_WST_SIE_MAG_PDT_MASTER -var ~/pUser $parUser -var ~/pPwd $parPwd -var ~/pCodeMagasin $CODEMAG ]=-"
#			.\startdelivery.bat -name MAG_WST_SIE_MAG_PDT_MASTER -var ~/pCodeMagasin $CODEMAG
			.\startdelivery.bat -name MAG_WST_SIE_MAG_PDT_MASTER -var ~/pUser $parUser -var ~/pPwd $parPwd -var ~/pCodeMagasin $CODEMAG
		}
		cd $BASE
		Move-Item -Path $FICH -Destination $ARCH
		echo ""
	}
}
cd $EXPLOITSHL
exit 0