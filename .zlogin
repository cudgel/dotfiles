DOTFILES_ZLOGIN=TRUE
export DOTFILES_ZLOGIN

if [ -d /opt/splunk ]; then
  sudo -u splunk /opt/splunk/bin/splunk status
fi

SEARCHES=`ps -ef | grep "search --id" | grep -v grep | wc -l`

echo "There are ${SEARCHES} searches."

ORPHANS=`ps -elf | grep splunk | grep -v start | awk '{if ($5 == 1){print $0}}'`

echo "These are possible orphans:"
echo $ORPHANS
