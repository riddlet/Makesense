library(dplyr)
library(lubridate)

df.events <- read.csv('data/events.csv')
df.event_parts <- read.csv('data/event_participants.csv')

names(df.event_parts)[1] <- 'id'
df.events %<>%
  select(id, from) %>%
  right_join(df.event_parts) %>%
  arrange(from)

plot.dat <- df.events %>%
  group_by(id) %>%
  mutate(participants = length(user_id)) %>%
  distinct()

plot.dat$date_bin <- floor_date(as_date(plot.dat$from), unit='week')
plot.dat %<>%
  group_by(date_bin) %>%
  mutate(n_events = length(date_bin))
plot.dat <- plot.dat[plot.dat$date_bin<today(),]

### number of events
ggplot(plot.dat, aes(x=date_bin, y=n_events)) + geom_line() + 
  ylab('Number of Events per week')

### number of participants

