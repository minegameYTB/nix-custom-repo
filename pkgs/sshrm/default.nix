{ lib, stdenvNoCC, openssh, fetchFromGitHub }:

 stdenvNoCC.mkDerivation rec {
   repoName = "sshrm";
   pname = "sshrm";
   version = "git-bf29f9b";

  src = fetchFromGitHub {
    owner = "aaaaadrien";
    repo = repoName;
    rev = "bf29f9b4bc83f215ff566df6ed29149ea21632a3";
    sha256 = "sha256-m7ltKxajRHsoops8T/vutbVVya8qCUQLPuO6LjB6LXE=";
  };

  installPhase = ''
    ### Make sshrm available to nix
    mkdir -p $out/bin
    cp ${pname} $out/bin/${pname}
    chmod +x $out/bin/${pname}

    ### Add license file accessible on the right directory
    mkdir -p $out/share/licenses/sshrm
    cp ${src}/LICENSE $out/share/licenses/sshrm/LICENSE
  '';

 #meta = with stdenv.lib; {
 #  description = "A tool to remove quickly all keys belonging to the specified host from a known_hosts file.";
 #  homepage = "https://github.com/aaaaadrien/sshrm";
 #  license = licenses.mit;
 #  maintainers = with maintainers; [ minegameYTB ];
 #  platforms = lib.platforms.linux;
 #};
}
