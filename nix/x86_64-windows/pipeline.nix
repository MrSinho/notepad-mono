{ nixpkgs, system }:

let
    
    pkgs = import nixpkgs {
        inherit system;
    };

    buildInputs = [
        #pkgs.flutter
        #pkgs.wineWowPackages.full
        #pkgs.wineWowPackages.waylandFull
        #pkgs.winetricks
        pkgs.docker
    ];

    buildPhase = ''
        #winetricks -q cmd powershell powershell_core
        #winetricks -q allfonts corefonts tahoma arial verdana courier gdiplus

        #wine powershell
    '';

    installPhase = ''# $PWD starts from app directory
        #mkdir -p $out/windows

        #cp -r $PWD/build/windows/runner/Release/bundle/* $out/windows/
    '';

in {
    pkgs         = pkgs;
    buildInputs  = buildInputs;
    buildPhase   = buildPhase;
    installPhase = installPhase;
}