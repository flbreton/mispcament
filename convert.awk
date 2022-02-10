#!/usr/bin/awk

BEGIN{
	FS=":";
	print "{";
	print "  \"authors\": [";
	print "    \"Unknown\"";
	print "  ],";
	print "  \"category\": \"med-bdm-it\",";
	print "  \"description\": \"intergration de la base bdm-it\",";
	print "  \"name\": \"med-bdm-it\",";
	print "  \"source\": \"Open Sources\",";
	print "  \"type\": \"medicament\",";
	print "  \"uuid\": \"84310ba3-fa6a-44aa-b378-b9e3271c7777\",";
	print "  \"values\": [";
	first=1;
}
$1 ~ /^Code ucd/ {
	if(first==1){
		first=0;
	}else{
		printf(",\n");
	}

	print "    {";
	print "      \"meta\": {";
	sub(" ","",$2);	
	printf("        \"UCD\": \"%s\",\n",$2);
	ucd=$2;
}
$1 ~ /^Nom court/ {
	sub(" ","",$2);
	printf("        \"Nom\": \"%s\",\n",$2);
	nom=$2;
}
$1 ~ /^Labo exp/ {
	sub(" ","",$2);
	printf("        \"Labo exp\": \"%s\",\n",$2);
}
$1 ~ /^Prix ttc/ {
	sub(" ","",$2);
	printf("        \"Prix ttc\": \"%s\",\n",$2);
}
$1 ~ /^Cod atc/ {
	sub(" ","",$2);
	printf("        \"Code ATC\": \"%s\",\n",$2);
}
$1 ~ /^Classe atc/ {
	sub(" ","",$2);
	printf("        \"Classe ATC\": \"%s\",\n",$2);
	print "        \"synonyms\": [";
	printf("          \"%s\"\n",nom);
	print "        ]";
	print "	      },";
        printf("      \"uuid\": \"40aa797a-ee87-43a1-8755-04d04%s\",\n",ucd);
        printf("      \"value\": \"%s\"\n",ucd);
        printf("    }");
}
END{
	printf("\n");
	print "  ],";
	printf("  \"version\": %s\n",vers);
	print "}";
}
