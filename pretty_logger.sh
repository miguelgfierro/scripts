# Script to display a log file with ERROR lines in red
# It assumes that the errors are logged as for example: 
# 2025-03-25 15:10:15 ERROR 'int' object has no attribute 'split'

tail -n 200 -f app.log | awk '/ERROR/{print "\033[31m" $0 "\033[0m"; next} {print $0}'
