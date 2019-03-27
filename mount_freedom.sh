#!/bin/bash
show_menu(){
    normal=`echo "\033[m"`
    menu=`echo "\033[36m"` #Blue
    number=`echo "\033[33m"` #yellow
    fgred=`echo "\033[41m"`
    red_text=`echo "\033[31m"`
    enter_line=`echo "\033[33m"`
    echo -e "${menu}*********************************************${normal}"
    echo -e "${menu}**${number} 1)${menu} Mount Drei ${normal}"
    echo -e "${menu}**${number} 2)${menu} Mount Zwei ${normal}"
    echo -e "${menu}**${number} 3)${menu} Freedom ${normal}"
#   echo -e "${menu}**${number} 4)${menu} ${normal}"
    echo -e "${menu}*********************************************${normal}"
    echo -e "${enter_line}Please enter a menu option and enter or ${red_text}enter to exit. ${normal}"
    read opt
}

function option_picked() {
    color='\033[01;31m' # bold red
    reset='\033[00;00m' # normal white
    message=${@:-"${reset}Error: No message passed"}
    echo -e "${color}${message}${reset}"
}

clear
show_menu
while [ opt != '' ]
    do
    if [[ $opt = "" ]]; then 
            exit;
    else
        case $opt in
        1) clear;
        	option_picked "Option 1 Picked";
        	su -c 'mount /dev/sdc1 /mnt/disk1/'; 
        menu;
        ;;

        2) clear;
            option_picked "Option 2 Picked";
            su -c 'mount /dev/sdd1 /mnt/disk2/';
        menu;
        ;;

        3) clear;
            option_picked "Option 3 Picked";
            su -c "free && sync && echo 3 > /proc/sys/vm/drop_caches && free";
        menu;
        ;;

        x)exit;
        ;;

        \n)exit;
        ;;

        *)clear;
        option_picked "Pick an option from the menu";
        show_menu;
        ;;
    esac
fi
done




