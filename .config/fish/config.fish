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

if test -d /opt/homebrew/bin
    if status is-interactive
        eval (/opt/homebrew/bin/brew shellenv)
    end
end

# ======================================================================== #
# Customized command
# ======================================================================== #

# brew install eza bat ripgrep fd
# cargo install eza ; cargo install bat ; cargo install ripgrep ; cargo install fd-find

# brew install fzf
# sudo apt-get install fzf

function cd
    builtin cd $argv
    ls
end

# https://github.com/eza-community/eza
if command -sq eza
    alias ls 'eza -lg --octal-permissions --time-style long-iso --icons'
    alias l 'eza -lg --octal-permissions --time-style long-iso --icons'
    alias la 'eza -lag --octal-permissions --time-style long-iso --icons'
    function lt
        if count $argv >/dev/null
            eza -lT --git --git-ignore --octal-permissions --time-style=long-iso --icons -L=$argv
        else
            eza -lT --git --git-ignore --octal-permissions --time-style=long-iso --icons -L=2
        end
    end
else
    alias l ls
    alias la 'ls -ahl'
end

# https://github.com/sharkdp/bat
if command -sq bat
    # bat --list-themes
    alias c 'bat --theme="OneHalfDark"'
else
    alias c cat
end

# https://github.com/BurntSushi/ripgrep
if command -sq rg
    alias gr rg
    alias grl 'rg -l'
end

# https://github.com/sharkdp/fd
if command -sq fd
    alias f fd
    alias rmds 'fd -IH ".DS_Store" | xargs rm'
    alias cleanc 'fd -e c -e h -e cpp -x clang-format -i'
    alias cleanmd 'fd -e md -x xargs prettier --write'
    alias cleanjson 'fd -e json -x prettier --no-config -w'
    alias cleanyml 'fd -e yml -e yaml -x prettier --no-config -w'
    alias cleanpy 'black .'
    alias cleansh 'fd -e sh -x xargs shfmt -i 2 -w'
    alias cleancss "fd -e css -E '*min.css' -x prettier --no-config -w"
    alias cleanjs "fd -e js -E '*min.js' -x prettier --no-config -w"
    alias cleants 'fd -e ts -e tsx | xargs prettier --write'
    alias cleanhtml 'fd ".*.html" -E ".*min.html" | xargs js-beautify -I -r -n -s 2 --no-preserve-newlines'
end

# https://github.com/junegunn/fzf
# $ brew install fzf ; /usr/local/opt/fzf/install
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
        ag --ignore-case '^host [^*]' ~/.ssh/config* | cut -d ' ' -f 2 | fzf --border --reverse | read -l result; and ssh "$result"
    end
end

# https://github.com/Gallopsled/pwntools
function exploit
    pwn template --host $argv[1] --port $argv[2] $argv[3] >exploit.py | black exploit.py
end

# https://formulae.brew.sh/formula/gnu-sed
if command -sq gsed
    alias sed gsed
end

function rmspace
    rename 's/ /_/g' $argv[1]
end

function update
    # macOS
    if command -sq sw_vers
        brew upgrade
    end
    # ubuntu
    if command -sq lsb_release
        sudo apt update && sudo apt upgrade -y
    end
    if command -sq mise
        mise self-update
        mise upgrade
    end
    if test -d ~/.cargo
        rustup self update
        rustup update
    end
    if test -d ~/.rye
        rye self update
        rye self completion --shell fish > ~/.config/fish/completions/rye.fish
    end
    if command -sq devbox
        devbox version update
        devbox completion fish > ~/.config/fish/completions/devbox.fish
    end
    if command -sq npm
        npm i -g npm yarn
        npm i -g npm-check-updates prettier prettier-plugin-java @prettier/plugin-php @prettier/plugin-ruby fast-cli aws-cdk
        npm update -g
        npm cache verify
        npm list -g --depth=0
    end
    if command -sq yarn
        yarn global upgrade
        yarn cache clean
        yarn global list --depth=0
    end
    if command -sq pip
        pip install -U pip
        pip install -U pipdeptree black isort pycryptodome requests numpy sympy scipy gmpy2 matplotlib bandit
    end
    if command -sq ghq
        ghq list | grep github.com | ghq get --update --parallel
    end
end

# ======================================================================== #
# Shorthand command
# ======================================================================== #

alias ] 'cd ../'
alias de 'cd ~/Desktop'
alias dl 'cd ~/Downloads'
alias do 'cd ~/Documents'
alias pj 'cd ~/Project'
alias gh 'cd ~/src/github.com/hi120ki'

alias rmr 'rm -rf'
alias cl clear
alias fishrc 'code ~/.config/fish/config.fish'
alias ncf 'nano ~/.config/fish/config.fish'
alias ghidra '~/ghidra/11.0/ghidraRun'
alias sha256 'shasum -a 256'

# Git
alias g git
alias gl 'git pull'
alias ga 'git add --all'
alias gc 'git commit -m'
alias gp 'git push origin (git_current_branch)'

# Docker
alias d docker
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
alias dockercleanall 'docker ps --format "{{.Names}}" | xargs docker stop ; docker ps -a --format "{{.Names}}" | xargs docker rm ; docker images --format "{{.Repository}}:{{.Tag}}" | xargs docker rmi ; docker network prune -f ; docker volume prune -f ; docker builder prune -f ; docker system prune -f'

# Docker Compose
alias dc 'docker compose'
alias dcb 'docker compose pull ; docker compose build --pull'
alias dcu 'docker compose up'
alias dcup 'docker compose up -d'
alias dcso 'docker compose stop'
alias dcrm 'docker compose rm -f'
alias dcps 'docker compose ps'
alias dcex 'docker compose exec'

# Vagrant
alias v vagrant
alias vup 'vagrant up'
alias vssh 'vagrant ssh'
alias vstat 'vagrant status'
alias vdest 'vagrant destroy -f'
alias vhalt 'vagrant halt'
alias vrelo 'vagrant reload'

# Vbox
alias vb vboxmanage
alias vbs 'vboxmanage list runningvms'
alias vbsa 'vboxmanage list vms'
alias vbc 'VBoxManage list vms | grep inaccessible | cut -d "{" -f2 | cut -d "}" -f1 | xargs -L1 VBoxManage unregistervm'

# ======================================================================== #
# OS command
# ======================================================================== #

# macOS
if command -sq sw_vers
    alias xcodeselect 'sudo rm -rf (xcode-select -print-path) ; xcode-select --install'
    alias launchpad 'defaults write com.apple.dock ResetLaunchPad -bool true ; killall Dock'
end

# ======================================================================== #
# Path
# ======================================================================== #

# mise
if test -f ~/.local/bin/mise
    ~/.local/bin/mise activate fish | source
end

# rust
if test -d ~/.cargo
    set -x PATH ~/.cargo/bin $PATH
end

# rye
if test -d ~/.rye
    set PATH $PATH ~/.rye/shims
end

# MySQL client
if test -d /opt/homebrew/opt/mysql-client
    set PATH $PATH /opt/homebrew/opt/mysql-client/bin
end
