filename evals url
 'http://www.openintro.org/stat/data/evals_sas.csv';
proc import datafile=evals
 out=evals
 dbms=csv
 replace;
 getnames=yes;
run;

/*EXERCISE 1*/
/*This is an observational study, because there is not a group to compare the professors who are “more attractive”.
 This makes answering the question whether beauty leads directly to the the differences in course evaluations not easy to answer, because correlation does not mean causation.
 There could be multiple factors that lead to a different evaluation score that have nothing to do with a professor’s attractiveness.
 A better question would be if there is a relationship between a professor’s attractiveness and course evaluations.*/

/*EXERCISE 2*/
proc univariate data=evals;
	var score;
	histogram score;
run;
/*The distribution of ‘score’ is skewed to the left, with the majority of the observation with score of between 4 and 5.
 This is as expected, most students will provide feeback with positive evaluation (4 or 5). */

/*EXERCISE 3*/
proc sgplot data=evals;
 vbox bty_avg / category=language;
 run;
 
/*From the boxplot we observe that even though the beauty-average medians of the two groups (professors who received an education in a school that taught in english vs non-english) are relatively similar ,non-english is a little higher, the spread of the two boxplots is different.
 Professors who received an education in a school that taught in english received beauty average scores up to 8 and as low as 2, however the non-english professors had a beauty-average of up to five and a half and down to three and a half with an outlier of approximatly three. 
 Also, the data for the non-english professors is concentred around the median.*/


/*Simple Linear Regression*/
proc sgplot data=evals;
 scatter y=score x=bty_avg;
run;

proc sql;
 select count(*) as N from evals;
quit;
/*EXERCISE 4*/

proc sgplot data=evals;
 scatter y=score x=bty_avg/ jitter;
run;
/*From the scatter plot I observe that the jitter option returns data with some noise added in, which I assume in this case means data points that overlap.
 There is much more data here than we originally assumed, giving more weight to certain points.*/

/*EXERCISE 5*/

proc reg data=evals;
model score= bty_avg ;
run;

/*EXERCISE 5 ANSWER
	Linear Model Equation: y_hat = 3.88034 + 0.06664(bty_avg)
 Thus for every count increase in bty_avg, the score increases by 0.6664.
 Though the average beauty score does appear to be a significant predictor, the model has a very low R-squared value, which implies that this model is not appropriate for the data.
 In conclusion, beauty average may not be a practically significant predictor.*/

/*EXERCISE 6*/
proc reg data=evals;
model score= bty_avg ;
run;
/* ANSWER
The conditions for least squares are:
1)residuals of model are nearly normal
2)variability of residuals is nearly constant
3)residuals are independent
4)each variable is linealy related to the outcome

The residuals are not normally distributed (left skewed).
They do not appear to have a somewhat constant spread (though more densely populated in the right end of the plot) , they are not concentrated around the zero line. 
Thus the conditions are not being met.*/

/*Multiple Linear Regression*/

proc corr data=evals plots=scatter(ellipse=none);
 var bty_avg bty_f1lower;
run;

ods select matrixplot;
proc corr data=evals plots(maxpoints=20000)=matrix(nvar=7);
 var bty_f1lower--bty_avg;
run;

proc glm data=evals;
 class gender / ref=first;
 model score=bty_avg gender / solution;
run;
quit;

/*EXERCISE 7*/
proc glm data=evals plots = all;
 class gender / ref=first;
 model score=bty_avg gender / solution;
run;
proc sgplot data=evals;
 vbox score / category=gender;
 run;
/*verify:
1) the residuals of the model are nearly normal
2) Absolute values of residuals against fitted values. (the variability of the residuals is nearly constant)
3) the residuals are independent
4) each variable is linearly related to the outcome.

1) The residuals of the model is not normal as residual values for the the higher quantiles are less than what a normal distribution would predict.
2) There some outliers although overall, most of the residual values are close to the fitted values.
3) Yes, this condition is met. The residuals based on the sequence when it was gathered shows that they were randomly gathered.Thus, there is a linear relationship between beauty average and teaching evaluation score.
*/
/*EXERCISE 8*/
/*Yes,From glm procedure results bty_avg is a significant predictor of score and adding the gender variable to has changed the parameter extimate for bty_avg (increased it from 0.06664 to 0.07416), but not significantly.
 However, the R-square is still very low for this model, so there exists a chance that, given a more significant predictor is added to the model, score may not be significant at that point.*/

