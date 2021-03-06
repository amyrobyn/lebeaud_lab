
setwd("C:/Users/amykr/Box Sync/Amy Krystosik's Files/melisa shah")
# temp climate -----------------------------------------------------------------
#Usually, incubation periods vary depending on the species of Plasmodium causing malaria. The average incubation period is 9-14 days for Plasmodium falciparum, 12-17 days for infections by Plasmodium vivax and 18-40 days for infections caused by Plasmodium malariae[1].
GapFilled_Daily_T_Coast<-read.csv("C:/Users/amykr/Box Sync/Amy Krystosik's Files/melisa shah/climate/GapFilled_Daily_T_Coast.csv")
temp.coast<-GapFilled_Daily_T_Coast[,c("Date","meanTemp.UK","meanTemp.MS")]
GapFilled_Daily_T_West<-read.csv("C:/Users/amykr/Box Sync/Amy Krystosik's Files/melisa shah/climate/GapFilled_Daily_T_West.csv")
temp.west<-GapFilled_Daily_T_West[,c("Date","meanTemp.CH","meanTemp.KI")]
temp<-merge(temp.west, temp.coast, by="Date")
temp$Date<-as.Date(temp$Date)
plot(temp$Date, round(temp$meanTemp.CH), exclude=NULL)
plot(temp$Date, round(temp$meanTemp.MS), exclude=NULL)
plot(temp$Date, round(temp$meanTemp.UK), exclude=NULL)
plot(temp$Date, round(temp$meanTemp.KI), exclude=NULL)
temp.long<-reshape(temp, varying=c("meanTemp.CH","meanTemp.KI","meanTemp.MS", "meanTemp.UK"), direction="long", idvar="Date", sep=".",timevar ="site")
colnames(temp.long)[1] <- "date_collected"
temp.long$date_collected <- as.Date(temp.long$date_collected, "%Y-%m-%d")
temp.long <- within (temp.long, site[temp.long$site=="UK"] <-"Ukunda")
temp.long <- within (temp.long, site[temp.long$site=="MS"] <-"Msambweni")
temp.long <- within (temp.long, site[temp.long$site=="KI"] <-"Kisumu")
temp.long <- within (temp.long, site[temp.long$site=="CH"] <-"Chulaimbo")
plot(temp.long$date_collected, round(temp.long$meanTemp), exclude=NULL)


# import climate data from redcap -----------------------------------------
library(redcapAPI)
library(REDCapR)
setwd("C:/Users/amykr/Box Sync/Amy Krystosik's Files/vector")
Redcap.token <- readLines("api.key.txt") # Read API token from folder
REDcap.URL  <- 'https://redcap.stanford.edu/api/'
rcon <- redcapConnection(url=REDcap.URL, token=Redcap.token)
climate <- redcap_read(redcap_uri  = REDcap.URL, token = Redcap.token, batch_size = 100)$data#export data from redcap to R 
#save backup from today
currentDate <- Sys.Date() 
FileName <- paste("vector_climate",currentDate,".rda",sep=" ") 
save(climate,file=FileName)

# or 2. load saved climate -----------------------------------------------------------------
currentDate <- Sys.Date() 
FileName <- paste("vector_climate",currentDate,".rda",sep=" ") 
#load most recent backup
#  load(FileName)
#or 3. import from redcap export  -----------------------------------------------------------------
climate<-  read.csv("C:/Users/amykr/Box Sync/Amy Krystosik's Files/melisa shah/climate/20180411111858_pid11751_MeJzB3.csv")
# rain climate -----------------------------------------------------------------
library(zoo)
library(lubridate)
climate$month_collected <- as.yearmon(climate$date_collected)
table(climate$month_collected)
climate$date_collected<-as.Date(climate$date_collected)
climate$date_collected<-ymd(climate$date_collected)
class(climate$date_collected)  

