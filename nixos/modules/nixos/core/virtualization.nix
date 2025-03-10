{ username, pkgs, ... }: {
  virtualisation.libvirtd = {
    enable = true;
    qemu = { package = pkgs.qemu_kvm; };
  };
  programs.virt-manager.enable = true;
  users.users.${username}.extraGroups = [ "libvirtd" "qemu-libvirtd" "kvm" ];
  users.groups.libvirtd.members = [ "${username}" ];
}
