{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "crlfsuite";
  version = "2.5.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Nefcore";
    repo = "CRLFsuite";
    tag = "v${version}";
    sha256 = "sha256-mK20PbVGhTEjhY5L6coCzSMIrG/PHHmNq30ZoJEs6uI=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    colorama
    requests
  ];

  # No tests present
  doCheck = false;

  pythonImportsCheck = [
    "crlfsuite"
  ];

  meta = with lib; {
    description = "CRLF injection (HTTP Response Splitting) scanner";
    mainProgram = "crlfsuite";
    homepage = "https://github.com/Nefcore/CRLFsuite";
    license = licenses.mit;
    maintainers = with maintainers; [
      c0bw3b
      fab
    ];
  };
}
