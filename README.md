# servicecheck
bash script to check if service is running on linux

How to use:
1. Place file service.sh in your server
2. Please config $token by adding token from line notification
3. Config crontab to call it interval for example every 5 second.
     - crontab -e
     - */5 * * * * $HOME/service.h >> $HOME/linelog.txt

