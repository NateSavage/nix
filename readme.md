## ❄️ Nate's NixOS Mono-Flake ❄️

This is me exploring how to work with Nix and shows how my personal machines are currently running. I am not an expert, this is just what makes sense to me after hours of reading and making the compiler angry. Nix is a package manager, functional programming language, and build system that makes declarative system configurations possible.

You can use Nix as a package manager on Mac or Linux to create clean build environments without dirtying your system, or declaritivly managing your home directory and config files.

### Structure Explanation
<pre>
📦nix-configuration
 ┣ 📂home - things to be setup in each user's home directory, how they like their environment configured
 ┃ ┣ 📂alice
 ┃ ┃ ┣ 📂always - things alice wants across all hosts
 ┃ ┃ ┣ 📂app-configs - how alice likes each program configured
 ┃ ┃ ┣ 📂at - defines alices environment on each host using everything in her folder
 ┃ ┃ ┃ ┣ ❄️desktop.nix
 ┃ ┃ ┃ ┣ ❄️work-laptop.nix
 ┃ ┃ ┃ ┗ ❄️home-server.nix
 ┃ ┃ ┗📂 feature-sets - things alice commonly bundles together
 ┃ ┗ 📂bob
 ┣ 📂hosts - system-wide configuration for each machine
 ┃ ┣ 📂desktop
 ┃ ┃ ┣ ❄️configuration.nix - users, modules, services, this host should have
 ┃ ┃ ┗ ❄️hardware-configuration.nix - things that may need to change if the host is moved to a different physical device
 ┃ ┣ 📂work-laptop
 ┃ ┗ 📂home-server
 ┣ 📂modules - any self contained thing, or bundle of things we install on a system
 ┃ ┣ 📂always - modules that all host machines need
 ┃ ┣ 📂apps - any individual program the user or system may invoke
 ┃ ┣ 📂feature-sets - bundles of apps/services that commonly go together
 ┃ ┗ 📂services - modules that will run automatically or in the background
 ┣ 📂users - logical understanding a host machine needs when configuring a user, like their name and what groups they belong to.
 ┃ ┣ 📂alice
 ┃ ┗ 📂bob
 ┣ ❄️flake.nix - ties everything in the repository together, informs nix what to include for each host and user
 ┣ ❄️flake.lock - holds specific versions for other flakes this flake relies on
 ┣ 📜justfile - recipies for shortening long winded commands I've typed too many times
 ┗ ❄️shell.nix - shell environments that can be invoked with one command for various tasks 

Things I've seen other nix users include that I'm not using.
┣ 📂overlays - changes overriding default settings from up stream packages
              ^ I don't use this because I consider all of my modules to potentially be overlays
</pre>

### Structure Notes
When importing a folder Nix will handle what tha means differently depending on if the folder contains a file called `default.nix`  or not. see [default-nix-expression in the manual](https://nix.dev/manual/nix/2.24/command-ref/files/default-nix-expression.html).

NixOS should generate your hardware configuration and flake.lock file for you, you don't need to tamper with them at first. If you've already broken your hardware configuration you can generate it again using [nixos-generate-config](https://www.mankier.com/8/nixos-generate-config).

### Things that have helped me along the way
I'm assuming that since you're looking at nix configurations, you've already figured out how to install nix on your system. These resources are all things worth exploring once you have a nix environment to play in. The first thing you should be doing if you're just getting started in your environment, is to make it as fast and easy to edit and rebuild your configuration as possible. Using a text editor you **already like**, maybe this means synchronizing changes from your non-nix machine using git or rsync. After that, really understanding the nix language by trying to do things with it will help you the most.

#### Language and Nixisms
- [Zero to Nix](https://zero-to-nix.com/) by [Determinate Systems](https://determinate.systems/)
- [Just Enough Nixlang](https://tonyfinn.com/blog/nix-from-first-principles-flake-edition/nix-4-just-enough-nixlang/) by [Tony Finn](https://tonyfinn.com/)
- [Nix - A One Pager](https://github.com/tazjin/nix-1p)
- [Nix Reference Manual](https://nix.dev/manual/nix/2.24/language/index.html), link to the language section of the full manual
- [Nix source code](https://github.com/NixOS/nixpkgs) can be more helpful than it's documentation once you know a little about the language
- [Noogle](https://noogle.dev) search for nix functions
- [search.nixos.org](https://search.nixos.org/packages) search for nix packages
---

#### Example configs
- [Misterio77](https://github.com/Misterio77)(Gabriel Fontes)'s [nix-config](https://github.com/Misterio77/nix-config), I think responsible for popularizing the general layout of configuration flakes like mine.
- [EmergentMind](https://www.youtube.com/@Emergent_Mind)'s [nix-config](https://github.com/EmergentMind/nix-config), includes many advanced features like disko, impermenance, and sops with yubikey support.

---

#### Basic Nix Tools
 - [nh](https://github.com/viperML/nh) (yet another nix helper), simplifies and pretties up nix and home manager's built in commands. Includes a search command for finding nix packages, and a tool to run the nix garbage collector at regular intervals.
 - [deadnix](https://github.com/astro/deadnix) cli tool for scanning your flake for inputs that aren't used.
 - [just](https://github.com/casey/just) a command runner. not nix related, but generally very helpful for simplifying the things you find yourself doing over and over.
---

#### Advanced Nix Tools
get comfortable with the language and basics of configuring nix before using these. I suggest you learn these in the order they're listed.

- [home-manager](https://github.com/nix-community/home-manager), configure your home directory and application configs using nix. (availble for MacOS as well!)
- [nix-sops](https://github.com/Mic92/sops-nix), wrapper for Mozilla [secret operations](https://github.com/getsops/sops). will allow you to safely have password protected system configurations stored in public places for easy access. I suggest reading [Handling Secrets in NixOS](https://lgug2z.com/articles/handling-secrets-in-nixos-an-overview/) by [LGUG2Z](https://github.com/LGUG2Z).
- [disko](https://github.com/nix-community/disko) declare your disk partitions and formats using nix.
- [impermenance](https://github.com/nix-community/impermanence) declare what should be kept on your system using nix, regularly wipe the rest.
- [nixos-anywhere](https://github.com/nix-community/nixos-anywhere) hijack most Linux system you can ssh into, and overwrite it with one of your nix configurations.
- [hydra](https://github.com/NixOS/hydra) continuous build system declared using nix.
---

#### System Fine Tuning
- [Nix: Reasonable Default Configs](https://jackson.dev/post/nix-reasonable-defaults/) by Patrick Jackson
---

