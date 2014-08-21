alias ls='ls $LS_OPTIONS'
alias df='df -h'
alias du='du -sh * | sort -rh | grep -v ^0'
alias cl='clear'
alias pso='ps -e -o user,comm | grep -v USER | sort'
alias psa='ps -aexfw -m'
alias wide='stty rows 24 columns 80'
alias ssh='ssh -q'
alias last='last | grep -v gwmon | less'
alias rgrep='grep --context=2 -siIrn'
alias pgrep='pgrep -fl'
alias gcat='grep -siIn --context=0 .'
alias gmt='sudo -u gwmon /opt/GWUmon/bin/gwmon --test'
alias pip='pip install --user --install-option="--install-scripts=$HOME/bin"'

# Bash shell driver for 'go' (http://code.google.com/p/go-tool/).
function go {
    export GO_SHELL_SCRIPT=$HOME/.__tmp_go.sh
    python -m go $*
    if [ -f $GO_SHELL_SCRIPT ] ; then
        source $GO_SHELL_SCRIPT
    fi
    unset GO_SHELL_SCRIPT
}

lds() {
    ldapsearch -x -D "uid=caldwell,ou=people,dc=gwu,du" -b "ou=people,dc=gwu,dc=edu" uid=$1
}

ads() {
    ldapsearch -LLL -x -D "CN=caldwell,OU=Accounts,OU=GWUsers,DC=ead,DC=gwu,DC=edu" -b "OU=Accounts,OU=GWUsers,DC=ead,DC=gwu,DC=edu" -W -ZZ -h authad.gwu.edu "(cn=${1})"
}

stripcert() {
    openssl rsa -in $1 -out $1.stripped
}

getcert() {
    echo QUIT | openssl s_client -connect $1 | sed -ne '/BEGIN CERT/,/END CERT/p'
}

tp() {
    nc -v -w 10 -z $1 $2
}

if [ -d /usr/local/crashplan ]; then

    cplocal() {
        perl -i -pe 's/\=14243/\=4243/' /usr/local/crashplan/conf/ui.properties; CrashPlanDesktop
    }
    cpremote() {
        perl -i -pe 's/\=4243/\=14243/' /usr/local/crashplan/conf/ui.properties; CrashPlanDesktop
    }

fi

if [ -d /nsr ]; then
    PRODIP=`echo $SSH_CONNECTION | awk '{print $3}'`

    bkup() {
        if [[ $PRODIP == 128* ]]; then
            export DISK=DiskFB
        else
            export DISK=DiskVA
        fi
        sudo /nsr/bin/save -i -s yukon.backup.es.gwu.edu -l full -b $DISK $1
    }

    rkvr() {
        sudo /nsr/bin/recover -s yukon.backup.es.gwu.edu
    }

    vinsr() {
        sudo /nsr/sbin/nsradmin -s yukon.backup.es.gwu.edu "name: $1.backup.es.gwu.edu"
    }

    lsnsr() {
        host=$1
        if [ "$host" = "" ] ; then host=`hostname`; fi
        sudo /nsr/sbin/mminfo -s yukon.backup.es.gwu.edu -t yesterday -c ${host}.backup.es.gwu.edu -v
    }

    catnsr() {
        printf "\n\t\t\t`hostname`\n\n"
        sudo bash -c "EDITOR=cat /nsr/sbin/nsradmin -s yukon.backup.es.gwu.edu \"name: `hostname`.backup.es.gwu.edu\"" | egrep "scheduled backup|comment|schedule|browse policy|retention policy|directive|group|save set"
    }
fi

       peek () {
            if [ "`uname`" == "SunOS" ]; then
                TAR=gtar
            else
                TAR=tar
            fi
            UNZIP=unzip

            case ${1} in
                *.tar.bz2 )
                    ${TAR} -jtvf ${1} ;;
                *.tar.gz )
                    ${TAR} -ztvf ${1} ;;
                *.tgz )
                    ${TAR} -ztvf ${1} ;;
                *.tar )
                    ${TAR} -tvf ${1} ;;
                *.zip )
                    ${UNZIP} -lv ${1} ;;
            esac
        }


    if [ "`uname`" == "Darwin" ]; then
        alias sleepoff="sudo pmset -a hibernatemode 0"
        alias sleepon="sudo pmset -a hibernatemode 1"
        alias spot='mdfind -onlyin `pwd`'
        alias vpnkill='sudo /usr/bin/killall -9 racoon'
        alias lserv='sudo /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -seed -r'

        tman () {
              MANWIDTH=160 MANPAGER='col -bx' man $@ | bbedit
        }

        # Quit an OS X application from the command line
        quit () {
            for app in $*; do
                osascript -e 'quit app "'$app'"'
            done
        }

        relaunch () {
            for app in $*; do
                osascript -e 'quit app "'$app'"';
                sleep 2;
                open -a $app
            done
        }

        zap () {
            open -a AppZapper /Applications/"${1}".app
        }

        pman () {
            man -t "${1}" | open -f -a /Applications/Preview.app
        }

        bman () {
            MANWIDTH=160 MANPAGER='col -bx' man $@ | bbedit
        }

    fi

    if [ "`uname`" == "Linux" ]; then
        alias netlstat="sudo netstat -tupan | grep LISTEN | less"
        alias setstype="bash /etc/fonts/infinality/infctl.sh setstyle"

        whichport() {
            sudo tcpdump -nn -vvv -i ${1} -s 1500 -c 1 'ether[20:2] == 0x2000'
        }

        add_cert() {
            certutil -d sql:$HOME/.pki/nssdb -A -t "P,," -n $1 -i $1
        }

        list_cert() {
            certutil -d sql:$HOME/.pki/nssdb -L # add '-h all' to see all built-in certs
        }

    fi

    if [ "`uname`" == "SunOS" ]; then
        alias scli='sudo /opt/QLogic_Corporation/SANsurferCLI/scli'
        alias powermt='sudo /etc/powermt'
        alias ipfr='sudo ipf -FA -f /etc/ipf/ipf.conf'
        alias netlstat='netstat -an -f inet | grep LISTEN | less'

        whichport() {
            sudo snoop -d ${1} -s 1500 -x0 -c 1 'ether[20:2] = 0x2000'
        }

    fi
