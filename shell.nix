{ pkgs ? import <nixpkgs> {} }:

let
  NPM_CONFIG_PREFIX = "/home/runner/.npm-global";

in
  pkgs.mkShell {
    packages = with pkgs; [
      nodejs-16_x
      nodePackages.npm
    ];

    inherit NPM_CONFIG_PREFIX;

    shellHook = ''
      npm set prefix "${NPM_CONFIG_PREFIX}"
      export PATH="${NPM_CONFIG_PREFIX}/bin:$PATH"
      npm i -g npm@latest
    '';
  }
