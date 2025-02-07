## ❄️ Nate's NixOS Mono-Flake ❄️

This is me exploring how to work with NixOS, I am not an expert, this is just what makes sense to me.

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
 ┣ 📂hosts - systemwide configuration for each machine
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
 ┣ 📜justfile - very high level commands for working with the nix configuration
 ┗ ❄️shell.nix - shell environments that can be invoked with one command for various tasks 

Things I've seen other nix users include that I'm not using.
┣ 📂overlays - changes overriding default settings from up stream packages
</pre>

When importing a folder NixOS will import the `default.nix` file underneath it.

NixOS should generate your hardware configuration and flake.lock file

### Things that have helped me along the way
- [Just Enough Nixlang](https://tonyfinn.com/blog/nix-from-first-principles-flake-edition/nix-4-just-enough-nixlang/) by [Tony Finn](https://tonyfinn.com/)
- [Misterio77](https://github.com/Misterio77)(Gabriel Fontes)'s [nix-config](https://github.com/Misterio77/nix-config)
- [NixOS Secrets Management](https://unmovedcentre.com/posts/secrets-management/) by 
[EmergentMind](https://github.com/EmergentMind)
- [NixOS source code](https://github.com/NixOS/nixpkgs) can be more helpful than it's documentation
- [Nix language reference manual](https://nix.dev/manual/nix/2.24/language/index.html)
- [Nix: Reasonable Default Configs](https://jackson.dev/post/nix-reasonable-defaults/) by Patrick Jackson
