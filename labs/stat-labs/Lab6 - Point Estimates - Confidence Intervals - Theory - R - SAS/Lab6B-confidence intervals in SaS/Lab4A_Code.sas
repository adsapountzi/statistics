/* LAB 4A:   */

*The Data;

filename amesh url 'http://www.openintro.org/stat/data/ames_sas.csv';

proc import datafile=amesh out=work.ames dbms=csv replace;
            getnames=yes;
            guessingrows=max;
run;

proc univariate data=work.ames;
     var Gr_Liv_Area;
     histogram Gr_Liv_Area;
     inset mean median std min max / pos=ne;
run;
/* ex 1
From the histogram we observe that the population distribution is centered around 1,500 
and is considerably right-skewed.
 */


*The Unknown Sampling Distribution;

/* ex2  */
proc surveyselect data=work.ames out=work.amessample sampsize=50
     method=srs ranuni;
run;

proc print data=amessample;
run;


proc univariate data=amessample;
     var Gr_Liv_Area;
     histogram Gr_Liv_Area;
     inset mean median std min max / pos=ne;
run;

/*From the histogram we observe that the sample is also right-skewed.
 The distribution is centered around 1450 - 1550, Depending on which 50 homes are selected.
 */

/* ex 3 */
proc surveyselect data=work.ames out=work.amessample2 sampsize=50
     method=srs ranuni;
run;
proc surveyselect data=work.ames out=work.amessample3 sampsize=100
     method=srs ranuni;
run;
proc surveyselect data=work.ames out=work.amessample4 sampsize=1000
     method=srs ranuni;
run;

proc means data=work.amessample mean;
 var Gr_Liv_Area;
run;
proc means data=work.amessample2 mean;
     var Gr_Liv_Area;
run;
proc means data=work.amessample3 mean;
     var Gr_Liv_Area;
run;
proc means data=work.amessample4 mean;
 var Gr_Liv_Area;
run;
/*Despite the fact that the sample sizes are the same, every time we take a random sample with size = 50 , we get a different sample mean.
  So there should be a lot of variability when estimating the population mean this way and the mean of work.amessample2 is different from the mean of work.amessample.
  By observing the means we coclude that the mean of the sample is closer to the population mean as the sample size increases.
  Thus the sample with size 1000 would provide a more accurate estimate of the population mean.*/


/* ex4  */
proc surveyselect data=work.ames out=work.amessampler sampsize=50
     method=srs reps=5000 ranuni;
run;

proc means data=work.amessampler mean noprint;
     by replicate;
     var Gr_Liv_Area;
     output out=work.reprun mean=sampmean;
run;

proc univariate data=work.reprun;
     var sampmean;
     histogram sampmean;
run;

proc sql  ;
	title 'observations in work.reprun';
	select count(*)
	from work.reprun ;
run ;

/* The sampling distribution is close to normal
 and centered near 1500
 50,000 sample mean
 */

proc surveyselect data=work.ames out=work.amessampler sampsize=50
     method=srs reps=50000 ranuni;
run;

proc means data=work.amessampler mean noprint;
     by replicate;
     var Gr_Liv_Area;
     output out=work.reprun mean=sampmean;
run;

proc univariate data=work.reprun;
     var sampmean;
     histogram sampmean;
run;
/*In this case the sample distribution has a closer 
behavior to normal distribution than the 5000 sample 
means  */

/* ex 5 */
proc surveyselect data=work.ames out=work.amessampler sampsize=50
     method=srs reps=100 ranuni;
run;

proc means data=work.amessampler mean noprint;
     by replicate;
     var Gr_Liv_Area;
     output out=work.reprunsmall mean=sampmean;
run;
proc print data=work.reprunsmall; run;


*Sample Size and the Sampling Distribution;
proc univariate data=work.reprun;
     var sampmean;
     histogram sampmean;
run;

proc surveyselect data=work.ames out=work.amessampler10 sampsize=10
     method=srs reps=5000 ranuni;
run;

proc means data=work.amessampler10 mean noprint;
     by replicate;
     var Gr_Liv_Area;
     output out=work.reprun10 mean=sampmean;
run;

proc surveyselect data=work.ames out=work.amessampler100 sampsize=100
     method=srs reps=5000 ranuni;
run;

proc means data=work.amessampler100 mean noprint;
     by replicate;
     var Gr_Liv_Area;
     output out=work.reprun100 mean=sampmean;
run;

proc univariate data=work.reprun;
     title 'Sample Size = 50';
     var sampmean;
     histogram sampmean;
run;

proc univariate data=work.reprun10;
     title 'Sample Size = 10';
     var sampmean;
     histogram sampmean;
run;

proc univariate data=work.reprun100;
     title 'Sample Size = 100';
     var sampmean;
     histogram sampmean;
run;

title;

data work.allsamples;
     set work.reprun (IN=Sample1)
	     work.reprun10 (IN=Sample2)
		 work.reprun100 (IN=Sample3);

     group = 1*(Sample1) + 2*(Sample2) + 3*(Sample3);
run;

proc sgpanel data=work.allsamples;
     panelby group;
	 histogram sampmean;
run;

/* ex6
 From the histograms we observe that the spread is less as the sample size increases.The center stays the same.
 


/*on your own 1*/
proc surveyselect data=work.ames out=work.amessample sampsize=50
     method=srs ranuni;
run;

proc means data=work.amessample mean;
	 title 'best point estimate
	 of the population mean';
     var SalePrice;
run;

proc means data=work.ames mean;
	 title ' population mean';
     var SalePrice;
run;


/*on your own 2*/
proc surveyselect data=work.ames out=work.amessampler sampsize=50
     method=srs reps=5000 ranuni;
run;

proc means data=work.amessampler mean noprint;
     by replicate;
     var Gr_Liv_Area;
     output out=work.repprice mean=sampmean;
run;

proc univariate data=work.repprice;
     var sampmean;
     histogram sampmean;
run;

proc means data=work.ames mean;
	 title ' population mean';
     var SalePrice;
run;

/*on your own 3*/
proc surveyselect data=work.ames out=work.amessampler sampsize=150
     method=srs reps=5000 ranuni;
run;

proc means data=work.amessampler mean noprint;
     by replicate;
     var Gr_Liv_Area;
     output out=work.repprice150 mean=sampmean;
run;

proc univariate data=work.repprice150;
     var sampmean;
     histogram sampmean;
run;

proc means data=work.ames mean;
	 title ' sample size= 150';
     var SalePrice;
run;
/* The above distribution tends to be a normal distribution.*/

/* on your own 4
the sampling distribution  3 has  smaller spread than the sample distribution 2. Thus we prefer the distribution 3 as its estimate is closer to the true value.*/

/*on your own 5
The concepts from the textbook that are covered in this lab are sampling distribution in chapter 4  */


