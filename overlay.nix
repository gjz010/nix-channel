final: prev:
let packages = {
    icalinguapp = final.callPackage ./pkgs/icalinguapp {};
    hmcl = final.callPackage ./pkgs/hmcl {};
    blivec = final.callPackage ./pkgs/blivec { enableFFPlay = true; };
    blivec-mpv = final.callPackage ./pkgs/blivec { enableMPV = true; };
    wechat-uos = final.callPackage ./pkgs/wechat-uos {};
    wemeetapp = final.callPackage ./pkgs/wemeetapp {};
    nix-user-chroot = final.callPackage ./pkgs/nix-user-chroot {};
    proxychains-wrapper = final.callPackage ./pkgs/proxychains-wrapper {};
};
examples = {
    egui-test = final.callPackage ./pkgs/examples/egui-test {};
};
in {
    gjz010 = {
      pkgs = packages // examples;
      lib = final.callPackage ./pkgs/lib {};
    };
}
