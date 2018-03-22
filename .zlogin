DOTFILES_ZLOGIN=TRUE
export DOTFILES_ZLOGIN

if [ -d /opt/splunk ]; then
  /opt/splunk/bin/splunk version
  echo ""
  sudo -u splunk /opt/splunk/bin/splunk status

  SEARCHES=`ps -ef | grep "search --id" | grep -v grep | wc -l`
  echo ""
  echo "There are ${SEARCHES} searches."

  ORPHANS=`ps -elf | grep splunk | grep -v start | awk '{if ($5 == 1){print $0}}'`

  echo "These are possible orphans:"
  echo $ORPHANS
fi
