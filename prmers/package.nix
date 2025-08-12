{
  curl,
  gmpxx,
  fetchFromGitHub,
  lib,
  ocl-icd,
  opencl-headers,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prmers";
  version = "4.8.08-alpha";

  src = fetchFromGitHub {
    owner = "cherubrock-seb";
    repo = "prmers";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-NH+KK6FFYJwRda+goR8ZD1hESlBkBFNgMwmzn7xJ9yc=";
  };

  buildInputs = [
    curl
    gmpxx
    ocl-icd
    opencl-headers
  ];

  PREFIX = placeholder "out";

  enableParallelBuilding = true;

  meta = {
    description = "GPU-accelerated Mersenne Primality Test";
    longDescription = ''
      PrMers is a high-performance GPU application for testing the primality
      of Mersenne numbers using the Lucas–Lehmer and PRP (Probable Prime)
      algorithms. It leverages OpenCL and Number Theoretic Transforms (NTT)
      for fast large-integer arithmetic, and is optimized for long-running
      computations.
    '';
    homepage = "https://www.mersenneforum.org/node/1074417";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "prmers";
  };
})
