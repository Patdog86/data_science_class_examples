## reference -- http://www.ats.ucla.edu/stat/r/dae/logit.htm
install.packages('aod')
library(aod)
library(ggplot2)

## About this data and data set
# This is data of students attempting to get into graduate school.
# We know if they were admitted(0, 1), their gre score, gpa, and the rank of their undergraduate school.
# How do we look at each of these features to predict if a student will get into graduate school
# or not?
x <- read.csv("http://www.ats.ucla.edu/stat/data/binary.csv")
xtabs(~admit + rank, data=x)
lin.fit <- lm(admit ~ ., data=x)
lin.fit2 <- lm(admit ~ 0 + ., data=x)
summary(lin.fit2)
x$rank <- factor(x$rank)
logit.fit <- glm(admit ~ ., family='binomial', data=x)
summary(logit.fit)

# deviance resids -> measure of model fit (like resids in linear model)
# coeffs -> chg in log-odds of the output variable for unit increase in the input variable

# coeffs of indicator (dummy) vars are slightly different...for example, the coeff of rank2 represents the change in the log-odds of the output variable that comes going to a rank2 school instead of a rank1 school

# odds ratios can be found by exponentiating the log-odds ratios
exp(coef(logit.fit))

# predict oos data

# have a look at mean gre, gpa
summary(x)

# note: important to give columns the same names as in the original df
new.data <- with(x, data.frame(gre=mean(gre), gpa=mean(gpa), rank=factor(1:4)))

# predict probs for new data (varying rank)
new.data$rank.prob <- predict(logit.fit, newdata=new.data, type='response')
new.data

# predict probs for new data (varying gre)
new.data2 <- with(x, data.frame(gre=rep(seq(from=200, to=800, length.out=100), 4), gpa=mean(gpa), rank=factor(rep(1:4, each=100))))
new.data2$pred <- predict(logit.fit, newdata=new.data2, type='response')
ggplot(new.data2, aes(x=gre, y=pred)) + geom_line(aes(colour=rank), size=1)

# predict probs for new data (varying gpa)
new.data3 <- with(x, data.frame(gpa=rep(seq(from=0, to=4.0, length.out=100), 4), gre=mean(gre), rank=factor(rep(1:4, each=100))))
new.data3$pred <- predict(logit.fit, newdata=new.data3, type='response')
ggplot(new.data3, aes(x=gpa, y=pred)) + geom_line(aes(colour=rank), size=1)