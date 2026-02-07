{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "phase-cli";
  version = "1.21.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "phasehq";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nj6vSq+2pquZ5A77EG9s2IXUsmAz41xD1OkaVHrKLIA=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    keyring
    questionary
    cffi
    requests
    pynacl
    rich
    pyyaml
    toml
    python-hcl2
    botocore
  ];

  nativeCheckInputs = [
    versionCheckHook
    python3Packages.pytestCheckHook
  ];

  enabledTestPaths = [
    "tests/*.py"
  ];

  pythonRelaxDeps = true;

  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  meta = {
    description = "Securely manage and sync environment variables with Phase";
    homepage = "https://github.com/phasehq/cli";
    changelog = "https://github.com/phasehq/cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      genga898
      medv
    ];
    mainProgram = "phase";
  };
})
