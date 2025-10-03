# Notepad Mono

An open source app to write and sync your monospace notes everywhere.

## Features

* Vanilla and Monaco code editors for writing notes with the same experience of an IDE
* Cross platform with Windows, Linux and Android binaries
* Data syncronization across multiple devices using your Google, Github and Microsoft accounts
* Pretty UI and status bar

[!login](./docs/media/login.png)

## Clone repository

```bash
git clone https://github.com/mrsinho/notepad-mono.git
```

## Build Nix flake for reproducibility

![NixOS](https://a11ybadges.com/badge?logo=nixos)

The Nix flake will download the required packages, build and patch the Linux and Android binaries. Since application relies on external packages from [pub.dev](https://pub.dev) you must disable the `sandbox` option.


```shell
nix build . --option sandbox false
./result/linux/notepad_mono
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

## License

This project is licensed under the [**GNU General Public License v3.0**]