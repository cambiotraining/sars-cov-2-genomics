---
pagetitle: "Visual Studio Code"
---

## Introduction
Visual Studio Code (or VS Code) is a free, open-source code editor. It is available for Windows, Linux and macOS. This page will give you information on:

- How to download and install VS Code
- Opening a folder in VS code
- Create a new script in VS Code
- Open a Terminal in VS Code


## Download
You can download VS Code from the URL: [https://code.visualstudio.com/download](https://code.visualstudio.com/download) by selecting the right platform.

![VS Code download page](images/vs-code-download-page.png)

To download VS code click on the respective icons, depending on your operating system.

## Installation
To install VS Code on

- macOS
    - Open the folder where you have downloaded VS code. It will be a `.zip` file.
    - Extract the zip contents.
    - After extracting you will see an app `Visual Studio Code.app`. Drag `Visual Studio Code.app` to the `Applications` folder, so that you will open this using the macOS Launchpad.

- Windows
    - Open the folder where you have downloaded VS code.
    - You will find a installer (`VSCodeUserSetup-{version}.exe`). Run the installer and follow the setup steps. It will take a few minutes.

- Linux
    - If you have downloaded the `.deb` file, then follow below instructions for installation
        - Open up the terminal
        - Move to the directory where you have downloaded the `.deb` file.
        - Run the following command to install
        ```bash
        sudo apt install ./<file-name>.deb

        # Replace <file-name> with the name of the vs-code file you have downloaded.
        #
        # If you're on an older Linux distribution, you will need to run this instead:
        # sudo dpkg -i <file-name>.deb
        # sudo apt-get install -f # Install dependencies
        ```
    
    - If you have downloaded the `.rpm` file, then follow below instructions for installation
        - Open up the terminal
        - Move to the directory where you have downloaded the `.rpm` file.
        - Run the following command to install
        ```bash
        sudo dnf install <file-name>.rpm

        # Replace <file-name> with the name of the vs-code file you have downloaded.
        ```

For more instructions on installing VS Code, you may visit [https://code.visualstudio.com/docs/setup/setup-overview](https://code.visualstudio.com/docs/setup/setup-overview).

## Open a folder in VS Code
