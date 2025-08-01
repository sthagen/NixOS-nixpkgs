{
  fetchFromGitHub,
  ffmpeg,
  freetype,
  fribidi,
  glew,
  harfbuzz,
  lib,
  libGL,
  libGLU,
  libpng,
  makeWrapper,
  nix-update-script,
  pkg-config,
  python3,
  SDL2,
  stdenv,
  versionCheckHook,
  withoutSteam ? true,
  zlib,
}:

let
  python = python3;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "renpy";
  version = "8.3.7.25031702";

  src = fetchFromGitHub {
    owner = "renpy";
    repo = "renpy";
    tag = finalAttrs.version;
    hash = "sha256-QY6MMiagPVV+pCDM0FRD++r2fY3tD8qWmHj7fJKIxUQ=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    python.pkgs.cython
    python.pkgs.setuptools
  ];

  buildInputs = [
    ffmpeg
    freetype
    fribidi
    glew
    harfbuzz
    libGL
    libGLU
    libpng
    SDL2
    zlib
  ]
  ++ (with python.pkgs; [
    ecdsa
    future
    pefile
    pygame-sdl2
    python
    requests
    six
    tkinter
  ]);

  RENPY_DEPS_INSTALL = lib.concatStringsSep "::" (
    [
      ffmpeg.lib
      freetype
      fribidi
      glew.dev
      harfbuzz.dev
      libpng
      SDL2
      (lib.getDev SDL2)
      zlib
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      libGL
      libGLU
    ]
  );

  enableParallelBuilding = true;

  patches = [
    ./shutup-erofs-errors.patch
    ./5687.patch
  ]
  ++ lib.optional withoutSteam ./noSteam.patch;

  postPatch = ''
    cp tutorial/game/tutorial_director.rpy{m,}

    cat > renpy/vc_version.py << EOF
    version = '${finalAttrs.version}'
    official = False
    nightly = False
    # Look at https://renpy.org/latest.html for what to put.
    version_name = '64bit Sensation'
    EOF
  '';

  buildPhase = ''
    runHook preBuild
    ${python.pythonOnBuildForHost.interpreter} module/setup.py build --parallel=$NIX_BUILD_CORES
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${python.pythonOnBuildForHost.interpreter} module/setup.py install_lib -d $out/${python.sitePackages}
    mkdir -p $out/share/renpy
    cp -vr sdk-fonts gui launcher renpy the_question tutorial renpy.py $out/share/renpy

    makeWrapper ${python.interpreter} $out/bin/renpy \
      --set PYTHONPATH "$PYTHONPATH:$out/${python.sitePackages}" \
      --add-flags "$out/share/renpy/renpy.py"

    runHook postInstall
  '';

  env = {
    NIX_CFLAGS_COMPILE = "-I${python.pkgs.pygame-sdl2}/include";
  };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Visual Novel Engine";
    mainProgram = "renpy";
    homepage = "https://renpy.org/";
    changelog = "https://renpy.org/doc/html/changelog.html";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ shadowrz ];
  };
})
