#!/bin/bash
# v1.0.1
# Script Name: generate-passwords-list.sh
# Requiers: ansible, bash
# Usage: 
# 1. Create & fill list-users.txt
# 2. Create & fill list-passwords.txt
# 3. Set var ANSIBLE_SERVER=<your_server>
# 4. Run script:
#      ./generate-passwords-list.sh ansible
#   or ./generate-passwords-list.sh zeppelin

ANSIBLE_SERVER=srv-hadoops01
SALT="mysef23f2fb"

USER_LIST=list-users.txt
PASSWORDS_LIST=list-passwords.txt
PASSWORDS_HASH=passwords-hash.txt

ANSIBLE_FILE=ansible-list.txt
ZEPPELIN_FILE=zeppelin-shiro-list.txt

#cat << EOF > $PASSWORD_LIST
#EOF

# passwords -> hash -> hash + users = ansible list\


# --- SUPPORT
function fail_ok()
{
    if [ $? -eq 0 ];then
        echo -ne "$GREEN_COLOR [OK] $CLEAR_COLOR $1"
        echo
    else
        echo -ne "$RED_COLOR [fail] $CLEAR_COLOR $1"
        echo
    fi
}


# --- SCRIPT
function generate_ansible_list()
{
    # GENERATE HASH FROM PASSWORDS VIA ANSIBLE
    :>$PASSWORDS_HASH
    while read -r password;
    do
        ansible $ANSIBLE_SERVER, -m debug -a "msg={{ '$password' | password_hash('sha512', '$SALT') }}" | grep msg | awk '{print $2}' >> $PASSWORDS_HASH
        fail_ok "Generate Password hash"
    done < $PASSWORDS_LIST
    fail_ok " ---- Complete Generate password hash ----"
    
    
    # GENERATE ANSIBLE LIST
    :> $ANSIBLE_FILE
    NUM=1
    while read -r user;
    do
        echo "      $user:" >> $ANSIBLE_FILE
        SED_PASS=`sed "${NUM}q;d" $PASSWORDS_HASH`
        echo "        password: $SED_PASS" >> $ANSIBLE_FILE
        fail_ok "Generate string for user: $user"
        let "NUM=NUM+1"
    done < $USER_LIST
    fail_ok "---- Complete Generate ansible list ----"
    
    echo "check file $ANSIBLE_FILE and place it to ansible role user-control.yaml"
}

function generate_zeppelin_list()
{
    # GENERATE ZEPPELIN LIST
    :> $ZEPPELIN_FILE
    NUM=1
    while read -r user;
    do
        SED_PASS=`sed "${NUM}q;d" $PASSWORDS_LIST`
        echo "$user = $SED_PASS" >> $ZEPPELIN_FILE
        fail_ok "Generate string for user: $user"
        let "NUM=NUM+1"
    done < $USER_LIST
    fail_ok "---- Complete Generate ansible list ----"
    
    echo "check file $ZEPPELIN_FILE and place it to zeppelin shiro"
}

command() 
{
  case "$1" in
    ansible)
      generate_ansible_list
      ;;
    zeppelin)
      generate_zeppelin_list
      ;;
    *)
      echo $"Usage: $0 { ansible | zeppelin }"
      echo "    ansible - generate list of users + passwords hashs"
      echo "    zeppelin - generate list users + passwords"
      exit 1
  esac
}

command "$1"


exit 0
