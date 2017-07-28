# -*- coding:utf-8 -*-  
import json

f = file("/usr/local/shadowsocksr/mudb.json");

json = json.load(f);

print "用户名\t端口\t已用流量\t流量限制"

for x in json:
  #Convert Unit To MB
  transfer_enable_int = int(x[u"transfer_enable"])/1024/1024;
  d_int = int(x[u"d"])/1024/1024;
  transfer_unit = "MB"
  d_unit = "MB"

  #Convert Unit To GB For Those Number Which Exceeds 1024MB
  if(transfer_enable_int > 1024):
  	transfer_enable_int = transfer_enable_int/1024
  	transfer_unit = "GB"
  if(transfer_enable_int > 1024):
  	d_int = d_int/1024
  	d_unit = "GB"

  #Print In Format
  print "%s\t%s\t%d%s\t\t%d%s" %(x[u"user"],x[u"port"],d_int,d_unit,transfer_enable_int,transfer_unit)

f.close();

