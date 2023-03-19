#!/bin/sh

# 检查是否有更新的镜像可用
if [ "$(docker pull xiaoyaliu/alist:latest 2>&1 | grep -c 'Downloaded newer image')" -eq 0 ]; then
    echo "远程镜像没有更新 无需更新"
    exit
fi

# 停止并移除现有容器
docker stop xiaoya
docker rm xiaoya

# 如果存在，则删除旧的令牌文件
if [ -f /etc/xiaoya/mytoken.txt ]; then
    rm -rf /etc/xiaoya/mytoken.txt
fi

# 创建必要的目录和文件
mkdir -p /etc/xiaoya
touch /etc/xiaoya/mytoken.txt
touch /etc/xiaoya/pikpak.txt
touch /etc/xiaoya/guestpass.txt
touch /etc/xiaoya/myopentoken.txt
touch /etc/xiaoya/temp_transfer_folder_id.txt

# 检查必要的文件是否存在且不为空
if [[ ! -s /etc/xiaoya/mytoken.txt ]] || [[ ! -s /etc/xiaoya/myopentoken.txt ]] || [[ ! -s /etc/xiaoya/temp_transfer_folder_id.txt ]]; then
    echo -e "请配置三个必须文件后再执行安装: \n/etc/xiaoya/mytoken.txt \n/etc/xiaoya/myopentoken.txt \n/etc/xiaoya/temp_transfer_folder_id.txt \n安装停止，请参考指南配置文件\nhttps://xiaoyaliu.notion.site/xiaoya-docker-69404af849504fa5bcf9f2dd5ecaa75f \n"
    exit
fi

# 使用最新的镜像运行新的容器
docker run -d -p 5678:80 -v /etc/xiaoya:/data --restart=always --name=xiaoya xiaoyaliu/alist:latest
echo "xiaoya 镜像已更新并重启成功！"