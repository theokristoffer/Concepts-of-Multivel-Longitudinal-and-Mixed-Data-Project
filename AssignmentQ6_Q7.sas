data adl;
    set '/home/u64047898/Concepts of Multilevel, Longitudinal and Mixed Models/adl.sas7bdat'; 
    lntime = log(time);
run;


/* QUESTION 6 */
/* * Find good dichotomization point * */
proc means data=adl N MEDIAN;
	var ADL;
run;

data adl_dich;
    set adl;
    if ADL <= 17 then ADL_Group = 1; 
    else ADL_Group = 0;
run;

proc freq data=adl_dich;
    tables ADL_Group /nopercent nocum;
run;

/*********************************************************************/
/*********************************************************************/

/* QUESTION 7 */

/* * Only neuro and time as predictors * */
/* Only random intercept */
proc glimmix data=adl_dich;
	class id neuro;
	model ADL_Group (event='1') =  neuro lntime neuro*lntime / dist=binary solution;
	random intercept / subject=id;
	store out=GLMM;
run;

/* Plot */
proc plm restore=GLMM;
    effectplot slicefit(x=lntime sliceby=neuro) / clm;  
run;

/* Random intercept and slope */
proc glimmix data=adl_dich;
	class id neuro;
	model ADL_Group (event='1') =  neuro lntime neuro*lntime / dist=binary solution;
	random intercept lntime / subject=id type=un g gcorr;
	nloptions maxiter=1000;
	store out=GLMM; 
run; 

/* Plot */
proc plm restore=GLMM;
    effectplot slicefit(x=lntime sliceby=neuro) / clm;  
run;

/*  */
/* Random intercept and slope without correlation between intercept and slope */
proc glimmix data=adl_dich;
	class id neuro;
	model ADL_Group (event='1') =  neuro lntime neuro*lntime / dist=binary solution;
	random intercept lntime / subject=id type=vc g gcorr; /* type=vc sets covariance of slope and intercept to 0
	store out=GLMM; */
run; 

/* Plot */
proc plm restore=GLMM;
    effectplot slicefit(x=lntime sliceby=neuro) / clm;  
run;


/************************************************************************/


/* * All predictors * */
/* Only random intercept */
proc glimmix data=adl_dich;
	class id neuro;
	model ADL_Group (event='1') = lntime neuro housing age lntime*neuro lntime*housing lntime*age / dist=binary solution;
	random intercept / subject=id;
	store out=GLMM;
run;

/* Random intercept and slope */
proc glimmix data=adl_dich;
	class id neuro;
	model ADL_Group (event='1') =  lntime neuro housing age lntime*neuro lntime*housing lntime*age / dist=binary solution;
	random intercept lntime / subject=id type=un g gcorr;
	nloptions maxiter=1000;
	store out=GLMM; 
run; 

/*  */
/* Random intercept and slope without correlation between intercept and slope */
proc glimmix data=adl_dich;
	class id neuro;
	model ADL_Group (event='1') =  lntime neuro housing age lntime*neuro lntime*housing lntime*age / dist=binary solution;
	random intercept lntime / subject=id type=vc g gcorr; /* type=vc sets covariance of slope and intercept to 0
	store out=GLMM; */
run; 