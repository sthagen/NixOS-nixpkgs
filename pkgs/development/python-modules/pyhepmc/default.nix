{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  setuptools,
  setuptools-scm,
  numpy,
  pybind11,
  wheel,
  pytestCheckHook,
  pythonOlder,
  graphviz,
}:

buildPythonPackage rec {
  pname = "pyhepmc";
  version = "2.14.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "pyhepmc";
    tag = "v${version}";
    hash = "sha256-yh02Z1nPGjghZYHkPBlClDEztq4VQsW3H+kuco/lBpk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    setuptools
    setuptools-scm
    wheel
  ];

  buildInputs = [ pybind11 ];

  propagatedBuildInputs = [ numpy ];

  dontUseCmakeConfigure = true;

  CMAKE_ARGS = [ "-DEXTERNAL_PYBIND11=ON" ];

  nativeCheckInputs = [
    graphviz
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyhepmc" ];

  meta = with lib; {
    description = "Easy-to-use Python bindings for HepMC3";
    homepage = "https://github.com/scikit-hep/pyhepmc";
    changelog = "https://github.com/scikit-hep/pyhepmc/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
