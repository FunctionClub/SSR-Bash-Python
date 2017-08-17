#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#Check Root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }

echo "1.使用用户名"
echo "2.使用端口"
echo ""
while :; do echo
	read -p "请选择： " lsid
	if [[ ! $lsid =~ ^[1-2]$ ]]; then
		if [[ $lsid == "" ]]; then
			bash /usr/local/SSR-Bash-Python/user.sh || exit 0
		fi
		echo "输入错误! 请输入正确的数字!"
	else
		break	
	fi
done
if [[ $lsid == 1 ]];then
	read -p "输入用户名： " uid
	cd /usr/local/shadowsocksr
	python mujson_mgr.py -d -u $uid
	echo "已成功删除用户名为 $uid 的用户流量"
fi
if [[ $lsid == 2 ]];then
	read -p "输入端口号： " uid
	cd /usr/local/shadowsocksr
	python mujson_mgr.py -d -p $uid
	echo "已成功删除端口号为 $uid 的用户流量"
fi
