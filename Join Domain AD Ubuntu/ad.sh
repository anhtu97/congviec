sudo apt-get install -y realmd sssd sssd-tools samba krb5-user packagekit adcli ntp
echo """
# /etc/ntp.conf, configuration for ntpd; see ntp.conf(5) for help

driftfile /var/lib/ntp/ntp.drift

# Leap seconds definition provided by tzdata
leapfile /usr/share/zoneinfo/leap-seconds.list

# Enable this if you want statistics to be logged.
#statsdir /var/log/ntpstats/

statistics loopstats peerstats clockstats
filegen loopstats file loopstats type day enable
filegen peerstats file peerstats type day enable
filegen clockstats file clockstats type day enable

# Specify one or more NTP servers.

# Use servers from the NTP Pool Project. Approved by Ubuntu Technical Board
# on 2011-02-08 (LP: #104525). See http://www.pool.ntp.org/join.html for
# more information.
pool 0.ubuntu.pool.ntp.org iburst
pool 1.ubuntu.pool.ntp.org iburst
pool 2.ubuntu.pool.ntp.org iburst
pool 3.ubuntu.pool.ntp.org iburst


#server 0.ubuntu.pool.ntp.org
#server 1.ubuntu.pool.ntp.org
#server 2.ubuntu.pool.ntp.org
#server 3.ubuntu.pool.ntp.org
server tpssoft.com.vn


# Use Ubuntu's ntp server as a fallback.
pool ntp.ubuntu.com

# Access control configuration; see /usr/share/doc/ntp-doc/html/accopt.html for
# details.  The web page <http://support.ntp.org/bin/view/Support/AccessRestrictions>
# might also be helpful.
#
# Note that 'restrict' applies to both servers and clients, so a configuration
# that might be intended to block requests from certain clients could also end
# up blocking replies from your own upstream servers.

# By default, exchange time with everybody, but don't allow configuration.
restrict -4 default kod notrap nomodify nopeer noquery limited
restrict -6 default kod notrap nomodify nopeer noquery limited

# Local users may interrogate the ntp server more closely.
restrict 127.0.0.1
restrict ::1

# Needed for adding pool entries
restrict source notrap nomodify noquery

# Clients from this (example!) subnet have unlimited access, but only if
# cryptographically authenticated.
#restrict 192.168.123.0 mask 255.255.255.0 notrust


# If you want to provide time to your local subnet, change the next line.
# (Again, the address is an example only.)
#broadcast 192.168.123.255

# If you want to listen to time broadcasts on your local subnet, de-comment the
# next lines.  Please do this only if you trust everybody on the network!
#disable auth
#broadcastclient

#Changes recquired to use pps synchonisation as explained in documentation:
#http://www.ntp.org/ntpfaq/NTP-s-config-adv.htm#AEN3918

#server 127.127.8.1 mode 135 prefer    # Meinberg GPS167 with PPS
#fudge 127.127.8.1 time1 0.0042        # relative to PPS for my hardware

#server 127.127.22.1                   # ATOM(PPS)
#fudge 127.127.22.1 flag3 1            # enable PPS API
"""> /etc/ntp.conf

systemctl restart ntp


echo """
[users]
    default-home = /home/
U
    default-shell = /bin/bash
[active-directory]
    default-client = sssd
    os-name = Ubuntu Server
    os-version = 18.10
[service]
    automatic-install = no
[wilderness.net]
    fully-qualified-names = no
    automatic-id-mapping = yes
    user-principal = yes
    manage-system = no
""" >  /etc/realmd.conf


sudo systemctl restart ntp realmd

read -p "- Nhap user de join domain:" user
echo "- Nhap password account de join domain!!!!!!!!!!!!"
sudo realm --verbose join tpssoft.com.vn --user=$user

echo """
#
# /etc/pam.d/common-session - session-related modules common to all services
#
# This file is included from other service-specific PAM config files,
# and should contain a list of modules that define tasks to be performed
# at the start and end of sessions of *any* kind (both interactive and
# non-interactive).
#
# As of pam 1.0.1-6, this file is managed by pam-auth-update by default.
# To take advantage of this, it is recommended that you configure any
# local modules either before or after the default block, and use
# pam-auth-update to manage selection of other modules.  See
# pam-auth-update(8) for details.

# here are the per-package modules (the 'Primary' block)
session	[default=1]			pam_permit.so
# here's the fallback if no module succeeds
session	requisite			pam_deny.so
# prime the stack with a positive return value if there isn't one already;
# this avoids us returning an error just because nothing sets a success code
# since the modules above will each just jump around
session	required			pam_permit.so
# The pam_umask module will set the umask according to the system default in
# /etc/login.defs and user settings, solving the problem of different
# umask settings with different shells, display managers, remote sessions etc.
# See 'man pam_umask'.
session optional			pam_umask.so
# and here are more per-package modules (the 'Additional' block)
session	required	pam_unix.so 
session	optional			pam_sss.so 
session	optional	pam_systemd.so 
# end of pam-auth-update config
# Create new user home dir
session required pam_mkhomedir.so skel=/etc/skel/ umask=0077
"""> /etc/pam.d/common-session

echo """
[sssd]
domains = tpssoft.com.vn
config_file_version = 2
services = nss, pam

[domain/tpssoft.com.vn]
ad_domain = tpssoft.com.vn
krb5_realm = TPSSOFT.COM.VN
realmd_tags = manages-system joined-with-adcli 
cache_credentials = True
id_provider = ad
krb5_store_password_if_offline = True
default_shell = /bin/bash
ldap_sasl_authid = UBUNTU-HCM-DKP-$
ldap_id_mapping = True
use_fully_qualified_names = True
fallback_homedir = /home/
u@
d
access_provider = ad
ad_gpo_access_control=permissive
""">/etc/sssd/sssd.conf
systemctl restart sssd