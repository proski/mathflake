{
  fetchFromGitHub,
  lib,
  ocl-icd,
  opencl-headers,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mfakto";
  version = "0.16-beta.2";

  src = fetchFromGitHub {
    owner = "primesearch";
    repo = "mfakto";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-kWJuiRkFUhV6/u6OYm4XSfR7xy/XG5ccRNeBeOnsr4k=";
  };

  patches = [ ./0001-NixOS-patch.patch ];

  buildInputs = [
    ocl-icd
    opencl-headers
  ];

  buildPhase = ''
    runHook preBuild

    make -C src

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/mfakto
    install -m755 mfakto $out/bin
    install -m755 datatypes.h tf_debug.h mfakto.ini *.cl $out/share/mfakto

    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = {
    description = "OpenCL based trial factoring program for Mersenne Primes";
    longDescription = ''
      mfakto is an application that trial factors Mersenne numbers for the
      Great Internet Mersenne Prime Search (GIMPS). mfakto utilizes OpenCL to
      run calculations on graphics processing units (GPUs). GPUs are very
      efficient at searching for factors due to their parallel nature.

      More information about trial factoring and the GIMPS project can be found
      on the GIMPS website:

      https://mersenne.org/various/math.php#trial_factoring
    '';
    homepage = "https://www.mersenneforum.org/node/11037";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    mainProgram = "mfakto";
  };
})
