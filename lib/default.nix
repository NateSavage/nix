{ lib, config, ... }: {
  relativeToFlakeRoot = lib.path.append ../.;

  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
}
