🌲 ANOVA à un facteur sous SAS : hauteur d'arbres dans trois forêts

🎯 Résultats

⚠️ Données simulées. Les données du TP d'origine ne sont pas publiées. Le programme génère un jeu simulé (3 groupes de 13, 14 et 10 arbres, écart-type commun 1,85, graine 2026). Les résultats ci-dessous décrivent ce jeu simulé, pas de vraies forêts. Ils servent à montrer la démarche.

| Étape | Résultat sur le jeu simulé |
| :--- | :--- |
| **Normalité** (Shapiro-Wilk, par forêt) | Forêt 1 : p = 0.5977 ; Forêt 2 : p = 0.5063 ; Forêt 3 : p = 0.3725 (Normalité acceptée pour les 3 groupes) |
| **Égalité des variances** (Levene) | F = 1.51, p = 0.2364 (Homoscédasticité acceptée) |
| **ANOVA à un facteur** | F = 14.29, p < 0.0001 |
| **Taille d'effet** ($\eta^2$) | $R^2 = 0.46$ (0.4567) |
| **Comparaisons multiples** (Tukey-Kramer) | Différences significatives entre la Forêt 1 et la Forêt 3, et entre la Forêt 2 et la Forêt 3. Pas de différence significative entre la Forêt 1 et la Forêt 2. |

**Conclusion :** Les forêts diffèrent significativement en hauteur moyenne ($p < 0.0001$). Plus précisément, la forêt 3 se distingue des forêts 1 et 2 par des hauteurs moyennes plus faibles, avec une forte taille d'effet ($\eta^2 \approx 46\%$ de la variance expliquée).

📝 Contexte et objectif

Programme réalisé à partir d'un TP du Master 2 Mathématiques appliquées et statistiques (Université d'Orléans). Question : la hauteur moyenne des arbres diffère-t-elle entre trois forêts ?

**Démarche :**
1. Description : statistiques par groupe, boîtes à moustaches, histogrammes.
2. Hypothèses de l'ANOVA : normalité (Shapiro-Wilk) et égalité des variances (tests F deux à deux écrits à la main, contrôlés par PROC TTEST, puis test de Levene).
3. ANOVA à un facteur avec PROC GLM, ANOVA de Welch, comparaisons multiples (Tukey-Kramer, Bonferroni), intervalles de confiance, $\eta^2$.
4. Vérification : table d'ANOVA recalculée à la main (macro `%anova_resume`, utilisable aussi à partir de statistiques résumées), qui coïncide bien avec PROC GLM.

🛠️ Outils
- **SAS :** PROC MEANS, PROC UNIVARIATE, PROC TTEST, PROC GLM, PROC SGPLOT, PROC SGPANEL, PROC SQL, macros, ODS
- **Environnement testé :** SAS Studio / SAS OnDemand for Academics

📂 Contenu du dépôt
- `analyse_anova_foret.sas` : programme final, propre et paramétré (`%let simule`, `%let fichier`, `%let alpha`).
- `exoforet__2_.sas` : brouillon d'origine, tel que rendu pour le TP, non corrigé.

📎 **À propos du brouillon `exoforet__2_.sas`.** Il est conservé pour documenter le point de départ du travail. Il n'a pas été relu et contient des erreurs connues, corrigées dans `analyse_anova_foret.sas` :
- le test d'égalité des variances « F2 vs F3 » réutilise des tables d'un bloc précédent et reteste en réalité F1 contre F2 ;
- la comparaison multiple de Bonferroni est lancée avec `alpha=0.5` au lieu de `0.05` ;
- l'histogramme par forêt regroupe la hauteur par elle-même (`group = heigth`) au lieu de la forêt ;
- les moyennes, effectifs et écarts-types des intervalles de confiance sont recopiés à la main ;
- les commentaires sont des notes de travail personnelles.

*Utilise `analyse_anova_foret.sas`, pas le brouillon.*

▶️ Utilisation
1. Ouvre `analyse_anova_foret.sas` dans SAS (SAS Studio, SAS OnDemand for Academics…).
2. Exécute-le tel quel : il génère les données simulées.
3. Pour utiliser tes propres données : mets `%let simule = 0;` et indique le chemin dans `%let fichier`. Le fichier doit contenir deux colonnes : la hauteur, puis le numéro de forêt (1, 2 ou 3).

⚠️ Limites et pistes d'amélioration

**Limites**
- Données simulées à partir d'une loi normale : les vérifications d'hypothèses sont satisfaites par construction et n'illustrent pas un cas réel.
- Petits échantillons (37 arbres au total) : les tests de normalité ont peu de puissance.
- Effectifs inégaux (13, 14, 10) : d'où le choix de Tukey-Kramer.
- L'indépendance des observations n'est pas vérifiable à partir des données seules.