ch.hosp.clim<-subset(climate, redcap_event_name=="chulaimbo_hospital_arm_1")
ch.vill.clim<-subset(climate, redcap_event_name=="chulaimbo_village_arm_1")
ch.clim<-merge(ch.hosp.clim, ch.vill.clim, by=c("date_collected"), all=T)
ch.clim$daily_rainfall <- round(rowMeans(ch.clim[,c("daily_rainfall.x", "daily_rainfall.y")], na.rm=TRUE), 1)
chulaimbo.clim <- ch.clim[,c("date_collected", "daily_rainfall", "redcap_event_name.x")]
colnames(chulaimbo.clim)[3] <- "redcap_event_name"
chulaimbo.clim$redcap_event_name<-as.character(chulaimbo.clim$redcap_event_name)
table(chulaimbo.clim$redcap_event_name)
climate<-climate[which(climate$redcap_event_name=="ukunda_arm_1"|climate$redcap_event_name=="obama_arm_1"|climate$redcap_event_name=="msambweni_arm_1"),]
library(plyr)
climate<-rbind.fill(climate,chulaimbo.clim)
climate$site<-NA
climate <- within (climate, site[climate$redcap_event_name=="chulaimbo_hospital_arm_1"] <-"Chulaimbo")
climate <- within (climate, site[climate$redcap_event_name=="ukunda_arm_1"] <-"Ukunda")
climate <- within (climate, site[climate$redcap_event_name=="obama_arm_1"] <-"Kisumu")
climate <- within (climate, site[climate$redcap_event_name=="msambweni_arm_1"] <-"Msambweni")
climate <-climate[!sapply(climate, function (x) all(is.na(x) ))]
time.min <-as.Date(as.character("2013/01/01"))
time.max <-as.Date(as.character("2018/01/31"))

all.dates<-seq(as.Date('2013/01/01'), as.Date('2018/01/31'), by = 'day')
all.dates.frame <- data.frame(list(date_collected=all.dates))

climate.m<-climate[which(climate$site=="Msambweni"),]
climate.m <- merge(all.dates.frame, climate.m, all.x=T, by=c("date_collected"))
climate.k<-climate[which(climate$site=="Kisumu"),]
climate.k <- merge(all.dates.frame, climate.k, all.x=T, by=c("date_collected"))
climate.u<-climate[which(climate$site=="Ukunda"),]
climate.u <- merge(all.dates.frame, climate.u, all.x=T, by=c("date_collected"))
climate.c<-climate[which(climate$site=="Chulaimbo"),]
climate.c <- merge(all.dates.frame, climate.c, all.x=T, by=c("date_collected"))
climate<-rbind(climate.c,climate.k,climate.m,climate.u)
rain<-climate[,c("date_collected","daily_rainfall","rainfall_hobo","site","daily_rainfall_long_term_mean")]
table(climate$site)

plot(rain$date_collected, round(rain$daily_rainfall), exclude=NULL)
temp.long <- merge(all.dates.frame, temp.long, all.x=T, by=c("date_collected"))
climate<-merge(rain, temp.long, by = c("date_collected", "site") )



# make rolling means and sums over time -----------------------------------
library(dplyr)
climate = climate %>%
  group_by(site) %>%
  arrange(site, date_collected) %>%
  mutate(
  temp_mean_30 = rollmean(x = meanTemp, 30, align = "right", fill = NA),
  rainfall_sum_30 = rollsum(x = daily_rainfall, 30, align = "right", fill = NA)
  )


# lagged time series -------------------------------------------------------------
library(xts)
dates<-as.Date(climate$date_collected)
data<-climate[c("temp_mean_30","rainfall_sum_30","site","date_collected")]
table(xts$site)
xts<-xts(x=data, order.by=dates)
xts$rainfall_sum_30.7 <- lag(xts$rainfall_sum_30,k=-7)
xts$rainfall_sum_30.14 <- lag(xts$rainfall_sum_30,k=-14)
xts$rainfall_sum_30.21 <- lag(xts$rainfall_sum_30,k=-21)
xts$rainfall_sum_30.28 <- lag(xts$rainfall_sum_30,k=-28)

xts$temp_mean_30.7 <- lag(xts$temp_mean_30,k=-7)
xts$temp_mean_30.14 <- lag(xts$temp_mean_30,k=-14)
xts$temp_mean_30.21 <- lag(xts$temp_mean_30,k=-21)
xts$temp_mean_30.28 <- lag(xts$temp_mean_30,k=-28)

