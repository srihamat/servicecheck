#!/bin/sh

# service.sh version 1.00
#  - Good for contrab timer to check every 5 sec
#  - Report only failed cases or passed after failed

err_flag=0
err_service=none
servIP=`ip addr show ens192 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*'`
token=[your line notification token]

#grep problem
err_previously=$(cat linelog.txt | grep 'problem')

rm $HOME/linelog.txt

for SERVICE in nginx mysqld
do
	if pgrep -x "$SERVICE" >/dev/null
	then
		echo "$SERVICE is running" >> $HOME/linelog.txt
	else
		echo "$SERVICE stopped" >> $HOME/linelog.txt
		err_flag=1
		err_service=$SERVICE
	fi
done

if [ $err_flag -eq 1 ];
then
	echo "server is having problem" >> $HOME/linelog.txt
	# if problem found previorsly
	# no need to report server is having problem again
	if [ "$err_previously" != "server is having problem" ]; then
	    curl -X POST -H 'Authorization: Bearer $token' -F 'message=Server "'"$servIP"'" has a problem with "'"$err_service"'"
            ' https://notify-api.line.me/api/notify.
	fi;
else
	echo "server is working fine !" >> $HOME/linelog.txt
	# if problem found previorsly
	# report server is working fine (via line)
	if [ "$err_previously" = "server is having problem" ]; then
	    curl -X POST -H 'Authorization: Bearer $token' -F 'message=Server "'"$servIP"'" is working fine !"
	    ' https://notify-api.line.me/api/notify.
	fi;
fi

