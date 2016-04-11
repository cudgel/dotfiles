DOTFILES_ZSHRC=TRUE
export DOTFILES_ZSHRC

LS_OPTIONS="-ph"
GREP_OPTIONS="--color=auto"
LESS="-r"

if [ `uname` = "Darwin" ]; then
    EDITOR="vim"
    VISUAL=${EDITOR}
    CVSEDITOR="${EDITOR}"
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
elif [ `uname` = "SunOS" ]; then
    EDITOR="vim"
    VISUAL=${EDITOR}
    CVSEDITOR=${EDITOR}
    SVN_EDITOR=${EDITOR}
    TERM=dtterm
elif [ `uname` = "Linux" ]; then
    # make less more friendly for non-text input files, see lesspipe(1)
    [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

    # set variable identifying the chroot you work in (used in the prompt below)
    if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
    fi
    EDITOR="vim"
    VISUAL=${EDITOR}
    CVSEDITOR="vim"
    SVN_EDITOR="vim"
    TERM='xterm-256color'
    LS_OPTIONS="${LS_OPTIONS} --color"
    GREP_OPTIONS="${GREP_OPTIONS} --exclude=.svn"
    BROWSER=/usr/bin/firefox
elif [ `uname` = "CYGWIN_NT-6.1-WOW64" ]; then
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
export GREP_OPTIONS
export LESS
export CLICOLOR
export BROWSER

# Automatically quote globs in URL and remote references
__remote_commands=(scp rsync)
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
zstyle -e :urlglobber url-other-schema '[[ $__remote_commands[(i)$words[1]] -le ${#__remote_commands} ]] && reply=("*") || reply=(http https ftp)'

bindkey -v

if [ -z $HISTFILE ]; then
  HISTFILE=$HOME/.zsh_history
fi
HISTSIZE=5000
SAVEHIST=15000

setopt appendhistory
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data
setopt autocd
setopt extendedglob
setopt notify

bindkey "^R" history-incremental-search-backward

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="bira"
plugins=(git gem history jsontools perl pip sudo vi-mode yum)
source $ZSH/oh-my-zsh.sh

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

source ~/.zsh_aliases
