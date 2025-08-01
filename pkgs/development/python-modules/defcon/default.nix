{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools-scm,
  fonttools,
  fontpens,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "defcon";
  version = "0.12.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rKhnSo9xcjr2oI8zLz7TFWug/gBZHrWv91csqtFHLQk=";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    fonttools
  ]
  ++ fonttools.optional-dependencies.ufo
  ++ fonttools.optional-dependencies.unicode;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "defcon" ];

  optional-dependencies = {
    pens = [ fontpens ];
    lxml = [ fonttools ] ++ fonttools.optional-dependencies.lxml;
  };

  meta = with lib; {
    description = "Set of UFO based objects for use in font editing applications";
    homepage = "https://github.com/robotools/defcon";
    changelog = "https://github.com/robotools/defcon/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
