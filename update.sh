#!/bin/bash
#
# Title:      PTS major file
# org.Author(s):  Admin9705 - Deiteq
# Mod from MrDoob for PTS
# GNU:        General Public License v3.0
################################################################################
sudocheck() {
  if [[ $EUID -ne 0 ]]; then
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  You Must Execute as a SUDO USER (with sudo) or as ROOT!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    exit 1
  fi
}

base() {
rm -rf /opt/pgstage && mkdir -p /opt/pgstage 1>/dev/null 2>&1
ansible-playbook /opt/ptsupdate/stage/pgstage.yml 1>/dev/null 2>&1
}

mainstart() {
  echo ""
  echo "💬  Pulling Update Files - Please Wait"
  file="/opt/pgstage/place.holder"
  waitvar=0
  while [ "$waitvar" == "0" ]; do
    sleep .5
    if [ -e "$file" ]; then waitvar=1; fi
  done

  pgnumber=$(cat /var/plexguide/pg.number)
  versions=$(cat /opt/pgstage/versions.sh)
  release="$(curl -s https://api.github.com/repos/PTS-Team/PTS-Team/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')"

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂  Update Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$versions

Installed : $pgnumber

[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  break=no
  read -p '🌍  TYPE master | dev or preview | PRESS ENTER: ' typed
  storage=$(grep $typed /opt/pgstage/versions.sh)
  parttwo
}

parttwo() {
  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then
    echo ""
    touch /var/plexguide/exited.upgrade
    exit
  fi
  if [ "$storage" != "" ]; then
    break=yes
    echo -e $storage >/var/plexguide/pg.number
    ansible-playbook /opt/ptsupdate/version/choice.yml

    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  SYSTEM MESSAGE: Installing Version - $typed - Standby!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 2
    touch /var/plexguide/new.install

    file="/var/plexguide/community.app"
    if [ -e "$file" ]; then rm -rf /var/plexguide/community.app; fi
  else
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  SYSTEM MESSAGE: Version $typed does not exist! - Standby!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 2
    mainstart
  fi
}

ende() {
alias 1>/dev/null 2>&1
remove 1>/dev/null 2>&1
redit 1>/dev/null 2>&1
owned 1>/dev/null 2>&1
exitcheck
check
}


########end funtions // execute commands

badinput() {
  echo
  read -p '⛔️ ERROR - Bad Input! | Press [ENTER] ' typed </dev/tty
}

alias() {
  ansible-playbook /opt/plexguide/menu/alias/alias.yml
}

remove() {
  ansible-playbook /opt/plexguide/menu/pg.yml --tag remove
}

redit() {
canonical-livepatch disable
disable-livepatch -r
}

owned() {
  chown -cR 1000:1000 /opt/plexguide
  chmod -R 775 /opt/plexguide
}

exitcheck() {
 bash /opt/plexguide/menu/interface/ending.sh 
}

check() {
file="/opt/plexguide/menu/pg.yml"
  if [[ -f $file ]]; then
  tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ All files Valid and latest version pulled
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
 else ansible-playbook /opt/plexguide/menu/version/missing_pull.yml; fi
}