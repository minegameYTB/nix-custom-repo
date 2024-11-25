{ lib, stdenv, fetchurl, makeWrapper, python311, dpkg }:

 stdenv.mkDerivation rec {
   pname = "webapp-manager";
   version = "1.3.7";
   arch = "all";

  src = fetchurl {
    url = "http://packages.linuxmint.com/pool/main/w/webapp-manager/${pname}_${version}_${arch}.deb";
    sha256 = "";
  };

 sourceRoot = ".";
 unpackCmd = "dpkg-deb -xv ${pname}_${version}_${arch}.deb ."

 dontConfigure = true;
 dontBuild = true;

 installPhase = ''
   runHook preInstall

   mkdir -p $out/bin \
     $out/{etc,bin,lib/${pname},share/applications,share/doc/${pname},share/icons,share/locale,${pname}}

   echo -e "#!/bin/sh\n./lib/webapp-manager/webapp-manager.py" > $out/bin/${pname}.sh
   pwd
 '';
 }
