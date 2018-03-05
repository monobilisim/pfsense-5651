#!/bin/sh

awk -f /sbin/dhcptibduzenle.sh < /var/dhcpd/var/db/dhcpd.leases > /tmp/dhcpd-tib.log

files='
/tmp/dhcpd-tib.log
/var/log/dhcpd.log
/var/log/portalauth.log
/var/squid/logs/access.log
/var/log/httpry.log
'

for file in $files
do
    if [ -e $file ]; then

        cd /logimza
        cp $file ./

        openssl ts -config /logimza/.openssl/openssl.cnf -query -data `basename "$file"` -no_nonce -out `basename "$file"`.tsq
        openssl ts -config /logimza/.openssl/openssl.cnf -passin file:/logimza/.openssl/password.txt -reply -queryfile `basename "$file"`.tsq -out `basename "$file"`.der -token_out
        openssl ts -config /logimza/.openssl/openssl.cnf -reply -in `basename "$file"`.der -token_in -text -token_out > `basename "$file"`.imza

        date=$(date +"%Y%m%d")
        year=$(date +"%Y")
        month=$(date +"%m")
        day=$(date +"%d")
        mkdir -p $year/$month/$day/
        tar -zcf $year/$month/$day/`basename "$file"`.$date.tgz `basename "$file"` `basename "$file"`.imza `basename "$file"`.tsq `basename "$file"`.der

        rm `basename "$file"`
        rm `basename "$file"`.imza
        rm `basename "$file"`.tsq
        rm `basename "$file"`.der

    fi
done

rm /tmp/dhcpd-tib.log
