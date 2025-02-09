{ stdenvNoCC, substituteAll, writeScriptBin, fetchFromGitHub, fastfetch, coreutils, gawk, bash, makeWrapper }:

stdenvNoCC.mkDerivation rec {
  pname = "GLFfetch-nixos";
  version = "git-${builtins.substring 0 7 src.rev}";  ### To update version number

  src = fetchFromGitHub {
    owner = "minegameYTB";
    repo = pname;
    rev = "e050de0e8e77f0068a745a1659adb7533b43a29e";
    sha256 = "sha256-BEWPX5rUm2k/O6g6uHvSjOxCUqsUMmwXBwhMQmnBd48=";
  };

  outputs = [ "out" "assets" ];
  outputsToInstall = outputs;

  buildInputs = [ fastfetch bash coreutils gawk ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $assets/share/${pname} $assets/share/${pname}/scripts
    
    cp $src/challenge.jsonc $assets/share/${pname}/challenge.jsonc
    cp $src/GLF.png $assets/share/${pname}/GLF.png
    
    if [ -d "$src/scripts" ]; then
      cp -r $src/scripts/* $assets/share/${pname}/scripts/
    fi

    substituteInPlace $assets/share/${pname}/challenge.jsonc \
      --replace-warn @GLF-path@ "$assets/share/${pname}" \
      --replace-warn @shell@ "${bash}"

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

