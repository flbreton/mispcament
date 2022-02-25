/\ _French project base on national medical reference_

# mispcament
L'objectif du projet est de proposer une source d'information structurée sur les médicaments en s'appuyant sur des sources publiques en accès libre.<BR>
La source utilisée est la base de médicament fournie par la __CPAM__ dans le cadre de la rétrocession de médicament par les établissements de santé :<BR>
http://www.codage.ext.cnamts.fr/codif/bdm_it/index_tele_ucd.php

avantage :<BR>
- elle contient les tarifs des médicaments

inconvenient : <BR>
- elle utilise les __UCD__ comme __ID__ pour les médicaments alors que cette information n'apparait pas sur la boite<BR>
- elle ne liste que les médicaments autorisés à la restrocession

[Notice expliquant la strucuture du fichier](http://www.codage.ext.cnamts.fr/f_mediam/fo/bdm_it/lisez_moi.pdf)

# Utilisation
Le script est a lancer depuis la __VM__ hébergeant __MISP__<BR>
Les constantes en début de script peuvent être corrigées si jamais les dossiers __Json__ ne sont pas localisés aux emplacements standards<BR>

  
## Remarques:<BR>
Le script utilise __dbview__ pour lire le __dbf__<BR>
Afin d'assurer la continuité de l'__UID__, les 7 derniers caractères sont composés avec l'__UCD__<BR>
La version de la base est mise à jour hebdomadairement, c'est pourquoi le script utilise cette information pour la version du cluster<BR>
Le script va récupérer la base sur le site d'amelie et créer les deux __json__ pour __MISP__ <BR>

## Base alternative :<BR>
- Thesorimed : base à priorie gratuite de médicament, reste à voir si elle est libre de téléchargement<BR>
- [Base de donnée publique des médicaments](https://base-donnees-publique.medicaments.gouv.fr/telechargement.php) :<BR>
-- mais pas d'information tarifaire<BR>
-- elle utilise comme __ID__ le __CIS__ et le __CIP__ mais ne contient pas l'__UCD__ qui sert de pivot dans la base de médicament "_*bdm_it*_"<BR>
-- [description du modele de donnée](https://base-donnees-publique.medicaments.gouv.fr/docs/Contenu_et_format_des_fichiers_telechargeables_dans_la_BDM_v1.pdf)

