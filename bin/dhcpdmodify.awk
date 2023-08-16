# dhcp.awk
# awk -f dhcp.awk  < /var/db/dhcpd.leases

/lease\ [0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\ {/ { 
	printf("%s\t\t", $2); 	
}

/starts\ [^;]*;/ {
	sub(";", "", $4);
	printf("%s-%s\t\t", $3, $4);	
}

/ends\ [^;]*;/ { 
	sub(";", "", $4);
	printf("%s-%s\t\t", $3, $4);	
}

/hardware\ ethernet\ [^;]*;/ {
	sub(";", "", $3);
	printf("%s\r\n", $3);	
}

