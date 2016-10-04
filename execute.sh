echo "********************************************"
echo "Gathering Data (Please be patient)"
echo "********************************************"
python code/import_webdata.py $1 $2
python code/import_fbdata.py $3

echo "********************************************"
echo "Generating report"
echo "********************************************"
Rscript -e "rmarkdown::render('code/report.rmd')"