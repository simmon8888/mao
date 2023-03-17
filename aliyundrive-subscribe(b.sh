docker stop aliyundrive-subscribe
docker rm aliyundrive-subscribe
docker pull looby/aliyundrive-subscribe:latest
echo "检测是否存在app.ini文件"
if [ -f "/etc/aliyundrive-subscribe/conf/app.ini" ];then
    echo "存在app.ini文件，跳过"
else
    echo "不存在app.ini文件，下载文件"
    wget -P /etc/aliyundrive-subscribe/conf https://ghproxy.com/https://raw.githubusercontent.com/kebedd69/mao/main/app.ini
fi
# wget -P /etc/aliyundrive-subscribe/conf/ http://upup.run.goorm.io/app.ini
docker run -d -p 8002:8002 -v /etc/aliyundrive-subscribe/conf:/app/conf --restart=always --name=aliyundrive-subscribe looby/aliyundrive-subscribe:latest
