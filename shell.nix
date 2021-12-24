{ pkgs ? import <nixpkgs> {} }:

let 
  NPM_CONFIG_PREFIX = "/home/runner/.npm-global";

in pkgs.mkShell {
    packages = with pkgs; [
      nodejs-16_x
      nodePackages.npm
    ];

    inherit NPM_CONFIG_PREFIX;

    shellHook = ''
      export PATH="${NPM_CONFIG_PREFIX}/bin:$PATH"
    '';
  }