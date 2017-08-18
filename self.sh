#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#Check Root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }

#Main
updateme(){
	cd ~
	if [[ -e ~/version.txt ]];then
		rm -f ~/version.txt
	fi
	wget -q https://raw.githubusercontent.com/Readour/AR-B-P-B/master/version.txt
	version1=`cat ~/version.txt`
	version2=`cat /usr/local/SSR-Bash-Python/version.txt`
	if [[ "$version1" == "$version2" ]];then
		echo "你当前已是最新版"
		sleep 2s
		ssr
	else
		echo "当前最新版本为$version1,输入y进行更新，其它按键退出"
		read -n 1 yn
		if [[ $yn == [Yy] ]];then
			wget -q -N --no-check-certificate https://raw.githubusercontent.com/Readour/AR-B-P-B/master/install.sh && bash install.sh
			sleep 3s
			clear
			ssr || exit 0
		else
			echo "输入错误，退出"
			bash /usr/local/SSR-Bash-Python/self.sh
		fi
	fi
}
sumdc(){
	sum1=`cat /proc/sys/kernel/random/uuid| cksum | cut -f1 -d" "|head -c 2`
	sum2=`cat /proc/sys/kernel/random/uuid| cksum | cut -f1 -d" "|head -c 1`
	solve=`echo "$sum1-$sum2"|bc`
	echo -e "请输入\e[32;49m $sum1-$sum2 \e[0m的运算结果,表示你已经确认,输入错误将退出"
	read sv
}

#Show
echo "输入数字选择功能："
echo ""
echo "1.检查更新"
echo "2.切换到开发版"
echo "3.程序自检"
echo "4.卸载程序"
while :; do echo
	read -p "请选择： " choice
	if [[ ! $choice =~ ^[1-4]$ ]]; then
		[ -z "$choice" ] && ssr && break
		echo "输入错误! 请输入正确的数字!"
	else
		break	
	fi
done

if [[ $choice == 1 ]];then
	updateme
fi
if [[ $choice == 2 ]];then
	echo "切换到开发版之后你将面临一些奇怪的问题"
	sumdc
	if [[ "$sv" == "$solve" ]];then
		wget -q -N --no-check-certificate https://raw.githubusercontent.com/Readour/AR-B-P-B/master/install.sh && bash install.sh develop
		sleep 3s
		clear
		ssr || exit 0
	else
		echo "计算错误，正确结果为$solve"
		bash /usr/local/SSR-Bash-Python/self.sh
	fi
fi
if [[ $choice == 3 ]];then
	bash /usr/local/SSR-Bash-Python/self-check.sh
fi
if [[ $choice == 4 ]];then
	echo "你在做什么？你真的这么狠心吗？"
	sumdc
	if [[ "$sv" == "$solve" ]];then
		wget -q -N --no-check-certificate https://raw.githubusercontent.com/Readour/AR-B-P-B/master/install.sh && bash install.sh uninstall
		exit 0
	else
		echo "计算错误，正确结果为$solve"
		bash /usr/local/SSR-Bash-Python/self.sh
	fi
fi
exit 0
