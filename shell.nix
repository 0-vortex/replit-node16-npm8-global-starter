{ pkgs ? import <nixpkgs> {} }:

let
  NPM_CONFIG_PREFIX = "/home/runner/.npm-global";

in
  pkgs.mkShell {
    inherit NPM_CONFIG_PREFIX;

    packages = with pkgs; [
      busybox
      (nodejs-16_x.override {
        enableNpm = false;
      })
      (nodePackages.npm.override {
        version = "8.3.0";
        src = fetchurl {
          url = "https://registry.npmjs.org/npm/-/npm-8.3.0.tgz";
          sha512 = "ug4xToae4Dh3yZh8Fp6MOnAPSS3fqCTANpJx1fXP2C4LTUzoZf7rEantHQR/ANPVYDBe5qQT4tGVsoPqqiYZMw==";
        };
      })
      nodePackages.typescript-language-server
    ];

    shellHook = ''
      rm -rf "${NPM_CONFIG_PREFIX}"
      mkdir -p "${NPM_CONFIG_PREFIX}"
      export PATH="${NPM_CONFIG_PREFIX}/bin:$PATH"
      npm config -g set prefix "${NPM_CONFIG_PREFIX}"
    '';
  }
