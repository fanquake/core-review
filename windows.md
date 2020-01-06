# Windows 10 Development Setup

## Download
Download a [Windows 10 Development Environment](https://developer.microsoft.com/en-us/windows/downloads/virtual-machines) VM.

## Import & Settings
Import `WinDev1912Eval.ovf` into Virtualbox.

Open Settings:
- System
    - Increase base memory.
    - Increase processor count.

- Display:
    - Increase video memory.

- Audio
    - Disable Audio.

## Boot

Update Virtualbox Gust Additions if required.

Go to `Updates & Security`, install all updates.

Clear the desktop and the taskbar.

Open `Apps & Features`. Uninstall pretty much everything.

Update Visual Studio. Remove everything except the C++ dev workload, git and Python3.

If you want to use WSL, open Ubuntu and update packages. Clone the bitcoin repo etc.

Reboot.

## Install dependencies and generate project files
[Vcpkg](https://github.com/Microsoft/vcpkg.git) is used to install build dependencies.
See the Bitcoin Core [MSVC build docs](https://github.com/bitcoin/bitcoin/tree/master/build_msvc) for more info.

Open `Developer Powershell for VS 2019`:
```powershell
git clone https://github.com/bitcoin/bitcoin.git
git clone https://github.com/Microsoft/vcpkg.git

cd vcpkg
.\bootstrap-vcpkg.bat -disableMetrics

# hook up user-wide integration
.\vcpkg.exe integrate install

# Install Bitcoin Core dependencies
.\vcpkg.exe install --triplet x64-windows-static $(Get-Content -Path ..\bitcoin\build_msvc\vcpkg-packages.txt).split()
cd ..

# Generate Project Files
cd bitcoin\build_msvc
py -3 msvc-autogen.py
```

## Build

```powershell
msbuild /m bitcoin.sln /p:Platform=x64 /p:Configuration=Release /t:build
```

Alternatively, open `bitcoin\build_msvc\bitcoin.sln` in Visual Studio.

If you are asked to `Retarget Projects`, choose `Yes`.

Choose `Release` and `x64`, then `Build -> Build Solution`.

## Create a VM Snapshot

The Microsoft VMs expire after 90 days.

Once everything is setup, take a VM snapshot.

![Windows](screenshots/windows.png)
