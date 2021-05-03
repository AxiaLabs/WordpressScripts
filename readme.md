# Getting Started

To begin using this you should run the following code from your lightsail instance:

```
curl https://raw.githubusercontent.com/AxiaLabs/WordpressScripts/main/WP_Setup.sh -o /home/bitnami/apps/wordpress/htdocs/WP_Setup.sh
sudo chown bitnami:bitnami /home/bitnami/apps/wordpress/htdocs/WP_Setup.sh
sudo chmod 700 /home/bitnami/apps/wordpress/htdocs/WP_Setup.sh
sudo chown -R bitnami:daemon ~/apps/wordpress/htdocs
/home/bitnami/apps/wordpress/htdocs/WP_Setup.sh
```
