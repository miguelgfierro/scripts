#!/bin/bash

clear

#Define list option
list_mode=false

while getopts "l" opt; do
    case "$opt" in
        l) list_mode=true ;;
        *) exit 1 ;;
    esac
done

#This removes the -l
shift $((OPTIND - 1))

#Define colors
colors=(
  "\e[31m"
  "\e[38;5;208m"
  "\e[33m" # Replacement for yellow
  "\e[32m"
  "\e[36m"
  "\e[34m" # Closest to indigo
  "\e[35m"
)

#Rainbow function
rainbow() {
    for c in "${colors[@]}"; do
        if ! $list_mode; then
            clear
        fi
        echo -e "${c}$(echo "
ooooooooo.         .o.       ooooo ooooo      ooo oooooooooo.    .oooooo.   oooooo   oooooo     oooo 
.888   .Y88.      .888.      .888. .888b.     .8. .888.   .Y8b  d8P.  .Y8b   .888.    .888.     .8.  
 888   .d88.     .88888.      888   8 .88b.    8   888     888 888      888   .888.   .8888.   .8.   
 888ooo88P.     .8. .888.     888   8   .88b.  8   888oooo888. 888      888    .888  .8..888. .8.    
 888.88b.      .88ooo8888.    888   8     .88b.8   888    .88b 888      888     .888.8.  .888.8.     
 888  .88b.   .8.     .888.   888   8       .888   888    .88P .88b    d88.      .888.    .888.      
o888o  o888o o88o     o8888o o888o o8o        .8  o888bood8P.   .Y8bood8P.        .8.      .8.")\e[0m\r"
        sleep 1
    done
}

#Display rainbow
index=$(( $1 + 0 ))
if [[ $1 > "" ]]; then
    while [[ $index > 0 ]]; do
        rainbow
        (( index-- ))
    done
else
  while true; do
      rainbow
      (( index-- ))
  done
fi
