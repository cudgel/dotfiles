DOTFILES_ZLOGIN=TRUE
export DOTFILES_ZLOGIN

if [ -d /opt/splunk ]; then

  SPL_UPTIME=`ps -ef | egrep "\ssplunkd -p" | grep -v process-runner | awk -F" " '{print $2}'`
  UPTIME_MSG=`ps -p ${SPL_UPTIME} -o etime | tail -1 | perl -i -pe 's/^[\W]+//g'`

  /opt/splunk/bin/splunk version
  echo ""
  sudo -u splunk /opt/splunk/bin/splunk status

  SEARCHES=`ps -ef | grep "search --id" | grep -v grep | wc -l`
  echo ""
  echo "There are ${SEARCHES} searches."
  echo "Splunk has been up for: ${UPTIME_MSG}"

  ORPHANS=`ps -elf | grep splunk | grep -v start | awk '{if ($5 == 1){print $0}}'`
  echo "These are possible orphans:"
  echo $ORPHANS

fi