View(xts)
plot(xts[,c("temp_mean_30")])
xts.monthly<-to.monthly(xts)

ep2 <- endpoints(xts.monthly,on="months") 
xts.monthly.means<-period.apply(xts.monthly,INDEX=ep2,FUN=mean)
plot(xts.monthly.means[,c("xts.Low","xts.High")])
xts.monthly.mean<-period.apply(xts.monthly,INDEX=ep2,FUN=function(x) mean(x))
plot(xts.monthly.means)

test<-apply.monthly(xts,mean)
plot(test[,"result_microscopy_malaria_kenya_A"])
test<-lag.xts(xts[,"temp_mean_30"],7)
climate<-as.data.frame(xts)
# plot rolling means and sums over time -----------------------------------
library(ggplot2)
ggplot (climate, aes (x = date_collected, y = temp_mean_30, colour = site)) +geom_line(linetype = "solid",size=2) +scale_x_date(date_breaks = "2 months", date_labels =  "%b %Y") +theme(axis.text.x=element_text(angle=60, hjust=1),legend.position="none",text = element_text(size = 20)) + facet_grid(site ~ .)+xlab("Month-Year") + ylab("Average Temperature (C) in last 30 days") 
ggplot (climate, aes (x = date_collected, y = rainfall_sum_30, colour = site)) +geom_line(linetype = "solid",size=2) +scale_x_date(date_breaks = "2 months", date_labels =  "%b %Y") +theme(axis.text.x=element_text(angle=60, hjust=1),legend.position="none",text = element_text(size = 20)) + facet_grid(site ~ .)+xlab("Month-Year") + ylab("Cummulative Precipitation (mm) in last 30 days") 

# malaria climate merge-----------------------------------------------------------------
aicmalaria <- readRDS("C:/Users/amykr/Box Sync/Amy Krystosik's Files/melisa shah/aicmalaria.rds")
aicmalaria <- aicmalaria[ , grepl("person_id|redcap_event|id_site|interview_date_aic_A|result_microscopy_malaria_kenya_A|aic_calculated_age_A|agecat_A|temp_A|roof_type_A|latrine_type_A|floor_type_A|drinking_water_source_A|number_windows_A|gender_aic_A|fever_contact_A|mosquito_bites_aic_A|mosquito_net_aic_A|telephone|radio|television|bicycle|motor_vehicle|domestic_worker|report" , names(aicmalaria) ) ]
aicmalaria$interview_date_aic_A<-as.Date(aicmalaria$interview_date_aic_A)
class(aicmalaria$interview_date_aic_A)
class(climate$date_collected)
table(aicmalaria$id_site_A)
table(climate$site)

malaria_climate<-merge(aicmalaria, climate, by.x = c("interview_date_aic_A","id_site_A"), by.y = c("date_collected","site"), all.x = T) 

malaria_climate$temp_mean_30.7<-as.numeric(malaria_climate$temp_mean_30.7)
class(malaria_climate$temp_mean_30.7)

hist(malaria_climate$temp_mean_30.7)

table(round(malaria_climate$temp_mean_30), malaria_climate$id_site_A, exclude = NULL)
table(round(malaria_climate$rainfall_sum_30), malaria_climate$id_site_A, exclude = NULL)

malaria_climate <-malaria_climate[ , !grepl("$_D|$_C|$_B|$_F|$_G|$_H" , names(malaria_climate) ) ]
malaria_climate<-malaria_climate[order((grepl('date', names(malaria_climate)))+1L)]
# ses ---------------------------------------------------------------------
ses<-(malaria_climate[, grepl("telephone|radio|television|bicycle|motor_vehicle|domestic_worker", names(malaria_climate))])
malaria_climate$ses_sum<-rowSums(malaria_climate[, c("telephone_A","radio_A","television_A","bicycle_A","motor_vehicle_A", "domestic_worker_A")], na.rm = TRUE)
table(malaria_climate$ses_sum)

