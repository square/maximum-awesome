export PATH=${PATH}:~/.local/binexport PATH="/usr/local/sbin:$PATH"
export PATH=~/.local/bin/:${PATH}

alias fixscreen="cscreen -d 32 -x 2560 -y 1440 -r 60 -s 1"

if [ -d /usr/local/etc/bash_completion.d ]; then
    for F in "/usr/local/etc/bash_completion.d/"*; do
        if [ -f "${F}" ]; then
            source "${F}";
        fi
    done
fi
