/* LAB 4B:   */

filename amesh url 'http://www.openintro.org/stat/data/ames_sas.csv';

proc import datafile=amesh out=work.ames dbms=csv replace;
   getnames=yes;
   guessingrows=max;
run;

proc surveyselect data=work.ames out=work.amessample sampsize=60
                  method=srs ranuni;
run;

data work.amessample;
   set work.amessample;
   keep Gr_Liv_Area;
run;

//Exercise 1: 

/*Answer 2:*/
  Another student’s distribution will be different. The probability is that other student’s sample distribution is not expected to be similar to ours,because of a relative small sample size. The sample size is 60 out of over 2000 cases. Rarely the distribution may be similar.
  
proc means data=work.amessample mean;
   var Gr_Liv_Area;
run;

proc means data=work.amessample mean clm alpha=0.05;
   var Gr_Liv_Area;
run;
  
/*Answer 3:*/
  The sample consists of at least 30 independent observations and the data are not strongly skewed.

/*Answer 4:*/
 95% confidence means that if we  repeat the sampling a lot times, 95% of the confidence intervals we will get would contain the true population mean.The confidence interval level for the normal model with standard error SE. The confidence interval for the population parameter is pointestimate±z⋅SE where z corresponds to the confidence level selected.

proc means data=work.ames mean;
   var Gr_Liv_Area;
run;

proc sql;
   select AVG(Gr_Liv_Area) into :popmean FROM work.ames;
run;

/*Answer 5:*/
Yes, the 95% confidence interval captures the true average size of houses in Ames.

/*Answer 6:*/
95% of the students will capture the true population mean in the confidence interval.This happens because by defintion (see Answer 4) the computation for the confidence interval will capture the true population mean 95% of the time - values that are +/- 1.96 times away from the standard error.

proc surveyselect data=work.ames out=work.amessampler sampsize=60
                  method=srs reps=50 ranuni;
run;

proc means data=work.amessampler mean clm alpha=0.05 noprint;
   by replicate;
   var Gr_Liv_Area;
   output out=work.reprun mean=s_mean lclm=s_lower uclm=s_upper;
run;

proc print data=work.reprun;
   var s_mean s_lower s_upper;
run;

/*   on  your own 1  */
data work.reprun;
	set work.reprun;
	captured = (s_lower le &popmean le s_upper);
run;

proc means data=work.reprun mean;
   var captured;
run;
