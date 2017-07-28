#! /usr/bin/env python
# -*- coding: utf-8 -*-
import json
import cgi

f = file("/usr/local/shadowsocksr/mudb.json");
json = json.load(f);

# 接受表达提交的数据
form = cgi.FieldStorage() 

# 解析处理提交的数据
getport = form['port'].value

#判断端口是否找到
portexist=0

#循环查找端口
for x in json:
	#当输入的端口与json端口一样时视为找到
	if(str(x[u"port"]) == str(getport)):
		portexist=1
		transfer_enable_int = int(x[u"transfer_enable"])/1024/1024;
		d_int = int(x[u"d"])/1024/1024;
		transfer_unit = "MB"
		d_unit = "MB"

		#流量单位转换
		if(transfer_enable_int > 1024):
			transfer_enable_int = transfer_enable_int/1024
			transfer_unit = "GB"
		if(transfer_enable_int > 1024):
			d_int = d_int/1024
			d_unit = "GB"
		break

if(portexist==0):
	getport = "未找到此端口，请检查是否输入错误！"
	d_int = ""
	d_unit = ""
	transfer_enable_int = ""
	transfer_unit = ""







header = '''
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta content="IE=edge" http-equiv="X-UA-Compatible">
	<meta content="initial-scale=1.0, width=device-width" name="viewport">
	<title>流量查询</title>
	<!-- css -->
	<link href="../css/base.min.css" rel="stylesheet">

	<!-- favicon -->
	<!-- ... -->

	<!-- ie -->
    <!--[if lt IE 9]>
        <script src="../js/html5shiv.js" type="text/javascript"></script>
        <script src="../js/respond.js" type="text/javascript"></script>
    <![endif]-->
    
</head>
<body>
    <div class="content">
        <div class="content-heading">
            <div class="container">
                <h1 class="heading">&nbsp;&nbsp;流量查询</h1>
            </div>
        </div>
        <div class="content-inner">
            <div class="container">
'''


footer = '''
</div>
        </div>
    </div>
	<footer class="footer">
		<div class="container">
			<p>Function Club</p>
		</div>
	</footer>

	<script src="../js/base.min.js" type="text/javascript"></script>
</body>
</html>
'''


#打印返回的内容
print header
formhtml = '''

<div class="card-wrap">
					<div class="row">
						<div class="col-lg-3 col-md-4 col-sm-6">
							<div class="card card-alt card-alt-bg">
								<div class="card-main">
									<div class="card-inner">
										<p class="card-heading">端口：%s</p>
										<p>
											已使用流量：%s %s <br>
											总流量限制：%s %s </br></br>
											<a href="../index.html"><button class="btn" type="button">返回</button></a>
										</p>
									</div>
								</div>
							</div>
						</div>
						
					</div>
				</div>



'''
print formhtml % (getport,d_int,d_unit,transfer_enable_int,transfer_unit)

print footer
f.close();

