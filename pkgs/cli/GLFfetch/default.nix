{ stdenvNoCC, substituteAll, writeScriptBin, fetchFromGitHub, fastfetch, coreutils, gawk, makeWrapper }:

stdenvNoCC.mkDerivation rec {
  pname = "GLFfetch-nixos";
  version = "git-${builtins.substring 0 7 src.rev}";  # Génération dynamique de la version

  src = fetchFromGitHub {
    owner = "minegameYTB";
    repo = pname;
    rev = "73224999309bbfe0b356507672621d138ff8deff";
    sha256 = "sha256-gbd/boOHSqK8EHD+7y1k3bAxGwsHnkXJGgzKYgBhi3A=";
  };

  outputs = [ "out" "assets" ];
  outputsToInstall = outputs;

  buildInputs = [ fastfetch coreutils gawk ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $assets/share/${pname} $assets/share/${pname}/scripts
    
    cp $src/challenge.jsonc $assets/share/${pname}/challenge.jsonc
    cp $src/GLF.png $assets/share/${pname}/GLF.png
    
    if [ -d "$src/scripts" ]; then
      cp -r $src/scripts/* $assets/share/${pname}/scripts/
    fi

    substituteInPlace $assets/share/${pname}/challenge.jsonc \
      --replace-warn @GLF-path@ "$assets/share/${pname}"

    for script in $assets/share/${pname}/scripts/*.sh; do
      substituteInPlace "$script" \
        --replace-warn @GLF-path@ "$assets/share/${pname}" \
        --replace-warn @coreutils@ "${coreutils}" \
        --replace-warn @gawk@ "${gawk}"
      chmod +x "$script"
    done

    makeWrapper ${fastfetch}/bin/fastfetch $out/bin/GLFfetch \
      --add-flags "--config $assets/share/${pname}/challenge.jsonc" \
      --prefix PATH : ${coreutils}/bin:${gawk}/bin

    ln -s $out/bin/GLFfetch $out/bin/GLFfetch-nixos
  '';
}

