{ lib, stdenvNoCC, fetchFromGitHub }:

 stdenvNoCC.mkDerivation rec {
   repoName = "sshrm";
   pname = "sshrm";
   version = "git-0803f9";

  src = fetchFromGitHub {
    owner = "aaaaadrien";
    repo = repoName;
    rev = "0803f982130ebcceb43abe4fe84da3541856ed46";
    sha256 = "sha256-Sm9RAK6UdvL0yHfE12gIjoLfy3pZBqgRtfm20X1FWm0=";
  };

  installPhase = ''
    ### Make sshrm available to nix
    mkdir -p $out/bin
    cp ${src}/${repoName} $out/bin/${repoName}
    chmod +x $out/bin/${repoName}

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
