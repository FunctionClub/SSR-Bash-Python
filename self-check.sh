#/bin/sh
#Check Root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }
echo "##################################
      SSR-Bash-Python 自检系统
             V1.0 Alpha
           Author:Kirito
##################################"
#List /usr/local
echo "############Filelist of /usr/local" >> /root/report.json
cd /usr/local
ls >> /root/report.json
#List /usr/local/ssr-bash-python
echo "############Filelist of /usr/local/SSR-Bash-Python" >> /root/report.json
cd /usr/local/SSR-Bash-Python
ls >> /root/report.json
#List /usr/local/shadowsockr
echo "############Filelist of /usr/local/shadowsockr" >> /root/report.json
cd /usr/local/shadowsocksr
ls >> /root/report.json
echo "############File test">>/root/report.json
#Check File Exist
if [ ! -f "/usr/local/bin/ssr" ]; then
  echo "SSR-Bash-Python主文件缺失，请确认服务器是否成功连接至Github"
  echo "SSR Miss" >> /root/report.json
  exit
fi
if [ ! -f "/usr/local/SSR-Bash-Python/server.sh" ]; then
  echo "SSR-Bash-Python主文件缺失，请确认服务器是否成功连接至Github"
  echo "SSR Miss" >> /root/report.json
  exit
fi
if [ ! -f "/usr/local/shadowsocksr/stop.sh" ]; then
  echo "SSR主文件缺失，请确认服务器是否成功连接至Github"
  echo "SSR Miss" >> /root/report.json
  exit
fi

#Firewall
echo "############Firewall test" >> report.json
iptables -L >> /root/report.json

echo "检测完成，未发现严重问题，如仍有任何问题请提交report.json"
