#!/bin/bash
# definition des variables
clusterdir=/var/www/MISP/app/files/misp-galaxy/clusters
galaxiedir=/var/www/MISP/app/files/misp-galaxy/galaxies
jsonfile=bdm_it.json
convertfile=convert.awk

function perror
{
	echo $1 >&2
	exit 1
}

# Verrication des prerequis
test -f $convertfile || perror "fichier awk absent"
test -d $clusterdir || perror "dossier cluster absent"
test -d $galaxiedir || perror "dossier galaxie absent"
which dbview >/dev/null  || perror "dbview absent"
which awk >/dev/null  || perror "awk absent"
which curl >/dev/null  || perror "curl absent"
which wget >/dev/null  || perror "wget absent"


# Telechargement du dernier fichier sur le site d'amelie
dbfile=`curl http://www.codage.ext.cnamts.fr/codif/bdm_it/index_tele_ucd.php 2>/dev/null |grep ucd_total -a | cut -d\" -f2|sed 's/.*\///'`
test -e $dbfile && rm $dbfile
wget http://www.codage.ext.cnamts.fr/`curl http://www.codage.ext.cnamts.fr/codif/bdm_it/index_tele_ucd.php 2>/dev/null |grep ucd_total -a | cut -d\" -f2`
if [ -e $dbfile ] ; then
	echo fichier $dbfile telecharger
else
	echo fichier BdM_IT non telecharger
	exit 2
fi
version=`echo $dbfile | cut -d_ -f3 | sed 's/^0*//'`

# conversion du fichier dbf en json pour le cluster
dbview $dbfile | iconv -f ISO885915 -t UTF8 | awk -v vers=$version -f $convertfile > $clusterdir/$jsonfile
if [ $? -eq 0 ] ; then 
	echo fichier $clusterdir/$jsonfile genere
else
	echo la conversion vers $clusterdir/$jsonfile a echoue
	exit 3
fi

# generation du fichier galaxie
echo '{
  "description": "Liste Medicamant BDM-IT",
  "icon": "industry",
  "name": "med-bdm-it",
  "namespace": "misp",
  "type": "medicament",
  "uuid": "84310ba3-fa6a-44aa-b378-b9e3271c7777",
  "version": 1
}'>$galaxiedir/$jsonfile

