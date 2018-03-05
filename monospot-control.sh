#!/bin/sh

CHECK="monospot" 
SEARCH='portal_reply_page($redirurl, "login", null, $clientmac, $clientip);'
REPLACE="include \'monospot\/captiveportal.php\'" 
FILE="/usr/local/captiveportal/index.php" 

if [ $(grep -c "$CHECK" "$FILE") -eq 0 ]; then 
	sed -i .bak "s/${SEARCH}/${REPLACE};/g" ${FILE}
	echo "Monospot devrede degil. Monospot devreye alindi." 
else
	echo "Monospot devrede. Degistirilmesine gerek yok."; 
fi