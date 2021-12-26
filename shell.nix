{ pkgs ? import <nixpkgs> {} }:

let
  NPM_CONFIG_PREFIX = "/home/runner/.npm-global";

in
  pkgs.mkShell {
    inherit NPM_CONFIG_PREFIX;

    packages = with pkgs; [
      nodejs-16_x
      (nodePackages.npm.override {
        version = "8.3.0";
        src = fetchurl {
          url = "https://registry.npmjs.org/npm/-/npm-8.3.0.tgz";
          sha512 = "ba0e314e869ee03877c9987c169e8c3a700f492ddfa824c0369271d5f5cfd82e0b4d4ce865feeb11a9ed1d047f00d3d560305ee6a413e2d195b283eaaa261933";
        };
      })
    ];

    shellHook = ''
      mkdir -p "${NPM_CONFIG_PREFIX}"
      npm set prefix "${NPM_CONFIG_PREFIX}"
      export PATH="${NPM_CONFIG_PREFIX}/bin:$PATH"
    '';
  }
