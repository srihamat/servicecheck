#!/bin/sh

# service.sh version 1.00
#  - Good for contrab timer to check every 5 sec
#  - Report only failed cases or passed after failed

err_flag=0
err_service=none
#ens192 is our example interface name we interest, please update yours
servIP=`ip addr show ens192 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*'`
#ZquoMHIKoNjdUCp8fNxVCbTETirZAQkJbWWmb7e1234 is out example token we have, pls get yours from https://notify-bot.line.me
token=ZquoMHIKoNjdUCp8fNxVCbTETirZAQkJbWWmb7e1234

#grep problem
err_previously=$(cat linelog.txt | grep 'problem')

rm $HOME/linelog.txt

# nginx and mysqld are our example services we interest, please update yours
# Modify services you interest, example replace mysqld with another db, replace nginx with another web service
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

# Sending line message to let administrator know before customer
if [ $err_flag -eq 1 ];
then
	echo "server is having problem" >> $HOME/linelog.txt
	# if problem found previorsly
	# no need to report server is having problem again
	if [ "$err_previously" != "server is having problem" ]; then
	    curl -X POST -H 'Authorization: Bearer '$token -F 'message=Server "'"$servIP"'" has a problem with "'"$err_service"'"
            ' https://notify-api.line.me/api/notify.
	fi;
else
	echo "server is working fine !" >> $HOME/linelog.txt
	# if problem found previorsly
	# report server is working fine
	if [ "$err_previously" = "server is having problem" ]; then
	    curl -X POST -H 'Authorization: Bearer '$token -F 'message=Server "'"$servIP"'" is working fine !"
	    ' https://notify-api.line.me/api/notify.
	fi;
fi

