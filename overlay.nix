final: prev :
let packages = {
    icalinguapp = final.callPackage ./pkgs/icalinguapp {};
    hmcl = final.callPackage ./pkgs/hmcl {};
    wechat-uos = final.callPackage ./pkgs/wechat-uos {};
    wemeet = final.callPackage ./pkgs/wemeet {};
};
in {
    gjz010 = {
      pkgs = packages;
      lib = final.callPackage ./pkgs/lib {};
    };
}
