# STUDENTS
perl -F'\|' -lane '

# SKIP STUDENTS AT NON-ELIGIBLE SCHOOLS
	if ($F[18] =~ m/^(72211|73422|74562|75585|76613)$/) { next; }
# ASSIGN NON-DELIVERY BORROWER TYPE TO ONLINE-ONLY STUDENT PATRONS
	elsif ($F[18] =~ m/^(70142)$/) { $F[1] = 37; }
# SET BORROWER TYPE FOR LIMITLESS LIBRARIES OPT-OUT STUDENTS
	elsif ($F[30] =~ m/^N$/) {
		if ($F[1] =~ m/^(25|26)$/) { $F[1] = 35; }
		elsif ($F[1] =~ m/^(27|28|29|30)$/) { $F[1] = 36; }
		elsif ($F[1] =~ m/^(31|32|33|34)$/) { $F[1] = 37; }
	} 
# SET STATUS = GOOD; SHOULD NOT OVERWRITE CARL.X STATUS
	$F[20] = "G";
# NORMALIZE DATE VALUE FOR EXPIRATION
#	if ($F[23] =~ /(\d{2})\/(\d{2})\/(\d{4})/) { $F[23] =~ s/(\d{2})\/(\d{2})\/(\d{4})/$3-$1-$2/; }
# CHANGE DATE VALUE FOR EXPIRATION TO 2018-08-04
	$F[23] = "2018-08-04";

# FORMAT AS CSV
	foreach (@F) {
		$_ =~ s/[\n\r]+//g;
		$_ =~ s/^\s+//;
		$_ =~ s/\s+$//;
		if ($_ =~ /,/) {$_ = q/"/ . $_ . q/"/;}
	}
# REPLACE PIPE DELIMITERS WITH COMMAS
	print join q/,/, @F' ../data/CARLX_INFINITECAMPUS_STUDENT.txt > ../data/INFINITECAMPUS_STUDENT.txt;
# REPLACE HEADERS
perl -pi -e '$_ = qq/"Patron ID","Borrower type code","Patron last name","Patron first name","Patron middle name","Patron suffix","Primary Street Address","Primary City","Primary State","Primary Zip Code","Secondary Street Address","Secondary City","Secondary State","Secondary Zip Code","Primary Phone Number","Secondary Phone Number","Alternate ID","Non-validated Stats","Default Branch","Validated Stat Codes","Status Code","Registration Date","Last Action Date","Expiration Date","Email Address","Notes","Birth Date","Guardian","Racial or Ethnic Category","Lap Top Check Out","Limitless Library Use","Tech Opt Out","Teacher ID","Teacher Name"\n/ if ( $. == 1 )' ../data/INFINITECAMPUS_STUDENT.txt

# STAFF
perl -F'\|' -lane '

# ADD EMPTY VALUES TO MATCH PATRON LOADER FORMAT
	@filler = ("","","","","","","","","","","","");
	splice @F, 6, 0, @filler;
	@filler = ("","","","","");
	splice @F, 19, 0, @filler;
	@filler = ("","","","","","","","","");
	splice @F, 25, 0, @filler;

# REMOVE SPECTRUM EMPLOYEES - I.E., REMOVE ALL NON-6-DIGIT EMPLOYEE IDS
	if ($F[0] !~ m/^\d{6}$/) { next; }

