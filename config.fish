# ======================================================================== #
# Fish shell
# ======================================================================== #

# https://github.com/fish-shell/fish-shell
# https://github.com/jorgebucaran/fisher

# fisher install oh-my-fish/theme-bobthefish edc/bass jethrokuan/z

function fish_greeting
end

# https://github.com/oh-my-fish/theme-bobthefish#configuration
set -g theme_powerline_fonts no
set -g theme_nerd_fonts yes
set -g theme_display_date no
set -g theme_color_scheme dracula

# ======================================================================== #
# Customized command
# ======================================================================== #

# brew install exa bat ripgrep fd
# cargo install exa ; cargo install bat ; cargo install ripgrep ; cargo install fd-find

# brew install fzf
# sudo apt-get install fzf

function cd
  builtin cd $argv
  ls
end

# https://github.com/ogham/exa
if command -sq exa
  alias ls 'exa -lg --octal-permissions --time-style long-iso --icons'
  alias l 'exa -lg --octal-permissions --time-style long-iso --icons'
  alias la 'exa -lag --octal-permissions --time-style long-iso --icons'
  function lt
    if count $argv > /dev/null
      exa -lT --git --git-ignore --icons --time-style=long-iso -L=$argv
    else
      exa -lT --git --git-ignore --icons --time-style=long-iso -L=2
    end
  end
else
  alias l 'ls'
  alias la 'ls -ahl'
end

# https://github.com/sharkdp/bat
if command -sq bat
  # bat --list-themes
  alias c 'bat --theme="OneHalfDark"'
else
  alias c 'cat'
end

# https://github.com/BurntSushi/ripgrep
if command -sq rg
  alias gr 'rg'
  alias grl 'rg -l'
end

# https://github.com/sharkdp/fd
if command -sq fd
  alias f 'fd'
  alias rmds 'fd -IH ".DS_Store" | xargs rm'
  alias cleanc 'fd ".*.c" | xargs clang-format -style=Google -i'
  alias cleanmd 'fd ".*.md" | xargs prettier --write'
  alias cleanjson 'fd ".*.json" | xargs prettier --write'
  alias cleanyml 'fd ".*.yml" | xargs prettier --write'
  alias cleancss 'fd ".*.css" -E ".*min.css" | xargs prettier --write'
  alias cleanjs 'fd ".*.js" -E ".*min.js" | xargs prettier --write'
  alias cleanpy 'fd ".*.py" | xargs black'
  alias cleansh 'fd ".*.sh" | xargs shfmt -i 2 -w'
  alias cleanhtml 'fd ".*.html" -E ".*min.html" | xargs js-beautify -I -r -n -s 2 --no-preserve-newlines'
end

# https://github.com/junegunn/fzf
if command -sq fzf
  set -Ux FZF_CTRL_T_COMMAND 'fd --type f --hidden --follow --exclude .git'
  set -Ux FZF_CTRL_T_OPTS '--preview "bat --color=always --style=header,grid --line-range :100 {}"'

  alias gcd 'cd (ghq root)/(ghq list | fzf --border)'
  alias gco 'code (ghq root)/(ghq list | fzf --border)'
  alias gop 'open (ghq root)/(ghq list | fzf --border)'
  alias fcd 'cd (/bin/ls | fzf --border)'

  # https://github.com/junegunn/fzf/wiki/Examples-(fish)
  function fco -d "Use `fzf` to choose which branch to check out" --argument-names branch
    set -q branch[1]; or set branch ''
    git for-each-ref --format='%(refname:short)' refs/heads | fzf --border --reverse --query=$branch --select-1 | xargs git checkout
  end

  # fzf ssh
  # brew install the_silver_searcher
  # sudo apt-get install silversearcher-ag
  function fssh -d "Fuzzy-find ssh host via ag and ssh into it"
    ag --ignore-case '^host [^*]' ~/.ssh/config | cut -d ' ' -f 2 | fzf --border --reverse | read -l result; and ssh "$result"
  end
end

# https://github.com/Gallopsled/pwntools
function exploit
  pwn template --host $argv[1] --port $argv[2] $argv[3] > exploit.py | black exploit.py
end

# https://formulae.brew.sh/formula/gnu-sed
if command -sq gsed
  alias sed 'gsed'
end

# ======================================================================== #
# Shorthand command
# ======================================================================== #

alias ] 'cd ../'
alias de 'cd ~/Desktop'
alias dl 'cd ~/Downloads'
alias do 'cd ~/Documents'
alias pj 'cd ~/Project'
alias vg 'cd ~/Vagrant'

alias rmr 'rm -rf'
alias cl 'clear'
alias fishrc 'code ~/.config/fish/config.fish'
alias ncf 'nano ~/.config/fish/config.fish'
alias ghidra '~/ghidra/10.0/ghidraRun'
alias sha256 'shasum -a 256'

# Python
alias venv 'source venv/bin/activate.fish'
alias venvinit 'rm -rf venv ; python -m venv venv'
alias pipinit 'pip install -U pip ; pip install -U pipdeptree black pycryptodome requests numpy sympy scipy gmpy2 matplotlib bandit pwntools'
alias pipreq 'pip install -r requirements.txt'

# Node.js
alias nup 'npm i -g npm yarn ; npm update -g ; yarn global upgrade ; npm cache verify ; yarn cache clean'

# Git
alias g 'git'
alias gl 'git pull'
alias ga 'git add --all'
alias gc 'git commit -m'
alias gp 'git push origin (git_current_branch)'
alias commit 'git add . ; git commit -m "commit" ; git push origin main'

# Docker
alias d 'docker'
alias dps 'docker ps'
alias dpsa 'docker ps -a'
alias dsa 'docker start'
alias dso 'docker stop'
alias drm 'docker rm'
alias drmi 'docker rmi'
alias dex 'docker exec -it'
alias di 'docker images | sort -k6 -h'
alias dip 'docker image prune -f'
alias dvp 'docker volume prune -f'

# Docker Compose
alias dc 'docker-compose'
alias dcb 'docker-compose build'
alias dcu 'docker-compose up'
alias dcup 'docker-compose up -d'
alias dcso 'docker-compose stop'
alias dcrm 'docker-compose rm -f'
alias dcps 'docker-compose ps'
alias dcex 'docker-compose exec'

# Vagrant
alias v 'vagrant'
alias vup 'vagrant up'
alias vssh 'vagrant ssh'
alias vstat 'vagrant status'
alias vdest 'vagrant destroy -f'
alias vhalt 'vagrant halt'
alias vrelo 'vagrant reload'

# ======================================================================== #
# OS command
# ======================================================================== #

# macOS
if command -sq sw_vers
  alias up 'brew upgrade ; brew upgrade --cask ; anyenv update'
  alias xcodeselect 'sudo rm -rf (xcode-select -print-path) ; xcode-select --install'
end

# ubuntu
if command -sq lsb_release
  alias up 'sudo apt update ; sudo apt upgrade -y'
end

# ======================================================================== #
# Path
# ======================================================================== #

set -x PATH ~/.anyenv/bin $PATH
anyenv init - | source
set -x PATH ~/.pyenv/bin $PATH
pyenv init --path | source

set -x PATH ~/.cargo/bin $PATH
