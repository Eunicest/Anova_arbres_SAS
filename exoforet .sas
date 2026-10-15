/*les données*/
DATA table;
	INFILE'~/modlin/foret.txt';
	INPUT heigth type$ ;
;
proc print;
Run;

/*stat*/
/*penser à mettre un trie c'a d un sort */
/*PROC SORT DATA= table OUT=;*/
PROC MEANS DATA = table; 
 by type;

RUN;

PROC MEANS DATA = table  N Mean Var STD; 
 by type;
RUN;

/*ce qu'il a fait pour le générale */
PROC MEANS DATA = table; 
RUN;

/*pour le model*/
PROC MEANS DATA = table N VAR Mean Std; 
RUN;
/*box plot*/

PROC SGPLOT DATA=table;
	VBOX heigth/CATEGORY=type ;
RUN;

/*faire test de l'egalité des moyenne avec ttest et f1 et f2*/

/*data pour enlever les types 3*/
DATA table2;
 set table;
 if type=3 then delete;
RUN;
proc print;
Run;

/* meme chose 
DATA table2;
 set table;
 if heigth = 1 or heigth = 2;
RUN;
proc print;
Run;*/


/*test de student pour comparer les moyenne de heigth des groupe*/
proc ttest data = table2 alpha =0.05 Sides = 2;
	var heigth;
	class type;
	run;
	
	
/*histogramme global*/
PROC SGPLOT DATA=table;
	histogram heigth ;
RUN;

/*histogramme by type*/

PROC SGPLOT DATA=table;
	by type ;
	histogram heigth / group = heigth ;
	/*transparency = 0.5;*/
RUN;

/*ce que j'ai essayé de faire*/
/*test  avec f1 et f3*/

/*data pour enlever les types 3*/
DATA table3;
 set table;
 if type=2 then delete;
RUN;
proc print;
Run;

/*le  test avec ttest*/
proc ttest data = table3 alpha =0.05 Sides = 2;
	var heigth;
	class type;
	run;

/*test avec f2 et f3*/

/*data pour enlever les types 1*/
DATA table4;
 set table;
 if type=1 then delete;
RUN;
proc print;
Run;

/*le  test avec ttest*/
proc ttest data = table4 alpha =0.05 Sides = 2;
	var heigth;
	class type;
	run;

/*test pour la var pour F1 et F2*/

/*d'abord les données*/
DATA table21;
 set table;
 if type=3 then delete;
 if type=2 then delete;
RUN;
proc print;
Run;

DATA table22;
 set table;
 if type=1 then delete;
 if type=3 then delete;
RUN;
proc print;
Run;

/*les stats*/
PROC MEANS DATA = table21 N Mean Var STD ; 
	OUTPUT OUT = StatExh N = n1 MEAN = moy1 VAR = Var1;
RUN;


PROC MEANS DATA = table22 N Mean Var STD; 
	OUTPUT OUT = StatExh2 N = n2 MEAN = moy2 VAR = Var2;
RUN;

/*le test?*/
TITLE "test d'egalite des variances";
DATA testvar;
	merge StatExh StatExh2;
	F = Var2/Var1; /* choix du rapport pour decalage a droite */
	alpha=0.05;
	Ql = QUANTILE('F', alpha/2, n2-1, n1-1); /* attention aux df numerateur et denominateur */
	Qr = QUANTILE('F', 1-alpha/2, n2-1, n1-1);
	pval = 2*(1 - PROBF(F, n2-1, n1-1));
	KEEP F Qr Ql pval;
PROC PRINT ; RUN;

/*test pour la var pour F1 et F3*/

/*d'abord les données*/
DATA table31;
 set table;
 if type=3 then delete;
 if type=2 then delete;
RUN;
proc print;
Run; /*table avce que la foret 1*/

DATA table33;
 set table;
 if type=1 then delete;
 if type=2 then delete;
RUN;
proc print;
Run;

