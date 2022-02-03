# mispcament
L'objectif du projet et de proposer une source d'information structurée sur les médicament en s'appuyant sur des sources public en accès libre.<BR>
La source utilisé est la base de médicament fournie par la CPAM dans le cadre de la rétrocession de médicament par les établissement de santé :<BR>
http://www.codage.ext.cnamts.fr/codif/bdm_it/index_tele_ucd.php

avantage :<BR>
- elle contient les tarif des médicament

inconvenient : <BR>
- elle utilise les UCD comme id pour les médicament alors que cette une information qui n'apparait pas sur la boite<BR>
- elle ne liste que les médicament autorisé à la restrocession

[Notice expliquant la strucuture du fichier](http://www.codage.ext.cnamts.fr/f_mediam/fo/bdm_it/lisez_moi.pdf)

## premier convertisseur avec awk sous la forme :<BR>
dbview ucd_total_XXXXX.dbf | awk -f convert.awk > ucd_total_XXXXX.json <BR>
Afin d'assurer la continuité de l'uid nous mettant l'UCD dans les 7 dernier caractère <BR>
NB : a réécrire en python

## Base alternative :<BR>
- Thesorimed : base à priorie gratuite de médicament reste à voir si elle est libre de téléchargement<BR>
- [Base de données publique des médicaments](https://base-donnees-publique.medicaments.gouv.fr/telechargement.php) :<BR>
-- mais pas d'information tarifaire<BR>
-- elle utilise comme id les CIS et le CIP mais ne contient pas l'UCD se qui pose un problème pour pivoter avec le la bdm_it<BR>
-- [description du modele de donnée](https://base-donnees-publique.medicaments.gouv.fr/docs/Contenu_et_format_des_fichiers_telechargeables_dans_la_BDM_v1.pdf)

