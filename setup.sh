#!/bin/sh

#~ import config
[ ! -e $PWD/setup.conf ] && { echo "setup.conf dosyası bulunamadı..."; exit 1; } || . $PWD/setup.conf

#~ remove old configs
[ "$REM_OLD_CFG" == "true" ] && { echo "Eski yapılandırmalar ve dosyalar siliniyor..."; rm -rf /logimza/.openssl /logimza/$(date +%Y) /usr/local/www/log_browser /usr/local/www/log_browser-master /sbin/logsigner.sh /sbin/dhcpdmodify.awk; }

#~ save project directory
PROJECT_DIRECTORY=$PWD

#~ make new folder and write config
mkdir -p /logimza/.openssl
cp $PWD/bin/openssl.cnf /logimza/.openssl/openssl.cnf
#fetch https://raw.githubusercontent.com/monobilisim/pfsense-5651/master/openssl.cnf -o /logimza/.openssl/openssl.cnf

#~ generate new password
openssl rand -base64 32 > /logimza/.openssl/password.txt

#~ make requested folders and write serial
mkdir -p /logimza/.openssl/ssl /logimza/.openssl/CA /logimza/.openssl/CA/private /logimza/.openssl/CA/newcerts
touch /logimza/.openssl/CA/index.txt
echo 011E > /logimza/.openssl/CA/serial
echo 011E > /logimza/.openssl/CA/tsaserial

#~ generate CA 
cd /logimza/.openssl/ssl
openssl req -config /logimza/.openssl/openssl.cnf -passout file:/logimza/.openssl/password.txt -days 3650 -x509 -newkey rsa:2048 -sha256 -subj "/CN=$SSL_CN/emailAddress=$SSL_EMAIL/O=$SSL_O/C=$SSL_C/ST=$SSL_ST/L=$SSL_L" -out /logimza/.openssl/ssl/cacert.pem -outform PEM
cp /logimza/.openssl/ssl/cacert.pem /logimza/.openssl/CA/
cp /logimza/.openssl/ssl/privkey.pem /logimza/.openssl/CA/private/cakey.pem

#~ generate TSA
openssl genrsa -aes256 -passout file:/logimza/.openssl/password.txt -out /logimza/.openssl/ssl/tsakey.pem 2048
openssl req -new -config /logimza/.openssl/openssl.cnf -key /logimza/.openssl/ssl/tsakey.pem -passin file:/logimza/.openssl/password.txt -sha256 -subj "/CN=$SSL_CN/emailAddress=$SSL_EMAIL/O=$SSL_O/C=$SSL_C/ST=$SSL_ST/L=$SSL_L" -out /logimza/.openssl/ssl/tsareq.csr
openssl ca -config /logimza/.openssl/openssl.cnf -passin file:/logimza/.openssl/password.txt -days 3650 -batch -in /logimza/.openssl/ssl/tsareq.csr -subj "/CN=$SSL_CN/emailAddress=$SSL_EMAIL/O=$SSL_O/C=$SSL_C/ST=$SSL_ST/L=$SSL_L" -out /logimza/.openssl/ssl/tsacert.pem

#~ copy new certificates
cp /logimza/.openssl/ssl/tsacert.pem /logimza/.openssl/CA/
cp /logimza/.openssl/ssl/tsakey.pem /logimza/.openssl/CA/private/

#~ install log browser
fetch https://github.com/monobilisim/log_browser/archive/master.zip -o /tmp/log_browser.zip
unzip -d /usr/local/www /tmp/log_browser.zip
mv /usr/local/www/log_browser-master /usr/local/www/log_browser
rm /tmp/log_browser.zip

#~ install other helper scripts
cd $PROJECT_DIRECTORY
cp $PWD/bin/logsigner.sh $PWD/bin/dhcpdmodify.awk /sbin/
#fetch https://raw.githubusercontent.com/monobilisim/pfsense-5651/master/logsigner.sh -o /sbin/logsigner.sh
#fetch https://raw.githubusercontent.com/monobilisim/pfsense-5651/master/dhcpdmodify.awk -o /sbin/dhcpdmodify.awk
chmod +x /sbin/logsigner.sh /sbin/dhcpdmodify.awk

#~ shortcuts
monospot_entry="\n\t<menu>\n\t\t<name>Monospot</name>\n\t\t<section>Services</section>\n\t\t<url>/monospot</url>\n\t</menu>\n"
logbrowser_entry="\n\t<menu>\n\t\t<name>5651 Gunluk Tarayicisi</name>\n\t\t<section>Status</section>\n\t\t<url>/log_browser</url>\n\t</menu>\n"
[ "$MONOSPOT_SHORTCUT" == "true" ] && { echo -e "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n<packagegui>${monospot_entry}${logbrowser_entry}</packagegui>" > /usr/local/share/pfSense/menu/pfSense-monospot.xml; exit; }
[ "$LOGBROWSER_SHORTCUT" == "true" ] && { echo -e "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n<packagegui>${logbrowser_entry}</packagegui>" > /usr/local/share/pfSense/menu/pfSense-monospot.xml; exit; }
 