/*les stats*/
PROC MEANS DATA = table31 N Mean Var STD ; 
	OUTPUT OUT = StatExh N = n1 MEAN = moy1 VAR = Var1;
RUN;


PROC MEANS DATA = table33 N Mean Var STD; 
	OUTPUT OUT = StatExh2 N = n2 MEAN = moy2 VAR = Var2;
RUN;

/*le test?*/
TITLE "test d'egalite des variances";
DATA testvar;
	merge StatExh StatExh2;
	F = Var2/Var1; /* choix du rapport pour decalage a droite */
	alpha=0.05;
	Ql = QUANTILE('F', alpha/2, n2-1, n1-1); /* attention aux df numerateur et denominateur */
	Qr = QUANTILE('F', 1-alpha/2, n2-1, n1-1);
	pval = 2*(1 - PROBF(F, n2-1, n1-1));
	KEEP F Qr Ql pval;
PROC PRINT ; RUN;

/*test pour la var pour F2 et F3*/

/*d'abord les données*/
DATA table42;
 set table;
 if type=3 then delete;
 if type=1 then delete;
RUN;
proc print;
Run; /*table avce que la foret 2*/

DATA table43;
 set table;
 if type=1 then delete;
 if type=2 then delete;
RUN;
proc print;
Run; /*table avce que la foret 3*/

/*les stats*/

PROC MEANS DATA = table31 N Mean Var STD; 
	OUTPUT OUT = StatExh1 N = n1 MEAN = moy1 VAR = Var1;
RUN; /*table avec foret 1*/

PROC MEANS DATA = table42 N Mean Var STD ; 
	OUTPUT OUT = StatExh2 N = n2 MEAN = moy2 VAR = Var2;
RUN; /*table avec foret 2*/


PROC MEANS DATA = table43 N Mean Var STD; 
	OUTPUT OUT = StatExh3 N = n3 MEAN = moy3 VAR = Var3;
RUN; /*table avec foret 3*/


PROC MEANS DATA = table N Mean Var STD; 
	OUTPUT OUT = StatExh4 N = n4 MEAN = moy4 VAR = Var4;
RUN; /*table avec foret global*/

/*le test?*/
TITLE "test d'egalite des variances";
DATA testvar;
	merge StatExh StatExh2;
	F = Var2/Var1; /* choix du rapport pour decalage a droite */
	alpha=0.05;
	Ql = QUANTILE('F', alpha/2, n2-1, n1-1); /* attention aux df numerateur et denominateur */
	Qr = QUANTILE('F', 1-alpha/2, n2-1, n1-1);
	pval = 2*(1 - PROBF(F, n2-1, n1-1));
	KEEP F Qr Ql pval;
PROC PRINT ; RUN;

DATA tablerec;
	merge StatExh1 StatExh2 StatExh3 StatExh4 ;
RUN;
PROC PRINT ; RUN;

/*
Cette commande va me mettre les données dans un meme tableau et les mettre une à la suite de l'autre 
*/

/*sa correction j'ai trouvé c'es ce que j'ai fait avec ttest donc ok*/

proc sort data=table out= ft; by type;

proc univariate data = ft NORMAL;
	Var heigth;
	by type;
run;
/*donne plusieur resultat , lire shapiro_wilk 
ici on ne rejette pas foret1 car 26% de se tromper en acceptant je crois mais en tt cas
on ne rejette. pas un test qui rejette à droit ça rejette vers 0
on ne rejette pas foret 2, ni foret 3*/

/*ici les hypothese ok donc on peut faire l'anova*/

title"analyse de variance a un facteur";
title2 "model: hauteur=f(foret)";
proc anova data=table;
	class type;
	model heigth=type;
run;

/*anova a la main*/
/*tu l'as fait dans ton cahier*/

