RED="\033[0;31m"
YELLOW="\033[33m"
REDBG="\033[0;41m"
WHITE="\033[1;37m"
NC="\033[0m"

fix-permissions(){
	git config core.fileMode false
	sudo chmod -R 777 media/ var/ app/etc/
}

fix-all-permissions(){
	git config core.fileMode false
	sudo chmod -R 777 .
}

clear-cache(){
	if [ ! -f bin/magento ]; then
    	sudo rm -rf var/cache/*
		sudo rm -rf var/full_page_cache/*
	else
		php bin/magento cache:flush
	fi
}

hints(){
	n98-magerun.phar dev:template-hints
}

sync-media(){
	rsync -avz $i media --exclude '*cache*'
}

clear-session(){
	sudo rm -rf var/session/*
}

watch-exception(){
	tail -f var/log/exception.log
}

magento2-install() {
	php bin/magento setup:install --base-url=$1 --db-host=localhost --db-name=$2 --db-user=MYSQL_USER --db-password=MYSQL_PASS --admin-firstname=Jamie --admin-lastname=Smith --admin-email=jamie.smith@blueacorn.com --admin-user=$MAGE_USER --admin-password=$MAGE_PASS --language=en_US --currency=USD --timezone=America/New_York --use-rewrites=1 --cleanup-database
}

magento-install() {
	# Loop through the versions and print them out as choices
	for i in /Users/jamie/Documents/Magento\ Versions/* ; do
	  if [ -d "$i" ]; then
	    echo -e "${YELLOW}$(basename "$i")${NC}"
	  fi
	done

	# Ask for the magento version to install
	echo -e "${RED}Enter the version you wish to install (only use the version number):${NC}";
	read version;

	# Ask for domain name
	echo -e "${RED}Enter local domain you wish to install version $version on:${NC}";
	read domain;

	# Ask for database name
	echo -e "${RED}Enter the database name you wish to create (eg: magentotesting.dev):${NC}";
	read databaseName;

	# Ask if they want to inport sample data into the created database
	echo "Setting up site $domain..."

	# Do shit man
	cp -a /Users/jamie/Documents/Magento\ Versions/Magento\ EE\ $version/. /Volumes/Sites/$domain
	chmod -R 777 /Volumes/Sites/$domain
	chown -R jamie:staff /Volumes/Sites/$domain
	cd /Volumes/Sites/$domain

	echo "Setting up database $databaseName..."

	# Create the database on local server
	mysql-create $databaseName

	echo "Running install script for magento..."

	# Run the install script
	php -f install.php -- \
	--license_agreement_accepted "yes" \
	--locale "en_US" \
	--timezone "Etc/GMT+5" \
	--default_currency "USD" \
	--db_host "127.0.0.1" \
	--db_name "$databaseName" \
	--db_user "$MYSQL_USER" \
	--db_pass "$MYSQL_PASS" \
	--session_save "db" \
	--admin_frontname "admin" \
	--url "http://$domain" \
	--use_rewrites "yes" \
	--use_secure "no" \
	--secure_base_url "" \
	--use_secure_admin "no" \
	--admin_firstname "Jamie" \
	--admin_lastname "Smith" \
	--admin_email "t@t.com" \
	--admin_username "$MAGE_USER" \
	--admin_password "$MAGE_PASS"
}

watch-system(){
	tail -f var/log/system.log
}

rm-profiler-data(){
	sudo rm -rf /tmp/cachegrind.out.*
}

clear-compiled(){
	rm -rf media/css/*.css media/js/*.js
}

reindex-site(){
	php ./shell/indexer.php --reindexall

	if [ ! -f bin/magento ]; then
    	php ./shell/indexer.php --reindexall
	else
		php bin/magento indexer:reindex
	fi
}

magento-base-setup(){
    echo "Setting up site $1..."
    echo "Updating configuration..."

	n98-magerun.phar db:query "update core_config_data set value = '0' where path = 'google/analytics/active';"
	n98-magerun.phar db:query "update core_config_data set value = 'http://$1/' where path = 'web/unsecure/base_url';"
	n98-magerun.phar db:query "update core_config_data set value = 'http://$1/' where path = 'web/secure/base_url';"
	n98-magerun.phar db:query "update core_config_data set value = '0' where path = 'payment/authorizenet/active';"
	n98-magerun.phar db:query "update core_config_data set value = '1' where path = 'payment/ccsave/active';"
	n98-magerun.phar db:query "delete from core_config_data where path = 'web/cookie/cookie_domain';"
	n98-magerun.phar db:query "update core_config_data set value = '0' where path = 'dev/js/merge_files';"
	n98-magerun.phar db:query "update core_config_data set value = '0' where path = 'dev/css/merge_files';"
	n98-magerun.phar db:query "update core_config_data set value = '{{unsecure_base_url}}' where path = 'web/unsecure/base_link_url';"
	n98-magerun.phar db:query "update core_config_data set value = '{{unsecure_base_url}}skin/' where path = 'web/unsecure/base_skin_url';"
	n98-magerun.phar db:query "update core_config_data set value = '{{unsecure_base_url}}media/' where path = 'web/unsecure/base_media_url';"
	n98-magerun.phar db:query "update core_config_data set value = '{{unsecure_base_url}}js/' where path = 'web/unsecure/base_js_url';"
	n98-magerun.phar db:query "update core_config_data set value = '{{secure_base_url}}' where path = 'web/secure/base_link_url';"
	n98-magerun.phar db:query "update core_config_data set value = '{{secure_base_url}}skin/' where path = 'web/secure/base_skin_url';"
	n98-magerun.phar db:query "update core_config_data set value = '{{secure_base_url}}media/' where path = 'web/secure/base_media_url';"
	n98-magerun.phar db:query "update core_config_data set value = '{{secure_base_url}}js/' where path = 'web/secure/base_js_url';"
	n98-magerun.phar db:query "update core_config_data set value = '0' where path = 'admin/security/password_is_forced';"
	n98-magerun.phar db:query "update core_config_data set value = '1000' where path = 'admin/security/password_lifetime';"

        echo "Disabling cache..."
        n98-magerun.phar cache:clean
        n98-magerun.phar cache:disable

	#echo "Enabling Logging for exceptions..."
	n98-magerun.phar dev:log --global
}

sanitize() {
  BASE_URL="http://$1/";
  n98-magerun.phar db:query "update core_config_data set value = '$BASE_URL' where path = 'web/unsecure/base_url';"
  n98-magerun.phar db:query "update core_config_data set value = '$BASE_URL' where path = 'web/secure/base_url';"
  n98-magerun.phar db:query "update core_config_data set value = '0' where path = 'payment/authorizenet/active';"
  n98-magerun.phar db:query "update core_config_data set value = '1' where path = 'payment/ccsave/active';"
  n98-magerun.phar db:query "delete from core_config_data where path = 'web/cookie/cookie_domain';"
  n98-magerun.phar db:query "update core_config_data set value = '0' where path = 'dev/js/merge_files';"
  n98-magerun.phar db:query "update core_config_data set value = '0' where path = 'dev/css/merge_files';"
  n98-magerun.phar db:query "update core_config_data set value = '{{unsecure_base_url}}' where path = 'web/unsecure/base_link_url';"
  n98-magerun.phar db:query "update core_config_data set value = '{{unsecure_base_url}}skin/' where path = 'web/unsecure/base_skin_url';"
  n98-magerun.phar db:query "update core_config_data set value = '{{unsecure_base_url}}media/' where path = 'web/unsecure/base_media_url';"
  n98-magerun.phar db:query "update core_config_data set value = '{{unsecure_base_url}}js/' where path = 'web/unsecure/base_js_url';"
  n98-magerun.phar db:query "update core_config_data set value = '{{secure_base_url}}' where path = 'web/secure/base_link_url';"
  n98-magerun.phar db:query "update core_config_data set value = '{{secure_base_url}}skin/' where path = 'web/secure/base_skin_url';"
  n98-magerun.phar db:query "update core_config_data set value = '{{secure_base_url}}media/' where path = 'web/secure/base_media_url';"
  n98-magerun.phar db:query "update core_config_data set value = '{{secure_base_url}}js/' where path = 'web/secure/base_js_url';"
  n98-magerun.phar db:query "update core_config_data set value = '0' where path = 'admin/security/password_is_forced';"
  n98-magerun.phar db:query "update core_config_data set value = '1000' where path = 'admin/security/password_lifetime';"
  n98-magerun.phar db:query "update core_config_data set value = '86400' where path = 'admin/security/session_cookie_lifetime';"
  n98-magerun.phar config:set admin/security/session_cookie_lifetime 86400
  magento-admin-user-create
  n98-magerun.phar config:set admin/startup/page 'system/config'
  n98-magerun.phar config:set dev/log/active 1
}


magento-sanitize(){
	echo "Sanitizing site..."
	n98-magerun.phar db:query "SET foreign_key_checks = 0;"
	n98-magerun.phar db:query "TRUNCATE \`catalogsearch_query\`;"
	n98-magerun.phar db:query "TRUNCATE \`catalogsearch_fulltext\`;"
	n98-magerun.phar db:query "TRUNCATE \`catalogsearch_result\`;"
	n98-magerun.phar db:query "TRUNCATE \`customer_address_entity\`;"
	n98-magerun.phar db:query "TRUNCATE \`customer_address_entity_datetime\`;"
	n98-magerun.phar db:query "TRUNCATE \`customer_address_entity_decimal\`;"
	n98-magerun.phar db:query "TRUNCATE \`customer_address_entity_int\`;"
	n98-magerun.phar db:query "TRUNCATE \`customer_address_entity_text\`;"
	n98-magerun.phar db:query "TRUNCATE \`customer_address_entity_varchar\`;"
	n98-magerun.phar db:query "TRUNCATE \`customer_entity\`;"
	n98-magerun.phar db:query "TRUNCATE \`customer_entity_datetime\`;"
	n98-magerun.phar db:query "TRUNCATE \`customer_entity_decimal\`;"
	n98-magerun.phar db:query "TRUNCATE \`customer_entity_int\`;"
	n98-magerun.phar db:query "TRUNCATE \`customer_entity_text\`;"
	n98-magerun.phar db:query "TRUNCATE \`customer_entity_varchar\`;"
	n98-magerun.phar db:query "TRUNCATE \`dataflow_batch\`;"
	n98-magerun.phar db:query "TRUNCATE \`dataflow_batch_export\`;"
	n98-magerun.phar db:query "TRUNCATE \`dataflow_batch_import\`;"
	n98-magerun.phar db:query "TRUNCATE \`dataflow_batch_import_backup\`;"
	n98-magerun.phar db:query "TRUNCATE \`dataflow_batch_export_backup\`;"
	n98-magerun.phar db:query "TRUNCATE \`enterprise_customerbalance_history\`;"
	n98-magerun.phar db:query "TRUNCATE \`enterprise_customer_sales_flat_order\`;"
	n98-magerun.phar db:query "TRUNCATE \`enterprise_customer_sales_flat_order_address\`;"
	n98-magerun.phar db:query "TRUNCATE \`enterprise_customer_sales_flat_quote\`;"
	n98-magerun.phar db:query "TRUNCATE \`enterprise_customer_sales_flat_quote_address\`;"
	n98-magerun.phar db:query "TRUNCATE \`enterprise_sales_creditmemo_grid_archive\`;"
	n98-magerun.phar db:query "TRUNCATE \`enterprise_sales_invoice_grid_archive\`;"
	n98-magerun.phar db:query "TRUNCATE \`enterprise_sales_order_grid_archive\`;"
	n98-magerun.phar db:query "TRUNCATE \`enterprise_sales_shipment_grid_archive\`;"
	n98-magerun.phar db:query "TRUNCATE \`enterprise_targetrule_index\`;"
	n98-magerun.phar db:query "TRUNCATE \`enterprise_targetrule_product\`;"
	n98-magerun.phar db:query "TRUNCATE \`log_customer\`;"
	n98-magerun.phar db:query "TRUNCATE \`log_visitor\`;"
	n98-magerun.phar db:query "TRUNCATE \`log_visitor_info\`;"
	n98-magerun.phar db:query "TRUNCATE \`log_visitor_online\`;"
	n98-magerun.phar db:query "TRUNCATE \`log_quote\`;"
	n98-magerun.phar db:query "TRUNCATE \`log_url\`;"
	n98-magerun.phar db:query "TRUNCATE \`log_url_info\`;"
	n98-magerun.phar db:query "TRUNCATE \`sendfriend_log\`;"
	n98-magerun.phar db:query "TRUNCATE \`newsletter_subscriber\`;"
	n98-magerun.phar db:query "TRUNCATE \`persistent_session\`;"
	n98-magerun.phar db:query "TRUNCATE \`product_alert_stock\`;"
	n98-magerun.phar db:query "TRUNCATE \`report_event\`;"
	n98-magerun.phar db:query "TRUNCATE \`report_compared_product_index\`;"
	n98-magerun.phar db:query "TRUNCATE \`report_viewed_product_index\`;"
	n98-magerun.phar db:query "TRUNCATE \`review\`;"
	n98-magerun.phar db:query "TRUNCATE \`review_detail\`;"
	n98-magerun.phar db:query "TRUNCATE \`review_store\`;"
	n98-magerun.phar db:query "TRUNCATE \`salesrule_customer\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_bestsellers_aggregated_daily\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_bestsellers_aggregated_monthly\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_bestsellers_aggregated_yearly\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_billing_agreement\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_billing_agreement_order\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_creditmemo\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_creditmemo_comment\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_creditmemo_grid\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_creditmemo_item\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_invoice\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_invoice_comment\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_invoice_grid\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_invoice_item\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_order\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_order_address\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_order_grid\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_order_item\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_order_payment\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_order_status_history\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_quote\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_quote_address\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_quote_address_item\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_quote_item\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_quote_item_option\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_quote_payment\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_quote_shipping_rate\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_shipment\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_shipment_comment\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_shipment_grid\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_shipment_item\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_flat_shipment_track\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_invoiced_aggregated\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_invoiced_aggregated_order\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_order_aggregated_created\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_order_tax\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_payment_transaction\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_recurring_profile\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_recurring_profile_order\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_refunded_aggregated\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_refunded_aggregated_order\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_shipping_aggregated\`;"
	n98-magerun.phar db:query "TRUNCATE \`sales_shipping_aggregated_order\`;"
	n98-magerun.phar db:query "TRUNCATE \`tag\`;"
	n98-magerun.phar db:query "TRUNCATE \`tag_properties\`;"
	n98-magerun.phar db:query "TRUNCATE \`tag_relation\`;"
	n98-magerun.phar db:query "TRUNCATE \`tag_summary\`;"
	n98-magerun.phar db:query "TRUNCATE \`wishlist\`;"
	n98-magerun.phar db:query "TRUNCATE \`wishlist_item\`;"
	n98-magerun.phar db:query "TRUNCATE \`wishlist_item_option\`;"
	n98-magerun.phar db:query "SET foreign_key_checks = 1;"
}

magento-delete-customers(){
	n98-magerun.phar db:query "SET foreign_key_checks = 0;TRUNCATE \`customer_address_entity\`;TRUNCATE \`customer_address_entity_datetime\`;TRUNCATE \`customer_address_entity_decimal\`;TRUNCATE \`customer_address_entity_int\`;TRUNCATE \`customer_address_entity_text\`;TRUNCATE \`customer_address_entity_varchar\`;TRUNCATE \`customer_entity\`;TRUNCATE \`customer_entity_datetime\`;TRUNCATE \`customer_entity_decimal\`;TRUNCATE \`customer_entity_int\`;TRUNCATE \`customer_entity_text\`;TRUNCATE \`customer_entity_varchar\`;SET foreign_key_checks = 1;"
}

getLocalXmlValue() {
    echo $1 | sed -n -e "s/.*<$2><!\[CDATA\[\(.*\)\]\]><\/$2>.*/\1/p" | head -n 1
}

getLocalXmlKey(){
	for f in `ls app/etc/local.xml*`
	do
		if [ ! -z $(getLocalXmlValue $f $1) ]
		then
			echo `getLocalXmlValue $f $1`
			return
		fi
	done

}

magento-database-table-sizes(){
	n98-magerun.phar db:query --no-ansi "pager less -SFX; SELECT TABLE_SCHEMA, TABLE_NAME, (INDEX_LENGTH+DATA_LENGTH)/(1024*1024) AS SIZE_MB,TABLE_ROWS FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA in ('$1') ORDER BY SIZE_MB DESC;"
}


magento-admin-user-create(){
	n98-magerun.phar admin:user:create "$MAGE_USER" t@t.com "$MAGE_PASS" t s

}

magento-customer-create(){
	n98-magerun.phar customer:create ta@ta.com "$MAGE_PASS" t
}

magento-db-dump-gzip(){
	n98-magerun.phar db:dump --strip="@development" --compression="gzip"
}

magento-db-import-gzip(){
	n98-magerun.phar db:import --compression="gz" $1
}

magento-db-dump(){
	n98-magerun.phar db:dump
}
