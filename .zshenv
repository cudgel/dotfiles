DOTFILES_ZSHENV=TRUE
export DOTFILES_ZSHENV

umask 022

if [ `uname` = "Darwin" ]; then
    PATH=/usr/X11R6/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
    PATH=/usr/local/sbin:/usr/local/bin:${PATH}
    MANPATH=/usr/local/man:/opt/local/man:$MANPATH
elif [ `uname` = "Linux" ]; then
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
    MANPATH=/usr/man:/usr/share/man:/usr/local/man
    if [ -d /usr/lib64/nagios/plugins ]; then
        PATH=${PATH}:/usr/lib64/nagios/plugins
    elif [ -d /usr/lib/nagios/plugins ]; then
        PATH=${PATH}:/usr/lib/nagios/plugins
    fi
fi

if [ -d /nsr ]; then
    PATH=${PATH}:/nsr/bin:/nsr/sbin
fi

if [ -d /opt/puppetlabs ]; then
  PATH=${PATH}:/opt/puppetlabs/bin
  if $(sudo cat /opt/puppetlabs/puppet/cache/state/agent_disabled.lock > /dev/null 2>&1); then
    export PUPPET_STATUS="disabled"
    echo "Puppet agent is ${PUPPET_STATUS}"
  fi
fi

if [ -d /opt/splunk ]; then
  SPLUNK_HOME='/opt/splunk'
elif [ -d /opt/splunkforwarder ]; then
  SPLUNK_HOME='/opt/splunkforwarder'
fi
if (( ${+SPLUNK_HOME} )); then
  export SPLUNK_HOME
  PATH=${PATH}:${SPLUNK_HOME}/bin
fi

GEM_HOME=~/.gems
export GEM_HOME
PATH=${PATH}:${GEM_HOME}/bin
PYTHONPATH=~/lib/python:${PYTHONPATH}

export PYTHONPATH
export MANPATH

PATH=~/bin:${PATH}
export PATH

LC_CTYPE=en_US.UTF-8; export LC_CTYPE

# Local config
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
