#!/bin/bash
# Move to the Behat test project folder
cd $HOME

# Remove previous Allure results
rm -rf allure-results

#Install the necessary npm packages
#npm install

#Install the necessary npm packages
composer install

# X11 for Ubuntu is not configured! The following configurations are needed for XVFB.
# Make a new display :21 with virtual screen 0 with resolution 1024x768 24dpi
Xvfb :10 -screen 0 1920x1080x24 2>&1 >/dev/null &

# Export the previously created display
export DISPLAY=:10.0

# Start the selenium server
echo "Starting webdriver"
webdriver-manager start >/dev/null 2>&1 &
# give it some time to start
sleep 2
echo "Finished starting webdriver"

echo "Running Behat tests"
cd tests
../vendor/bin/behat

# The 'uluwatu-e2e-protractor' test project launch configuration file (e2e.conf.js) should be passed here.
#DISPLAY=:10 protractor $@
export RESULT=$?

#echo "Behat tests have done"
# Close the XVFB display
killall Xvfb
# Remove temporary folders
rm -rf .config .local .pki .cache .dbus .gconf .mozilla
# Set the file access permissions (read, write and access) recursively for the result folders
chmod -Rf 777 allure-results test-results

exit $RESULT
