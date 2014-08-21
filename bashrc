# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

umask 022

if [ "`uname`" == "Darwin" ]; then
    PATH=/usr/X11R6/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
    PATH=/usr/local/sbin:/usr/local/bin:${PATH}
    MANPATH=/usr/local/man:/opt/local/man:$MANPATH
elif [ "`uname`" == "SunOS" ]; then
    PATH=/usr/sbin:/usr/bin:/sbin:/bin:/usr/sadm/bin:/usr/sfw/bin
    PATH=${PATH}:/usr/ucb:/usr/aset:/usr/aset/util:/usr/platform/`uname -i`/sbin
    PATH=/usr/local/sbin:/usr/local/bin:/opt/csw/bin:/opt/csw/sbin:${PATH}
    MANPATH=/usr/man:/usr/local/man:/usr/local/ssl/man
    if [ -d /nsr ]; then
        PATH=${PATH}:/nsr/bin:/nsr/sbin
    fi
    if [ -d /opt/SUNWexplo ]; then
        PATH=${PATH}:/opt/SUNWexplo/bin
        MANPATH=${MANPATH}:/opt/SUNWexplo/man
    fi
    if [ -d /opt/csw/libexec/nagios-plugins ]; then
        PATH=${PATH}:/opt/csw/libexec/nagios-plugins
    fi
elif [ "`uname`" == "Linux" ]; then
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
    MANPATH=/usr/man:/usr/share/man:/usr/local/man
    if [ -d /nsr ]; then
        PATH=${PATH}:/nsr/bin:/nsr/sbin
    fi
    if [ -d ~/android-sdk-linux ]; then
        #AndroidDev PATH
        PATH=${PATH}:~/android-sdk-linux/tools
        PATH=${PATH}:~/android-sdk-linux/platform-tools
    fi
    if [ -d /usr/lib64/nagios/plugins ]; then
        PATH=${PATH}:/usr/lib64/nagios/plugins
    fi
elif [ "`uname`" == "CYGWIN_NT-6.1-WOW64" ]; then
    PATH=/usr/local/bin:/usr/sbin:${PATH}
fi

GEM_HOME=~/.gems
export GEM_HOME
PATH=${GEM_HOME}/bin:~/bin:${PATH}
PYTHONPATH=~/lib/python:${PYTHONPATH}

export PATH
export PYTHONPATH
export MANPATH

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

if [ -z "${SSH_CLIENT}" ]; then
    bind "set completion-ignore-case on"
fi

LS_OPTIONS="-ph"
GREP_OPTIONS="--color=auto"
LESS="-r"

CLICOLOR=1
function EXT_COLOR () { echo -ne "\e[38;5;$1m"; }
function CLOSE_COLOR () { echo -ne '\e[m'; }

if [ "`uname`" == "Darwin" ]; then
  if [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
  fi
    EDITOR="subl"
    VISUAL=${EDITOR}
    CVSEDITOR="${EDITOR} -w"
    SVN_EDITOR=$CVSEDITOR
    TERM=xterm-256color
    if [[ -z $DISPLAY ]]; then
        disp_no=($( ps -ax | grep X11.app | grep -v grep | awk '{print $7}' ))
        if [[ -n $disp_no ]];then
            export DISPLAY=${disp_no}.0
        else
            export DISPLAY=:0.0
        fi
        echo "DISPLAY has been set to ${DISPLAY}"
    fi
    LS_OPTIONS="${LS_OPTIONS}G"
    GREP_OPTIONS="${GREP_OPTIONS} --exclude-dir=.svn"
    if [ -f $(brew --prefix)/etc/bash_completion ]; then
       . $(brew --prefix)/etc/bash_completion
    fi
elif [ "`uname`" == "SunOS" ]; then
    EDITOR="vim"
    VISUAL=${EDITOR}
    CVSEDITOR=${EDITOR}
    SVN_EDITOR=${EDITOR}
    TERM=dtterm
elif [ "`uname`" == "Linux" ]; then
    # make less more friendly for non-text input files, see lesspipe(1)
    [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

    # set variable identifying the chroot you work in (used in the prompt below)
    if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
    fi
    if [ -f ~/bin/subl ]; then
        EDITOR="subl"
    else
        EDITOR="rmate"
    fi
    VISUAL=${EDITOR}
    CVSEDITOR="vim"
    SVN_EDITOR="vim"
    if [ -e /usr/share/terminfo/x/xterm-256color ]; then
        TERM='xterm-256color'
    else
        TERM='xterm-color'
    fi
    LS_OPTIONS="${LS_OPTIONS} --color"
    GREP_OPTIONS="${GREP_OPTIONS} --exclude=.svn"
elif [ "`uname`" == "CYGWIN_NT-6.1-WOW64" ]; then
    EDITOR="vim"
    VISUAL=${EDITOR}
    CVSEDITOR=${EDITOR}
    SVN_EDITOR=${EDITOR}
else
    EDITOR="vi"
    VISUAL=${EDITOR}
    CVSEDITOR=${EDITOR}
    SVN_EDITOR=${EDITOR}
    TERM=vt100
fi

export EDITOR
export TERM
export VISUAL
export CVSEDITOR
export SVN_EDITOR
export LS_OPTIONS
export GREP_OPTIONS
export LESS
export CLICOLOR
if [ "`uname`" == "SunOS" ]; then
  HOSTNAME=`hostname`
else
  HOSTNAME=`hostname -s`
fi
PROMPT_COMMAND='echo -ne "\033]0;@${HOSTNAME}: ${PWD/$HOME/~}\007"'
export PROMPT_COMMAND

if [ "`uname`" == "Linux" ]; then
    AWKCMD="awk -F:"
elif [ "`uname`" == "SunOS" ]; then
    AWKCMD="awk"
fi

# autocomplete ssh hosts if not already in an ssh session
if [ -z "${SSH_CLIENT}" ]; then
    complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh
fi

PS1='\u@\h: \W \$ '
PS2="-contd-> "
PS4="$0.$LINENO+ "
export PS1 PS2 PS4
