{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  cython,
  pdm-backend,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "editdistance";
  version = "0.8.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "roy-ht";
    repo = "editdistance";
    tag = "v${version}";
    hash = "sha256-Ncdg8S/UHYqJ1uFnHk9qhHMM3Lrop00woSu3PLKvuBI=";
  };

  nativeBuildInputs = [
    cython
    pdm-backend
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "editdistance" ];

  meta = with lib; {
    description = "Python implementation of the edit distance (Levenshtein distance)";
    homepage = "https://github.com/roy-ht/editdistance";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
