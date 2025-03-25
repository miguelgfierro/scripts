# Script to display a log file with ERROR lines in red
# It assumes that the errors are logged as for example: 
# 2025-03-25 15:10:15 ERROR 'int' object has no attribute 'split'
#
# Usage:
# sh pretty_logger.sh
# sh pretty_logger.sh my_log_file.txt

# Get the log file from command line argument or use default
LOG_FILE="${1:-app.log}"

tail -n 200 -f "$LOG_FILE" | awk '/ERROR/{print "\033[31m" $0 "\033[0m"; next} {print $0}'