#subset by site -----------------------------------------------------------------
table(malaria_climate$id_site_A, exclude=NULL)
malaria_climate_u<-malaria_climate[which(malaria_climate$id_site_A=="Ukunda"),]
malaria_climate_m<-malaria_climate[which(malaria_climate$id_site_A=="Msambweni"),]
malaria_climate_c<-malaria_climate[which(malaria_climate$id_site_A=="Chulaimbo"),]
malaria_climate_k<-malaria_climate[which(malaria_climate$id_site_A=="Kisumu"),]

# table one ---------------------------------------------------------------
library(tableone)
vars<-c("ses_sum","rainfall_sum_30","temp_mean_30","aic_calculated_age_A",  "temp_A", "roof_type_A", "latrine_type_A", "floor_type_A", "drinking_water_source_A", "number_windows_A", "gender_aic_A", "fever_contact_A", "mosquito_bites_aic_A", "mosquito_net_aic_A")
factorVars<-c("roof_type_A", "latrine_type_A", "floor_type_A", "drinking_water_source_A", "gender_aic_A", "fever_contact_A", "mosquito_bites_aic_A", "mosquito_net_aic_A")

tableOne_mal_c <- CreateTableOne(vars = vars, factorVars = factorVars, strata = "result_microscopy_malaria_kenya_A", data = malaria_climate_c)
tableOne_mal_k <- CreateTableOne(vars = vars, factorVars = factorVars, strata = "result_microscopy_malaria_kenya_A", data = malaria_climate_k)
tableOne_mal_m <- CreateTableOne(vars = vars, factorVars = factorVars, strata = "result_microscopy_malaria_kenya_A", data = malaria_climate_m)
tableOne_mal_u <- CreateTableOne(vars = vars, factorVars = factorVars, strata = "result_microscopy_malaria_kenya_A", data = malaria_climate_u)

tableOne_site <- CreateTableOne(vars = vars, factorVars = factorVars, strata = "id_site_A", data = malaria_climate)

# non-linear temperature option 1. splines -------------------------------------------------------
#install.packages("splines")
library("splines")
malaria_climate$id_site_A<-as.factor(malaria_climate$id_site_A)
malaria_climate$drinking_water_source_A<-as.factor(malaria_climate$drinking_water_source_A)
malaria_climate$gender_aic_A<-as.factor(malaria_climate$gender_aic_A)
malaria_climate$fever_contact_A<-as.factor(malaria_climate$fever_contact_A)
malaria_climate$mosquito_net_aic_A<-as.factor(malaria_climate$mosquito_net_aic_A)

hist(climate$temp_mean_30)
class(malaria_climate$id_site_A)
malaria_climate$agecat_A<-as.factor(malaria_climate$agecat_A)
malaria_climate$reportcough_A<-as.factor(malaria_climate$reportcough_A)
malaria_climate$reportdiarrhea_A<-as.factor(malaria_climate$reportdiarrhea_A)
malaria_climate$reportjoint_A<-as.factor(malaria_climate$reportjoint_A)
malaria_climate$reportnv_A<-as.factor(malaria_climate$reportnv_A)
malaria_climate$id_site_A<-as.factor(malaria_climate$id_site_A)

bs(malaria_climate$temp_mean_30, df = 3)
bs(malaria_climate$rainfall_sum_30, df = 4)

# correlation  ------------------------------------------------------------
corrvars<-c("result_microscopy_malaria_kenya_A","temp_mean_30", "rainfall_sum_30", "agecat_A" ,  "fever_contact_A",  "mosquito_bites_aic_A" ,"id_site_A", "gender_aic_A","ses_sum")
my_cols <- c("#00AFBB", "#E7B800")  
pairs(na.omit(malaria_climate[corrvars]), pch = 19,  cex = 0.5, col = my_cols[aicmalaria$result_microscopy_malaria_kenya_A], lower.panel=NULL)
cor(na.omit(malaria_climate[vars]))

