# Server Setup Script

This repository contains a comprehensive server setup script designed to streamline the installation and configuration of essential packages and tools for bug bounty hunting and penetration testing.


## Supported Distributions

- Ubuntu

## Usage

1. Clone this repository to your server:
    ```bash
    git clone https://github.com/OoS-MaMaD/Hunt-Setup.git
    cd Hunt-Setup
    ```

2. Make the script executable:
    ```bash
    chmod +x setup.sh
    ```

3. Run the script:
    ```bash
    sudo ./setup.sh
    ```
4. After installation, add these to your zshrc or bashrc profile
   ```bash
   unalias gau    # only if your using zsh
   export PATH=$PATH:/usr/local/go/bin
   export GOPATH=$HOME/go
   export PATH=$PATH:$GOPATH/bin
   ```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.
