---
pagetitle: "Windows Subsystem for Linux"
---


## Introduction
The WSL is a tool that allows developers/users to run a GNU/Linux environment directly on Windows without any overhead or dual-boot setup. It natively integrates with most applications on your system, allowing for a Linux-like development experience on Windows.

## Resources
There are two main versions of WSL, WSL 1 and WSL 2. Microsoft recommends using WSL 2 as it offers improved performance (over WSL 1) and 100% system call compatibility. WSL 2 is available in Windows 10, Version 1903, Build 18362 or higher.

:::note

To check your Windows version press **Windows Logo Key** + **R**, type **winver**, select OK.

:::

Follow the following instruction to install the WSL 2 on the supported version of Windows:

- [How to Install the Windows Subsystem for Linux 2 on Microsoft Windows 10 - By DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-install-the-windows-subsystem-for-linux-2-on-microsoft-windows-10)

If you are running an old version of Windows then you may follow the following instruction to install the WSL 1

- [Manual installation steps for older versions of WSL - By Microsoft](https://docs.microsoft.com/en-us/windows/wsl/install-manual)

## Navigation in the WSL

Undoubtedly, navigating to the filesystem is one of the crucial things. You might be wondering how to navigate to your `C drive` or `D drive`. You'll find your drives under the `/mnt` directory. To list all the available drives you can do:

```bash
$ ls /mnt
```
```bash
c	d	e
```

So if you want to navigate to `C:` drive, you have to do:
```bash
cd /mnt/c
```

:::note
You may have noticed that the drive letter is in a small case. If you try to use an uppercase letter then you will get an error, "No such file or directory".
:::
