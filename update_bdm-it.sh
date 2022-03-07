#!/bin/bash
# definition des variables
clusterdir=/var/www/MISP/app/files/misp-galaxy/clusters
galaxiedir=/var/www/MISP/app/files/misp-galaxy/galaxies
clusterschema=/var/www/MISP/app/files/misp-galaxy/schema_clusters.json
galaxieschema=/var/www/MISP/app/files/misp-galaxy/schema_galaxies.json
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
# prequis facultatif
which jq >/dev/null 
if [ $? -eq 0 ] ; then 
	check=1
	which jsonschema >/dev/null
	if [ $? -eq 0 ] ; then 
		test -f $galaxieschema && test -f $clusterschema && check=2
	else
		echo jsonschema absent les fichiers json ne pourront pas etre valides completement >&2
	fi
else
	check=0
	echo jq absent les fichiers json ne pourront pas etre valides >&2
fi

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
if [ $check -eq 1 ] ; then 
	mv $clusterdir/$jsonfile $clusterdir/$jsonfile.sav
fi

dbview -b $dbfile | cut -d: -f1,7,3,11,38,39| sed 's/   *//g'|sort |uniq | iconv -f ISO885915 -t UTF8 | awk -v vers=$version -f $convertfile > $clusterdir/$jsonfile
if [ $? -eq 0 ] ; then 
	if [ $check -eq 1 ] ; then 
		jq -e . $clusterdir/$jsonfile >/dev/null 2>&1
		if [ $? -eq 0 ] ; then 
			if [ $check -eq 2 ] ; then 
				jsonschema $clusterschema -i $clusterdir/$jsonfile
				if [ $? -eq 0 ] ; then
					echo fichier $clusterdir/$jsonfile genere
					rm $clusterdir/$jsonfile.sav
				else
					echo le fichier genere n ete pas valide je remet l ancienne version
					rm $clusterdir/$jsonfile
					mv $clusterdir/$jsonfile.sav $clusterdir/$jsonfile
				fi
			else
				echo fichier $clusterdir/$jsonfile genere
				rm $clusterdir/$jsonfile.sav
			fi
		else
			echo le fichier genere n ete pas valide je remet l ancienne version
			rm $clusterdir/$jsonfile
			mv $clusterdir/$jsonfile.sav $clusterdir/$jsonfile
		fi
	else
		echo fichier $clusterdir/$jsonfile genere
	fi
else
	echo la conversion vers $clusterdir/$jsonfile a echoue
	exit 3
fi

# generation du fichier galaxie
if [ $check -eq 1 ] ; then 
	mv $galaxiedir/$jsonfile $galaxiedir/$jsonfile.sav
fi
echo '{
  "description": "Liste Medicamant BDM-IT",
  "icon": "industry",
  "name": "med-bdm-it",
  "namespace": "misp",
  "type": "medicament",
  "uuid": "84310ba3-fa6a-44aa-b378-b9e3271c7777",
  "version": 1
}'>$galaxiedir/$jsonfile
if [ $? -eq 0 ] ; then 
	if [ $check -eq 1 ] ; then 
		jq -e . $galaxiedir/$jsonfile >/dev/null 2>&1
		if [ $? -eq 0 ] ; then 
			if [ $check -eq 2 ] ; then 
				jsonschema $galaxieschema -i $galaxiedir/$jsonfile
				if [ $? -eq 0 ] ; then
					echo fichier $galaxiedir/$jsonfile genere
					rm $galaxiedir/$jsonfile.sav
				else
					echo le fichier genere n ete pas valide je remet l ancienne version
					rm $galaxiedir/$jsonfile
					mv $galaxiedir/$jsonfile.sav $galaxiedir/$jsonfile
				fi
			else
				echo fichier $galaxiedir/$jsonfile genere
				rm $galaxiedir/$jsonfile.sav
			fi
		else
			echo le fichier genere n ete pas valide je remet l ancienne version
			rm $galaxiedir/$jsonfile
			mv $galaxiedir/$jsonfile.sav $galaxiedir/$jsonfile
		fi
	else
		echo fichier $galaxiedir/$jsonfile genere
	fi
else
	echo la conversion vers $galaxiedir/$jsonfile a echoue
	exit 3
fi
