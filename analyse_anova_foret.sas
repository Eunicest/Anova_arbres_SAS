/*=====================================================================
  Comparaison de la hauteur d'arbres entre trois forêts
  ANOVA à un facteur, vérification des hypothèses, comparaisons multiples
  ---------------------------------------------------------------------
  Auteure  : Eunice Sitti-Mawubejro
  Contexte : TP du Master 2 Mathématiques appliquées,statistiques,
             Université d'Orléans (programme remanié pour ce dépôt)
  Données  : le fichier d'origine (foret.txt) n'est pas publié.
             Un jeu simulé de même structure est généré par défaut.
  Principe : aucune valeur n'est recopiée à la main ; tout est calculé
             à partir des données ou récupéré via ODS OUTPUT.
=====================================================================*/

options nodate nonumber;
ods graphics on;

/*---------------------------------------------------------------------
  Paramètres
---------------------------------------------------------------------*/
%let alpha   = 0.05;
%let simule  = 1;                      /* 1 = données simulées ; 0 = lire le fichier */
%let fichier = ~/modlin/foret.txt;     /* utilisé seulement si simule = 0 */


/*---------------------------------------------------------------------
  Outils (macros)
---------------------------------------------------------------------*/

/* Chargement des données : colonnes "hauteur" puis "foret" (1, 2 ou 3) */
%macro charger_donnees;
  %if &simule = 1 %then %do;
    /* Jeu simulé : 3 groupes de tailles 13, 14 et 10, écart-type commun 1,85 */
    data arbres;
      call streaminit(2026);
      length foret $1;
      do g = 1 to 3;
        n  = choosen(g, 13, 14, 10);
        mu = choosen(g, 26, 25.4, 23.1);
        foret = put(g, 1.);
        do i = 1 to n;
          hauteur = mu + 1.85 * rand('normal');
          output;
        end;
      end;
      keep foret hauteur;
    run;
  %end;
  %else %do;
    data arbres;
      infile "&fichier";
      length foret $1;
      input hauteur foret $;
    run;
  %end;
%mend charger_donnees;

/* Test F bilatéral d'égalité de deux variances (groupes f1 et f2).
   Le plus grand estimateur de variance est mis au numérateur (F >= 1). */
%macro test_f(f1, f2);
  data _f_&f1.&f2;
    merge stats_groupes(keep=foret effectif variance where=(foret="&f1")
                        rename=(effectif=n1 variance=v1))
          stats_groupes(keep=foret effectif variance where=(foret="&f2")
                        rename=(effectif=n2 variance=v2));
    length comparaison $12;
    comparaison = "F&f1 vs F&f2";
    if v1 >= v2 then do; F = v1/v2; df_num = n1 - 1; df_den = n2 - 1; end;
    else             do; F = v2/v1; df_num = n2 - 1; df_den = n1 - 1; end;
    pvalue = min(1, 2 * sdf('F', F, df_num, df_den));
    keep comparaison F df_num df_den pvalue;
  run;
%mend test_f;

/* Table d'ANOVA à un facteur calculée "à la main" à partir de statistiques
   résumées (effectif, moyenne, variance par groupe). Utile quand on ne
   dispose pas des données individuelles. */
%macro anova_resume(data=, n=effectif, moy=moy, variance=variance,
                    out=anova_manuelle);
  proc sql noprint;
    select sum(&n) format=best32.,
           sum(&n * &moy) / sum(&n) format=best32.,
           count(*) format=best32.
      into :_ntot trimmed, :_moyg trimmed, :_k trimmed
      from &data;
  quit;

  data &out;
    set &data end=fin;
    retain SSM 0 SSE 0;
    SSM + &n * (&moy - &_moyg)**2;      /* variabilité inter-groupes */
    SSE + (&n - 1) * &variance;         /* variabilité intra-groupe  */
    if fin then do;
      k = &_k;
      N_total = &_ntot;
      DFM = k - 1;
      DFE = N_total - k;
      SST = SSM + SSE;
      MSM = SSM / DFM;
      MSE = SSE / DFE;
      F = MSM / MSE;
      pvalue = sdf('F', F, DFM, DFE);   /* test unilatéral à droite */
      output;
    end;
    keep k N_total SSM SSE SST DFM DFE MSM MSE F pvalue;
  run;