DATA anovatablemain ;
	SET tablerec;
	k = 3;
	SSMmain = (n1*(moy1-moy4)**2) + (n2*(moy2-moy4)**2) + (n3*(moy3-moy4)**2) ;
	SSEMain = (n1 -1)*var1 + (n2 -1)*var2 +(n3 -1)*var3;
	SSTMain = SSEMain + SSMmain;
	DFM = k - 1;
	DFE = n4 - k;
	MSMmain = SSMmain/DFM;
	MSEmain = SSEMain /DFE;
	Fishmain = MSMmain/MSEmain;
	pvalueM =  1 - PROBF(Fishmain, DFM, DFE);
	
	KEEP  SSMmain SSEMain SSTMain DFM DFE MSMmain MSEmain Fishmain pvalueM;
RUN;	
proc print; run;

/*ic pour mu pour foret 1*/
DATA icmu; 
	alpha = 0.05; /* IC 95% */
	ng = 37;
	x1bar= 25.9692;k=3;
	rootmse = 1.851596;
	n1=13;
	qt = QUANTILE('T', 1-alpha/2, ng-k);
	ICg95 = x1bar - qt*rootmse/sqrt(n1) ;
	ICd95 = x1bar + qt*rootmse/sqrt(n1) ;
	KEEP ICg95 ICd95;
		
PROC PRINT; RUN; /* exemple d'affichage lisible */

/*ic pour mu pour foret 2*/
DATA icmu; 
	alpha = 0.05; /* IC 95% */
	ng = 37;
	x2bar= 25.38;k=3;
	rootmse = 1.851596;
	n2=14;
	qt = QUANTILE('T', 1-alpha/2, ng-k);
	ICg95 = x2bar - qt*rootmse/sqrt(n2) ;
	ICd95 = x2bar + qt*rootmse/sqrt(n2) ;
	KEEP ICg95 ICd95;
		
PROC PRINT; RUN; /* exemple d'affichage lisible */

/*ic pour mu pour foret 3*/
DATA icmu; 
	alpha = 0.05; /* IC 95% */
	ng = 37;
	x2bar= 23.13;k=3;
	rootmse = 1.851596;
	n2=10;
	qt = QUANTILE('T', 1-alpha/2, ng-k);
	ICg95 = x2bar - qt*rootmse/sqrt(n2) ;
	ICd95 = x2bar + qt*rootmse/sqrt(n2) ;
	KEEP ICg95 ICd95;
		
PROC PRINT; RUN; /* exemple d'affichage lisible */

/*ic avec anova ici il le fait avec bonferoni donc ic niveau alpha/3*/
proc anova data=table;
	class type;
	model heigth=type;
	mean type/ bon clm alpha=0.05;
run;

/*ic pour retrouver ce qu'on avait avant on met 3*alpha parce que
avant on avait erreur de chaque ic a 5% */
proc anova data=table;
	class type;
	model heigth=type;
	mean type/ bon clm alpha=0.15;
run;

/*numero 7 test d egalité des moyenne, bon il fait chaque test 2 a 2 avec niveau alpha/3*/

proc anova data=table;
	class type;
	model heigth=type;
	mean type/ bon alpha=0.5;
run;

/*anova mais ici on n'a pas les données*/
/*je rentre la stat de test ici non appariées*/

DATA regimeA;
	INPUT _TYPE_ _STAT_ $ impedance;
	CARDS;
	0 N    10
	0 MEAN 5.2
	0 VAR  7.956
	;
PROC PRINT; RUN;

/* Création directe d'une table de synthèse avec PROC MEANS */
PROC MEANS DATA=regimeA N MEAN VAR MAXDEC=2 STACKODSOUTPUT;
    VAR impedance;
    OUTPUT OUT=tablerecapA(drop=_TYPE_ _FREQ_) 
           N=N MEAN=moyA VAR=varA / AUTONAME;
RUN;

PROC PRINT DATA=tablerecapA; 
RUN;

DATA regimeA;
    INPUT _TYPE_ _STAT_ $ impedance;
    CARDS;
    0 N    10
    0 MEAN 5.2
    0 VAR  7.956
    ;
RUN;


