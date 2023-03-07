---
pagetitle: "SARS-CoV-2 Genomics"
editor_options: 
  markdown: 
    wrap: sentence
---

# Managing and Running Bioinformatics Software

**Note:** This page is under revision.

If you are attending one of our workshops, we will provide a virtual training environment with all of the required software and data pre-installed.
In this page you will learn to manage bioinformatics software installation and setup.
You will also learn why most bioinformatic tools run on Linux.
With this regard you will learn typical environment in which you can setup and run Ubuntu Linux OS in your Windows PC taking into consideration the fact that many PCs users are in Windows.
If you run Windows and you want to setup your own computer to run the analysis demonstrated on this course, you can follow the instructions below.
However, if you have already Linux in your PC/Server or you want to install fresh Ubuntu Linux you can follow the instruction from th [Install Linux](##Install%20Linux) section.

::: note
The `viralrecon` pipeline that we cover in this workshop can run on a regular desktop (e.g. with 4 CPUs and 16GB RAM).
However, if you are processing hundreds of samples, it may take several hours or even days.

For general bioinformatic applications, we recommend investing in a high-performance desktop workstation.
The exact specifications depend on the application, but as a minimum at least 32 threads and 64GB RAM.
:::

## Software architecture for bioinformatics

Apart from having key hardware parts such as CPU, memory and Storage, any computer system running bioinformatics tools consists of the following software architecture; operating system (OS) in this case Linux, package manager(s), and bioinformatics software as illustrated in the following diagram.

![Typical software architecture from the perspective of bioinformatics software when it runs in in any computer system](images/bioinformatics_software_architecture.png)

This is pretty much similar architecture of any application software that runs on any standard PC.

However, bioinformatics software/tools most of them are primarily written to run on machine running Linux based operating systems (OS).
There could be a lot of reasons for this, but we outline the following ones.

-   Many bioinformatics tools are only available for Linux
-   More secure for medical-related data
-   Linux has built-in programming languages (Python, Perl)
-   Linux is free and open source
-   Linux has flexible built-in tools to manipulate large data
    -   `cat`, `grep`, `sed`, `awk`, and the `|` pipe for chaining commands

::: warning
Try to open a large FASTA file (human assembly contig file) in Windows Notepad → the max size it can handle is 58Mb!
:::

Despite the above advantages of Linux OS over Windows from bioinformatics perspective, many PCs users appear to be Windows savy mainly due to inherent and historical reasons particularly the fact that Windows was the earliest Graphical User Interface (GUI) OS, so many applications were written in GUI and therefore gained popularity among users who had average knowledge of computer.

The first step for running bioinformatics software in your Windows machine is to ensure that Linux OS runs on your machine.
The question is how can we setup Linux OS (preferred Ubuntu) on your Windows machine?

### Setting up Linux environment on Windows OS

There are different ways to run bioinformatics tools on your Windows machine.

-   WSL2 (Windows Subsystem for Linux) version 2 - In this way you install a preferred Linux distribution on Windows after enabling WSL feature within Windows.
-   Linux emulator using Virtualisation software setup - You can use a preferred virtual machine software (Oracle Virtualbox) which will host a Linux distribution of your choice which runs on top of Windows.
-   Dual booting
-   Installing docker for Windows - In this way you run containerised bioinformatics tool on Windows using docker.

#### WSL2

WSL2 enables you to run Linux software on Windows natively.
This section describes step by step on how to install WSL on Windows 11.
For Windows 10 instructions are [here](https://cambiotraining.github.io/sars-cov-2-genomics/104-wsl_windows.html "WSL2").
We advise that you update Windows 10 to 11 as it seems that WSL2 can be smooth installed on the Windows 11.

To run WSL use the following command:

```{bash}
wsl --install
```

The above command will download the Linux kernel, set WSL2 as default, and install Ubuntu as default Linux distribution.

If you don't want Ubuntu you can use the following command:

```{bash}
wsl --install -d <distro name>
```

After either of the above commands you will find an app called Ubuntu (or other distro of your choice).

Then open the Ubuntu app that you just installed, and you will find Linux terminal.
And then try to run some Linux commands.

#### Virtual Machine (VM)

Another way of running bioinformatics based software is to install and run Virtual Machine (VM).
The VM enables you to run a guest OS, (in this case Ubuntu) on top of a host OS (example Windows).
Normally, the guest OS will have a real feeling of running on its own PC.
When you run VM you will also be able to run any GU based software.

The most popular VM software are:

-   VMware workstation (<https://www.vmware.com/products/workstation-pro.html>)

-   Oracle VirtualBox (<https://www.virtualbox.org/>)

The full instructions and commands to run Oracle VirtualBox are explained in the managing software installations instructions page (link).

#### Dual Booting

Dual booting is the mechanism of installing and managing two operating systems aside one another in the same machine.
Using dual booting technique you can install and run Linux OS as well as Windows, and therefore being able to install and run bioinformatics software for your analysis.
In dual booting the full installation of Linux OS of your choice will performed and during running time, the Linux OS will have full control of the hardware of your machine.

The installation requires somehow an advance knowledge of both hardware and system software.
During the start of the PC/Server after the dual boot installation, you will be given the options of selecting which OS you want to choose to control your PC and running other application software (in this case a Linux based bioinformatics software).

#### Docker

If Linux installation seems to be a daunting task, alternatively you can install docker for windows which can be downloaded from this [link](https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe) and the detailed instructions on installing docker for Windows has been explained [here](https://docs.docker.com/desktop/install/windows-install/).
In certain circumstances your systems may no meet the requirements to run docker for Windows, if so please download a [Docker Toolbox](https://docs.docker.com/toolbox/overview/).
The major problem for Docker option is that there are available bioinformatics tools you may want to use for analysis which does not have docker images.
There is a useful docker hub for most bioinformatics tools [here](https://pegi3s.github.io/dockerfiles/).
Furthermore, you need a basic Docker understanding.
There is a good tutorial to start practicing Docker from [freeCodeCamp](https://www.freecodecamp.org/news/the-docker-handbook/).

### Package Manager(s)

The next step after having the Linux distribution of your choice in your machine is to ensure that the package manager(s) are installed.
Most bioinformatics tools require package manager(s) to handle different dependencies (libraries) which they need to run correctly in the Linux system.
So, what is a package manager?
A package manager is a software which takes care all necessary dependencies required by bioinformatics tool to run in a proper manner in Linux OS.

#### Package managers that are part of Linux ecosystem

There are package managers, which are Linux based and that are shipped with Linux OS. Example of Linux based package managers are 'apt'/'apt-get', 'dpkg', and 'yum/RPM' for Ubuntu, Debian (or derivative of Debian such as Ubuntu), and RedHat Linux based OS such Fedora/CentOS respectively.
Other related package managers for Ubuntu which bioinformatics tools can be embedded include aptitude or snap.
These either of the two are part of the ecosystem of Ubuntu, but they need to be installed before using them.
Instructions on how to use or install these OS based package managers can be found in our page.

#### Conda

In addition, there are other bioinformatics tools that depend on the package managers which are not part of Linux ecosystem and they need to be installed before installing actual bioinformatics tool for your analysis.
The good example of such package managers is 'Conda', which is a Python based.
Many of such bioinformatics tools are available in different Conda channels.
Conda channels are the locations where packages are stored.
Please refer to the diagram in slides.
Conda packages are downloaded from remote channels, which are URLs to directories containing conda packages.
The instructions to install Conda is on this page.

#### Pip

Pip is another Python based package manager, which bioinformatics tools written in python and require other Python libraries to run smoothly.
Pip is a recursive acronym for "Pip installs Python".
Pip can be installed in the Ubuntu using apt but the latest Ubuntu versions are shipped with Python3 which has pre-installed pip3.
Otherwise you need to install it using apt package manager.

To check the pip version i your system you can type this command:

```{bash}
pip3 --version
```

More instructions on installing pip on Ubuntu can be found in the installation instruction page.
