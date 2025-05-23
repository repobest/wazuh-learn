# FreeBSD 14.2 or latest
# Wazuh Agent was installed
sed -e "s|quarterly|latest|g" -i.bak /etc/pkg/FreeBSD.conf

# 1) Copy /etc/locatime to /var/ossec/etc directory
cp /etc/localtime /var/ossec/etc

# 2) You must edit /var/ossec/etc/ossec.conf.sample for your setup and rename/copy it to ossec.conf
cp /var/ossec/etc/ossec.conf.sample /var/ossec/etc/ossec.conf
# Take a look wazuh configuration at the following url: https://documentation.wazuh.com/current/user-manual/index.html

# 3) Move /var/ossec/etc/client.keys.sample to /var/ossec/etc/client.keys. This file is used to store agent credentials
mv /var/ossec/etc/client.keys.sample /var/ossec/etc/client.keys

# 4) You can find additional useful files installed at /var/ossec/packages_files/agent_installation_scripts

# 5) FreeBSD SCA files are installed by default to the following directory: /var/ossec/packages_files/agent_installation_scripts/sca/freebsd
# For more information about FreeBSD SCA updates take a look at: https://github.com/alonsobsd/wazuh-freebsd

# 6) Add Wazuh agent to /etc/rc.conf
sysrc wazuh_agent_enable="YES"
# or
service wazuh-agent enable

# 7) Start Wazuh agent
service wazuh-agent start
