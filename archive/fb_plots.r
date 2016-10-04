library(ggplot2)
library(splitstackshape)
library(dplyr)
library(broom)
library(magrittr)
library(lme4)
library(package))

df <- read.csv('fbdat.csv')
df <- arrange(df, id)

df.disagg <- df %>%
  group_by(id) %>%
  do(action=c(rep('attending', .$attending_count),
              rep('interested', .$interested_count),
              rep('maybe', .$maybe_count),
              rep('no_reply', .$noreply_count))) %>%
  tidy(action) %>%
  ungroup() %>%
  left_join(df[,c('id', 'start_time')])

names(df.disagg)[2] <- 'action'

df.disagg %<>%
  mutate(attending=action=='attending',
         interested=action=='interested',
         maybe=action=='maybe',
         no_reply=action=='no_reply')
df.disagg %<>%
  group_by(id) %>%
  mutate(no_reply_prop = sum(no_reply)/length(no_reply),
         attending_prop = sum(attending)/length(attending),
         interested_prop = sum(interested)/length(interested),
         maybe_prob = sum(maybe)/length(maybe),
         n_obs = length(no_reply))

df$date_bin <- floor_date(as_date(df$start_time), unit='month')
df %<>%
  group_by(date_bin) %>%
  mutate(n_events = length(contacts))

df.past <- df[which(as_date(df$start_time)<today()),]

#number of events over time
ggplot(df.past, aes(date_bin, n_events)) + geom_line()

#size of events over time
m <- lm(log(contacts)~as_date(start_time), data=df.past)

ggplot(df.past, aes(x=as_date(start_time), y=log(contacts))) + 
  stat_smooth(method='lm') + geom_point() + 
  stat_smooth()#+
  #geom_line(data=df, aes(x=as_date(start_time), y=log(preds))) +
  #geom_ribbon(data=df, aes(x=as_date(start_time), ymax=se_upper, ymin=se_lower),
   #           alpha=.25)

##attending over time
m <- lm(log(attending_count+.01)~as_date(start_time), data=df.past)

ggplot(df.past, aes(x=as_date(start_time), y=log(attending_count))) + 
  stat_smooth(method='lm') + geom_point() +
  stat_smooth()

##interested over time
m <- lm(log(interested_count+.01)~as_date(start_time), data=df.past)

ggplot(df.past, aes(x=as_date(start_time), y=log(interested_count))) + 
  stat_smooth(method='lm') + geom_point() +
  stat_smooth()

##noreply over time
m <- lm(log(noreply_count+.01)~as_date(start_time), data=df)

ggplot(df, aes(x=as_date(start_time), y=log(noreply_count))) + 
  stat_smooth(method='lm') + geom_point() 

#glmer
#non-response
m.nonresp <- glmer(no_reply~as_date(start_time) + (1|id), data=df.disagg,
                     family='binomial')
preds <- predictSE(m.nonresp, type='response', re.form=NA, se.fit=T)
df.disagg$preds <-preds[[1]]
df.disagg$se_plus <- 

plot.dat <- df.disagg %>%
  select(id, start_time, attending_prop, n_obs, preds) %>%
  unique()

ggplot(plot.dat) + 
  geom_point(aes(x=as_date(start_time), y=attending_prop, size=n_obs),
             alpha=.5) +
  geom_line(aes(x=as_date(start_time), y=preds))
  
#attending people
m.attending <- glmer(attending~as_date(start_time) + (1|id), data=df.disagg,
                      family='binomial')
df.disagg$preds <- predict(m.attending, type='response', re.form=NA)

plot.dat <- df.disagg %>%
  select(id, start_time, attending_prop, n_obs, preds) %>%
  unique()

ggplot(plot.dat) + 
  geom_point(aes(x=as_date(start_time), y=attending_prop, size=n_obs),
             alpha=.5) +
  geom_line(aes(x=as_date(start_time), y=preds))

### interested people
m.interested <- glmer(interested~as_date(start_time) + (1|id), data=df.disagg,
                      family='binomial')
df.disagg$preds <- predict(m.interested, type='response', re.form=NA)

plot.dat <- df.disagg %>%
  select(id, start_time, interested_prop, n_obs, preds) %>%
  unique()

ggplot(plot.dat) + 
  geom_point(aes(x=as_date(start_time), y=interested_prop, size=n_obs),
             alpha=.5) +
  geom_line(aes(x=as_date(start_time), y=preds))


## no reply
m.noreply <- glmer(no_reply~as_date(start_time) + (1|id), data=df.disagg, 
                   family='binomial')
df.disagg$preds <- predict(m.noreply, type='response', re.form=NA)

plot.dat <- df.disagg %>%
  select(id, start_time, no_reply_prop, n_obs, preds) %>%
  unique()

ggplot(plot.dat) + 
  geom_point(aes(x=as_date(start_time), y=no_reply_prop, size=n_obs),
             alpha=.5) +
  geom_line(aes(x=as_date(start_time), y=preds))
