{ nixpkgs, system }:

let
    
    pkgs = import nixpkgs {
        inherit system;
    };

    buildInputs = [
        windowsPkgs.flutter
        windowsPkgs.wineWowPackages.full
        windowsPkgs.wineWowPackages.waylandFull
        windowsPkgs.winetricks
    ];

    buildPhase = ''
        cd app
        flutter pub get
        flutter create .
        
        flutter build windows --release
    '';

    installPhase = ''# $PWD starts from app directory
        mkdir -p $out/windows

        cp -r $PWD/build/windows/runner/Release/bundle/* $out/windows/
    '';

in {
    pkgs         = pkgs;
    buildInputs  = buildInputs;
    buildPhase   = buildPhase;
    installPhase = installPhase;
}