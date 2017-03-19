# Path to your oh-my-zsh installation.
export ZSH=$HOME/.dotfiles/zsh

#set Editor
export EDITOR="/usr/local/bin/vim"
export GIT_EDITOR="subl --wait --new-window"

#set highlight for cheat
export CHEATCOLORS=true

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME=af-magic

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy/mm/dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git colored-man colorize github vagrant virtualenv pip python brew-cask brew osx zsh-syntax-highlighting)

# User configuration
export MANPATH="/usr/local/man:$MANPATH"
export PATH="/Users/zhangchen/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"


source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

#Preferred editor for local and remote sessions
#if [[ -n $SSH_CONNECTION ]]; then
#  export EDITOR='vim'
#else
#  export EDITOR='mvim'
#fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Aliases
alias zshconfig="vi ~/.zshrc"
alias -s html=subl   # 在命令行直接输入后缀为 html 的文件名，会在 sublime text 中打开
alias -s rb=subl     # 在命令行直接输入 ruby 文件，会在 sublime text 中打开
alias -s js=vi
alias -s c=vi
alias -s txt=vi
alias vi='vim'
alias ll='ls -altr'
alias grep='grep --color'
alias egrep='egrep --color'
alias fgrep='fgrep --color'
alias date='cal;date'
alias app='cd ~/Applications;ls -l'
alias wor='cd ~/workspace;ls -l'
alias makescript="fc -rnl | head -1 >"
alias genpasswd="strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d '\n'; echo"
alias c="clear"
alias histg="history | grep"
alias ..='cd ..'
alias ...='cd ../..'

#Function
mcd() { mkdir -p "$1"; cd "$1";}
cls() { cd "$1"; ls;}
backup() { cp "$1"{,.bak};}
md5check() { md5sum "$1" | grep "$2";}

extract() {
if [ -f $1 ] ; then
case $1 in
  *.tar.bz2)   tar xjf $1     ;;
  *.tar.gz)    tar xzf $1     ;;
  *.bz2)       bunzip2 $1     ;;
  *.rar)       unrar e $1     ;;
  *.gz)        gunzip $1      ;;
  *.tar)       tar xf $1      ;;
  *.tbz2)      tar xjf $1     ;;
  *.tgz)       tar xzf $1     ;;
  *.zip)       unzip $1       ;;
  *.Z)         uncompress $1  ;;
  *.7z)        7z x $1        ;;
  *)     echo "'$1' cannot be extracted via extract()" ;;
   esac
else
   echo "'$1' is not a valid file"
fi
}
