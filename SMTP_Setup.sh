SES_region="us-west-2"
SES_user=""
SES_pass=""

#Configure Mail SMTP
wp option patch insert wp_mail_smtp mail from_email "support@$domain_name" && \
wp option patch insert wp_mail_smtp mail from_name "$client" && \
wp option patch insert wp_mail_smtp mail mailer "smtp" && \
wp option patch insert wp_mail_smtp mail from_email_force "false" && \
wp option patch insert wp_mail_smtp smtp host "email-smtp.$SES_region.amazonaws.com" && \
wp option patch insert wp_mail_smtp smtp user "$SES_user" && \
wp option patch insert wp_mail_smtp smtp pass "$SES_pass" && \
wp option patch insert wp_mail_smtp smtp encryption "tls" && \
wp option patch insert wp_mail_smtp smtp port "587"