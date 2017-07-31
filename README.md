# SSR多用户管理脚本（基于官方mujson版本）
[![Build Status](https://travis-ci.org/Readour/AR-B-P-B.svg?branch=master)](https://travis-ci.org/Readour/AR-B-P-B)
## 介绍 ##

一个Shell脚本，集成SSR多用户管理，流量限制，加密更改等基本操作。是一个基于ShadowsocksR官方的mujson的辅助脚本。方便用户操作，并且支持快速构建SSR服务环境。

- 请谨慎使用，出问题概不负责！！！！

## 备份日志 ##
- 2017-7-30

## 系统支持 ##
* Ubuntu 14
* Ubuntu 16
* Debian 7
* Debian 8
* CentOS 6
* CentOS 7

## 功能 ##
- 一键开启、关闭SSR服务
- 添加、删除、修改用户端口和密码
- 自由限制用户端口流量使用及端口网速
- 自动修改防火墙规则
- 自助修改SR加密方式、协议、混淆等参数
- 自动统计，方便查询每个用户端口的流量使用情况
- 自动安装Libsodium库以支持Chacha20等加密方式

## 缺点 ##
- 无法删除最后一名用户（官方限制）
- 未设置开机启动

## 安装 ##
    wget -N --no-check-certificate https://raw.githubusercontent.com/Readour/AR-B-P-B/master/install.sh && bash install.sh

## 自检 ##
    wget -N --no-check-certificate https://raw.githubusercontent.com/Readour/AR-B-P-B/master/self-check.sh && bash self-check.sh
