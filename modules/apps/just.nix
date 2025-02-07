# just a command runner https://github.com/casey/just

{nixpkgs, ...}: {
  environment.systemPackages = [ 
    nixpkgs.just 
  ];
}