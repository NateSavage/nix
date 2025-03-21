# Terminal based text editor with mouse support https://micro-editor.github.io/
{ lib, config, pkgs,... }:
let
  module = config.programs.micro;
in{

  options.programs.micro = {
    # home manager already has a micro module, we're only extending the existing one
    #enable = lib.mkEnableOption "[micro](https://micro-editor.github.io/), a terminal editor with mouse support";

    isDefaultEditor = lib.mkOption {
      type = lib.types.bool;
      default = "true";
      description = "sets the EDITOR and VISUAL environment variables to micro unless set to false";
    };
  };

  config = { # lib.mkIf module.enable

      home.sessionVariables = { # lib.mkIf module.isDefaultEditor
         EDITOR = "micro";
         VISUAL = "micro"; # "advanced" full screen text editor
      };

      programs.micro = {
       	enable = true;
        package = pkgs.micro;
       	settings = {
       	  # show only file name below files instead of full path
          basename = false;

          clipboard = "terminal";

          # display diff indicators before lines.
          diffgutter = true;

          # integrates the diffgutter option with Git. If you are in a Git directory, the diff gutter will show changes with respect to the most recent Git commit rather than the diff since opening the file.
          diff = true;

          # highlight all search text in document instead of one at a time
          hlsearch = true;

          keepautoindent = true;

          # the number of lines from the current view to keep in view when paging up or down.
          pageoverlap = 16;

          #pluginrepos = ;

          scrollbar = true;

          # navigate spaces at the beginning of lines as if they are tabs (e.g. move over 4 spaces at once). This option only does anything if tabstospaces is on.
          tabmovement = true;

          # use spaces instead of tabs.
          tabstospaces = true;
          tabsize = 2;
       	};
      };
    };
}
