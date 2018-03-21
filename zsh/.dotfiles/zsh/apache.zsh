SITES_DIR=/Volumes/Sites/

VHOST_TEMPLATE="
<VirtualHost *:80>
	ServerName  {template}
	DocumentRoot $SITES_DIR{template}
</VirtualHost>
"

watch-apache(){
	tail -f /var/log/apache2/error.log
}

enable-site(){
  	sudo a2ensite $1
}

disable-site(){
	sudo a2dissite $1
}

restart-apache(){
	sudo service apache2 restart
}

remove-site(){
	# read template - replace data - write into a new file
	sudo rm -rf /etc/apache2/extra/vhosts.d/vhost-http-$1.conf
	sudo apachectl restart #restart server
}

add-site(){

	# read template - replace data - write into a new file
	sudo touch /etc/apache2/extra/vhosts.d/vhost-http-$1.conf
	sudo chmod 777 /etc/apache2/extra/vhosts.d/vhost-http-$1.conf
	sudo echo "$VHOST_TEMPLATE" | sed "s/{template}/$1/g" | cat > /etc/apache2/extra/vhosts.d/vhost-http-$1.conf

	sudo apachectl restart #restart server

	sudo echo 127.0.0.1 $1 >> /etc/hosts #create reference
}

rsync-example(){
	
	echo "rsync -uavz -e ssh test-server:/var/www/html/media/ media/ --exclude 'catalog/product/cache/*' --exclude 'tmp/*' --exclude 'js/*' --exclude 'css/*' --exclude 'css_secure/*'"
}