%mend anova_resume;


/*---------------------------------------------------------------------
  0. Données
---------------------------------------------------------------------*/
%charger_donnees;

proc print data=arbres(obs=10);
  title "0. Aperçu des données (10 premières lignes)";
run;


/*---------------------------------------------------------------------
  1. Statistiques descriptives
---------------------------------------------------------------------*/
title "1. Statistiques descriptives par forêt";
proc means data=arbres n mean std var min max maxdec=2;
  class foret;
  var hauteur;
run;

title "1. Statistiques descriptives globales";
proc means data=arbres n mean std var min max maxdec=2;
  var hauteur;
run;

/* Statistiques par groupe, réutilisées plus bas (tests F, ANOVA manuelle) */
proc means data=arbres noprint nway;
  class foret;
  var hauteur;
  output out=stats_groupes n=effectif mean=moy var=variance;
run;

title "1. Distribution de la hauteur par forêt";
proc sgplot data=arbres;
  vbox hauteur / category=foret;
  xaxis label="Forêt";
  yaxis label="Hauteur";        /* unité à préciser selon les données */
run;

proc sgpanel data=arbres;
  panelby foret / columns=3;
  histogram hauteur;
run;


/*---------------------------------------------------------------------
  2. Hypothèses de l'ANOVA : normalité et égalité des variances
---------------------------------------------------------------------*/
title "2a. Normalité de la hauteur dans chaque forêt (Shapiro-Wilk)";
proc univariate data=arbres normal;
  class foret;
  var hauteur;
  ods select TestsForNormality;
run;

/* 2b. Tests F d'égalité des variances, deux à deux, calculés manuellement */
%test_f(1, 2);
%test_f(1, 3);
%test_f(2, 3);

data tests_variances;
  set _f_12 _f_13 _f_23;
  signif_bonferroni = (pvalue < &alpha / 3);   /* 3 comparaisons : seuil alpha/3 */
run;

title "2b. Égalité des variances, deux à deux (test F bilatéral)";
proc print data=tests_variances noobs;
run;

/* 2c. Contrôle : PROC TTEST fournit le même test (ligne "Folded F") */
title "2c. Contrôle avec PROC TTEST (forêts 1 et 2)";
proc ttest data=arbres(where=(foret in ('1','2')));
  class foret;
  var hauteur;
  ods select Equality;
run;


/*---------------------------------------------------------------------
  3. ANOVA à un facteur : hauteur = f(forêt)
     - test de Levene et ANOVA de Welch (robustes à l'hétéroscédasticité)
     - comparaisons multiples : Tukey-Kramer (effectifs inégaux) et Bonferroni
     - intervalles de confiance des moyennes (variance résiduelle commune)
---------------------------------------------------------------------*/
title "3. ANOVA à un facteur : hauteur = f(forêt)";
proc glm data=arbres plots=diagnostics;
  class foret;
  model hauteur = foret / ss3;
  means foret / hovtest=levene welch;
  means foret / tukey cldiff alpha=&alpha;
  means foret / bon clm alpha=&alpha;
  lsmeans foret / cl alpha=&alpha;
  ods output OverallANOVA=anova_glm FitStatistics=ajustement;
run;
quit;

/* Taille d'effet : pour une ANOVA à un facteur, eta² = R² du modèle */
title "3b. Qualité d'ajustement (R² = eta²) et écart-type résiduel";
proc print data=ajustement noobs;
run;


/*---------------------------------------------------------------------
  4. Vérification : table d'ANOVA recalculée à la main
     doit coïncider avec la table d'ANOVA de PROC GLM (section 3)
---------------------------------------------------------------------*/
%anova_resume(data=stats_groupes);

title "4. Table d'ANOVA calculée manuellement (à comparer à PROC GLM)";
proc print data=anova_manuelle noobs;
run;
