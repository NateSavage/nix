
{ pkgs, ... } : {

  programs.neovim.enable = true;
  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    
    plugins = with pkgs.vimPlugins; [
      nerdtree
      vim-gitgutter
    ];
  };
}
