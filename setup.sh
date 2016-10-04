echo "********************************************"
echo "Installing Python dependencies"
echo "********************************************"
cat code/dependencies.txt | while read PACKAGE
	do pip install "$PACKAGE" 
done

echo "********************************************"
echo "Installing R dependencies"
echo "********************************************"
sudo R CMD INSTALL bin/dplyr_0.5.0.tar.gz
sudo R CMD INSTALL bin/ggplot2_2.1.0.tar.gz
sudo R CMD INSTALL bin/knitr_1.14.tar.gz
sudo R CMD INSTALL bin/lubridate_1.6.0.tar.gz