DATA regimeB;
	INPUT _TYPE_ _STAT_ $ impedance;
	CARDS;
	0 N    10
	0 MEAN 5.0
	0 VAR  11.99
	;
PROC PRINT; RUN;

DATA regimec;
	INPUT _TYPE_ _STAT_ $ impedance;
	CARDS;
	0 N    10
	0 MEAN 6.7
	0 VAR  11.79
	;
PROC PRINT; RUN;

DATA tablerecapA ;
    SET regimeA END=fin; /*fin vaut 1 à la derniere observation*/
    RETAIN N moyA varA; /*garde les valeurs calculée d'une ligne à l'autre*/
    if _STAT_ = 'MEAN' then moyA = impedance;
    if _STAT_ = 'N' then N = impedance;
    if _STAT_ = 'VAR' then VarA = impedance;
    /*keep N moyA varA;*/
    if fin;
    DROP _TYPE_ _STAT_ impedance fin;
   
RUN;

PROC PRINT; RUN;



DATA tablerecapb;
    SET regimeB END=fin;
    RETAIN N moyb varb;
    if _STAT_ = 'MEAN' then moyb = impedance;
    if _STAT_ = 'N' then N = impedance;
    if _STAT_ = 'VAR' then Varb = impedance;
    keep N moyb varb;
    if fin;
    DROP _TYPE_ _STAT_ impedance fin;
RUN;

PROC PRINT; RUN;

DATA tablerecapc;
    SET regimec END=fin;
    RETAIN N moyc varc;
    if _STAT_ = 'MEAN' then moyc = impedance;
    if _STAT_ = 'N' then N = impedance;
    if _STAT_ = 'VAR' then Varc = impedance;
    keep N moyc varc;
    if fin;
    DROP _TYPE_ _STAT_ impedance fin;
RUN;

PROC PRINT; RUN;


/*le test?*/
TITLE "test d'egalite des variances";
DATA testvar;
	merge tablerecapA tablerecapb;
	F = Varb/VarA; /* choix du rapport pour decalage a droite */
	alpha=0.05;
	Ql = QUANTILE('F', alpha/2, N-1, N-1); /* attention aux df numerateur et denominateur */
	Qr = QUANTILE('F', 1-alpha/2, N-1, N-1);
	pval = 2*(1 - PROBF(F, N-1, N-1));
	KEEP F Qr Ql pval;
RUN;
PROC PRINT ; RUN;

/*ma table d'anova*/

/*xpoinpoin*/
DATA regimegene;
	INPUT regime xbar var n ;
	CARDS;
	1 5.2  7.956  10
	2 5.0  11.99   10
	3 6.7  11.79  10 
	;
run;
PROC PRINT; RUN;
proc means; run;

/*table avec les stats*/

DATA testvar1;
	merge tablerecapA tablerecapb tablerecapc;
RUN;

PROC PRINT; RUN;

/*table avec les stats*/

DATA testvar2;
	merge tablerecapA tablerecapb tablerecapc;
	n = 3*n;
	keep moyA moyb moyc n ;
RUN;

PROC PRINT; RUN;

/*table d'anova main pour cette partie*/
DATA anovatablemain1 ;
	SET testvar1 ;
	k = 3;
	moy4 = 5.6333333;
	moy1 = moyA ;
	moy2 = moyb  ;
	moy3 = moyc ;
	var1 = varA;
	var2 = varb;
	var3 = varc;
	SSMmain = (n*(moy1-moy4)**2) + (n*(moy2-moy4)**2) + (n*(moy3-moy4)**2) ;
	SSEMain = (n -1)*var1 + (n -1)*var2 +(n -1)*var3;
	SSTMain = SSEMain + SSMmain;
	DFM = k - 1;
	DFE = (n+n+n) - k;
	MSMmain = SSMmain/DFM;
	MSEmain = SSEMain /DFE;
	Fishmain = MSMmain/MSEmain;
	pvalueM = ( 1 - PROBF(Fishmain, DFM, DFE)); /*ici ce n'est pasbilateral*/
	
	KEEP  SSMmain SSEMain SSTMain DFM DFE MSMmain MSEmain Fishmain pvalueM;
