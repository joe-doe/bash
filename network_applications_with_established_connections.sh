#!/usr/bin/env bash

ports_string=`netstat |grep EST| awk '{print $4}'|awk -F':' '{print $2}'`

mapfile -t ports <<< "${ports_string}"

printf "%7s application name\n" 'est.'
echo "------- ----------------"

for port in "${ports[@]}"
do
  lsof -i:${port} | awk '{if (NR!=1) {print $1}}'
done | sort | uniq -c
