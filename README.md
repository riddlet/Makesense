# Makesense

Code for makesense exploration.

To produce the data files that generate the presentation, you will need:

1. A dump of the sql database
2. a user name and password for connecting to the database
3. An access key for facebooks's graph api.

To obtain the latter, [go here](https://developers.facebook.com/tools/explorer) and click on the 'get token' button. The string that appears in the access token bar is your temporary access token.

To generate the data, navigate to the directory, and run:

`./execute.sh arg1 arg2 arg3`

`arg1` = your database user name 
`arg2` = your database password 
`arg3` = your facebook access token 
