#!/usr/bin/env bash
set -o errexit

source /tmp/__common-lib.sh

main() {
  export DEBIAN_FRONTEND='noninteractive'
  call_build_function func_name="__resolvconf_install"
}

__resolvconf_install() {
  systemctl stop systemd-resolved
  systemctl mask systemd-resolved
  rm -f "/etc/resolv.conf"
  touch "/etc/resolv.conf"
  chmod 644 "/etc/resolv.conf"
  call_build_function func_name="__resolvconf_get_content" >> "/etc/resolv.conf"
}

__resolvconf_get_content(){
  echo "options rotate
options timeout:1

nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 1.1.1.1
nameserver 1.0.0.1
"
}

__resolvconf_get_content_for_ibm(){
  echo "options timeout:10
nameserver 192.168.0.1
"
}

__resolvconf_get_content_ppc64le(){
  __resolvconf_get_content_for_ibm
}

__resolvconf_get_content_s390x(){
  __resolvconf_get_content_for_ibm
}

main "$@"
