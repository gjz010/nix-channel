{stdenv, lib, 
dpkg, lsb-release, bubblewrap, procps, bash, 
coreutils, scrot, fetchurl, buildFHSUserEnv, dbus,
nettools,
autoPatchelfHook,
libsForQt515
}:
let
libsForQt5 = libsForQt515;
wemeet = stdenv.mkDerivation {
  pname = "wemeet";
  version = "2.1.5";
  deb = fetchurl {
    url = "https://updatecdn.meeting.qq.com/cos/e078bf97365540d9f0ff063f93372a9c/TencentMeeting_0300000000_3.12.0.400_x86_64_default.publish.deb";
    sha256 = "NN09Sm8IepV0tkosqC3pSor4/db4iF11XcGAuN/iOpM=";
    meta.license = lib.licenses.unfree;
  };
  buildInputs = with libsForQt5.qt5; [
    qtlocation qtwebengine qtwebchannel qtx11extras
  ];
  nativeBuildInputs = [ autoPatchelfHook libsForQt5.wrapQtAppsHook dpkg];
  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];
  unpackPhase = ''
    echo "  -> Extracting the deb package..."
    dpkg -x $deb ./deb
  '';
  wemeetLibrary = [
    "libdesktop_common.so"
    "libwemeet.so"
    "libwemeet_base.so" "libwemeet_framework.so"
    "libui_framework.so" "libwemeet_util.so" "libnxui_uikit.so"
    "libqt_framework.so" "libqt_util.so" "libqt_ui_framework.so"
    "libqt_uikit.so" "libwemeet_module_api.so" "libwemeet_sdk.so" "libservice_manager.so"
    "libwemeet_qt.so" "libwemeet_app_components.so" "libwemeet_app_sdk.so" "libxnn.so"
    "libxnn_core.so" "libxcast.so" "libxcast_codec.so" "libImSDK.so" "libwemeet_plugins.so"
    "libxnn_media.so"
  ];
  dontWrapQtApps = true;
  installPhase = ''
    echo $foo
    mkdir -p $out/bin $out/lib
    cp -r ./deb/opt/wemeet/bin $out
    rm $out/bin/QtWebEngineProcess
    ln -s ${libsForQt5.qt5.qtwebengine.out}/libexec/QtWebEngineProcess $out/bin
    for lib in $wemeetLibrary; do
        cp ./deb/opt/wemeet/lib/$lib $out/lib
    done
    cp -r ./deb/opt/wemeet/{resources,translations} $out
    mkdir -p $out/share $out/share/applications
    cp -r ./deb/opt/wemeet/icons $out/share
    cp ${./wemeetapp.desktop} $out/share/applications/wemeetapp.desktop
  '';
  postFixup = ''
    wrapQtApp "$out/bin/wemeetapp" --prefix PATH : $out/bin
  '';
};
in wemeet
/*
in
buildFHSUserEnv{
  inherit (wechat) name meta;
  runScript = "${wechat.outPath}/bin/wechat-uos";
  extraInstallCommands = ''
    mkdir -p $out/share/applications
    mv $out/bin/$name $out/bin/wechat-uos
    ln -s ${wechat.outPath}/share/applications/wechat-uos.desktop $out/share/applications
    cp -r ${wechat.outPath}/share/icons/ $out/share/icons
  '';
  targetPkgs = pkgs: [wechat-uos-env openssl dbus nettools];
  extraOutputsToInstall = ["usr" "var/lib/uos" "var/uos" "etc"];
}
*/
