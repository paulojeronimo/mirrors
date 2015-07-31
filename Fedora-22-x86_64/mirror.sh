#!/bin/bash
# Author: Paulo Jerônimo (@paulojeronimo, pj@paulojeronimo.info)
#
# This script clones a Fedora public mirror to use as a private 
# mirror in my teaching classes about Linux, JBoss and related 
# things.
#
# x86_64 mirrors in Brazil: https://mirrors.fedoraproject.org/publiclist/Fedora/20/x86_64/#BR

# BR mirrors:
#RSYNC_BASE_DIR=${RSYNC_BASE_DIR:-rsync://rsync.las.ic.unicamp.br/fedora-linux}
RSYNC_BASE_DIR=${RSYNC_BASE_DIR:-rsync://fedora.c3sl.ufpr.br/fedora/linux}
# US mirrors:
#RSYNC_BASE_DIR=${RSYNC_BASE_DIR:-rsync://mirror.pnl.gov/fedora/linux}

FEDORA_VERSION=22
RSYNC_RELEASES_DIR=${RSYNC_RELEASES_DIR:-$RSYNC_BASE_DIR/releases/$FEDORA_VERSION/}
RSYNC_UPDATES_DIR=${RSYNC_UPDATES_DIR:-$RSYNC_BASE_DIR/updates/$FEDORA_VERSION/}

# FEDORA_MIRROR indicates the full PATH to the mirror directory. If you don't specify it, the mirror will be created in the same dir running this script.
[ "$FEDORA_MIRROR" ] && \
  d=$FEDORA_MIRROR || \
  d=$(d=`dirname "$0"`/mirror; mkdir -p "$d" && cd "$d"; echo -n $PWD)

[ -w "$d/" ] && unset sudo || sudo=sudo

$sudo mkdir -p "$d/releases" && cd "$d"

$sudo rsync --progress -avrt --delete --delete-excluded \
--exclude "Cloud/*" \
--exclude "Cloud_Atomic/*" \
--exclude "Docker/*" \
--exclude "Everything/armhfp/*" \
--exclude "Everything/i386/*" \
--exclude "Everything/x86_64/debug/*" \
--exclude "Everything/source/*" \
--exclude "Fedora/armhfp/*" \
--exclude "Fedora/i386/*" \
--exclude "Fedora/source/*" \
--exclude "Images/*" \
--exclude "Live/*" \
--exclude "Server/*" \
--include "Workstation/x86_64/" \
--include "Workstation/x86_64/iso/" \
--include "Workstation/x86_64/iso/Fedora-Workstation-netinst-x86_64-22.iso" \
--exclude "Workstation/x86_64/os/" \
--exclude "Workstation/x86_64/debug/" \
--exclude "Workstation/*" \
$RSYNC_RELEASES_DIR releases/$FEDORA_VERSION

$sudo mkdir -p "$d/updates" && cd "$d"

$sudo rsync --progress -avrt --delete --delete-excluded \
--exclude "SRPMS/*" \
--exclude "armhfp/*" \
--exclude "i386/*" \
--exclude "x86_64/debug/*" \
$RSYNC_UPDATES_DIR updates/$FEDORA_VERSION
