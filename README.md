# Makesense

Code for MakeSense exploration.

First, this report was built using the Anaconda 4.0 distribution of Python 2.7.12 and R version 3.3.1. To run this code, you will need to have Python and R installed on your machine.

In addition, you will need to run the setup script before anything else can be done. This script installs the needed dependencies on your machine. To run this script, navigate to the head directory and run `./setup.sh`.

To produce the data files and generate the report, you will need:

1. A dump of the sql database (stored in the `data` directory)
2. a user name and password for connecting to the database
3. An access key for facebooks's graph api.

To obtain the latter, [go here](https://developers.facebook.com/tools/explorer) and click on the 'get token' button. The string that appears in the access token bar is your temporary access token.

To generate the data, navigate to the directory, and run:

`./execute.sh arg1 arg2 arg3`

`arg1` = your database user name 
`arg2` = your database password 
`arg3` = your facebook access token 