# SCHOOL LIBRARIANS
# TO DO : make ad hoc report!
# select patronid from patron_v where bty = 40 and length(patronid) = 6 order by patronid;

	@schoolLibrarians = (107639,
		107673,
		117357,
		117678,
		149236,
		158315,
		180288,
		180700,
		181674,
		181686,
		181877,
		182270,
		182657,
		183083,
		183231,
		183827,
		184333,
		184458,
		186766,
		186784,
		190415,
		194118,
		205539,
		212114,
		212116,
		212519,
		214387,
		214389,
		216035,
		217257,
		229481,
		239006,
		239018,
		249616,
		250861,
		252590,
		254102,
		256088,
		256102,
		256313,
		260418,
		270661,
		271653,
		277662,
		281514,
		295873,
		297353,
		298041,
		299388,
		302051,
		302102,
		304079,
		344182,
		373248,
		373278,
		406230,
		408024,
		424446,
		430045,
		430357,
		430548,
		433782,
		437613,
		440140,
		445552,
		447445,
		448122,
		448500,
		450594,
		451199,
		451311,
		452917,
		453980,
		455993,
		457584,
		462342,
		469861,
		472555,
		497215,
		497769,
		497835,
		497886,
		497902,
		497998,
		498013,
		498118,
		498192,
		498304,
		498344,
		498431,
		498496,
		498691,
		498735,
		498889,
		498916,
		500736,
		500747,
		500767,
		501036,
		501059,
		501088,
		501120,
		501128,
		501160,
		501197,
		501221,
		501222,
		501318,
		501336,
		501367,
		501446,
		501591,
		501628,
		501664,
		501818,
		501872,
		501899,
		501912,
		501925,
		502054,
		502192,
		502292,
		502471,
		502589,
		502599,
		502612,
		502677,
		502693,
		502839,
		502864,
		502925,
		503015,
		503112,
		503175,
		503254,
		503334,
		503370,
		503472,
		503568,
		503685,
		503783,
		503876,
		503879,
		503909,
		504046,
		504069,
		504070,
		504154,
		504208,
		504359,
		505248,
		505871,
		506076,
		511225,
		512790,
		516640,
		516785,
		518365,
		532613,
		534681,
		535599,
		536259,
		548113,
		550713,
		551389,
		584696,
		586227,
		590815,
		590945,
		599982,
		620966,
		626846,
		643552,
		646960,
		647724,
		660595,
		661495,
		662805,
		703954,
		704480,
		708687,
		717412,
		719546,
		725412,
		751272,
		751915,
		760136,
		777809,
		784242,
		787384,
		840791,
		840858,
		842149,
		849652,
		850676,
		861034,
		865739,
		866487);

	if (grep(/^$F[0]$/,@schoolLibrarians)) {$F[1]=40;}

# SET STATUS = GOOD; SHOULD NOT OVERWRITE CARL.X STATUS
	$F[20] = "G";

# CHANGE DATE VALUE FOR EXPIRATION TO 2018-08-04
	$F[23] = "2018-08-04";

# REMOVE STAFF RECORDS ASSOCIATED WITH usd475.org EMAIL
	if ($F[24] =~ m/usd475\.org/) { next; }

# NORMALIZE ALL DATE VALUES

# FORMAT AS CSV
	foreach (@F) {
		$_ =~ s/[\n\r]+//g;
		$_ =~ s/^\s+//;
		$_ =~ s/\s+$//;
		if ($_ =~ /,/) {$_ = q/"/ . $_ . q/"/;}
	}
# REPLACE PIPE DELIMITERS WITH COMMAS
	print join q/,/, @F' ../data/CARLX_INFINITECAMPUS_STAFF.txt > ../data/INFINITECAMPUS_STAFF.txt;
# REPLACE HEADERS
perl -pi -e '$_ = qq/"Patron ID","Borrower type code","Patron last name","Patron first name","Patron middle name","Patron suffix","Primary Street Address","Primary City","Primary State","Primary Zip Code","Secondary Street Address","Secondary City","Secondary State","Secondary Zip Code","Primary Phone Number","Secondary Phone Number","Alternate ID","Non-validated Stats","Default Branch","Validated Stat Codes","Status Code","Registration Date","Last Action Date","Expiration Date","Email Address","Notes","Birth Date","Guardian","Racial or Ethnic Category","Lap Top Check Out","Limitless Library Use","Tech Opt Out","Teacher ID","Teacher Name"\n/ if ( $. == 1 )' ../data/INFINITECAMPUS_STAFF.txt

# CONCATENATE STUDENT AND STAFF FILES
#cat ../data/INFINITECAMPUS_STUDENT.txt ../data/INFINITECAMPUS_STAFF.txt > ../data/INFINITECAMPUS.txt
