# Capture command line arguments
CLI_HOSTNAME=$1
CLI_PASSWORD=$2

# Do these steps first, only need to be done once per host
# sudo apt-get update

# Installer for:software-properties-common
REQUIRED_PKG="software-properties-common"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo PACKAGE CHECK: $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get --yes install $REQUIRED_PKG 
fi

#sudo add-apt-repository universe
#sudo add-apt-repository ppa:certbot/certbot
#sudo apt-get update
#

# Install certbot if it's not already installed
REQUIRED_PKG="certbot"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo PACKAGE CHECK: $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get --yes install $REQUIRED_PKG 
fi

# Determine the hostname to grab a certificate for
# Use one entered from the CLI, otherwise ask for one
if [ -z ${CLI_HOSTNAME} ];
then
  read -p "Enter your hostname: " HOSTNAME
else
  echo "Requesting a cert for: " $CLI_HOSTNAME
  HOSTNAME=$CLI_HOSTNAME
fi

# Set a password on the .p12 file (required for some software on import)
if [ -z ${CLI_PASSWORD} ];
then
  read -p 'Enter a password to protect your .p12: ' PASSWORD
else
  echo "Protecting your .p12 with password: " $CLI_PASSWORD
  PASSWORD=$CLI_PASSWORD
fi

# Certbot
sudo certbot certonly --standalone --cert-name $HOSTNAME
# Should only run command below if certbot completed successfully
mkdir -p local-certs
sudo cp /etc/letsencrypt/live/$HOSTNAME/fullchain.pem ./local-certs
sudo cp /etc/letsencrypt/live/$HOSTNAME/privkey.pem ./local-certs
sudo openssl pkcs12 -export -inkey /etc/letsencrypt/live/$HOSTNAME/privkey.pem -in /etc/letsencrypt/live/$HOSTNAME/fullchain.pem -out ./local-certs/$HOSTNAME.p12 -password pass:$PASSWORD

# Certs are owned by root and can't be moved?
sudo chown $USER:$USER ./local-certs/$HOSTNAME.p12
sudo chown $USER:$USER ./local-certs/privkey.pem
sudo chown $USER:$USER ./local-certs/fullchain.pem