{ lib, ... }: {
  relativeToFlakeRoot = lib.path.append ../.;

  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;

  # imports default.nix files from every fulder inside the given directory
  importModulesRecursive = dir:
    let
      safeImport = path: if lib.pathExists path then import path else {};
      subdirs = lib.attrNames (builtins.readDir dir);
      importedModules = builtins.attrsets.foldl' (acc name:
        let path = "${dir}/${name}/default.nix";
            contents = safeImport path;
          in acc // { "${name}" = contents; }
      ) {} subdirs;
    in importedModules;
}
