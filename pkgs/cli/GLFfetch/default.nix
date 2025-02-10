{ 
  stdenvNoCC, 
  substituteAll, 
  writeScriptBin, 
  fetchFromGitHub, 
  makeWrapper, 
  fastfetch, 
  coreutils, 
  gawk,
  bash, 
  glfIcon ? "GLF"  # Paramètre pour choisir l'icône ("GLF" ou "GLFos")
}:

stdenvNoCC.mkDerivation rec {
  pname = "GLFfetch-nixos";
  version = "git-${builtins.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "minegameYTB";
    repo = pname;
    rev = "a0935f03d32acdeb108798f3fe9cfb18ce5413a1";
    sha256 = "sha256-fO+vko4Ef41jXReIhZv2BVPTkETpAslZUrdBhyvVO2w=";
  };

  outputs = [ "out" "assets" ];
  outputsToInstall = outputs;

  buildInputs = [ fastfetch bash coreutils gawk ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $assets/share/${pname}/scripts

    # Copier les icônes
    cp $src/GLF.png $assets/share/${pname}/GLF.png
    cp $src/GLFos.png $assets/share/${pname}/GLFos.png

    # Sélectionner l'icône à utiliser
    iconPath=$assets/share/${pname}/${glfIcon}.png

    if [ ! -f "$iconPath" ]; then
      echo "Warning: this icon does not exist, Use GLF or GLFos instead"
      iconPath=$assets/share/${pname}/GLF.png
    fi

    # Copier le fichier de configuration
    cp $src/challenge.jsonc $assets/share/${pname}/challenge.jsonc

    # Modifier le fichier de configuration avec l'icône choisie
    substituteInPlace $assets/share/${pname}/challenge.jsonc \
      --replace-warn @GLF-path@ "$assets/share/${pname}" \
      --replace-warn @GLFos-icon@ "$iconPath" \
      --replace-warn @shell@ "${bash}/bin/bash"

    # Copier les scripts
    if [ -d "$src/scripts" ]; then
      cp -r $src/scripts/* $assets/share/${pname}/scripts/
    fi

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
