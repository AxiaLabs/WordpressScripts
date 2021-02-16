#######################
### User Variable  ####
#######################

domain_name="" #exclude https://
email=""
client=""
client_slug="" # Should Match client variable but with "-"s instead of spaces. No special Characters
client_phrase=""
client_address=""
client_city=""
client_state="" #SHOULD BE STATE ABBREVIATION (UT, AZ, etc)
client_zip=""

client_primary_color=""

SES_region=""
SES_user=""
SES_pass=""

ImagifyApiKey=""

#####################
### Installation ####
#####################

# # Bitnami Permisions
# mkdir ~/apps/wordpress/htdocs/wp-content/upgrade
# sudo chown bitnami:daemon ~/apps/wordpress/htdocs/wp-content/upgrade
# sudo chmod 775 ~/apps/wordpress/htdocs/wp-content/upgrade

# # WP CLI
# curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# chmod +x wp-cli.phar
# sudo mv wp-cli.phar /usr/local/bin/wp

sudo wp core update --allow-root
sudo chown -R daemon /apps/wordpress/htdocs
sudo chown -R bitnami /apps/wordpress/htdocs/wp-content
sudo chown bitnami /apps/wordpress/htdocs/wp-config.php

#################
### Clean Up ####
#################

#Remove All Users
wp user delete user --yes
#Remove all posts
wp post delete $(wp post list --post_type='posts' --format=ids) --force
#Remove All Pages
wp post delete $(wp post list --post_type='page' --format=ids) --force
#Remove all Plugins
wp plugin deactivate --all
wp plugin delete --all
# Deletes all default themes
wp theme delete --all

########################
### Default Creation ###
########################

# Users
wp user create rob rob@axialabs.com --role=administrator --user_pass=AxiaLabs123
wp user create demitri demitri@axialabs.com --role=administrator --user_pass=AxiaLabs123

# Plugins
wp plugin install wp-mail-smtp --activate
wp plugin install elementor --activate
wp plugin install imagify --activate
wp plugin install megamenu --activate
wp plugin install admin-menu-editor --activate

#Security Plugins
wp plugin install wordfence --activate
wp plugin install wps-hide-login --activate

# #BuddyPress
# wp plugin install buddypress --activate

# # WooCommerce
# wp plugin install woocommerce --activate
# wp plugin install advanced-coupons-for-woocommerce-free --activate

# Themes
wp theme update --all
wp theme install hello-elementor

# Child Theme
wp scaffold child-theme $client_slug --parent_theme=hello-elementor --theme_name="$client Theme" --author="Axia Labs" --author_uri="https://axialabs.com" --activate
mkdir /home/bitnami/apps/wordpress/htdocs/wp-content/themes/$client_slug/woocommerce
mkdir /home/bitnami/apps/wordpress/htdocs/wp-content/themes/$client_slug/woocommerce/loop
sudo cp -r /home/bitnami/apps/wordpress/htdocs/wp-content/plugins/woocommerce/templates/loop/ /home/bitnami/apps/wordpress/htdocs/wp-content/themes/$client_slug/woocommerce/
sudo chown -R bitnami:bitnami  /home/bitnami/apps/wordpress/htdocs/wp-content/themes/$client_slug/woocommerce/loop

# Pages
homeId=$(wp post create --post_type="page" --post_title="Home" --post_status="publish" --post_author="2" --porcelain)
blogId=$(wp post create --post_type="page" --post_title="Blog" --post_status="publish" --post_author="2" --porcelain)
aboutId=$(wp post create --post_type="page" --post_title="About Us" --post_status="publish" --post_author="2" --porcelain)
contactId=$(wp post create --post_type="page" --post_title="Contact Us" --post_status="publish" --post_author="2" --porcelain)
termsId=$(wp post create --post_type="page" --post_title="Terms & Conditions" --post_status="publish" --post_author="2" --porcelain)
shippingId=$(wp post create --post_type="page" --post_title="Shipping And Returns" --post_status="publish" --post_author="2" --porcelain)
privacyId=$(wp post create --post_type="page" --post_title="Privacy Statement" --post_status="publish" --post_author="2" --porcelain)

#Menus
wp menu create "header-menu"
wp menu item add-post header-menu $homeId --title="Home"
wp menu item add-post header-menu $blogId --title="Blog"
wp menu item add-post header-menu $aboutId --title="About Us"
wp menu item add-post header-menu $contactId --title="Contact Us"

wp menu create "support-menu"
wp menu item add-post support-menu $termsId --title="Terms & Conditions"
wp menu item add-post support-menu $termsId --title="Shipping And Returns"
wp menu item add-post support-menu $privacyId --title="Privacy Statement"

########################
### Settings  ##########
########################

# Read Settings
wp option update show_on_front 'page'
wp option update page_on_front $homeId
wp option update page_for_posts $blogId


# Wordpress
wp config set WP_SITEURL "https://$domain_name"
wp option update siteurl "https://$domain_name"
wp config set WP_HOME "https://$domain_name"
wp option update home "https://$domain_name"
wp option update blogname "$client"
wp option update blogdescription "$client_phrase"
wp option update admin_email "$email"
wp option update permalink_structure '/%postname%/'
wp option update wp_page_for_privacy_policy $privacyId


# Woocommerce
# wp option update woocommerce_store_address "$client_address"
# wp option update woocommerce_store_city "$client_city"
# wp option update woocommerce_store_postcode "$client_zip"
# wp option update woocommerce_default_country "US:$client_state"
# wp option update woocommerce_currency "USD"
# wp option update woocommerce_weight_unit "lbs"
# wp option update woocommerce_dimension_unit "in"
# wp option update woocommerce_registration_generate_password no
# wp option update woocommerce_email_from_address "orders@$domain_name"
# wp option update woocommerce_email_from_name "$client"
# wp option update woocommerce_email_footer_text "(site_title}. 2021."
# wp option update woocommerce_email_background_color "#D3D3D3"
# wp option update woocommerce_email_base_color $client_primary_color
# wp option update woocommerce_email_body_background_color "#FFF"
# wp option update woocommerce_email_text_color "#000"
# wp option update woocommerce_myaccount_downloads_endpoint ""

# Mail SMTP
echo "support@$domain_name" | wp option patch insert wp_mail_smtp mail from_email
echo "$client"              | wp option patch insert wp_mail_smtp mail from_name
echo "smtp"                 | wp option patch insert wp_mail_smtp mail mailer
echo "false"                | wp option patch insert wp_mail_smtp mail from_email_force
echo "email-smtp.$SES_region.amazonaws.com" | wp option patch insert wp_mail_smtp smtp host
echo "$SES_user"            | wp option patch insert wp_mail_smtp smtp user
echo "$SES_pass"            | wp option patch insert wp_mail_smtp smtp pass
echo "tls"                  | wp option patch insert wp_mail_smtp smtp encryption
echo "587"                  | wp option patch insert wp_mail_smtp smtp port

# Imagify 
echo "$ImagifyApiKey" | wp option patch update imagify_settings api_key
echo 1 | wp option patch update imagify_settings display_webp

# BITNAMI
sudo /opt/bitnami/apps/wordpress/bnconfig --disable_banner 1
sudo /opt/bitnami/ctlscript.sh restart apache


########################
### SSL  ###############
########################
echo "Configuration Complete: Set Up SSL with previous command before processing."
sudo /opt/bitnami/bncert-tool
