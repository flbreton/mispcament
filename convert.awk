#!/usr/bin/awk

BEGIN{
	FS=":";
	print "{";
	print "  \"authors\": [";
	print "    \"mispcament\"";
	print "  ],";
	print "  \"category\": \"med-bdm-it\",";
	print "  \"description\": \"intergration de la base bdm-it\",";
	print "  \"name\": \"med-bdm-it\",";
	print "  \"source\": \"ameli.fr/CNAM\",";
	print "  \"type\": \"medicament\",";
	print "  \"uuid\": \"84310ba3-fa6a-44aa-b378-b9e3271c7777\",";
	print "  \"values\": [";
	first=1;
}
{
	# stucuture de debut
	if(first==1){
		first=0;
	}else{
		printf(",\n");
	}

	print "    {";
	print "      \"meta\": {";
	# champ UCD : 1
	printf("        \"UCD\": \"%s\",\n",$1);
	# champ Nom : 2
	printf("        \"Nom\": \"%s\",\n",$2);
	# champ labo : 3
	printf("        \"Labo exp\": \"%s\",\n",$3);
	# champ prix : 4
	printf("        \"Prix ttc\": \"%s\",\n",$4);
	# champ code atc : 5
	printf("        \"Code ATC\": \"%s\",\n",$6);
	# champ classe atc : 6
	printf("        \"Classe ATC\": \"%s\",\n",$5);
	# struture de fin
	print "        \"synonyms\": [";
	printf("          \"%s\"\n",$2);
	print "        ]";
	print "	      },";
        printf("      \"uuid\": \"40aa797a-ee87-43a1-8755-04d04%s\",\n",$1);
        printf("      \"value\": \"%s\"\n",$1);
        printf("    }");
}
END{
	printf("\n");
	print "  ],";
	printf("  \"version\": %s\n",vers);
	print "}";
}
