# Terminal based text editor with mouse support https://micro-editor.github.io/

{
  programs.micro = {
  	enable = true;
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
}
