# Notepad Mono

[![](https://img.shields.io/github/actions/workflow/status/mrsinho/notepad-mono/linux.yaml?style=for-the-badge&label=Nix%20Linux%20build&labelColor=grey&logo=linux)](https://github.com/MrSinho/notepad-mono/actions)
[![](https://img.shields.io/github/actions/workflow/status/mrsinho/notepad-mono/android.yaml?style=for-the-badge&label=Nix%20Android%20build&labelColor=grey&logo=android)](https://github.com/MrSinho/notepad-mono/actions)
[![](https://img.shields.io/github/actions/workflow/status/mrsinho/notepad-mono/windows.yaml?style=for-the-badge&label=Actions%20Windows%20build&labelColor=grey&logo=github)](https://github.com/MrSinho/notepad-mono/actions)

![](https://img.shields.io/github/license/mrsinho/notepad-mono?style=for-the-badge)

[![CodeFactor](https://www.codefactor.io/repository/github/mrsinho/notepad-mono/badge)](https://www.codefactor.io/repository/github/mrsinho/notepad-mono)

An open source app to write and sync your monospace notes everywhere.

<p align="center">
<img src="./docs/media/frame/frameitHomeDesktop.png"/>
</p>

## Features

* Use a simple notepad with the same editing experience of an advanced text editor
* Cross platform with Windows, Linux and Android binaries
* Data syncronization across multiple devices using your Google, Github and Microsoft accounts
* Pretty UI and status bar

<p align="center">
<img src="./docs/media/frame/frameitEditDesktop.png"/>
</p>


## Clone repository

```bash
git clone https://github.com/mrsinho/notepad-mono.git
```

## Easy flutter build

### ![](https://a11ybadges.com/badge?logo=windows)

```shell
cd app
flutter build linux --release
```

### ![](https://a11ybadges.com/badge?logo=linux)

```shell
cd app
flutter build windows --release
```


## Build from source with Nix flake

The Nix flake will download the required packages, compile and patch the Linux and Android binaries. Since application relies on external packages from [pub.dev](https://pub.dev) you must disable the `sandbox` option.

If you don't have installed nix on your system, you can follow the [official guide](https://nixos.org/download) for all platforms.

### ![](https://a11ybadges.com/badge?logo=linux) ![](https://a11ybadges.com/badge?logo=nixos)

```shell
nix build --option sandbox false --verbose ./nix/allarch-linux --out-link ./nix/out/x86_64-linux/result
./nix/out/x86_64-linux/result

nix build --option sandbox false --verbose ./nix/allarch-linux --out-link ./nix/out/aarch64-linux/result -E 'with import <nixpkgs> { crossSystem = { config = "aarch64-unknown-linux-gnueabi"; }; }; headscale'
```

> [!NOTE]
> If you are running the application on NixOS, be sure you have enabled the **UDP port 3000**.

```nix
networking.firewall = {
  enable = true;
  allowedTCPPorts = [
    # [...]
  ];
  allowedUDPPorts = [
    # [...]
    3000
  ];
};
```

### ![](https://a11ybadges.com/badge?logo=android)

```shell
nix build --option sandbox false --verbose ./nix/aarch64-android --out-link ./nix/aarch64-android/result
./nix/aarch64-android/result
```

### Update flake locks (devs only)



<p align="center">
<img src="./docs/media/mockupuphone/googlePixel8Obsidian/homeMobile-portrait.png" width="200"/>
<img src="./docs/media/mockupuphone/googlePixel8Obsidian/editMobile-portrait.png" width="200"/>
</p>

## Check Android Manifest in the .apk file

```bash
# Starting from repo root directory, after nix build
cd result/android
aapt dump xmltree notepad_mono.apk AndroidManifest.xml
```

## Android diagnostic

- Enable the developer options on your Android device
- Enable USB debug in the developer options
- Connect the device to a USB data port with a USB data cable
- From the terminal with the [Android Debug Bridge (adb)](https://developer.android.com/tools/adb) installed these commands might be useful.

```bash
# Check devices
adb devices

# Find package relative to the newly installed app
adb shell pm list packages | grep notepad_mono

# Send redirect action
adb shell am start -a android.intent.action.VIEW -d "notepad-mono://login-callback"
```

## Data hosting and transparency

Currently the notes and databases are hosted by [Supabase](https://https://supabase.com/). While the database is encrypted and has RLS enabled, admin devs can still theoretically have access to the notes content. For safety reasons it's highly recommended to NOT save sensitive data such as passwords and personal information.

## License

This project is licensed under the [**GNU General Public License v3.0**](https://github.com/MrSinho/notepad-mono/blob/main/LICENSE)