# random intercept for site -----------------------------------------------------------------
library(lmerTest)
library(lme4)
summary(spline.malaria.random <- lmer(result_microscopy_malaria_kenya_A ~ bs(temp_mean_30, df = 3) + bs(rainfall_sum_30, df = 4) + agecat_A +   fever_contact_A + mosquito_bites_aic_A +  (1|id_site_A)+gender_aic_A + ses_sum, data = malaria_climate))
anova(spline.malaria.random)
exp(confint(spline.malaria.random, method="boot", parallel="multicore", ncpus=4))
exp(cbind(OR = coef(spline.malaria.random), confint(spline.malaria.random)))

# all sites -----------------------------------------------------------------
summary(spline.malaria <- lm(result_microscopy_malaria_kenya_A ~ bs(temp_mean_30, df = 3) + bs(rainfall_sum_30, df = 4) + agecat_A +  fever_contact_A + mosquito_bites_aic_A + id_site_A + gender_aic_A +ses_sum, data = malaria_climate))
exp(cbind(OR = coef(spline.malaria), confint(spline.malaria)))
anova(spline.malaria)

table(round(malaria_climate$rainfall_sum_30))
range(malaria_climate$temp_mean_30)
range(malaria_climate$rainfall_sum_30)

plot(effects::Effect(focal.predictors = c("rainfall_sum_30"), mod = spline.malaria, xlevels = list(rainfall_sum_30 = 1:384)), rug = FALSE, main="Precipitation Effect on Malaria Transmission" ,ylab="Probablity of Plasmodium Positive Microscopy", xlab="Cummulative Precipitation (mm) in last 30 days")
plot(effects::Effect(focal.predictors = c("temp_mean_30"), mod = spline.malaria, xlevels = list(temp_mean_30 = 22.6:31.02)), rug = FALSE, main="Temperature Effect on Malaria Transmission" ,ylab="Probablity of Plasmodium Positive Microscopy", xlab="Average Temperature (C) in last 30 days")

# by site -----------------------------------------------------------------
table(round(malaria_climate_c$rainfall_sum_30))
range(malaria_climate_c$temp_mean_30)
range(malaria_climate_c$rainfall_sum_30)
summary(spline.malaria.c <- lm(result_microscopy_malaria_kenya_A ~ bs(temp_mean_30, df = 3) + bs(rainfall_sum_30, df = 4) + agecat_A +   fever_contact_A + mosquito_bites_aic_A  + gender_aic_A + ses_sum, data = malaria_climate_c))
anova(spline.malaria.c)
exp(cbind(OR = coef(spline.malaria.c), confint(spline.malaria.c)))
plot(effects::Effect(focal.predictors = c("rainfall_sum_30"), mod = spline.malaria, xlevels = list(rainfall_sum_30 = 16:371)), rug = FALSE, sub="Chulaimbo", main="Precipitation Effect on Malaria Transmission" ,ylab="Probablity of Plasmodium Positive Microscopy", xlab="Cummulative Precipitation (mm) in last 30 days")
plot(effects::Effect(focal.predictors = c("temp_mean_30"), mod = spline.malaria, xlevels = list(temp_mean_30 = 22.52:26.45)), rug = FALSE, sub="Chulaimbo",main="Temperature Effect on Malaria Transmission" ,ylab="Probablity of Plasmodium Positive Microscopy", xlab="Average Temperature (C) in last 30 days")

table(round(malaria_climate_k$rainfall_sum_30))
range(malaria_climate_k$temp_mean_30)
range(malaria_climate_k$rainfall_sum_30)
summary(spline.malaria.k <- lm(result_microscopy_malaria_kenya_A ~ bs(temp_mean_30, df = 3) + bs(rainfall_sum_30, df = 4) + agecat_A + fever_contact_A + mosquito_bites_aic_A +  gender_aic_A + ses_sum, data = malaria_climate_k))
exp(cbind(OR = coef(spline.malaria.k), confint(spline.malaria.k)))
anova(spline.malaria.k)
plot(effects::Effect(focal.predictors = c("rainfall_sum_30"), mod = spline.malaria, xlevels = list(rainfall_sum_30 = 16:367)), rug = FALSE, sub="Kisumu", main="Precipitation Effect on Malaria Transmission" ,ylab="Probablity of Plasmodium Positive Microscopy", xlab="Cummulative Precipitation (mm) in last 30 days")
plot(effects::Effect(focal.predictors = c("temp_mean_30"), mod = spline.malaria, xlevels = list(temp_mean_30 = 24.08:28.15)), rug = FALSE, sub="Kisumu", main="Temperature Effect on Malaria Transmission" ,ylab="Probablity of Plasmodium Positive Microscopy", xlab="Average Temperature (C) in last 30 days")

