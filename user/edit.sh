#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#Check Root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }

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
echo "${CFAILURE}Does not support this OS, Please contact the author! ${CEND}"
kill -9 $$
fi

echo "1.使用用户名"
echo "2.使用端口"
echo ""
while :; do echo
	read -p "请选择： " lsid
	if [[ ! $lsid =~ ^[1-2]$ ]]; then
		echo "输入错误! 请输入正确的数字!"
	else
		break	
	fi
done
if [[ $lsid == 1 ]];then
	read -p "输入用户名： " uid
	cd /usr/local/shadowsocksr
	python mujson_mgr.py -l -u $uid
fi
if [[ $lsid == 2 ]];then
	read -p "输入端口号： " uid
	cd /usr/local/shadowsocksr
	python mujson_mgr.py -l -p $uid
fi

echo "1.修改密码"
echo "2.修改加密"
echo "3.修改协议"
echo "4.修改混淆"
echo "5.修改协议参数"
echo "6.修改混淆参数"
echo "7.修改流量"
echo "8.修改端口限制"
echo "9.修改总端口限速"

while :; do echo
	read -p "请选择： " ec
	if [[ ! $ec =~ ^[1-9]$ ]]; then
		echo "输入错误! 请输入正确的数字!"
	else
		break	
	fi
done

if [[ $ec == 1 ]];then
	read -p "输入密码： " upass
	cd /usr/local/shadowsocksr
	if [[ $lsid == 1 ]];then
		cd /usr/local/shadowsocksr
		python mujson_mgr.py -e -u $uid -k $upass
		echo "用户名为 $uid 的用户密码已设置成 $upass"
	fi
	if [[ $lsid == 2 ]];then
		cd /usr/local/shadowsocksr
		python mujson_mgr.py -e -p $uid -k $upass
		echo "端口号为 $uid 的用户密码已设置成 $upass"
	fi
fi
if [[ $ec == 2 ]];then
	echo "加密方式"
	echo '1.none'
	echo '2.aes-128-cfb'
	echo '3.aes-256-cfb'
	echo '4.aes-128-ctr'
	echo '5.aes-256-ctr'
	echo '6.rc4-md5'
	echo '7.chacha20'
	echo '8.chacha20-ietf'
	echo '9.salsa20'
	while :; do echo
		read -p "输入新加密方式： " um
		if [[ ! $um =~ ^[1-9]$ ]]; then
			echo "输入错误! 请输入正确的数字!"
		else
			break	
		fi
	done
	
	if [[ $um == 1 ]];then
		um1="none"
	fi
	if [[ $um == 2 ]];then
		um1="aes-128-cfb"
	fi
	if [[ $um == 3 ]];then
		um1="aes-256-cfb"
	fi
	if [[ $um == 4 ]];then
		um1="aes-128-ctr"
	fi
	if [[ $um == 5 ]];then
		um1="aes-256-ctr"
	fi
	if [[ $um == 6 ]];then
		um1="rc4-md5"
	fi
	if [[ $um == 7 ]];then
		um1="chacha20"
	fi
	if [[ $um == 8 ]];then
		um1="chacha20-ietf"
	fi
	if [[ $um == 9 ]];then
		um1="salsa20"
	fi
	cd /usr/local/shadowsocksr
	if [[ $lsid == 1 ]];then
		cd /usr/local/shadowsocksr
		python mujson_mgr.py -e -u $uid -m $um1
		echo "用户名为 $uid 的加密方式已切换为 $um1"
	fi
	if [[ $lsid == 2 ]];then
		cd /usr/local/shadowsocksr
		python mujson_mgr.py -e -p $uid -m $um1
		echo "端口号为 $uid 的加密方式已切换为 $um1"
	fi
fi
if [[ $ec == 3 ]];then
	echo "协议方式"
	echo '1.origin'
	echo '2.auth_sha1_v4'
	echo '3.auth_aes128_md5'
	echo '4.auth_aes128_sha1'
	echo '5.verify_deflate'
	echo '6.auth_chain_a'
	while :; do echo
	read -p "输入协议方式： " ux
	if [[ ! $ux =~ ^[1-6]$ ]]; then
		echo "输入错误! 请输入正确的数字!"
	else
		break	
	fi
	done
	
	if [[ $ux == 2 ]];then
	while :; do echo
		read -p "是否兼容原版协议（y/n）： " ifprotocolcompatible
		if [[ ! $ifprotocolcompatible =~ ^[y,n]$ ]]; then
			echo "输入错误! 请输入y或者n!"
		else
			break
		fi
	done
	fi

	if [[ $ux == 1 ]];then
	ux1="origin"
	fi
	if [[ $ux == 2 ]];then
		ux1="auth_sha1_v4"
	fi
	if [[ $ux == 3 ]];then
		ux1="auth_aes128_md5"
	fi
	if [[ $ux == 4 ]];then
		ux1="auth_aes128_sha1"
	fi
	if [[ $ux == 5 ]];then
		ux1="verify_deflate"
	fi
	if [[ $ux == 6 ]];then
		ux1="auth_chain_a"
	fi

	if [[ $ifprotocolcompatible == y ]]; then
		ux1=${ux1}"_compatible"
	fi

	cd /usr/local/shadowsocksr
	if [[ $lsid == 1 ]];then
		cd /usr/local/shadowsocksr
		python mujson_mgr.py -e -u $uid -O $ux1
		echo "用户名为 $uid 的协议方式已更改为 $ux1"
	fi
	if [[ $lsid == 2 ]];then
		cd /usr/local/shadowsocksr
		python mujson_mgr.py -e -p $uid -O $ux1
		echo "端口号为 $uid 的协议方式已更改为 $ux1"
	fi
