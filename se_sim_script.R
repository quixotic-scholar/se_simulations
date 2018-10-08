# Setup -------------------------------------------------------------------

library("rstan")
library("rstanarm")
library("arm")
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)


# Simulate data structure-------------------------------------------------
J <-26 # number of people in experiment
Obs_per_pearson <- 8 # number of measurements per person
person_id<- rep(1:J, rep(Obs_per_pearson, J)) # assign person id for each measurement
exp_index<- rep(1:Obs_per_pearson, J) # assign number based on obs timing
timing<- exp_index -1 # time of measurements, from 0 to 9
N<- length(person_id) # number total measurements (360)
a<- rnorm(J, 75, 8) # simulate intercept of measures, centered at 0
b<- rnorm(J, 2, 4) # simulate individual slope of growth w/o treatment
theta<- 2 # increase in slope effect of treatment
sigma_y <- 3 # standard deviation of participant slopes

# Simulate between person outcomes----------------------------------------
z <- sample(rep(c(0,1), J/2), J) # assign persons to treatments (26)
y_pred<- a[person_id] - exp(b[person_id]*timing) + theta*z[person_id]*timing #simulate all measurement outcomes based on treatment assignment & timing 
y <- rnorm(N, y_pred, sigma_y) # add variability to simulated measurements 
z_full <- z[person_id] # treatment assignment for all measurements (720)
exposure <- z_full*timing # how much treatment 'dosage'-- e.g., treatment(0/1) * timing
data_1 <- data.frame(timing, person_id, exposure, y, z_full)