## SELinux
sed -i s/^SELINUX=.*$/SELINUX=permissive/ /etc/selinux/config; setenforce 0

## Firewalld
systemctl disable --now firewalld

## Libvirtd
systemctl restart libvirtd
systemctl enable --now libvirtd