DOTFILES_ZLOGIN=TRUE
export DOTFILES_ZLOGIN

if [ -d /opt/splunk ]; then
  sudo -u splunk /opt/splunk/bin/splunk status
fi

SEARCHES=`ps -ef | grep search | grep -v grep | wc -l`

echo "There are ${SEARCHES} searches."
