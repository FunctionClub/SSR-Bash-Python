#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
#Check Root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }

#Delete Files
rm -rf /usr/local/SSR-Bash-Python
echo '已删除控制脚本'
rm -rf /usr/local/shadowsocksr
echo '已删除服务脚本'
rm -rf /usr/local/bin/ssr
echo '已删除全部脚本！感谢您的支持'
