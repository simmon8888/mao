#!/bin/bash

# 停止并删除已存在的容器
if [ "$(docker ps -q -f name=aliyundrive-subscribe)" ]; then
    docker stop aliyundrive-subscribe
fi
if [ "$(docker ps -qa -f name=aliyundrive-subscribe)" ]; then
    docker rm aliyundrive-subscribe
fi

# 拉取最新版本的镜像
docker pull looby/aliyundrive-subscribe:latest

# 下载配置文件
config_dir=/etc/aliyundrive-subscribe/conf
config_file=$config_dir/app.ini
mkdir -p "$config_dir"
if [ ! -f "$config_file" ]; then
    curl -sSL -o "$config_file" https://raw.githubusercontent.com/kebedd69/mao/main/app.ini \
        || { echo "无法下载配置文件，请手动从 GitHub 下载并将其保存到 $config_file"; exit 1; }
fi

# 运行新容器，并使用安全设置
docker run -d --name aliyundrive-subscribe --restart always -p 8002:8002 -u 1000:1000 -v /etc/aliyundrive-subscribe/conf:/app/conf looby/aliyundrive-subscribe:latest