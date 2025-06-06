{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
}:

let
  pyjsparser = buildPythonPackage {
    pname = "pyjsparser";
    version = "2.7.1";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "PiotrDabkowski";
      repo = "pyjsparser";
      rev = "5465d037b30e334cb0997f2315ec1e451b8ad4c1";
      hash = "sha256-Hqay9/qsjUfe62U7Q79l0Yy01L2Bnj5xNs6427k3Br8=";
    };

    nativeCheckInputs = [
      pytestCheckHook
    ];

    # js2py is needed for tests but it's unmaintained and insecure
    doCheck = false;

    pythonImportsCheck = [ "pyjsparser" ];

    meta = with lib; {
      description = "Fast javascript parser (based on esprima.js)";
      homepage = "https://github.com/PiotrDabkowski/pyjsparser";
      license = licenses.mit;
      maintainers = with maintainers; [ onny ];
    };
  };
in
pyjsparser
