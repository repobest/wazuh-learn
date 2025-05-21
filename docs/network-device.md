# 1 Configuration Ubuntu endpoint

Rsyslog is a preinstalled utility in Ubuntu 22.04 for receiving syslog events. The following section shows the steps for enabling Rsyslog on the Ubuntu endpoint and configuring the Wazuh agent to send the syslog log data to the Wazuh server.

1. Paste the following code snippet at the bottom of the /etc/rsyslog.conf file on the Ubuntu endpoint. This code enables the UDP port 514 to listen for syslogs and adds a location to store the security events:
```sh
$ModLoad imudp
$UDPServerRun 514
#Storing Messages from a Remote System into a specific File
if $fromhost-ip startswith '<YOUR_MIKROTIK_IP_ADDRESS>' then /var/log/mikrotik.log
& ~

Replace <YOUR_MIKROTIK_IP_ADDRESS> with the IP address of the MikroTik device.
```
2. Create the mikrotik.log file in the /var/log directory to store the syslog events:
```sh
touch /var/log/mikrotik.log
```
3. Change the file ownership for the /var/log/mikrotik.log file to syslog and group to adm:
```sh
chown syslog:adm /var/log/mikrotik.log
```
4. Restart the rsyslog utility for the changes to take effect:
```sh
systemctl restart rsyslog
```
5. Paste the following within the <ossec_config> block of the Wazuh agent /var/ossec/etc/ossec.conf configuration file.
```sh
<localfile>
  <log_format>syslog</log_format>
  <location>/var/log/mikrotik.log</location>
  <out_format>RouterOS7.1-logs: $(log)</out_format>
</localfile>
```
6. Restart the Wazuh agent to apply the changes:
```sh
systemctl restart wazuh-agent
```

# 2 MikroTik configuration

In this scenario, we configure the MikroTik router to send syslog messages remotely to the Wazuh agent using port 514. Perform the following configuration using the MikroTik Winbox tool on a Windows operating system or the WebUI using the MikroTik device IP address.
```sh
/system logging action
set 3 remote=<YOUR_AGENT_WAZUH_IP_ADDRESS> remote-log-format=syslog syslog-severity=emergency
/system logging
set 0 action=remote
set 1 action=remote
set 2 action=remote
set 3 action=remote
```

# 3 Wazuh server

We create custom decoders and rules to extract the necessary fields from the MikroTik syslog and generate alerts based on their relevance. Follow the steps below to create custom rules and decoders in the Wazuh server.
MikroTik decoders

1. Create a custom decoder file mikrotik_decoders.xml in the /var/ossec/etc/decoders/ directory.
2. Add the custom MikroTik decoders below to the /var/ossec/etc/decoders/mikrotik_decoders.xml file:
```sh
<decoder name="mikrotik">
  <prematch>^RouterOS7.1-logs: </prematch>
</decoder>
<decoder name="mikrotik1">
  <parent>mikrotik</parent>
  <regex type="pcre2">\S+ (\w+ \d+ \d+:\d+:\d+) MikroTik user (\S+) (.*?) from (\d+.\d+.\d+.\d+) via (\w+)</regex>
  <order>logtimestamp, logged_user, action, ip_address, protocol</order>
</decoder>
<decoder name="mikrotik1">
  <parent>mikrotik</parent>
  <regex type="pcre2">\S+ (\w+ \d+ \d+:\d+:\d+) MikroTik dhcp-client on (\S+) (.*?) address (\d+.\d+.\d+.\d+)</regex>
  <order>logtimestamp, interface, action, ip_address</order>
</decoder>
<decoder name="mikrotik1">
  <parent>mikrotik</parent>
  <regex type="pcre2">\S+ (\w+ \d+ \d+:\d+:\d+) MikroTik router (\S+)</regex>
  <order>logtimestamp, action</order>
</decoder>
```
3. Save the decoder and restart the Wazuh manager.
```sh
systemctl restart wazuh-manager
```

## MikroTik rules

1. Create a custom rule file mikrotik_rules.xml in the /var/ossec/etc/rules/ directory.

2. Add the custom MikroTik rules below to the /var/ossec/etc/rules/mikrotik_rules.xml file.
<group name="Mikrotik,">
  <rule id="110000" level="0">
    <decoded_as>mikrotik</decoded_as>
    <description>Mikrotik-Event</description>
  </rule>
  <rule id="110001" level="5">
    <if_sid>110000</if_sid>
    <match>dhcp-client on ether</match>
    <description>MikroTik dhcp-client received an IP address $(ip_address)</description>
  </rule>
  <rule id="110002" level="5">
    <if_sid>110000</if_sid>
    <match>rebooted</match>
    <description>MikroTik router rebooted</description>
  </rule>
  <rule id="110003" level="5">
    <if_sid>110000</if_sid>
    <match>logged out from</match>
    <description>MikroTik user logged out via $(protocol)</description>
  </rule>
  <rule id="110004" level="5">
    <if_sid>110000</if_sid>
    <match>logged in from</match>
    <description>MikroTik user logged in from $(ip_address) via $(protocol)</description>
  </rule>
</group>

Where:

    Rule ID 110000 is triggered when Wazuh detects a new MikroTik event
    Rule ID 110001 is triggered when Wazuh detects an IP address has been received by the MikroTik device using the dhcp-client protocol
    Rule ID 110002 is triggered when Wazuh detects the MikroTik device has been rebooted
    Rule ID 110003 is triggered when Wazuh detects a MikroTik user has logged out
    Rule ID 110004 is triggered when Wazuh detects a MikroTik user has logged in

3. Save the rule and restart the Wazuh manager.
```sh
systemctl restart wazuh-manager
```

## Use case

The following use case generates alerts on the Wazuh dashboard when certain events match the above rules. We performed a successful SSH login and rebooted the MikroTik router to generate the events.

1. Run the following commands from any endpoint within the same network as the MikroTik router:
```sh
$ ssh <MIKROTIK_USER>@<MIKROTIK_IP_ADDRESS>
> /system/reboot
```
Replace:

    <MIKROTIK_USER> with the username of the account used for administration on the Mikrotik device.
    <MIKROTIK_IP_ADDRESS> with the IP address of the MikroTik device.

2. Navigate to the Security events page of your Ubuntu endpoint on your Wazuh dashboard. The image below shows the alerts generated for the above actions.