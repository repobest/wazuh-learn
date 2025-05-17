# Ubuntu/Debian installation script for Wazuh agent
wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.11.2-1_amd64.deb && sudo WAZUH_MANAGER='10.0.0.1' WAZUH_AGENT_GROUP='default' WAZUH_AGENT_NAME='Ubuntu' dpkg -i ./wazuh-agent_4.11.2-1_amd64.deb

# RHEL/CentOS installation script for Wazuh agent
curl -o wazuh-agent-4.11.2-1.x86_64.rpm https://packages.wazuh.com/4.x/yum/wazuh-agent-4.11.2-1.x86_64.rpm && sudo WAZUH_MANAGER='10.0.0.1' WAZUH_AGENT_GROUP='default' WAZUH_AGENT_NAME='RedHat' rpm -ihv wazuh-agent-4.11.2-1.x86_64.rpm

# Enable and start the Wazuh agent service
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent

