#!/bin/bash

# This is to encrypt to char ASCII code from decimal ASCII code (Excludes extended ASCII code).
# For this (https://play.picoctf.org/practice/challenge/156) picoCTF challenge.
# The ASCII table was hand-copied from https://theasciicode.com.ar/ascii-control-characters/start-of-header-ascii-code-1.html.

# Decimal ASCII code from dump.txt have to be separated by a newline.

function join()
{
    local IFS="$1"
    shift
    echo "$*"
}

declare ascii_code=""
ascii_code="$(cat ./dump.txt)"

# echo "$(sed "s/\$'"\'"'\\n'"\'"'//" <<< "$ascii_code")" # echoe's dump.txt without weird things popping up.

declare ascii_table=(NUL SOH STX ETX EOT ENQ ACK BEL BS TAB LF VT FF CR SO SI DLE DC1 DC2 DC3 DC4 NAK SYN ETB CAN EM SUB ESC FS GS RS US Space ! \" \# \$ % \& \' \( \) \* \+ \, - . / 0 1 2 3 4 5 6 7 8 9 : \; \< '=' \> ? @ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z \[ \\ \] ^ _ \` a b c d e f g h i j k l m n o p q r s t u v w x y z \{ \| \} \~)

declare array=()
declare result=()

for n in $ascii_code; do

#    index="$(echo "${#array[@]}")" # stores the number of elements in $array inside of $index.
    array+=("${n}")
done

echo
echo "${array[*]}"
echo

declare counter=0
declare result_index=0

for index in ${array[*]}; do

	if [ "$index" -ge 127 ]; then

		if [ "$counter" == 0 ]; then
		    echo "We have detected ASCII code beyond the control and printable characters, replacing them with 'ERR'. (One time message)"
		    echo
		fi
		result[$result_index]="ERR"
        result_index=$((result_index+1))
        counter=1
        continue
	fi
    result[$result_index]="${ascii_table[$index]}"
    result_index=$((result_index+1))
done

echo "${result[*]}"
echo

read -r -p "Do you want to join the char ASCII code together?(y/n): " y_n;
echo

if [ "$y_n" == "y" ]; then
    read -r -p "Do you want to separate them by anything?(Spaces don't work. Press enter to separate them by nothing): " separator;
    echo
    join "$separator" "${result[@]}"
    echo
fi
