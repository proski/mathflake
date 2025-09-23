{
  cudaPackages,
  fetchFromGitHub,
  lib,
  makeWrapper,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mfaktc";
  version = "0.24.0-beta.6";

  src = fetchFromGitHub {
    owner = "primesearch";
    repo = "mfaktc";
    rev = "${finalAttrs.version}";
    sha256 = "sha256-2v1h9mkOL9clnGaqNtEag666tdFoC50XclAuGlBadD4=";
  };

  buildInputs = [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvcc
  ];

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild

    make -C src

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/mfaktc
    install -m755 mfaktc $out/bin/mfaktc
    install -m644 src/tf_debug.h mfaktc.ini $out/share/mfaktc

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram "$out/bin/mfaktc" \
      --add-flags "-i $out/share/mfaktc/mfaktc.ini"
  '';

  enableParallelBuilding = true;

  meta = {
    description = "CUDA based trial factoring program for Mersenne Primes";
    longDescription = ''
      mfaktc is an application that trial factors Mersenne numbers for the
      Great Internet Mersenne Prime Search (GIMPS).

      More information about trial factoring and the GIMPS project can be found
      on the GIMPS website:

      https://mersenne.org/various/math.php#trial_factoring
    '';
    homepage = "https://www.mersenneforum.org/node/11037";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    mainProgram = "mfaktc";
  };
})
