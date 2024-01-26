---
pagetitle: "SARS Genomic Surveillance"
---

# Linux Virtual Machine {.unnumbered}

## Running Ubuntu on Oracle VirtualBox (OVB)

To install and run Ubuntu on Oracle VirtualBox please follow below instructions:

-   Download and install [Oracle VirtualBox](https://www.virtualbox.org/wiki/Downloads) in your Windows PC

    -   OVB depends on the [Microsoft Visual C++ redistiributable](https://aka.ms/vs/17/release/vc_redist.x64.exe), which should be installed first.
        Otherwise you may get the following error:

        ![](images/VisualC++VMrequired.PNG)

    -   After downloads follow the instructions on the screen to install OVB.

    -   You may also need to install later a Python Core package and the win32api bindings as instructed [here](https://www.sysnettechsolutions.com/en/fix-python-win32api-virtualbox/).
        Otherwise you will get warning message and possibly OVB will not work properly.

        ![](images/python_core_win32api_ovb_installation.PNG)

- While installing Oracle VM, seprately download Ubuntu Linux distribution which is in ISO image [here](https://ubuntu.com/download/desktop/thank-you?version=22.04.2&architecture=amd64) (preferred the latest Ubuntu 22.04).
    Depending in the Internet speed it may take roughly 10 minutes or more to download the latest Ubuntu image ISO.
    In my case it took about 13 minutes to fully download the Ubuntu ISO image.
    
-   After Oracle VM successfully installed, click its desktop icon ![](images/VM_image.jpeg){width="18"} to start your Oracle VM

    -   You will see a window similar like this one:

        ![](images/Welcome_window_OVM.PNG)

-   Set up your Virtual Machine as follows

    -   In the opened up window click 'Machine' menu and in the dropdown menu click 'New'

    -   Name the machine whatever name you would like for instance "Bioinformatics"

    -   Choose the folder where VirtualMachine will reside in your PC.

    -   Then choose downloaded Ubuntu Linux ISO image.
        You can leave to default all other parameters.
        See the diagram below:

        ![](images/ubuntu-22.04.2-desktop-amd64.PNG)

    -   You may want to set up Username and Password of Ubuntu.
        See the diagram below:

        ![](images/UnattendedGuestUserNamePwdChange.PNG)

    -   Select memory size you want for your Ubuntu OS when it runs.
        Drag the slider up to the end of the green bar, which is a safe memory size based on your laptop memory size.

    -   Select the number of processors you want.

        -   For illustration, please see the diagram below.

            ![](images/MemoryCPUSize.PNG)

    -   Create a virtual hard drive.
        Make sure you have enough physical hard drive storage size.
        If you have less than 20Gb free space of your actual memory, probably the installation may not be completed and you may get installation error.

        ![](images/VirtualHardDrive.PNG)

        -   File location and size - default is fine (although in practice they may want to increase this limit for larger data)

-   The next step is to read a summary of all parameters you have selected before actual installation starts as see in the diagram below:

    ![](images/SummaryInstallationParameters.PNG)

    -   Then click next

-   The installation of Ubuntu 22.04 will start and a window like the one below will be appearing.
    While installation in progress, several windows after will be changing.

    ![](images/UbuntuOS_installationVM.PNG)

### For Mac OS users

For mac OS users who want to run linux through VM, please follow the instructions below: 

- Download the virtualbox from [home page](https://www.virtualbox.org/wiki/Downloads). Note that when you download you need to know the exact package based on your type of CPU either Intel, or (M1/M2) Arm64 host.
- Click to open the downloaded file which is in the ".dmg" format. Then double click to begin the installation process.
- Click the continue button when the installation wizard pops up.
- If you are OK with the default installation click OK otherwise you can select different installation location by clicking "Change installation location".
- Click the “Install Software” button to continue the installation process after entering password and admin username.
- If the installation is successful, a pop up windows indicating the installation was completed successful will show up in which case the VirtualBox launcher will be in your application folder.
- Then you can install linux as described in the section above.

## Using apt, apt-get, dpkg or Installing aptitude

After the installation is successfully now it is time to install the package managers.
We will test the Ubuntu shipped package manager which is apt and apt-get both are the same with very minor variation.
Many bioinformatics tools require to first update the system package managers before installing the tool.
In this kind of situation the apt or apt-get is used as shown in the example below.

```bash
sudo apt-get update # Update database packages to the current state 
sudo apt upgrade # upgrade the old package
```

After those two commands you can then install the bioinformatics tools you want, for instance you can install bwa tool for doing mapping using the following commands.

```bash
sudo apt -y install bwa
```

