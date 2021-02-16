#######################
### User Variable  ####
#######################
read -p "What's the client address? " client_address
read -p "What's the client city? " client_city
read -p "What's the client state abbreviation: " client_state
read -p "What's the client Zipcode? " client_zip
read -p "Enter HEX for client primary color: ( ex. #FAFAFA ) " client_primary_color

#######################
### Plugins  ##########
#######################
wp plugin install woocommerce --activate
wp plugin install advanced-coupons-for-woocommerce-free --activate

#######################
### Pages #############
#######################
shippingId=$(wp post create --post_type="page" --post_title="Shipping And Returns" --post_status="publish" --post_author="2" --porcelain)

#######################
### Menu  #############
#######################
wp menu item add-post support-menu $termsId --title="Shipping And Returns"

#######################
### Options  ##########
#######################
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