table(round(malaria_climate_m$rainfall_sum_30))
range(malaria_climate_m$temp_mean_30)
range(malaria_climate_m$rainfall_sum_30)
summary(spline.malaria.m <- lm(result_microscopy_malaria_kenya_A ~ bs(temp_mean_30, df = 3) + bs(rainfall_sum_30, df = 4) + agecat_A + fever_contact_A + mosquito_bites_aic_A +  gender_aic_A +ses_sum , data = malaria_climate_m))
exp(cbind(OR = coef(spline.malaria.m), confint(spline.malaria.m)))
anova(spline.malaria.m)
plot(effects::Effect(focal.predictors = c("rainfall_sum_30"), mod = spline.malaria, xlevels = list(rainfall_sum_30 = 1:384)), rug = FALSE, sub="Msambweni",main="Precipitation Effect on Malaria Transmission" ,ylab="Probablity of Plasmodium Positive Microscopy", xlab="Cummulative Precipitation (mm) in last 30 days")
plot(effects::Effect(focal.predictors = c("temp_mean_30"), mod = spline.malaria, xlevels = list(temp_mean_30 = 24.93:31.02)), rug = FALSE, sub="Msambweni", main="Temperature Effect on Malaria Transmission" ,ylab="Probablity of Plasmodium Positive Microscopy", xlab="Average Temperature (C) in last 30 days")

table(round(malaria_climate_u$rainfall_sum_30))
range(malaria_climate_u$temp_mean_30)
range(malaria_climate_u$rainfall_sum_30)
summary(spline.malaria.u <- lm(result_microscopy_malaria_kenya_A ~ bs(temp_mean_30, df = 3) + bs(rainfall_sum_30, df = 4) +agecat_A + fever_contact_A + mosquito_bites_aic_A +  gender_aic_A + ses_sum, data = malaria_climate_u))
exp(cbind(OR = coef(spline.malaria.u), confint(spline.malaria.u)))
anova(spline.malaria.u)
library("lattice")
trellis.device() 
trellis.par.set(list(axis.text = list(cex = 2), 
                     par.ylab.text = list(cex = 1.5), 
                     par.xlab.text = list(cex = 1.5),
                     par.main.text = list(cex = 1.5),
                     par.sub.text = list(cex = 1.5)
)) 
plot(effects::Effect(focal.predictors = c("rainfall_sum_30"), mod = spline.malaria, xlevels = list(rainfall_sum_30 = 1:306)), rug = FALSE, main="Precipitation Effect on Malaria Transmission",sub="Ukunda",ylab="Probablity of Plasmodium Positive Microscopy", xlab="Cummulative Precipitation (mm) in last 30 days")

plot(effects::Effect(focal.predictors = c("temp_mean_30"), mod = spline.malaria, xlevels = list(temp_mean_30 = 25.15:30.15)), rug = FALSE, main="Temperature Effect on Malaria Transmission", sub="Ukunda",ylab="Probablity of Plasmodium Positive Microscopy", xlab="Average Temperature (C) in last 30 days")

# save merged dataset.  ---------------------------------------------------
saveRDS(malaria_climate, file="malaria_climate.rds")

library(zoo)
uktest1$month <- as.yearmon(uktest1$date)
library(dplyr)
ts.uktest<-uktest1 %>%group_by(month) %>%summarize(monthly_malaria = mean(microA, na.rm = TRUE))
plot(ts.uktest$month,ts.uktest$monthly_malaria)

ts.uktest = ts(ts.uktest$monthly_malaria, start = c(2014,1), end=c(2018, 1), frequency = 12)
plot(ts.uktest) 

components.ts=decompose(ts.uktest)
plot(components.ts)
