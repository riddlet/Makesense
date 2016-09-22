import psycopg2
import pandas as pd
import numpy as np
import sys

user = sys.argv[1]
pw = sys.argv[2]

try:
    conn = psycopg2.connect("dbname='makesense' user={0} host='localhost' password={1}".format(user, pw)) 
except:
    print "I am unable to connect to the database"

cur = conn.cursor()

sql = """Select * FROM events_participants"""
cur.execute(sql)
colnames = [desc[0] for desc in cur.description]
df_event_participants = pd.DataFrame(cur.fetchall(), columns=colnames)
df_event_participants.to_csv('../data/event_participants.csv', index=False)

sql = """Select * FROM events"""
cur.execute(sql)
colnames = [desc[0] for desc in cur.description]
df_events = pd.DataFrame(cur.fetchall(), columns=colnames)
df_events.to_csv('../data/events.csv', index=False)

sql = """Select * FROM users"""
cur.execute(sql)
colnames = [desc[0] for desc in cur.description]
df_users = pd.DataFrame(cur.fetchall(), columns=colnames)
df_users.to_csv('../data/users.csv', index=False)