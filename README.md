<iframe frameborder="0" width="100%" height="500px" src="https://repl.it/@0-vortex/replit-node16-npm8-global-starter?embed=true"></iframe>

# Getting started with Nix Shell on Replit

> Warning: Nix support on Replit is still under heavy development and is subject to change.

You've just created a new Nix repl. There's not much here yet but with a little work you can use it as the starting point for *ANYTHING*.

To get started there are 2 config files that you can use to customize the environment. To show them click the 3 dots menu button in the file tree and then click "Show config files".

### `shell.nix` - Configures the nix shell environment

This file should look something like the example below. The `deps` array specifies which Nix packages you would like to be available in your environment. You can search for Nix packages here: https://search.nixos.org/packages

What we are doing here is getting a sandbox reload mechanism, `node@16` lite and a separate binary install of `npm@8` which wo then configure to sensible userspace defaults:

```nix
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
```

### `.replit` - Configures the run command

The run command in this file should look something like this. You can use any binary made available by your `shell.nix` file in this run command.

We assume it will be npm scripts that you want to run.

```toml
language = "nix"
run = "node -v && npm -v"

[packager]
language = "nodejs-npm"

  [packager.features]
  packageSearch = true
  guessImports = false

[unitTest]
language = "nodejs"

[languages.javascript]
pattern = "**/*.js"
syntax = "javascript"

  [languages.javascript.languageServer]
  start = [ "typescript-language-server", "--stdio" ]

[nix]
#channel = "unstable"
channel = "stable-21_11"

[env]
XDG_CONFIG_HOME = "/home/runner/.config"
```

You can manually restart the environment by running:

```shell
busybox reboot
```

Once both those files are configured and you add files for your language, you can run you repl like normal, with the run button.

Both the Console and Shell will pick up changes made to your `replit.nix` file. However, once you open the Shell tab, the environment will not update until you run `exit`. This will close out the existing `shell` process and start a new one that includes any changes that you made to your `replit.nix` file.

### Credits and inspiration

- [@replit/Nix-beta](https://replit.com/@replit/Nix-beta?v=1)
- [@RoBlockHead/NodeJS-16](https://replit.com/@RoBlockHead/NodeJS-16?v=1)
- [@amasad/Live-Coding-in-Nodejs](https://replit.com/@amasad/Live-Coding-in-Nodejs?v=1)
- [@ConnorBrewster/BetterNode-3](https://replit.com/@ConnorBrewster/BetterNode-3?v=1)
- [replit blog nix dynamic version](https://blog.replit.com/nix_dynamic_version)

## Learn More About Nix

If you'd like to learn more about Nix, here are some great resources:

* [Getting started with Nix](https://docs.replit.com/programming-ide/getting-started-nix) - How to use Nix on Replit
* [Nix Pills](https://nixos.org/guides/nix-pills/) - Guided introduction to Nix
* [Nixology](https://www.youtube.com/playlist?list=PLRGI9KQ3_HP_OFRG6R-p4iFgMSK1t5BHs) - A series of videos introducing Nix in a practical way
* [Nix Package Manager Guide](https://nixos.org/manual/nix/stable/) - A comprehensive guide of the Nix Package Manager
* [A tour of Nix](https://nixcloud.io/tour) - Learn the nix language itself
