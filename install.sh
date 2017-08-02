#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#Check Root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }
#Check OS
if [ -n "$(grep 'Aliyun Linux release' /etc/issue)" -o -e /etc/redhat-release ];then
    OS=CentOS
    [ -n "$(grep ' 7\.' /etc/redhat-release)" ] && CentOS_RHEL_version=7
    [ -n "$(grep ' 6\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release6 15' /etc/issue)" ] && CentOS_RHEL_version=6
    [ -n "$(grep ' 5\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release5' /etc/issue)" ] && CentOS_RHEL_version=5
elif [ -n "$(grep 'Amazon Linux AMI release' /etc/issue)" -o -e /etc/system-release ];then
    OS=CentOS
    CentOS_RHEL_version=6
elif [ -n "$(grep bian /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Debian' ];then
    OS=Debian
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Debian_version=$(lsb_release -sr | awk -F. '{print $1}')
elif [ -n "$(grep Deepin /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Deepin' ];then
    OS=Debian
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Debian_version=$(lsb_release -sr | awk -F. '{print $1}')
elif [ -n "$(grep Ubuntu /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Ubuntu' -o -n "$(grep 'Linux Mint' /etc/issue)" ];then
    OS=Ubuntu
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Ubuntu_version=$(lsb_release -sr | awk -F. '{print $1}')
    [ -n "$(grep 'Linux Mint 18' /etc/issue)" ] && Ubuntu_version=16
else
    echo "Does not support this OS, Please contact the author! "
    kill -9 $$
fi


#Get Current Directory
workdir=$(pwd)

#Install Basic Tools
if [ ! -e /usr/local/bin/ssr ];then
echo "开始部署"
sleep 2s
if [[ ${OS} == Ubuntu ]];then
	apt-get update
	apt-get install python -y
	apt-get install python-pip -y
	apt-get install git -y
	apt-get install language-pack-zh-hans -y
    apt-get install build-essential screen curl -y
fi
if [[ ${OS} == CentOS ]];then
	yum install python screen curl -y
	yum install python-setuptools -y && easy_install pip -y
	yum install git -y
    yum groupinstall "Development Tools" -y
fi
if [[ ${OS} == Debian ]];then
	apt-get update
	apt-get install python screen curl -y
	apt-get install python-pip -y
	apt-get install git -y
    apt-get install build-essential -y
fi
#Install Libsodium
cd $workdir
export LIBSODIUM_VER=1.0.11
wget https://github.com/jedisct1/libsodium/releases/download/1.0.11/libsodium-$LIBSODIUM_VER.tar.gz
tar xvf libsodium-$LIBSODIUM_VER.tar.gz
pushd libsodium-$LIBSODIUM_VER
./configure --prefix=/usr && make
make install
popd
ldconfig
cd $workdir && rm -rf libsodium-$LIBSODIUM_VER.tar.gz libsodium-$LIBSODIUM_VER
fi

#Install SSR and SSR-Bash
if [ -e /usr/local/bin/ssr ];then
	echo "开始更新"
	sleep 1s
	echo "正在清理老版本"
	rm -f /usr/local/bin/ssr
	rm -rf /usr/local/shadowsocksr
	rm -rf /usr/local/SSR-Bash-Python
	sleep 1s
	echo "开始部署"
fi
cd /usr/local
git clone https://github.com/Readour/shadowsocksr.git
git clone https://github.com/Readour/AR-B-P-B.git
mv AR-B-P-B SSR-Bash-Python
cd /usr/local/shadowsocksr
bash initcfg.sh

#Start when boot
if [[ ${OS} == Ubuntu || ${OS} == Debian ]];then
    cat >/etc/init.d/ssr-bash-python <<EOF
#!/bin/sh
### BEGIN INIT INFO
# Provides:          SSR-Bash_python
# Required-Start: $local_fs $remote_fs
# Required-Stop: $local_fs $remote_fs
# Should-Start: $network
# Should-Stop: $network
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description: SSR-Bash-Python
# Description: SSR-Bash-Python
### END INIT INFO
iptables-restore < /etc/iptables.up.rules
bash /usr/local/shadowsocksr/logrun.sh
EOF
    chmod 755 /etc/init.d/ssr-bash-python
    chmod +x /etc/init.d/ssr-bash-python
    cd /etc/init.d
    update-rc.d ssr-bash-python defaults 95
fi

if [[ ${OS} == CentOS ]];then
    echo "
iptables-restore < /etc/iptables.up.rules
bash /usr/local/shadowsocksr/logrun.sh
" > /etc/rc.d/init.d/ssr-bash-python
    chmod +x  /etc/rc.d/init.d/ssr-bash-python
    echo "/etc/rc.d/init.d/ssr-bash-python" >> /etc/rc.d/rc.local
    chmod +x /etc/rc.d/rc.local
fi

#Change CentOS7 Firewall
if [[ ${OS} == CentOS && $CentOS_RHEL_version == 7 ]];then
    systemctl stop firewalld.service
    systemctl disable firewalld.service
    yum install iptables-services -y
    cat << EOF > /etc/sysconfig/iptables
# sample configuration for iptables service
# you can edit this manually or use system-config-firewall
# please do not ask us to add additional ports/services to this default configuration
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
EOF
systemctl restart iptables.service
systemctl enable iptables.service
fi

#Install SSR-Bash Background
wget -N --no-check-certificate -O /usr/local/bin/ssr https://raw.githubusercontent.com/readour/AR-B-P-B/master/ssr
chmod +x /usr/local/bin/ssr

#Modify ShadowsocksR API
sed -i "s/sspanelv2/mudbjson/g" /usr/local/shadowsocksr/userapiconfig.py
sed -i "s/UPDATE_TIME = 60/UPDATE_TIME = 10/g" /usr/local/shadowsocksr/userapiconfig.py
sed -i "s/SERVER_PUB_ADDR = '127.0.0.1'/SERVER_PUB_ADDR = '$(wget -qO- -t1 -T2 ipinfo.io/ip)'/" /usr/local/shadowsocksr/userapiconfig.py
#INstall Success
read -p "输入与您主机绑定的域名: " ipname
echo "$ipname" > /usr/local/shadowsocksr/myip.txt
bash /usr/local/SSR-Bash-Python/self-check.sh
echo '安装完成！输入 ssr 即可使用本程序~'
echo '原作者已经停止本脚本服务，此版本为2017.7.30号的备份（带最新端口限速）'
echo '还好在作者删服务前备份了'
echo '谨慎使用！仅供研究！'
echo '谨慎使用！仅供研究！'
echo '谨慎使用！仅供研究！'