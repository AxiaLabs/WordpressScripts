# Getting Started

To begin using these scripts witb amazon lightsail you should put the following lines into the start up script section

```
curl https://raw.githubusercontent.com/RobertUpchurch/WordpressScripts/main/WP_Setup.sh -o ~apps/wordpress/htdocs/WP_Setup.sh
sudo chown bitnami ~apps/wordpress/htdocs/WP_Setup.sh
sudo chmod 700 ~apps/wordpress/htdocs/WP_Setup.sh
```