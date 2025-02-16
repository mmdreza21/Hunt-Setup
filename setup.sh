#!/bin/bash
set -e # Exit script on error

# Define color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

install_packages_ubuntu() {
    echo -e "${GREEN}[+] Installing Packages on Ubuntu...${NC}"
    sudo apt update && sudo apt install -y zsh make jq whois python3-pip tmux nmap git curl wget unzip
}

install_rust() {
    if ! command -v rustc &>/dev/null; then
        echo -e "${GREEN}[+] Installing Rust...${NC}"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        . "$HOME/.cargo/env"
    else
        echo -e "${GREEN}[+] Rust is already installed.${NC}"
    fi
}

install_tool() {
    local repo=$1
    local post_install_cmds=$2
    local tool_name=$(basename "$repo" .git)
    local tool_path="$HOME/Tools/$tool_name"

    if [ -d "$tool_path" ] && [ "$(ls -A "$tool_path")" ]; then
        echo -e "${GREEN}[+] $tool_name is already installed. Skipping.${NC}"
        return
    fi

    git clone "$repo" "$tool_path"
    cd "$tool_path"
    eval "$post_install_cmds"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[+] Successfully installed $tool_name${NC}"
    else
        echo -e "${RED}[-] Failed to install $tool_name${NC}"
    fi
    cd - >/dev/null
}

install_tools_from_source() {
    echo -e "${GREEN}[+] Installing Tools from Source...${NC}"
    mkdir -p "$HOME/Tools"

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
    if command -v go &>/dev/null; then
        echo -e "${GREEN}[+] Go is already installed.${NC}"
        return
    fi

    echo -e "${GREEN}[+] Installing Go...${NC}"

    GO_VERSION=$(curl -s https://go.dev/dl/ | grep -oP 'go[0-9]+\.[0-9]+\.[0-9]' | sort -uV | tail -1)
    GO_BINARY_URL="https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz"
    INSTALL_DIR="/usr/local"

    curl -OL "$GO_BINARY_URL"
    sudo tar -C "$INSTALL_DIR" -xzf "${GO_VERSION}.linux-amd64.tar.gz"

    echo "export PATH=\$PATH:$INSTALL_DIR/go/bin" >>"$HOME/.bashrc"
    . "$HOME/.bashrc"

    rm "${GO_VERSION}.linux-amd64.tar.gz"

    echo -e "${GREEN}[+] Installing Go tools...${NC}"
    install_go_tools
}

install_go_tools() {
    go install github.com/tomnomnom/waybackurls@latest
    go install github.com/projectdiscovery/alterx/cmd/alterx@latest
    go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
    go install github.com/projectdiscovery/tlsx/cmd/tlsx@latest
    go install github.com/tomnomnom/anew@latest
    go install github.com/glebarez/cero@latest
    go install github.com/iangcarroll/cookiemonster/cmd/cookiemonster@latest
    go install github.com/ffuf/ffuf/v2@latest
    go install github.com/lc/gau/v2/cmd/gau@latest
    go install github.com/projectdiscovery/httpx/cmd/httpx@latest
    go install github.com/hahwul/dalfox/v2@latest
    go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
    go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
    go install github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
    go install github.com/tomnomnom/unfurl@latest
    go install github.com/projectdiscovery/asnmap/cmd/asnmap@latest
    go install github.com/xm1k3/cent@latest
    go install github.com/projectdiscovery/chaos-client/cmd/chaos@latest
    go install github.com/OJ/gobuster/v3@latest
    go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
    go install github.com/projectdiscovery/katana/cmd/katana@latest
    go install github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest
    go install github.com/projectdiscovery/notify/cmd/notify@latest
    go install github.com/d3mondev/puredns/v2@latest
    go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
    go install github.com/projectdiscovery/uncover/cmd/uncover@latest
    go install github.com/ImAyrix/cut-cdn@latest
    go install github.com/sw33tLie/sns@latest
    go install github.com/BishopFox/jsluice/cmd/jsluice@latest
    go install github.com/ImAyrix/fallparams@latest

    install_tool https://github.com/assetnote/kiterunner.git "make build && ln -s $(pwd)/Tools/kiterunner/dist/kr /usr/local/bin/kr"
}

install_packages_ubuntu
install_rust
install_to
install_go
install_go_tools

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo -e "${GREEN}FINISHED!!!!!${NC}"
