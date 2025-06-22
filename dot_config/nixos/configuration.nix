{ config, pkgs, lib, ... }:

{

environment.systemPackages = with pkgs; [
  multipass
];

systemd.services.multipassd = {
  description = "Multipass backend daemon";
  after       = [ "network.target" ];
  wantedBy    = [ "multi-user.target" ];

  serviceConfig = {
    ExecStart = "${pkgs.multipass}/bin/multipassd";
    Restart   = "on-failure";
  };
};

users.users."${builtins.getEnv "USER"}" = {
  isNormalUser = true;
  extraGroups  = [ "kvm" ];
};

}