/*EXERCISE 9
4) There is a is a linear relationship between gender and evaluation score. The median scores and variability for both males and females are similar in terms of evaluation scores. 
score-hat= 3.74734+0.07416×beauty_avg+0.17239×gender_male
For gender = Male, we will evaluate the equation with gender_male = 1. In case, of female gender, we will substitute a 0.
score-hat= 3.74734+0.07416×beauty_avg+0.17239
Male professor will have a evaluation score higher by 0.17239 all other things being equal.*/

/*EXERCISE 10*/
proc glm data=evals;
 class rank / ref=first;
 model score=bty_avg rank / solution;
run;
quit;
/*Since the rank variable has three variables (teaching, tenure track and tenured), there has been added another line into the regression table.
Thus, for a variable with more than 2 levels, it appears to handle it considerering them 2 different variables.*/

/*EXERCISE 11
The “number of professors” (cls_profs) as the variable to have the least assoication with the professor’s evaluation score.
*/

proc glm data=evals;
 class rank ethnicity gender language cls_level cls_profs
 cls_credits pic_outfit pic_color / ref=first;
 model score=rank ethnicity gender language age cls_perc_eval
 cls_students cls_level cls_profs cls_credits bty_avg
 pic_outfit pic_color / solution;
run;
quit;

/*EXERCISE 12
The cls_profs variable (number of professors teaching sections in course in sample: single, multiple) was the one that had the highest p-value = 0.7781, meaning it was the variable with the least association with score in relation to the other variables.
*/

/*EXERCISE 13
From observing the table provided by the glm procedure the ethnicity_not_minority variable increases the score by 0.123492921 when all other variables are held constant.
*/

/*EXERCISE 14
              ===>remove cls_profs from model<====*/
proc glm data=evals;
 class rank ethnicity gender language cls_level
 cls_credits pic_outfit pic_color / ref=first;
 model score=rank ethnicity gender language age cls_perc_eval
 cls_students cls_level  cls_credits bty_avg
 pic_outfit pic_color / solution;
run;
quit;
/*The coefficients and significance changed slightly. Since the values changed, the drop variable was slightly collinear with the other explanatory variables.*/

/*EXERCISE 15*/
proc glm data=evals;
 class  ethnicity gender language 
 cls_credits  pic_color / ref=first;
 model score= ethnicity gender language age cls_perc_eval
    cls_credits bty_avg pic_color / solution;
run;
quit;

/*EXERCISE 16*/
proc glm data=evals plots=all;
 class  ethnicity gender language 
 cls_credits  pic_color / ref=first;
 model score= ethnicity gender language age cls_perc_eval
    cls_credits bty_avg pic_color / solution;
run;
quit;
proc sgplot data=evals;
 vbox score / category=language;
 run;

proc sgplot data=evals;
 vbox score / category=ethnicity;
 run;
 
proc sgplot data=evals;
 vbox score / category=gender;
 run;
 
proc sgplot data=evals;
 vbox score / category=cls_credits;
 run;
 
proc sgplot data=evals;
 vbox score / category=pic_color;
 run;
/*Verify that the conditions for this model are reasonable using diagnostic plots.
1) the residuals of the model are nearly normalThe residuals of the model is not normal as residual values for the the higher and lower quantiles are less than what a normal distribution would predict
2) Absolute values of residuals against fitted values. (the variability of the residuals is nearly constant)
3) the residuals are independent
4) each variable is linearly related to the outcome.
answers:
1)The residuals of the model is not normal as residual values for the the higher and lower quantiles are less than what a normal distribution would predict.
2)There some outliers but most of the residual values are close to the fitted values.
3)Yes the residuals show that they were randomly gathered.
4)The variables are linearly related to the score, some more than others.*/


/*EXERCISE 17
No, because class courses are independent of each other so evaluation scores from one course is indpendent of the other even if the course is being taught by the same professor.*/

/*EXERCISE 18
The professor is not a minority and male, must have graduated from school where they speak English and teaches a one credit course.
He most likely has a high beauty average score from the students and the professor’s class photo should be in black and white.
He must also be relatively young. And a good percentage of his class must have completed the evaluation.*/

/*EXERCISE 19
No because the sample size = 6 is way too small so we can not to generalize those conclusions for all of the professors.
Another reason is that some of the predictor variables are biased and may vary with culture. Beauty is subjective.*/
