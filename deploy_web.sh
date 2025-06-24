#!/bin/bash

set -e

PACKAGE="httpd wget unzip"
SVC="httpd"
URL="https://www.tooplate.com/zip-templates/2098_health.zip"
ART_NAME="2098_health"
TEMPDIR="/tmp/webfiles"
WEBROOT="/var/www/html"

check_success() {
    if [ $? -ne 0 ]; then
        echo "ERROR: $1 failed."
        exit 1
    fi
}


echo "########################################"
echo "Installing required packages..."
echo "########################################"
sudo yum install -y $PACKAGE > /dev/null
check_success "Package installation"
echo "Packages installed successfully."
echo

echo "########################################"
echo "Starting & enabling HTTPD service..."
echo "########################################"
sudo systemctl start $SVC
sudo systemctl enable $SVC
check_success "HTTPD service start/enable"
echo "Service $SVC is running and enabled."
echo

echo "########################################"
echo "Setting up deployment environment..."
echo "########################################"
mkdir -p $TEMPDIR
cd $TEMPDIR
echo "Temporary directory ready at $TEMPDIR."
echo

echo "########################################"
echo "Downloading and extracting website files..."
echo "########################################"
wget -q $URL
check_success "Downloading website template"

unzip -q ${ART_NAME}.zip
check_success "Unzipping artifact"

if [ -d "$WEBROOT" ]; then
    BACKUP_DIR="${WEBROOT}_bak_$(date +%F-%H%M%S)"
    sudo mv $WEBROOT $BACKUP_DIR
    echo "Backup of existing web files created at: $BACKUP_DIR"
fi

sudo mkdir -p $WEBROOT
sudo cp -r $ART_NAME/* $WEBROOT/
check_success "Copying website files"
echo "Website deployed to $WEBROOT."
echo

if command -v getenforce &> /dev/null && [ "$(getenforce)" == "Enforcing" ]; then
    echo "SELinux is enforcing, applying correct context..."
    sudo chcon -R -t httpd_sys_content_t $WEBROOT
    check_success "Applying SELinux context"
    echo "SELinux context applied."
    echo
fi

echo "########################################"
echo "Restarting $SVC service..."
echo "########################################"
sudo systemctl restart $SVC
check_success "Restarting $SVC"
echo "$SVC service restarted successfully."
echo

echo "########################################"
echo "Cleaning up temporary files..."
echo "########################################"
rm -rf $TEMPDIR
echo "Temporary files removed."
echo

echo "########################################"
echo "Deployment Complete"
echo "Service Status:"
sudo systemctl status $SVC | grep Active
echo

echo "Website Files:"
ls -l $WEBROOT
echo
echo "Visit the server's IP or domain to view the website."
echo "########################################"