**Pistes d'amélioration**
- Analyser des données réelles publiques (autorisation de publication obtenue).
- Ajouter une analyse de puissance, ou un test par permutations / bootstrap.
- Ajouter des covariables (modèle linéaire général) si les données le permettent.
- Étudier l'impact d'autres facteurs environnementaux (p. ex. type de sol, exposition).

**Ce que j'ai appris :** 
L'automatisation du pipeline statistique via les instructions ODS et les macros SAS permet d'éviter les erreurs de retranscription manuelle des résultats intermédiaires et garantit une rigueur reproductible de bout en bout.

---

<details>
<summary>🇬🇧 <b>English version</b></summary>

🌲 One-way ANOVA in SAS: tree heights across three forests

🎯 Results

⚠️ Simulated data. The original coursework data are not published. The program generates a simulated dataset (3 groups of 13, 14 and 10 trees, common standard deviation 1.85, seed 2026). The results below describe this simulated dataset, not real forests. They illustrate the workflow.

| Step | Result on the simulated dataset |
| :--- | :--- |
| **Normality** (Shapiro-Wilk, per forest) | Forest 1: p = 0.5977; Forest 2: p = 0.5063; Forest 3: p = 0.3725 (Normality met for all 3 groups) |
| **Equality of variances** (Levene) | F = 1.51, p = 0.2364 (Homoscedasticity accepted) |
| **One-way ANOVA** | F = 14.29, p < 0.0001 |
| **Effect size ($\eta^2$)** | $R^2 = 0.46$ (0.4567) |
| **Multiple comparisons** (Tukey-Kramer) | Significant differences between Forest 1 and Forest 3, and between Forest 2 and Forest 3. No significant difference between Forest 1 and Forest 2. |

**Conclusion:** Mean tree heights differ significantly between forests ($p < 0.0001$). Specifically, forest 3 shows lower mean heights compared to forests 1 and 2, with a strong effect size ($\eta^2 \approx 46\%$).

📝 Context and goal

Program built from a coursework exercise of the 2nd-year Master's in Applied Mathematics and Statistics (University of Orléans). Question: does mean tree height differ between three forests?

1. Description: group statistics, boxplots, histograms.
2. ANOVA assumptions: normality (Shapiro-Wilk) and equality of variances (pairwise F tests written by hand, checked against PROC TTEST, then Levene's test).
3. One-way ANOVA with PROC GLM, ANOVA de Welch, multiple comparisons (Tukey-Kramer, Bonferroni), confidence intervals, $\eta^2$.
4. Check: ANOVA table recomputed by hand (macro `%anova_resume`, also usable from summary statistics only), matching PROC GLM.

🛠️ Tools
- **SAS:** PROC MEANS, PROC UNIVARIATE, PROC TTEST, PROC GLM, PROC SGPLOT, PROC SGPANEL, PROC SQL, macros, ODS
- **Tested environment:** SAS Studio (SAS OnDemand for Academics)

📂 Repository content
- `analyse_anova_foret.sas`: final program, clean and parameterized (`%let simule`, `%let fichier`, `%let alpha`).
- `exoforet__2_.sas`: original draft, as submitted for the coursework, uncorrected.

📎 **About the draft `exoforet__2_.sas`.** It is kept to document the starting point of the work. It was not reviewed and contains known errors, fixed in `analyse_anova_foret.sas`:
- the "F2 vs F3" variance test reuses tables from a previous block and actually retests F1 against F2;
- the Bonferroni multiple comparison is run with `alpha=0.5` instead of `0.05`;
- the per-forest histogram groups height by itself (`group = heigth`) instead of by forest;
- means, sample sizes and standard deviations used for the confidence intervals are typed in by hand;
- the comments are personal working notes.

*Use `analyse_anova_foret.sas`, not the draft.*

▶️ Usage
1. Open `analyse_anova_foret.sas` in SAS.
2. Run it as is: it generates the simulated data.
3. To use your own data: set `%let simule = 0;` and give the path in `%let fichier`. The file must have two columns: height, then forest number (1, 2 or 3).

⚠️ Limitations and improvements

**Limitations**
- Data simulated from a normal distribution: assumption checks pass by construction and do not illustrate a real case.
- Small samples (37 trees in total): normality tests have low power.
- Unequal group sizes (13, 14, 10): hence Tukey-Kramer.
- Independence of observations cannot be checked from the data alone.

**Possible improvements**
- Analyze real public data (with permission to publish).
- Add a power analysis, or a permutation / bootstrap test.
- Add covariates (general linear model) if the data allow it.

**What I learned:** 
Automating the statistical pipeline via ODS outputs and SAS macros prevents manual copy-paste errors and ensures full reproducibility.

</details>
