my-mysql(){
	mysql -u "$MYSQL_USER" -p"$MYSQL_PASS"
}

mysql-import-sql-file(){
	mysql -u "$MYSQL_USER" -p"$MYSQL_PASS" $1 < $2
}

mysql-dump-sql-file(){
    mysqldump -u "$MYSQL_USER" -p"$MYSQL_PASS" $1 > $2
}

mysql-import-gzip-sql-file(){
	gunzip < $2 | mysql -u "$MYSQL_USER" -p"$MYSQL_PASS" $1
}

mysql-sanitize-file(){
	sed "s/\/\*[^\/]*DEFINER.*\*\///" $1 > $2
}

mysql-create(){
    mysqladmin -u "$MYSQL_USER" -p"$MYSQL_PASS" create $1
}