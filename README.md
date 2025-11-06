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

## Release changelog

You can find the release changelog file [here](./CHANGELOG.md).

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
mkdir -p nix/out/linux
nix build --option sandbox false --verbose ./nix/linux --out-link ./nix/out/linux/result
./nix/out/linux/result/NotepadMono
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
mkdir -p nix/out/android
nix build --option sandbox false --verbose ./nix/android --out-link ./nix/out/android/result
```

For some reason during the build Gradle might fail/crash unexpectectly, and this might happen also in the Github actions job. For now rerunning the flake build will solve the issue. 

### Update flake locks (devs only)

<p align="center">
<img src="./docs/media/mockupuphone/googlePixel8Obsidian/homeMobile-portrait.png" width="200"/>
<img src="./docs/media/mockupuphone/googlePixel8Obsidian/editMobile-portrait.png" width="200"/>
</p>

```shell
cd nix/linux
nix flake update
```

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

## Start dummy session

For testing purposes, if you do not want to create a new account you can have access to all the application features using a special URI:

* On desktop devices:

```bash
curl http://localhost:4516//dummy/?key=WQBjbIwEEpxhqCPhxwEFIAivcFdlCXpa
```

* On Android:

```bash
# From any browser or API client you can enter this link: notepad-mono://dummy/?key=WQBjbIwEEpxhqCPhxwEFIAivcFdlCXpa

# Or using the Android Debug Bridge (only debug builds)
adb shell am start -a android.intent.action.VIEW -d "notepad-mono://dummy/?key=WQBjbIwEEpxhqCPhxwEFIAivcFdlCXpa"
```

This `key` parameter corresponds to an environment variable which is read during the compilation of the application.

This "dummy" session is temporary but unlocks all the application features including note creation and editing.

## External packages

All the external packages are pulled from [pub.dev](https://pub.dev) listed with their relative version in the [pubspec.yaml].

## Data hosting and transparency

Currently the notes and databases are hosted by [Supabase](https://https://supabase.com/). While the database is encrypted and has RLS enabled, there is not E2E encryption enabled. admin devs could theoretically have access to the notes content. For safety reasons it's highly recommended to NOT save sensitive data such as passwords and personal information.

For more information about the privacy policy see the [related page](https://github.com/MrSinho/notepad-mono/blob/main/PRIVACY_POLICY.md).

## License

This project is licensed under the [**GNU General Public License v3.0**](https://github.com/MrSinho/notepad-mono/blob/main/LICENSE)

