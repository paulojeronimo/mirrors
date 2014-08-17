#!/bin/bash
# Author: Paulo Jerônimo (@paulojeronimo, pj@paulojeronimo.info)
#
# This script clones a CentOS 6 public mirror to use as a private 
# mirror in my teaching classes about Linux, JBoss and related 
# things.
#
# Some alternative rsync mirrors (near to Brazil)
#
#rsync://linorg.usp.br/CentOS/
#rsync://mirrors.abdicar.com/costarica_CentOS/
#rsync://centos.ufms.br/CentOS/

CENTOS_VERSION=6.5
RSYNC_DIR=${RSYNC_DIR:-rsync://linorg.usp.br/CentOS/$CENTOS_VERSION/}

# CENTOS_MIRROR indicates the full PATH to the mirror directory. 
# If you don't specify it, the mirror will be created in the same dir running this script.
[ "$CENTOS_MIRROR" ] && \
  d=$CENTOS_MIRROR || \
  d=$(d=`dirname "$0"`/mirror; mkdir -p "$d" && cd "$d"; echo -n $PWD)

[ -w "$d/" ] && unset sudo || sudo=sudo

# This will rsync only CentOS x86_64 and exclude i386
$sudo rsync --progress -avrt --delete --delete-excluded \
--include "isos/x86_64/CentOS-$CENTOS_VERSION-x86_64-netinstall.iso" \
--exclude "isos/x86_64/*" \
--exclude "isos/i386" \
--exclude "local*" \
--exclude "centosplus" \
--exclude "i386" \
$RSYNC_DIR "$d/"
