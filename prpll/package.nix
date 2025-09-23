{
  fetchFromGitHub,
  lib,
  ocl-icd,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prpll";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "preda";
    repo = "gpuowl";
    rev = "v/prpll/${finalAttrs.version}";
    sha256 = "sha256-uARWaY48IdqWqiX4Z1ZZdhCNGqqVKbyFKOiILSln7ao=";
  };

  buildInputs = [
    ocl-icd
  ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace Makefile --replace-fail \
      'git describe --tags --long --dirty --always --match v/prpll/*' \
      'echo "${finalAttrs.version}"'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 build-release/prpll $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Probable Prime and Lucas-Lehmer Mersenne Primality Test";
    longDescription = ''
      PRPLL is an OpenCL (GPU) program for primality testing Mersenne numbers.
      PRPLL implements two primality tests for Mersenne numbers: PRP
      ("PRobable Prime") and LL ("Lucas-Lehmer").
    '';
    homepage = "https://www.mersenneforum.org/node/144";
    license = licenses.gpl3;
    platforms = lib.platforms.all;
    mainProgram = "prpll";
  };
})
