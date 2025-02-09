{ stdenvNoCC, substituteAll, writeScriptBin, fetchFromGitHub, fastfetch, coreutils, gawk, makeWrapper }:

stdenvNoCC.mkDerivation rec {
  pname = "GLFfetch-nixos";
  version = "git-${builtins.substring 0 7 src.rev}";  # Dynamically generate version from Git hash

  src = fetchFromGitHub {
    owner = "minegameYTB";
    repo = pname;
    rev = "73224999309bbfe0b356507672621d138ff8deff";
    sha256 = "sha256-gbd/boOHSqK8EHD+7y1k3bAxGwsHnkXJGgzKYgBhi3A=";
  };

  outputs = [ "out" "assets" ];
  outputsToInstall = outputs;

  buildInputs = [ fastfetch coreutils ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $assets/share/${pname} $assets/share/${pname}/scripts
    
    cp $src/challenge.jsonc $assets/share/${pname}/challenge.jsonc
    cp $src/GLF.png $assets/share/${pname}/GLF.png
    cp -r $src/scripts/* $assets/share/${pname}/scripts/

    substituteInPlace $assets/share/${pname}/challenge.jsonc \
      --replace @GLF-path@ $assets/share/${pname}
    
    for script in $assets/share/${pname}/scripts/*.sh; do
      substituteInPlace "$script" --replace @GLF-path@ $assets/share/${pname} \
        --replace @coreutils@ ${coreutils} \
        --replace @gawk@ ${gawk}
      chmod +x "$script"
    done

    makeWrapper ${fastfetch}/bin/fastfetch $out/bin/GLFfetch \
      --add-flags "--config $assets/share/${pname}/challenge.jsonc \
      --prefix PATH : ${coreutils}/bin

      ### symlink GLFfetch to GLFfetch-nixos to run it directly with nix run
      ln -s $out/bin/GLFfetch $out/bin/GLFfetch-nixos
  '';
}
