import facebook
import requests
import pandas as pd
import sys

token = sys.argv[2]

graph = facebook.GraphAPI(access_token=token, 
                          version=2.2)
#make a graph object for makesense events
events = graph.get_object('MakeSenseorg', fields='events', page=True)
#retrieve all events
allevents = []
event_engagement = []
these_events = events['events']
while(True):
    try:
        for event in these_events['data']:
            allevents.append(event['id'])
            event_engagement.append(
                        graph.get_object(event['id'], 
                                         fields=['attending_count, interested_count, maybe_count, noreply_count']))
        these_events=requests.get(these_events['paging']['next']).json()
    except KeyError:
        break

df = pd.DataFrame(event_engagement)
df['contacts'] = df.attending_count + df.interested_count+df.maybe_count+df.noreply_count
df.to_csv('../data/fbdat.csv', index=False)