# Backup Config file
#+ and clear comment in config file

sed -i.bak "/^\s*[#;]/d;/^$/d" $1
