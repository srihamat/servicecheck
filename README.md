# Service Check
Bash script to check if service is running on linux, then posting line instant message to let system admin know before customer. This service check is very usefull for our lazy team that doesn't want to manual check if service is available and on top of that our team realized the problem happened and try to fix it before our customer experienced.

How to use:
1. Place file service.sh in your server
2. Please config $token by adding token from line notification
3. Config crontab to call it interval for example every 5 second.
     - crontab -e
     - */5 * * * * $HOME/service.h >> $HOME/linelog.txt

Tested on Debian 4.9.88-1+deb9u1
