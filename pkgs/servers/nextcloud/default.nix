{ lib, stdenv, fetchurl, nixosTests }:

let
  generic = {
    version, sha256,
    eol ? false, extraVulnerabilities ? []
  }: stdenv.mkDerivation rec {
    pname = "nextcloud";
    inherit version;

    src = fetchurl {
      url = "https://download.nextcloud.com/server/releases/${pname}-${version}.tar.bz2";
      inherit sha256;
    };

    passthru.tests = nixosTests.nextcloud;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/
      cp -R . $out/
      runHook postInstall
    '';

    meta = with lib; {
      description = "Sharing solution for files, calendars, contacts and more";
      homepage = "https://nextcloud.com";
      maintainers = with maintainers; [ schneefux bachp globin fpletz ma27 ];
      license = licenses.agpl3Plus;
      platforms = with platforms; unix;
      knownVulnerabilities = extraVulnerabilities
        ++ (optional eol "Nextcloud version ${version} is EOL");
    };
  };
in {
  nextcloud21 = throw ''
    Nextcloud v21 has been removed from `nixpkgs` as the support for it was dropped
    by upstream in 2022-02. Please upgrade to at least Nextcloud v22 by declaring

        services.nextcloud.package = pkgs.nextcloud22;

    in your NixOS config.

    WARNING: if you were on Nextcloud 20 on NixOS 21.11 you have to upgrade to Nextcloud 21
    first on 21.11 because Nextcloud doesn't support upgrades accross multiple major versions!
  '';

  nextcloud22 = generic {
    version = "22.2.8";
    sha256 = "061b8a118d0fa500058a04ff8476ba96d4c24cef56e5fe5e300cc7113ce13a18";
  };

  nextcloud23 = generic {
    version = "23.0.5";
    sha256 = "3cf51a795f8439e5d34f0a521d939cefafbae38450cce64c6673016984195f29";
  };

  nextcloud24 = generic {
    version = "24.0.1";
    sha256 = "d32a8f6c4722a45cb67de7018163cfafcfa22a871fbac0f623c3875fa4304e5a";
  };

  # tip: get she sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
