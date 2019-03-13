#!/bin/bash
clear -n

# This script has been tested on doctl version 1.12.2-release
# This script might not work on newer version of doctl.
# Version 0.1 - Jan 30, 2018
# DigitalOcean Solution Engineers
# This is a BETA

function CHECK() {

if [[ $(doctl auth init | grep 'OK') != *OK* ]];

then 

echo "You must authenticate doctl before you can use the toolbox"
echo "https://github.com/digitalocean/doctl/blob/master/README.md"
exit

else MENU

fi
}

# Menu Function - Presents user interactive menu.
function MENU() {
   TITLE BETA_DO_TOOLBOX
   local PS3='Please enter your choice (Press enter to see menu): '

   options=("Compute Menu     " "Backups Menu" "Snapshot Menu" "Quit")
   select opt in "${options[@]}"; do
      case $opt in
         "Compute Menu     ")              DO_COMPUTE_MENU           ;;
         "Backups Menu")                   DO_BACKUP_MENU            ;;
         "Snapshot Menu")                  DO_SNAPSHOT_MENU          ;;
         "Quit")                           exit                      ;;
         *) echo -e "\e[97m invalid option \e[39m"                   ;;
      esac
   done
}

# Backup Function - Presents user interactive menu.
function DO_BACKUP_MENU() {
   TITLE BETA_DO_BACKUP_MENU
   local PS3='Please enter your choice (Press enter to see menu): '

   options=("List Backups     " "Enable Backups" "Main Menu" "Quit")
   select opt in "${options[@]}"; do
      case $opt in
         "List Backups     ")              LIST_BACKUP                ;;
         "Enable Backups")                 ENABLE_BACKUP              ;;
         "Main Menu")                      MENU                       ;;
         "Quit")                           exit                       ;;
         *) echo -e "\e[97m invalid option \e[39m"                    ;;
      esac
   done
}

# Compute Function - Presents user interactive menu.
function DO_COMPUTE_MENU() {
   TITLE BETA_DO_COMPUTE_MENU
   local PS3='Please enter your choice (Press enter to see menu): '

   options=("List Droplets     " "Main Menu" "Quit")
   select opt in "${options[@]}"; do
      case $opt in
         "List Droplets     ")             LIST_DROPLET               ;;
         "Main Menu")                      MENU                       ;;
         "Quit")                           exit                       ;;
         *) echo -e "\e[97m invalid option \e[39m"                    ;;
      esac
   done
}


# Title Function - Presents title in clean format
function TITLE() {
   echo -en "\n"; s=$(printf "%-71s" "-"); echo -en "${s// /-}"; echo -en "\r-- $1 -"; echo -en "\n\n"
}

# Global Variables 
tmpfile='.doctl.tmp'

# List Backups - list droplets that have and dont have backups. 
function LIST_BACKUP() {

clear -n

TITLE DROPLETS_WITH_BACKUPS

doctl compute droplet list | sed '1p;/backups/!d'
echo -en "\n"

TITLE DROPLETS_WITHOUT_BACKUPS

doctl compute droplet list | grep -v backups
echo -en "\n"

}


# Enable Backups - List droplets and enbale all with backups. 
function ENABLE_BACKUP() {

clear -n

TITLE BETA_ENABLING_BACKUPS

doctl compute droplet list | grep -v backups
echo -en "\n"

read -r -p "Would you like to enable backups on all of the machines above? [y/N] `echo $'\n> '`" list
   case "$list" in
       [yY][eE][sS]|[yY])  
       
            for i in $(doctl compute droplet list | grep -v backups | sed '1d' | awk '{print $1}')
            do doctl compute droplet-action enable-backups $i;
            done  
            ;;

       *)   echo -en "\n"
            echo "You can also enable one droplet at a time by running:"
            echo "doctl compute droplet-action enable-backups <dropletid>"
            echo -en "\n"
            ;;
   esac

}

function LIST_DROPLET() {

clear -n

TITLE BETA_LIST_DROPLETS
doctl compute droplet list

}

CHECK