RUN;	
proc print; run;


/* 2eme facon */
DATA regimegene;
	INPUT regime xbar var n ;
	CARDS;
	1 5.2  7.956  10
	2 5.0  11.99   10
	3 6.7  11.79  10 
	;
run;
PROC PRINT; RUN;

/*pour xpoinpoint*/

PROC means; RUN;

/*ma table d'anova*/

DATA anovatablemain ;
	SET regimegene ;
	k = 3;
	moy4 = 5.6333333;
	moy1 = 5.2 ;
	moy2 = 5.0  ;
	moy3 = 6.7 ;
	var1 = 7.956;
	var2 = 11.99;
	var3 = 11.79;
	SSMmain = (n*(moy1-moy4)**2) + (n*(moy2-moy4)**2) + (n*(moy3-moy4)**2) ;
	SSEMain = (n -1)*var1 + (n -1)*var2 +(n -1)*var3;
	SSTMain = SSEMain + SSMmain;
	DFM = k - 1;
	DFE = (n+n+n) - k;
	MSMmain = SSMmain/DFM;
	MSEmain = SSEMain /DFE;
	Fishmain = MSMmain/MSEmain;
	pvalueM = ( 1 - PROBF(Fishmain, DFM, DFE)); /*ici ce n'est pasbilateral*/
	
	KEEP  SSMmain SSEMain SSTMain DFM DFE MSMmain MSEmain Fishmain pvalueM;
RUN;	
proc print; run;

/*table d'anova automatique*/

/* Calcul de la moyenne générale */
PROC MEANS DATA=regimegene MEAN;
    VAR xbar;
    OUTPUT OUT=moyennegenerale MEAN=moy4;
RUN;


/* Table d'ANOVA */

DATA anovatablemain2 ;
    SET regimegene;
    IF _N_ = 1 THEN SET moyennegenerale; /* Récupère la moyenne générale */
    
    k = 3;
    SSMmain = SUM( (n*(xbar - moy4)**2) );
    SSEMain = SUM( (n - 1)*var );
    SSTMain = SSMmain + SSEMain;
    DFM = k - 1;
    DFE = SUM(n) - k;
    MSMmain = SSMmain/DFM;
    MSEmain = SSEMain /DFE;
    Fishmain = MSMmain/MSEmain;
    pvalueM = ( 1 - PROBF(Fishmain, DFM, DFE));

    KEEP  SSMmain SSEMain SSTMain DFM DFE MSMmain MSEmain Fishmain pvalueM;
RUN;    
proc print data=anovatablemain2; run;

/*la table d'anova automatique ne marche pas inh*/

/*essai*/

DATA prepa2 ;
	merge testvar1 moyennegenerale ;
	drop _TYPE_ ;
	drop _FREQ_	;
run;
proc print; run;

DATA anovatablemain3 ;
	set prepa2 ;
	k = 3;
	moy1 = moyA ;
	moy2 = moyb  ;
	moy3 = moyc ;
	var1 = varA;
	var2 = varb;
	var3 = varc;
	SSMmain = sum((n*(moy1-moy4)**2), (n*(moy2-moy4)**2), (n*(moy3-moy4)**2)) ;
	SSEMain = sum((n -1)*var1 , (n -1)*var2 ,(n -1)*var3);
	SSTMain = sum (SSEMain , SSMmain);
	DFM = k - 1;
	DFE = sum(n,n,n) - k;
	MSMmain = SSMmain/DFM;
	MSEmain = SSEMain /DFE;
	Fishmain = MSMmain/MSEmain;
	pvalueM = ( 1 - PROBF(Fishmain, DFM, DFE)); /*ici ce n'est pasbilateral*/
	
	KEEP  SSMmain SSEMain SSTMain DFM DFE MSMmain MSEmain Fishmain pvalueM;
RUN;	
proc print; run;