#VARIABLES - ALL ARE REQUIRED
domain_name=""
email=""
client=""
client_slug=""
client_phrase=""
client_address=""
client_city=""
client_state="" #SHOULD BE STATE ABBREVIATION (UT, AZ, etc)
client_zip=""
client_primary_color="#FF0000"
client_secondary_color="#00FF00"

# START OF SCRIPT
#Create necessary folders and permissions
mkdir ~/apps/wordpress/htdocs/wp-content/upgrade
sudo chown bitnami:daemon ~/apps/wordpress/htdocs/wp-content/upgrade
sudo chmod 775 ~/apps/wordpress/htdocs/wp-content/upgrade

# GET WP CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

#Remove All Users
wp user delete user --yes
#Remove all posts
wp post delete $(wp post list --post_type='posts' --format=ids) --force
#Remove All Pages
wp post delete $(wp post list --post_type='page' --format=ids) --force
#Remove all Plugins
wp plugin deactivate --all
wp plugin delete --all

# Create New Default Users
wp user create rob rob@axialabs.com --role=administrator --user_pass=AxiaLabs123
wp user create demitri demitri@axialabs.com --role=administrator --user_pass=AxiaLabs123

#Add Public Free Plugins
wp plugin install wp-mail-smtp --activate
wp plugin install elementor --activate
wp plugin install woocommerce --activate

# Deletes all default themes
wp theme delete --all

#install/activate hello elementor
wp theme install hello-elementor

#Update themes
wp theme update --all

#Generate Pages and Save IDs
homeId=$(wp post create --post_type="page" --post_title="Home" --post_status="publish" --post_author="2" --porcelain)
blogId=$(wp post create --post_type="page" --post_title="Blog" --post_status="publish" --post_author="2" --porcelain)
aboutId=$(wp post create --post_type="page" --post_title="About Us" --post_status="publish" --post_author="2" --porcelain)
contactId=$(wp post create --post_type="page" --post_title="Contact Us" --post_status="publish" --post_author="2" --porcelain)
termsId=$(wp post create --post_type="page" --post_title="Terms & Conditions" --post_status="publish" --post_author="2" --porcelain)
shippingId=$(wp post create --post_type="page" --post_title="Shipping And Returns" --post_status="publish" --post_author="2" --porcelain)
privacyId=$(wp post create --post_type="page" --post_title="Privacy Statement" --post_status="publish" --post_author="2" --porcelain)

#SET FRONT PAGE and Blog Page
wp option update show_on_front 'page'
wp option update page_on_front $homeId
wp option update page_for_posts $blogId

#Generate Menus
wp menu create "header-menu"
wp menu item add-post header-menu $homeId --title="Home"
wp menu item add-post header-menu $blogId --title="Blog"
wp menu item add-post header-menu $aboutId --title="About Us"
wp menu item add-post header-menu $contactId --title="Contact Us"

wp menu create "support-menu"
wp menu item add-post support-menu $termsId --title="Terms & Conditions"
wp menu item add-post support-menu $termsId --title="Shipping And Returns"
wp menu item add-post support-menu $privacyId --title="Privacy Statement"

#Set WP Options
wp option update siteurl "https://' . $_SERVER['HTTP_HOST'] . '/'"
wp option update home "https://' . $_SERVER['HTTP_HOST'] . '/'"
wp option update blogname "$client"
wp option update blogdescription "$client_phrase"
wp option update admin_email "$email"
wp option update permalink_structure '/%postname%/'
wp option update wp_page_for_privacy_policy $privacyId

#SET WOOCOMMERCE OPTIONS
wp option update woocommerce_store_address "$client_address"
wp option update woocommerce_store_city "$client_city"
wp option update woocommerce_store_postcode "$client_zip"
wp option update woocommerce_default_country "US:$client_state"
wp option update woocommerce_currency "USD"
wp option update woocommerce_weight_unit "lbs"
wp option update woocommerce_dimension_unit "in"
wp option update woocommerce_registration_generate_password no
wp option update woocommerce_email_from_address "orders@$domain_name"
wp option update woocommerce_email_from_name "$client"
wp option update woocommerce_email_footer_text "(site_title}. 2021."
wp option update woocommerce_email_background_color "#D3D3D3"
wp option update woocommerce_email_base_color $client_primary_color
wp option update woocommerce_email_body_background_color "#FFF"
wp option update woocommerce_email_text_color "#000"
wp option update woocommerce_myaccount_downloads_endpoint ""

#Generate Child Theme
wp scaffold child-theme $client_slug --parent_theme=hello-elementor --theme_name="$client Theme" --author="Axia Labs" --author_uri="https://axialabs.com" --activate

#Disable Bitnami Banner
sudo /opt/bitnami/apps/wordpress/bnconfig --disable_banner 1
sudo /opt/bitnami/ctlscript.sh restart apache

# START Cert tool
sudo /opt/bitnami/bncert-tool
