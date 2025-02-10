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
  glfIcon ? "GLF"  # ### Use GLF icon or GLFos icon (to change icon)
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
    ### Create directory
    mkdir -p $out/bin $assets/share/${pname}/scripts
    cp $src/GLF.png $assets/share/${pname}/GLF.png
    cp $src/GLFos.png $assets/share/${pname}/GLFos.png

    # Set icon on a variable
    iconPath=$assets/share/${pname}/${glfIcon}.png

    cp $src/challenge.jsonc $assets/share/${pname}/challenge.jsonc

    substituteInPlace $assets/share/${pname}/challenge.jsonc \
      --replace-warn @GLF-path@ "$assets/share/${pname}" \
      --replace-warn @GLFos-icon@ "$iconPath" \
      --replace-warn @shell@ "${bash}/bin/bash"

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
