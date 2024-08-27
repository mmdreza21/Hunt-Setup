#!/bin/bash

### Server setup script ###

# Define color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

install_packages_ubuntu() {
    echo -e "${GREEN}Installing Packages on Ubuntu...${NC}"
    
    sudo apt install -y vim curl zsh git gcc net-tools ruby ruby-dev tmux build-essential postgresql make python3-apt bind9 certbot python3-certbot-nginx libssl-dev zip unzip jq nginx pkg-config mysql-server php php-curl php-fpm php-mysql dnsutils whois python3-pip ca-certificates gnupg tmux nmap libpcap-dev
}

install_rust() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
}

install_tool() {
    local repo=$1
    local post_install_cmds=$2
    local tool_name=$(basename "$repo" .git)
        
    git clone "$repo"
    cd "$tool_name"
    eval "$post_install_cmds"
    if [[ $? -eq 0 ]]; then
        echo -e "[+] Successfully installed $tool_name"
    else
        echo -e "[-] Failed to install $tool_name"
    fi
    cd -
}

install_tools_from_source() {
    echo -e "${GREEN}[+] Installing Tools from source...${NC}"
    mkdir -p Tools && cd Tools

    install_tool https://github.com/blechschmidt/massdns.git "make && sudo make install"
    install_tool https://github.com/robertdavidgraham/masscan.git "make && sudo make install"
    install_tool https://github.com/sqlmapproject/sqlmap.git ""
    install_tool https://github.com/phor3nsic/favicon_hash_shodan.git "sudo python3 setup.py install"
    install_tool https://github.com/0xacb/recollapse.git "pip3 install --user --upgrade -r requirements.txt && chmod +x install.sh && ./install.sh"
    install_tool https://github.com/jim3ma/crunch.git "make && sudo make install"

    pip3 install dnsgen uro dirsearch
    cargo install x8
    cargo install ripgen
    gem install wpscan
}

install_go() {
    get_latest_go_version() {
        curl -s https://go.dev/dl/ | grep -oP 'go[0-9]+\.[0-9]+\.[0-9]' | sort -uV | tail -1
    }

    GO_VERSION=$(get_latest_go_version)

    if [[ -z "$GO_VERSION" ]]; then
        echo -e "${RED}Failed to fetch the latest Go version. Aborting.${NC}"
        exit 1
    fi

    GO_BINARY_URL="https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz"
    INSTALL_DIR="/usr/local"

    curl -OL "$GO_BINARY_URL"
    sudo tar -C "$INSTALL_DIR" -xzf "${GO_VERSION}.linux-amd64.tar.gz"

    echo "export PATH=\$PATH:$INSTALL_DIR/go/bin" >> "$HOME/.bashrc"
    source "$HOME/.bashrc"

    rm "${GO_VERSION}.linux-amd64.tar.gz"

    if go version &> /dev/null; then
        echo -e "[+] Installing go tools..."
        install_go_package() {
            package=$1
            if go install $package &> /dev/null; then
                echo -e "${GREEN}[+] Successfully installed $package${NC}"
            else
                echo -e "${RED}[-] Failed to install $package${NC}"
            fi
        }

        install_go_package github.com/tomnomnom/waybackurls@latest
        install_go_package github.com/projectdiscovery/alterx/cmd/alterx@latest
        install_go_package github.com/projectdiscovery/dnsx/cmd/dnsx@latest
        install_go_package github.com/projectdiscovery/tlsx/cmd/tlsx@latest
        install_go_package github.com/tomnomnom/anew@latest
        install_go_package github.com/glebarez/cero@latest
        install_go_package github.com/iangcarroll/cookiemonster/cmd/cookiemonster@latest
        install_go_package github.com/ffuf/ffuf/v2@latest
        install_go_package github.com/lc/gau/v2/cmd/gau@latest
        install_go_package github.com/jaeles-project/gospider@latest
        install_go_package github.com/projectdiscovery/httpx/cmd/httpx@latest
        install_go_package github.com/hahwul/dalfox/v2@latest
        install_go_package github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
        install_go_package github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
        install_go_package github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
        install_go_package github.com/tomnomnom/unfurl@latest
        install_go_package github.com/projectdiscovery/asnmap/cmd/asnmap@latest
        install_go_package github.com/xm1k3/cent@latest
        install_go_package github.com/projectdiscovery/chaos-client/cmd/chaos@latest
        install_go_package github.com/OJ/gobuster/v3@latest
        install_go_package github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
        install_go_package github.com/projectdiscovery/katana/cmd/katana@latest
        install_go_package github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest
        install_go_package github.com/projectdiscovery/notify/cmd/notify@latest
        install_go_package github.com/d3mondev/puredns/v2@latest
        install_go_package github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
        install_go_package github.com/projectdiscovery/uncover/cmd/uncover@latest
        install_go_package github.com/ImAyrix/cut-cdn@latest
        install_go_package github.com/sw33tLie/sns@latest
        install_go_package github.com/BishopFox/jsluice/cmd/jsluice@latest
        install_go_package github.com/ImAyrix/fallparams@latest
        install_go_package github.com/glitchedgitz/cook/v2/cmd/cook@latest
        install_go_package github.com/BishopFox/sj@latest
        install_go_package github.com/sw33tLie/sns@latest
        install_tool https://github.com/assetnote/kiterunner.git "make build && ln -s $(pwd)/Tools/kiterunner/dist/kr /usr/local/bin/kr" 
    fi
}

install_packages_ubuntu
install_rust
install_tools_from_source
install_go

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo -e "${GREEN}FINISHED!!!!!${NC}"
