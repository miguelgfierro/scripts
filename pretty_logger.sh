# Script to display a log file with ERROR lines in red.
# It displays the latest 200 lines of the log file.
# It assumes that the errors are logged as for example: 
# 2025-03-25 15:10:15 ERROR 'int' object has no attribute 'split'
#
# Usage:
# sh pretty_logger.sh
# sh pretty_logger.sh my_log_file.txt

# Display help
display_help() {
  echo "Usage: $(basename "$0") [LOG_FILE] [-h|--help]"
  echo
  echo "Display a log file with ERROR lines highlighted in red"
  echo
  echo "Options:"
  echo "  LOG_FILE    Path to log file (default: app.log)"
  echo "  -h, --help  Display this help message and exit"
  echo
  echo "Example:"
  echo "  $(basename "$0")                # Display app.log"
  echo "  $(basename "$0") my_logs.log    # Display my_logs.log"
  exit 0
}

# Check for help flag
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  display_help
fi

# Get the log file from command line argument or use default
LOG_FILE="${1:-app.log}"

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
  echo "ERROR: Log file '$LOG_FILE' does not exist."
  echo "Run '$(basename "$0") --help' for usage information."
  exit 1
fi

tail -n 200 -f "$LOG_FILE" | awk '/ERROR/{print "\033[31m" $0 "\033[0m"; next} {print $0}'