fi
if [[ $ec == 4 ]];then
	echo "混淆方式"
	echo '1.plain'
	echo '2.http_simple'
	echo '3.http_post'
	echo '4.tls1.2_ticket_auth'
	while :; do echo
	read -p "输入混淆方式： " uo
	if [[ ! $uo =~ ^[1-4]$ ]]; then
		echo "输入错误! 请输入正确的数字!"
	else
		break	
	fi
	done
	
	if [[ $uo != 1 ]];then
		while :; do echo
			read -p "是否兼容原版混淆（y/n）： " ifobfscompatible
			if [[ ! $ifobfscompatible =~ ^[y,n]$ ]]; then
				echo "输入错误! 请输入y或者n!"
			else
				break
			fi
		done
	fi

	if [[ $uo == 1 ]];then
		uo1="plain"
	fi
	if [[ $uo == 2 ]];then
		uo1="http_simple"
	fi
	if [[ $uo == 3 ]];then
		uo1="http_post"
	fi
	if [[ $uo == 4 ]];then
		uo1="tls1.2_ticket_auth"
	fi
	
	if [[ $ifobfscompatible == y ]]; then
		uo1=${uo1}"_compatible"
	fi
	
	cd /usr/local/shadowsocksr
	if [[ $lsid == 1 ]];then
		cd /usr/local/shadowsocksr
		python mujson_mgr.py -e -u $uid -o $uo1
		echo "用户名为 $uid 的混淆方式已更改为 $uo1"
	fi
	if [[ $lsid == 2 ]];then
		cd /usr/local/shadowsocksr
		python mujson_mgr.py -e -p $uid -o $uo1
		echo "端口号为 $uid 的混淆方式已更改为 $uo1"
	fi
fi
if [[ $ec == 5 ]];then
	read -p "输入协议参数： " ux2
	cd /usr/local/shadowsocksr
	if [[ $lsid == 1 ]];then
		cd /usr/local/shadowsocksr
		python mujson_mgr.py -e -u $uid -G $ux2
		echo "用户名为 $uid 的协议参数已更改为 $ux2"
	fi
	if [[ $lsid == 2 ]];then
		cd /usr/local/shadowsocksr
		python mujson_mgr.py -e -p $uid -G $ux2
		echo "端口号为 $uid 的协议参数已更改为 $ux2"
	fi
fi
if [[ $ec == 6 ]];then
	read -p "输入混淆参数： " uo2
	cd /usr/local/shadowsocksr
	if [[ $lsid == 1 ]];then
		cd /usr/local/shadowsocksr
		python mujson_mgr.py -e -u $uid -g $uo2
		echo "用户名为 $uid 的混淆参数已更改为 $uo2"
	fi
	if [[ $lsid == 2 ]];then
		cd /usr/local/shadowsocksr
		python mujson_mgr.py -e -p $uid -g $uo2
		echo "端口号为 $uid 的混淆参数已更改为 $uo2"
	fi
fi
if [[ $ec == 7 ]];then	
	while :; do echo
		read -p "输入流量限制(只需输入数字，单位：GB)： " ut
		if [[ "$ut" =~ ^(-?|\+?)[0-9]+(\.?[0-9]+)?$ ]];then
			break
		else
			echo 'Input Error! Please Try Again!'
		fi
	done
	cd /usr/local/shadowsocksr
	if [[ $lsid == 1 ]];then
		cd /usr/local/shadowsocksr
		python mujson_mgr.py -e -u $uid -t $ut
		echo "用户名为 $uid 的流量限制已改为 $ut"
	fi
	if [[ $lsid == 2 ]];then
		cd /usr/local/shadowsocksr
		python mujson_mgr.py -e -p $uid -t $ut
		echo "端口号为 $uid 的流量限制已改为 $ut"
	fi
fi
if [[ $ec == 8 ]];then
	read -p "输入端口限制（如1~80和90~100输入"1-80,90-100"）： " ub
	cd /usr/local/shadowsocksr
	if [[ $lsid == 1 ]];then
		cd /usr/local/shadowsocksr
		#python mujson_mgr.py -e -u $uid -f $ub
		echo "此功能目前无法使用"
	fi
	if [[ $lsid == 2 ]];then
		cd /usr/local/shadowsocksr
		#python mujson_mgr.py -e -p $uid -f $ub
		echo "此功能目前无法使用"
	fi
fi

if [[ $ec == 9 ]];then
	while :; do echo
		read -p "输入端口总限速(只需输入数字，单位：KB/s)： " us
		if [[ "$us" =~ ^(-?|\+?)[0-9]+(\.?[0-9]+)?$ ]];then
	   		break
		else
	   		echo 'Input Error!'
		fi
	done
	cd /usr/local/shadowsocksr
	if [[ $lsid == 1 ]];then
		cd /usr/local/shadowsocksr
		python mujson_mgr.py -e -u $uid -S $us
		echo "用户名为 $uid 的用户端口限速已修改为 $us KB/s"
	fi
	if [[ $lsid == 2 ]];then
		cd /usr/local/shadowsocksr
		python mujson_mgr.py -e -p $uid -S $us
		echo "端口号为 $uid 的用户端口限速已修改为 $us KB/s"
	fi
fi