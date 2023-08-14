#!/bin/sh

SSL_CN="hotspot.pfsense.biz.tr"
SSL_EMAIL="hotspot@pfsense.biz.tr"
SSL_O="Monospot"
SSL_C="TR"
SSL_ST="Istanbul"
SSL_L="Avcilar"

# Gerekirse sifirla
# rm -rf /logimza/.openssl/password.txt /logimza/.openssl/CA/ /logimza/.openssl/ssl/ /usr/local/www/log_browser /usr/local/www/log_browser-master /sbin/logimza-imzala.sh /sbin/dhcptibduzenle.sh

# Zaman damgasi icin OpenSSL ayarlari
mkdir -p /logimza/.openssl
fetch https://raw.githubusercontent.com/monobilisim/pfsense-5651/master/openssl.cnf -o /logimza/.openssl/openssl.cnf

# Sertifika icin rasgele sifre olusturuyoruz
touch /logimza/.openssl/password.txt
openssl rand -base64 32 > /logimza/.openssl/password.txt
cat /logimza/.openssl/password.txt

# Sertifika olusturma islemleri

# Gerekli klasor ve dosyalari olustur
mkdir -p /logimza/.openssl/ssl
mkdir -p /logimza/.openssl/CA/private
mkdir -p /logimza/.openssl/CA/newcerts
touch /logimza/.openssl/CA/index.txt
touch /logimza/.openssl/CA/serial
echo 011E > /logimza/.openssl/CA/serial
touch /logimza/.openssl/CA/tsaserial
echo 011E > /logimza/.openssl/CA/tsaserial

# CA olustur
cd /logimza/.openssl/ssl
openssl req -config /logimza/.openssl/openssl.cnf -passout file:/logimza/.openssl/password.txt -days 3650 -x509 -newkey rsa:2048 -sha256 -subj "/CN=$SSL_CN/emailAddress=$SSL_EMAIL/O=$SSL_O/C=$SSL_C/ST=$SSL_ST/L=$SSL_L" -out /logimza/.openssl/ssl/cacert.pem -outform PEM
cp /logimza/.openssl/ssl/cacert.pem /logimza/.openssl/CA/
cp /logimza/.openssl/ssl/privkey.pem /logimza/.openssl/CA/private/cakey.pem

# TSA icin Sertifika olustur
openssl genrsa -aes256 -passout file:/logimza/.openssl/password.txt -out /logimza/.openssl/ssl/tsakey.pem 2048
openssl req -new -config /logimza/.openssl/openssl.cnf -key /logimza/.openssl/ssl/tsakey.pem -passin file:/logimza/.openssl/password.txt -sha256 -subj "/CN=$SSL_CN/emailAddress=$SSL_EMAIL/O=$SSL_O/C=$SSL_C/ST=$SSL_ST/L=$SSL_L" -out /logimza/.openssl/ssl/tsareq.csr
openssl ca -config /logimza/.openssl/openssl.cnf -passin file:/logimza/.openssl/password.txt -days 3650 -batch -in /logimza/.openssl/ssl/tsareq.csr -subj "/CN=$SSL_CN/emailAddress=$SSL_EMAIL/O=$SSL_O/C=$SSL_C/ST=$SSL_ST/L=$SSL_L" -out /logimza/.openssl/ssl/tsacert.pem
cp /logimza/.openssl/ssl/tsacert.pem /logimza/.openssl/CA/
cp /logimza/.openssl/ssl/tsakey.pem /logimza/.openssl/CA/private/

# log_browser ve imzalama betiklerini yukle
fetch https://github.com/monobilisim/log_browser/archive/master.zip -o /tmp/log_browser.zip
unzip -d /usr/local/www /tmp/log_browser.zip
mv /usr/local/www/log_browser-master /usr/local/www/log_browser
rm /tmp/log_browser.zip
fetch https://raw.githubusercontent.com/monobilisim/pfsense-5651/master/logimza-imzala.sh -o /sbin/logimza-imzala.sh
fetch https://raw.githubusercontent.com/monobilisim/pfsense-5651/master/dhcptibduzenle.sh -o /sbin/dhcptibduzenle.sh
chmod +x /sbin/logimza-imzala.sh /sbin/dhcptibduzenle.sh
