# just a command runner https://github.com/casey/just

{pkgs, ...}: {
  environment.systemPackages = [ 
    pkgs.just 
  ];
}