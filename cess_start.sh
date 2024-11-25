#!/bin/bash

# 检查是否以root用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以root用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到root用户，然后再次运行此脚本。"
    exit 1
fi

echo "\$nrconf{kernelhints} = 0;" >> /etc/needrestart/needrestart.conf
echo "\$nrconf{restart} = 'l';" >> /etc/needrestart/needrestart.conf
source ~/.bashrc

# 检查 docker 是否已安装
if ! command -v docker &> /dev/null
then
  # 如果 docker 未安装，则进行安装
  echo "未检测到 docker，正在安装..."
  sudo apt update

  sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

  sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd


  # 验证 Docker Engine 安装是否成功
  sudo docker run hello-world
  # 应该能看到 hello-world 程序的输出

  # 检查 Docker Compose 版本
  docker-compose -v
else
    # 如果 docker 已安装，则不做任何操作
    echo "docker 已安装。"
fi


# 检查 Git 是否已安装
if ! command -v git &> /dev/null
then
    # 如果 Git 未安装，则进行安装
    echo "未检测到 Git，正在安装..."
    sudo apt install git -y
else
    # 如果 Git 已安装，则不做任何操作
    echo "Git 已安装。"
fi

# 安装cess节点
wget https://github.com/CESSProject/cess-nodeadm/archive/v0.5.7.tar.gz
tar -xvzf v0.5.7.tar.gz
cd cess-nodeadm-0.5.7/
./install.sh
