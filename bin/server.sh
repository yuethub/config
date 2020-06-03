#!/bin/bash
###################################################################### 
# 本文件用于Ubuntu20.04服务器搭建，运行该脚本可以完成基本设置        # 
######################################################################

# @brief 获得由N个相同字符组成的字符串
# @param $1 传入的字符
# @param $2 字符的数量
getNChar()
{
    local str=""
    for i in $(seq 1 $2)
    do        
        str="${str}$1"
    done
    echo "$str"
    unset i
    unset str
}

# @brief 打印提示信息
# @param 提示信息
printPrompt()
{
    local -x default_width=60
    local str=$1
    local -x str_width=${#str}
    if [ $str_width -le $[ $default_width - 6 ] ]; then
        local -x width=${default_width}
    else
        local -x width=$[ $str_width + 6 ]
    fi
    printf "\033[0;32m"
    local tbLine=$(getNChar "#" $width)
    printf "  $tbLine\n"

    local midLine="#"
    local spacer="$(getNChar ' ' $[ (width - 2 - str_width) / 2])"
    midLine="${midLine}${spacer}${str}${spacer}"
    if [ $[ (width - str_width) % 2 ] -eq 1 ]; then
        midLine="${midLine} "
    fi
    midLine="${midLine}#"
    printf "  $midLine\n"
    printf "  $tbLine\n\n"
    printf "\033[0m"
    unset spacer
    unset midLine
    unset tbLine
    unset width
    unset str_width
    unset str
    unset default_width
}

# @brief 打印执行结果信息
# @param $1: 执行结果
printResult()
{
    if [ $1 != 0 ]; then
        printf "  \033[1;31mError\033[0m: The program  will exit.\n"        
        return 1
    else
        printf "  \033[1;32mSuccessfully.\033[0m\n"
        return 0
    fi

}

# @brief 更新软件包信息
update()
{
    printPrompt "Update the package information from all configured sources"
    sudo apt update
    printResult $?
    if [ $? != 0 ]; then
        printf "  You can use 'sudo apt update' manually.\n"
        exit 1
    fi
}

# @brief 更新计算机上的所有软件
upgrade()
{
    printPrompt "Install available upgrades of all packages installed on the system"
    sudo apt upgrade
    if [ $? != 0 ]; then
        printf "  You can use 'sudo apt upgrade' manuallly.\n"
        exit 1
    fi
}

# @brief 更换Ubuntu软件源为华为源
changeUbuntuSource()
{
    printPrompt "change ubuntu source"
    if [ ! -f /etc/apt/sources.list.bak ]; then
        sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
    fi
    sudo sed -i "s/http:\/\/.*.archive.ubuntu.com/http:\/\/mirrors.huaweicloud.com/g" /etc/apt/sources.list

    sudo sed -i "s/http:\/\/.*security.ubuntu.com/http:\/\/mirrors.huaweicloud.com/g" /etc/apt/sources.list
    update
}

# @brief 更换Python源为华为源
changePythonSource()
{
    printPrompt "change python source"
    mkdir -p ~/.pip/
    echo "[global]" > ~/.pip/pip.conf
    echo "index-url = https://mirrors.huaweicloud.com/repository/pypi/simple" >> ~/.pip/pip.conf
    echo "trusted-host = mirrors.huaweicloud.com" >> ~/.pip/pip.conf
    echo "timeout = 120" >> ~/.pip/pip.conf
}


toInstall()
{
    printPrompt "install $1"
    if [ -n "$(dpkg -l | grep "$1")" ];then
        printf "  \033[1;33m$1 already exists in the system.\033[0m\n"
        return 0
    fi
    sudo apt install $1
    if [ $? != 0 ]; then
        printf "  \033[1;31mError while installing $1\033[0m: The program  will exit.\n"        
        printf "  You can use 'sudo apt install $1' manually.\n";
        exit 1
    else
        printf "  \033[1;32mSuccessfully installed $1.\033[0m\n"
    fi
}

installRos()
{
    echo "deb http://mirrors.ustc.edu.cn/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
    sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
    update
    toInstall "ros-noetic-desktop-full"
}

installVim()
{
    toInstall "vim-gtk3"
}

installVSFTPD()
{
    toInstall "vsftpd"
    sudo sed -i "s/#local_enable/local_enable/" /etc/vsftpd.conf
    sudo sed -i "s/#write_enable/wirte_enable/" /etc/vsftpd.conf
}

installSSH()
{
    toInstall "openssh-server"
    toInstall "openssh-client"
}

installXrdp()
{
    cd ~/下载/
    printPrompt "install xrdp"
    if [ -n "$(dpkg -l | grep "xrdp")" ]; then
        printf "  \033[1;33mxrdp already exists in the system.\033[0m\n\n"
        return 0
    fi
    wget https://www.c-nergy.be/downloads/xrdp-installer-1.2.zip
    unzip xrdp-installer-1.2.zip
    chmod a+x xrdp-installer-1.2.sh
    ./xrdp-installer-1.2.sh
    cd ~
}








changeUbuntuSource
changePythonSource
installVim
installRos
installVSFTPD
installSSH
installXrdp
exit 0



